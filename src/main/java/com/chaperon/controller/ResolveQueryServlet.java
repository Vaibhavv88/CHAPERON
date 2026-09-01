package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
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

@WebServlet("/officer/resolve-query")
public class ResolveQueryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    /*
     * Query + related application information.
     *
     * user_id and application_number notification
     * create karne ke liye load kiye ja rahe hain.
     */
    private static final String FIND_QUERY =

            "SELECT " +
            "q.query_id, " +
            "q.application_id, " +
            "q.raised_by_officer_id, " +
            "q.status, " +

            "a.user_id, " +
            "a.application_number, " +
            "a.department_id, " +
            "a.assigned_officer_id " +

            "FROM application_queries q " +

            "JOIN applications a " +
            "ON q.application_id = a.application_id " +

            "WHERE q.query_id = ?";


    /*
     * Sirf RESPONDED query ko RESOLVED kiya jayega.
     */
    private static final String RESOLVE_QUERY =

            "UPDATE application_queries " +

            "SET status = 'RESOLVED', " +
            "resolved_at = CURRENT_TIMESTAMP, " +
            "updated_at = CURRENT_TIMESTAMP " +

            "WHERE query_id = ? " +
            "AND status = 'RESPONDED'";


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {


        /*
         * ============================================
         * 1. OFFICER SESSION CHECK
         * ============================================
         */

        HttpSession session =
                request.getSession(false);


        if (session == null ||
            session.getAttribute("userRole") == null ||
            session.getAttribute("departmentId") == null ||
            session.getAttribute("officerProfileId") == null ||
            !"OFFICER".equalsIgnoreCase(
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
         * ============================================
         * 2. PARAMETERS
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


        /*
         * Query ID + Application ID required.
         */
        if (queryIdParameter == null ||
            queryIdParameter.isBlank() ||
            applicationIdParameter == null ||
            applicationIdParameter.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Query information is required."
            );

            return;
        }


        try {

            /*
             * Query ID.
             */
            long queryId =
                    Long.parseLong(
                            queryIdParameter
                    );


            /*
             * Application ID.
             */
            long applicationId =
                    Long.parseLong(
                            applicationIdParameter
                    );


            /*
             * Logged-in officer department.
             */
            long officerDepartmentId =
                    ((Number)
                    session.getAttribute(
                            "departmentId"
                    )).longValue();


            /*
             * Logged-in officer profile.
             */
            long officerProfileId =
                    ((Number)
                    session.getAttribute(
                            "officerProfileId"
                    )).longValue();


            /*
             * ============================================
             * 3. TRANSACTION
             * ============================================
             */

            try (
                Connection connection =
                        DBConnection.getConnection()
            ) {

                connection.setAutoCommit(false);


                try {

                    /*
                     * Query information.
                     */
                    long queryApplicationId;

                    long applicationDepartmentId;

                    Long assignedOfficerId = null;

                    String queryStatus;


                    /*
                     * Notification information.
                     */
                    long entrepreneurUserId;

                    String applicationNumber;


                    /*
                     * ====================================
                     * 4. FIND QUERY
                     * ====================================
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

                            /*
                             * Query nahi mili.
                             */
                            if (!resultSet.next()) {

                                connection.rollback();


                                response.sendError(
                                        HttpServletResponse.SC_NOT_FOUND,
                                        "Query not found."
                                );

                                return;
                            }


                            /*
                             * Query kis application ki hai.
                             */
                            queryApplicationId =
                                    resultSet.getLong(
                                            "application_id"
                                    );


                            /*
                             * Application department.
                             */
                            applicationDepartmentId =
                                    resultSet.getLong(
                                            "department_id"
                                    );


                            /*
                             * Current query status.
                             */
                            queryStatus =
                                    resultSet.getString(
                                            "status"
                                    );


                            /*
                             * Assigned officer.
                             */
                            long assignedValue =
                                    resultSet.getLong(
                                            "assigned_officer_id"
                                    );


                            if (!resultSet.wasNull()) {

                                assignedOfficerId =
                                        assignedValue;
                            }


                            /*
                             * =================================
                             * NOTIFICATION INFORMATION
                             * =================================
                             */

                            entrepreneurUserId =
                                    resultSet.getLong(
                                            "user_id"
                                    );


                            applicationNumber =
                                    resultSet.getString(
                                            "application_number"
                                    );
                        }
                    }


                    /*
                     * ====================================
                     * 5. APPLICATION MATCH
                     * ====================================
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
                     * ====================================
                     * 6. DEPARTMENT SECURITY
                     * ====================================
                     */

                    if (applicationDepartmentId
                            != officerDepartmentId) {

                        connection.rollback();


                        response.sendError(
                                HttpServletResponse.SC_FORBIDDEN,
                                "You cannot resolve another department's query."
                        );

                        return;
                    }


                    /*
                     * ====================================
                     * 7. ASSIGNED OFFICER SECURITY
                     * ====================================
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
                     * ====================================
                     * 8. STATUS CHECK
                     * ====================================
                     *
                     * Entrepreneur response ke baad hi
                     * query resolve ki ja sakti hai.
                     */

                    if (!"RESPONDED"
                            .equalsIgnoreCase(
                                    queryStatus
                            )) {

                        connection.rollback();


                        response.sendRedirect(
                                request.getContextPath()
                                + "/officer/application-review?id="
                                + applicationId
                                + "&message=Only a responded query can be resolved."
                        );

                        return;
                    }


                    /*
                     * ====================================
                     * 9. RESOLVE QUERY
                     * ====================================
                     */

                    int updatedRows;


                    try (
                        PreparedStatement statement =
                                connection.prepareStatement(
                                        RESOLVE_QUERY
                                )
                    ) {

                        statement.setLong(
                                1,
                                queryId
                        );


                        updatedRows =
                                statement.executeUpdate();
                    }


                    /*
                     * Query update nahi hui.
                     */
                    if (updatedRows == 0) {

                        connection.rollback();


                        response.sendError(
                                HttpServletResponse.SC_CONFLICT,
                                "Query could not be resolved."
                        );

                        return;
                    }


                    /*
                     * ====================================
                     * 10. COMMIT QUERY RESOLUTION
                     * ====================================
                     */

                    connection.commit();


                    /*
                     * ====================================
                     * 11. CREATE NOTIFICATION
                     * ====================================
                     *
                     * IMPORTANT:
                     *
                     * Query resolve transaction pehle
                     * commit ho chuki hai.
                     *
                     * Notification fail hone par query
                     * RESOLVED hi rahegi.
                     */

                    try {

                        NotificationService notificationService =
                                new NotificationService();


                        notificationService
                                .notifyQueryResolved(
                                        entrepreneurUserId,
                                        applicationId,
                                        applicationNumber
                                );


                    } catch (SQLException notificationException) {

                        log(
                                "Query resolved successfully, "
                                + "but query resolved notification could not be created.",
                                notificationException
                        );
                    }


                    /*
                     * ====================================
                     * 12. SUCCESS REDIRECT
                     * ====================================
                     */

                    response.sendRedirect(
                            request.getContextPath()
                            + "/officer/application-review?id="
                            + applicationId
                            + "&success=query-resolved"
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
                    "Invalid query information."
            );


        } catch (SQLException e) {

            log(
                    "Unable to resolve query.",
                    e
            );


            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to resolve query."
            );
        }
    }
}