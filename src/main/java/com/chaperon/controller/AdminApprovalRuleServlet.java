package com.chaperon.controller;

import java.io.IOException;
import java.math.BigDecimal;
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

@WebServlet("/admin/approval-rules")
public class AdminApprovalRuleServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }


        List<Map<String, Object>> rules =
                new ArrayList<>();

        List<Map<String, Object>> approvals =
                new ArrayList<>();


        String rulesSql =
                "SELECT " +
                "r.rule_id, " +
                "r.approval_id, " +
                "a.approval_name, " +
                "a.approval_code, " +
                "r.rule_name, " +
                "r.industry, " +
                "r.business_constitution, " +
                "r.business_activity, " +
                "r.project_stage, " +
                "r.pollution_category, " +
                "r.state, " +
                "r.minimum_employee_count, " +
                "r.maximum_employee_count, " +
                "r.minimum_investment, " +
                "r.maximum_investment, " +
                "r.minimum_annual_turnover, " +
                "r.maximum_annual_turnover, " +
                "r.interstate_supply_required, " +
                "r.handles_personal_data_required, " +
                "r.stpi_benefits_required, " +
                "r.sez_unit_required, " +
                "r.cert_in_applicability_required, " +
                "r.trademark_protection_required, " +
                "r.software_copyright_required, " +
                "r.hazardous_material_required, " +
                "r.boiler_required, " +
                "r.groundwater_required, " +
                "r.industrial_waste_required, " +
                "r.priority, " +
                "r.recommendation_reason, " +
                "r.active, " +
                "r.created_at, " +
                "r.updated_at " +
                "FROM approval_rules r " +
                "JOIN approvals a " +
                "ON r.approval_id = a.approval_id " +
                "ORDER BY r.rule_id DESC";


        String approvalsSql =
                "SELECT approval_id, approval_name, approval_code " +
                "FROM approvals " +
                "WHERE active = 1 " +
                "ORDER BY approval_name ASC";


        try (
            Connection connection =
                    DBConnection.getConnection()
        ) {

            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                rulesSql
                        );

                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    Map<String, Object> rule =
                            new HashMap<>();


                    rule.put(
                            "ruleId",
                            resultSet.getLong(
                                    "rule_id"
                            )
                    );

                    rule.put(
                            "approvalId",
                            resultSet.getLong(
                                    "approval_id"
                            )
                    );

                    rule.put(
                            "approvalName",
                            resultSet.getString(
                                    "approval_name"
                            )
                    );

                    rule.put(
                            "approvalCode",
                            resultSet.getString(
                                    "approval_code"
                            )
                    );

                    rule.put(
                            "ruleName",
                            resultSet.getString(
                                    "rule_name"
                            )
                    );

                    rule.put(
                            "industry",
                            resultSet.getString(
                                    "industry"
                            )
                    );

                    rule.put(
                            "businessConstitution",
                            resultSet.getString(
                                    "business_constitution"
                            )
                    );

                    rule.put(
                            "businessActivity",
                            resultSet.getString(
                                    "business_activity"
                            )
                    );

                    rule.put(
                            "projectStage",
                            resultSet.getString(
                                    "project_stage"
                            )
                    );

                    rule.put(
                            "pollutionCategory",
                            resultSet.getString(
                                    "pollution_category"
                            )
                    );

                    rule.put(
                            "state",
                            resultSet.getString(
                                    "state"
                            )
                    );

                    rule.put(
                            "minimumEmployeeCount",
                            getNullableInteger(
                                    resultSet,
                                    "minimum_employee_count"
                            )
                    );

                    rule.put(
                            "maximumEmployeeCount",
                            getNullableInteger(
                                    resultSet,
                                    "maximum_employee_count"
                            )
                    );

                    rule.put(
                            "minimumInvestment",
                            resultSet.getBigDecimal(
                                    "minimum_investment"
                            )
                    );

                    rule.put(
                            "maximumInvestment",
                            resultSet.getBigDecimal(
                                    "maximum_investment"
                            )
                    );

                    rule.put(
                            "minimumAnnualTurnover",
                            resultSet.getBigDecimal(
                                    "minimum_annual_turnover"
                            )
                    );

                    rule.put(
                            "maximumAnnualTurnover",
                            resultSet.getBigDecimal(
                                    "maximum_annual_turnover"
                            )
                    );

                    rule.put("interstateSupplyRequired",
                            getNullableBoolean(resultSet, "interstate_supply_required"));
                    rule.put("handlesPersonalDataRequired",
                            getNullableBoolean(resultSet, "handles_personal_data_required"));
                    rule.put("stpiBenefitsRequired",
                            getNullableBoolean(resultSet, "stpi_benefits_required"));
                    rule.put("sezUnitRequired",
                            getNullableBoolean(resultSet, "sez_unit_required"));
                    rule.put("certInApplicabilityRequired",
                            getNullableBoolean(resultSet, "cert_in_applicability_required"));
                    rule.put("trademarkProtectionRequired",
                            getNullableBoolean(resultSet, "trademark_protection_required"));
                    rule.put("softwareCopyrightRequired",
                            getNullableBoolean(resultSet, "software_copyright_required"));

                    rule.put(
                            "hazardousMaterialRequired",
                            getNullableBoolean(
                                    resultSet,
                                    "hazardous_material_required"
                            )
                    );

                    rule.put(
                            "boilerRequired",
                            getNullableBoolean(
                                    resultSet,
                                    "boiler_required"
                            )
                    );

                    rule.put(
                            "groundwaterRequired",
                            getNullableBoolean(
                                    resultSet,
                                    "groundwater_required"
                            )
                    );

                    rule.put(
                            "industrialWasteRequired",
                            getNullableBoolean(
                                    resultSet,
                                    "industrial_waste_required"
                            )
                    );

                    rule.put(
                            "priority",
                            resultSet.getString(
                                    "priority"
                            )
                    );

                    rule.put(
                            "recommendationReason",
                            resultSet.getString(
                                    "recommendation_reason"
                            )
                    );

                    rule.put(
                            "active",
                            resultSet.getBoolean(
                                    "active"
                            )
                    );

                    rule.put(
                            "createdAt",
                            resultSet.getTimestamp(
                                    "created_at"
                            )
                    );

                    rule.put(
                            "updatedAt",
                            resultSet.getTimestamp(
                                    "updated_at"
                            )
                    );


                    rules.add(rule);
                }
            }


            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                approvalsSql
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

                    approvals.add(approval);
                }
            }


            request.setAttribute(
                    "rules",
                    rules
            );

            request.setAttribute(
                    "approvals",
                    approvals
            );


            request.getRequestDispatcher(
                    "/WEB-INF/views/admin/approval-rules.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            log(
                    "Unable to load approval rules.",
                    e
            );

            throw new ServletException(
                    "Unable to load approval rules.",
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

                addRule(
                        request,
                        response
                );

            } else if ("update".equals(action)) {

                updateRule(
                        request,
                        response
                );

            } else if ("toggle".equals(action)) {

                toggleRule(
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
                    "Approval rule operation failed.",
                    e
            );

            throw new ServletException(
                    "Unable to process approval rule request.",
                    e
            );
        }
    }


    private void addRule(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        RuleFormData data =
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
                    data.approvalId
            )) {

                redirect(
                        request,
                        response,
                        "error=invalid-approval"
                );

                return;
            }


            String sql =
                    "INSERT INTO approval_rules (" +
                    "approval_id, " +
                    "rule_name, " +
                    "industry, " +
                    "business_constitution, " +
                    "business_activity, " +
                    "project_stage, " +
                    "pollution_category, " +
                    "state, " +
                    "minimum_employee_count, " +
                    "maximum_employee_count, " +
                    "minimum_investment, " +
                    "maximum_investment, " +
                    "minimum_annual_turnover, " +
                    "maximum_annual_turnover, " +
                    "interstate_supply_required, " +
                    "handles_personal_data_required, " +
                    "stpi_benefits_required, " +
                    "sez_unit_required, " +
                    "cert_in_applicability_required, " +
                    "trademark_protection_required, " +
                    "software_copyright_required, " +
                    "hazardous_material_required, " +
                    "boiler_required, " +
                    "groundwater_required, " +
                    "industrial_waste_required, " +
                    "priority, " +
                    "recommendation_reason, " +
                    "active" +
                    ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)";


            try (
                PreparedStatement statement =
                        connection.prepareStatement(sql)
            ) {

                setRuleStatement(
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


    private void updateRule(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        long ruleId;

        try {

            ruleId =
                    Long.parseLong(
                            request.getParameter(
                                    "ruleId"
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


        RuleFormData data =
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

            if (!ruleExists(
                    connection,
                    ruleId
            )) {

                redirect(
                        request,
                        response,
                        "error=invalid-id"
                );

                return;
            }


            if (!approvalExists(
                    connection,
                    data.approvalId
            )) {

                redirect(
                        request,
                        response,
                        "error=invalid-approval"
                );

                return;
            }


            String sql =
                    "UPDATE approval_rules SET " +
                    "approval_id = ?, " +
                    "rule_name = ?, " +
                    "industry = ?, " +
                    "business_constitution = ?, " +
                    "business_activity = ?, " +
                    "project_stage = ?, " +
                    "pollution_category = ?, " +
                    "state = ?, " +
                    "minimum_employee_count = ?, " +
                    "maximum_employee_count = ?, " +
                    "minimum_investment = ?, " +
                    "maximum_investment = ?, " +
                    "minimum_annual_turnover = ?, " +
                    "maximum_annual_turnover = ?, " +
                    "interstate_supply_required = ?, " +
                    "handles_personal_data_required = ?, " +
                    "stpi_benefits_required = ?, " +
                    "sez_unit_required = ?, " +
                    "cert_in_applicability_required = ?, " +
                    "trademark_protection_required = ?, " +
                    "software_copyright_required = ?, " +
                    "hazardous_material_required = ?, " +
                    "boiler_required = ?, " +
                    "groundwater_required = ?, " +
                    "industrial_waste_required = ?, " +
                    "priority = ?, " +
                    "recommendation_reason = ? " +
                    "WHERE rule_id = ?";


            try (
                PreparedStatement statement =
                        connection.prepareStatement(sql)
            ) {

                setRuleStatement(
                        statement,
                        data
                );

                statement.setLong(
                        28,
                        ruleId
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


    private void toggleRule(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        long ruleId;

        try {

            ruleId =
                    Long.parseLong(
                            request.getParameter(
                                    "ruleId"
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
                "UPDATE approval_rules " +
                "SET active = CASE " +
                "WHEN active = 1 THEN 0 " +
                "ELSE 1 END " +
                "WHERE rule_id = ?";


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    ruleId
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


    private RuleFormData readForm(
            HttpServletRequest request
    ) {

        RuleFormData data =
                new RuleFormData();


        try {

            data.approvalId =
                    Long.parseLong(
                            request.getParameter(
                                    "approvalId"
                            )
                    );

        } catch (Exception e) {

            data.error =
                    "invalid-approval";

            return data;
        }


        data.ruleName =
                clean(
                        request.getParameter(
                                "ruleName"
                        )
                );

        data.industry =
                clean(
                        request.getParameter(
                                "industry"
                        )
                );

        data.businessConstitution =
                clean(
                        request.getParameter(
                                "businessConstitution"
                        )
                );

        data.businessActivity =
                clean(
                        request.getParameter(
                                "businessActivity"
                        )
                );

        data.projectStage =
                clean(
                        request.getParameter(
                                "projectStage"
                        )
                );

        data.pollutionCategory =
                clean(
                        request.getParameter(
                                "pollutionCategory"
                        )
                );

        data.state =
                clean(
                        request.getParameter(
                                "state"
                        )
                );

        data.priority =
                clean(
                        request.getParameter(
                                "priority"
                        )
                );

        data.recommendationReason =
                clean(
                        request.getParameter(
                                "recommendationReason"
                        )
                );


        if (data.ruleName == null ||
            data.ruleName.isBlank()) {

            data.error =
                    "required";

            return data;
        }


        try {

            data.minimumEmployeeCount =
                    parseNullableInteger(
                            request.getParameter(
                                    "minimumEmployeeCount"
                            )
                    );

            data.maximumEmployeeCount =
                    parseNullableInteger(
                            request.getParameter(
                                    "maximumEmployeeCount"
                            )
                    );

            data.minimumInvestment =
                    parseNullableDecimal(
                            request.getParameter(
                                    "minimumInvestment"
                            )
                    );

            data.maximumInvestment =
                    parseNullableDecimal(
                            request.getParameter(
                                    "maximumInvestment"
                            )
                    );

            data.minimumAnnualTurnover =
                    parseNullableDecimal(
                            request.getParameter(
                                    "minimumAnnualTurnover"
                            )
                    );

            data.maximumAnnualTurnover =
                    parseNullableDecimal(
                            request.getParameter(
                                    "maximumAnnualTurnover"
                            )
                    );

        } catch (Exception e) {

            data.error =
                    "invalid-number";

            return data;
        }


        if (isNegative(
                data.minimumEmployeeCount
        ) ||
            isNegative(
                    data.maximumEmployeeCount
            ) ||
            isNegative(
                    data.minimumInvestment
            ) ||
            isNegative(
                    data.maximumInvestment
            ) ||
            isNegative(
                    data.minimumAnnualTurnover
            ) ||
            isNegative(
                    data.maximumAnnualTurnover
            )) {

            data.error =
                    "invalid-number";

            return data;
        }


        if (data.minimumEmployeeCount != null &&
            data.maximumEmployeeCount != null &&
            data.minimumEmployeeCount >
                    data.maximumEmployeeCount) {

            data.error =
                    "employee-range";

            return data;
        }


        if (data.minimumInvestment != null &&
            data.maximumInvestment != null &&
            data.minimumInvestment.compareTo(
                    data.maximumInvestment
            ) > 0) {

            data.error =
                    "investment-range";

            return data;
        }

        if (data.minimumAnnualTurnover != null &&
            data.maximumAnnualTurnover != null &&
            data.minimumAnnualTurnover.compareTo(
                    data.maximumAnnualTurnover
            ) > 0) {

            data.error = "turnover-range";
            return data;
        }

        data.interstateSupplyRequired = parseNullableBoolean(
                request.getParameter("interstateSupplyRequired"));
        data.handlesPersonalDataRequired = parseNullableBoolean(
                request.getParameter("handlesPersonalDataRequired"));
        data.stpiBenefitsRequired = parseNullableBoolean(
                request.getParameter("stpiBenefitsRequired"));
        data.sezUnitRequired = parseNullableBoolean(
                request.getParameter("sezUnitRequired"));
        data.certInApplicabilityRequired = parseNullableBoolean(
                request.getParameter("certInApplicabilityRequired"));
        data.trademarkProtectionRequired = parseNullableBoolean(
                request.getParameter("trademarkProtectionRequired"));
        data.softwareCopyrightRequired = parseNullableBoolean(
                request.getParameter("softwareCopyrightRequired"));


        data.hazardousMaterialRequired =
                parseNullableBoolean(
                        request.getParameter(
                                "hazardousMaterialRequired"
                        )
                );

        data.boilerRequired =
                parseNullableBoolean(
                        request.getParameter(
                                "boilerRequired"
                        )
                );

        data.groundwaterRequired =
                parseNullableBoolean(
                        request.getParameter(
                                "groundwaterRequired"
                        )
                );

        data.industrialWasteRequired =
                parseNullableBoolean(
                        request.getParameter(
                                "industrialWasteRequired"
                        )
                );


        if (data.priority == null ||
            data.priority.isBlank()) {

            data.priority =
                    "MEDIUM";

        } else {

            data.priority =
                    data.priority.toUpperCase();

            if (!"LOW".equals(data.priority) &&
                !"MEDIUM".equals(data.priority) &&
                !"HIGH".equals(data.priority)) {

                data.error =
                        "invalid-priority";

                return data;
            }
        }


        data.valid = true;

        return data;
    }


    private void setRuleStatement(
            PreparedStatement statement,
            RuleFormData data
    ) throws Exception {
        statement.setLong(1, data.approvalId);
        statement.setString(2, data.ruleName);
        statement.setString(3, emptyToNull(data.industry));
        statement.setString(4, emptyToNull(data.businessConstitution));
        statement.setString(5, emptyToNull(data.businessActivity));
        statement.setString(6, emptyToNull(data.projectStage));
        statement.setString(7, emptyToNull(data.pollutionCategory));
        statement.setString(8, emptyToNull(data.state));

        setNullableInteger(statement, 9, data.minimumEmployeeCount);
        setNullableInteger(statement, 10, data.maximumEmployeeCount);
        setNullableDecimal(statement, 11, data.minimumInvestment);
        setNullableDecimal(statement, 12, data.maximumInvestment);
        setNullableDecimal(statement, 13, data.minimumAnnualTurnover);
        setNullableDecimal(statement, 14, data.maximumAnnualTurnover);

        setNullableBoolean(statement, 15, data.interstateSupplyRequired);
        setNullableBoolean(statement, 16, data.handlesPersonalDataRequired);
        setNullableBoolean(statement, 17, data.stpiBenefitsRequired);
        setNullableBoolean(statement, 18, data.sezUnitRequired);
        setNullableBoolean(statement, 19, data.certInApplicabilityRequired);
        setNullableBoolean(statement, 20, data.trademarkProtectionRequired);
        setNullableBoolean(statement, 21, data.softwareCopyrightRequired);
        setNullableBoolean(statement, 22, data.hazardousMaterialRequired);
        setNullableBoolean(statement, 23, data.boilerRequired);
        setNullableBoolean(statement, 24, data.groundwaterRequired);
        setNullableBoolean(statement, 25, data.industrialWasteRequired);

        statement.setString(26, data.priority);
        statement.setString(27, emptyToNull(data.recommendationReason));
    }


    private boolean ruleExists(
            Connection connection,
            long ruleId
    ) throws Exception {

        String sql =
                "SELECT rule_id " +
                "FROM approval_rules " +
                "WHERE rule_id = ?";


        try (
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    ruleId
            );


            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                return resultSet.next();
            }
        }
    }


    private boolean approvalExists(
            Connection connection,
            long approvalId
    ) throws Exception {

        String sql =
                "SELECT approval_id " +
                "FROM approvals " +
                "WHERE approval_id = ? " +
                "AND active = 1";


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


    private Boolean getNullableBoolean(
            ResultSet resultSet,
            String column
    ) throws Exception {

        boolean value =
                resultSet.getBoolean(column);

        if (resultSet.wasNull()) {
            return null;
        }

        return value;
    }


    private Integer parseNullableInteger(
            String value
    ) {

        if (value == null ||
            value.isBlank()) {

            return null;
        }

        return Integer.valueOf(
                value.trim()
        );
    }


    private BigDecimal parseNullableDecimal(
            String value
    ) {

        if (value == null ||
            value.isBlank()) {

            return null;
        }

        return new BigDecimal(
                value.trim()
        );
    }


    private Boolean parseNullableBoolean(
            String value
    ) {

        if (value == null ||
            value.isBlank() ||
            "ANY".equalsIgnoreCase(value)) {

            return null;
        }

        if ("YES".equalsIgnoreCase(value) ||
            "TRUE".equalsIgnoreCase(value) ||
            "1".equals(value)) {

            return true;
        }

        if ("NO".equalsIgnoreCase(value) ||
            "FALSE".equalsIgnoreCase(value) ||
            "0".equals(value)) {

            return false;
        }

        return null;
    }


    private boolean isNegative(
            Integer value
    ) {

        return value != null &&
               value < 0;
    }


    private boolean isNegative(
            BigDecimal value
    ) {

        return value != null &&
               value.compareTo(
                       BigDecimal.ZERO
               ) < 0;
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


    private void setNullableDecimal(
            PreparedStatement statement,
            int index,
            BigDecimal value
    ) throws Exception {

        if (value == null) {

            statement.setNull(
                    index,
                    java.sql.Types.DECIMAL
            );

        } else {

            statement.setBigDecimal(
                    index,
                    value
            );
        }
    }


    private void setNullableBoolean(
            PreparedStatement statement,
            int index,
            Boolean value
    ) throws Exception {

        if (value == null) {

            statement.setNull(
                    index,
                    java.sql.Types.TINYINT
            );

        } else {

            statement.setBoolean(
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
                + "/admin/approval-rules?"
                + parameter
        );
    }


    private static class RuleFormData {

        private long approvalId;

        private String ruleName;

        private String industry;
        private String businessConstitution;
        private String businessActivity;
        private String projectStage;
        private String pollutionCategory;
        private String state;

        private Integer minimumEmployeeCount;
        private Integer maximumEmployeeCount;

        private BigDecimal minimumInvestment;
        private BigDecimal maximumInvestment;
        private BigDecimal minimumAnnualTurnover;
        private BigDecimal maximumAnnualTurnover;

        private Boolean interstateSupplyRequired;
        private Boolean handlesPersonalDataRequired;
        private Boolean stpiBenefitsRequired;
        private Boolean sezUnitRequired;
        private Boolean certInApplicabilityRequired;
        private Boolean trademarkProtectionRequired;
        private Boolean softwareCopyrightRequired;

        private Boolean hazardousMaterialRequired;
        private Boolean boilerRequired;
        private Boolean groundwaterRequired;
        private Boolean industrialWasteRequired;

        private String priority;
        private String recommendationReason;

        private boolean valid = false;
        private String error = "invalid";
    }
}
