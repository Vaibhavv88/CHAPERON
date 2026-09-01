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

@WebServlet("/officer/reject-application")
public class RejectApplicationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    /*
     * Application information.
     *
     * user_id and application_number are also loaded
     * for entrepreneur notification.
     */
    private static final String FIND_APPLICATION =

            "SELECT " +
            "application_id, " +
            "application_number, " +
            "user_id, " +
            "department_id, " +
            "assigned_officer_id, " +
            "current_status " +
            "FROM applications " +
            "WHERE application_id = ? " +
            "LIMIT 1";


    /*
     * Application rejection query.
     */
    private static final String REJECT_APPLICATION =

            "UPDATE applications " +
            "SET current_status = 'REJECTED', " +
            "rejection_reason = ?, " +
            "officer_remarks = ?, " +
            "can_reapply = ?, " +
            "rejected_by = ?, " +
            "rejected_at = CURRENT_TIMESTAMP, " +
            "updated_at = CURRENT_TIMESTAMP " +
            "WHERE application_id = ? " +
            "AND current_status = 'UNDER_REVIEW'";


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        /*
         * ==========================================
         * 1. SESSION CHECK
         * ==========================================
         */

        HttpSession session =
                request.getSession(false);


        if (session == null ||
            session.getAttribute("userId") == null ||
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
         * ==========================================
         * 2. PARAMETERS
         * ==========================================
         */

        String applicationIdParameter =
                request.getParameter(
                        "applicationId"
                );


        String rejectionCategory =
                request.getParameter(
                        "rejectionCategory"
                );


        String rejectionDetails =
                request.getParameter(
                        "rejectionDetails"
                );


        String officerRemarks =
                request.getParameter(
                        "officerRemarks"
                );


        boolean canReapply =
                "true".equalsIgnoreCase(
                        request.getParameter(
                                "canReapply"
                        )
                );


        /*
         * Application ID required.
         */
        if (applicationIdParameter == null ||
            applicationIdParameter.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Application ID is required."
            );

            return;
        }


        /*
         * Rejection category required.
         */
        if (rejectionCategory == null ||
            rejectionCategory.isBlank()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/officer/application-review?id="
                    + applicationIdParameter
                    + "&message=Please select a rejection reason."
            );

            return;
        }


        rejectionCategory =
                rejectionCategory.trim();


        if (rejectionDetails != null) {

            rejectionDetails =
                    rejectionDetails.trim();
        }


        if (officerRemarks != null) {

            officerRemarks =
                    officerRemarks.trim();
        }


        /*
         * Complete rejection reason.
         *
         * Example:
         * Invalid Document: PAN document is expired
         */
        String finalRejectionReason =
                rejectionCategory;


        if (rejectionDetails != null &&
            !rejectionDetails.isBlank()) {

            finalRejectionReason =
                    rejectionCategory
                    + ": "
                    + rejectionDetails;
        }


        /*
         * Rejection reason length validation.
         */
        if (finalRejectionReason.length()
                > 3000) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Rejection reason is too long."
            );

            return;
        }


        try {

            /*
             * Application ID String -> long
             */
            long applicationId =
                    Long.parseLong(
                            applicationIdParameter
                    );


            /*
             * rejected_by references users.user_id
             */
            long officerUserId =
                    ((Number)
                    session.getAttribute("userId"))
                    .longValue();


            /*
             * Officer profile ID.
             */
            long officerProfileId =
                    ((Number)
                    session.getAttribute(
                            "officerProfileId"
                    )).longValue();


            /*
             * Officer department ID.
             */
            long officerDepartmentId =
                    ((Number)
                    session.getAttribute(
                            "departmentId"
                    )).longValue();


            /*
             * Database connection.
             */
            try (
                Connection connection =
                        DBConnection.getConnection()
            ) {

                /*
                 * Rejection transaction start.
                 */
                connection.setAutoCommit(false);


                try {

                    /*
                     * ==================================
                     * 3. LOAD APPLICATION
                     * ==================================
                     */

                    long applicationDepartmentId;

                    Long assignedOfficerId = null;


                    /*
                     * Notification ke liye.
                     */
                    long entrepreneurUserId;

                    String applicationNumber;


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

                            /*
                             * Application nahi mili.
                             */
                            if (!resultSet.next()) {

                                connection.rollback();

                                response.sendError(
                                        HttpServletResponse.SC_NOT_FOUND,
                                        "Application not found."
                                );

                                return;
                            }


                            /*
                             * ==================================
                             * ENTREPRENEUR INFORMATION
                             * ==================================
                             */

                            entrepreneurUserId =
                                    resultSet.getLong(
                                            "user_id"
                                    );


                            applicationNumber =
                                    resultSet.getString(
                                            "application_number"
                                    );


                            /*
                             * Application department.
                             */
                            applicationDepartmentId =
                                    resultSet.getLong(
                                            "department_id"
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
                             * Current status.
                             */
                            currentStatus =
                                    resultSet.getString(
                                            "current_status"
                                    );
                        }
                    }


                    /*
                     * ==================================
                     * 4. DEPARTMENT CHECK
                     * ==================================
                     */

                    if (applicationDepartmentId
                            != officerDepartmentId) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_FORBIDDEN,
                                "You cannot reject another department's application."
                        );

                        return;
                    }


                    /*
                     * ==================================
                     * 5. OFFICER CHECK
                     * ==================================
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
                     * ==================================
                     * 6. STATUS CHECK
                     * ==================================
                     *
                     * Sirf UNDER_REVIEW application
                     * reject ho sakti hai.
                     */

                    if (!"UNDER_REVIEW"
                            .equalsIgnoreCase(
                                    currentStatus
                            )) {

                        connection.rollback();

                        response.sendRedirect(
                                request.getContextPath()
                                + "/officer/application-review?id="
                                + applicationId
                                + "&message=Only an application under review can be rejected."
                        );

                        return;
                    }


                    /*
                     * ==================================
                     * 7. REJECT APPLICATION
                     * ==================================
                     */

                    int updatedRows;


                    try (
                        PreparedStatement statement =
                                connection.prepareStatement(
                                        REJECT_APPLICATION
                                )
                    ) {

                        /*
                         * rejection_reason
                         */
                        statement.setString(
                                1,
                                finalRejectionReason
                        );


                        /*
                         * officer_remarks
                         */
                        statement.setString(
                                2,
                                officerRemarks
                        );


                        /*
                         * can_reapply
                         */
                        statement.setBoolean(
                                3,
                                canReapply
                        );


                        /*
                         * rejected_by
                         */
                        statement.setLong(
                                4,
                                officerUserId
                        );


                        /*
                         * application_id
                         */
                        statement.setLong(
                                5,
                                applicationId
                        );


                        updatedRows =
                                statement.executeUpdate();
                    }


                    /*
                     * Agar application status meanwhile
                     * change ho gaya ho.
                     */
                    if (updatedRows == 0) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_CONFLICT,
                                "Application could not be rejected."
                        );

                        return;
                    }


                    /*
                     * ==================================
                     * 8. COMMIT REJECTION
                     * ==================================
                     */

                    connection.commit();


                    /*
                     * ==================================
                     * 9. CREATE REJECTION NOTIFICATION
                     * ==================================
                     *
                     * IMPORTANT:
                     * Notification commit ke BAAD.
                     *
                     * Agar notification fail ho jaye,
                     * actual rejection rollback nahi hoga.
                     */

                    try {

                        NotificationService notificationService =
                                new NotificationService();


                        notificationService
                                .notifyApplicationRejected(
                                        entrepreneurUserId,
                                        applicationId,
                                        applicationNumber
                                );


                    } catch (SQLException notificationException) {

                        log(
                                "Application rejected successfully, "
                                + "but rejection notification could not be created.",
                                notificationException
                        );
                    }


                    /*
                     * ==================================
                     * 10. REDIRECT
                     * ==================================
                     */

                    response.sendRedirect(
                            request.getContextPath()
                            + "/officer/application-review?id="
                            + applicationId
                            + "&success=application-rejected"
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
                    "Invalid Application ID."
            );


        } catch (SQLException e) {

            log(
                    "Unable to reject application.",
                    e
            );


            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to reject application."
            );
        }
    }
}