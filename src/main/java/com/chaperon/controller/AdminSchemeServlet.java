package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
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

@WebServlet("/admin/schemes")
public class AdminSchemeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }


        List<Map<String, Object>> schemes =
                new ArrayList<>();

        List<Map<String, Object>> departments =
                new ArrayList<>();


        String schemeSql =
                "SELECT " +
                "gs.scheme_id, " +
                "gs.scheme_name, " +
                "gs.department_id, " +
                "d.department_name, " +
                "d.department_code, " +
                "gs.description, " +
                "gs.eligibility, " +
                "gs.benefit, " +
                "gs.deadline, " +
                "gs.official_information_url, " +
                "gs.active, " +
                "gs.created_at, " +
                "gs.updated_at " +
                "FROM government_schemes gs " +
                "LEFT JOIN departments d " +
                "ON gs.department_id = d.department_id " +
                "ORDER BY gs.scheme_name ASC";


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
             * LOAD SCHEMES
             */
            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                schemeSql
                        );

                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    Map<String, Object> scheme =
                            new HashMap<>();

                    scheme.put(
                            "schemeId",
                            resultSet.getLong(
                                    "scheme_id"
                            )
                    );

                    scheme.put(
                            "schemeName",
                            resultSet.getString(
                                    "scheme_name"
                            )
                    );

                    Object departmentId = null;

                    long departmentIdValue =
                            resultSet.getLong(
                                    "department_id"
                            );

                    if (!resultSet.wasNull()) {
                        departmentId =
                                departmentIdValue;
                    }

                    scheme.put(
                            "departmentId",
                            departmentId
                    );

                    scheme.put(
                            "departmentName",
                            resultSet.getString(
                                    "department_name"
                            )
                    );

                    scheme.put(
                            "departmentCode",
                            resultSet.getString(
                                    "department_code"
                            )
                    );

                    scheme.put(
                            "description",
                            resultSet.getString(
                                    "description"
                            )
                    );

                    scheme.put(
                            "eligibility",
                            resultSet.getString(
                                    "eligibility"
                            )
                    );

                    scheme.put(
                            "benefit",
                            resultSet.getString(
                                    "benefit"
                            )
                    );

                    scheme.put(
                            "deadline",
                            resultSet.getDate(
                                    "deadline"
                            )
                    );

                    scheme.put(
                            "officialInformationUrl",
                            resultSet.getString(
                                    "official_information_url"
                            )
                    );

                    scheme.put(
                            "active",
                            resultSet.getBoolean(
                                    "active"
                            )
                    );

                    scheme.put(
                            "createdAt",
                            resultSet.getTimestamp(
                                    "created_at"
                            )
                    );

                    scheme.put(
                            "updatedAt",
                            resultSet.getTimestamp(
                                    "updated_at"
                            )
                    );

                    schemes.add(scheme);
                }
            }


            /*
             * LOAD ACTIVE DEPARTMENTS
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
                    "schemes",
                    schemes
            );

            request.setAttribute(
                    "departments",
                    departments
            );


            request.getRequestDispatcher(
                    "/WEB-INF/views/admin/schemes.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            log(
                    "Unable to load government schemes.",
                    e
            );

            throw new ServletException(
                    "Unable to load government schemes.",
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

                addScheme(
                        request,
                        response
                );

            } else if ("update".equals(action)) {

                updateScheme(
                        request,
                        response
                );

            } else if ("toggle".equals(action)) {

                toggleScheme(
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
                    "Government scheme operation failed.",
                    e
            );

            throw new ServletException(
                    "Unable to process government scheme request.",
                    e
            );
        }
    }


    /*
     * =========================================
     * ADD SCHEME
     * =========================================
     */
    private void addScheme(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        SchemeFormData data =
                readForm(request);


        if (!data.valid) {

            redirect(
                    request,
                    response,
                    "error=" + data.error
            );

            return;
        }


        try (
            Connection connection =
                    DBConnection.getConnection()
        ) {

            if (data.departmentId != null &&
                !departmentExists(
                        connection,
                        data.departmentId
                )) {

                redirect(
                        request,
                        response,
                        "error=invalid-department"
                );

                return;
            }


            String sql =
                    "INSERT INTO government_schemes (" +
                    "scheme_name, " +
                    "department_id, " +
                    "description, " +
                    "eligibility, " +
                    "benefit, " +
                    "deadline, " +
                    "official_information_url, " +
                    "active" +
                    ") VALUES (?, ?, ?, ?, ?, ?, ?, 1)";


            try (
                PreparedStatement statement =
                        connection.prepareStatement(sql)
            ) {

                setSchemeStatement(
                        statement,
                        data
                );

                statement.executeUpdate();
            }
        }


        redirect(
                request,
                response,
                "success=added"
        );
    }


    /*
     * =========================================
     * UPDATE SCHEME
     * =========================================
     */
    private void updateScheme(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        long schemeId;

        try {

            schemeId =
                    Long.parseLong(
                            request.getParameter(
                                    "schemeId"
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


        SchemeFormData data =
                readForm(request);


        if (!data.valid) {

            redirect(
                    request,
                    response,
                    "error=" + data.error
            );

            return;
        }


        try (
            Connection connection =
                    DBConnection.getConnection()
        ) {

            if (!schemeExists(
                    connection,
                    schemeId
            )) {

                redirect(
                        request,
                        response,
                        "error=invalid-id"
                );

                return;
            }


            if (data.departmentId != null &&
                !departmentExists(
                        connection,
                        data.departmentId
                )) {

                redirect(
                        request,
                        response,
                        "error=invalid-department"
                );

                return;
            }


            String sql =
                    "UPDATE government_schemes SET " +
                    "scheme_name = ?, " +
                    "department_id = ?, " +
                    "description = ?, " +
                    "eligibility = ?, " +
                    "benefit = ?, " +
                    "deadline = ?, " +
                    "official_information_url = ? " +
                    "WHERE scheme_id = ?";


            try (
                PreparedStatement statement =
                        connection.prepareStatement(sql)
            ) {

                setSchemeStatement(
                        statement,
                        data
                );

                statement.setLong(
                        8,
                        schemeId
                );

                statement.executeUpdate();
            }
        }


        redirect(
                request,
                response,
                "success=updated"
        );
    }


    /*
     * =========================================
     * ACTIVATE / DEACTIVATE
     * =========================================
     */
    private void toggleScheme(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        long schemeId;

        try {

            schemeId =
                    Long.parseLong(
                            request.getParameter(
                                    "schemeId"
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


        String sql =
                "UPDATE government_schemes " +
                "SET active = CASE " +
                "WHEN active = 1 THEN 0 " +
                "ELSE 1 END " +
                "WHERE scheme_id = ?";


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    schemeId
            );

            int rows =
                    statement.executeUpdate();


            if (rows == 0) {

                redirect(
                        request,
                        response,
                        "error=invalid-id"
                );

                return;
            }
        }


        redirect(
                request,
                response,
                "success=status"
        );
    }


    /*
     * =========================================
     * READ FORM
     * =========================================
     */
    private SchemeFormData readForm(
            HttpServletRequest request
    ) {

        SchemeFormData data =
                new SchemeFormData();


        data.schemeName =
                clean(
                        request.getParameter(
                                "schemeName"
                        )
                );

        data.description =
                clean(
                        request.getParameter(
                                "description"
                        )
                );

        data.eligibility =
                clean(
                        request.getParameter(
                                "eligibility"
                        )
                );

        data.benefit =
                clean(
                        request.getParameter(
                                "benefit"
                        )
                );

        data.officialInformationUrl =
                clean(
                        request.getParameter(
                                "officialInformationUrl"
                        )
                );


        if (data.schemeName == null ||
            data.schemeName.isBlank()) {

            data.error = "required";

            return data;
        }


        /*
         * Department optional
         */
        String departmentValue =
                request.getParameter(
                        "departmentId"
                );


        if (departmentValue != null &&
            !departmentValue.isBlank()) {

            try {

                data.departmentId =
                        Long.valueOf(
                                departmentValue
                        );

            } catch (Exception e) {

                data.error =
                        "invalid-department";

                return data;
            }
        }


        /*
         * Deadline optional
         */
        String deadlineValue =
                request.getParameter(
                        "deadline"
                );


        if (deadlineValue != null &&
            !deadlineValue.isBlank()) {

            try {

                data.deadline =
                        Date.valueOf(
                                deadlineValue
                        );

            } catch (Exception e) {

                data.error =
                        "invalid-deadline";

                return data;
            }
        }


        data.valid = true;

        return data;
    }


    /*
     * =========================================
     * PREPARED STATEMENT
     * =========================================
     */
    private void setSchemeStatement(
            PreparedStatement statement,
            SchemeFormData data
    ) throws Exception {

        statement.setString(
                1,
                data.schemeName
        );


        if (data.departmentId == null) {

            statement.setNull(
                    2,
                    java.sql.Types.BIGINT
            );

        } else {

            statement.setLong(
                    2,
                    data.departmentId
            );
        }


        statement.setString(
                3,
                emptyToNull(
                        data.description
                )
        );

        statement.setString(
                4,
                emptyToNull(
                        data.eligibility
                )
        );

        statement.setString(
                5,
                emptyToNull(
                        data.benefit
                )
        );


        if (data.deadline == null) {

            statement.setNull(
                    6,
                    java.sql.Types.DATE
            );

        } else {

            statement.setDate(
                    6,
                    data.deadline
            );
        }


        statement.setString(
                7,
                emptyToNull(
                        data.officialInformationUrl
                )
        );
    }


    /*
     * =========================================
     * DATABASE CHECKS
     * =========================================
     */
    private boolean schemeExists(
            Connection connection,
            long schemeId
    ) throws Exception {

        String sql =
                "SELECT scheme_id " +
                "FROM government_schemes " +
                "WHERE scheme_id = ?";


        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    schemeId
            );


            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                return resultSet.next();
            }
        }
    }


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
                + "/admin/schemes?"
                + parameter
        );
    }


    private static class SchemeFormData {

        private String schemeName;

        private Long departmentId;

        private String description;

        private String eligibility;

        private String benefit;

        private Date deadline;

        private String officialInformationUrl;

        private boolean valid = false;

        private String error = "invalid";
    }
}