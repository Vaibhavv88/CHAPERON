package com.chaperon.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class ClearanceInspection {

    private long clearanceInspectionId;
    private long clearanceApplicationId;
    private long inspectorUserId;

    private String inspectionType;
    private Date scheduledDate;
    private Time scheduledTime;
    private String inspectionAddress;
    private BigDecimal latitude;
    private BigDecimal longitude;

    private String inspectionStatus;
    private String inspectionResult;
    private String findings;
    private String inspectorRemarks;
    private String recommendation;
    private Long inspectionReportDocumentId;
    private Timestamp completedAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Joined display fields.
    private String inspectorName;
    private String inspectionReportPath;
    private String applicationNumber;

    public ClearanceInspection() {
    }

    public long getClearanceInspectionId() {
        return clearanceInspectionId;
    }

    public void setClearanceInspectionId(long clearanceInspectionId) {
        this.clearanceInspectionId = clearanceInspectionId;
    }

    public long getClearanceApplicationId() {
        return clearanceApplicationId;
    }

    public void setClearanceApplicationId(long clearanceApplicationId) {
        this.clearanceApplicationId = clearanceApplicationId;
    }

    public long getInspectorUserId() {
        return inspectorUserId;
    }

    public void setInspectorUserId(long inspectorUserId) {
        this.inspectorUserId = inspectorUserId;
    }

    public String getInspectionType() {
        return inspectionType;
    }

    public void setInspectionType(String inspectionType) {
        this.inspectionType = inspectionType;
    }

    public Date getScheduledDate() {
        return scheduledDate;
    }

    public void setScheduledDate(Date scheduledDate) {
        this.scheduledDate = scheduledDate;
    }

    public Time getScheduledTime() {
        return scheduledTime;
    }

    public void setScheduledTime(Time scheduledTime) {
        this.scheduledTime = scheduledTime;
    }

    public String getInspectionAddress() {
        return inspectionAddress;
    }

    public void setInspectionAddress(String inspectionAddress) {
        this.inspectionAddress = inspectionAddress;
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

    public String getInspectionStatus() {
        return inspectionStatus;
    }

    public void setInspectionStatus(String inspectionStatus) {
        this.inspectionStatus = inspectionStatus;
    }

    public String getInspectionResult() {
        return inspectionResult;
    }

    public void setInspectionResult(String inspectionResult) {
        this.inspectionResult = inspectionResult;
    }

    public String getFindings() {
        return findings;
    }

    public void setFindings(String findings) {
        this.findings = findings;
    }

    public String getInspectorRemarks() {
        return inspectorRemarks;
    }

    public void setInspectorRemarks(String inspectorRemarks) {
        this.inspectorRemarks = inspectorRemarks;
    }

    public String getRecommendation() {
        return recommendation;
    }

    public void setRecommendation(String recommendation) {
        this.recommendation = recommendation;
    }

    public Long getInspectionReportDocumentId() {
        return inspectionReportDocumentId;
    }

    public void setInspectionReportDocumentId(Long inspectionReportDocumentId) {
        this.inspectionReportDocumentId = inspectionReportDocumentId;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
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

    public String getInspectorName() {
        return inspectorName;
    }

    public void setInspectorName(String inspectorName) {
        this.inspectorName = inspectorName;
    }

    public String getInspectionReportPath() {
        return inspectionReportPath;
    }

    public void setInspectionReportPath(String inspectionReportPath) {
        this.inspectionReportPath = inspectionReportPath;
    }

    public String getApplicationNumber() {
        return applicationNumber;
    }

    public void setApplicationNumber(String applicationNumber) {
        this.applicationNumber = applicationNumber;
    }
}
