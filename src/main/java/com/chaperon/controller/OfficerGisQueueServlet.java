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

@WebServlet("/officer/gis-verification")
public class OfficerGisQueueServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     * ==========================================
     * LOAD GIS VERIFICATION QUEUE
     * ==========================================
     */

    private static final String FIND_GIS_APPLICATIONS =
            "SELECT DISTINCT " +
            "ca.clearance_application_id, " +
            "ca.application_number, " +
            "ca.project_title, " +
            "ca.state, " +
            "ca.district, " +
            "ca.project_area_hectares, " +
            "ca.current_status, " +
            "ca.submission_date, " +
            "ct.clearance_name, " +
            "ct.clearance_code, " +
            "csa.verification_status, " +
            "csa.recommendation_level, " +
            "csa.analysed_at " +
            "FROM clearance_applications ca " +
            "JOIN clearance_types ct " +
            "ON ct.clearance_type_id = " +
            "ca.clearance_type_id " +
            "JOIN clearance_spatial_analysis csa " +
            "ON csa.clearance_application_id = " +
            "ca.clearance_application_id " +
            "ORDER BY " +
            "CASE " +
            "WHEN csa.verification_status = 'PENDING' " +
            "THEN 0 ELSE 1 END, " +
            "csa.analysed_at DESC";

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
                || session.getAttribute("userId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/officer-login"
            );

            return;
        }

        /*
         * ==========================================
         * OFFICER ROLE CHECK
         * ==========================================
         */

        Object roleObject =
                session.getAttribute("userRole");

        if (roleObject == null
                || !"OFFICER".equalsIgnoreCase(
                        roleObject.toString()
                )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/officer-login"
            );

            return;
        }

        /*
         * ==========================================
         * PREPARE GIS APPLICATION LIST
         * ==========================================
         */

        List<Map<String, Object>> gisApplications =
                new ArrayList<>();

        int pendingCount = 0;
        int verifiedCount = 0;
        int rejectedCount = 0;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            FIND_GIS_APPLICATIONS
                    );

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            /*
             * ==========================================
             * READ DATABASE RESULTS
             * ==========================================
             */

            while (resultSet.next()) {

                Map<String, Object> application =
                        new HashMap<>();

                application.put(
                        "applicationId",
                        resultSet.getLong(
                                "clearance_application_id"
                        )
                );

                application.put(
                        "applicationNumber",
                        resultSet.getString(
                                "application_number"
                        )
                );

                application.put(
                        "projectTitle",
                        resultSet.getString(
                                "project_title"
                        )
                );

                application.put(
                        "state",
                        resultSet.getString("state")
                );

                application.put(
                        "district",
                        resultSet.getString("district")
                );

                application.put(
                        "projectAreaHectares",
                        resultSet.getBigDecimal(
                                "project_area_hectares"
                        )
                );

                application.put(
                        "applicationStatus",
                        resultSet.getString(
                                "current_status"
                        )
                );

                application.put(
                        "submissionDate",
                        resultSet.getTimestamp(
                                "submission_date"
                        )
                );

                application.put(
                        "clearanceName",
                        resultSet.getString(
                                "clearance_name"
                        )
                );

                application.put(
                        "clearanceCode",
                        resultSet.getString(
                                "clearance_code"
                        )
                );

                application.put(
                        "analysedAt",
                        resultSet.getTimestamp(
                                "analysed_at"
                        )
                );

                String verificationStatus =
                        resultSet.getString(
                                "verification_status"
                        );

                application.put(
                        "verificationStatus",
                        verificationStatus
                );

                application.put(
                        "recommendationLevel",
                        resultSet.getString(
                                "recommendation_level"
                        )
                );

                /*
                 * ======================================
                 * COUNT VERIFICATION STATUS
                 * ======================================
                 */

                if ("PENDING".equalsIgnoreCase(
                        verificationStatus)) {

                    pendingCount++;

                } else if ("VERIFIED".equalsIgnoreCase(
                        verificationStatus)) {

                    verifiedCount++;

                } else if ("REJECTED".equalsIgnoreCase(
                        verificationStatus)) {

                    rejectedCount++;
                }

                gisApplications.add(application);
            }

            /*
             * ==========================================
             * SEND DATA TO JSP
             * ==========================================
             */

            request.setAttribute(
                    "gisApplications",
                    gisApplications
            );

            request.setAttribute(
                    "pendingCount",
                    pendingCount
            );

            request.setAttribute(
                    "verifiedCount",
                    verifiedCount
            );

            request.setAttribute(
                    "rejectedCount",
                    rejectedCount
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/officer/"
                    + "officer-gis-queue.jsp"
            ).forward(request, response);

        } catch (Exception exception) {

            exception.printStackTrace();

            throw new ServletException(
                    "Unable to load GIS verification queue.",
                    exception
            );
        }
    }
}