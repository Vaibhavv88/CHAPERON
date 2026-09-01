package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

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

            return;
        }


        int totalEntrepreneurs = 0;
        int totalOfficers = 0;
        int totalDepartments = 0;
        int totalApprovals = 0;

        int totalApplications = 0;
        int pendingApplications = 0;
        int approvedApplications = 0;
        int rejectedApplications = 0;


        String userCountSql =
                "SELECT role, COUNT(*) AS total " +
                "FROM users " +
                "GROUP BY role";


        String departmentCountSql =
                "SELECT COUNT(*) AS total " +
                "FROM departments";


        String approvalCountSql =
                "SELECT COUNT(*) AS total " +
                "FROM approvals " +
                "WHERE active = 1";


        String applicationCountSql =
                "SELECT " +
                "COUNT(*) AS total_applications, " +

                "SUM(CASE WHEN current_status IN " +
                "('SUBMITTED', 'UNDER_REVIEW', 'QUERY_RAISED') " +
                "THEN 1 ELSE 0 END) AS pending_applications, " +

                "SUM(CASE WHEN current_status = 'APPROVED' " +
                "THEN 1 ELSE 0 END) AS approved_applications, " +

                "SUM(CASE WHEN current_status = 'REJECTED' " +
                "THEN 1 ELSE 0 END) AS rejected_applications " +

                "FROM applications";


        try (
            Connection connection =
                    DBConnection.getConnection()
        ) {

            /*
             * ==========================
             * USERS COUNT
             * ==========================
             */

            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                userCountSql
                        );

                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    String role =
                            resultSet.getString(
                                    "role"
                            );

                    int total =
                            resultSet.getInt(
                                    "total"
                            );


                    if ("ENTREPRENEUR".equalsIgnoreCase(role)) {

                        totalEntrepreneurs = total;

                    } else if ("OFFICER".equalsIgnoreCase(role)) {

                        totalOfficers = total;
                    }
                }
            }


            /*
             * ==========================
             * DEPARTMENTS COUNT
             * ==========================
             */

            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                departmentCountSql
                        );

                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    totalDepartments =
                            resultSet.getInt(
                                    "total"
                            );
                }
            }


            /*
             * ==========================
             * APPROVALS COUNT
             * ==========================
             */

            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                approvalCountSql
                        );

                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    totalApprovals =
                            resultSet.getInt(
                                    "total"
                            );
                }
            }


            /*
             * ==========================
             * APPLICATION COUNTS
             * ==========================
             */

            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                applicationCountSql
                        );

                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    totalApplications =
                            resultSet.getInt(
                                    "total_applications"
                            );

                    pendingApplications =
                            resultSet.getInt(
                                    "pending_applications"
                            );

                    approvedApplications =
                            resultSet.getInt(
                                    "approved_applications"
                            );

                    rejectedApplications =
                            resultSet.getInt(
                                    "rejected_applications"
                            );
                }
            }


            /*
             * ==========================
             * SEND DATA TO JSP
             * ==========================
             */

            request.setAttribute(
                    "totalEntrepreneurs",
                    totalEntrepreneurs
            );

            request.setAttribute(
                    "totalOfficers",
                    totalOfficers
            );

            request.setAttribute(
                    "totalDepartments",
                    totalDepartments
            );

            request.setAttribute(
                    "totalApprovals",
                    totalApprovals
            );

            request.setAttribute(
                    "totalApplications",
                    totalApplications
            );

            request.setAttribute(
                    "pendingApplications",
                    pendingApplications
            );

            request.setAttribute(
                    "approvedApplications",
                    approvedApplications
            );

            request.setAttribute(
                    "rejectedApplications",
                    rejectedApplications
            );


            request.getRequestDispatcher(
                    "/WEB-INF/views/admin/admin-dashboard.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            log(
                    "Unable to load admin dashboard.",
                    e
            );

            throw new ServletException(
                    "Unable to load admin dashboard.",
                    e
            );
        }
    }
}