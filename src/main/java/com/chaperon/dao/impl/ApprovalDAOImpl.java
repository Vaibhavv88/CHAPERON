package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.ApprovalDAO;
import com.chaperon.model.Approval;
import com.chaperon.model.ApprovalRule;
import com.chaperon.util.DBConnection;

public class ApprovalDAOImpl implements ApprovalDAO {

    private static final String FIND_ALL_ACTIVE_APPROVALS =
            "SELECT * FROM approvals " +
            "WHERE active = TRUE " +
            "ORDER BY approval_name";

    private static final String FIND_APPROVAL_BY_ID =
            "SELECT a.*, d.department_name " +
            "FROM approvals a " +
            "JOIN departments d " +
            "ON a.department_id = d.department_id " +
            "WHERE a.approval_id = ?"; 
    
    
    private static final String FIND_ACTIVE_RULES =
            "SELECT * FROM approval_rules " +
            "WHERE active = TRUE " +
            "ORDER BY rule_id";

    private static final String FIND_RULES_BY_APPROVAL_ID =
            "SELECT * FROM approval_rules " +
            "WHERE approval_id = ? " +
            "AND active = TRUE " +
            "ORDER BY rule_id";

    @Override
    public List<Approval> findAllActiveApprovals()
            throws SQLException {

        List<Approval> approvals =
                new ArrayList<>();

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            FIND_ALL_ACTIVE_APPROVALS
                    );

