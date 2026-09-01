package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

import com.chaperon.service.NotificationService;
import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/officer/approve-application")
public class ApproveApplicationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     * Application + Approval information.
     *
     * user_id and application_number are also loaded
     * because they are required for entrepreneur notification.
     */
    private static final String FIND_APPLICATION =

            "SELECT " +
            "ap.application_id, " +
            "ap.application_number, " +
            "ap.user_id, " +
            "ap.department_id, " +
            "ap.assigned_officer_id, " +
            "ap.current_status, " +

            "a.approval_code, " +
            "a.validity_type, " +
            "a.validity_value " +

            "FROM applications ap " +

            "JOIN approvals a " +
            "ON ap.approval_id = a.approval_id " +

            "WHERE ap.application_id = ? " +
            "LIMIT 1";


    /*
     * Approval tabhi allowed hoga jab
     * koi OPEN ya RESPONDED query pending na ho.
     */
    private static final String FIND_PENDING_QUERY =

            "SELECT COUNT(*) " +
            "FROM application_queries " +
            "WHERE application_id = ? " +
            "AND status IN ('OPEN', 'RESPONDED')";


    /*
     * Application ko APPROVED mark karega.
     */
    private static final String APPROVE_APPLICATION =

            "UPDATE applications " +
            "SET current_status = 'APPROVED', " +
            "officer_remarks = ?, " +
            "rejection_reason = NULL, " +
            "rejected_by = NULL, " +
            "rejected_at = NULL, " +
            "updated_at = CURRENT_TIMESTAMP " +
            "WHERE application_id = ? " +
            "AND current_status = 'UNDER_REVIEW'";


    /*
     * Successful approval ke baad
     * approval certificate create hoga.
     */
    private static final String INSERT_CERTIFICATE =

            "INSERT INTO approval_certificates (" +
            "application_id, " +
            "approval_number, " +
            "approved_by, " +
            "approval_date, " +
            "valid_from, " +
            "valid_until, " +
            "remarks" +
            ") VALUES (?, ?, ?, ?, ?, ?, ?)";


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        /*
         * ==========================================
         * 1. OFFICER SESSION CHECK
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
         * 2. GET PARAMETERS
         * ==========================================
         */

        String applicationIdParameter =
                request.getParameter("applicationId");

        String remarks =
                request.getParameter("remarks");


        /*
         * Application ID required hai.
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
         * Remarks optional hain.
         * Lekin agar hain to maximum 2000 characters.
         */
        if (remarks != null) {

            remarks = remarks.trim();

            if (remarks.length() > 2000) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Remarks are too long."
                );

                return;
            }
        }


        try {

            /*
             * Application ID String se long me.
             */
            long applicationId =
                    Long.parseLong(
                            applicationIdParameter
                    );


            /*
             * approved_by column users.user_id ko
             * reference karta hai.
             */
            long officerUserId =
                    ((Number)
                    session.getAttribute("userId"))
                    .longValue();


            /*
             * assigned_officer_id
             * officer_profiles.officer_profile_id hai.
             */
            long officerProfileId =
                    ((Number)
                    session.getAttribute(
                            "officerProfileId"
                    )).longValue();


            /*
             * Officer kis department ka hai.
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
                 * Approval + certificate creation ek
                 * transaction me hoga.
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
                     * NEW:
                     * Notification ke liye entrepreneur
                     * user id aur application number.
                     */
                    long entrepreneurUserId;

                    String applicationNumber;


                    String currentStatus;

                    String approvalCode;

                    String validityType;

                    Integer validityValue = null;


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
                             * NOTIFICATION INFORMATION
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
                             * Current application status.
                             */
                            currentStatus =
                                    resultSet.getString(
                                            "current_status"
                                    );


                            /*
                             * Approval code.
                             */
                            approvalCode =
                                    resultSet.getString(
                                            "approval_code"
                                    );


                            /*
                             * Validity type.
                             */
                            validityType =
                                    resultSet.getString(
                                            "validity_type"
                                    );


                            /*
                             * Validity value.
                             */
                            int validityValueResult =
                                    resultSet.getInt(
                                            "validity_value"
                                    );

                            if (!resultSet.wasNull()) {

                                validityValue =
                                        validityValueResult;
                            }
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
                                "You cannot approve another department's application."
                        );

                        return;
                    }


                    /*
                     * ==================================
                     * 5. ASSIGNED OFFICER CHECK
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
                     * approve ho sakti hai.
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
                                + "&message=Only an application under review can be approved."
                        );

                        return;
                    }


                    /*
                     * ==================================
                     * 7. PENDING QUERY CHECK
                     * ==================================
                     */

                    int pendingQueries = 0;


                    try (
                        PreparedStatement statement =
                                connection.prepareStatement(
                                        FIND_PENDING_QUERY
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

                                pendingQueries =
                                        resultSet.getInt(1);
                            }
                        }
                    }


                    /*
                     * OPEN / RESPONDED query pending hai
                     * to approval nahi hoga.
                     */
                    if (pendingQueries > 0) {

                        connection.rollback();

                        response.sendRedirect(
                                request.getContextPath()
                                + "/officer/application-review?id="
                                + applicationId
                                + "&message=Resolve all pending queries before approving this application."
                        );

                        return;
                    }


                    /*
                     * ==================================
                     * 8. APPROVAL DATE + VALIDITY
                     * ==================================
                     */

                    LocalDate approvalDate =
                            LocalDate.now();


                    LocalDate validFrom =
                            approvalDate;


                    LocalDate validUntil =
                            calculateValidUntil(
                                    approvalDate,
                                    validityType,
                                    validityValue
                            );


                    /*
                     * ==================================
                     * 9. GENERATE APPROVAL NUMBER
                     * ==================================
                     */

                    String safeApprovalCode =
                            approvalCode != null &&
                            !approvalCode.isBlank()

                            ? approvalCode
                                    .replaceAll(
                                            "[^A-Za-z0-9]",
                                            ""
                                    )
                                    .toUpperCase()

                            : "APPROVAL";


                    /*
                     * Example:
                     *
                     * CHP-FIRENOC-2026-000003
                     */
                    String approvalNumber =
                            "CHP-"
                            + safeApprovalCode
                            + "-"
                            + approvalDate.getYear()
                            + "-"
                            + String.format(
                                    "%06d",
                                    applicationId
                            );


                    /*
                     * ==================================
                     * 10. INSERT CERTIFICATE
                     * ==================================
                     */

                    try (
                        PreparedStatement statement =
                                connection.prepareStatement(
                                        INSERT_CERTIFICATE
                                )
                    ) {

                        /*
                         * application_id
                         */
                        statement.setLong(
                                1,
                                applicationId
                        );


                        /*
                         * approval_number
                         */
                        statement.setString(
                                2,
                                approvalNumber
                        );


                        /*
                         * approved_by
                         * users.user_id
                         */
                        statement.setLong(
                                3,
                                officerUserId
                        );


                        /*
                         * approval_date
                         */
                        statement.setDate(
                                4,
                                Date.valueOf(
                                        approvalDate
                                )
                        );


                        /*
                         * valid_from
                         */
                        statement.setDate(
                                5,
                                Date.valueOf(
                                        validFrom
                                )
                        );


                        /*
                         * valid_until
                         */
                        if (validUntil != null) {

                            statement.setDate(
                                    6,
                                    Date.valueOf(
                                            validUntil
                                    )
                            );

                        } else {

                            statement.setNull(
                                    6,
                                    java.sql.Types.DATE
                            );
                        }


                        /*
                         * remarks
                         */
                        statement.setString(
                                7,
                                remarks
                        );


                        statement.executeUpdate();
                    }


                    /*
                     * ==================================
                     * 11. UPDATE APPLICATION
                     * ==================================
                     */

                    int updatedRows;


                    try (
                        PreparedStatement statement =
                                connection.prepareStatement(
                                        APPROVE_APPLICATION
                                )
                    ) {

                        statement.setString(
                                1,
                                remarks
                        );


                        statement.setLong(
                                2,
                                applicationId
                        );


                        updatedRows =
                                statement.executeUpdate();
                    }


                    /*
                     * Agar status kisi aur request ne
                     * change kar diya ho.
                     */
                    if (updatedRows == 0) {

                        connection.rollback();

                        response.sendError(
                                HttpServletResponse.SC_CONFLICT,
                                "Application status changed before approval."
                        );

                        return;
                    }


                    /*
                     * ==================================
                     * 12. COMMIT APPROVAL
                     * ==================================
                     */

                    connection.commit();


                    /*
                     * ==================================
                     * 13. CREATE APPROVAL NOTIFICATION
                     * ==================================
                     *
                     * IMPORTANT:
                     *
                     * Notification transaction commit
                     * hone ke BAAD create kar rahe hain.
                     *
                     * Notification fail hone par actual
                     * approval rollback nahi hoga.
                     */

                    try {

                        NotificationService notificationService =
                                new NotificationService();


                        notificationService
                                .notifyApplicationApproved(
                                        entrepreneurUserId,
                                        applicationId,
                                        applicationNumber
                                );


                    } catch (SQLException notificationException) {

                        log(
                                "Application approved successfully, "
                                + "but approval notification could not be created.",
                                notificationException
                        );
                    }


                    /*
                     * ==================================
                     * 14. REDIRECT
                     * ==================================
                     */

                    response.sendRedirect(
                            request.getContextPath()
                            + "/officer/application-review?id="
                            + applicationId
                            + "&success=application-approved"
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
                    "Unable to approve application.",
                    e
            );


            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to approve application."
            );
        }
    }


    /*
     * ==========================================
     * VALIDITY CALCULATION
     * ==========================================
     */

    private LocalDate calculateValidUntil(
            LocalDate validFrom,
            String validityType,
            Integer validityValue
    ) {

        /*
         * Validity type missing.
         */
        if (validityType == null) {

            return null;
        }


        /*
         * Permanent approval.
         */
        if ("PERMANENT"
                .equalsIgnoreCase(
                        validityType
                )) {

            return null;
        }


        /*
         * Condition change hone tak valid.
         */
        if ("UNTIL_CONDITION_CHANGES"
                .equalsIgnoreCase(
                        validityType
                )) {

            return null;
        }


        /*
         * Validity value missing / invalid.
         */
        if (validityValue == null ||
            validityValue <= 0) {

            return null;
        }


        /*
         * Days validity.
         */
        if ("DAYS"
                .equalsIgnoreCase(
                        validityType
                )) {

            return validFrom.plusDays(
                    validityValue
            );
        }


        /*
         * Months validity.
         */
        if ("MONTHS"
                .equalsIgnoreCase(
                        validityType
                )) {

            return validFrom.plusMonths(
                    validityValue
            );
        }


        /*
         * Years validity.
         */
        if ("YEARS"
                .equalsIgnoreCase(
                        validityType
                )) {

            return validFrom.plusYears(
                    validityValue
            );
        }


        return null;
    }
}