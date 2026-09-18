package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.IncentiveRuleDAO;
import com.chaperon.model.IncentiveRule;
import com.chaperon.util.DBConnection;

public class IncentiveRuleDAOImpl
        implements IncentiveRuleDAO {

    private static final String FIND_ACTIVE_RULES =
            "SELECT " +
            "incentive_rule_id, " +
            "scheme_id, " +
            "rule_name, " +
            "incentive_type, " +
            "state, " +
            "district, " +
            "industry, " +
            "enterprise_category, " +
            "project_type, " +
            "minimum_investment, " +
            "maximum_investment, " +
            "minimum_employees, " +
            "maximum_employees, " +
            "calculation_type, " +
            "benefit_rate, " +
            "fixed_amount, " +
            "maximum_benefit, " +
            "validity_start, " +
            "validity_end, " +
            "calculation_basis, " +
            "eligibility_note, " +
            "active " +
            "FROM incentive_rules " +
            "WHERE active = 1 " +
            "AND (" +
            "validity_start IS NULL " +
            "OR validity_start <= CURRENT_DATE" +
            ") " +
            "AND (" +
            "validity_end IS NULL " +
            "OR validity_end >= CURRENT_DATE" +
            ") " +
            "ORDER BY incentive_rule_id";

    @Override
    public List<IncentiveRule> findActiveRules()
            throws Exception {

        List<IncentiveRule> rules =
                new ArrayList<>();

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            FIND_ACTIVE_RULES
                    );

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                IncentiveRule rule =
                        mapRule(resultSet);

                rules.add(rule);
            }
        }

        return rules;
    }

    private IncentiveRule mapRule(
            ResultSet resultSet) throws Exception {

        IncentiveRule rule =
                new IncentiveRule();

        rule.setIncentiveRuleId(
                resultSet.getLong(
                        "incentive_rule_id"
                )
        );

        long schemeId =
                resultSet.getLong("scheme_id");

        if (resultSet.wasNull()) {
            rule.setSchemeId(null);
        } else {
            rule.setSchemeId(schemeId);
        }

        rule.setRuleName(
                resultSet.getString("rule_name")
        );

        rule.setIncentiveType(
                resultSet.getString(
                        "incentive_type"
                )
        );

        rule.setState(
                resultSet.getString("state")
        );

        rule.setDistrict(
                resultSet.getString("district")
        );

        rule.setIndustry(
                resultSet.getString("industry")
        );

        rule.setEnterpriseCategory(
                resultSet.getString(
                        "enterprise_category"
                )
        );

        rule.setProjectType(
                resultSet.getString(
                        "project_type"
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

        int minimumEmployees =
                resultSet.getInt(
                        "minimum_employees"
                );

        if (resultSet.wasNull()) {
            rule.setMinimumEmployees(null);
        } else {
            rule.setMinimumEmployees(
                    minimumEmployees
            );
        }

        int maximumEmployees =
                resultSet.getInt(
                        "maximum_employees"
                );

        if (resultSet.wasNull()) {
            rule.setMaximumEmployees(null);
        } else {
            rule.setMaximumEmployees(
                    maximumEmployees
            );
        }

        rule.setCalculationType(
                resultSet.getString(
                        "calculation_type"
                )
        );

        rule.setBenefitRate(
                resultSet.getBigDecimal(
                        "benefit_rate"
                )
        );

        rule.setFixedAmount(
                resultSet.getBigDecimal(
                        "fixed_amount"
                )
        );

        rule.setMaximumBenefit(
                resultSet.getBigDecimal(
                        "maximum_benefit"
                )
        );

        Date validityStart =
                resultSet.getDate(
                        "validity_start"
                );

        if (validityStart != null) {
            rule.setValidityStart(
                    validityStart.toLocalDate()
            );
        }

        Date validityEnd =
                resultSet.getDate(
                        "validity_end"
                );

        if (validityEnd != null) {
            rule.setValidityEnd(
                    validityEnd.toLocalDate()
            );
        }

        rule.setCalculationBasis(
                resultSet.getString(
                        "calculation_basis"
                )
        );

        rule.setEligibilityNote(
                resultSet.getString(
                        "eligibility_note"
                )
        );

        rule.setActive(
                resultSet.getBoolean("active")
        );

        return rule;
    }
}