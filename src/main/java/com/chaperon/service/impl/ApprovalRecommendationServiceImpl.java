package com.chaperon.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.ApprovalDAO;
import com.chaperon.dao.BusinessApprovalDAO;
import com.chaperon.dao.impl.ApprovalDAOImpl;
import com.chaperon.dao.impl.BusinessApprovalDAOImpl;
import com.chaperon.model.ApprovalRule;
import com.chaperon.model.Business;
import com.chaperon.model.BusinessApproval;
import com.chaperon.service.ApprovalRecommendationService;
import com.chaperon.service.BusinessService;

public class ApprovalRecommendationServiceImpl
        implements ApprovalRecommendationService {

    private final ApprovalDAO approvalDAO;

    private final BusinessApprovalDAO businessApprovalDAO;

    private final BusinessService businessService;

    public ApprovalRecommendationServiceImpl() {

        approvalDAO =
                new ApprovalDAOImpl();

        businessApprovalDAO =
                new BusinessApprovalDAOImpl();

        businessService =
                new BusinessServiceImpl();
    }

    @Override
    public List<BusinessApproval> generateRecommendations(
            long userId
    ) throws SQLException {

        /*
         * =============================================
         * LOAD CURRENT BUSINESS PROFILE
         * =============================================
         */
        Business business =
                businessService.getBusinessByUserId(
                        userId
                );

        if (business == null) {

            return new ArrayList<>();
        }

        long businessId =
                business.getBusinessId();

        /*
         * =============================================
         * IMPORTANT FIX
         *
         * Remove only old recommendations which were
         * never started.
         *
         * Submitted / approved / rejected application
         * history remains preserved.
         * =============================================
         */
        businessApprovalDAO
                .deleteNotStartedByBusinessId(
                        businessId
                );

        /*
         * =============================================
         * LOAD ACTIVE RULES
         * =============================================
         */
        List<ApprovalRule> rules =
                approvalDAO.findActiveRules();

        if (rules == null ||
            rules.isEmpty()) {

            return businessApprovalDAO
                    .findByBusinessId(
                            businessId
                    );
        }

        /*
         * =============================================
         * RE-CALCULATE CURRENT APPLICABLE APPROVALS
         * =============================================
         */
        for (ApprovalRule rule : rules) {

            if (rule == null) {
                continue;
            }

            if (!matches(
                    business,
                    rule
            )) {

                continue;
            }

            /*
             * If an old submitted/approved/etc.
             * record already exists, do not duplicate it.
             */
            if (businessApprovalDAO.exists(
                    businessId,
                    rule.getApprovalId()
            )) {

                continue;
            }

            BusinessApproval recommendation =
                    new BusinessApproval();

            recommendation.setBusinessId(
                    businessId
            );

            recommendation.setApprovalId(
                    rule.getApprovalId()
            );

            recommendation.setRequirementStatus(
                    "REQUIRED"
            );

            recommendation.setPriorityLevel(
                    defaultText(
                            rule.getPriorityLevel(),
                            "MEDIUM"
                    )
            );

            recommendation.setReasonText(
                    defaultText(
                            rule.getReasonText(),
                            "Recommended based on your current business profile."
                    )
            );

            recommendation.setCurrentStatus(
                    "NOT_STARTED"
            );

            recommendation.setMandatory(
                    true
            );

            businessApprovalDAO
                    .saveBusinessApproval(
                            recommendation
                    );
        }

        /*
         * =============================================
         * RETURN REFRESHED ROADMAP
         * =============================================
         */
        return businessApprovalDAO
                .findByBusinessId(
                        businessId
                );
    }

    @Override
    public List<BusinessApproval> getRecommendations(
            long userId
    ) throws SQLException {

        Business business =
                businessService.getBusinessByUserId(
                        userId
                );

        if (business == null) {

            return new ArrayList<>();
        }

        return businessApprovalDAO
                .findByBusinessId(
                        business.getBusinessId()
                );
    }

    /*
     * =================================================
     * RULE MATCHING ENGINE
     * =================================================
     */
    private boolean matches(
            Business business,
            ApprovalRule rule
    ) {

        /*
         * Industry
         */
        if (!matchesText(
                rule.getIndustry(),
                business.getIndustry()
        )) {

            return false;
        }

        if (!matchesText(rule.getBusinessConstitution(), business.getBusinessConstitution())) {
            return false;
        }

        /*
         * Business Activity
         */
        if (!matchesText(
                rule.getBusinessActivity(),
                business.getBusinessActivity()
        )) {

            return false;
        }

        /*
         * Project Stage
         */
        if (!matchesText(
                rule.getProjectStage(),
                business.getProjectStage()
        )) {

            return false;
        }

        /*
         * State
         */
        if (!matchesText(
                rule.getState(),
                business.getState()
        )) {

            return false;
        }

        /*
         * Pollution Category
         */
        if (!matchesText(
                rule.getPollutionCategory(),
                business.getPollutionCategory()
        )) {

            return false;
        }

        /*
         * Employee Count
         */
        if (!matchesEmployeeCount(
                business,
                rule
        )) {

            return false;
        }

        /*
         * Investment
         */
        if (!matchesInvestment(
                business,
                rule
        )) {

            return false;
        }

        if (!matchesAnnualTurnover(business, rule)) {
            return false;
        }

        if (!matchesBoolean(rule.getInterstateSupplyRequired(), business.isInterstateSupply())
                || !matchesBoolean(rule.getHandlesPersonalDataRequired(), business.isHandlesPersonalData())
                || !matchesBoolean(rule.getStpiBenefitsRequired(), business.isSeeksStpiBenefits())
                || !matchesBoolean(rule.getSezUnitRequired(), business.isLocatedInSez())
                || !matchesBoolean(rule.getCertInApplicabilityRequired(), business.isCertInApplicable())
                || !matchesBoolean(rule.getTrademarkProtectionRequired(), business.isSeeksTrademarkProtection())
                || !matchesBoolean(rule.getSoftwareCopyrightRequired(), business.isSeeksSoftwareCopyright())) {
            return false;
        }

        /*
         * Hazardous Material
         */
        if (!matchesBoolean(
                rule.getHazardousMaterialRequired(),
                business.isHazardousMaterial()
        )) {

            return false;
        }

        /*
         * Boiler
         */
        if (!matchesBoolean(
                rule.getBoilerRequired(),
                business.isBoilerUsed()
        )) {

            return false;
        }

        /*
         * Industrial Waste
         */
        if (!matchesBoolean(
                rule.getIndustrialWasteRequired(),
                business.isIndustrialWaste()
        )) {

            return false;
        }

        /*
         * Groundwater
         */
        if (!matchesBoolean(
                rule.getGroundwaterRequired(),
                business.isGroundwaterRequired()
        )) {

            return false;
        }

        return true;
    }

    /*
     * =================================================
     * TEXT CONDITION
     *
     * NULL rule value means condition is irrelevant.
     * =================================================
     */
    private boolean matchesText(
            String ruleValue,
            String businessValue
    ) {

        if (ruleValue == null ||
            ruleValue.isBlank()) {

            return true;
        }

        if (businessValue == null ||
            businessValue.isBlank()) {

            return false;
        }

        return ruleValue
                .trim()
                .equalsIgnoreCase(
                        businessValue.trim()
                );
    }

    /*
     * =================================================
     * EMPLOYEE CONDITION
     * =================================================
     */
    private boolean matchesEmployeeCount(
            Business business,
            ApprovalRule rule
    ) {

        int employeeCount =
                business.getEmployeeCount();

        Integer minimum =
                rule.getMinimumEmployees();

        Integer maximum =
                rule.getMaximumEmployees();

        if (minimum != null &&
            employeeCount < minimum) {

            return false;
        }

        if (maximum != null &&
            employeeCount > maximum) {

            return false;
        }

        return true;
    }

    /*
     * =================================================
     * INVESTMENT CONDITION
     * =================================================
     */
    private boolean matchesInvestment(
            Business business,
            ApprovalRule rule
    ) {

        BigDecimal minimum =
                rule.getMinimumInvestment();

        BigDecimal maximum =
                rule.getMaximumInvestment();

        if (minimum == null &&
            maximum == null) {

            return true;
        }

        BigDecimal investment =
                business.getInvestmentAmount();

        if (investment == null) {

            return false;
        }

        if (minimum != null &&
            investment.compareTo(
                    minimum
            ) < 0) {

            return false;
        }

        if (maximum != null &&
            investment.compareTo(
                    maximum
            ) > 0) {

            return false;
        }

        return true;
    }

    /*
     * =================================================
     * BOOLEAN CONDITION
     *
     * NULL means ignore the condition.
     * =================================================
     */
    private boolean matchesBoolean(
            Boolean ruleValue,
            boolean businessValue
    ) {

        if (ruleValue == null) {

            return true;
        }

        return ruleValue.booleanValue()
                == businessValue;
    }

    private boolean matchesAnnualTurnover(Business business, ApprovalRule rule) {
        BigDecimal minimum = rule.getMinimumAnnualTurnover();
        BigDecimal maximum = rule.getMaximumAnnualTurnover();

        if (minimum == null && maximum == null) {
            return true;
        }

        BigDecimal annualTurnover = business.getAnnualTurnover();
        if (annualTurnover == null) {
            return false;
        }

        return (minimum == null || annualTurnover.compareTo(minimum) >= 0)
                && (maximum == null || annualTurnover.compareTo(maximum) <= 0);
    }

    private String defaultText(
            String value,
            String defaultValue
    ) {

        if (value == null ||
            value.isBlank()) {

            return defaultValue;
        }

        return value;
    }
}
