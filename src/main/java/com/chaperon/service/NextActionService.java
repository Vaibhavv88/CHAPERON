package com.chaperon.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.chaperon.model.NextAction;
import com.chaperon.util.DBConnection;

public class NextActionService {

    /*
     * =========================================================
     * PUBLIC METHOD
     * =========================================================
     */

    public NextAction getNextAction(
            long userId
    ) throws SQLException {

        NextAction action;

        /*
         * =====================================================
         * PRIORITY ORDER
         * =====================================================
         *
         * 1. Complete Business Profile
         * 2. Respond To Officer Query
         * 3. Fix Rejected / Expired Document
         * 4. Review Draft Application
         * 5. Prepare For Inspection
         * 6. Start Required Not-Started Approval
         * 7. Handle Renewal
         * 8. Generate Approval Roadmap
         * 9. Track Active Application
         * 10. All Caught Up
         *
         * =====================================================
         */


        /*
         * -----------------------------------------------------
         * 1. BUSINESS PROFILE
         * -----------------------------------------------------
         */

        action =
                checkBusinessProfile(
                        userId
                );

        if (action != null) {
            return action;
        }


        /*
         * -----------------------------------------------------
         * 2. OPEN OFFICER QUERY
         * -----------------------------------------------------
         */

        action =
                checkOpenQuery(
                        userId
                );

        if (action != null) {
            return action;
        }


        /*
         * -----------------------------------------------------
         * 3. DOCUMENT ISSUE
         * -----------------------------------------------------
         */

        action =
                checkDocumentIssue(
                        userId
                );

        if (action != null) {
            return action;
        }


        /*
         * -----------------------------------------------------
         * 4. DRAFT APPLICATION
         * -----------------------------------------------------
         */

        action =
                checkDraftApplication(
                        userId
                );

        if (action != null) {
            return action;
        }


        /*
         * -----------------------------------------------------
         * 5. INSPECTION
         * -----------------------------------------------------
         */

        action =
                checkScheduledInspection(
                        userId
                );

        if (action != null) {
            return action;
        }


        /*
         * -----------------------------------------------------
         * 6. RECOMMENDED APPROVAL NOT STARTED
         * -----------------------------------------------------
         */

        action =
                checkNotStartedApproval(
                        userId
                );

        if (action != null) {
            return action;
        }


        /*
         * -----------------------------------------------------
         * 7. UPCOMING RENEWAL
         * -----------------------------------------------------
         */

        action =
                checkUpcomingRenewal(
                        userId
                );

        if (action != null) {
            return action;
        }


        /*
         * -----------------------------------------------------
         * 8. APPROVAL ROADMAP NOT GENERATED
         * -----------------------------------------------------
         */

        action =
                checkApprovalRoadmap(
                        userId
                );

        if (action != null) {
            return action;
        }


        /*
         * -----------------------------------------------------
         * 9. TRACK ACTIVE APPLICATION
         * -----------------------------------------------------
         */

        action =
                checkExistingApplication(
                        userId
                );

        if (action != null) {
            return action;
        }


        /*
         * -----------------------------------------------------
         * 10. NOTHING URGENT
         * -----------------------------------------------------
         */

        return new NextAction(
                "ALL_CAUGHT_UP",
                "You're All Caught Up",
                "There is no urgent action required right now. "
                        + "You can continue monitoring your approval "
                        + "and compliance journey.",
                "View Applications",
                "/entrepreneur/my-applications",
                "LOW",
                null,
                null
        );
    }


    /*
     * =========================================================
     * BUSINESS PROFILE
     * =========================================================
     */

