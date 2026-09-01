package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/respond-query")
public class RespondQueryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    private static final String FIND_QUERY =
            "SELECT " +
            "q.query_id, " +
            "q.application_id, " +
            "q.status, " +
            "a.user_id, " +
            "a.current_status " +
            "FROM application_queries q " +
            "JOIN applications a " +
            "ON q.application_id = a.application_id " +
            "WHERE q.query_id = ?";


    private static final String UPDATE_QUERY =
            "UPDATE application_queries " +
            "SET entrepreneur_response = ?, " +
            "status = 'RESPONDED', " +
            "responded_at = CURRENT_TIMESTAMP, " +
            "updated_at = CURRENT_TIMESTAMP " +
            "WHERE query_id = ? " +
            "AND status = 'OPEN'";


    private static final String UPDATE_APPLICATION =
            "UPDATE applications " +
            "SET current_status = 'UNDER_REVIEW', " +
            "updated_at = CURRENT_TIMESTAMP " +
            "WHERE application_id = ?";


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding(
                "UTF-8"
        );


        /*
         * ============================================
         * 1. ENTREPRENEUR SESSION CHECK
         * ============================================
         */

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null ||
            session.getAttribute("userRole") == null ||
            !"ENTREPRENEUR".equalsIgnoreCase(
                    String.valueOf(
                            session.getAttribute(
                                    "userRole"
                            )
                    )
            )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }


        /*
         * ============================================
         * 2. READ FORM DATA
         * ============================================
         */

        String queryIdParameter =
                request.getParameter(
                        "queryId"
                );

        String applicationIdParameter =
                request.getParameter(
                        "applicationId"
                );

        String entrepreneurResponse =
                request.getParameter(
                        "entrepreneurResponse"
                );


        if (queryIdParameter == null ||
            queryIdParameter.isBlank() ||
            applicationIdParameter == null ||
            applicationIdParameter.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Query information is missing."
            );

            return;
        }


        if (entrepreneurResponse == null ||
            entrepreneurResponse.isBlank()) {

            redirectWithMessage(
                    request,
                    response,
                    applicationIdParameter,
                    "Please enter your response."
            );

            return;
        }


        if (entrepreneurResponse.trim()
                .length() > 3000) {

            redirectWithMessage(
                    request,
                    response,
                    applicationIdParameter,
                    "Response cannot exceed 3000 characters."
            );

            return;
        }


        try {

            long queryId =
                    Long.parseLong(
                            queryIdParameter
                    );

            long applicationId =
                    Long.parseLong(
                            applicationIdParameter
                    );

            long loggedInUserId =
                    ((Number)
                    session.getAttribute(
                            "userId"
                    )).longValue();


            /*
             * ============================================
             * 3. DATABASE TRANSACTION
             * ============================================
             */

            try (
                Connection connection =
                        DBConnection.getConnection()
            ) {

                connection.setAutoCommit(
                        false
                );

                try {

                    long queryApplicationId;
                    long applicationUserId;
                    String queryStatus;
                    String applicationStatus;


                    /*
                     * ============================================
                     * 4. LOAD QUERY + APPLICATION
                     * ============================================
                     */

                    try (
                        PreparedStatement statement =
                                connection.prepareStatement(
                                        FIND_QUERY
                                )
                    ) {

                        statement.setLong(
                                1,
                                queryId
                        );

                        try (
                            ResultSet resultSet =
                                    statement.executeQuery()
                        ) {

                            if (!resultSet.next()) {

                                connection.rollback();

                                response.sendError(
                                        HttpServletResponse.SC_NOT_FOUND,
                                        "Query not found."
                                );

                                return;
                            }

                            queryApplicationId =
                                    resultSet.getLong(
                                            "application_id"
                                    );

                            applicationUserId =
                                    resultSet.getLong(
                                            "user_id"
                                    );

                            queryStatus =
                                    resultSet.getString(
                                            "status"
                                    );

                            applicationStatus =
                                    resultSet.getString(
                                            "current_status"
                                    );
                        }
                    }


                    /*
                     * ============================================
                     * 5. APPLICATION MATCH CHECK
                     * ============================================
                     */

                    if (queryApplicationId
                            != applicationId) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_BAD_REQUEST,
                                "Query does not belong to this application."
                        );

                        return;
                    }


                    /*
                     * ============================================
                     * 6. OWNERSHIP SECURITY
                     * ============================================
                     */

                    if (applicationUserId
                            != loggedInUserId) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_FORBIDDEN,
                                "You cannot respond to this query."
                        );

                        return;
                    }


                    /*
                     * ============================================
                     * 7. QUERY STATUS CHECK
                     * ============================================
                     */

                    if (!"OPEN"
                            .equalsIgnoreCase(
                                    queryStatus
                            )) {

                        connection.rollback();

                        redirectWithMessage(
                                request,
                                response,
                                applicationIdParameter,
                                "This query has already been responded to."
                        );

                        return;
                    }


                    /*
                     * ============================================
                     * 8. APPLICATION STATUS CHECK
                     * ============================================
                     */

                    if (!"QUERY_RAISED"
                            .equalsIgnoreCase(
                                    applicationStatus
                            )) {

                        connection.rollback();

                        redirectWithMessage(
                                request,
                                response,
                                applicationIdParameter,
                                "This application is not currently waiting for a query response."
                        );

                        return;
                    }


                    /*
                     * ============================================
                     * 9. SAVE ENTREPRENEUR RESPONSE
                     * ============================================
                     */

                    int updatedQueryRows;

                    try (
                        PreparedStatement statement =
                                connection.prepareStatement(
                                        UPDATE_QUERY
                                )
                    ) {

                        statement.setString(
                                1,
                                entrepreneurResponse
                                        .trim()
                        );

                        statement.setLong(
                                2,
                                queryId
                        );

                        updatedQueryRows =
                                statement.executeUpdate();
                    }


                    if (updatedQueryRows == 0) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_CONFLICT,
                                "Query could not be updated."
                        );

                        return;
                    }


                    /*
                     * ============================================
                     * 10. RETURN APPLICATION TO REVIEW
                     * ============================================
                     */

                    try (
                        PreparedStatement statement =
                                connection.prepareStatement(
                                        UPDATE_APPLICATION
                                )
                    ) {

                        statement.setLong(
                                1,
                                applicationId
                        );

                        statement.executeUpdate();
                    }


                    /*
                     * ============================================
                     * 11. COMMIT
                     * ============================================
                     */

                    connection.commit();


                    response.sendRedirect(
                            request.getContextPath()
                            + "/entrepreneur/application-details?id="
                            + applicationId
                            + "&success=query-responded"
                    );


                } catch (Exception e) {

                    connection.rollback();
                    throw e;

                } finally {

                    connection.setAutoCommit(
                            true
                    );
                }
            }


        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid query information."
            );


        } catch (SQLException e) {

            log(
                    "Unable to submit query response.",
                    e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to submit query response."
            );
        }
    }


    private void redirectWithMessage(
            HttpServletRequest request,
            HttpServletResponse response,
            String applicationId,
            String message
    ) throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/entrepreneur/application-details?id="
                + applicationId
                + "&message="
                + java.net.URLEncoder.encode(
                        message,
                        java.nio.charset.StandardCharsets.UTF_8
                )
        );
    }
}