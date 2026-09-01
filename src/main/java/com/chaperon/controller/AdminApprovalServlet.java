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

@WebServlet("/admin/approvals")
public class AdminApprovalServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    /*
     * =========================================
     * GET - LOAD APPROVAL MASTER
     * =========================================
     */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        List<Map<String, Object>> approvals =
                new ArrayList<>();

        List<Map<String, Object>> departments =
                new ArrayList<>();


        String approvalSql =
                "SELECT " +
                "a.approval_id, " +
                "a.approval_name, " +
                "a.approval_code, " +
                "a.department_id, " +
                "d.department_name, " +
                "d.department_code, " +
                "a.description, " +
                "a.minimum_processing_days, " +
                "a.maximum_processing_days, " +
                "a.sla_days, " +
                "a.validity_type, " +
                "a.validity_value, " +
                "a.renewal_required, " +
                "a.renewal_before_days, " +
                "a.inspection_required, " +
                "a.official_reference_url, " +
                "a.active, " +
                "a.created_at, " +
                "a.updated_at " +
                "FROM approvals a " +
                "JOIN departments d " +
                "ON a.department_id = d.department_id " +
                "ORDER BY a.approval_name ASC";


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
             * ==========================
             * LOAD APPROVALS
             * ==========================
             */
            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                approvalSql
                        );

                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    Map<String, Object> approval =
                            new HashMap<>();

                    approval.put(
                            "approvalId",
                            resultSet.getLong(
                                    "approval_id"
                            )
                    );

                    approval.put(
                            "approvalName",
                            resultSet.getString(
                                    "approval_name"
                            )
                    );

                    approval.put(
                            "approvalCode",
                            resultSet.getString(
                                    "approval_code"
                            )
                    );

                    approval.put(
                            "departmentId",
                            resultSet.getLong(
                                    "department_id"
                            )
                    );

                    approval.put(
                            "departmentName",
                            resultSet.getString(
                                    "department_name"
                            )
                    );

                    approval.put(
                            "departmentCode",
                            resultSet.getString(
                                    "department_code"
                            )
                    );

                    approval.put(
                            "description",
                            resultSet.getString(
                                    "description"
                            )
                    );

                    approval.put(
                            "minimumProcessingDays",
                            getNullableInteger(
                                    resultSet,
                                    "minimum_processing_days"
                            )
                    );

                    approval.put(
                            "maximumProcessingDays",
                            getNullableInteger(
                                    resultSet,
                                    "maximum_processing_days"
                            )
                    );

                    approval.put(
                            "slaDays",
                            getNullableInteger(
                                    resultSet,
                                    "sla_days"
                            )
                    );

                    approval.put(
                            "validityType",
                            resultSet.getString(
                                    "validity_type"
                            )
                    );

                    approval.put(
                            "validityValue",
                            getNullableInteger(
                                    resultSet,
                                    "validity_value"
                            )
                    );

                    approval.put(
                            "renewalRequired",
                            resultSet.getBoolean(
                                    "renewal_required"
                            )
                    );

                    approval.put(
                            "renewalBeforeDays",
                            getNullableInteger(
                                    resultSet,
                                    "renewal_before_days"
                            )
                    );

                    approval.put(
                            "inspectionRequired",
                            resultSet.getBoolean(
                                    "inspection_required"
                            )
                    );

                    approval.put(
                            "officialReferenceUrl",
                            resultSet.getString(
                                    "official_reference_url"
                            )
                    );

                    approval.put(
                            "active",
                            resultSet.getBoolean(
                                    "active"
                            )
                    );

                    approval.put(
                            "createdAt",
                            resultSet.getTimestamp(
                                    "created_at"
                            )
                    );

                    approval.put(
                            "updatedAt",
                            resultSet.getTimestamp(
                                    "updated_at"
                            )
                    );

                    approvals.add(approval);
                }
            }


            /*
             * ==========================
             * LOAD ACTIVE DEPARTMENTS
             * ==========================
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
                    "approvals",
                    approvals
            );

            request.setAttribute(
                    "departments",
                    departments
            );


            request.getRequestDispatcher(
                    "/WEB-INF/views/admin/approvals.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            log(
                    "Unable to load approval master.",
                    e
            );

            throw new ServletException(
                    "Unable to load approval master.",
                    e
            );
        }
    }


    /*
     * =========================================
     * POST
     * =========================================
     */
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

                addApproval(
                        request,
                        response
                );

            } else if ("update".equals(action)) {

                updateApproval(
                        request,
                        response
                );

            } else if ("toggle".equals(action)) {

                toggleApproval(
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
                    "Approval management operation failed.",
                    e
            );

            throw new ServletException(
                    "Unable to process approval request.",
                    e
            );
        }
    }


    /*
     * =========================================
     * ADD APPROVAL
     * =========================================
     */
    private void addApproval(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        ApprovalFormData data =
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

            if (!departmentExists(
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


            if (approvalCodeExists(
                    connection,
                    data.approvalCode,
                    null
            )) {

                redirect(
                        request,
                        response,
                        "error=duplicate-code"
                );

                return;
            }


            String sql =
                    "INSERT INTO approvals (" +
                    "approval_name, " +
                    "approval_code, " +
                    "department_id, " +
                    "description, " +
                    "minimum_processing_days, " +
                    "maximum_processing_days, " +
                    "sla_days, " +
                    "validity_type, " +
                    "validity_value, " +
                    "renewal_required, " +
                    "renewal_before_days, " +
                    "inspection_required, " +
                    "official_reference_url, " +
                    "active" +
                    ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)";


            try (
                PreparedStatement statement =
                        connection.prepareStatement(sql)
            ) {

                setApprovalStatement(
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
     * UPDATE APPROVAL
     * =========================================
     */
    private void updateApproval(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        long approvalId;

        try {

            approvalId =
                    Long.parseLong(
                            request.getParameter(
                                    "approvalId"
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


        ApprovalFormData data =
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

            if (!approvalExists(
                    connection,
                    approvalId
            )) {

                redirect(
                        request,
                        response,
                        "error=invalid-id"
                );

                return;
            }


            if (!departmentExists(
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


            if (approvalCodeExists(
                    connection,
                    data.approvalCode,
                    approvalId
            )) {

                redirect(
                        request,
                        response,
                        "error=duplicate-code"
                );

                return;
            }


            String sql =
                    "UPDATE approvals SET " +
                    "approval_name = ?, " +
                    "approval_code = ?, " +
                    "department_id = ?, " +
                    "description = ?, " +
                    "minimum_processing_days = ?, " +
                    "maximum_processing_days = ?, " +
                    "sla_days = ?, " +
                    "validity_type = ?, " +
                    "validity_value = ?, " +
                    "renewal_required = ?, " +
                    "renewal_before_days = ?, " +
                    "inspection_required = ?, " +
                    "official_reference_url = ? " +
                    "WHERE approval_id = ?";


            try (
                PreparedStatement statement =
                        connection.prepareStatement(sql)
            ) {

                setApprovalStatement(
                        statement,
                        data
                );

                statement.setLong(
                        14,
                        approvalId
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
    private void toggleApproval(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        long approvalId;

        try {

            approvalId =
                    Long.parseLong(
                            request.getParameter(
                                    "approvalId"
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
                "UPDATE approvals " +
                "SET active = CASE " +
                "WHEN active = 1 THEN 0 " +
                "ELSE 1 END " +
                "WHERE approval_id = ?";


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    approvalId
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
    private ApprovalFormData readForm(
            HttpServletRequest request
    ) {

        ApprovalFormData data =
                new ApprovalFormData();


        data.approvalName =
                clean(
                        request.getParameter(
                                "approvalName"
                        )
                );

        data.approvalCode =
                clean(
                        request.getParameter(
                                "approvalCode"
                        )
                );

        data.description =
                clean(
                        request.getParameter(
                                "description"
                        )
                );

        data.validityType =
                clean(
                        request.getParameter(
                                "validityType"
                        )
                );

        data.officialReferenceUrl =
                clean(
                        request.getParameter(
                                "officialReferenceUrl"
                        )
                );


        /*
         * Required values
         */
        if (data.approvalName == null ||
            data.approvalName.isBlank() ||
            data.approvalCode == null ||
            data.approvalCode.isBlank()) {

            data.error = "required";
            return data;
        }


        data.approvalCode =
                data.approvalCode.toUpperCase();


        /*
         * Department
         */
        try {

            data.departmentId =
                    Long.parseLong(
                            request.getParameter(
                                    "departmentId"
                            )
                    );

        } catch (Exception e) {

            data.error =
                    "invalid-department";

            return data;
        }


        /*
         * Numeric fields
         */
        try {

            data.minimumProcessingDays =
                    parseNullableInteger(
                            request.getParameter(
                                    "minimumProcessingDays"
                            )
                    );

            data.maximumProcessingDays =
                    parseNullableInteger(
                            request.getParameter(
                                    "maximumProcessingDays"
                            )
                    );

            data.slaDays =
                    parseNullableInteger(
                            request.getParameter(
                                    "slaDays"
                            )
                    );

            data.validityValue =
                    parseNullableInteger(
                            request.getParameter(
                                    "validityValue"
                            )
                    );

            data.renewalBeforeDays =
                    parseNullableInteger(
                            request.getParameter(
                                    "renewalBeforeDays"
                            )
                    );

        } catch (NumberFormatException e) {

            data.error =
                    "invalid-number";

            return data;
        }


        /*
         * No negative values
         */
        if (isNegative(data.minimumProcessingDays) ||
            isNegative(data.maximumProcessingDays) ||
            isNegative(data.slaDays) ||
            isNegative(data.validityValue) ||
            isNegative(data.renewalBeforeDays)) {

            data.error =
                    "invalid-number";

            return data;
        }


        /*
         * Minimum cannot exceed maximum.
         */
        if (data.minimumProcessingDays != null &&
            data.maximumProcessingDays != null &&
            data.minimumProcessingDays >
                    data.maximumProcessingDays) {

            data.error =
                    "processing-range";

            return data;
        }


        /*
         * Boolean checkboxes
         */
        data.renewalRequired =
                request.getParameter(
                        "renewalRequired"
                ) != null;

        data.inspectionRequired =
                request.getParameter(
                        "inspectionRequired"
                ) != null;


        /*
         * Validity types supported by CHAPERON
         */
        if (data.validityType != null &&
            !data.validityType.isBlank()) {

            data.validityType =
                    data.validityType.toUpperCase();

            boolean validType =
                    "DAYS".equals(data.validityType) ||
                    "MONTHS".equals(data.validityType) ||
                    "YEARS".equals(data.validityType) ||
                    "PERMANENT".equals(data.validityType) ||
                    "UNTIL_CONDITION_CHANGES".equals(
                            data.validityType
                    );

            if (!validType) {

                data.error =
                        "invalid-validity";

                return data;
            }
        } else {

            data.validityType = null;
        }


        /*
         * Permanent / condition based approvals
         * don't require numeric validity.
         */
        if ("PERMANENT".equals(
                data.validityType
        ) ||
            "UNTIL_CONDITION_CHANGES".equals(
                    data.validityType
            )) {

            data.validityValue = null;
        }


        /*
         * DAYS/MONTHS/YEARS require value.
         */
        if (("DAYS".equals(data.validityType) ||
             "MONTHS".equals(data.validityType) ||
             "YEARS".equals(data.validityType))
             &&
             (data.validityValue == null ||
              data.validityValue <= 0)) {

            data.error =
                    "validity-value";

            return data;
        }


        /*
         * If renewal isn't required,
         * reminder days don't apply.
         */
        if (!data.renewalRequired) {

            data.renewalBeforeDays = null;
        }


        data.valid = true;

        return data;
    }


    /*
     * =========================================
     * PREPARED STATEMENT VALUES
     * =========================================
     */
    private void setApprovalStatement(
            PreparedStatement statement,
            ApprovalFormData data
    ) throws Exception {

        statement.setString(
                1,
                data.approvalName
        );

        statement.setString(
                2,
                data.approvalCode
        );

        statement.setLong(
                3,
                data.departmentId
        );

        statement.setString(
                4,
                emptyToNull(
                        data.description
                )
        );


        setNullableInteger(
                statement,
                5,
                data.minimumProcessingDays
        );

        setNullableInteger(
                statement,
                6,
                data.maximumProcessingDays
        );

        setNullableInteger(
                statement,
                7,
                data.slaDays
        );


        statement.setString(
                8,
                emptyToNull(
                        data.validityType
                )
        );


        setNullableInteger(
                statement,
                9,
                data.validityValue
        );


        statement.setBoolean(
                10,
                data.renewalRequired
        );


        setNullableInteger(
                statement,
                11,
                data.renewalBeforeDays
        );


        statement.setBoolean(
                12,
                data.inspectionRequired
        );


        statement.setString(
                13,
                emptyToNull(
                        data.officialReferenceUrl
                )
        );
    }


    /*
     * =========================================
     * DATABASE CHECKS
     * =========================================
     */
    private boolean approvalExists(
            Connection connection,
            long approvalId
    ) throws Exception {

        String sql =
                "SELECT approval_id " +
                "FROM approvals " +
                "WHERE approval_id = ?";


        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    approvalId
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


    private boolean approvalCodeExists(
            Connection connection,
            String approvalCode,
            Long excludeApprovalId
    ) throws Exception {

        String sql;


        if (excludeApprovalId == null) {

            sql =
                    "SELECT approval_id " +
                    "FROM approvals " +
                    "WHERE approval_code = ? " +
                    "LIMIT 1";

        } else {

            sql =
                    "SELECT approval_id " +
                    "FROM approvals " +
                    "WHERE approval_code = ? " +
                    "AND approval_id <> ? " +
                    "LIMIT 1";
        }


        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    approvalCode
            );


            if (excludeApprovalId != null) {

                statement.setLong(
                        2,
                        excludeApprovalId
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
    private Integer getNullableInteger(
            ResultSet resultSet,
            String column
    ) throws Exception {

        int value =
                resultSet.getInt(column);

        if (resultSet.wasNull()) {
            return null;
        }

        return value;
    }


    private Integer parseNullableInteger(
            String value
    ) throws NumberFormatException {

        if (value == null ||
            value.isBlank()) {

            return null;
        }

        return Integer.valueOf(
                value.trim()
        );
    }


    private boolean isNegative(
            Integer value
    ) {

        return value != null &&
               value < 0;
    }


    private void setNullableInteger(
            PreparedStatement statement,
            int index,
            Integer value
    ) throws Exception {

        if (value == null) {

            statement.setNull(
                    index,
                    java.sql.Types.INTEGER
            );

        } else {

            statement.setInt(
                    index,
                    value
            );
        }
    }


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
                + "/admin/approvals?"
                + parameter
        );
    }


    /*
     * =========================================
     * INTERNAL FORM DATA
     * =========================================
     */
    private static class ApprovalFormData {

        private String approvalName;
        private String approvalCode;

        private long departmentId;

        private String description;

        private Integer minimumProcessingDays;
        private Integer maximumProcessingDays;
        private Integer slaDays;

        private String validityType;
        private Integer validityValue;

        private boolean renewalRequired;
        private Integer renewalBeforeDays;

        private boolean inspectionRequired;

        private String officialReferenceUrl;

        private boolean valid = false;
        private String error = "invalid";
    }
}