    private NextAction checkBusinessProfile(
            long userId
    ) throws SQLException {

        String sql = """
                SELECT
                    business_id,
                    profile_completed,
                    completion_percentage
                FROM business_onboarding_progress
                WHERE user_id = ?
                ORDER BY updated_at DESC
                LIMIT 1
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(sql)
        ) {

            ps.setLong(
                    1,
                    userId
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {

                /*
                 * No business onboarding record.
                 */

                if (!rs.next()) {

                    return new NextAction(
                            "COMPLETE_PROFILE",
                            "Complete Your Business Profile",
                            "CHAPERON needs your business details "
                                    + "before it can generate personalised "
                                    + "regulatory approvals.",
                            "Complete Business Profile",
                            "/entrepreneur/business-onboarding",
                            "HIGH",
                            "BUSINESS",
                            null
                    );
                }


                boolean profileCompleted =
                        rs.getBoolean(
                                "profile_completed"
                        );


                int completionPercentage =
                        rs.getInt(
                                "completion_percentage"
                        );


                long businessId =
                        rs.getLong(
                                "business_id"
                        );


                if (!profileCompleted ||
                    completionPercentage < 100) {

                    return new NextAction(
                            "COMPLETE_PROFILE",
                            "Complete Your Business Profile",
                            "Your business profile is "
                                    + completionPercentage
                                    + "% complete. Finish the remaining "
                                    + "details so CHAPERON can generate "
                                    + "accurate regulatory guidance.",
                            "Continue Business Profile",
                            "/entrepreneur/business-onboarding",
                            "HIGH",
                            "BUSINESS",
                            businessId
                    );
                }
            }
        }

        return null;
    }


    /*
     * =========================================================
     * OPEN OFFICER QUERY
     * =========================================================
     */

    private NextAction checkOpenQuery(
            long userId
    ) throws SQLException {

        String sql = """
                SELECT
                    q.query_id,
                    q.application_id,
                    q.query_description,
                    q.response_deadline,
                    a.application_number
                FROM application_queries q

                INNER JOIN applications a
                    ON a.application_id = q.application_id

                WHERE a.user_id = ?
                  AND q.status = 'OPEN'

                ORDER BY
                    CASE
                        WHEN q.response_deadline IS NULL
                            THEN 1
                        ELSE 0
                    END,
                    q.response_deadline ASC,
                    q.query_id ASC

                LIMIT 1
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(sql)
        ) {

            ps.setLong(
                    1,
                    userId
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {

                if (rs.next()) {

                    long queryId =
                            rs.getLong(
                                    "query_id"
                            );


                    long applicationId =
                            rs.getLong(
                                    "application_id"
                            );


                    String applicationNumber =
                            rs.getString(
                                    "application_number"
                            );


                    String queryDescription =
                            rs.getString(
                                    "query_description"
                            );


                    String description =
                            "An officer has raised a query for application "
                                    + applicationNumber
                                    + ".";


                    if (queryDescription != null &&
                        !queryDescription.isBlank()) {

                        description +=
                                " "
                                + queryDescription;
                    }


                    description +=
                            " Respond to the officer to keep "
                            + "the application moving.";


                    return new NextAction(
                            "RESPOND_TO_QUERY",
                            "Officer Response Required",
                            description,
                            "Respond to Query",
                            "/entrepreneur/application-details?id="
                                    + applicationId,
                            "HIGH",
                            "QUERY",
                            queryId
                    );
                }
            }
        }

        return null;
    }


    /*
     * =========================================================
     * DOCUMENT ISSUE
     * =========================================================
     */

    private NextAction checkDocumentIssue(
            long userId
    ) throws SQLException {

        String sql = """
                SELECT
                    document_id,
                    document_type,
                    verification_status
                FROM documents
                WHERE user_id = ?
                  AND verification_status IN (
                      'REJECTED',
                      'EXPIRED'
                  )
                ORDER BY document_id DESC
                LIMIT 1
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(sql)
        ) {

            ps.setLong(
                    1,
                    userId
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {

                if (rs.next()) {

                    long documentId =
                            rs.getLong(
                                    "document_id"
                            );


                    String documentType =
                            rs.getString(
                                    "document_type"
                            );


                    String documentStatus =
                            rs.getString(
                                    "verification_status"
                            );


                    if (documentType == null ||
                        documentType.isBlank()) {

                        documentType =
                                "A document";
                    }


                    return new NextAction(
                            "UPLOAD_DOCUMENT",
                            "Document Attention Required",
                            documentType
                                    + " is marked as "
                                    + documentStatus
                                    + ". Replace or upload a valid "
                                    + "document before continuing.",
                            "Open Document Vault",
                            "/entrepreneur/documents",
                            "HIGH",
                            "DOCUMENT",
                            documentId
                    );
                }
            }
        }

        return null;
    }


    /*
     * =========================================================
     * DRAFT APPLICATION
     * =========================================================
     */

    private NextAction checkDraftApplication(
            long userId
    ) throws SQLException {

        String sql = """
                SELECT
                    application_id,
                    application_number
                FROM applications
                WHERE user_id = ?
                  AND current_status = 'DRAFT'
                ORDER BY updated_at ASC
                LIMIT 1
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(sql)
        ) {

            ps.setLong(
                    1,
                    userId
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {

                if (rs.next()) {

                    long applicationId =
                            rs.getLong(
                                    "application_id"
                            );


                    String applicationNumber =
                            rs.getString(
                                    "application_number"
                            );


                    return new NextAction(
                            "SUBMIT_APPLICATION",
                            "Complete Your Draft Application",
                            "Application "
                                    + applicationNumber
                                    + " is currently in draft. "
                                    + "Review its readiness and complete "
                                    + "the remaining requirements.",
                            "Review Draft",
                            "/entrepreneur/application-details?id="
                                    + applicationId,
                            "MEDIUM",
                            "APPLICATION",
                            applicationId
                    );
                }
            }
        }

        return null;
    }


