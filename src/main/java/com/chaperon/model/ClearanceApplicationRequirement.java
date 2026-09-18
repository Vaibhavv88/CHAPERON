package com.chaperon.model;

import java.sql.Timestamp;

public class ClearanceApplicationRequirement {

    private long applicationRequirementId;
    private long clearanceApplicationId;
    private long requirementId;

    private Long documentId;
    private Long uploadedByUserId;
    private Long verifiedByUserId;

    private boolean applicable;
    private boolean mandatory;
    private String requirementStatus;
    private String applicantRemarks;
    private String officerRemarks;
    private Timestamp uploadedAt;
    private Timestamp verifiedAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Joined display fields from clearance_requirements and documents.
    private String category;
    private String requirementName;
    private String requirementDescription;
    private String requirementType;
    private String responsibleRole;
    private String documentType;
    private String documentFilePath;

    public ClearanceApplicationRequirement() {
    }

    public long getApplicationRequirementId() {
        return applicationRequirementId;
    }

    public void setApplicationRequirementId(long applicationRequirementId) {
        this.applicationRequirementId = applicationRequirementId;
    }

    public long getClearanceApplicationId() {
        return clearanceApplicationId;
    }

    public void setClearanceApplicationId(long clearanceApplicationId) {
        this.clearanceApplicationId = clearanceApplicationId;
    }

    public long getRequirementId() {
        return requirementId;
    }

    public void setRequirementId(long requirementId) {
        this.requirementId = requirementId;
    }

    public Long getDocumentId() {
        return documentId;
    }

    public void setDocumentId(Long documentId) {
        this.documentId = documentId;
    }

    public Long getUploadedByUserId() {
        return uploadedByUserId;
    }

    public void setUploadedByUserId(Long uploadedByUserId) {
        this.uploadedByUserId = uploadedByUserId;
    }

    public Long getVerifiedByUserId() {
        return verifiedByUserId;
    }

    public void setVerifiedByUserId(Long verifiedByUserId) {
        this.verifiedByUserId = verifiedByUserId;
    }

    public boolean isApplicable() {
        return applicable;
    }

    public void setApplicable(boolean applicable) {
        this.applicable = applicable;
    }

    public boolean isMandatory() {
        return mandatory;
    }

    public void setMandatory(boolean mandatory) {
        this.mandatory = mandatory;
    }

    public String getRequirementStatus() {
        return requirementStatus;
    }

    public void setRequirementStatus(String requirementStatus) {
        this.requirementStatus = requirementStatus;
    }

    public String getApplicantRemarks() {
        return applicantRemarks;
    }

    public void setApplicantRemarks(String applicantRemarks) {
        this.applicantRemarks = applicantRemarks;
    }

    public String getOfficerRemarks() {
        return officerRemarks;
    }

    public void setOfficerRemarks(String officerRemarks) {
        this.officerRemarks = officerRemarks;
    }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public Timestamp getVerifiedAt() {
        return verifiedAt;
    }

    public void setVerifiedAt(Timestamp verifiedAt) {
        this.verifiedAt = verifiedAt;
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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getRequirementName() {
        return requirementName;
    }

    public void setRequirementName(String requirementName) {
        this.requirementName = requirementName;
    }

    public String getRequirementDescription() {
        return requirementDescription;
    }

    public void setRequirementDescription(String requirementDescription) {
        this.requirementDescription = requirementDescription;
    }

    public String getRequirementType() {
        return requirementType;
    }

    public void setRequirementType(String requirementType) {
        this.requirementType = requirementType;
    }

    public String getResponsibleRole() {
        return responsibleRole;
    }

    public void setResponsibleRole(String responsibleRole) {
        this.responsibleRole = responsibleRole;
    }

    public String getDocumentType() {
        return documentType;
    }

    public void setDocumentType(String documentType) {
        this.documentType = documentType;
    }

    public String getDocumentFilePath() {
        return documentFilePath;
    }

    public void setDocumentFilePath(String documentFilePath) {
        this.documentFilePath = documentFilePath;
    }
}
