package com.chaperon.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class IncentiveRule {

    private long incentiveRuleId;
    private Long schemeId;

    private String ruleName;
    private String incentiveType;

    private String state;
    private String district;
    private String industry;

    private String enterpriseCategory;
    private String projectType;

    private BigDecimal minimumInvestment;
    private BigDecimal maximumInvestment;

    private Integer minimumEmployees;
    private Integer maximumEmployees;

    private String calculationType;

    private BigDecimal benefitRate;
    private BigDecimal fixedAmount;
    private BigDecimal maximumBenefit;

    private LocalDate validityStart;
    private LocalDate validityEnd;

    private String calculationBasis;
    private String eligibilityNote;

    private boolean active;

    public IncentiveRule() {
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

    public String getRuleName() {
        return ruleName;
    }

    public void setRuleName(String ruleName) {
        this.ruleName = ruleName;
    }

    public String getIncentiveType() {
        return incentiveType;
    }

    public void setIncentiveType(String incentiveType) {
        this.incentiveType = incentiveType;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getIndustry() {
        return industry;
    }

    public void setIndustry(String industry) {
        this.industry = industry;
    }

    public String getEnterpriseCategory() {
        return enterpriseCategory;
    }

    public void setEnterpriseCategory(
            String enterpriseCategory) {

        this.enterpriseCategory = enterpriseCategory;
    }

    public String getProjectType() {
        return projectType;
    }

    public void setProjectType(String projectType) {
        this.projectType = projectType;
    }

    public BigDecimal getMinimumInvestment() {
        return minimumInvestment;
    }

    public void setMinimumInvestment(
            BigDecimal minimumInvestment) {

        this.minimumInvestment = minimumInvestment;
    }

    public BigDecimal getMaximumInvestment() {
        return maximumInvestment;
    }

    public void setMaximumInvestment(
            BigDecimal maximumInvestment) {

        this.maximumInvestment = maximumInvestment;
    }

    public Integer getMinimumEmployees() {
        return minimumEmployees;
    }

    public void setMinimumEmployees(
            Integer minimumEmployees) {

        this.minimumEmployees = minimumEmployees;
    }

    public Integer getMaximumEmployees() {
        return maximumEmployees;
    }

    public void setMaximumEmployees(
            Integer maximumEmployees) {

        this.maximumEmployees = maximumEmployees;
    }

    public String getCalculationType() {
        return calculationType;
    }

    public void setCalculationType(
            String calculationType) {

        this.calculationType = calculationType;
    }

    public BigDecimal getBenefitRate() {
        return benefitRate;
    }

    public void setBenefitRate(BigDecimal benefitRate) {
        this.benefitRate = benefitRate;
    }

    public BigDecimal getFixedAmount() {
        return fixedAmount;
    }

    public void setFixedAmount(BigDecimal fixedAmount) {
        this.fixedAmount = fixedAmount;
    }

    public BigDecimal getMaximumBenefit() {
        return maximumBenefit;
    }

    public void setMaximumBenefit(
            BigDecimal maximumBenefit) {

        this.maximumBenefit = maximumBenefit;
    }

    public LocalDate getValidityStart() {
        return validityStart;
    }

    public void setValidityStart(LocalDate validityStart) {
        this.validityStart = validityStart;
    }

    public LocalDate getValidityEnd() {
        return validityEnd;
    }

    public void setValidityEnd(LocalDate validityEnd) {
        this.validityEnd = validityEnd;
    }

    public String getCalculationBasis() {
        return calculationBasis;
    }

    public void setCalculationBasis(
            String calculationBasis) {

        this.calculationBasis = calculationBasis;
    }

    public String getEligibilityNote() {
        return eligibilityNote;
    }

    public void setEligibilityNote(
            String eligibilityNote) {

        this.eligibilityNote = eligibilityNote;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}