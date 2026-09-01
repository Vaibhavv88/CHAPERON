package com.chaperon.controller;

import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/entrepreneur/compliance")
public class EntrepreneurComplianceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     * Load all approved certificates belonging to
     * the currently logged-in entrepreneur.
     */
    private static final String FIND_CERTIFICATES =
            "SELECT " +
            "ac.certificate_id, " +
            "ac.application_id, " +
            "ac.approval_number, " +
            "ac.approval_date, " +
            "ac.valid_from, " +
            "ac.valid_until, " +
            "ac.remarks AS certificate_remarks, " +

            "a.application_number, " +
            "a.business_id, " +
            "a.current_status AS application_status, " +

            "ap.approval_id, " +
            "ap.approval_name, " +
            "ap.approval_code, " +
            "ap.validity_type, " +
            "ap.validity_value, " +
            "ap.renewal_required, " +
            "ap.renewal_before_days, " +

            "d.department_name, " +
            "d.department_code, " +

            "b.business_name " +

            "FROM approval_certificates ac " +

            "INNER JOIN applications a " +
            "ON ac.application_id = a.application_id " +

            "INNER JOIN approvals ap " +
            "ON a.approval_id = ap.approval_id " +

            "INNER JOIN departments d " +
            "ON ap.department_id = d.department_id " +

            "INNER JOIN businesses b " +
            "ON a.business_id = b.business_id " +

            "WHERE a.user_id = ? " +

            "ORDER BY ac.approval_date DESC, " +
            "ac.certificate_id DESC";


    /*
     * Find compliance records for a business + approval.
     */
    private static final String FIND_COMPLIANCE =
            "SELECT " +
            "compliance_id, " +
            "compliance_name, " +
            "due_date, " +
            "status, " +
            "remarks, " +
            "created_at " +
            "FROM compliance_records " +
            "WHERE business_id = ? " +
            "AND approval_id = ? " +
            "ORDER BY due_date ASC, compliance_id DESC";


    /*
     * Find renewal reminders belonging to a certificate.
     */
    private static final String FIND_REMINDERS =
            "SELECT " +
            "reminder_id, " +
            "reminder_days_before, " +
            "reminder_date, " +
            "status, " +
            "notified, " +
            "created_at " +
            "FROM renewal_reminders " +
            "WHERE certificate_id = ? " +
            "ORDER BY reminder_days_before DESC";


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }


        Object userIdObject =
                session.getAttribute("userId");

        String userRole =
                (String)
                session.getAttribute("userRole");


        if (userIdObject == null ||
            userRole == null ||
            !"ENTREPRENEUR".equalsIgnoreCase(userRole)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }


        long userId =
                ((Number) userIdObject)
                .longValue();


        List<Map<String, Object>> complianceItems =
                new ArrayList<>();


        int totalApprovals = 0;
        int activeApprovals = 0;
        int expiringSoon = 0;
        int expiredApprovals = 0;
        int renewalRequired = 0;
        int pendingCompliance = 0;


        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_CERTIFICATES)) {


            statement.setLong(1, userId);


            try (ResultSet rs =
                         statement.executeQuery()) {


                while (rs.next()) {

                    Map<String, Object> item =
                            new HashMap<>();


                    long certificateId =
                            rs.getLong(
                                    "certificate_id"
                            );


                    long businessId =
                            rs.getLong(
                                    "business_id"
                            );


                    long approvalId =
                            rs.getLong(
                                    "approval_id"
                            );


                    Date validUntilSql =
                            rs.getDate(
                                    "valid_until"
                            );


                    LocalDate validUntil =
                            validUntilSql != null
                            ? validUntilSql.toLocalDate()
                            : null;


                    String validityStatus;
                    Long daysRemaining = null;


                    /*
                     * Calculate certificate status.
                     *
                     * No valid_until means that the
                     * certificate does not currently
                     * have a fixed expiry date.
                     */
                    if (validUntil == null) {

                        validityStatus =
                                "ACTIVE";

                    } else {

                        daysRemaining =
                                ChronoUnit.DAYS.between(
                                        LocalDate.now(),
                                        validUntil
                                );


                        if (daysRemaining < 0) {

                            validityStatus =
                                    "EXPIRED";

                        } else if (daysRemaining <= 90) {

                            validityStatus =
                                    "EXPIRING_SOON";

                        } else {

                            validityStatus =
                                    "ACTIVE";
                        }
                    }


                    boolean isRenewalRequired =
                            rs.getBoolean(
                                    "renewal_required"
                            );


                    /*
                     * Summary counters
                     */
                    totalApprovals++;


                    if ("EXPIRED".equals(
                            validityStatus)) {

                        expiredApprovals++;

                    } else if ("EXPIRING_SOON".equals(
                            validityStatus)) {

                        expiringSoon++;

                    } else {

                        activeApprovals++;
                    }


                    if (isRenewalRequired) {

                        renewalRequired++;
                    }


                    /*
                     * Basic certificate information
                     */
                    item.put(
                            "certificateId",
                            certificateId
                    );

                    item.put(
                            "applicationId",
                            rs.getLong(
                                    "application_id"
                            )
                    );

                    item.put(
                            "applicationNumber",
                            rs.getString(
                                    "application_number"
                            )
                    );

                    item.put(
                            "approvalNumber",
                            rs.getString(
                                    "approval_number"
                            )
                    );

                    item.put(
                            "approvalDate",
                            rs.getDate(
                                    "approval_date"
                            )
                    );

                    item.put(
                            "validFrom",
                            rs.getDate(
                                    "valid_from"
                            )
                    );

                    item.put(
                            "validUntil",
                            validUntilSql
                    );

                    item.put(
                            "certificateRemarks",
                            rs.getString(
                                    "certificate_remarks"
                            )
                    );


                    /*
                     * Approval information
                     */
                    item.put(
                            "approvalId",
                            approvalId
                    );

                    item.put(
                            "approvalName",
                            rs.getString(
                                    "approval_name"
                            )
                    );

                    item.put(
                            "approvalCode",
                            rs.getString(
                                    "approval_code"
                            )
                    );

                    item.put(
                            "validityType",
                            rs.getString(
                                    "validity_type"
                            )
                    );

                    item.put(
                            "validityValue",
                            rs.getObject(
                                    "validity_value"
                            )
                    );

                    item.put(
                            "renewalRequired",
                            isRenewalRequired
                    );

                    item.put(
                            "renewalBeforeDays",
                            rs.getObject(
                                    "renewal_before_days"
                            )
                    );


                    /*
                     * Department + business
                     */
                    item.put(
                            "departmentName",
                            rs.getString(
                                    "department_name"
                            )
                    );

                    item.put(
                            "departmentCode",
                            rs.getString(
                                    "department_code"
                            )
                    );

                    item.put(
                            "businessName",
                            rs.getString(
                                    "business_name"
                            )
                    );


                    /*
                     * Calculated information
                     */
                    item.put(
                            "validityStatus",
                            validityStatus
                    );

                    item.put(
                            "daysRemaining",
                            daysRemaining
                    );


                    /*
                     * Load compliance records
                     */
                    List<Map<String, Object>>
                            complianceRecords =
                            loadComplianceRecords(
                                    connection,
                                    businessId,
                                    approvalId
                            );


                    item.put(
                            "complianceRecords",
                            complianceRecords
                    );


                    for (Map<String, Object> record
                            : complianceRecords) {

                        String complianceStatus =
                                String.valueOf(
                                        record.get("status")
                                );


                        if (!"COMPLETED".equalsIgnoreCase(
                                complianceStatus)) {

                            pendingCompliance++;
                        }
                    }


                    /*
                     * Load renewal reminders
                     */
                    List<Map<String, Object>>
                            reminders =
                            loadRenewalReminders(
                                    connection,
                                    certificateId
                            );


                    item.put(
                            "renewalReminders",
                            reminders
                    );


                    complianceItems.add(item);
                }
            }


        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load compliance information.",
                    e
            );
        }


        /*
         * Send data to JSP
         */
        request.setAttribute(
                "complianceItems",
                complianceItems
        );

        request.setAttribute(
                "totalApprovals",
                totalApprovals
        );

        request.setAttribute(
                "activeApprovals",
                activeApprovals
        );

        request.setAttribute(
                "expiringSoon",
                expiringSoon
        );

        request.setAttribute(
                "expiredApprovals",
                expiredApprovals
        );

        request.setAttribute(
                "renewalRequired",
                renewalRequired
        );

        request.setAttribute(
                "pendingCompliance",
                pendingCompliance
        );


        request.getRequestDispatcher(
                "/WEB-INF/views/entrepreneur/compliance.jsp"
        ).forward(
                request,
                response
        );
    }


    /*
     * =========================================================
     * LOAD COMPLIANCE RECORDS
     * =========================================================
     */

    private List<Map<String, Object>>
            loadComplianceRecords(
                    Connection connection,
                    long businessId,
                    long approvalId)
            throws SQLException {


        List<Map<String, Object>> records =
                new ArrayList<>();


        try (PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_COMPLIANCE)) {


            statement.setLong(
                    1,
                    businessId
            );

            statement.setLong(
                    2,
                    approvalId
            );


            try (ResultSet rs =
                         statement.executeQuery()) {


                while (rs.next()) {

                    Map<String, Object> record =
                            new HashMap<>();


                    record.put(
                            "complianceId",
                            rs.getLong(
                                    "compliance_id"
                            )
                    );

                    record.put(
                            "complianceName",
                            rs.getString(
                                    "compliance_name"
                            )
                    );

                    record.put(
                            "dueDate",
                            rs.getDate(
                                    "due_date"
                            )
                    );

                    record.put(
                            "status",
                            rs.getString(
                                    "status"
                            )
                    );

                    record.put(
                            "remarks",
                            rs.getString(
                                    "remarks"
                            )
                    );

                    record.put(
                            "createdAt",
                            rs.getTimestamp(
                                    "created_at"
                            )
                    );


                    records.add(record);
                }
            }
        }


        return records;
    }


    /*
     * =========================================================
     * LOAD RENEWAL REMINDERS
     * =========================================================
     */

    private List<Map<String, Object>>
            loadRenewalReminders(
                    Connection connection,
                    long certificateId)
            throws SQLException {


        List<Map<String, Object>> reminders =
                new ArrayList<>();


        try (PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_REMINDERS)) {


            statement.setLong(
                    1,
                    certificateId
            );


            try (ResultSet rs =
                         statement.executeQuery()) {


                while (rs.next()) {

                    Map<String, Object> reminder =
                            new HashMap<>();


                    reminder.put(
                            "reminderId",
                            rs.getLong(
                                    "reminder_id"
                            )
                    );

                    reminder.put(
                            "reminderDaysBefore",
                            rs.getInt(
                                    "reminder_days_before"
                            )
                    );

                    reminder.put(
                            "reminderDate",
                            rs.getDate(
                                    "reminder_date"
                            )
                    );

                    reminder.put(
                            "status",
                            rs.getString(
                                    "status"
                            )
                    );

                    reminder.put(
                            "notified",
                            rs.getBoolean(
                                    "notified"
                            )
                    );

                    reminder.put(
                            "createdAt",
                            rs.getTimestamp(
                                    "created_at"
                            )
                    );


                    reminders.add(reminder);
                }
            }
        }


        return reminders;
    }
}