package com.chaperon.model;

import java.math.BigDecimal;

public class IncentiveCalculationRequest {

    private long userId;
    private long businessId;

    private String state;
    private String district;
    private String industry;
    private String enterpriseCategory;
    private String projectType;

    private BigDecimal totalInvestment;
    private BigDecimal environmentalInvestment;
    private BigDecimal renewableEnergyInvestment;

    private int employeeCount;

    private boolean womenEntrepreneur;
    private boolean scStEntrepreneur;
    private boolean locatedInIndustrialArea;

    public IncentiveCalculationRequest() {
        totalInvestment = BigDecimal.ZERO;
        environmentalInvestment = BigDecimal.ZERO;
        renewableEnergyInvestment = BigDecimal.ZERO;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public long getBusinessId() {
        return businessId;
    }

    public void setBusinessId(long businessId) {
        this.businessId = businessId;
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

    public BigDecimal getTotalInvestment() {
        return totalInvestment;
    }

    public void setTotalInvestment(
            BigDecimal totalInvestment) {

        this.totalInvestment = totalInvestment;
    }

    public BigDecimal getEnvironmentalInvestment() {
        return environmentalInvestment;
    }

    public void setEnvironmentalInvestment(
            BigDecimal environmentalInvestment) {

        this.environmentalInvestment =
                environmentalInvestment;
    }

    public BigDecimal getRenewableEnergyInvestment() {
        return renewableEnergyInvestment;
    }

    public void setRenewableEnergyInvestment(
            BigDecimal renewableEnergyInvestment) {

        this.renewableEnergyInvestment =
                renewableEnergyInvestment;
    }

    public int getEmployeeCount() {
        return employeeCount;
    }

    public void setEmployeeCount(int employeeCount) {
        this.employeeCount = employeeCount;
    }

    public boolean isWomenEntrepreneur() {
        return womenEntrepreneur;
    }

    public void setWomenEntrepreneur(
            boolean womenEntrepreneur) {

        this.womenEntrepreneur = womenEntrepreneur;
    }

    public boolean isScStEntrepreneur() {
        return scStEntrepreneur;
    }

    public void setScStEntrepreneur(
            boolean scStEntrepreneur) {

        this.scStEntrepreneur = scStEntrepreneur;
    }

    public boolean isLocatedInIndustrialArea() {
        return locatedInIndustrialArea;
    }

    public void setLocatedInIndustrialArea(
            boolean locatedInIndustrialArea) {

        this.locatedInIndustrialArea =
                locatedInIndustrialArea;
    }
}