    /*
     * =========================================================
     * SCHEDULED INSPECTION
     * =========================================================
     */

    private NextAction checkScheduledInspection(
            long userId
    ) throws SQLException {

        String sql = """
                SELECT
                    i.inspection_id,
                    i.application_id,
                    i.inspection_date,
                    i.status,
                    a.application_number
                FROM inspections i

                INNER JOIN applications a
                    ON a.application_id = i.application_id

                WHERE a.user_id = ?
                  AND i.status IN (
                      'SCHEDULED',
                      'RESCHEDULED'
                  )

                ORDER BY
                    i.inspection_date ASC,
                    i.inspection_id ASC

                LIMIT 1
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(sql)
        ) {

            ps.setLong(
                    1,
                    userId
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {

                if (rs.next()) {

                    long inspectionId =
                            rs.getLong(
                                    "inspection_id"
                            );


                    String applicationNumber =
                            rs.getString(
                                    "application_number"
                            );


                    return new NextAction(
                            "VIEW_INSPECTION",
                            "Prepare for Your Scheduled Inspection",
                            "An inspection is scheduled for application "
                                    + applicationNumber
                                    + ". Review the inspection details "
                                    + "and prepare the required records "
                                    + "or premises.",
                            "View Inspection",
                            "/entrepreneur/inspections",
                            "MEDIUM",
                            "INSPECTION",
                            inspectionId
                    );
                }
            }
        }

        return null;
    }


    /*
     * =========================================================
     * NOT STARTED RECOMMENDED APPROVAL
     * =========================================================
     *
     * This is the important missing rule.
     *
     * business_approvals contains:
     *
     * requirement_status
     * priority_level
     * reason_text
     * current_status
     * mandatory
     *
     * When current_status is NOT_STARTED and no active
     * application exists for the same business + approval,
     * CHAPERON should guide the entrepreneur to start it.
     *
     * =========================================================
     */

    private NextAction checkNotStartedApproval(
            long userId
    ) throws SQLException {

        String sql = """
                SELECT
                    ba.business_approval_id,
                    ba.business_id,
                    ba.approval_id,
                    ba.requirement_status,
                    ba.priority_level,
                    ba.reason_text,
                    ba.current_status,
                    ba.mandatory,

                    ap.approval_name,
                    ap.approval_code

                FROM business_approvals ba

                INNER JOIN businesses b
                    ON b.business_id = ba.business_id

                INNER JOIN approvals ap
                    ON ap.approval_id = ba.approval_id

                WHERE b.user_id = ?

                  AND UPPER(
                        REPLACE(
                            COALESCE(
                                ba.current_status,
                                'NOT_STARTED'
                            ),
                            ' ',
                            '_'
                        )
                      ) = 'NOT_STARTED'

                  AND NOT EXISTS (

                        SELECT 1

                        FROM applications a

                        WHERE a.user_id = ?
                          AND a.business_id = ba.business_id
                          AND a.approval_id = ba.approval_id
                          AND a.current_status <> 'REJECTED'
                  )

                ORDER BY

                    CASE
                        WHEN UPPER(
                                COALESCE(
                                    ba.requirement_status,
                                    ''
                                )
                             ) = 'REQUIRED'
                            THEN 0

                        WHEN ba.mandatory = 1
                            THEN 1

                        ELSE 2
                    END,

                    CASE
                        WHEN UPPER(
                                COALESCE(
                                    ba.priority_level,
                                    ''
                                )
                             ) = 'HIGH'
                            THEN 0

                        WHEN UPPER(
                                COALESCE(
                                    ba.priority_level,
                                    ''
                                )
                             ) = 'MEDIUM'
                            THEN 1

                        WHEN UPPER(
                                COALESCE(
                                    ba.priority_level,
                                    ''
                                )
                             ) = 'LOW'
                            THEN 2

                        ELSE 3
                    END,

                    ba.business_approval_id ASC

                LIMIT 1
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(sql)
        ) {

            ps.setLong(
                    1,
                    userId
            );

            ps.setLong(
                    2,
                    userId
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {

                if (rs.next()) {

                    long businessApprovalId =
                            rs.getLong(
                                    "business_approval_id"
                            );


                    String approvalName =
                            rs.getString(
                                    "approval_name"
                            );


                    String approvalCode =
                            rs.getString(
                                    "approval_code"
                            );


                    String requirementStatus =
                            rs.getString(
                                    "requirement_status"
                            );


                    String priorityLevel =
                            rs.getString(
                                    "priority_level"
                            );


                    String reasonText =
                            rs.getString(
                                    "reason_text"
                            );


                    boolean mandatory =
                            rs.getBoolean(
                                    "mandatory"
                            );


                    /*
                     * -----------------------------------------
                     * Safe Approval Name
                     * -----------------------------------------
                     */

                    if (approvalName == null ||
                        approvalName.isBlank()) {

                        approvalName =
                                "Recommended Approval";
                    }


                    /*
                     * -----------------------------------------
                     * Priority
                     * -----------------------------------------
                     */

                    String priority =
                            normalizePriority(
                                    priorityLevel
                            );


                    /*
                     * REQUIRED or MANDATORY should never
                     * become LOW priority on next-action UI.
                     */

                    if ("REQUIRED".equalsIgnoreCase(
                            requirementStatus
                        ) ||
                        mandatory) {

                        if ("LOW".equals(priority)) {

                            priority =
                                    "MEDIUM";
                        }
                    }


                    /*
                     * -----------------------------------------
                     * Description
                     * -----------------------------------------
                     */

                    StringBuilder description =
                            new StringBuilder();


                    if ("REQUIRED".equalsIgnoreCase(
                            requirementStatus
                        )) {

                        description.append(
                                "This approval is required "
                                + "for your business"
                        );

                    } else {

                        description.append(
                                "This approval is recommended "
                                + "for your business"
                        );
                    }


                    if (approvalCode != null &&
                        !approvalCode.isBlank()) {

                        description.append(
                                " ("
                        );

                        description.append(
                                approvalCode
                        );

                        description.append(
                                ")"
                        );
                    }


                    description.append(
                            " and has not been started yet."
                    );


                    if (reasonText != null &&
                        !reasonText.isBlank()) {

                        description.append(
                                " "
                        );

                        description.append(
                                reasonText
                        );
                    }


                    /*
                     * -----------------------------------------
                     * Return Next Action
                     * -----------------------------------------
                     */

                    return new NextAction(
                            "START_APPROVAL",
                            "Start "
                                    + approvalName,
                            description.toString(),
                            "Open Approval Roadmap",
                            "/entrepreneur/generate-approvals",
                            priority,
                            "BUSINESS_APPROVAL",
                            businessApprovalId
                    );
                }
            }
        }

        return null;
    }


