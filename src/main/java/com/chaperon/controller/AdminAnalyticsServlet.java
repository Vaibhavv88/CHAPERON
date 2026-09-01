package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/analytics")
public class AdminAnalyticsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }


        int totalApplications = 0;
        int approvedApplications = 0;
        int rejectedApplications = 0;
        int pendingApplications = 0;

        double approvalRate = 0.0;
        double rejectionRate = 0.0;


        List<String> departmentLabels =
                new ArrayList<>();

        List<Integer> departmentCounts =
                new ArrayList<>();


        List<String> statusLabels =
                new ArrayList<>();

        List<Integer> statusCounts =
                new ArrayList<>();


        List<String> monthLabels =
                new ArrayList<>();

        List<Integer> monthCounts =
                new ArrayList<>();


        String summarySql =
                "SELECT " +
                "COUNT(*) AS total, " +
                "SUM(CASE WHEN current_status = 'APPROVED' THEN 1 ELSE 0 END) AS approved, " +
                "SUM(CASE WHEN current_status = 'REJECTED' THEN 1 ELSE 0 END) AS rejected, " +
                "SUM(CASE WHEN current_status NOT IN ('APPROVED', 'REJECTED', 'DRAFT') THEN 1 ELSE 0 END) AS pending " +
                "FROM applications";


        String departmentSql =
                "SELECT d.department_name, COUNT(a.application_id) AS total " +
                "FROM departments d " +
                "LEFT JOIN applications a " +
                "ON d.department_id = a.department_id " +
                "GROUP BY d.department_id, d.department_name " +
                "ORDER BY total DESC, d.department_name ASC";


        String statusSql =
                "SELECT current_status, COUNT(*) AS total " +
                "FROM applications " +
                "GROUP BY current_status " +
                "ORDER BY total DESC";


        String monthlySql =
                "SELECT DATE_FORMAT(created_at, '%Y-%m') AS month_key, " +
                "COUNT(*) AS total " +
                "FROM applications " +
                "WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 11 MONTH) " +
                "GROUP BY DATE_FORMAT(created_at, '%Y-%m') " +
                "ORDER BY month_key ASC";


        try (
            Connection connection =
                    DBConnection.getConnection()
        ) {

            try (
                PreparedStatement statement =
                        connection.prepareStatement(summarySql);

                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    totalApplications =
                            resultSet.getInt("total");

                    approvedApplications =
                            resultSet.getInt("approved");

                    rejectedApplications =
                            resultSet.getInt("rejected");

                    pendingApplications =
                            resultSet.getInt("pending");
                }
            }


            if (totalApplications > 0) {

                approvalRate =
                        approvedApplications * 100.0
                        / totalApplications;

                rejectionRate =
                        rejectedApplications * 100.0
                        / totalApplications;
            }


            try (
                PreparedStatement statement =
                        connection.prepareStatement(departmentSql);

                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    departmentLabels.add(
                            resultSet.getString(
                                    "department_name"
                            )
                    );

                    departmentCounts.add(
                            resultSet.getInt(
                                    "total"
                            )
                    );
                }
            }


            try (
                PreparedStatement statement =
                        connection.prepareStatement(statusSql);

                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    String status =
                            resultSet.getString(
                                    "current_status"
                            );

                    if (status == null) {
                        status = "UNKNOWN";
                    }

                    statusLabels.add(
                            status.replace("_", " ")
                    );

                    statusCounts.add(
                            resultSet.getInt(
                                    "total"
                            )
                    );
                }
            }


            try (
                PreparedStatement statement =
                        connection.prepareStatement(monthlySql);

                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    monthLabels.add(
                            resultSet.getString(
                                    "month_key"
                            )
                    );

                    monthCounts.add(
                            resultSet.getInt(
                                    "total"
                            )
                    );
                }
            }


            request.setAttribute(
                    "totalApplications",
                    totalApplications
            );

            request.setAttribute(
                    "approvedApplications",
                    approvedApplications
            );

            request.setAttribute(
                    "rejectedApplications",
                    rejectedApplications
            );

            request.setAttribute(
                    "pendingApplications",
                    pendingApplications
            );

            request.setAttribute(
                    "approvalRate",
                    approvalRate
            );

            request.setAttribute(
                    "rejectionRate",
                    rejectionRate
            );

            request.setAttribute(
                    "departmentLabels",
                    departmentLabels
            );

            request.setAttribute(
                    "departmentCounts",
                    departmentCounts
            );

            request.setAttribute(
                    "statusLabels",
                    statusLabels
            );

            request.setAttribute(
                    "statusCounts",
                    statusCounts
            );

            request.setAttribute(
                    "monthLabels",
                    monthLabels
            );

            request.setAttribute(
                    "monthCounts",
                    monthCounts
            );


            request.getRequestDispatcher(
                    "/WEB-INF/views/admin/analytics.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            log(
                    "Unable to load admin analytics.",
                    e
            );

            throw new ServletException(
                    "Unable to load analytics.",
                    e
            );
        }
    }


    private boolean isAdmin(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null ||
            !"ADMIN".equalsIgnoreCase(
                    String.valueOf(
                            session.getAttribute("userRole")
                    )
            )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-login"
            );

            return false;
        }

        return true;
    }
}