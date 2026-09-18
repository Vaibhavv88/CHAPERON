package com.chaperon.controller;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/gis-recommendations")
public class EntrepreneurGisRecommendationsServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String FIND_RECOMMENDATIONS =

            "SELECT " +

            "cgr.gis_recommendation_id, " +
            "cgr.clearance_application_id, " +
            "cgr.recommended_clearance_type_id, " +
            "cgr.recommendation_level, " +
            "cgr.recommendation_reason, " +
            "cgr.generated_from, " +
            "cgr.status AS recommendation_status, " +
            "cgr.officer_remarks, " +
            "cgr.created_at, " +
            "cgr.confirmed_at, " +

            "ca.application_number, " +
            "ca.project_title, " +
            "ca.project_description, " +
            "ca.state, " +
            "ca.district, " +
            "ca.location_address, " +
            "ca.project_area_hectares, " +
            "ca.current_status AS application_status, " +

            "ct.clearance_name, " +
            "ct.clearance_code, " +
            "ct.description AS clearance_description, " +

            "csa.spatial_relation, " +
            "csa.feature_name, " +
            "csa.distance_km, " +
            "csa.intersection_area_hectares, " +
            "csa.intersection_percentage, " +
            "csa.verification_status " +

            "FROM clearance_gis_recommendations cgr " +

            "JOIN clearance_applications ca " +
            "ON ca.clearance_application_id = " +
            "cgr.clearance_application_id " +

            "JOIN clearance_types ct " +
            "ON ct.clearance_type_id = " +
            "cgr.recommended_clearance_type_id " +

            "LEFT JOIN clearance_spatial_analysis csa " +
            "ON csa.clearance_application_id = " +
            "ca.clearance_application_id " +

            "WHERE ca.user_id = ? " +

            "AND cgr.status = 'OFFICER_CONFIRMED' " +
            "AND csa.verification_status = 'VERIFIED' " +

            "ORDER BY cgr.confirmed_at DESC, " +
            "cgr.created_at DESC";

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        /*
         * ==========================================
         * LOGIN CHECK
         * ==========================================
         */

        if (session == null
                || session.getAttribute("userId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }

        /*
         * ==========================================
         * ENTREPRENEUR ROLE CHECK
         * ==========================================
         */

        Object roleObject =
                session.getAttribute("userRole");

        if (roleObject == null
                || !"ENTREPRENEUR".equalsIgnoreCase(
                        roleObject.toString()
                )) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Entrepreneur access is required."
            );

            return;
        }

        long userId =
                ((Number) session.getAttribute(
                        "userId"
                )).longValue();

        List<Map<String, Object>>
                gisRecommendations =
                new ArrayList<>();

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            FIND_RECOMMENDATIONS
                    )
        ) {

            statement.setLong(1, userId);

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    Map<String, Object> recommendation =
                            new LinkedHashMap<>();

                    recommendation.put(
                            "gisRecommendationId",
                            resultSet.getLong(
                                    "gis_recommendation_id"
                            )
                    );

                    recommendation.put(
                            "applicationId",
                            resultSet.getLong(
                                    "clearance_application_id"
                            )
                    );

                    recommendation.put(
                            "recommendedClearanceTypeId",
                            resultSet.getLong(
                                    "recommended_clearance_type_id"
                            )
                    );

                    recommendation.put(
                            "applicationNumber",
                            resultSet.getString(
                                    "application_number"
                            )
                    );

                    recommendation.put(
                            "projectTitle",
                            resultSet.getString(
                                    "project_title"
                            )
                    );

                    recommendation.put(
                            "projectDescription",
                            resultSet.getString(
                                    "project_description"
                            )
                    );

                    recommendation.put(
                            "state",
                            resultSet.getString("state")
                    );

                    recommendation.put(
                            "district",
                            resultSet.getString("district")
                    );

                    recommendation.put(
                            "locationAddress",
                            resultSet.getString(
                                    "location_address"
                            )
                    );

                    recommendation.put(
                            "projectAreaHectares",
                            resultSet.getBigDecimal(
                                    "project_area_hectares"
                            )
                    );

                    recommendation.put(
                            "applicationStatus",
                            resultSet.getString(
                                    "application_status"
                            )
                    );

                    recommendation.put(
                            "clearanceName",
                            resultSet.getString(
                                    "clearance_name"
                            )
                    );

                    recommendation.put(
                            "clearanceCode",
                            resultSet.getString(
                                    "clearance_code"
                            )
                    );

                    recommendation.put(
                            "clearanceDescription",
                            resultSet.getString(
                                    "clearance_description"
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
                            "recommendationStatus",
                            resultSet.getString(
                                    "recommendation_status"
                            )
                    );

                    recommendation.put(
                            "officerRemarks",
                            resultSet.getString(
                                    "officer_remarks"
                            )
                    );

                    recommendation.put(
                            "spatialRelation",
                            resultSet.getString(
                                    "spatial_relation"
                            )
                    );

                    recommendation.put(
                            "featureName",
                            resultSet.getString(
                                    "feature_name"
                            )
                    );

                    recommendation.put(
                            "distanceKm",
                            resultSet.getBigDecimal(
                                    "distance_km"
                            )
                    );

                    recommendation.put(
                            "intersectionAreaHectares",
                            resultSet.getBigDecimal(
                                    "intersection_area_hectares"
                            )
                    );

                    recommendation.put(
                            "intersectionPercentage",
                            resultSet.getBigDecimal(
                                    "intersection_percentage"
                            )
                    );

                    recommendation.put(
                            "verificationStatus",
                            resultSet.getString(
                                    "verification_status"
                            )
                    );

                    recommendation.put(
                            "confirmedAt",
                            resultSet.getTimestamp(
                                    "confirmed_at"
                            )
                    );

                    gisRecommendations.add(
                            recommendation
                    );
                }
            }

            request.setAttribute(
                    "gisRecommendations",
                    gisRecommendations
            );

            request.setAttribute(
                    "confirmedRecommendationCount",
                    gisRecommendations.size()
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/"
                    + "gis-recommendations.jsp"
            ).forward(request, response);

        } catch (Exception exception) {

            exception.printStackTrace();

            throw new ServletException(
                    "Unable to load verified GIS recommendations.",
                    exception
            );
        }
    }
}