    /*
     * =========================================================
     * UPCOMING RENEWAL
     * =========================================================
     */

    private NextAction checkUpcomingRenewal(
            long userId
    ) throws SQLException {

        String sql = """
                SELECT
                    rr.reminder_id,
                    rr.certificate_id,
                    rr.reminder_days_before,
                    rr.reminder_date,

                    ac.application_id,
                    ac.approval_number,

                    a.application_number

                FROM renewal_reminders rr

                INNER JOIN approval_certificates ac
                    ON ac.certificate_id = rr.certificate_id

                INNER JOIN applications a
                    ON a.application_id = ac.application_id

                WHERE a.user_id = ?
                  AND rr.status = 'PENDING'

                ORDER BY
                    rr.reminder_date ASC,
                    rr.reminder_id ASC

                LIMIT 1
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(sql)
        ) {

            ps.setLong(
                    1,
                    userId
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {

                if (rs.next()) {

                    long reminderId =
                            rs.getLong(
                                    "reminder_id"
                            );


                    int reminderDaysBefore =
                            rs.getInt(
                                    "reminder_days_before"
                            );


                    String applicationNumber =
                            rs.getString(
                                    "application_number"
                            );


                    String approvalNumber =
                            rs.getString(
                                    "approval_number"
                            );


                    String reference =
                            applicationNumber;


                    if (approvalNumber != null &&
                        !approvalNumber.isBlank()) {

                        reference =
                                approvalNumber;
                    }


                    String priority =
                            reminderDaysBefore <= 30
                                    ? "HIGH"
                                    : "MEDIUM";


                    return new NextAction(
                            "RENEW_APPROVAL",
                            "Upcoming Renewal Requires Attention",
                            "Approval "
                                    + reference
                                    + " has an upcoming renewal requirement. "
                                    + "Review its validity and renewal "
                                    + "requirements to avoid a compliance gap.",
                            "View Compliance",
                            "/entrepreneur/compliance",
                            priority,
                            "RENEWAL",
                            reminderId
                    );
                }
            }
        }

        return null;
    }


    /*
     * =========================================================
     * APPROVAL ROADMAP
     * =========================================================
     */

    private NextAction checkApprovalRoadmap(
            long userId
    ) throws SQLException {

        String sql = """
                SELECT
                    COUNT(*) AS total
                FROM business_approvals ba

                INNER JOIN businesses b
                    ON b.business_id = ba.business_id

                WHERE b.user_id = ?
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(sql)
        ) {

            ps.setLong(
                    1,
                    userId
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {

                if (rs.next()) {

                    int total =
                            rs.getInt(
                                    "total"
                            );


                    if (total == 0) {

                        return new NextAction(
                                "GENERATE_APPROVALS",
                                "Generate Your Approval Roadmap",
                                "Your business profile is ready. "
                                        + "Generate a personalised list "
                                        + "of applicable registrations, "
                                        + "licences, NOCs and approvals.",
                                "Generate Approval Roadmap",
                                "/entrepreneur/generate-approvals",
                                "MEDIUM",
                                "BUSINESS",
                                null
                        );
                    }
                }
            }
        }

        return null;
    }


