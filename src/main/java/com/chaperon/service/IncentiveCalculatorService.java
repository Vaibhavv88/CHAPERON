package com.chaperon.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.IncentiveRuleDAO;
import com.chaperon.dao.impl.IncentiveRuleDAOImpl;
import com.chaperon.model.IncentiveCalculationRequest;
import com.chaperon.model.IncentiveResult;
import com.chaperon.model.IncentiveRule;

public class IncentiveCalculatorService {

    private static final BigDecimal ONE_HUNDRED =
            new BigDecimal("100");

    private final IncentiveRuleDAO incentiveRuleDAO;

    public IncentiveCalculatorService() {
        this.incentiveRuleDAO =
                new IncentiveRuleDAOImpl();
    }

    public List<IncentiveResult> calculate(
            IncentiveCalculationRequest request)
            throws Exception {

        validateRequest(request);

        List<IncentiveRule> activeRules =
                incentiveRuleDAO.findActiveRules();

        List<IncentiveResult> results =
                new ArrayList<>();

        for (IncentiveRule rule : activeRules) {

            if (!isEligible(rule, request)) {
                continue;
            }

            BigDecimal basisAmount =
                    findBasisAmount(rule, request);

            BigDecimal calculatedBenefit =
                    calculateBenefit(
                            rule,
                            request,
                            basisAmount
                    );

            if (calculatedBenefit.compareTo(
                    BigDecimal.ZERO) <= 0) {
                continue;
            }

            IncentiveResult result =
                    createResult(
                            rule,
                            basisAmount,
                            calculatedBenefit
                    );

            results.add(result);
        }

        return results;
    }

    public BigDecimal calculateTotal(
            List<IncentiveResult> results) {

        BigDecimal total = BigDecimal.ZERO;

        if (results == null) {
            return total;
        }

        for (IncentiveResult result : results) {

            if (result.getEstimatedBenefit()
                    != null) {

                total = total.add(
                        result.getEstimatedBenefit()
                );
            }
        }

        return total.setScale(
                2,
                RoundingMode.HALF_UP
        );
    }

    private boolean isEligible(
            IncentiveRule rule,
            IncentiveCalculationRequest request) {

        if (!matchesOptionalText(
                rule.getState(),
                request.getState())) {
            return false;
        }

        if (!matchesOptionalText(
                rule.getDistrict(),
                request.getDistrict())) {
            return false;
        }

        if (!matchesOptionalText(
                rule.getIndustry(),
                request.getIndustry())) {
            return false;
        }

        if (!matchesCategory(
                rule.getEnterpriseCategory(),
                request.getEnterpriseCategory())) {
            return false;
        }

        if (!matchesProjectType(
                rule.getProjectType(),
                request.getProjectType())) {
            return false;
        }

        BigDecimal investment =
                safeAmount(
                        request.getTotalInvestment()
                );

        if (rule.getMinimumInvestment() != null
                && investment.compareTo(
                        rule.getMinimumInvestment()
                ) < 0) {
            return false;
        }

        if (rule.getMaximumInvestment() != null
                && investment.compareTo(
                        rule.getMaximumInvestment()
                ) > 0) {
            return false;
        }

        if (rule.getMinimumEmployees() != null
                && request.getEmployeeCount()
                < rule.getMinimumEmployees()) {
            return false;
        }

        if (rule.getMaximumEmployees() != null
                && request.getEmployeeCount()
                > rule.getMaximumEmployees()) {
            return false;
        }

        if ("ELECTRICITY_DUTY_EXEMPTION"
                .equalsIgnoreCase(
                        rule.getIncentiveType()
                )
                && !request
                .isLocatedInIndustrialArea()) {

            return false;
        }

        if ("Environmental Investment Support"
                .equalsIgnoreCase(
                        rule.getRuleName()
                )
                && safeAmount(
                        request
                        .getEnvironmentalInvestment()
                ).compareTo(BigDecimal.ZERO) <= 0) {

            return false;
        }

        return true;
    }

    private BigDecimal findBasisAmount(
            IncentiveRule rule,
            IncentiveCalculationRequest request) {

        if ("Environmental Investment Support"
                .equalsIgnoreCase(
                        rule.getRuleName()
                )) {

            return safeAmount(
                    request.getEnvironmentalInvestment()
            );
        }

        return safeAmount(
                request.getTotalInvestment()
        );
    }

