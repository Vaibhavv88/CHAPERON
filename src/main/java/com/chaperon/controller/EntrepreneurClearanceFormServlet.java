package com.chaperon.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

import com.chaperon.dao.DocumentDAO;
import com.chaperon.dao.impl.DocumentDAOImpl;
import com.chaperon.model.Business;
import com.chaperon.model.ClearanceApplication;
import com.chaperon.model.ClearanceApplicationMap;
import com.chaperon.model.ClearanceApplicationRequirement;
import com.chaperon.model.ClearanceType;
import com.chaperon.model.Document;
import com.chaperon.service.BusinessService;
import com.chaperon.service.ClearanceApplicationService;
import com.chaperon.service.ClearanceMapService;
import com.chaperon.service.impl.BusinessServiceImpl;
import com.chaperon.service.impl.ClearanceApplicationServiceImpl;
import com.chaperon.service.impl.ClearanceMapServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/clearances/new")
public class EntrepreneurClearanceFormServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ClearanceApplicationService clearanceService;
    private ClearanceMapService clearanceMapService;
    private BusinessService businessService;
    private DocumentDAO documentDAO;

    @Override
    public void init() throws ServletException {

        clearanceService =
                new ClearanceApplicationServiceImpl();

        clearanceMapService =
                new ClearanceMapServiceImpl();

        businessService =
                new BusinessServiceImpl();

        documentDAO =
                new DocumentDAOImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        Long userId =
                getLoggedInUserId(session);

        String userRole =
                getLoggedInUserRole(session);

        if (userId == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur-login");

            return;
        }

        if (!"ENTREPRENEUR".equalsIgnoreCase(
                userRole)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only entrepreneurs can access this page.");

            return;
        }

        try {
            Business business =
                    businessService
                            .getBusinessByUserId(userId);

            if (business == null) {

                session.setAttribute(
                        "errorMessage",
                        "Please complete your business profile first.");

                response.sendRedirect(
                        request.getContextPath()
                                + "/entrepreneur/"
                                + "business-onboarding");

                return;
            }

            List<Document> businessDocuments =
                    documentDAO.findByBusinessId(
                            business.getBusinessId());

            Long clearanceTypeId =
                    parseLong(
                            request.getParameter(
                                    "typeId"));

            Long applicationId =
                    parseLong(
                            request.getParameter(
                                    "id"));

            ClearanceApplication clearanceApplication =
                    null;

            ClearanceApplicationMap clearanceMap =
                    null;

            List<ClearanceApplicationRequirement>
                    applicationChecklist =
                    Collections.emptyList();

            int readinessPercentage = 0;

            /*
             * Existing draft edit mode.
             */
            if (applicationId != null) {

                clearanceApplication =
                        clearanceService
                                .getApplicationForUser(
                                        applicationId,
                                        userId);

                if (clearanceApplication == null) {

                    response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Clearance application not found.");

                    return;
                }

                if (!"DRAFT".equalsIgnoreCase(
                        clearanceApplication
                                .getCurrentStatus())) {

                    session.setAttribute(
                            "errorMessage",
                            "Only draft applications can be edited.");

                    response.sendRedirect(
                            request.getContextPath()
                                    + "/entrepreneur/clearances");

                    return;
                }

                clearanceTypeId =
                        clearanceApplication
                                .getClearanceTypeId();

                clearanceMap =
                        clearanceMapService
                                .getMapByApplicationId(
                                        applicationId);

                applicationChecklist =
                        clearanceService
                                .getApplicationChecklist(
                                        applicationId);

                readinessPercentage =
                        clearanceService
                                .calculateReadinessPercentage(
                                        applicationId);
            }

            if (clearanceTypeId == null) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Clearance type is required.");

                return;
            }

            ClearanceType selectedClearanceType =
                    findActiveClearanceType(
                            clearanceTypeId);

            if (selectedClearanceType == null) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Invalid or inactive clearance type.");

                return;
            }

            request.setAttribute(
                    "business",
                    business);

            request.setAttribute(
                    "selectedClearanceType",
                    selectedClearanceType);

            request.setAttribute(
                    "clearanceApplication",
                    clearanceApplication);

            request.setAttribute(
                    "clearanceMap",
                    clearanceMap);

            request.setAttribute(
                    "applicationChecklist",
                    applicationChecklist);

            request.setAttribute(
                    "readinessPercentage",
                    readinessPercentage);

            request.setAttribute(
                    "businessDocuments",
                    businessDocuments);

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/"
                            + "clearance-form.jsp")
                    .forward(request, response);

        } catch (Exception exception) {

            exception.printStackTrace();

            throw new ServletException(
                    "Unable to open clearance application form.",
                    exception);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session =
                request.getSession(false);

        Long userId =
                getLoggedInUserId(session);

        String userRole =
                getLoggedInUserRole(session);

        if (userId == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur-login");

            return;
        }

        if (!"ENTREPRENEUR".equalsIgnoreCase(
                userRole)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only entrepreneurs can access this page.");

            return;
        }

        Business business = null;

        try {
            business =
                    businessService
                            .getBusinessByUserId(userId);

            if (business == null) {

                session.setAttribute(
                        "errorMessage",
                        "Please complete your business profile first.");

                response.sendRedirect(
                        request.getContextPath()
                                + "/entrepreneur/"
                                + "business-onboarding");

                return;
            }

            Long applicationId =
                    parseLong(
                            request.getParameter(
                                    "applicationId"));

            Long clearanceTypeId =
                    parseLong(
                            request.getParameter(
                                    "clearanceTypeId"));

            if (clearanceTypeId == null) {

                throw new IllegalArgumentException(
                        "Clearance type is required.");
            }

            ClearanceType selectedClearanceType =
                    findActiveClearanceType(
                            clearanceTypeId);

            if (selectedClearanceType == null) {

                throw new IllegalArgumentException(
                        "Invalid or inactive clearance type.");
            }

            ClearanceApplication clearanceApplication;

            /*
             * Update existing draft.
             */
            if (applicationId != null) {

                clearanceApplication =
                        clearanceService
                                .getApplicationForUser(
                                        applicationId,
                                        userId);

                if (clearanceApplication == null) {

                    response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Clearance application not found.");

                    return;
                }

                if (!"DRAFT".equalsIgnoreCase(
                        clearanceApplication
                                .getCurrentStatus())) {

                    throw new IllegalStateException(
                            "Only draft applications can be edited.");
                }

            } else {

                /*
                 * Create new draft.
                 */
                clearanceApplication =
                        new ClearanceApplication();

                clearanceApplication.setUserId(
                        userId);

                clearanceApplication.setBusinessId(
                        business.getBusinessId());

                clearanceApplication.setClearanceTypeId(
                        clearanceTypeId);

                clearanceApplication.setCurrentStatus(
                        "DRAFT");
            }

            clearanceApplication.setProjectTitle(
                    clean(
                            request.getParameter(
                                    "projectTitle")));

            clearanceApplication.setProjectDescription(
                    clean(
                            request.getParameter(
                                    "projectDescription")));

            clearanceApplication.setState(
                    clean(
                            request.getParameter(
                                    "state")));

            clearanceApplication.setDistrict(
                    clean(
                            request.getParameter(
                                    "district")));

            clearanceApplication.setLocationAddress(
                    clean(
                            request.getParameter(
                                    "locationAddress")));

            clearanceApplication.setLatitude(
                    parseBigDecimal(
                            request.getParameter(
                                    "latitude")));

            clearanceApplication.setLongitude(
                    parseBigDecimal(
                            request.getParameter(
                                    "longitude")));

            clearanceApplication.setProjectAreaHectares(
                    parseBigDecimal(
                            request.getParameter(
                                    "projectAreaHectares")));

            boolean declarationAccepted =
                    request.getParameter(
                            "applicantDeclaration") != null;

            clearanceApplication.setApplicantDeclaration(
                    declarationAccepted);

            validateApplication(
                    clearanceApplication);

            /*
             * Save application.
             */
            long savedApplicationId;

            if (applicationId == null) {

                savedApplicationId =
                        clearanceService.createDraft(
                                clearanceApplication);

            } else {

                boolean updated =
                        clearanceService.updateDraft(
                                clearanceApplication);

                if (!updated) {

                    throw new IllegalStateException(
                            "Clearance application could not be updated.");
                }

                savedApplicationId =
                        applicationId;
            }

            /*
             * Save or update map.
             */
            ClearanceApplicationMap clearanceMap =
                    new ClearanceApplicationMap();

            clearanceMap.setClearanceApplicationId(
                    savedApplicationId);

            clearanceMap.setMapName(
                    "Project Boundary");

            clearanceMap.setMapType(
                    "PROJECT_BOUNDARY");

            clearanceMap.setBoundarySource(
                    "DRAWN_ON_MAP");

            clearanceMap.setGeojsonData(
                    clean(
                            request.getParameter(
                                    "boundaryGeoJson")));

            clearanceMap.setCentreLatitude(
                    clearanceApplication
                            .getLatitude());

            clearanceMap.setCentreLongitude(
                    clearanceApplication
                            .getLongitude());

            clearanceMap.setCalculatedAreaHectares(
                    clearanceApplication
                            .getProjectAreaHectares());

            clearanceMap.setValidationStatus(
                    "PENDING");

            clearanceMap.setValidationMessage(
                    "Project map submitted by entrepreneur.");

            clearanceMap.setUploadedByUserId(
                    userId);

            clearanceMapService.saveOrUpdateMap(
                    clearanceMap);

            session.setAttribute(
                    "successMessage",
                    applicationId == null
                            ? "Application and project map saved successfully."
                            : "Application and project map updated successfully.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur/clearances/new?id="
                            + savedApplicationId);

        } catch (Exception exception) {

            exception.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    exception.getMessage());

            preparePageAfterError(
                    request,
                    business,
                    userId);

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/"
                            + "clearance-form.jsp")
                    .forward(request, response);
        }
    }

    private void preparePageAfterError(
            HttpServletRequest request,
            Business business,
            Long userId) {

        try {
            Long clearanceTypeId =
                    parseLong(
                            request.getParameter(
                                    "clearanceTypeId"));

            Long applicationId =
                    parseLong(
                            request.getParameter(
                                    "applicationId"));

            request.setAttribute(
                    "business",
                    business);

            request.setAttribute(
                    "selectedClearanceType",
                    findActiveClearanceType(
                            clearanceTypeId));

            request.setAttribute(
                    "applicationChecklist",
                    Collections.emptyList());

            request.setAttribute(
                    "readinessPercentage",
                    0);

            if (business != null) {

                List<Document> businessDocuments =
                        documentDAO.findByBusinessId(
                                business.getBusinessId());

                request.setAttribute(
                        "businessDocuments",
                        businessDocuments);

            } else {

                request.setAttribute(
                        "businessDocuments",
                        Collections.emptyList());
            }

            if (applicationId != null
                    && userId != null) {

                ClearanceApplication application =
                        clearanceService
                                .getApplicationForUser(
                                        applicationId,
                                        userId);

                request.setAttribute(
                        "clearanceApplication",
                        application);

                ClearanceApplicationMap map =
                        clearanceMapService
                                .getMapByApplicationId(
                                        applicationId);

                request.setAttribute(
                        "clearanceMap",
                        map);

                List<ClearanceApplicationRequirement>
                        checklist =
                        clearanceService
                                .getApplicationChecklist(
                                        applicationId);

                request.setAttribute(
                        "applicationChecklist",
                        checklist);

                int readinessPercentage =
                        clearanceService
                                .calculateReadinessPercentage(
                                        applicationId);

                request.setAttribute(
                        "readinessPercentage",
                        readinessPercentage);
            }

            request.setAttribute(
                    "formProjectTitle",
                    clean(
                            request.getParameter(
                                    "projectTitle")));

            request.setAttribute(
                    "formProjectDescription",
                    clean(
                            request.getParameter(
                                    "projectDescription")));

            request.setAttribute(
                    "formState",
                    clean(
                            request.getParameter(
                                    "state")));

            request.setAttribute(
                    "formDistrict",
                    clean(
                            request.getParameter(
                                    "district")));

            request.setAttribute(
                    "formLocationAddress",
                    clean(
                            request.getParameter(
                                    "locationAddress")));

            request.setAttribute(
                    "formLatitude",
                    clean(
                            request.getParameter(
                                    "latitude")));

            request.setAttribute(
                    "formLongitude",
                    clean(
                            request.getParameter(
                                    "longitude")));

            request.setAttribute(
                    "formProjectAreaHectares",
                    clean(
                            request.getParameter(
                                    "projectAreaHectares")));

            request.setAttribute(
                    "formBoundaryGeoJson",
                    clean(
                            request.getParameter(
                                    "boundaryGeoJson")));

        } catch (Exception exception) {

            exception.printStackTrace();
        }
    }

    private void validateApplication(
            ClearanceApplication application) {

        if (application == null) {

            throw new IllegalArgumentException(
                    "Application information is required.");
        }

        if (isBlank(
                application.getProjectTitle())) {

            throw new IllegalArgumentException(
                    "Project title is required.");
        }

        if (isBlank(application.getState())) {

            throw new IllegalArgumentException(
                    "State is required.");
        }

        if (isBlank(application.getDistrict())) {

            throw new IllegalArgumentException(
                    "District is required.");
        }

        if (isBlank(
                application.getLocationAddress())) {

            throw new IllegalArgumentException(
                    "Project location is required.");
        }

        if (application.getLatitude() == null
                || application.getLongitude() == null) {

            throw new IllegalArgumentException(
                    "Please select the project location on the map.");
        }

        BigDecimal latitude =
                application.getLatitude();

        BigDecimal longitude =
                application.getLongitude();

        if (latitude.compareTo(
                new BigDecimal("-90")) < 0
                || latitude.compareTo(
                        new BigDecimal("90")) > 0) {

            throw new IllegalArgumentException(
                    "Latitude must be between -90 and 90.");
        }

        if (longitude.compareTo(
                new BigDecimal("-180")) < 0
                || longitude.compareTo(
                        new BigDecimal("180")) > 0) {

            throw new IllegalArgumentException(
                    "Longitude must be between -180 and 180.");
        }
    }

    private ClearanceType findActiveClearanceType(
            Long clearanceTypeId)
            throws Exception {

        if (clearanceTypeId == null) {
            return null;
        }

        List<ClearanceType> clearanceTypes =
                clearanceService
                        .getActiveClearanceTypes();

        if (clearanceTypes == null) {
            return null;
        }

        for (ClearanceType clearanceType
                : clearanceTypes) {

            if (clearanceTypeId.equals(
                    clearanceType
                            .getClearanceTypeId())) {

                return clearanceType;
            }
        }

        return null;
    }

    private Long getLoggedInUserId(
            HttpSession session) {

        if (session == null) {
            return null;
        }

        Object userIdObject =
                session.getAttribute("userId");

        if (userIdObject == null) {
            return null;
        }

        if (userIdObject instanceof Number) {

            return ((Number) userIdObject)
                    .longValue();
        }

        try {
            return Long.valueOf(
                    String.valueOf(userIdObject));

        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private String getLoggedInUserRole(
            HttpSession session) {

        if (session == null) {
            return null;
        }

        Object roleObject =
                session.getAttribute("userRole");

        return roleObject == null
                ? null
                : String.valueOf(roleObject);
    }

    private Long parseLong(String value) {

        try {
            if (isBlank(value)) {
                return null;
            }

            return Long.valueOf(
                    value.trim());

        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private BigDecimal parseBigDecimal(
            String value) {

        try {
            if (isBlank(value)) {
                return null;
            }

            return new BigDecimal(
                    value.trim());

        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private String clean(String value) {

        if (value == null) {
            return null;
        }

        String cleanedValue =
                value.trim();

        return cleanedValue.isEmpty()
                ? null
                : cleanedValue;
    }

    private boolean isBlank(String value) {

        return value == null
                || value.trim().isEmpty();
    }
}