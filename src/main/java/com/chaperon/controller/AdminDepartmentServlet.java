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

@WebServlet("/admin/departments")
public class AdminDepartmentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    /*
     * =========================================
     * GET
     * Show all departments
     * =========================================
     */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (!isAdminLoggedIn(request, response)) {
            return;
        }

        List<Map<String, Object>> departments =
                new ArrayList<>();


        String sql =
                "SELECT " +
                "department_id, " +
                "department_name, " +
                "department_code, " +
                "description, " +
                "contact_email, " +
                "contact_phone, " +
                "active, " +
                "created_at " +
                "FROM departments " +
                "ORDER BY department_name ASC";


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                Map<String, Object> department =
                        new HashMap<>();


                department.put(
                        "departmentId",
                        resultSet.getLong(
                                "department_id"
                        )
                );

                department.put(
                        "departmentName",
                        resultSet.getString(
                                "department_name"
                        )
                );

                department.put(
                        "departmentCode",
                        resultSet.getString(
                                "department_code"
                        )
                );

                department.put(
                        "description",
                        resultSet.getString(
                                "description"
                        )
                );

                department.put(
                        "contactEmail",
                        resultSet.getString(
                                "contact_email"
                        )
                );

                department.put(
                        "contactPhone",
                        resultSet.getString(
                                "contact_phone"
                        )
                );

                department.put(
                        "active",
                        resultSet.getBoolean(
                                "active"
                        )
                );

                department.put(
                        "createdAt",
                        resultSet.getTimestamp(
                                "created_at"
                        )
                );


                departments.add(department);
            }


            request.setAttribute(
                    "departments",
                    departments
            );


            request.getRequestDispatcher(
                    "/WEB-INF/views/admin/departments.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (SQLException e) {

            log(
                    "Unable to load departments.",
                    e
            );

            throw new ServletException(
                    "Unable to load departments.",
                    e
            );
        }
    }



    /*
     * =========================================
     * POST
     * ADD / UPDATE / TOGGLE STATUS
     * =========================================
     */
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (!isAdminLoggedIn(request, response)) {
            return;
        }


        request.setCharacterEncoding("UTF-8");


        String action =
                request.getParameter("action");


        if (action == null ||
            action.isBlank()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/departments?error=invalid-action"
            );

            return;
        }


        try {

            switch (action) {

                case "add":
                    addDepartment(
                            request,
                            response
                    );
                    break;


                case "update":
                    updateDepartment(
                            request,
                            response
                    );
                    break;


                case "toggle":
                    toggleDepartmentStatus(
                            request,
                            response
                    );
                    break;


                default:

                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin/departments?error=invalid-action"
                    );
            }


        } catch (SQLException e) {

            log(
                    "Department management error.",
                    e
            );

            throw new ServletException(
                    "Unable to process department request.",
                    e
            );
        }
    }



    /*
     * =========================================
     * ADD DEPARTMENT
     * =========================================
     */
    private void addDepartment(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws SQLException, IOException {

        String departmentName =
                clean(
                        request.getParameter(
                                "departmentName"
                        )
                );

        String departmentCode =
                clean(
                        request.getParameter(
                                "departmentCode"
                        )
                );

        String description =
                clean(
                        request.getParameter(
                                "description"
                        )
                );

        String contactEmail =
                clean(
                        request.getParameter(
                                "contactEmail"
                        )
                );

        String contactPhone =
                clean(
                        request.getParameter(
                                "contactPhone"
                        )
                );


        /*
         * Required fields
         */
        if (departmentName == null ||
            departmentName.isBlank() ||
            departmentCode == null ||
            departmentCode.isBlank()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/departments?error=required"
            );

            return;
        }


        /*
         * Normalize code
         */
        departmentCode =
                departmentCode
                        .trim()
                        .toUpperCase();


        /*
         * Check duplicate code
         */
        if (departmentCodeExists(
                departmentCode,
                null
        )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/departments?error=duplicate-code"
            );

            return;
        }


        String sql =
                "INSERT INTO departments " +
                "(department_name, " +
                "department_code, " +
                "description, " +
                "contact_email, " +
                "contact_phone, " +
                "active) " +
                "VALUES (?, ?, ?, ?, ?, 1)";


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    departmentName
            );

            statement.setString(
                    2,
                    departmentCode
            );

            statement.setString(
                    3,
                    emptyToNull(description)
            );

            statement.setString(
                    4,
                    emptyToNull(contactEmail)
            );

            statement.setString(
                    5,
                    emptyToNull(contactPhone)
            );


            statement.executeUpdate();
        }


        response.sendRedirect(
                request.getContextPath()
                + "/admin/departments?success=added"
        );
    }



    /*
     * =========================================
     * UPDATE DEPARTMENT
     * =========================================
     */
    private void updateDepartment(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws SQLException, IOException {

        long departmentId;

        try {

            departmentId =
                    Long.parseLong(
                            request.getParameter(
                                    "departmentId"
                            )
                    );

        } catch (Exception e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/departments?error=invalid-id"
            );

            return;
        }


        String departmentName =
                clean(
                        request.getParameter(
                                "departmentName"
                        )
                );

        String departmentCode =
                clean(
                        request.getParameter(
                                "departmentCode"
                        )
                );

        String description =
                clean(
                        request.getParameter(
                                "description"
                        )
                );

        String contactEmail =
                clean(
                        request.getParameter(
                                "contactEmail"
                        )
                );

        String contactPhone =
                clean(
                        request.getParameter(
                                "contactPhone"
                        )
                );


        if (departmentName == null ||
            departmentName.isBlank() ||
            departmentCode == null ||
            departmentCode.isBlank()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/departments?error=required"
            );

            return;
        }


        departmentCode =
                departmentCode
                        .trim()
                        .toUpperCase();


        /*
         * Check duplicate code,
         * excluding current department.
         */
        if (departmentCodeExists(
                departmentCode,
                departmentId
        )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/departments?error=duplicate-code"
            );

            return;
        }


        String sql =
                "UPDATE departments SET " +
                "department_name = ?, " +
                "department_code = ?, " +
                "description = ?, " +
                "contact_email = ?, " +
                "contact_phone = ? " +
                "WHERE department_id = ?";


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    departmentName
            );

            statement.setString(
                    2,
                    departmentCode
            );

            statement.setString(
                    3,
                    emptyToNull(description)
            );

            statement.setString(
                    4,
                    emptyToNull(contactEmail)
            );

            statement.setString(
                    5,
                    emptyToNull(contactPhone)
            );

            statement.setLong(
                    6,
                    departmentId
            );


            statement.executeUpdate();
        }


        response.sendRedirect(
                request.getContextPath()
                + "/admin/departments?success=updated"
        );
    }



    /*
     * =========================================
     * ACTIVE / INACTIVE
     * =========================================
     */
    private void toggleDepartmentStatus(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws SQLException, IOException {

        long departmentId;

        try {

            departmentId =
                    Long.parseLong(
                            request.getParameter(
                                    "departmentId"
                            )
                    );

        } catch (Exception e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/departments?error=invalid-id"
            );

            return;
        }


        String sql =
                "UPDATE departments " +
                "SET active = CASE " +
                "WHEN active = 1 THEN 0 " +
                "ELSE 1 END " +
                "WHERE department_id = ?";


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    departmentId
            );

            statement.executeUpdate();
        }


        response.sendRedirect(
                request.getContextPath()
                + "/admin/departments?success=status"
        );
    }



    /*
     * =========================================
     * CHECK UNIQUE DEPARTMENT CODE
     * =========================================
     */
    private boolean departmentCodeExists(
            String departmentCode,
            Long excludeDepartmentId
    ) throws SQLException {

        String sql;


        if (excludeDepartmentId == null) {

            sql =
                    "SELECT department_id " +
                    "FROM departments " +
                    "WHERE department_code = ? " +
                    "LIMIT 1";

        } else {

            sql =
                    "SELECT department_id " +
                    "FROM departments " +
                    "WHERE department_code = ? " +
                    "AND department_id <> ? " +
                    "LIMIT 1";
        }


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    departmentCode
            );


            if (excludeDepartmentId != null) {

                statement.setLong(
                        2,
                        excludeDepartmentId
                );
            }


            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                return resultSet.next();
            }
        }
    }



    /*
     * =========================================
     * ADMIN SESSION CHECK
     * =========================================
     */
    private boolean isAdminLoggedIn(
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
     * HELPER METHODS
     * =========================================
     */
    private String clean(
            String value
    ) {

        if (value == null) {
            return null;
        }

        return value.trim();
    }


    private String emptyToNull(
            String value
    ) {

        if (value == null ||
            value.isBlank()) {

            return null;
        }

        return value.trim();
    }
}