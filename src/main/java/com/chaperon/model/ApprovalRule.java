package com.chaperon.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class ApprovalRule {

    private long ruleId;
    private long approvalId;

    private String industry;
    private String businessActivity;
    private String projectStage;
    private String state;
    private String pollutionCategory;

    private Boolean hazardousMaterialRequired;
    private Boolean boilerRequired;
    private Boolean groundwaterRequired;
    private Boolean industrialWasteRequired;

    private Integer minimumEmployees;
    private Integer maximumEmployees;

    private BigDecimal minimumInvestment;
    private BigDecimal maximumInvestment;

    private String priorityLevel;

    private String reasonText;

    private boolean active;

    private Timestamp createdAt;
    private Timestamp updatedAt;

    public ApprovalRule() {
    }

    public long getRuleId() {
        return ruleId;
    }

    public void setRuleId(long ruleId) {
        this.ruleId = ruleId;
    }

    public long getApprovalId() {
        return approvalId;
    }

    public void setApprovalId(long approvalId) {
        this.approvalId = approvalId;
    }

    public String getIndustry() {
        return industry;
    }

    public void setIndustry(String industry) {
        this.industry = industry;
    }

    public String getBusinessActivity() {
        return businessActivity;
    }

    public void setBusinessActivity(String businessActivity) {
        this.businessActivity = businessActivity;
    }

    public String getProjectStage() {
        return projectStage;
    }

    public void setProjectStage(String projectStage) {
        this.projectStage = projectStage;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getPollutionCategory() {
        return pollutionCategory;
    }

    public void setPollutionCategory(String pollutionCategory) {
        this.pollutionCategory = pollutionCategory;
    }

    public Boolean getHazardousMaterialRequired() {
        return hazardousMaterialRequired;
    }

    public void setHazardousMaterialRequired(
            Boolean hazardousMaterialRequired) {

        this.hazardousMaterialRequired =
                hazardousMaterialRequired;
    }

    public Boolean getBoilerRequired() {
        return boilerRequired;
    }

    public void setBoilerRequired(
            Boolean boilerRequired) {

        this.boilerRequired = boilerRequired;
    }

    public Boolean getGroundwaterRequired() {
        return groundwaterRequired;
    }

    public void setGroundwaterRequired(
            Boolean groundwaterRequired) {

        this.groundwaterRequired =
                groundwaterRequired;
    }

    public Boolean getIndustrialWasteRequired() {
        return industrialWasteRequired;
    }

    public void setIndustrialWasteRequired(
            Boolean industrialWasteRequired) {

        this.industrialWasteRequired =
                industrialWasteRequired;
    }

    public Integer getMinimumEmployees() {
        return minimumEmployees;
    }

    public void setMinimumEmployees(
            Integer minimumEmployees) {

        this.minimumEmployees =
                minimumEmployees;
    }

    public Integer getMaximumEmployees() {
        return maximumEmployees;
    }

    public void setMaximumEmployees(
            Integer maximumEmployees) {

        this.maximumEmployees =
                maximumEmployees;
    }

    public BigDecimal getMinimumInvestment() {
        return minimumInvestment;
    }

    public void setMinimumInvestment(
            BigDecimal minimumInvestment) {

        this.minimumInvestment =
                minimumInvestment;
    }

    public BigDecimal getMaximumInvestment() {
        return maximumInvestment;
    }

    public void setMaximumInvestment(
            BigDecimal maximumInvestment) {

        this.maximumInvestment =
                maximumInvestment;
    }

    public String getPriorityLevel() {
        return priorityLevel;
    }

    public void setPriorityLevel(
            String priorityLevel) {

        this.priorityLevel =
                priorityLevel;
    }

    public String getReasonText() {
        return reasonText;
    }

    public void setReasonText(
            String reasonText) {

        this.reasonText =
                reasonText;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(
            Timestamp createdAt) {

        this.createdAt =
                createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(
            Timestamp updatedAt) {

        this.updatedAt =
                updatedAt;
    }
}