            ResultSet resultSet =
                    preparedStatement.executeQuery()
        ) {

            while (resultSet.next()) {

                Approval approval =
                        mapApproval(resultSet);

                approvals.add(approval);
            }
        }

        return approvals;
    }

    @Override
    public Approval findApprovalById(long approvalId)
            throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            FIND_APPROVAL_BY_ID
                    )
        ) {

            preparedStatement.setLong(
                    1,
                    approvalId
            );

            try (
                ResultSet resultSet =
                        preparedStatement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return mapApproval(
                            resultSet
                    );
                }
            }
        }

        return null;
    }

    @Override
    public List<ApprovalRule> findActiveRules()
            throws SQLException {

        List<ApprovalRule> rules =
                new ArrayList<>();

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            FIND_ACTIVE_RULES
                    );

            ResultSet resultSet =
                    preparedStatement.executeQuery()
        ) {

            while (resultSet.next()) {

                ApprovalRule rule =
                        mapApprovalRule(
                                resultSet
                        );

                rules.add(rule);
            }
        }

        return rules;
    }

    @Override
    public List<ApprovalRule> findRulesByApprovalId(
            long approvalId
    ) throws SQLException {

        List<ApprovalRule> rules =
                new ArrayList<>();

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            FIND_RULES_BY_APPROVAL_ID
                    )
        ) {

            preparedStatement.setLong(
                    1,
                    approvalId
            );

            try (
                ResultSet resultSet =
                        preparedStatement.executeQuery()
            ) {

                while (resultSet.next()) {

                    ApprovalRule rule =
                            mapApprovalRule(
                                    resultSet
                            );

                    rules.add(rule);
                }
            }
        }

        return rules;
    }

    private Approval mapApproval(
            ResultSet resultSet
    ) throws SQLException {

        Approval approval =
                new Approval();

        approval.setApprovalId(
                resultSet.getLong(
                        "approval_id"
                )
        );

        approval.setApprovalName(
                resultSet.getString(
                        "approval_name"
                )
        );

        approval.setApprovalCode(
                resultSet.getString(
                        "approval_code"
                )
        );

        approval.setDepartmentId(
                resultSet.getLong(
                        "department_id"
                )
        );
        
        approval.setDepartmentName(
                getOptionalString(
                        resultSet,
                        "department_name"
                )
        );

        approval.setDescription(
                resultSet.getString(
                        "description"
                )
        );

        approval.setMinimumProcessingDays(
                getNullableInteger(
                        resultSet,
                        "minimum_processing_days"
                )
        );

        approval.setMaximumProcessingDays(
                getNullableInteger(
                        resultSet,
                        "maximum_processing_days"
                )
        );

        approval.setSlaDays(
                getNullableInteger(
                        resultSet,
                        "sla_days"
                )
        );

        approval.setValidityType(
                resultSet.getString(
                        "validity_type"
                )
        );

        approval.setValidityValue(
                getNullableInteger(
                        resultSet,
                        "validity_value"
                )
        );

        approval.setRenewalRequired(
                resultSet.getBoolean(
                        "renewal_required"
                )
        );

        approval.setRenewalBeforeDays(
                getNullableInteger(
                        resultSet,
                        "renewal_before_days"
                )
        );

        approval.setInspectionRequired(
                resultSet.getBoolean(
                        "inspection_required"
                )
        );

        approval.setOfficialReferenceUrl(
                resultSet.getString(
                        "official_reference_url"
                )
        );

        approval.setActive(
                resultSet.getBoolean(
                        "active"
                )
        );

        approval.setCreatedAt(
                resultSet.getTimestamp(
                        "created_at"
                )
        );

        approval.setUpdatedAt(
                resultSet.getTimestamp(
                        "updated_at"
                )
        );

        return approval;
    }

    private ApprovalRule mapApprovalRule(
            ResultSet resultSet
    ) throws SQLException {

        ApprovalRule rule =
                new ApprovalRule();

        rule.setRuleId(
                resultSet.getLong(
                        "rule_id"
                )
        );

        rule.setApprovalId(
                resultSet.getLong(
                        "approval_id"
                )
        );

        rule.setIndustry(
                resultSet.getString(
                        "industry"
                )
        );

        rule.setBusinessActivity(
                resultSet.getString(
                        "business_activity"
                )
        );

        rule.setProjectStage(
                resultSet.getString(
                        "project_stage"
                )
        );

        rule.setState(
                resultSet.getString(
                        "state"
                )
        );

        rule.setPollutionCategory(
                resultSet.getString(
                        "pollution_category"
                )
        );

        rule.setMinimumEmployees(
                getNullableInteger(
                        resultSet,
                        "minimum_employee_count"
                )
        );

        rule.setMaximumEmployees(
                getNullableInteger(
                        resultSet,
                        "maximum_employee_count"
                )
        );

        rule.setMinimumInvestment(
                resultSet.getBigDecimal(
                        "minimum_investment"
                )
        );

        rule.setMaximumInvestment(
                resultSet.getBigDecimal(
                        "maximum_investment"
                )
        );

        rule.setHazardousMaterialRequired(
                getNullableBoolean(
                        resultSet,
                        "hazardous_material_required"
                )
        );

        rule.setBoilerRequired(
                getNullableBoolean(
                        resultSet,
                        "boiler_required"
                )
        );

        rule.setGroundwaterRequired(
                getNullableBoolean(
                        resultSet,
                        "groundwater_required"
                )
        );

        rule.setIndustrialWasteRequired(
                getNullableBoolean(
                        resultSet,
                        "industrial_waste_required"
                )
        );

        rule.setPriorityLevel(
                resultSet.getString(
                        "priority"
                )
        );

        rule.setReasonText(
                resultSet.getString(
                        "recommendation_reason"
                )
        );

        rule.setActive(
                resultSet.getBoolean(
                        "active"
                )
        );

        rule.setCreatedAt(
                resultSet.getTimestamp(
                        "created_at"
                )
        );

        return rule;
    }

    private Integer getNullableInteger(
            ResultSet resultSet,
            String columnName
    ) throws SQLException {

        int value =
                resultSet.getInt(
                        columnName
                );

        if (resultSet.wasNull()) {
            return null;
        }

        return value;
    }

    private Boolean getNullableBoolean(
            ResultSet resultSet,
            String columnName
    ) throws SQLException {

        boolean value =
                resultSet.getBoolean(
                        columnName
                );

        if (resultSet.wasNull()) {
            return null;
        }

        return value;
    }
    private String getOptionalString(
            ResultSet resultSet,
            String columnName
    ) {
        try {
            return resultSet.getString(columnName);
        } catch (SQLException e) {
            return null;
        }
    }
}