package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.chaperon.service.NotificationService;
import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/officer/raise-query")
public class RaiseQueryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     * Application ke saath entrepreneur user_id aur
     * application_number bhi load karenge.
     *
     * Ye notification generate karne ke liye chahiye.
     */
    private static final String FIND_APPLICATION =
            "SELECT " +
            "user_id, " +
            "application_number, " +
            "department_id, " +
            "current_status, " +
            "assigned_officer_id " +
            "FROM applications " +
            "WHERE application_id = ?";


    private static final String INSERT_QUERY =
            "INSERT INTO application_queries " +
            "(application_id, raised_by_officer_id, " +
            "query_description, response_deadline, status) " +
            "VALUES (?, ?, ?, ?, 'OPEN')";


    private static final String UPDATE_APPLICATION =
            "UPDATE applications " +
            "SET current_status = 'QUERY_RAISED', " +
            "assigned_officer_id = ?, " +
            "updated_at = CURRENT_TIMESTAMP " +
            "WHERE application_id = ?";


    private final NotificationService notificationService =
            new NotificationService();


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");


        /*
         * =====================================================
         * 1. CHECK OFFICER SESSION
         * =====================================================
         */

        HttpSession session =
                request.getSession(false);


        if (session == null ||
            session.getAttribute("userRole") == null ||
            session.getAttribute("departmentId") == null ||
            session.getAttribute("officerProfileId") == null ||
            !"OFFICER".equalsIgnoreCase(
                    String.valueOf(
                            session.getAttribute("userRole")
                    )
            )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/officer-login"
            );

            return;
        }


        /*
         * =====================================================
         * 2. READ FORM DATA
         * =====================================================
         */

        String applicationIdParam =
                request.getParameter(
                        "applicationId"
                );


        String queryDescription =
                request.getParameter(
                        "queryDescription"
                );


        String responseDeadlineParam =
                request.getParameter(
                        "responseDeadline"
                );


        if (applicationIdParam == null ||
            applicationIdParam.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Application ID is required."
            );

            return;
        }


        if (queryDescription == null ||
            queryDescription.isBlank()) {

            redirectWithError(
                    request,
                    response,
                    applicationIdParam,
                    "Please enter the query description."
            );

            return;
        }


        if (responseDeadlineParam == null ||
            responseDeadlineParam.isBlank()) {

            redirectWithError(
                    request,
                    response,
                    applicationIdParam,
                    "Please select a response deadline."
            );

            return;
        }


        /*
         * =====================================================
         * 3. CONVERT VALUES
         * =====================================================
         */

        long applicationId;

        Date responseDeadline;


        try {

            applicationId =
                    Long.parseLong(
                            applicationIdParam
                    );

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid application ID."
            );

            return;
        }


        try {

            responseDeadline =
                    Date.valueOf(
                            responseDeadlineParam
                    );

        } catch (IllegalArgumentException e) {

            redirectWithError(
                    request,
                    response,
                    applicationIdParam,
                    "Invalid response deadline."
            );

            return;
        }


        long officerProfileId =
                ((Number)
                session.getAttribute(
                        "officerProfileId"
                )).longValue();


        long officerDepartmentId =
                ((Number)
                session.getAttribute(
                        "departmentId"
                )).longValue();


        /*
         * Notification ke liye transaction ke andar
         * entrepreneur info store karenge.
         */
        long entrepreneurUserId = 0;

        String applicationNumber = null;


        /*
         * =====================================================
         * 4. DATABASE TRANSACTION
         * =====================================================
         */

        try (
            Connection connection =
                    DBConnection.getConnection()
        ) {

            connection.setAutoCommit(false);


            try {

                /*
                 * =================================================
                 * 5. FIND APPLICATION
                 * =================================================
                 */

                long applicationDepartmentId;

                String currentStatus;

                Long assignedOfficerId = null;


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


                        /*
                         * Entrepreneur account
                         */
                        entrepreneurUserId =
                                resultSet.getLong(
                                        "user_id"
                                );


                        /*
                         * Application number
                         */
                        applicationNumber =
                                resultSet.getString(
                                        "application_number"
                                );


                        applicationDepartmentId =
                                resultSet.getLong(
                                        "department_id"
                                );


                        currentStatus =
                                resultSet.getString(
                                        "current_status"
                                );


                        long assignedValue =
                                resultSet.getLong(
                                        "assigned_officer_id"
                                );


                        if (!resultSet.wasNull()) {

                            assignedOfficerId =
                                    assignedValue;
                        }
                    }
                }


                /*
                 * =================================================
                 * 6. DEPARTMENT SECURITY
                 * =================================================
                 */

                if (applicationDepartmentId
                        != officerDepartmentId) {

                    connection.rollback();


                    response.sendError(
                            HttpServletResponse.SC_FORBIDDEN,
                            "You cannot raise a query for another department's application."
                    );

                    return;
                }


                /*
                 * =================================================
                 * 7. CHECK APPLICATION STATUS
                 * =================================================
                 */

                if (!"UNDER_REVIEW"
                        .equalsIgnoreCase(
                                currentStatus
                        )) {

                    connection.rollback();


                    redirectWithError(
                            request,
                            response,
                            applicationIdParam,
                            "A query can only be raised while the application is under review."
                    );

                    return;
                }


                /*
                 * =================================================
                 * 8. CHECK ASSIGNED OFFICER
                 * =================================================
                 */

                if (assignedOfficerId != null &&
                    assignedOfficerId.longValue()
                            != officerProfileId) {

                    connection.rollback();


                    response.sendError(
                            HttpServletResponse.SC_FORBIDDEN,
                            "This application is assigned to another officer."
                    );

                    return;
                }


                /*
                 * =================================================
                 * 9. INSERT QUERY
                 * =================================================
                 */

                try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    INSERT_QUERY
                            )
                ) {

                    statement.setLong(
                            1,
                            applicationId
                    );


                    statement.setLong(
                            2,
                            officerProfileId
                    );


                    statement.setString(
                            3,
                            queryDescription.trim()
                    );


                    statement.setDate(
                            4,
                            responseDeadline
                    );


                    statement.executeUpdate();
                }


                /*
                 * =================================================
                 * 10. UPDATE APPLICATION STATUS
                 * =================================================
                 */

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


                    statement.executeUpdate();
                }


                /*
                 * =================================================
                 * 11. COMMIT QUERY + APPLICATION STATUS
                 * =================================================
                 */

                connection.commit();


            } catch (Exception e) {

                connection.rollback();

                throw e;


            } finally {

                connection.setAutoCommit(true);
            }


        } catch (SQLException e) {

            log(
                    "Unable to raise application query.",
                    e
            );


            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to raise application query."
            );

            return;
        }


        /*
         * =====================================================
         * 12. CREATE ENTREPRENEUR NOTIFICATION
         * =====================================================
         *
         * Important:
         * Query transaction already successfully committed.
         *
         * Notification failure se actual query rollback nahi hogi.
         * Notification error ko log karenge.
         */

        try {

            notificationService.notifyQueryRaised(
                    entrepreneurUserId,
                    applicationId,
                    applicationNumber
            );


        } catch (SQLException e) {

            log(
                    "Query was raised successfully, "
                    + "but notification could not be created.",
                    e
            );
        }


        /*
         * =====================================================
         * 13. SUCCESS REDIRECT
         * =====================================================
         */

        response.sendRedirect(
                request.getContextPath()
                + "/officer/application-review?id="
                + applicationId
                + "&success=query-raised"
        );
    }


    /*
     * =========================================================
     * ERROR REDIRECT HELPER
     * =========================================================
     */

    private void redirectWithError(
            HttpServletRequest request,
            HttpServletResponse response,
            String applicationId,
            String message)
            throws IOException {


        response.sendRedirect(
                request.getContextPath()
                + "/officer/application-review?id="
                + applicationId
                + "&message="
                + java.net.URLEncoder.encode(
                        message,
                        java.nio.charset.StandardCharsets.UTF_8
                )
        );
    }
}