    /*
     * =========================================================
     * TRACK ACTIVE APPLICATION
     * =========================================================
     */

    private NextAction checkExistingApplication(
            long userId
    ) throws SQLException {

        String sql = """
                SELECT
                    application_id,
                    application_number,
                    current_status
                FROM applications

                WHERE user_id = ?

                  AND current_status NOT IN (
                      'APPROVED',
                      'REJECTED',
                      'DRAFT'
                  )

                ORDER BY updated_at DESC

                LIMIT 1
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(sql)
        ) {

            ps.setLong(
                    1,
                    userId
            );

            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {

                if (rs.next()) {

                    long applicationId =
                            rs.getLong(
                                    "application_id"
                            );


                    String applicationNumber =
                            rs.getString(
                                    "application_number"
                            );


                    String status =
                            rs.getString(
                                    "current_status"
                            );


                    return new NextAction(
                            "TRACK_APPLICATION",
                            "Track Your Approval Journey",
                            "Application "
                                    + applicationNumber
                                    + " is currently at "
                                    + formatStatus(status)
                                    + ". Review the application timeline "
                                    + "for the latest progress.",
                            "Track Application",
                            "/entrepreneur/application-details?id="
                                    + applicationId,
                            "LOW",
                            "APPLICATION",
                            applicationId
                    );
                }
            }
        }

        return null;
    }


    /*
     * =========================================================
     * PRIORITY NORMALISATION
     * =========================================================
     */

    private String normalizePriority(
            String priority
    ) {

        if (priority == null ||
            priority.isBlank()) {

            return "MEDIUM";
        }


        String normalized =
                priority
                        .trim()
                        .toUpperCase();


        if ("HIGH".equals(normalized)) {
            return "HIGH";
        }


        if ("LOW".equals(normalized)) {
            return "LOW";
        }


        return "MEDIUM";
    }


    /*
     * =========================================================
     * STATUS FORMATTER
     * =========================================================
     */

    private String formatStatus(
            String status
    ) {

        if (status == null ||
            status.isBlank()) {

            return "Unknown Status";
        }


        String formatted =
                status
                        .replace(
                                '_',
                                ' '
                        )
                        .toLowerCase();


        String[] words =
                formatted.split(
                        " "
                );


        StringBuilder builder =
                new StringBuilder();


        for (String word : words) {

            if (word == null ||
                word.isBlank()) {

                continue;
            }


            builder.append(
                    Character.toUpperCase(
                            word.charAt(0)
                    )
            );


            if (word.length() > 1) {

                builder.append(
                        word.substring(1)
                );
            }


            builder.append(
                    " "
            );
        }


        return builder
                .toString()
                .trim();
    }
}