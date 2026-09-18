package com.chaperon.model;

import java.math.BigDecimal;

public class IncentiveResult {

    private long incentiveRuleId;
    private Long schemeId;

    private String incentiveName;
    private String incentiveType;

    private BigDecimal calculationBasisAmount;
    private BigDecimal appliedRate;
    private BigDecimal estimatedBenefit;

    private String explanation;
    private String eligibilityStatus;

    public IncentiveResult() {
        this.calculationBasisAmount = BigDecimal.ZERO;
        this.appliedRate = BigDecimal.ZERO;
        this.estimatedBenefit = BigDecimal.ZERO;
    }

    public long getIncentiveRuleId() {
        return incentiveRuleId;
    }

    public void setIncentiveRuleId(long incentiveRuleId) {
        this.incentiveRuleId = incentiveRuleId;
    }

    public Long getSchemeId() {
        return schemeId;
    }

    public void setSchemeId(Long schemeId) {
        this.schemeId = schemeId;
    }

    public String getIncentiveName() {
        return incentiveName;
    }

    public void setIncentiveName(String incentiveName) {
        this.incentiveName = incentiveName;
    }

    public String getIncentiveType() {
        return incentiveType;
    }

    public void setIncentiveType(String incentiveType) {
        this.incentiveType = incentiveType;
    }

    public BigDecimal getCalculationBasisAmount() {
        return calculationBasisAmount;
    }

    public void setCalculationBasisAmount(
            BigDecimal calculationBasisAmount) {

        this.calculationBasisAmount =
                calculationBasisAmount;
    }

    public BigDecimal getAppliedRate() {
        return appliedRate;
    }

    public void setAppliedRate(BigDecimal appliedRate) {
        this.appliedRate = appliedRate;
    }

    public BigDecimal getEstimatedBenefit() {
        return estimatedBenefit;
    }

    public void setEstimatedBenefit(
            BigDecimal estimatedBenefit) {

        this.estimatedBenefit = estimatedBenefit;
    }

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }

    public String getEligibilityStatus() {
        return eligibilityStatus;
    }

    public void setEligibilityStatus(
            String eligibilityStatus) {

        this.eligibilityStatus = eligibilityStatus;
    }
}