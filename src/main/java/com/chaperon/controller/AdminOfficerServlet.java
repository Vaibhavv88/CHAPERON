package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.chaperon.util.DBConnection;
import com.chaperon.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/officers")
public class AdminOfficerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        List<Map<String, Object>> officers =
                new ArrayList<>();

        List<Map<String, Object>> departments =
                new ArrayList<>();


        String officerSql =
                "SELECT " +
                "op.officer_profile_id, " +
                "op.user_id, " +
                "u.full_name, " +
                "u.email, " +
                "u.mobile, " +
                "u.account_status, " +
                "op.department_id, " +
                "d.department_name, " +
                "d.department_code, " +
                "op.designation, " +
                "op.employee_code, " +
                "op.active, " +
                "op.created_at " +
                "FROM officer_profiles op " +
                "JOIN users u ON op.user_id = u.user_id " +
                "JOIN departments d " +
                "ON op.department_id = d.department_id " +
                "WHERE u.role = 'OFFICER' " +
                "ORDER BY u.full_name ASC";


        String departmentSql =
                "SELECT department_id, " +
                "department_name, " +
                "department_code " +
                "FROM departments " +
                "WHERE active = 1 " +
                "ORDER BY department_name ASC";


        try (
            Connection connection =
                    DBConnection.getConnection()
        ) {

            /*
             * OFFICERS
             */
            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                officerSql
                        );

                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    Map<String, Object> officer =
                            new HashMap<>();

                    officer.put(
                            "officerProfileId",
                            resultSet.getLong(
                                    "officer_profile_id"
                            )
                    );

                    officer.put(
                            "userId",
                            resultSet.getLong(
                                    "user_id"
                            )
                    );

                    officer.put(
                            "fullName",
                            resultSet.getString(
                                    "full_name"
                            )
                    );

                    officer.put(
                            "email",
                            resultSet.getString(
                                    "email"
                            )
                    );

                    officer.put(
                            "mobile",
                            resultSet.getString(
                                    "mobile"
                            )
                    );

                    officer.put(
                            "accountStatus",
                            resultSet.getString(
                                    "account_status"
                            )
                    );

                    officer.put(
                            "departmentId",
                            resultSet.getLong(
                                    "department_id"
                            )
                    );

                    officer.put(
                            "departmentName",
                            resultSet.getString(
                                    "department_name"
                            )
                    );

                    officer.put(
                            "departmentCode",
                            resultSet.getString(
                                    "department_code"
                            )
                    );

                    officer.put(
                            "designation",
                            resultSet.getString(
                                    "designation"
                            )
                    );

                    officer.put(
                            "employeeCode",
                            resultSet.getString(
                                    "employee_code"
                            )
                    );

                    officer.put(
                            "active",
                            resultSet.getBoolean(
                                    "active"
                            )
                    );

                    officer.put(
                            "createdAt",
                            resultSet.getTimestamp(
                                    "created_at"
                            )
                    );

                    officers.add(officer);
                }
            }


            /*
             * ACTIVE DEPARTMENTS
             */
            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                departmentSql
                        );

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

                    departments.add(department);
                }
            }


            request.setAttribute(
                    "officers",
                    officers
            );

            request.setAttribute(
                    "departments",
                    departments
            );


            request.getRequestDispatcher(
                    "/WEB-INF/views/admin/officers.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            log(
                    "Unable to load officers.",
                    e
            );

            throw new ServletException(
                    "Unable to load officers.",
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

        try {

            if ("add".equals(action)) {

                addOfficer(
                        request,
                        response
                );

            } else if ("update".equals(action)) {

                updateOfficer(
                        request,
                        response
                );

            } else if ("toggle".equals(action)) {

                toggleOfficer(
                        request,
                        response
                );

            } else {

                redirect(
                        request,
                        response,
                        "error=invalid-action"
                );
            }

        } catch (Exception e) {

            log(
                    "Officer management operation failed.",
                    e
            );

            throw new ServletException(
                    "Unable to process officer request.",
                    e
            );
        }
    }



    /*
     * =========================================
     * ADD OFFICER
     * =========================================
     */

    private void addOfficer(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        String fullName =
                clean(
                        request.getParameter(
                                "fullName"
                        )
                );

        String email =
                clean(
                        request.getParameter(
                                "email"
                        )
                );

        String mobile =
                clean(
                        request.getParameter(
                                "mobile"
                        )
                );

        String password =
                request.getParameter(
                        "password"
                );

        String designation =
                clean(
                        request.getParameter(
                                "designation"
                        )
                );

        String employeeCode =
                clean(
                        request.getParameter(
                                "employeeCode"
                        )
                );

        long departmentId;

        try {

            departmentId =
                    Long.parseLong(
                            request.getParameter(
                                    "departmentId"
                            )
                    );

        } catch (Exception e) {

            redirect(
                    request,
                    response,
                    "error=invalid-department"
            );

            return;
        }


        if (fullName == null ||
            fullName.isBlank() ||
            email == null ||
            email.isBlank() ||
            password == null ||
            password.isBlank() ||
            employeeCode == null ||
            employeeCode.isBlank()) {

            redirect(
                    request,
                    response,
                    "error=required"
            );

            return;
        }


        email =
                email.toLowerCase();

        employeeCode =
                employeeCode.toUpperCase();


        try (
            Connection connection =
                    DBConnection.getConnection()
        ) {

            connection.setAutoCommit(false);

            try {

                /*
                 * Verify department
                 */
                if (!departmentExists(
                        connection,
                        departmentId
                )) {

                    connection.rollback();

                    redirect(
                            request,
                            response,
                            "error=invalid-department"
                    );

                    return;
                }


                /*
                 * Check email
                 */
                if (emailExists(
                        connection,
                        email,
                        null
                )) {

                    connection.rollback();

                    redirect(
                            request,
                            response,
                            "error=duplicate-email"
                    );

                    return;
                }


                /*
                 * Check employee code
                 */
                if (employeeCodeExists(
                        connection,
                        employeeCode,
                        null
                )) {

                    connection.rollback();

                    redirect(
                            request,
                            response,
                            "error=duplicate-code"
                    );

                    return;
                }


                String passwordHash =
                        PasswordUtil.hashPassword(
                                password
                        );


                /*
                 * CREATE USER
                 */
                String userSql =
                        "INSERT INTO users " +
                        "(full_name, email, mobile, " +
                        "password_hash, role, " +
                        "profile_completed, account_status) " +
                        "VALUES (?, ?, ?, ?, " +
                        "'OFFICER', 1, 'ACTIVE')";


                long userId;


                try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    userSql,
                                    Statement.RETURN_GENERATED_KEYS
                            )
                ) {

                    statement.setString(
                            1,
                            fullName
                    );

                    statement.setString(
                            2,
                            email
                    );

                    statement.setString(
                            3,
                            emptyToNull(mobile)
                    );

                    statement.setString(
                            4,
                            passwordHash
                    );


                    statement.executeUpdate();


                    try (
                        ResultSet keys =
                                statement.getGeneratedKeys()
                    ) {

                        if (!keys.next()) {

                            throw new Exception(
                                    "Unable to obtain generated user ID."
                            );
                        }

                        userId =
                                keys.getLong(1);
                    }
                }


                /*
                 * CREATE OFFICER PROFILE
                 */
                String profileSql =
                        "INSERT INTO officer_profiles " +
                        "(user_id, department_id, " +
                        "designation, employee_code, active) " +
                        "VALUES (?, ?, ?, ?, 1)";


                try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    profileSql
                            )
                ) {

                    statement.setLong(
                            1,
                            userId
                    );

                    statement.setLong(
                            2,
                            departmentId
                    );

                    statement.setString(
                            3,
                            emptyToNull(designation)
                    );

                    statement.setString(
                            4,
                            employeeCode
                    );

                    statement.executeUpdate();
                }


                connection.commit();


                redirect(
                        request,
                        response,
                        "success=added"
                );


            } catch (Exception e) {

                connection.rollback();

                throw e;

            } finally {

                try {
                    connection.setAutoCommit(true);
                } catch (Exception ignored) {
                }
            }
        }
    }



    /*
     * =========================================
     * UPDATE OFFICER
     * =========================================
     */

    private void updateOfficer(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        long officerProfileId;
        long userId;
        long departmentId;

        try {

            officerProfileId =
                    Long.parseLong(
                            request.getParameter(
                                    "officerProfileId"
                            )
                    );

            userId =
                    Long.parseLong(
                            request.getParameter(
                                    "userId"
                            )
                    );

            departmentId =
                    Long.parseLong(
                            request.getParameter(
                                    "departmentId"
                            )
                    );

        } catch (Exception e) {

            redirect(
                    request,
                    response,
                    "error=invalid-id"
            );

            return;
        }


        String fullName =
                clean(
                        request.getParameter(
                                "fullName"
                        )
                );

        String email =
                clean(
                        request.getParameter(
                                "email"
                        )
                );

        String mobile =
                clean(
                        request.getParameter(
                                "mobile"
                        )
                );

        String designation =
                clean(
                        request.getParameter(
                                "designation"
                        )
                );

        String employeeCode =
                clean(
                        request.getParameter(
                                "employeeCode"
                        )
                );

        String newPassword =
                request.getParameter(
                        "newPassword"
                );


        if (fullName == null ||
            fullName.isBlank() ||
            email == null ||
            email.isBlank() ||
            employeeCode == null ||
            employeeCode.isBlank()) {

            redirect(
                    request,
                    response,
                    "error=required"
            );

            return;
        }


        email =
                email.toLowerCase();

        employeeCode =
                employeeCode.toUpperCase();


        try (
            Connection connection =
                    DBConnection.getConnection()
        ) {

            connection.setAutoCommit(false);

            try {

                if (!departmentExists(
                        connection,
                        departmentId
                )) {

                    connection.rollback();

                    redirect(
                            request,
                            response,
                            "error=invalid-department"
                    );

                    return;
                }


                if (emailExists(
                        connection,
                        email,
                        userId
                )) {

                    connection.rollback();

                    redirect(
                            request,
                            response,
                            "error=duplicate-email"
                    );

                    return;
                }


                if (employeeCodeExists(
                        connection,
                        employeeCode,
                        officerProfileId
                )) {

                    connection.rollback();

                    redirect(
                            request,
                            response,
                            "error=duplicate-code"
                    );

                    return;
                }


                /*
                 * Update user
                 */
                String userSql =
                        "UPDATE users SET " +
                        "full_name = ?, " +
                        "email = ?, " +
                        "mobile = ? " +
                        "WHERE user_id = ? " +
                        "AND role = 'OFFICER'";


                try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    userSql
                            )
                ) {

                    statement.setString(
                            1,
                            fullName
                    );

                    statement.setString(
                            2,
                            email
                    );

                    statement.setString(
                            3,
                            emptyToNull(mobile)
                    );

                    statement.setLong(
                            4,
                            userId
                    );

                    statement.executeUpdate();
                }


                /*
                 * Optional password reset
                 */
                if (newPassword != null &&
                    !newPassword.isBlank()) {

                    String passwordHash =
                            PasswordUtil.hashPassword(
                                    newPassword
                            );

                    String passwordSql =
                            "UPDATE users " +
                            "SET password_hash = ? " +
                            "WHERE user_id = ? " +
                            "AND role = 'OFFICER'";


                    try (
                        PreparedStatement statement =
                                connection.prepareStatement(
                                        passwordSql
                                )
                    ) {

                        statement.setString(
                                1,
                                passwordHash
                        );

                        statement.setLong(
                                2,
                                userId
                        );

                        statement.executeUpdate();
                    }
                }


                /*
                 * Update profile
                 */
                String profileSql =
                        "UPDATE officer_profiles SET " +
                        "department_id = ?, " +
                        "designation = ?, " +
                        "employee_code = ? " +
                        "WHERE officer_profile_id = ? " +
                        "AND user_id = ?";


                try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    profileSql
                            )
                ) {

                    statement.setLong(
                            1,
                            departmentId
                    );

                    statement.setString(
                            2,
                            emptyToNull(designation)
                    );

                    statement.setString(
                            3,
                            employeeCode
                    );

                    statement.setLong(
                            4,
                            officerProfileId
                    );

                    statement.setLong(
                            5,
                            userId
                    );

                    statement.executeUpdate();
                }


                connection.commit();


                redirect(
                        request,
                        response,
                        "success=updated"
                );


            } catch (Exception e) {

                connection.rollback();

                throw e;

            } finally {

                try {
                    connection.setAutoCommit(true);
                } catch (Exception ignored) {
                }
            }
        }
    }



    /*
     * =========================================
     * ACTIVATE / DEACTIVATE
     * =========================================
     */

    private void toggleOfficer(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        long officerProfileId;
        long userId;

        try {

            officerProfileId =
                    Long.parseLong(
                            request.getParameter(
                                    "officerProfileId"
                            )
                    );

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
                    "error=invalid-id"
            );

            return;
        }


        try (
            Connection connection =
                    DBConnection.getConnection()
        ) {

            connection.setAutoCommit(false);

            try {

                String findSql =
                        "SELECT active " +
                        "FROM officer_profiles " +
                        "WHERE officer_profile_id = ? " +
                        "AND user_id = ?";


                boolean currentlyActive;


                try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    findSql
                            )
                ) {

                    statement.setLong(
                            1,
                            officerProfileId
                    );

                    statement.setLong(
                            2,
                            userId
                    );


                    try (
                        ResultSet resultSet =
                                statement.executeQuery()
                    ) {

                        if (!resultSet.next()) {

                            connection.rollback();

                            redirect(
                                    request,
                                    response,
                                    "error=invalid-id"
                            );

                            return;
                        }


                        currentlyActive =
                                resultSet.getBoolean(
                                        "active"
                                );
                    }
                }


                boolean newActive =
                        !currentlyActive;


                String profileSql =
                        "UPDATE officer_profiles " +
                        "SET active = ? " +
                        "WHERE officer_profile_id = ? " +
                        "AND user_id = ?";


                try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    profileSql
                            )
                ) {

                    statement.setBoolean(
                            1,
                            newActive
                    );

                    statement.setLong(
                            2,
                            officerProfileId
                    );

                    statement.setLong(
                            3,
                            userId
                    );

                    statement.executeUpdate();
                }


                /*
                 * Keep login account status synchronized.
                 */
                String userSql =
                        "UPDATE users " +
                        "SET account_status = ? " +
                        "WHERE user_id = ? " +
                        "AND role = 'OFFICER'";


                try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    userSql
                            )
                ) {

                    statement.setString(
                            1,
                            newActive
                                    ? "ACTIVE"
                                    : "INACTIVE"
                    );

                    statement.setLong(
                            2,
                            userId
                    );

                    statement.executeUpdate();
                }


                connection.commit();


                redirect(
                        request,
                        response,
                        "success=status"
                );


            } catch (Exception e) {

                connection.rollback();

                throw e;

            } finally {

                try {
                    connection.setAutoCommit(true);
                } catch (Exception ignored) {
                }
            }
        }
    }



    /*
     * =========================================
     * CHECKS
     * =========================================
     */

    private boolean departmentExists(
            Connection connection,
            long departmentId
    ) throws Exception {

        String sql =
                "SELECT department_id " +
                "FROM departments " +
                "WHERE department_id = ? " +
                "AND active = 1";


        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    departmentId
            );


            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                return resultSet.next();
            }
        }
    }


    private boolean emailExists(
            Connection connection,
            String email,
            Long excludeUserId
    ) throws Exception {

        String sql;

        if (excludeUserId == null) {

            sql =
                    "SELECT user_id " +
                    "FROM users " +
                    "WHERE email = ? " +
                    "LIMIT 1";

        } else {

            sql =
                    "SELECT user_id " +
                    "FROM users " +
                    "WHERE email = ? " +
                    "AND user_id <> ? " +
                    "LIMIT 1";
        }


        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    email
            );


            if (excludeUserId != null) {

                statement.setLong(
                        2,
                        excludeUserId
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


    private boolean employeeCodeExists(
            Connection connection,
            String employeeCode,
            Long excludeProfileId
    ) throws Exception {

        String sql;

        if (excludeProfileId == null) {

            sql =
                    "SELECT officer_profile_id " +
                    "FROM officer_profiles " +
                    "WHERE employee_code = ? " +
                    "LIMIT 1";

        } else {

            sql =
                    "SELECT officer_profile_id " +
                    "FROM officer_profiles " +
                    "WHERE employee_code = ? " +
                    "AND officer_profile_id <> ? " +
                    "LIMIT 1";
        }


        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    employeeCode
            );


            if (excludeProfileId != null) {

                statement.setLong(
                        2,
                        excludeProfileId
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
     * ADMIN AUTHORIZATION
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
     * HELPERS
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


    private void redirect(
            HttpServletRequest request,
            HttpServletResponse response,
            String parameter
    ) throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/officers?"
                + parameter
        );
    }
}