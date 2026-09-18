package com.chaperon.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class ClearanceApplication {

    private long clearanceApplicationId;
    private String applicationNumber;
    private long clearanceTypeId;
    private long userId;
    private long businessId;
    private Long assignedOfficerId;

    private String projectTitle;
    private String projectDescription;
    private String state;
    private String district;
    private String locationAddress;

    private BigDecimal latitude;
    private BigDecimal longitude;
    private BigDecimal projectAreaHectares;

    private String currentStatus;
    private Timestamp submissionDate;
    private Date expectedCompletionDate;
    private boolean applicantDeclaration;
    private String officerRemarks;
    private String rejectionReason;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Joined display fields.
    private String clearanceName;
    private String applicantName;
    private String businessName;
    private String assignedOfficerName;

    public ClearanceApplication() {
    }

    public long getClearanceApplicationId() {
        return clearanceApplicationId;
    }

    public void setClearanceApplicationId(long clearanceApplicationId) {
        this.clearanceApplicationId = clearanceApplicationId;
    }

    public String getApplicationNumber() {
        return applicationNumber;
    }

    public void setApplicationNumber(String applicationNumber) {
        this.applicationNumber = applicationNumber;
    }

    public long getClearanceTypeId() {
        return clearanceTypeId;
    }

    public void setClearanceTypeId(long clearanceTypeId) {
        this.clearanceTypeId = clearanceTypeId;
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

    public Long getAssignedOfficerId() {
        return assignedOfficerId;
    }

    public void setAssignedOfficerId(Long assignedOfficerId) {
        this.assignedOfficerId = assignedOfficerId;
    }

    public String getProjectTitle() {
        return projectTitle;
    }

    public void setProjectTitle(String projectTitle) {
        this.projectTitle = projectTitle;
    }

    public String getProjectDescription() {
        return projectDescription;
    }

    public void setProjectDescription(String projectDescription) {
        this.projectDescription = projectDescription;
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

    public String getLocationAddress() {
        return locationAddress;
    }

    public void setLocationAddress(String locationAddress) {
        this.locationAddress = locationAddress;
    }

    public BigDecimal getLatitude() {
        return latitude;
    }

    public void setLatitude(BigDecimal latitude) {
        this.latitude = latitude;
    }

    public BigDecimal getLongitude() {
        return longitude;
    }

    public void setLongitude(BigDecimal longitude) {
        this.longitude = longitude;
    }

    public BigDecimal getProjectAreaHectares() {
        return projectAreaHectares;
    }

    public void setProjectAreaHectares(BigDecimal projectAreaHectares) {
        this.projectAreaHectares = projectAreaHectares;
    }

    public String getCurrentStatus() {
        return currentStatus;
    }

    public void setCurrentStatus(String currentStatus) {
        this.currentStatus = currentStatus;
    }

    public Timestamp getSubmissionDate() {
        return submissionDate;
    }

    public void setSubmissionDate(Timestamp submissionDate) {
        this.submissionDate = submissionDate;
    }

    public Date getExpectedCompletionDate() {
        return expectedCompletionDate;
    }

    public void setExpectedCompletionDate(Date expectedCompletionDate) {
        this.expectedCompletionDate = expectedCompletionDate;
    }

    public boolean isApplicantDeclaration() {
        return applicantDeclaration;
    }

    public void setApplicantDeclaration(boolean applicantDeclaration) {
        this.applicantDeclaration = applicantDeclaration;
    }

    public String getOfficerRemarks() {
        return officerRemarks;
    }

    public void setOfficerRemarks(String officerRemarks) {
        this.officerRemarks = officerRemarks;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
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

    public String getClearanceName() {
        return clearanceName;
    }

    public void setClearanceName(String clearanceName) {
        this.clearanceName = clearanceName;
    }

    public String getApplicantName() {
        return applicantName;
    }

    public void setApplicantName(String applicantName) {
        this.applicantName = applicantName;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getAssignedOfficerName() {
        return assignedOfficerName;
    }

    public void setAssignedOfficerName(String assignedOfficerName) {
        this.assignedOfficerName = assignedOfficerName;
    }
}