    private BigDecimal calculateBenefit(
            IncentiveRule rule,
            IncentiveCalculationRequest request,
            BigDecimal basisAmount) {

        BigDecimal benefit = BigDecimal.ZERO;

        String calculationType =
                rule.getCalculationType();

        if ("PERCENTAGE".equalsIgnoreCase(
                calculationType)) {

            BigDecimal rate =
                    safeAmount(
                            rule.getBenefitRate()
                    );

            benefit = basisAmount
                    .multiply(rate)
                    .divide(
                            ONE_HUNDRED,
                            2,
                            RoundingMode.HALF_UP
                    );

        } else if ("FIXED_AMOUNT"
                .equalsIgnoreCase(
                        calculationType)) {

            benefit = safeAmount(
                    rule.getFixedAmount()
            );

        } else if ("PER_EMPLOYEE"
                .equalsIgnoreCase(
                        calculationType)) {

            BigDecimal amountPerEmployee =
                    safeAmount(
                            rule.getFixedAmount()
                    );

            benefit = amountPerEmployee.multiply(
                    BigDecimal.valueOf(
                            request.getEmployeeCount()
                    )
            );
        }

        if (rule.getMaximumBenefit() != null
                && benefit.compareTo(
                        rule.getMaximumBenefit()
                ) > 0) {

            benefit = rule.getMaximumBenefit();
        }

        return benefit.setScale(
                2,
                RoundingMode.HALF_UP
        );
    }

    private IncentiveResult createResult(
            IncentiveRule rule,
            BigDecimal basisAmount,
            BigDecimal calculatedBenefit) {

        IncentiveResult result =
                new IncentiveResult();

        result.setIncentiveRuleId(
                rule.getIncentiveRuleId()
        );

        result.setSchemeId(
                rule.getSchemeId()
        );

        result.setIncentiveName(
                rule.getRuleName()
        );

        result.setIncentiveType(
                rule.getIncentiveType()
        );

        result.setCalculationBasisAmount(
                basisAmount
        );

        result.setAppliedRate(
                safeAmount(
                        rule.getBenefitRate()
                )
        );

        result.setEstimatedBenefit(
                calculatedBenefit
        );

        result.setEligibilityStatus(
                "POTENTIALLY_ELIGIBLE"
        );

        result.setExplanation(
                buildExplanation(
                        rule,
                        calculatedBenefit
                )
        );

        return result;
    }

    private String buildExplanation(
            IncentiveRule rule,
            BigDecimal calculatedBenefit) {

        StringBuilder explanation =
                new StringBuilder();

        explanation.append(
                "Matched rule: "
        );

        explanation.append(
                rule.getRuleName()
        );

        explanation.append(
                ". Estimated benefit: Rs. "
        );

        explanation.append(
                calculatedBenefit
                        .setScale(
                                2,
                                RoundingMode.HALF_UP
                        )
                        .toPlainString()
        );

        if (rule.getEligibilityNote() != null
                && !rule.getEligibilityNote()
                .isBlank()) {

            explanation.append(". ");
            explanation.append(
                    rule.getEligibilityNote()
            );
        }

        return explanation.toString();
    }

    private boolean matchesOptionalText(
            String ruleValue,
            String requestValue) {

        if (ruleValue == null
                || ruleValue.isBlank()) {
            return true;
        }

        return requestValue != null
                && ruleValue.trim()
                .equalsIgnoreCase(
                        requestValue.trim()
                );
    }

    private boolean matchesCategory(
            String ruleCategory,
            String requestCategory) {

        if (ruleCategory == null
                || "ALL".equalsIgnoreCase(
                        ruleCategory)) {
            return true;
        }

        return requestCategory != null
                && ruleCategory.equalsIgnoreCase(
                        requestCategory
                );
    }

    private boolean matchesProjectType(
            String ruleProjectType,
            String requestProjectType) {

        if (ruleProjectType == null
                || "BOTH".equalsIgnoreCase(
                        ruleProjectType)) {
            return true;
        }

        return requestProjectType != null
                && ruleProjectType
                .equalsIgnoreCase(
                        requestProjectType
                );
    }

    private BigDecimal safeAmount(
            BigDecimal value) {

        return value == null
                ? BigDecimal.ZERO
                : value;
    }

    private void validateRequest(
            IncentiveCalculationRequest request) {

        if (request == null) {
            throw new IllegalArgumentException(
                    "Calculation details are required."
            );
        }

        if (request.getUserId() <= 0) {
            throw new IllegalArgumentException(
                    "Valid user is required."
            );
        }

        if (request.getBusinessId() <= 0) {
            throw new IllegalArgumentException(
                    "Valid business is required."
            );
        }

        if (request.getEnterpriseCategory() == null
                || request.getEnterpriseCategory()
                .isBlank()) {

            throw new IllegalArgumentException(
                    "Enterprise category is required."
            );
        }

        if (request.getProjectType() == null
                || request.getProjectType()
                .isBlank()) {

            throw new IllegalArgumentException(
                    "Project type is required."
            );
        }

        if (request.getState() == null
                || request.getState().isBlank()) {

            throw new IllegalArgumentException(
                    "State is required."
            );
        }

        if (request.getIndustry() == null
                || request.getIndustry().isBlank()) {

            throw new IllegalArgumentException(
                    "Industry is required."
            );
        }

        if (safeAmount(
                request.getTotalInvestment()
        ).compareTo(BigDecimal.ZERO) <= 0) {

            throw new IllegalArgumentException(
                    "Investment must be greater than zero."
            );
        }

        if (request.getEmployeeCount() < 0) {
            throw new IllegalArgumentException(
                    "Employee count cannot be negative."
            );
        }
    }
}