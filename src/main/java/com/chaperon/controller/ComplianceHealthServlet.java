package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/compliance-health")
public class ComplianceHealthServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("userId") == null
                || session.getAttribute("userRole") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }

        String role =
                String.valueOf(
                        session.getAttribute("userRole")
                );

        if (!"ENTREPRENEUR"
                .equalsIgnoreCase(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "This page is only available for entrepreneurs."
            );

            return;
        }

        long userId =
                ((Number)
                session.getAttribute("userId"))
                .longValue();

        try (
                Connection connection =
                        DBConnection.getConnection()
        ) {

            long businessId =
                    findBusinessId(
                            connection,
                            userId
                    );

            if (businessId <= 0) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/entrepreneur/business-onboarding"
                );

                return;
            }

            int approvedLicences =
                    getApprovedLicences(
                            connection,
                            userId
                    );

            int activeApplications =
                    getActiveApplications(
                            connection,
                            userId
                    );

            int openQueries =
                    getOpenQueries(
                            connection,
                            userId
                    );

            int scheduledInspections =
                    getScheduledInspections(
                            connection,
                            userId
                    );

            int documentIssues =
                    getDocumentIssues(
                            connection,
                            businessId
                    );

            int slaBreaches =
                    getSlaBreaches(
                            connection,
                            userId
                    );

            int score =
                    calculateScore(
                            openQueries,
                            scheduledInspections,
                            documentIssues,
                            slaBreaches
                    );

            String healthStatus =
                    getHealthStatus(
                            score
                    );

            String healthMessage =
                    getHealthMessage(
                            score
                    );

            List<Map<String, Object>>
                    passport =
                    loadRegulatoryPassport(
                            connection,
                            userId
                    );

            request.setAttribute(
                    "healthScore",
                    score
            );

            request.setAttribute(
                    "healthStatus",
                    healthStatus
            );

            request.setAttribute(
                    "healthMessage",
                    healthMessage
            );

            request.setAttribute(
                    "approvedLicences",
                    approvedLicences
            );

            request.setAttribute(
                    "activeApplications",
                    activeApplications
            );

            request.setAttribute(
                    "openQueries",
                    openQueries
            );

            request.setAttribute(
                    "scheduledInspections",
                    scheduledInspections
            );

            request.setAttribute(
                    "documentIssues",
                    documentIssues
            );

            request.setAttribute(
                    "slaBreaches",
                    slaBreaches
            );

            request.setAttribute(
                    "passport",
                    passport
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/compliance-health.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to calculate compliance health.",
                    e
            );
        }
    }


    private long findBusinessId(
            Connection connection,
            long userId)
            throws SQLException {

        String sql =
                "SELECT business_id " +
                "FROM businesses " +
                "WHERE user_id = ? " +
                "ORDER BY business_id DESC " +
                "LIMIT 1";

        try (
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

                    return rs.getLong(
                            "business_id"
                    );
                }
            }
        }

        return 0;
    }


    private int getApprovedLicences(
            Connection connection,
            long userId)
            throws SQLException {

        String sql =
                "SELECT COUNT(*) " +
                "FROM applications " +
                "WHERE user_id = ? " +
                "AND current_status = 'APPROVED'";

        return executeCount(
                connection,
                sql,
                userId
        );
    }


    private int getActiveApplications(
            Connection connection,
            long userId)
            throws SQLException {

        String sql =
                "SELECT COUNT(*) " +
                "FROM applications " +
                "WHERE user_id = ? " +
                "AND current_status NOT IN " +
                "('DRAFT','APPROVED','REJECTED')";

        return executeCount(
                connection,
                sql,
                userId
        );
    }


    private int getOpenQueries(
            Connection connection,
            long userId)
            throws SQLException {

        String sql =
                "SELECT COUNT(*) " +
                "FROM application_queries q " +
                "INNER JOIN applications a " +
                "ON q.application_id = a.application_id " +
                "WHERE a.user_id = ? " +
                "AND q.status = 'OPEN'";

        return executeCount(
                connection,
                sql,
                userId
        );
    }


    private int getScheduledInspections(
            Connection connection,
            long userId)
            throws SQLException {

        String sql =
                "SELECT COUNT(*) " +
                "FROM inspections i " +
                "INNER JOIN applications a " +
                "ON i.application_id = a.application_id " +
                "WHERE a.user_id = ? " +
                "AND i.status = 'SCHEDULED'";

        return executeCount(
                connection,
                sql,
                userId
        );
    }


    private int getDocumentIssues(
            Connection connection,
            long businessId)
            throws SQLException {

        String sql =
                "SELECT COUNT(*) " +
                "FROM documents " +
                "WHERE business_id = ? " +
                "AND (" +
                "UPPER(verification_status) = 'REJECTED' " +
                "OR UPPER(verification_status) = 'EXPIRED' " +
                "OR (expiry_date IS NOT NULL " +
                "AND expiry_date < CURDATE())" +
                ")";

        return executeCount(
                connection,
                sql,
                businessId
        );
    }


    private int getSlaBreaches(
            Connection connection,
            long userId)
            throws SQLException {

        String sql =
                "SELECT COUNT(*) " +
                "FROM applications " +
                "WHERE user_id = ? " +
                "AND current_status NOT IN " +
                "('APPROVED','REJECTED','DRAFT') " +
                "AND expected_completion_date IS NOT NULL " +
                "AND expected_completion_date < CURDATE()";

        return executeCount(
                connection,
                sql,
                userId
        );
    }


    private int executeCount(
            Connection connection,
            String sql,
            long value)
            throws SQLException {

        try (
                PreparedStatement ps =
                        connection.prepareStatement(sql)
        ) {

            ps.setLong(
                    1,
                    value
            );

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                if (rs.next()) {

                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }


    private int calculateScore(
            int openQueries,
            int inspections,
            int documentIssues,
            int slaBreaches) {

        int score = 100;

        score -=
                Math.min(
                        openQueries * 10,
                        30
                );

        score -=
                Math.min(
                        inspections * 5,
                        15
                );

        score -=
                Math.min(
                        documentIssues * 15,
                        30
                );

        score -=
                Math.min(
                        slaBreaches * 10,
                        30
                );

        if (score < 0) {
            score = 0;
        }

        return score;
    }


    private String getHealthStatus(
            int score) {

        if (score >= 85) {
            return "EXCELLENT";
        }

        if (score >= 70) {
            return "GOOD";
        }

        if (score >= 50) {
            return "ATTENTION REQUIRED";
        }

        return "CRITICAL";
    }


    private String getHealthMessage(
            int score) {

        if (score >= 85) {

            return "Your regulatory journey is currently healthy with no major compliance risks detected.";
        }

        if (score >= 70) {

            return "Your compliance position is generally healthy, but a few pending actions should be monitored.";
        }

        if (score >= 50) {

            return "Some regulatory actions require attention. Resolve document, query or timeline issues to improve your score.";
        }

        return "Multiple compliance risks need attention. Review pending queries, document issues and delayed applications.";
    }


    private List<Map<String, Object>>
            loadRegulatoryPassport(
            Connection connection,
            long userId)
            throws SQLException {

        String sql =
                "SELECT " +
                "a.application_id, " +
                "a.application_number, " +
                "ap.approval_name, " +
                "ap.approval_code, " +
                "d.department_name, " +
                "ac.approval_number, " +
                "ac.approval_date, " +
                "ac.valid_from, " +
                "ac.valid_until " +
                "FROM approval_certificates ac " +
                "INNER JOIN applications a " +
                "ON ac.application_id = a.application_id " +
                "INNER JOIN approvals ap " +
                "ON a.approval_id = ap.approval_id " +
                "INNER JOIN departments d " +
                "ON a.department_id = d.department_id " +
                "WHERE a.user_id = ? " +
                "ORDER BY ac.approval_date DESC";

        List<Map<String, Object>>
                passport =
                new ArrayList<>();

        try (
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

                while (rs.next()) {

                    Map<String, Object> row =
                            new HashMap<>();

                    row.put(
                            "applicationId",
                            rs.getLong(
                                    "application_id"
                            )
                    );

                    row.put(
                            "applicationNumber",
                            rs.getString(
                                    "application_number"
                            )
                    );

                    row.put(
                            "approvalName",
                            rs.getString(
                                    "approval_name"
                            )
                    );

                    row.put(
                            "approvalCode",
                            rs.getString(
                                    "approval_code"
                            )
                    );

                    row.put(
                            "departmentName",
                            rs.getString(
                                    "department_name"
                            )
                    );

                    row.put(
                            "approvalNumber",
                            rs.getString(
                                    "approval_number"
                            )
                    );

                    row.put(
                            "approvalDate",
                            rs.getDate(
                                    "approval_date"
                            )
                    );

                    row.put(
                            "validFrom",
                            rs.getDate(
                                    "valid_from"
                            )
                    );

                    row.put(
                            "validUntil",
                            rs.getDate(
                                    "valid_until"
                            )
                    );

                    passport.add(row);
                }
            }
        }

        return passport;
    }
}