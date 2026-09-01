package com.chaperon.model;

import java.sql.Timestamp;

public class Approval {

    private long approvalId;
    private String approvalName;
    private String approvalCode;
    private long departmentId;
    private String description;

    private Integer minimumProcessingDays;
    private Integer maximumProcessingDays;
    private Integer slaDays;

    private String validityType;
    private Integer validityValue;

    private boolean renewalRequired;
    private Integer renewalBeforeDays;

    private boolean inspectionRequired;
    private String officialReferenceUrl;
    
    private String departmentName;

    private boolean active;

    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Approval() {
    }

    public long getApprovalId() {
        return approvalId;
    }

    public void setApprovalId(long approvalId) {
        this.approvalId = approvalId;
    }

    public String getApprovalName() {
        return approvalName;
    }

    public void setApprovalName(String approvalName) {
        this.approvalName = approvalName;
    }

    public String getApprovalCode() {
        return approvalCode;
    }

    public void setApprovalCode(String approvalCode) {
        this.approvalCode = approvalCode;
    }

    public long getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(long departmentId) {
        this.departmentId = departmentId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getMinimumProcessingDays() {
        return minimumProcessingDays;
    }

    public void setMinimumProcessingDays(Integer minimumProcessingDays) {
        this.minimumProcessingDays = minimumProcessingDays;
    }

    public Integer getMaximumProcessingDays() {
        return maximumProcessingDays;
    }

    public void setMaximumProcessingDays(Integer maximumProcessingDays) {
        this.maximumProcessingDays = maximumProcessingDays;
    }

    public Integer getSlaDays() {
        return slaDays;
    }

    public void setSlaDays(Integer slaDays) {
        this.slaDays = slaDays;
    }

    public String getValidityType() {
        return validityType;
    }

    public void setValidityType(String validityType) {
        this.validityType = validityType;
    }

    public Integer getValidityValue() {
        return validityValue;
    }

    public void setValidityValue(Integer validityValue) {
        this.validityValue = validityValue;
    }

    public boolean isRenewalRequired() {
        return renewalRequired;
    }

    public void setRenewalRequired(boolean renewalRequired) {
        this.renewalRequired = renewalRequired;
    }

    public Integer getRenewalBeforeDays() {
        return renewalBeforeDays;
    }

    public void setRenewalBeforeDays(Integer renewalBeforeDays) {
        this.renewalBeforeDays = renewalBeforeDays;
    }

    public boolean isInspectionRequired() {
        return inspectionRequired;
    }

    public void setInspectionRequired(boolean inspectionRequired) {
        this.inspectionRequired = inspectionRequired;
    }

    public String getOfficialReferenceUrl() {
        return officialReferenceUrl;
    }

    public void setOfficialReferenceUrl(String officialReferenceUrl) {
        this.officialReferenceUrl = officialReferenceUrl;
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

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }
}