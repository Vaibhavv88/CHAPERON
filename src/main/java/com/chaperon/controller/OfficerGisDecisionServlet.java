package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/officer/gis-decision")
public class OfficerGisDecisionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     * ==========================================
     * UPDATE SPATIAL ANALYSIS
     * ==========================================
     */

    private static final String UPDATE_SPATIAL_ANALYSIS =
            "UPDATE clearance_spatial_analysis " +
            "SET verification_status = ?, " +
            "verified_by_user_id = ?, " +
            "officer_remarks = ?, " +
            "verified_at = NOW() " +
            "WHERE clearance_application_id = ?";

    /*
     * ==========================================
     * UPDATE GIS RECOMMENDATION
     * ==========================================
     */

    private static final String UPDATE_GIS_RECOMMENDATION =
            "UPDATE clearance_gis_recommendations " +
            "SET status = ?, " +
            "confirmed_by_user_id = ?, " +
            "officer_remarks = ?, " +
            "confirmed_at = NOW() " +
            "WHERE clearance_application_id = ?";

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        /*
         * ==========================================
         * SESSION AND ROLE CHECK
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
         * READ REQUEST PARAMETERS
         * ==========================================
         */

        String applicationIdParameter =
                request.getParameter("applicationId");

        String decision =
                clean(
                    request.getParameter("decision")
                );

        String officerRemarks =
                clean(
                    request.getParameter(
                            "officerRemarks"
                    )
                );

        /*
         * ==========================================
         * VALIDATION
         * ==========================================
         */

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

        if (!"VERIFY".equalsIgnoreCase(decision)
                && !"REJECT".equalsIgnoreCase(
                        decision
                )) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid GIS verification decision."
            );

            return;
        }

        if (officerRemarks == null
                || officerRemarks.length() < 5) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Officer remarks must contain at least "
                    + "5 characters."
            );

            return;
        }

        if (officerRemarks.length() > 2000) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Officer remarks cannot exceed "
                    + "2000 characters."
            );

            return;
        }

        /*
         * ==========================================
         * PREPARE DATABASE STATUS VALUES
         * ==========================================
         */

        String verificationStatus;
        String recommendationStatus;
        String redirectStatus;

        if ("VERIFY".equalsIgnoreCase(decision)) {

            verificationStatus = "VERIFIED";

            recommendationStatus =
                    "OFFICER_CONFIRMED";

            redirectStatus = "verified";

        } else {

            verificationStatus = "REJECTED";

            recommendationStatus =
                    "OFFICER_REJECTED";

            redirectStatus = "rejected";
        }

        long officerUserId =
                ((Number)
                session.getAttribute("userId"))
                .longValue();

        /*
         * ==========================================
         * SAVE DECISION USING TRANSACTION
         * ==========================================
         */

        Connection connection = null;

        try {

            connection =
                    DBConnection.getConnection();

            connection.setAutoCommit(false);

            int spatialRowsUpdated;

            int recommendationRowsUpdated;

            /*
             * --------------------------------------
             * UPDATE SPATIAL FINDINGS
             * --------------------------------------
             */

            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                UPDATE_SPATIAL_ANALYSIS
                        )
            ) {

                statement.setString(
                        1,
                        verificationStatus
                );

                statement.setLong(
                        2,
                        officerUserId
                );

                statement.setString(
                        3,
                        officerRemarks
                );

                statement.setLong(
                        4,
                        applicationId
                );

                spatialRowsUpdated =
                        statement.executeUpdate();
            }

            /*
             * --------------------------------------
             * UPDATE RECOMMENDATIONS
             * --------------------------------------
             */

            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                UPDATE_GIS_RECOMMENDATION
                        )
            ) {

                statement.setString(
                        1,
                        recommendationStatus
                );

                statement.setLong(
                        2,
                        officerUserId
                );

                statement.setString(
                        3,
                        officerRemarks
                );

                statement.setLong(
                        4,
                        applicationId
                );

                recommendationRowsUpdated =
                        statement.executeUpdate();
            }

            /*
             * --------------------------------------
             * ENSURE DATA WAS ACTUALLY UPDATED
             * --------------------------------------
             */

            if (spatialRowsUpdated == 0) {

                connection.rollback();

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "No spatial findings were found "
                        + "for this GIS application."
                );

                return;
            }

            if (recommendationRowsUpdated == 0) {

                connection.rollback();

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "No GIS recommendations were found "
                        + "for this application."
                );

                return;
            }

            connection.commit();

            /*
             * --------------------------------------
             * REDIRECT TO REVIEW PAGE
             * --------------------------------------
             */

            response.sendRedirect(
                    request.getContextPath()
                    + "/officer/gis-review?id="
                    + applicationId
                    + "&status="
                    + redirectStatus
            );

        } catch (Exception exception) {

            if (connection != null) {

                try {

                    connection.rollback();

                } catch (Exception rollbackException) {

                    rollbackException.printStackTrace();
                }
            }

            exception.printStackTrace();

            throw new ServletException(
                    "Unable to save GIS officer decision.",
                    exception
            );

        } finally {

            if (connection != null) {

                try {

                    connection.setAutoCommit(true);
                    connection.close();

                } catch (Exception closeException) {

                    closeException.printStackTrace();
                }
            }
        }
    }

    /*
     * ==========================================
     * CLEAN USER INPUT
     * ==========================================
     */

    private String clean(String value) {

        if (value == null) {
            return null;
        }

        String cleaned =
                value.trim();

        if (cleaned.isEmpty()) {
            return null;
        }

        return cleaned;
    }
}