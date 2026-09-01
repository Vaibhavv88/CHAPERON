package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

@WebServlet("/admin/applications")
public class AdminApplicationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }


        List<Map<String, Object>> applications =
                new ArrayList<>();


        String sql =
                "SELECT " +
                "a.application_id, " +
                "a.application_number, " +
                "a.user_id, " +
                "u.full_name AS entrepreneur_name, " +
                "u.email AS entrepreneur_email, " +

                "a.business_id, " +
                "b.business_name, " +
                "b.industry, " +

                "a.approval_id, " +
                "ap.approval_name, " +
                "ap.approval_code, " +

                "a.department_id, " +
                "d.department_name, " +
                "d.department_code, " +

                "a.assigned_officer_id, " +
                "ou.full_name AS officer_name, " +
                "op.employee_code, " +

                "a.submission_date, " +
                "a.current_status, " +
                "a.sla_days, " +
                "a.expected_completion_date, " +
                "a.risk_level, " +
                "a.officer_remarks, " +
                "a.rejection_reason, " +
                "a.can_reapply, " +
                "a.created_at, " +
                "a.updated_at " +

                "FROM applications a " +

                "JOIN users u " +
                "ON a.user_id = u.user_id " +

                "JOIN businesses b " +
                "ON a.business_id = b.business_id " +

                "JOIN approvals ap " +
                "ON a.approval_id = ap.approval_id " +

                "JOIN departments d " +
                "ON a.department_id = d.department_id " +

                "LEFT JOIN officer_profiles op " +
                "ON a.assigned_officer_id = op.officer_profile_id " +

                "LEFT JOIN users ou " +
                "ON op.user_id = ou.user_id " +

                "ORDER BY a.application_id DESC";


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                Map<String, Object> application =
                        new HashMap<>();


                application.put(
                        "applicationId",
                        resultSet.getLong(
                                "application_id"
                        )
                );

                application.put(
                        "applicationNumber",
                        resultSet.getString(
                                "application_number"
                        )
                );

                application.put(
                        "userId",
                        resultSet.getLong(
                                "user_id"
                        )
                );

                application.put(
                        "entrepreneurName",
                        resultSet.getString(
                                "entrepreneur_name"
                        )
                );

                application.put(
                        "entrepreneurEmail",
                        resultSet.getString(
                                "entrepreneur_email"
                        )
                );


                application.put(
                        "businessId",
                        resultSet.getLong(
                                "business_id"
                        )
                );

                application.put(
                        "businessName",
                        resultSet.getString(
                                "business_name"
                        )
                );

                application.put(
                        "industry",
                        resultSet.getString(
                                "industry"
                        )
                );


                application.put(
                        "approvalId",
                        resultSet.getLong(
                                "approval_id"
                        )
                );

                application.put(
                        "approvalName",
                        resultSet.getString(
                                "approval_name"
                        )
                );

                application.put(
                        "approvalCode",
                        resultSet.getString(
                                "approval_code"
                        )
                );


                application.put(
                        "departmentId",
                        resultSet.getLong(
                                "department_id"
                        )
                );

                application.put(
                        "departmentName",
                        resultSet.getString(
                                "department_name"
                        )
                );

                application.put(
                        "departmentCode",
                        resultSet.getString(
                                "department_code"
                        )
                );


                long officerProfileId =
                        resultSet.getLong(
                                "assigned_officer_id"
                        );

                if (resultSet.wasNull()) {

                    application.put(
                            "assignedOfficerId",
                            null
                    );

                } else {

                    application.put(
                            "assignedOfficerId",
                            officerProfileId
                    );
                }


                application.put(
                        "officerName",
                        resultSet.getString(
                                "officer_name"
                        )
                );

                application.put(
                        "employeeCode",
                        resultSet.getString(
                                "employee_code"
                        )
                );


                application.put(
                        "submissionDate",
                        resultSet.getTimestamp(
                                "submission_date"
                        )
                );

                application.put(
                        "currentStatus",
                        resultSet.getString(
                                "current_status"
                        )
                );


                int slaDays =
                        resultSet.getInt(
                                "sla_days"
                        );

                if (resultSet.wasNull()) {

                    application.put(
                            "slaDays",
                            null
                    );

                } else {

                    application.put(
                            "slaDays",
                            slaDays
                    );
                }


                application.put(
                        "expectedCompletionDate",
                        resultSet.getDate(
                                "expected_completion_date"
                        )
                );

                application.put(
                        "riskLevel",
                        resultSet.getString(
                                "risk_level"
                        )
                );

                application.put(
                        "officerRemarks",
                        resultSet.getString(
                                "officer_remarks"
                        )
                );

                application.put(
                        "rejectionReason",
                        resultSet.getString(
                                "rejection_reason"
                        )
                );

                application.put(
                        "canReapply",
                        resultSet.getBoolean(
                                "can_reapply"
                        )
                );

                application.put(
                        "createdAt",
                        resultSet.getTimestamp(
                                "created_at"
                        )
                );

                application.put(
                        "updatedAt",
                        resultSet.getTimestamp(
                                "updated_at"
                        )
                );


                applications.add(
                        application
                );
            }


            request.setAttribute(
                    "applications",
                    applications
            );


            request.getRequestDispatcher(
                    "/WEB-INF/views/admin/applications.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            log(
                    "Unable to load admin application monitoring.",
                    e
            );

            throw new ServletException(
                    "Unable to load applications.",
                    e
            );
        }
    }


    /*
     * =========================================
     * ADMIN SESSION CHECK
     * =========================================
     */
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
                            session.getAttribute(
                                    "userRole"
                            )
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