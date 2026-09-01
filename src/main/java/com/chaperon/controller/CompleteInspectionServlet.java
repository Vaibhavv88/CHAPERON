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

@WebServlet("/officer/complete-inspection")
public class CompleteInspectionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    /*
     * Inspection + related application information.
     *
     * Application user_id and application_number
     * notification ke liye load kiye ja rahe hain.
     */
    private static final String FIND_INSPECTION =

            "SELECT " +
            "i.inspection_id, " +
            "i.application_id, " +
            "i.department_id, " +
            "i.officer_profile_id, " +
            "i.status AS inspection_status, " +

            "a.user_id, " +
            "a.application_number, " +
            "a.current_status AS application_status " +

            "FROM inspections i " +

            "JOIN applications a " +
            "ON i.application_id = a.application_id " +

            "WHERE i.inspection_id = ? " +
            "AND i.application_id = ? " +
            "LIMIT 1";


    /*
     * Inspection completion query.
     */
    private static final String COMPLETE_INSPECTION =

            "UPDATE inspections " +
            "SET status = 'COMPLETED', " +
            "result = ?, " +
            "inspection_notes = ?, " +
            "recommendation = ?, " +
            "updated_at = CURRENT_TIMESTAMP " +
            "WHERE inspection_id = ? " +
            "AND application_id = ?";


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        /*
         * =========================================
         * 1. SESSION SECURITY
         * =========================================
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
         * =========================================
         * 2. READ FORM DATA
         * =========================================
         */

        String inspectionIdText =
                request.getParameter(
                        "inspectionId"
                );


        String applicationIdText =
                request.getParameter(
                        "applicationId"
                );


        String result =
                request.getParameter(
                        "result"
                );


        String inspectionNotes =
                request.getParameter(
                        "inspectionNotes"
                );


        String recommendation =
                request.getParameter(
                        "recommendation"
                );


        /*
         * =========================================
         * 3. BASIC VALIDATION
         * =========================================
         */

        if (inspectionIdText == null ||
            inspectionIdText.isBlank() ||
            applicationIdText == null ||
            applicationIdText.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Inspection ID and Application ID are required."
            );

            return;
        }


        /*
         * Result required hai.
         */
        if (result == null ||
            result.isBlank()) {

            redirectWithMessage(
                    request,
                    response,
                    applicationIdText,
                    "Please select an inspection result."
            );

            return;
        }


        /*
         * Result ko uppercase me normalize karo.
         */
        result =
                result.trim().toUpperCase();


        /*
         * Sirf ye 3 inspection results allowed hain.
         */
        if (!"PASSED".equals(result) &&
            !"FAILED".equals(result) &&
            !"PARTIALLY_COMPLIANT".equals(result)) {

            redirectWithMessage(
                    request,
                    response,
                    applicationIdText,
                    "Invalid inspection result."
            );

            return;
        }


        /*
         * Optional inspection notes.
         */
        if (inspectionNotes != null) {

            inspectionNotes =
                    inspectionNotes.trim();
        }


        /*
         * Optional recommendation.
         */
        if (recommendation != null) {

            recommendation =
                    recommendation.trim();
        }


        /*
         * =========================================
         * 4. PARSE IDS
         * =========================================
         */

        try {

            long inspectionId =
                    Long.parseLong(
                            inspectionIdText
                    );


            long applicationId =
                    Long.parseLong(
                            applicationIdText
                    );


            /*
             * Officer department.
             */
            long officerDepartmentId =
                    ((Number)
                    session.getAttribute(
                            "departmentId"
                    )).longValue();


            /*
             * Officer profile.
             */
            long officerProfileId =
                    ((Number)
                    session.getAttribute(
                            "officerProfileId"
                    )).longValue();


            /*
             * =========================================
             * 5. DATABASE TRANSACTION
             * =========================================
             */

            try (
                Connection connection =
                        DBConnection.getConnection()
            ) {

                connection.setAutoCommit(false);


                try {

                    /*
                     * Inspection information.
                     */
                    long inspectionDepartmentId;

                    Long inspectionOfficerProfileId =
                            null;


                    String inspectionStatus;

                    String applicationStatus;


                    /*
                     * Notification information.
                     */
                    long entrepreneurUserId;

                    String applicationNumber;


                    /*
                     * -----------------------------------------
                     * LOAD INSPECTION
                     * -----------------------------------------
                     */

                    try (
                        PreparedStatement statement =
                                connection.prepareStatement(
                                        FIND_INSPECTION
                                )
                    ) {

                        statement.setLong(
                                1,
                                inspectionId
                        );


                        statement.setLong(
                                2,
                                applicationId
                        );


                        try (
                            ResultSet resultSet =
                                    statement.executeQuery()
                        ) {

                            /*
                             * Inspection nahi mili.
                             */
                            if (!resultSet.next()) {

                                connection.rollback();

                                response.sendError(
                                        HttpServletResponse.SC_NOT_FOUND,
                                        "Inspection not found."
                                );

                                return;
                            }


                            /*
                             * Inspection department.
                             */
                            inspectionDepartmentId =
                                    resultSet.getLong(
                                            "department_id"
                                    );


                            /*
                             * Assigned officer profile.
                             */
                            long officerValue =
                                    resultSet.getLong(
                                            "officer_profile_id"
                                    );


                            if (!resultSet.wasNull()) {

                                inspectionOfficerProfileId =
                                        officerValue;
                            }


                            /*
                             * Inspection status.
                             */
                            inspectionStatus =
                                    resultSet.getString(
                                            "inspection_status"
                                    );


                            /*
                             * Application status.
                             */
                            applicationStatus =
                                    resultSet.getString(
                                            "application_status"
                                    );


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
                     * -----------------------------------------
                     * DEPARTMENT SECURITY
                     * -----------------------------------------
                     */

                    if (inspectionDepartmentId
                            != officerDepartmentId) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_FORBIDDEN,
                                "You cannot complete another department's inspection."
                        );

                        return;
                    }


                    /*
                     * -----------------------------------------
                     * OFFICER SECURITY
                     * -----------------------------------------
                     */

                    if (inspectionOfficerProfileId != null &&
                        inspectionOfficerProfileId.longValue()
                                != officerProfileId) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_FORBIDDEN,
                                "This inspection is assigned to another officer."
                        );

                        return;
                    }


                    /*
                     * -----------------------------------------
                     * APPLICATION MUST STILL BE UNDER REVIEW
                     * -----------------------------------------
                     */

                    if (!"UNDER_REVIEW"
                            .equalsIgnoreCase(
                                    applicationStatus
                            )) {

                        connection.rollback();

                        redirectWithMessage(
                                request,
                                response,
                                applicationIdText,
                                "Inspection cannot be completed because the application is no longer under review."
                        );

                        return;
                    }


                    /*
                     * -----------------------------------------
                     * INSPECTION MUST BE SCHEDULED
                     * -----------------------------------------
                     */

                    if (!"SCHEDULED"
                            .equalsIgnoreCase(
                                    inspectionStatus
                            )) {

                        connection.rollback();

                        redirectWithMessage(
                                request,
                                response,
                                applicationIdText,
                                "Only a scheduled inspection can be completed."
                        );

                        return;
                    }


                    /*
                     * -----------------------------------------
                     * COMPLETE INSPECTION
                     * -----------------------------------------
                     */

                    int updatedRows;


                    try (
                        PreparedStatement statement =
                                connection.prepareStatement(
                                        COMPLETE_INSPECTION
                                )
                    ) {

                        /*
                         * result
                         */
                        statement.setString(
                                1,
                                result
                        );


                        /*
                         * inspection_notes
                         */
                        statement.setString(
                                2,
                                inspectionNotes
                        );


                        /*
                         * recommendation
                         */
                        statement.setString(
                                3,
                                recommendation
                        );


                        /*
                         * inspection_id
                         */
                        statement.setLong(
                                4,
                                inspectionId
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
                     * Exactly one inspection update honi chahiye.
                     */
                    if (updatedRows != 1) {

                        connection.rollback();

                        throw new SQLException(
                                "Inspection update failed."
                        );
                    }


                    /*
                     * =========================================
                     * 6. COMMIT INSPECTION
                     * =========================================
                     */

                    connection.commit();


                    /*
                     * =========================================
                     * 7. CREATE NOTIFICATION
                     * =========================================
                     *
                     * IMPORTANT:
                     *
                     * Notification inspection transaction
                     * commit hone ke BAAD create ho rahi hai.
                     *
                     * Notification fail hone par completed
                     * inspection rollback nahi hogi.
                     */

                    try {

                        NotificationService notificationService =
                                new NotificationService();


                        notificationService
                                .notifyInspectionCompleted(
                                        entrepreneurUserId,
                                        applicationId,
                                        applicationNumber,
                                        result
                                );


                    } catch (SQLException notificationException) {

                        log(
                                "Inspection completed successfully, "
                                + "but inspection notification could not be created.",
                                notificationException
                        );
                    }


                    /*
                     * =========================================
                     * 8. SUCCESS REDIRECT
                     * =========================================
                     */

                    response.sendRedirect(
                            request.getContextPath()
                            + "/officer/application-review?id="
                            + applicationId
                            + "&success=inspection-completed"
                    );


                } catch (SQLException | RuntimeException e) {

                    connection.rollback();

                    throw e;


                } finally {

                    try {

                        connection.setAutoCommit(true);

                    } catch (SQLException ignored) {

                        // Connection is about to close.
                    }
                }
            }


        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid Inspection ID or Application ID."
            );


        } catch (SQLException e) {

            log(
                    "Unable to complete inspection.",
                    e
            );


            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to complete inspection."
            );
        }
    }


    /*
     * =========================================
     * REDIRECT WITH MESSAGE
     * =========================================
     */

    private void redirectWithMessage(
            HttpServletRequest request,
            HttpServletResponse response,
            String applicationId,
            String message
    ) throws IOException {

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