package com.chaperon.service;

import com.chaperon.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class NotificationService {

    private static final String INSERT_NOTIFICATION =
            "INSERT INTO notifications " +
            "(user_id, application_id, notification_type, title, message, action_url, is_read) " +
            "VALUES (?, ?, ?, ?, ?, ?, 0)";


    /*
     * =========================================================
     * GENERIC NOTIFICATION
     * =========================================================
     */

    public void createNotification(
            long userId,
            Long applicationId,
            String notificationType,
            String title,
            String message,
            String actionUrl)
            throws SQLException {


        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(
                             INSERT_NOTIFICATION)) {


            statement.setLong(
                    1,
                    userId
            );


            if (applicationId != null) {

                statement.setLong(
                        2,
                        applicationId
                );

            } else {

                statement.setNull(
                        2,
                        java.sql.Types.BIGINT
                );
            }


            statement.setString(
                    3,
                    notificationType
            );


            statement.setString(
                    4,
                    title
            );


            statement.setString(
                    5,
                    message
            );


            statement.setString(
                    6,
                    actionUrl
            );


            statement.executeUpdate();
        }
    }


    /*
     * =========================================================
     * QUERY RAISED
     * =========================================================
     */

    public void notifyQueryRaised(
            long userId,
            long applicationId,
            String applicationNumber)
            throws SQLException {


        createNotification(
                userId,
                applicationId,
                "QUERY_RAISED",
                "Officer Query Raised",
                "A government officer has raised a query for application "
                        + applicationNumber
                        + ". Please review the query and submit your response.",
                "/entrepreneur/application-details?id="
                        + applicationId
        );
    }


    /*
     * =========================================================
     * INSPECTION SCHEDULED
     * =========================================================
     */

    public void notifyInspectionScheduled(
            long userId,
            long applicationId,
            String applicationNumber,
            String inspectionDate)
            throws SQLException {


        String message =
                "An inspection has been scheduled for application "
                + applicationNumber;


        if (inspectionDate != null &&
            !inspectionDate.isBlank()) {

            message +=
                    " on "
                    + inspectionDate;
        }


        message +=
                ". Please check the inspection details.";


        createNotification(
                userId,
                applicationId,
                "INSPECTION_SCHEDULED",
                "Inspection Scheduled",
                message,
                "/entrepreneur/inspections"
        );
    }


    /*
     * =========================================================
     * APPLICATION APPROVED
     * =========================================================
     */

    public void notifyApplicationApproved(
            long userId,
            long applicationId,
            String applicationNumber)
            throws SQLException {


        createNotification(
                userId,
                applicationId,
                "APPLICATION_APPROVED",
                "Application Approved",
                "Congratulations. Your application "
                        + applicationNumber
                        + " has been approved. You can now view your approval certificate.",
                "/entrepreneur/application-details?id="
                        + applicationId
        );
    }


    /*
     * =========================================================
     * APPLICATION REJECTED
     * =========================================================
     */

    public void notifyApplicationRejected(
            long userId,
            long applicationId,
            String applicationNumber)
            throws SQLException {


        createNotification(
                userId,
                applicationId,
                "APPLICATION_REJECTED",
                "Application Rejected",
                "Your application "
                        + applicationNumber
                        + " has been rejected. Please review the rejection reason and next steps.",
                "/entrepreneur/application-details?id="
                        + applicationId
        );
    }


    /*
     * =========================================================
     * QUERY RESOLVED
     * =========================================================
     */

    public void notifyQueryResolved(
            long userId,
            long applicationId,
            String applicationNumber)
            throws SQLException {


        createNotification(
                userId,
                applicationId,
                "QUERY_RESOLVED",
                "Query Resolved",
                "The officer query related to application "
                        + applicationNumber
                        + " has been resolved and your application can continue in the approval process.",
                "/entrepreneur/application-details?id="
                        + applicationId
        );
    }


    /*
     * =========================================================
     * INSPECTION COMPLETED
     * =========================================================
     */

    public void notifyInspectionCompleted(
            long userId,
            long applicationId,
            String applicationNumber,
            String result)
            throws SQLException {


        String message =
                "The inspection for application "
                + applicationNumber
                + " has been completed.";


        if (result != null &&
            !result.isBlank()) {

            message +=
                    " Result: "
                    + result.replace("_", " ")
                    + ".";
        }


        createNotification(
                userId,
                applicationId,
                "INSPECTION_COMPLETED",
                "Inspection Completed",
                message,
                "/entrepreneur/inspections"
        );
    }


    /*
     * =========================================================
     * RENEWAL REMINDER
     * =========================================================
     */

    public void notifyRenewalReminder(
            long userId,
            long applicationId,
            String approvalName,
            int daysBefore)
            throws SQLException {


        createNotification(
                userId,
                applicationId,
                "RENEWAL_REMINDER",
                "Approval Renewal Reminder",
                approvalName
                        + " will require renewal soon. Approximately "
                        + daysBefore
                        + " day(s) remain before the configured renewal reminder period.",
                "/entrepreneur/compliance"
        );
    }


    /*
     * =========================================================
     * COMPLIANCE DUE
     * =========================================================
     */

    public void notifyComplianceDue(
            long userId,
            Long applicationId,
            String complianceName,
            String dueDate)
            throws SQLException {


        String message =
                "Compliance requirement \""
                + complianceName
                + "\" is due";


        if (dueDate != null &&
            !dueDate.isBlank()) {

            message +=
                    " on "
                    + dueDate;
        }


        message += ".";


        createNotification(
                userId,
                applicationId,
                "COMPLIANCE_DUE",
                "Compliance Due",
                message,
                "/entrepreneur/compliance"
        );
    }
}