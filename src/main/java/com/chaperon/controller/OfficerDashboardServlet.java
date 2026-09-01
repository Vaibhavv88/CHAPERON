package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

import com.chaperon.dto.OfficerApplicationView;
import com.chaperon.model.Application;
import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/officer/dashboard")
public class OfficerDashboardServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String FIND_DEPARTMENT_APPLICATIONS =

            "SELECT " +

            "ap.application_id, " +
            "ap.application_number, " +
            "ap.user_id, " +
            "ap.business_id, " +
            "ap.approval_id, " +
            "ap.department_id, " +
            "ap.assigned_officer_id, " +
            "ap.previous_application_id, " +
            "ap.submission_date, " +
            "ap.current_status, " +
            "ap.sla_days, " +
            "ap.expected_completion_date, " +
            "ap.risk_level, " +
            "ap.officer_remarks, " +
            "ap.rejection_reason, " +
            "ap.can_reapply, " +
            "ap.rejected_by, " +
            "ap.rejected_at, " +
            "ap.created_at, " +
            "ap.updated_at, " +

            "a.approval_name, " +
            "a.approval_code, " +

            "u.full_name AS applicant_name, " +

            "b.business_name " +

            "FROM applications ap " +

            "JOIN approvals a " +
            "ON ap.approval_id = a.approval_id " +

            "JOIN users u " +
            "ON ap.user_id = u.user_id " +

            "JOIN businesses b " +
            "ON ap.business_id = b.business_id " +

            "WHERE ap.department_id = ? " +

            "AND ap.current_status <> 'DRAFT' " +

            "ORDER BY " +
            "ap.submission_date DESC, " +
            "ap.created_at DESC";

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        /*
         * ----------------------------------------
         * 1. SESSION CHECK
         * ----------------------------------------
         */

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null ||
            !"OFFICER".equalsIgnoreCase(
                    (String)
                    session.getAttribute(
                            "userRole"
                    )
            )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/officer-login"
            );

            return;
        }

        /*
         * ----------------------------------------
         * 2. DEPARTMENT CHECK
         * ----------------------------------------
         */

        Object departmentIdObject =
                session.getAttribute(
                        "departmentId"
                );

        if (departmentIdObject == null) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath()
                    + "/officer-login"
            );

            return;
        }

        try {

            long departmentId =
                    ((Number)
                    departmentIdObject)
                    .longValue();

            /*
             * ----------------------------------------
             * 3. LOAD APPLICATIONS
             * ----------------------------------------
             */

            List<OfficerApplicationView>
                    applicationViews =
                    new ArrayList<>();

            int submittedCount = 0;

            int underReviewCount = 0;

            int queryCount = 0;

            int completedCount = 0;

            try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement statement =
                        connection.prepareStatement(
                                FIND_DEPARTMENT_APPLICATIONS
                        )
            ) {

                statement.setLong(
                        1,
                        departmentId
                );

                try (
                    ResultSet resultSet =
                            statement.executeQuery()
                ) {

                    while (resultSet.next()) {

                        /*
                         * --------------------------
                         * APPLICATION MODEL
                         * --------------------------
                         */

                        Application application =
                                new Application();

                        application.setApplicationId(
                                resultSet.getLong(
                                        "application_id"
                                )
                        );

                        application.setApplicationNumber(
                                resultSet.getString(
                                        "application_number"
                                )
                        );

                        application.setUserId(
                                resultSet.getLong(
                                        "user_id"
                                )
                        );

                        application.setBusinessId(
                                resultSet.getLong(
                                        "business_id"
                                )
                        );

                        application.setApprovalId(
                                resultSet.getLong(
                                        "approval_id"
                                )
                        );

                        application.setDepartmentId(
                                resultSet.getLong(
                                        "department_id"
                                )
                        );

                        /*
                         * assigned officer
                         */
                        long assignedOfficerId =
                                resultSet.getLong(
                                        "assigned_officer_id"
                                );

                        if (!resultSet.wasNull()) {

                            application.setAssignedOfficerId(
                                    assignedOfficerId
                            );
                        }

                        /*
                         * previous application
                         */
                        long previousApplicationId =
                                resultSet.getLong(
                                        "previous_application_id"
                                );

                        if (!resultSet.wasNull()) {

                            application.setPreviousApplicationId(
                                    previousApplicationId
                            );
                        }

                        application.setSubmissionDate(
                                resultSet.getTimestamp(
                                        "submission_date"
                                )
                        );

                        application.setCurrentStatus(
                                resultSet.getString(
                                        "current_status"
                                )
                        );

                        /*
                         * SLA
                         */
                        int slaDays =
                                resultSet.getInt(
                                        "sla_days"
                                );

                        if (!resultSet.wasNull()) {

                            application.setSlaDays(
                                    slaDays
                            );
                        }

                        application.setExpectedCompletionDate(
                                resultSet.getDate(
                                        "expected_completion_date"
                                )
                        );

                        application.setRiskLevel(
                                resultSet.getString(
                                        "risk_level"
                                )
                        );

                        application.setOfficerRemarks(
                                resultSet.getString(
                                        "officer_remarks"
                                )
                        );

                        application.setRejectionReason(
                                resultSet.getString(
                                        "rejection_reason"
                                )
                        );

                        application.setCanReapply(
                                resultSet.getBoolean(
                                        "can_reapply"
                                )
                        );

                        /*
                         * rejected by
                         */
                        long rejectedBy =
                                resultSet.getLong(
                                        "rejected_by"
                                );

                        if (!resultSet.wasNull()) {

                            application.setRejectedBy(
                                    rejectedBy
                            );
                        }

                        application.setRejectedAt(
                                resultSet.getTimestamp(
                                        "rejected_at"
                                )
                        );

                        application.setCreatedAt(
                                resultSet.getTimestamp(
                                        "created_at"
                                )
                        );

                        application.setUpdatedAt(
                                resultSet.getTimestamp(
                                        "updated_at"
                                )
                        );

                        /*
                         * --------------------------
                         * EXTRA DISPLAY INFORMATION
                         * --------------------------
                         */

                        String approvalName =
                                resultSet.getString(
                                        "approval_name"
                                );

                        String approvalCode =
                                resultSet.getString(
                                        "approval_code"
                                );

                        String applicantName =
                                resultSet.getString(
                                        "applicant_name"
                                );

                        String businessName =
                                resultSet.getString(
                                        "business_name"
                                );

                        OfficerApplicationView view =
                                new OfficerApplicationView(
                                        application,
                                        approvalName,
                                        approvalCode,
                                        applicantName,
                                        businessName
                                );

                        applicationViews.add(
                                view
                        );

                        /*
                         * --------------------------
                         * DASHBOARD COUNTERS
                         * --------------------------
                         */

                        String status =
                                application
                                        .getCurrentStatus();

                        if ("SUBMITTED"
                                .equalsIgnoreCase(
                                        status
                                )) {

                            submittedCount++;

                        } else if (
                                "UNDER_REVIEW"
                                .equalsIgnoreCase(
                                        status
                                )
                        ) {

                            underReviewCount++;

                        } else if (
                                "QUERY_RAISED"
                                .equalsIgnoreCase(
                                        status
                                )
                        ) {

                            queryCount++;

                        } else if (
                                "APPROVED"
                                .equalsIgnoreCase(
                                        status
                                )
                                ||
                                "REJECTED"
                                .equalsIgnoreCase(
                                        status
                                )
                        ) {

                            completedCount++;
                        }
                    }
                }
            }

            /*
             * ----------------------------------------
             * 4. SEND DATA TO JSP
             * ----------------------------------------
             */

            request.setAttribute(
                    "applicationViews",
                    applicationViews
            );

            request.setAttribute(
                    "submittedCount",
                    submittedCount
            );

            request.setAttribute(
                    "underReviewCount",
                    underReviewCount
            );

            request.setAttribute(
                    "queryCount",
                    queryCount
            );

            request.setAttribute(
                    "completedCount",
                    completedCount
            );

            /*
             * ----------------------------------------
             * 5. OPEN DASHBOARD
             * ----------------------------------------
             */

            request.getRequestDispatcher(
                    "/WEB-INF/views/officer/officer-dashboard.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            log(
                    "Unable to load officer dashboard.",
                    e
            );

            response.sendError(
                    HttpServletResponse
                            .SC_INTERNAL_SERVER_ERROR,
                    "Unable to load officer dashboard."
            );
        }
    }
}