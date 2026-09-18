package com.chaperon.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Business {

    private long businessId;
    private long userId;

    private String businessName;
    private String businessConstitution;
    private String businessActivity;
    private String industry;

    private String state;
    private String district;
    private String taluka;
    private String industrialArea;
    private String pinCode;

    private String projectStage;
    private BigDecimal investmentAmount;
    private BigDecimal annualTurnover;
    private boolean interstateSupply;
    private int employeeCount;
    private BigDecimal landArea;
    private BigDecimal builtUpArea;
    private BigDecimal powerRequirement;
    private BigDecimal waterRequirement;

    private String pollutionCategory;

    private boolean hazardousMaterial;
    private boolean boilerUsed;
    private boolean industrialWaste;
    private boolean groundwaterRequired;

    private boolean handlesPersonalData;
    private boolean seeksStpiBenefits;
    private boolean locatedInSez;
    private boolean certInApplicable;
    private boolean seeksTrademarkProtection;
    private boolean seeksSoftwareCopyright;

    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Business() {
    }

    public long getBusinessId() {
        return businessId;
    }

    public void setBusinessId(long businessId) {
        this.businessId = businessId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getBusinessConstitution() {
        return businessConstitution;
    }

    public void setBusinessConstitution(String businessConstitution) {
        this.businessConstitution = businessConstitution;
    }

    public String getBusinessActivity() {
        return businessActivity;
    }

    public void setBusinessActivity(String businessActivity) {
        this.businessActivity = businessActivity;
    }

    public String getIndustry() {
        return industry;
    }

    public void setIndustry(String industry) {
        this.industry = industry;
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

    public String getTaluka() {
        return taluka;
    }

    public void setTaluka(String taluka) {
        this.taluka = taluka;
    }

    public String getIndustrialArea() {
        return industrialArea;
    }

    public void setIndustrialArea(String industrialArea) {
        this.industrialArea = industrialArea;
    }

    public String getPinCode() {
        return pinCode;
    }

    public void setPinCode(String pinCode) {
        this.pinCode = pinCode;
    }

    public String getProjectStage() {
        return projectStage;
    }

    public void setProjectStage(String projectStage) {
        this.projectStage = projectStage;
    }

    public BigDecimal getInvestmentAmount() {
        return investmentAmount;
    }

    public void setInvestmentAmount(BigDecimal investmentAmount) {
        this.investmentAmount = investmentAmount;
    }

    public BigDecimal getAnnualTurnover() {
        return annualTurnover;
    }

    public void setAnnualTurnover(BigDecimal annualTurnover) {
        this.annualTurnover = annualTurnover;
    }

    public boolean isInterstateSupply() {
        return interstateSupply;
    }

    public void setInterstateSupply(boolean interstateSupply) {
        this.interstateSupply = interstateSupply;
    }

    public int getEmployeeCount() {
        return employeeCount;
    }

    public void setEmployeeCount(int employeeCount) {
        this.employeeCount = employeeCount;
    }

    public BigDecimal getLandArea() {
        return landArea;
    }

    public void setLandArea(BigDecimal landArea) {
        this.landArea = landArea;
    }

    public BigDecimal getBuiltUpArea() {
        return builtUpArea;
    }

    public void setBuiltUpArea(BigDecimal builtUpArea) {
        this.builtUpArea = builtUpArea;
    }

    public BigDecimal getPowerRequirement() {
        return powerRequirement;
    }

    public void setPowerRequirement(BigDecimal powerRequirement) {
        this.powerRequirement = powerRequirement;
    }

    public BigDecimal getWaterRequirement() {
        return waterRequirement;
    }

    public void setWaterRequirement(BigDecimal waterRequirement) {
        this.waterRequirement = waterRequirement;
    }

    public String getPollutionCategory() {
        return pollutionCategory;
    }

    public void setPollutionCategory(String pollutionCategory) {
        this.pollutionCategory = pollutionCategory;
    }

    public boolean isHazardousMaterial() {
        return hazardousMaterial;
    }

    public void setHazardousMaterial(boolean hazardousMaterial) {
        this.hazardousMaterial = hazardousMaterial;
    }

    public boolean isBoilerUsed() {
        return boilerUsed;
    }

    public void setBoilerUsed(boolean boilerUsed) {
        this.boilerUsed = boilerUsed;
    }

    public boolean isIndustrialWaste() {
        return industrialWaste;
    }

    public void setIndustrialWaste(boolean industrialWaste) {
        this.industrialWaste = industrialWaste;
    }

    public boolean isGroundwaterRequired() {
        return groundwaterRequired;
    }

    public void setGroundwaterRequired(boolean groundwaterRequired) {
        this.groundwaterRequired = groundwaterRequired;
    }

    public boolean isHandlesPersonalData() {
        return handlesPersonalData;
    }

    public void setHandlesPersonalData(boolean handlesPersonalData) {
        this.handlesPersonalData = handlesPersonalData;
    }

    public boolean isSeeksStpiBenefits() {
        return seeksStpiBenefits;
    }

    public void setSeeksStpiBenefits(boolean seeksStpiBenefits) {
        this.seeksStpiBenefits = seeksStpiBenefits;
    }

    public boolean isLocatedInSez() {
        return locatedInSez;
    }

    public void setLocatedInSez(boolean locatedInSez) {
        this.locatedInSez = locatedInSez;
    }

    public boolean isCertInApplicable() {
        return certInApplicable;
    }

    public void setCertInApplicable(boolean certInApplicable) {
        this.certInApplicable = certInApplicable;
    }

    public boolean isSeeksTrademarkProtection() {
        return seeksTrademarkProtection;
    }

    public void setSeeksTrademarkProtection(
            boolean seeksTrademarkProtection) {

        this.seeksTrademarkProtection =
                seeksTrademarkProtection;
    }

    public boolean isSeeksSoftwareCopyright() {
        return seeksSoftwareCopyright;
    }

    public void setSeeksSoftwareCopyright(
            boolean seeksSoftwareCopyright) {

        this.seeksSoftwareCopyright =
                seeksSoftwareCopyright;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}