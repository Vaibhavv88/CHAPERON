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

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        List<Map<String, Object>> entrepreneurs =
                new ArrayList<>();


        String sql =
                "SELECT " +
                "u.user_id, " +
                "u.full_name, " +
                "u.email, " +
                "u.mobile, " +
                "u.created_at, " +
                "u.last_login, " +
                "u.profile_completed, " +
                "u.account_status, " +

                "b.business_id, " +
                "b.business_name, " +
                "b.business_constitution, " +
                "b.business_activity, " +
                "b.industry, " +
                "b.state, " +
                "b.district, " +
                "b.taluka, " +
                "b.industrial_area, " +
                "b.pin_code, " +
                "b.project_stage, " +
                "b.investment_amount, " +
                "b.employee_count, " +
                "b.pollution_category, " +

                "(SELECT COUNT(*) " +
                " FROM applications a " +
                " WHERE a.user_id = u.user_id) " +
                "AS application_count, " +

                "(SELECT COUNT(*) " +
                " FROM applications a " +
                " WHERE a.user_id = u.user_id " +
                " AND a.current_status = 'APPROVED') " +
                "AS approved_count " +

                "FROM users u " +

                "LEFT JOIN businesses b " +
                "ON b.business_id = (" +
                "   SELECT MAX(b2.business_id) " +
                "   FROM businesses b2 " +
                "   WHERE b2.user_id = u.user_id" +
                ") " +

                "WHERE u.role = 'ENTREPRENEUR' " +

                "ORDER BY u.created_at DESC, u.user_id DESC";


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                Map<String, Object> entrepreneur =
                        new HashMap<>();


                entrepreneur.put(
                        "userId",
                        resultSet.getLong("user_id")
                );

                entrepreneur.put(
                        "fullName",
                        resultSet.getString("full_name")
                );

                entrepreneur.put(
                        "email",
                        resultSet.getString("email")
                );

                entrepreneur.put(
                        "mobile",
                        resultSet.getString("mobile")
                );

                entrepreneur.put(
                        "createdAt",
                        resultSet.getTimestamp("created_at")
                );

                entrepreneur.put(
                        "lastLogin",
                        resultSet.getTimestamp("last_login")
                );

                entrepreneur.put(
                        "profileCompleted",
                        resultSet.getBoolean("profile_completed")
                );

                entrepreneur.put(
                        "accountStatus",
                        resultSet.getString("account_status")
                );


                /*
                 * BUSINESS ID CAN BE NULL
                 */
                long businessId =
                        resultSet.getLong("business_id");

                if (resultSet.wasNull()) {

                    entrepreneur.put(
                            "businessId",
                            null
                    );

                } else {

                    entrepreneur.put(
                            "businessId",
                            businessId
                    );
                }


                entrepreneur.put(
                        "businessName",
                        resultSet.getString("business_name")
                );

                entrepreneur.put(
                        "businessConstitution",
                        resultSet.getString("business_constitution")
                );

                entrepreneur.put(
                        "businessActivity",
                        resultSet.getString("business_activity")
                );

                entrepreneur.put(
                        "industry",
                        resultSet.getString("industry")
                );

                entrepreneur.put(
                        "state",
                        resultSet.getString("state")
                );

                entrepreneur.put(
                        "district",
                        resultSet.getString("district")
                );

                entrepreneur.put(
                        "taluka",
                        resultSet.getString("taluka")
                );

                entrepreneur.put(
                        "industrialArea",
                        resultSet.getString("industrial_area")
                );

                entrepreneur.put(
                        "pinCode",
                        resultSet.getString("pin_code")
                );

                entrepreneur.put(
                        "projectStage",
                        resultSet.getString("project_stage")
                );

                entrepreneur.put(
                        "investmentAmount",
                        resultSet.getBigDecimal("investment_amount")
                );


                int employeeCount =
                        resultSet.getInt("employee_count");

                if (resultSet.wasNull()) {

                    entrepreneur.put(
                            "employeeCount",
                            null
                    );

                } else {

                    entrepreneur.put(
                            "employeeCount",
                            employeeCount
                    );
                }


                entrepreneur.put(
                        "pollutionCategory",
                        resultSet.getString("pollution_category")
                );

                entrepreneur.put(
                        "applicationCount",
                        resultSet.getInt("application_count")
                );

                entrepreneur.put(
                        "approvedCount",
                        resultSet.getInt("approved_count")
                );


                entrepreneurs.add(
                        entrepreneur
                );
            }


            request.setAttribute(
                    "entrepreneurs",
                    entrepreneurs
            );


            request.getRequestDispatcher(
                    "/WEB-INF/views/admin/users.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            log(
                    "Unable to load entrepreneurs.",
                    e
            );

            throw new ServletException(
                    "Unable to load entrepreneur accounts.",
                    e
            );
        }
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }


        request.setCharacterEncoding("UTF-8");

        String action =
                request.getParameter("action");


        if (!"toggle-status".equals(action)) {

            redirect(
                    request,
                    response,
                    "error=invalid-action"
            );

            return;
        }


        long userId;

        try {

            userId =
                    Long.parseLong(
                            request.getParameter(
                                    "userId"
                            )
                    );

        } catch (Exception e) {

            redirect(
                    request,
                    response,
                    "error=invalid-user"
            );

            return;
        }


        String findSql =
                "SELECT account_status " +
                "FROM users " +
                "WHERE user_id = ? " +
                "AND role = 'ENTREPRENEUR'";


        String updateSql =
                "UPDATE users " +
                "SET account_status = ? " +
                "WHERE user_id = ? " +
                "AND role = 'ENTREPRENEUR'";


        try (
            Connection connection =
                    DBConnection.getConnection()
        ) {

            String currentStatus = null;


            /*
             * FIND CURRENT STATUS
             */
            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                findSql
                        )
            ) {

                statement.setLong(
                        1,
                        userId
                );


                try (
                    ResultSet resultSet =
                            statement.executeQuery()
                ) {

                    if (resultSet.next()) {

                        currentStatus =
                                resultSet.getString(
                                        "account_status"
                                );
                    }
                }
            }


            if (currentStatus == null) {

                redirect(
                        request,
                        response,
                        "error=invalid-user"
                );

                return;
            }


            String newStatus;

            if ("ACTIVE".equalsIgnoreCase(
                    currentStatus
            )) {

                newStatus = "INACTIVE";

            } else {

                newStatus = "ACTIVE";
            }


            /*
             * UPDATE ACCOUNT STATUS
             */
            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                updateSql
                        )
            ) {

                statement.setString(
                        1,
                        newStatus
                );

                statement.setLong(
                        2,
                        userId
                );

                int rows =
                        statement.executeUpdate();


                if (rows == 0) {

                    redirect(
                            request,
                            response,
                            "error=invalid-user"
                    );

                    return;
                }
            }


            redirect(
                    request,
                    response,
                    "success=status-updated"
            );


        } catch (Exception e) {

            log(
                    "Unable to update entrepreneur account status.",
                    e
            );

            throw new ServletException(
                    "Unable to update entrepreneur account.",
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


    /*
     * =========================================
     * REDIRECT
     * =========================================
     */
    private void redirect(
            HttpServletRequest request,
            HttpServletResponse response,
            String parameter
    ) throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/users?"
                + parameter
        );
    }
}