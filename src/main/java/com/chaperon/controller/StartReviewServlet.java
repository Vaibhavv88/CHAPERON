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

@WebServlet("/officer/start-review")
public class StartReviewServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String FIND_APPLICATION =
            "SELECT department_id, current_status " +
            "FROM applications " +
            "WHERE application_id = ?";

    private static final String UPDATE_APPLICATION =
            "UPDATE applications " +
            "SET current_status = 'UNDER_REVIEW', " +
            "assigned_officer_id = ?, " +
            "updated_at = CURRENT_TIMESTAMP " +
            "WHERE application_id = ? " +
            "AND current_status = 'SUBMITTED'";

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null ||
            !"OFFICER".equalsIgnoreCase(
                    (String) session.getAttribute("userRole")
            )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/officer-login"
            );

            return;
        }

        String applicationIdParam =
                request.getParameter("applicationId");

        if (applicationIdParam == null ||
            applicationIdParam.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Application ID is required."
            );

            return;
        }

        try {

            long applicationId =
                    Long.parseLong(applicationIdParam);

            long officerProfileId =
                    ((Number)
                    session.getAttribute("officerProfileId"))
                    .longValue();

            long officerDepartmentId =
                    ((Number)
                    session.getAttribute("departmentId"))
                    .longValue();

            try (
                Connection connection =
                        DBConnection.getConnection()
            ) {

                connection.setAutoCommit(false);

                try {

                    long applicationDepartmentId;
                    String currentStatus;

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

                            if (!resultSet.next()) {

                                connection.rollback();

                                response.sendError(
                                        HttpServletResponse.SC_NOT_FOUND,
                                        "Application not found."
                                );

                                return;
                            }

                            applicationDepartmentId =
                                    resultSet.getLong(
                                            "department_id"
                                    );

                            currentStatus =
                                    resultSet.getString(
                                            "current_status"
                                    );
                        }
                    }

                    if (applicationDepartmentId
                            != officerDepartmentId) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_FORBIDDEN,
                                "You cannot review applications from another department."
                        );

                        return;
                    }

                    if (!"SUBMITTED"
                            .equalsIgnoreCase(currentStatus)) {

                        connection.rollback();

                        response.sendRedirect(
                                request.getContextPath()
                                + "/officer/application-review?id="
                                + applicationId
                                + "&message=Application is already under processing."
                        );

                        return;
                    }

                    try (
                        PreparedStatement statement =
                                connection.prepareStatement(
                                        UPDATE_APPLICATION
                                )
                    ) {

                    	statement.setLong(
                    	        1,
                    	        officerProfileId
                    	);

                        statement.setLong(
                                2,
                                applicationId
                        );

                        int updatedRows =
                                statement.executeUpdate();

                        if (updatedRows == 0) {

                            connection.rollback();

                            response.sendError(
                                    HttpServletResponse.SC_CONFLICT,
                                    "Application could not be moved to review."
                            );

                            return;
                        }
                    }

                    connection.commit();

                    response.sendRedirect(
                            request.getContextPath()
                            + "/officer/application-review?id="
                            + applicationId
                            + "&success=review-started"
                    );

                } catch (Exception e) {

                    connection.rollback();
                    throw e;

                } finally {

                    connection.setAutoCommit(true);
                }
            }

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid application ID."
            );

        } catch (SQLException e) {

            log(
                    "Unable to start application review.",
                    e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to start application review."
            );

        } catch (Exception e) {

            log(
                    "Unexpected error while starting review.",
                    e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Something went wrong."
            );
        }
    }
}