package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/explain-delay")
public class ExplainMyDelayServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("userId") == null
                || session.getAttribute("userRole") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }

        String role = String.valueOf(
                session.getAttribute("userRole")
        );

        if (!"ENTREPRENEUR".equalsIgnoreCase(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN
            );

            return;
        }

        long userId =
                ((Number) session.getAttribute("userId"))
                        .longValue();

        String applicationIdParam =
                request.getParameter("applicationId");

        if (applicationIdParam == null
                || applicationIdParam.isBlank()) {

            loadApplications(
                    userId,
                    request
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/explain-my-delay.jsp"
            ).forward(request, response);

            return;
        }

        try {

            long applicationId =
                    Long.parseLong(
                            applicationIdParam
                    );

            analyseApplication(
                    userId,
                    applicationId,
                    request
            );

            loadApplications(
                    userId,
                    request
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/explain-my-delay.jsp"
            ).forward(request, response);

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid application ID."
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to analyse application delay.",
                    e
            );
        }
    }

    private void loadApplications(
            long userId,
            HttpServletRequest request)
            throws ServletException {

        String sql = """
                SELECT
                    a.application_id,
                    a.application_number,
                    a.current_status,
                    a.expected_completion_date,
                    ap.approval_name
                FROM applications a
                INNER JOIN approvals ap
                    ON a.approval_id = ap.approval_id
                WHERE a.user_id = ?
                ORDER BY a.updated_at DESC
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

            ResultSet rs =
                    ps.executeQuery();

            java.util.List<java.util.Map<String, Object>>
                    applications =
                    new java.util.ArrayList<>();

            while (rs.next()) {

                java.util.Map<String, Object> row =
                        new java.util.HashMap<>();

                row.put(
                        "applicationId",
                        rs.getLong("application_id")
                );

                row.put(
                        "applicationNumber",
                        rs.getString("application_number")
                );

                row.put(
                        "approvalName",
                        rs.getString("approval_name")
                );

                row.put(
                        "currentStatus",
                        rs.getString("current_status")
                );

                row.put(
                        "expectedCompletionDate",
                        rs.getDate(
                                "expected_completion_date"
                        )
                );

                applications.add(row);
            }

            request.setAttribute(
                    "applications",
                    applications
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load applications.",
                    e
            );
        }
    }

    private void analyseApplication(
            long userId,
            long applicationId,
            HttpServletRequest request)
            throws SQLException {

        String sql = """
                SELECT
                    a.application_id,
                    a.application_number,
                    a.current_status,
                    a.submission_date,
                    a.expected_completion_date,
                    a.sla_days,
                    a.officer_remarks,
                    ap.approval_name,
                    d.department_name
                FROM applications a
                INNER JOIN approvals ap
                    ON a.approval_id = ap.approval_id
                INNER JOIN departments d
                    ON a.department_id = d.department_id
                WHERE a.application_id = ?
                  AND a.user_id = ?
                """;

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        connection.prepareStatement(sql)
        ) {

            ps.setLong(
                    1,
                    applicationId
            );

            ps.setLong(
                    2,
                    userId
            );

            ResultSet rs =
                    ps.executeQuery();

            if (!rs.next()) {

                request.setAttribute(
                        "analysisError",
                        "Application not found."
                );

                return;
            }

            String applicationNumber =
                    rs.getString(
                            "application_number"
                    );

            String approvalName =
                    rs.getString(
                            "approval_name"
                    );

            String departmentName =
                    rs.getString(
                            "department_name"
                    );

            String currentStatus =
                    rs.getString(
                            "current_status"
                    );

            Date expectedDate =
                    rs.getDate(
                            "expected_completion_date"
                    );

            String officerRemarks =
                    rs.getString(
                            "officer_remarks"
                    );

            request.setAttribute(
                    "selectedApplicationId",
                    applicationId
            );

            request.setAttribute(
                    "applicationNumber",
                    applicationNumber
            );

            request.setAttribute(
                    "approvalName",
                    approvalName
            );

            request.setAttribute(
                    "departmentName",
                    departmentName
            );

            request.setAttribute(
                    "currentStatus",
                    currentStatus
            );

            request.setAttribute(
                    "expectedDate",
                    expectedDate
            );

            request.setAttribute(
                    "officerRemarks",
                    officerRemarks
            );

            DelayResult result =
                    determineDelay(
                            connection,
                            applicationId,
                            currentStatus,
                            expectedDate
                    );

            request.setAttribute(
                    "delayTitle",
                    result.title
            );

            request.setAttribute(
                    "delayExplanation",
                    result.explanation
            );

            request.setAttribute(
                    "nextAction",
                    result.nextAction
            );

            request.setAttribute(
                    "delayLevel",
                    result.level
            );

            request.setAttribute(
                    "daysInfo",
                    result.daysInfo
            );

            request.setAttribute(
                    "analysisPerformed",
                    true
            );
        }
    }

    private DelayResult determineDelay(
            Connection connection,
            long applicationId,
            String currentStatus,
            Date expectedDate)
            throws SQLException {

        DelayResult queryResult =
                checkQuery(
                        connection,
                        applicationId
                );

        if (queryResult != null) {
            return queryResult;
        }

        DelayResult inspectionResult =
                checkInspection(
                        connection,
                        applicationId
                );

        if (inspectionResult != null) {
            return inspectionResult;
        }

        if ("APPROVED".equalsIgnoreCase(
                currentStatus)) {

            return new DelayResult(
                    "Application Completed",
                    "Your application has already been approved. There is no active processing delay.",
                    "View your approval certificate and monitor future renewal requirements.",
                    "COMPLETED",
                    "Approval completed"
            );
        }

        if ("REJECTED".equalsIgnoreCase(
                currentStatus)) {

            return new DelayResult(
                    "Application Rejected",
                    "Processing has stopped because the application was rejected.",
                    "Review the rejection reason, correct the identified issue and reapply if permitted.",
                    "ACTION",
                    "Processing stopped"
            );
        }

        if ("DRAFT".equalsIgnoreCase(
                currentStatus)) {

            return new DelayResult(
                    "Application Not Submitted",
                    "This application is still in Draft status, so departmental processing has not started yet.",
                    "Complete the required documents and submit the application.",
                    "ACTION",
                    "SLA has not started"
            );
        }

        if (expectedDate != null) {

            LocalDate today =
                    LocalDate.now();

            LocalDate deadline =
                    expectedDate.toLocalDate();

            long difference =
                    ChronoUnit.DAYS.between(
                            today,
                            deadline
                    );

            if (difference < 0) {

                long overdue =
                        Math.abs(difference);

                return new DelayResult(
                        "SLA Deadline Exceeded",
                        "The estimated completion date has passed and the application is still under processing.",
                        "No new submission is required unless the department raises a query. Continue monitoring the application and department updates.",
                        "BREACHED",
                        overdue
                                + " day(s) beyond estimated completion"
                );
            }

            if (difference <= 2) {

                return new DelayResult(
                        "Near SLA Deadline",
                        "Your application is still being processed and is close to its estimated completion date.",
                        "Monitor notifications and be ready to respond quickly if the officer raises a query.",
                        "WARNING",
                        difference
                                + " day(s) remaining"
                );
            }

            return new DelayResult(
                    getStatusTitle(
                            currentStatus
                    ),
                    getStatusExplanation(
                            currentStatus
                    ),
                    getStatusAction(
                            currentStatus
                    ),
                    "ON_TRACK",
                    difference
                            + " day(s) remaining before estimated completion"
            );
        }

        return new DelayResult(
                getStatusTitle(
                        currentStatus
                ),
                getStatusExplanation(
                        currentStatus
                ),
                getStatusAction(
                        currentStatus
                ),
                "INFO",
                "No estimated completion date available"
        );
    }

    private DelayResult checkQuery(
            Connection connection,
            long applicationId)
            throws SQLException {

        String sql = """
                SELECT
                    query_description,
                    response_deadline,
                    status,
                    entrepreneur_response,
                    responded_at,
                    resolved_at
                FROM application_queries
                WHERE application_id = ?
                ORDER BY raised_date DESC
                LIMIT 1
                """;

        try (
                PreparedStatement ps =
                        connection.prepareStatement(sql)
        ) {

            ps.setLong(
                    1,
                    applicationId
            );

            ResultSet rs =
                    ps.executeQuery();

            if (!rs.next()) {
                return null;
            }

            String status =
                    rs.getString("status");

            String response =
                    rs.getString(
                            "entrepreneur_response"
                    );

            Date responseDeadline =
                    rs.getDate(
                            "response_deadline"
                    );

            if ("OPEN".equalsIgnoreCase(status)
                    &&
                    (response == null
                            || response.isBlank())) {

                String deadlineText =
                        responseDeadline == null
                                ? "Response pending"
                                : "Respond by "
                                + responseDeadline;

                return new DelayResult(
                        "Action Required: Officer Query",
                        "The department has raised a query and is waiting for your response. Processing may remain paused until you respond.",
                        "Open the application, review the officer's query and submit your response with any requested document.",
                        "ACTION",
                        deadlineText
                );
            }

            if (("RESPONDED".equalsIgnoreCase(status)
                    ||
                    response != null)
                    &&
                    !"RESOLVED".equalsIgnoreCase(status)) {

                return new DelayResult(
                        "Response Under Review",
                        "You have responded to the officer's query. The department now needs to review your response before processing can continue.",
                        "No additional action is required unless the officer asks for more information.",
                        "WAITING",
                        "Response submitted"
                );
            }

            return null;
        }
    }

    private DelayResult checkInspection(
            Connection connection,
            long applicationId)
            throws SQLException {

        String sql = """
                SELECT
                    inspection_date,
                    inspection_time,
                    status,
                    result
                FROM inspections
                WHERE application_id = ?
                ORDER BY created_at DESC
                LIMIT 1
                """;

        try (
                PreparedStatement ps =
                        connection.prepareStatement(sql)
        ) {

            ps.setLong(
                    1,
                    applicationId
            );

            ResultSet rs =
                    ps.executeQuery();

            if (!rs.next()) {
                return null;
            }

            String status =
                    rs.getString("status");

            String result =
                    rs.getString("result");

            Date inspectionDate =
                    rs.getDate(
                            "inspection_date"
                    );

            if ("SCHEDULED".equalsIgnoreCase(
                    status)) {

                return new DelayResult(
                        "Waiting for Inspection",
                        "The application has reached the inspection stage. Final processing may depend on completion of the scheduled inspection.",
                        "Prepare the premises and required records for the scheduled inspection.",
                        "WAITING",
                        inspectionDate == null
                                ? "Inspection scheduled"
                                : "Inspection date: "
                                + inspectionDate
                );
            }

            if ("COMPLETED".equalsIgnoreCase(status)
                    &&
                    result == null) {

                return new DelayResult(
                        "Inspection Result Pending",
                        "The inspection has been completed, but the result has not yet been recorded.",
                        "No immediate action is required. Monitor the application for the inspection outcome.",
                        "WAITING",
                        "Department action pending"
                );
            }

            if ("COMPLETED".equalsIgnoreCase(status)
                    &&
                    "FAILED".equalsIgnoreCase(result)) {

                return new DelayResult(
                        "Inspection Issue Identified",
                        "The inspection result indicates that required conditions were not fully satisfied.",
                        "Review inspection remarks and complete the required corrective action.",
                        "ACTION",
                        "Inspection result: Failed"
                );
            }

            return null;
        }
    }

    private String getStatusTitle(
            String status) {

        if (status == null) {
            return "Application Processing";
        }

        return switch (
                status.toUpperCase()) {

            case "SUBMITTED" ->
                    "Waiting for Initial Review";

            case "UNDER_REVIEW" ->
                    "Department Review in Progress";

            case "DOCUMENT_VERIFIED" ->
                    "Documents Verified";

            case "FINAL_REVIEW" ->
                    "Final Decision Pending";

            case "QUERY" ->
                    "Query Stage";

            case "INSPECTION" ->
                    "Inspection Stage";

            default ->
                    "Application Processing";
        };
    }

    private String getStatusExplanation(
            String status) {

        if (status == null) {

            return "Your application is currently being processed.";
        }

        return switch (
                status.toUpperCase()) {

            case "SUBMITTED" ->
                    "Your application has been submitted and is waiting for departmental review.";

            case "UNDER_REVIEW" ->
                    "The assigned department is currently reviewing your application and submitted information.";

            case "DOCUMENT_VERIFIED" ->
                    "Your submitted documents have been verified and the application is moving to the next regulatory stage.";

            case "FINAL_REVIEW" ->
                    "The application has reached final review and is awaiting the department's decision.";

            case "QUERY" ->
                    "The application is currently in the query stage.";

            case "INSPECTION" ->
                    "The application is currently progressing through the inspection stage.";

            default ->
                    "Your application is progressing through the departmental workflow.";
        };
    }

    private String getStatusAction(
            String status) {

        if (status == null) {

            return "Monitor your application and notifications for further updates.";
        }

        return switch (
                status.toUpperCase()) {

            case "SUBMITTED",
                 "UNDER_REVIEW",
                 "DOCUMENT_VERIFIED",
                 "FINAL_REVIEW" ->

                    "No immediate action is required. Monitor notifications and respond promptly if the department requests information.";

            case "QUERY" ->

                    "Check whether an officer query requires your response.";

            case "INSPECTION" ->

                    "Check your inspection schedule and prepare the required premises and records.";

            default ->

                    "Monitor the application timeline for the next action.";
        };
    }

    private static class DelayResult {

        private final String title;
        private final String explanation;
        private final String nextAction;
        private final String level;
        private final String daysInfo;

        private DelayResult(
                String title,
                String explanation,
                String nextAction,
                String level,
                String daysInfo) {

            this.title = title;
            this.explanation = explanation;
            this.nextAction = nextAction;
            this.level = level;
            this.daysInfo = daysInfo;
        }
    }
}