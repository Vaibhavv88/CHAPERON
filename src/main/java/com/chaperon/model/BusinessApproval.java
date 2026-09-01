package com.chaperon.model;

import java.sql.Timestamp;

public class BusinessApproval {

    private long businessApprovalId;

    private long businessId;
    private long approvalId;

    private String requirementStatus;
    private String priorityLevel;

    private String reasonText;

    private String currentStatus;
    
    private String approvalName;
    private String approvalCode;

    private boolean mandatory;

    private Timestamp generatedAt;
    private Timestamp updatedAt;

    public BusinessApproval() {
    }

    public long getBusinessApprovalId() {
        return businessApprovalId;
    }

    public void setBusinessApprovalId(
            long businessApprovalId) {

        this.businessApprovalId =
                businessApprovalId;
    }

    public long getBusinessId() {
        return businessId;
    }

    public void setBusinessId(long businessId) {
        this.businessId = businessId;
    }

    public long getApprovalId() {
        return approvalId;
    }

    public void setApprovalId(long approvalId) {
        this.approvalId = approvalId;
    }

    public String getRequirementStatus() {
        return requirementStatus;
    }

    public void setRequirementStatus(
            String requirementStatus) {

        this.requirementStatus =
                requirementStatus;
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

    public String getCurrentStatus() {
        return currentStatus;
    }

    public void setCurrentStatus(
            String currentStatus) {

        this.currentStatus =
                currentStatus;
    }

    public boolean isMandatory() {
        return mandatory;
    }

    public void setMandatory(
            boolean mandatory) {

        this.mandatory =
                mandatory;
    }

    public Timestamp getGeneratedAt() {
        return generatedAt;
    }

    public void setGeneratedAt(
            Timestamp generatedAt) {

        this.generatedAt =
                generatedAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(
            Timestamp updatedAt) {

        this.updatedAt =
                updatedAt;
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
}