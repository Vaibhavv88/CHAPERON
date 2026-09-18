package com.chaperon.controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.Locale;

import com.chaperon.dao.GisLayerDAO;
import com.chaperon.dao.impl.GisLayerDAOImpl;
import com.chaperon.model.GisFeature;
import com.chaperon.model.GisLayer;
import com.chaperon.service.GeoJsonImportService;
import com.chaperon.service.GeoJsonImportService.ImportResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/admin/gis-layers")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 50L * 1024L * 1024L,
        maxRequestSize = 55L * 1024L * 1024L
)
public class AdminGisLayerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private GisLayerDAO gisLayerDAO;
    private GeoJsonImportService geoJsonImportService;

    @Override
    public void init() throws ServletException {
        gisLayerDAO = new GisLayerDAOImpl();
        geoJsonImportService = new GeoJsonImportService(gisLayerDAO);
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session = getAdminSession(request);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/admin-login"
            );
            return;
        }

        try {
            List<GisLayer> layers = gisLayerDAO.findAllLayers();
            request.setAttribute("gisLayers", layers);

            String selectedLayerIdValue =
                    clean(request.getParameter("layerId"));

            if (selectedLayerIdValue != null) {
                Long selectedLayerId = parseLong(selectedLayerIdValue);

                if (selectedLayerId != null) {
                    GisLayer selectedLayer =
                            gisLayerDAO.findLayerById(selectedLayerId);

                    if (selectedLayer != null) {
                        List<GisFeature> features =
                                gisLayerDAO.findFeaturesByLayerId(
                                        selectedLayerId
                                );

                        request.setAttribute(
                                "selectedLayer",
                                selectedLayer
                        );

                        request.setAttribute(
                                "selectedLayerFeatures",
                                features
                        );
                    }
                }
            }

            applyMessage(request);

            request.getRequestDispatcher(
                    "/WEB-INF/views/admin/gis-layers.jsp"
            ).forward(request, response);

        } catch (SQLException exception) {
            throw new ServletException(
                    "Unable to load GIS layers.",
                    exception
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session = getAdminSession(request);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/admin-login"
            );
            return;
        }

        request.setCharacterEncoding(StandardCharsets.UTF_8.name());

        String action = clean(request.getParameter("action"));

        if (action == null) {
            action = "upload";
        }

        try {
            switch (action) {

                case "upload":
                    uploadLayer(request, response, session);
                    break;

                case "toggle-layer":
                    toggleLayer(request, response);
                    break;

                case "toggle-feature":
                    toggleFeature(request, response);
                    break;

                default:
                    redirectError(
                            request,
                            response,
                            "invalid-action"
                    );
                    break;
            }

        } catch (IllegalArgumentException exception) {
            redirectError(
                    request,
                    response,
                    "invalid-geojson"
            );

        } catch (SQLException exception) {
            throw new ServletException(
                    "GIS database operation failed.",
                    exception
            );
        }
    }

    private void uploadLayer(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session
    ) throws SQLException, IOException, ServletException {

        String layerCode = normalizeCode(
                request.getParameter("layerCode")
        );

        String layerName = clean(
                request.getParameter("layerName")
        );

        String layerCategory = normalizeCode(
                request.getParameter("layerCategory")
        );

        String description = clean(
                request.getParameter("description")
        );

        String dataSource = clean(
                request.getParameter("dataSource")
        );

        String sourceAuthority = clean(
                request.getParameter("sourceAuthority")
        );

        String sourceVersion = clean(
                request.getParameter("sourceVersion")
        );

        String sourceDateValue = clean(
                request.getParameter("sourceDate")
        );

        String stateName = clean(
                request.getParameter("stateName")
        );

        String districtName = clean(
                request.getParameter("districtName")
        );

        boolean activateAfterImport =
                "true".equalsIgnoreCase(
                        request.getParameter("active")
                )
                || "1".equals(
                        request.getParameter("active")
                )
                || "on".equalsIgnoreCase(
                        request.getParameter("active")
                );

        Long adminUserId = getSessionUserId(session);

        if (adminUserId == null) {
            response.sendRedirect(
                    request.getContextPath() + "/admin-login"
            );
            return;
        }

        if (layerCode == null
                || layerName == null
                || layerCategory == null
                || dataSource == null
                || sourceAuthority == null) {

            redirectError(
                    request,
                    response,
                    "missing-fields"
            );
            return;
        }

        if (!layerCode.matches("^[A-Z0-9][A-Z0-9_]{0,119}$")) {
            redirectError(
                    request,
                    response,
                    "invalid-layer-code"
            );
            return;
        }

        if (gisLayerDAO.layerCodeExists(layerCode)) {
            redirectError(
                    request,
                    response,
                    "duplicate-layer-code"
            );
            return;
        }

        Part geoJsonPart = request.getPart("geoJsonFile");

        if (geoJsonPart == null || geoJsonPart.getSize() <= 0) {
            redirectError(
                    request,
                    response,
                    "file-required"
            );
            return;
        }

        String submittedFileName = clean(
                geoJsonPart.getSubmittedFileName()
        );

        if (!isGeoJsonFile(submittedFileName)) {
            redirectError(
                    request,
                    response,
                    "invalid-file-type"
            );
            return;
        }

        String geoJson = new String(
                geoJsonPart.getInputStream().readAllBytes(),
                StandardCharsets.UTF_8
        );

        if (geoJson.isBlank()) {
            redirectError(
                    request,
                    response,
                    "empty-file"
            );
            return;
        }

        Date sourceDate = null;

        if (sourceDateValue != null) {
            try {
                sourceDate = Date.valueOf(sourceDateValue);
            } catch (IllegalArgumentException exception) {
                redirectError(
                        request,
                        response,
                        "invalid-source-date"
                );
                return;
            }
        }

        GisLayer layer = new GisLayer();

        layer.setLayerCode(layerCode);
        layer.setLayerName(layerName);
        layer.setLayerCategory(layerCategory);
        layer.setDescription(description);
        layer.setDataSource(dataSource);
        layer.setSourceAuthority(sourceAuthority);
        layer.setSourceVersion(sourceVersion);
        layer.setSourceDate(sourceDate);
        layer.setStateName(stateName);
        layer.setDistrictName(districtName);

        /*
         * GeoJSON coordinates must be WGS84 longitude/latitude.
         */
        layer.setCoordinateSystem("EPSG:4326");

        /*
         * Keep layer inactive until every feature is imported.
         * This prevents incomplete GIS data from being used.
         */
        layer.setActive(false);
        layer.setUploadedByUserId(adminUserId);

        long layerId = gisLayerDAO.saveLayer(layer);

        if (layerId <= 0) {
            redirectError(
                    request,
                    response,
                    "layer-save-failed"
            );
            return;
        }

        try {
            ImportResult importResult =
                    geoJsonImportService.importGeoJson(
                            layerId,
                            geoJson,
                            stateName,
                            districtName
                    );

            gisLayerDAO.updateLayerStatus(
                    layerId,
                    activateAfterImport
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/gis-layers"
                    + "?layerId=" + layerId
                    + "&success=uploaded"
                    + "&imported="
                    + importResult.getImportedCount()
            );

        } catch (IllegalArgumentException | SQLException exception) {

            /*
             * The metadata row remains inactive so invalid or partially
             * imported GIS data cannot affect clearance recommendations.
             */
            try {
                gisLayerDAO.updateLayerStatus(layerId, false);
            } catch (SQLException ignored) {
                // Preserve original import exception.
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/gis-layers"
                    + "?layerId=" + layerId
                    + "&error=import-failed"
            );
        }
    }

    private void toggleLayer(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws SQLException, IOException {

        Long layerId = parseLong(
                request.getParameter("layerId")
        );

        Boolean active = parseBoolean(
                request.getParameter("active")
        );

        if (layerId == null || active == null) {
            redirectError(
                    request,
                    response,
                    "invalid-layer"
            );
            return;
        }

        boolean updated = gisLayerDAO.updateLayerStatus(
                layerId,
                active
        );

        if (!updated) {
            redirectError(
                    request,
                    response,
                    "layer-update-failed"
            );
            return;
        }

        response.sendRedirect(
                request.getContextPath()
                + "/admin/gis-layers"
                + "?layerId=" + layerId
                + "&success=layer-status-updated"
        );
    }

    private void toggleFeature(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws SQLException, IOException {

        Long featureId = parseLong(
                request.getParameter("featureId")
        );

        Long layerId = parseLong(
                request.getParameter("layerId")
        );

        Boolean active = parseBoolean(
                request.getParameter("active")
        );

        if (featureId == null
                || layerId == null
                || active == null) {

            redirectError(
                    request,
                    response,
                    "invalid-feature"
            );
            return;
        }

        boolean updated = gisLayerDAO.updateFeatureStatus(
                featureId,
                active
        );

        if (!updated) {
            redirectError(
                    request,
                    response,
                    "feature-update-failed"
            );
            return;
        }

        response.sendRedirect(
                request.getContextPath()
                + "/admin/gis-layers"
                + "?layerId=" + layerId
                + "&success=feature-status-updated"
        );
    }

    private HttpSession getAdminSession(
            HttpServletRequest request
    ) {

        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        Object userId = session.getAttribute("userId");
        Object roleValue = session.getAttribute("userRole");

        if (userId == null || roleValue == null) {
            return null;
        }

        String role = String.valueOf(roleValue)
                .trim()
                .toUpperCase(Locale.ROOT);

        if (!"ADMIN".equals(role)
                && !"SUPER_ADMIN".equals(role)
                && !"SYSTEM_ADMIN".equals(role)) {
            return null;
        }

        return session;
    }

    private Long getSessionUserId(HttpSession session) {

        Object value = session.getAttribute("userId");

        if (value == null) {
            return null;
        }

        if (value instanceof Number) {
            return ((Number) value).longValue();
        }

        return parseLong(String.valueOf(value));
    }

    private boolean isGeoJsonFile(String fileName) {

        if (fileName == null) {
            return false;
        }

        String lowerName = fileName.toLowerCase(Locale.ROOT);

        return lowerName.endsWith(".geojson")
                || lowerName.endsWith(".json");
    }

    private String normalizeCode(String value) {

        String cleaned = clean(value);

        if (cleaned == null) {
            return null;
        }

        return cleaned
                .toUpperCase(Locale.ROOT)
                .replaceAll("[^A-Z0-9]+", "_")
                .replaceAll("^_+|_+$", "");
    }

    private String clean(String value) {

        if (value == null) {
            return null;
        }

        String cleaned = value.trim();

        return cleaned.isEmpty() ? null : cleaned;
    }

    private Long parseLong(String value) {

        String cleaned = clean(value);

        if (cleaned == null) {
            return null;
        }

        try {
            long parsed = Long.parseLong(cleaned);
            return parsed > 0 ? parsed : null;
        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private Boolean parseBoolean(String value) {

        String cleaned = clean(value);

        if (cleaned == null) {
            return null;
        }

        if ("true".equalsIgnoreCase(cleaned)
                || "1".equals(cleaned)
                || "on".equalsIgnoreCase(cleaned)) {
            return true;
        }

        if ("false".equalsIgnoreCase(cleaned)
                || "0".equals(cleaned)
                || "off".equalsIgnoreCase(cleaned)) {
            return false;
        }

        return null;
    }

    private void applyMessage(HttpServletRequest request) {

        String success = clean(request.getParameter("success"));
        String error = clean(request.getParameter("error"));

        if ("uploaded".equals(success)) {
            String imported = clean(
                    request.getParameter("imported")
            );

            request.setAttribute(
                    "successMessage",
                    (imported == null ? "0" : imported)
                    + " GIS features imported successfully."
            );

        } else if ("layer-status-updated".equals(success)) {
            request.setAttribute(
                    "successMessage",
                    "GIS layer status updated successfully."
            );

        } else if ("feature-status-updated".equals(success)) {
            request.setAttribute(
                    "successMessage",
                    "GIS feature status updated successfully."
            );
        }

        if ("missing-fields".equals(error)) {
            request.setAttribute(
                    "errorMessage",
                    "Please complete all mandatory layer details."
            );

        } else if ("invalid-layer-code".equals(error)) {
            request.setAttribute(
                    "errorMessage",
                    "Layer code is invalid."
            );

        } else if ("duplicate-layer-code".equals(error)) {
            request.setAttribute(
                    "errorMessage",
                    "A GIS layer with this code already exists."
            );

        } else if ("file-required".equals(error)) {
            request.setAttribute(
                    "errorMessage",
                    "Please select an official GeoJSON file."
            );

        } else if ("invalid-file-type".equals(error)) {
            request.setAttribute(
                    "errorMessage",
                    "Only .geojson and .json files are supported."
            );

        } else if ("empty-file".equals(error)) {
            request.setAttribute(
                    "errorMessage",
                    "The selected GeoJSON file is empty."
            );

        } else if ("invalid-source-date".equals(error)) {
            request.setAttribute(
                    "errorMessage",
                    "The source publication date is invalid."
            );

        } else if ("layer-save-failed".equals(error)) {
            request.setAttribute(
                    "errorMessage",
                    "GIS layer metadata could not be saved."
            );

        } else if ("import-failed".equals(error)
                || "invalid-geojson".equals(error)) {
            request.setAttribute(
                    "errorMessage",
                    "GeoJSON import failed. Use valid Polygon or "
                    + "MultiPolygon data in EPSG:4326 format."
            );

        } else if ("invalid-layer".equals(error)) {
            request.setAttribute(
                    "errorMessage",
                    "Invalid GIS layer request."
            );

        } else if ("invalid-feature".equals(error)) {
            request.setAttribute(
                    "errorMessage",
                    "Invalid GIS feature request."
            );

        } else if ("layer-update-failed".equals(error)) {
            request.setAttribute(
                    "errorMessage",
                    "GIS layer status could not be updated."
            );

        } else if ("feature-update-failed".equals(error)) {
            request.setAttribute(
                    "errorMessage",
                    "GIS feature status could not be updated."
            );

        } else if ("invalid-action".equals(error)) {
            request.setAttribute(
                    "errorMessage",
                    "Invalid GIS management action."
            );
        }
    }

    private void redirectError(
            HttpServletRequest request,
            HttpServletResponse response,
            String errorCode
    ) throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/gis-layers"
                + "?error=" + errorCode
        );
    }
}