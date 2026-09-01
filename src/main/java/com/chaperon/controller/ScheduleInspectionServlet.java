package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;

import com.chaperon.service.NotificationService;
import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/officer/schedule-inspection")
public class ScheduleInspectionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     * Notification ke liye user_id aur
     * application_number bhi load kar rahe hain.
     */
    private static final String FIND_APPLICATION =
            "SELECT " +
            "application_id, " +
            "user_id, " +
            "application_number, " +
            "department_id, " +
            "assigned_officer_id, " +
            "current_status " +
            "FROM applications " +
            "WHERE application_id = ? " +
            "LIMIT 1";


    private static final String FIND_ACTIVE_INSPECTION =
            "SELECT inspection_id " +
            "FROM inspections " +
            "WHERE application_id = ? " +
            "AND status IN ('SCHEDULED', 'RESCHEDULED') " +
            "LIMIT 1";


    private static final String INSERT_INSPECTION =
            "INSERT INTO inspections (" +
            "application_id, " +
            "inspection_type, " +
            "department_id, " +
            "officer_profile_id, " +
            "inspection_date, " +
            "inspection_time, " +
            "location, " +
            "remarks, " +
            "status" +
            ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'SCHEDULED')";


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
         * 1. SESSION CHECK
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

        String applicationIdText =
                request.getParameter(
                        "applicationId"
                );


        String inspectionType =
                request.getParameter(
                        "inspectionType"
                );


        String inspectionDateText =
                request.getParameter(
                        "inspectionDate"
                );


        String inspectionTimeText =
                request.getParameter(
                        "inspectionTime"
                );


        String location =
                request.getParameter(
                        "location"
                );


        String remarks =
                request.getParameter(
                        "remarks"
                );


        if (applicationIdText == null ||
            applicationIdText.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Application ID is required."
            );

            return;
        }


        if (inspectionType == null ||
            inspectionType.isBlank()) {

            redirectWithMessage(
                    request,
                    response,
                    applicationIdText,
                    "Inspection type is required."
            );

            return;
        }


        if (inspectionDateText == null ||
            inspectionDateText.isBlank()) {

            redirectWithMessage(
                    request,
                    response,
                    applicationIdText,
                    "Inspection date is required."
            );

            return;
        }


        if (inspectionTimeText == null ||
            inspectionTimeText.isBlank()) {

            redirectWithMessage(
                    request,
                    response,
                    applicationIdText,
                    "Inspection time is required."
            );

            return;
        }


        if (location == null ||
            location.isBlank()) {

            redirectWithMessage(
                    request,
                    response,
                    applicationIdText,
                    "Inspection location is required."
            );

            return;
        }


        inspectionType =
                inspectionType.trim();


        location =
                location.trim();


        if (remarks != null) {

            remarks =
                    remarks.trim();
        }


        if (inspectionType.length() > 100) {

            redirectWithMessage(
                    request,
                    response,
                    applicationIdText,
                    "Inspection type is too long."
            );

            return;
        }


        if (location.length() > 500) {

            redirectWithMessage(
                    request,
                    response,
                    applicationIdText,
                    "Inspection location is too long."
            );

            return;
        }


        /*
         * =====================================================
         * 3. PARSE DATA
         * =====================================================
         */

        try {

            long applicationId =
                    Long.parseLong(
                            applicationIdText
                    );


            LocalDate inspectionDate =
                    LocalDate.parse(
                            inspectionDateText
                    );


            LocalTime inspectionTime =
                    LocalTime.parse(
                            inspectionTimeText
                    );


            if (inspectionDate.isBefore(
                    LocalDate.now())) {

                redirectWithMessage(
                        request,
                        response,
                        applicationIdText,
                        "Inspection date cannot be in the past."
                );

                return;
            }


            long officerDepartmentId =
                    ((Number)
                    session.getAttribute(
                            "departmentId"
                    )).longValue();


            long officerProfileId =
                    ((Number)
                    session.getAttribute(
                            "officerProfileId"
                    )).longValue();


            /*
             * Notification ke liye values
             */
            long entrepreneurUserId = 0;

            String applicationNumber = null;


            /*
             * =================================================
             * 4. DATABASE TRANSACTION
             * =================================================
             */

            try (
                Connection connection =
                        DBConnection.getConnection()
            ) {

                connection.setAutoCommit(false);


                try {

                    long applicationDepartmentId;

                    Long assignedOfficerId =
                            null;

                    String currentStatus;


                    /*
                     * -----------------------------------------
                     * LOAD APPLICATION
                     * -----------------------------------------
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

                            if (!resultSet.next()) {

                                connection.rollback();


                                response.sendError(
                                        HttpServletResponse.SC_NOT_FOUND,
                                        "Application not found."
                                );

                                return;
                            }


                            entrepreneurUserId =
                                    resultSet.getLong(
                                            "user_id"
                                    );


                            applicationNumber =
                                    resultSet.getString(
                                            "application_number"
                                    );


                            applicationDepartmentId =
                                    resultSet.getLong(
                                            "department_id"
                                    );


                            long assignedValue =
                                    resultSet.getLong(
                                            "assigned_officer_id"
                                    );


                            if (!resultSet.wasNull()) {

                                assignedOfficerId =
                                        assignedValue;
                            }


                            currentStatus =
                                    resultSet.getString(
                                            "current_status"
                                    );
                        }
                    }


                    /*
                     * -----------------------------------------
                     * DEPARTMENT SECURITY
                     * -----------------------------------------
                     */

                    if (applicationDepartmentId
                            != officerDepartmentId) {

                        connection.rollback();


                        response.sendError(
                                HttpServletResponse.SC_FORBIDDEN,
                                "You cannot schedule an inspection for another department."
                        );

                        return;
                    }


                    /*
                     * -----------------------------------------
                     * OFFICER SECURITY
                     * -----------------------------------------
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
                     * -----------------------------------------
                     * STATUS SECURITY
                     * -----------------------------------------
                     */

                    if (!"UNDER_REVIEW"
                            .equalsIgnoreCase(
                                    currentStatus
                            )) {

                        connection.rollback();


                        redirectWithMessage(
                                request,
                                response,
                                applicationIdText,
                                "Inspection can only be scheduled while the application is under review."
                        );

                        return;
                    }


                    /*
                     * -----------------------------------------
                     * DUPLICATE ACTIVE INSPECTION CHECK
                     * -----------------------------------------
                     */

                    try (
                        PreparedStatement statement =
                                connection.prepareStatement(
                                        FIND_ACTIVE_INSPECTION
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

                                connection.rollback();


                                redirectWithMessage(
                                        request,
                                        response,
                                        applicationIdText,
                                        "An active inspection is already scheduled for this application."
                                );

                                return;
                            }
                        }
                    }


                    /*
                     * -----------------------------------------
                     * INSERT INSPECTION
                     * -----------------------------------------
                     */

                    try (
                        PreparedStatement statement =
                                connection.prepareStatement(
                                        INSERT_INSPECTION
                                )
                    ) {

                        statement.setLong(
                                1,
                                applicationId
                        );


                        statement.setString(
                                2,
                                inspectionType
                        );


                        statement.setLong(
                                3,
                                officerDepartmentId
                        );


                        statement.setLong(
                                4,
                                officerProfileId
                        );


                        statement.setDate(
                                5,
                                Date.valueOf(
                                        inspectionDate
                                )
                        );


                        statement.setTime(
                                6,
                                Time.valueOf(
                                        inspectionTime
                                )
                        );


                        statement.setString(
                                7,
                                location
                        );


                        statement.setString(
                                8,
                                remarks
                        );


                        statement.executeUpdate();
                    }


                    /*
                     * -----------------------------------------
                     * COMMIT INSPECTION
                     * -----------------------------------------
                     */

                    connection.commit();


                } catch (Exception e) {

                    connection.rollback();

                    throw e;


                } finally {

                    connection.setAutoCommit(true);
                }
            }


            /*
             * =================================================
             * 5. CREATE ENTREPRENEUR NOTIFICATION
             * =================================================
             *
             * Inspection already commit ho chuki hai.
             * Notification fail hone par inspection rollback
             * nahi hogi.
             */

            try {

                notificationService
                        .notifyInspectionScheduled(
                                entrepreneurUserId,
                                applicationId,
                                applicationNumber,
                                inspectionDate.toString()
                        );


            } catch (SQLException e) {

                log(
                        "Inspection was scheduled successfully, "
                        + "but notification could not be created.",
                        e
                );
            }


            /*
             * =================================================
             * 6. SUCCESS REDIRECT
             * =================================================
             */

            response.sendRedirect(
                    request.getContextPath()
                    + "/officer/application-review?id="
                    + applicationId
                    + "&success=inspection-scheduled"
            );


        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid Application ID."
            );


        } catch (java.time.format.DateTimeParseException e) {

            redirectWithMessage(
                    request,
                    response,
                    applicationIdText,
                    "Invalid inspection date or time."
            );


        } catch (SQLException e) {

            log(
                    "Unable to schedule inspection.",
                    e
            );


            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to schedule inspection."
            );
        }
    }


    /*
     * =========================================================
     * ERROR REDIRECT HELPER
     * =========================================================
     */

    private void redirectWithMessage(
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