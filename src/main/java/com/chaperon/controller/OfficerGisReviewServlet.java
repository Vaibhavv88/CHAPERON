package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/officer/gis-review")
public class OfficerGisReviewServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     * ==========================================
     * APPLICATION DETAILS
     * ==========================================
     */

    private static final String FIND_APPLICATION =
            "SELECT " +
            "ca.clearance_application_id, " +
            "ca.application_number, " +
            "ca.user_id, " +
            "ca.business_id, " +
            "ca.project_title, " +
            "ca.project_description, " +
            "ca.state, " +
            "ca.district, " +
            "ca.location_address, " +
            "ca.latitude, " +
            "ca.longitude, " +
            "ca.project_area_hectares, " +
            "ca.current_status, " +
            "ca.submission_date, " +
            "ca.created_at, " +
            "ct.clearance_name, " +
            "ct.clearance_code, " +
            "u.full_name AS applicant_name, " +
            "u.email AS applicant_email, " +
            "u.mobile AS applicant_mobile, " +
            "b.business_name " +
            "FROM clearance_applications ca " +
            "JOIN clearance_types ct " +
            "ON ct.clearance_type_id = " +
            "ca.clearance_type_id " +
            "JOIN users u " +
            "ON u.user_id = ca.user_id " +
            "JOIN businesses b " +
            "ON b.business_id = ca.business_id " +
            "WHERE ca.clearance_application_id = ?";

    /*
     * ==========================================
     * SPATIAL FINDINGS
     * ==========================================
     */

    private static final String FIND_SPATIAL_FINDINGS =
            "SELECT " +
            "csa.spatial_analysis_id, " +
            "csa.layer_category, " +
            "csa.spatial_relation, " +
            "csa.feature_name, " +
            "csa.intersection_found, " +
            "csa.project_inside_feature, " +
            "csa.distance_km, " +
            "csa.intersection_area_hectares, " +
            "csa.intersection_percentage, " +
            "csa.recommendation_level, " +
            "csa.analysis_message, " +
            "csa.recommendation_reason, " +
            "csa.verification_status, " +
            "csa.verified_by_user_id, " +
            "csa.officer_remarks, " +
            "csa.analysed_at, " +
            "csa.verified_at, " +
            "gl.layer_name, " +
            "gl.layer_code " +
            "FROM clearance_spatial_analysis csa " +
            "LEFT JOIN gis_features gf " +
            "ON gf.gis_feature_id = " +
            "csa.gis_feature_id " +
            "LEFT JOIN gis_layers gl " +
            "ON gl.gis_layer_id = gf.gis_layer_id " +
            "WHERE csa.clearance_application_id = ? " +
            "ORDER BY csa.analysed_at DESC";

    /*
     * ==========================================
     * GIS RECOMMENDATIONS
     * ==========================================
     */

    private static final String FIND_RECOMMENDATIONS =
            "SELECT " +
            "cgr.gis_recommendation_id, " +
            "cgr.recommended_clearance_type_id, " +
            "cgr.recommendation_level, " +
            "cgr.recommendation_reason, " +
            "cgr.generated_from, " +
            "cgr.status, " +
            "cgr.confirmed_by_user_id, " +
            "cgr.officer_remarks, " +
            "cgr.created_at, " +
            "cgr.confirmed_at, " +
            "ct.clearance_name AS " +
            "recommended_clearance_name, " +
            "ct.clearance_code AS " +
            "recommended_clearance_code " +
            "FROM clearance_gis_recommendations cgr " +
            "JOIN clearance_types ct " +
            "ON ct.clearance_type_id = " +
            "cgr.recommended_clearance_type_id " +
            "WHERE cgr.clearance_application_id = ? " +
            "ORDER BY cgr.created_at DESC";

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        /*
         * ==========================================
         * SESSION CHECK
         * ==========================================
         */

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("userId") == null
                || !"OFFICER".equalsIgnoreCase(
                        String.valueOf(
                                session.getAttribute(
                                        "userRole"
                                )
                        )
                )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/officer-login"
            );

            return;
        }

        /*
         * ==========================================
         * APPLICATION ID VALIDATION
         * ==========================================
         */

        String applicationIdParameter =
                request.getParameter("id");

        if (applicationIdParameter == null
                || applicationIdParameter.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "GIS application ID is required."
            );

            return;
        }

        long applicationId;

        try {

            applicationId =
                    Long.parseLong(
                            applicationIdParameter
                    );

        } catch (NumberFormatException exception) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid GIS application ID."
            );

            return;
        }

        /*
         * ==========================================
         * RESPONSE DATA
         * ==========================================
         */

        Map<String, Object> gisApplication = null;

        List<Map<String, Object>> spatialFindings =
                new ArrayList<>();

        List<Map<String, Object>> gisRecommendations =
                new ArrayList<>();

        try (
            Connection connection =
                    DBConnection.getConnection()
        ) {

            /*
             * ======================================
             * LOAD APPLICATION
             * ======================================
             */

            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                FIND_APPLICATION
                        )
            ) {

                statement.setLong(
                        1,
                        applicationId
                );

                try (
                    ResultSet resultSet =
                            statement.executeQuery()
                ) {

                    if (resultSet.next()) {

                        gisApplication =
                                new HashMap<>();

                        gisApplication.put(
                                "applicationId",
                                resultSet.getLong(
                                    "clearance_application_id"
                                )
                        );

                        gisApplication.put(
                                "applicationNumber",
                                resultSet.getString(
                                    "application_number"
                                )
                        );

                        gisApplication.put(
                                "userId",
                                resultSet.getLong(
                                    "user_id"
                                )
                        );

                        gisApplication.put(
                                "businessId",
                                resultSet.getLong(
                                    "business_id"
                                )
                        );

                        gisApplication.put(
                                "projectTitle",
                                resultSet.getString(
                                    "project_title"
                                )
                        );

                        gisApplication.put(
                                "projectDescription",
                                resultSet.getString(
                                    "project_description"
                                )
                        );

                        gisApplication.put(
                                "state",
                                resultSet.getString(
                                    "state"
                                )
                        );

                        gisApplication.put(
                                "district",
                                resultSet.getString(
                                    "district"
                                )
                        );

                        gisApplication.put(
                                "locationAddress",
                                resultSet.getString(
                                    "location_address"
                                )
                        );

                        gisApplication.put(
                                "latitude",
                                resultSet.getBigDecimal(
                                    "latitude"
                                )
                        );

                        gisApplication.put(
                                "longitude",
                                resultSet.getBigDecimal(
                                    "longitude"
                                )
                        );

                        gisApplication.put(
                                "projectAreaHectares",
                                resultSet.getBigDecimal(
                                    "project_area_hectares"
                                )
                        );

                        gisApplication.put(
                                "applicationStatus",
                                resultSet.getString(
                                    "current_status"
                                )
                        );

                        gisApplication.put(
                                "submissionDate",
                                resultSet.getTimestamp(
                                    "submission_date"
                                )
                        );

                        gisApplication.put(
                                "createdAt",
                                resultSet.getTimestamp(
                                    "created_at"
                                )
                        );

                        gisApplication.put(
                                "clearanceName",
                                resultSet.getString(
                                    "clearance_name"
                                )
                        );

                        gisApplication.put(
                                "clearanceCode",
                                resultSet.getString(
                                    "clearance_code"
                                )
                        );

                        gisApplication.put(
                                "applicantName",
                                resultSet.getString(
                                    "applicant_name"
                                )
                        );

                        gisApplication.put(
                                "applicantEmail",
                                resultSet.getString(
                                    "applicant_email"
                                )
                        );

                        gisApplication.put(
                                "applicantMobile",
                                resultSet.getString(
                                    "applicant_mobile"
                                )
                        );

                        gisApplication.put(
                                "businessName",
                                resultSet.getString(
                                    "business_name"
                                )
                        );
                    }
                }
            }

            /*
             * ======================================
             * APPLICATION NOT FOUND
             * ======================================
             */

            if (gisApplication == null) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "GIS application was not found."
                );

                return;
            }

            /*
             * ======================================
             * LOAD SPATIAL FINDINGS
             * ======================================
             */

            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                FIND_SPATIAL_FINDINGS
                        )
            ) {

                statement.setLong(
                        1,
                        applicationId
                );

                try (
                    ResultSet resultSet =
                            statement.executeQuery()
                ) {

                    while (resultSet.next()) {

                        Map<String, Object> finding =
                                new HashMap<>();

                        finding.put(
                                "spatialAnalysisId",
                                resultSet.getLong(
                                    "spatial_analysis_id"
                                )
                        );

                        finding.put(
                                "layerCategory",
                                resultSet.getString(
                                    "layer_category"
                                )
                        );

                        finding.put(
                                "spatialRelation",
                                resultSet.getString(
                                    "spatial_relation"
                                )
                        );

                        finding.put(
                                "featureName",
                                resultSet.getString(
                                    "feature_name"
                                )
                        );

                        finding.put(
                                "intersectionFound",
                                resultSet.getBoolean(
                                    "intersection_found"
                                )
                        );

                        finding.put(
                                "projectInsideFeature",
                                resultSet.getBoolean(
                                    "project_inside_feature"
                                )
                        );

                        finding.put(
                                "distanceKm",
                                resultSet.getBigDecimal(
                                    "distance_km"
                                )
                        );

                        finding.put(
                                "intersectionAreaHectares",
                                resultSet.getBigDecimal(
                                    "intersection_area_hectares"
                                )
                        );

                        finding.put(
                                "intersectionPercentage",
                                resultSet.getBigDecimal(
                                    "intersection_percentage"
                                )
                        );

                        finding.put(
                                "recommendationLevel",
                                resultSet.getString(
                                    "recommendation_level"
                                )
                        );

                        finding.put(
                                "analysisMessage",
                                resultSet.getString(
                                    "analysis_message"
                                )
                        );

                        finding.put(
                                "recommendationReason",
                                resultSet.getString(
                                    "recommendation_reason"
                                )
                        );

                        finding.put(
                                "verificationStatus",
                                resultSet.getString(
                                    "verification_status"
                                )
                        );

                        finding.put(
                                "officerRemarks",
                                resultSet.getString(
                                    "officer_remarks"
                                )
                        );

                        finding.put(
                                "analysedAt",
                                resultSet.getTimestamp(
                                    "analysed_at"
                                )
                        );

                        finding.put(
                                "verifiedAt",
                                resultSet.getTimestamp(
                                    "verified_at"
                                )
                        );

                        finding.put(
                                "layerName",
                                resultSet.getString(
                                    "layer_name"
                                )
                        );

                        finding.put(
                                "layerCode",
                                resultSet.getString(
                                    "layer_code"
                                )
                        );

                        spatialFindings.add(finding);
                    }
                }
            }

            /*
             * ======================================
             * LOAD GIS RECOMMENDATIONS
             * ======================================
             */

            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                FIND_RECOMMENDATIONS
                        )
            ) {

                statement.setLong(
                        1,
                        applicationId
                );

                try (
                    ResultSet resultSet =
                            statement.executeQuery()
                ) {

                    while (resultSet.next()) {

                        Map<String, Object> recommendation =
                                new HashMap<>();

                        recommendation.put(
                                "recommendationId",
                                resultSet.getLong(
                                    "gis_recommendation_id"
                                )
                        );

                        recommendation.put(
                                "recommendedClearanceTypeId",
                                resultSet.getLong(
                                    "recommended_clearance_type_id"
                                )
                        );

                        recommendation.put(
                                "recommendationLevel",
                                resultSet.getString(
                                    "recommendation_level"
                                )
                        );

                        recommendation.put(
                                "recommendationReason",
                                resultSet.getString(
                                    "recommendation_reason"
                                )
                        );

                        recommendation.put(
                                "generatedFrom",
                                resultSet.getString(
                                    "generated_from"
                                )
                        );

                        recommendation.put(
                                "status",
                                resultSet.getString(
                                    "status"
                                )
                        );

                        recommendation.put(
                                "officerRemarks",
                                resultSet.getString(
                                    "officer_remarks"
                                )
                        );

                        recommendation.put(
                                "createdAt",
                                resultSet.getTimestamp(
                                    "created_at"
                                )
                        );

                        recommendation.put(
                                "confirmedAt",
                                resultSet.getTimestamp(
                                    "confirmed_at"
                                )
                        );

                        recommendation.put(
                                "clearanceName",
                                resultSet.getString(
                                    "recommended_clearance_name"
                                )
                        );

                        recommendation.put(
                                "clearanceCode",
                                resultSet.getString(
                                    "recommended_clearance_code"
                                )
                        );

                        gisRecommendations.add(
                                recommendation
                        );
                    }
                }
            }

            /*
             * ==========================================
             * FORWARD DATA TO JSP
             * ==========================================
             */

            request.setAttribute(
                    "gisApplication",
                    gisApplication
            );

            request.setAttribute(
                    "spatialFindings",
                    spatialFindings
            );

            request.setAttribute(
                    "gisRecommendations",
                    gisRecommendations
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/officer/"
                    + "officer-gis-review.jsp"
            ).forward(request, response);

        } catch (Exception exception) {

            exception.printStackTrace();

            throw new ServletException(
                    "Unable to load GIS review details.",
                    exception
            );
        }
    }
}