package com.chaperon.model;

import java.sql.Date;
import java.sql.Timestamp;

public class ClearanceCertificate {

    private long clearanceCertificateId;
    private long clearanceApplicationId;
    private String clearanceNumber;
    private String verificationCode;
    private long issuedByUserId;
    private Long certificateDocumentId;

    private Date issueDate;
    private Date validFrom;
    private Date validUntil;
    private String validityType;
    private Integer validityValue;
    private String certificateStatus;

    private String approvalConditions;
    private String authorityRemarks;
    private Timestamp suspendedAt;
    private Timestamp revokedAt;
    private String revocationReason;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Joined display fields.
    private String applicationNumber;
    private String clearanceName;
    private String businessName;
    private String issuedByName;
    private String certificateDocumentPath;

    public ClearanceCertificate() {
    }

    public long getClearanceCertificateId() {
        return clearanceCertificateId;
    }

    public void setClearanceCertificateId(long clearanceCertificateId) {
        this.clearanceCertificateId = clearanceCertificateId;
    }

    public long getClearanceApplicationId() {
        return clearanceApplicationId;
    }

    public void setClearanceApplicationId(long clearanceApplicationId) {
        this.clearanceApplicationId = clearanceApplicationId;
    }

    public String getClearanceNumber() {
        return clearanceNumber;
    }

    public void setClearanceNumber(String clearanceNumber) {
        this.clearanceNumber = clearanceNumber;
    }

    public String getVerificationCode() {
        return verificationCode;
    }

    public void setVerificationCode(String verificationCode) {
        this.verificationCode = verificationCode;
    }

    public long getIssuedByUserId() {
        return issuedByUserId;
    }

    public void setIssuedByUserId(long issuedByUserId) {
        this.issuedByUserId = issuedByUserId;
    }

    public Long getCertificateDocumentId() {
        return certificateDocumentId;
    }

    public void setCertificateDocumentId(Long certificateDocumentId) {
        this.certificateDocumentId = certificateDocumentId;
    }

    public Date getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(Date issueDate) {
        this.issueDate = issueDate;
    }

    public Date getValidFrom() {
        return validFrom;
    }

    public void setValidFrom(Date validFrom) {
        this.validFrom = validFrom;
    }

    public Date getValidUntil() {
        return validUntil;
    }

    public void setValidUntil(Date validUntil) {
        this.validUntil = validUntil;
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

    public String getCertificateStatus() {
        return certificateStatus;
    }

    public void setCertificateStatus(String certificateStatus) {
        this.certificateStatus = certificateStatus;
    }

    public String getApprovalConditions() {
        return approvalConditions;
    }

    public void setApprovalConditions(String approvalConditions) {
        this.approvalConditions = approvalConditions;
    }

    public String getAuthorityRemarks() {
        return authorityRemarks;
    }

    public void setAuthorityRemarks(String authorityRemarks) {
        this.authorityRemarks = authorityRemarks;
    }

    public Timestamp getSuspendedAt() {
        return suspendedAt;
    }

    public void setSuspendedAt(Timestamp suspendedAt) {
        this.suspendedAt = suspendedAt;
    }

    public Timestamp getRevokedAt() {
        return revokedAt;
    }

    public void setRevokedAt(Timestamp revokedAt) {
        this.revokedAt = revokedAt;
    }

    public String getRevocationReason() {
        return revocationReason;
    }

    public void setRevocationReason(String revocationReason) {
        this.revocationReason = revocationReason;
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

    public String getApplicationNumber() {
        return applicationNumber;
    }

    public void setApplicationNumber(String applicationNumber) {
        this.applicationNumber = applicationNumber;
    }

    public String getClearanceName() {
        return clearanceName;
    }

    public void setClearanceName(String clearanceName) {
        this.clearanceName = clearanceName;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getIssuedByName() {
        return issuedByName;
    }

    public void setIssuedByName(String issuedByName) {
        this.issuedByName = issuedByName;
    }

    public String getCertificateDocumentPath() {
        return certificateDocumentPath;
    }

    public void setCertificateDocumentPath(String certificateDocumentPath) {
        this.certificateDocumentPath = certificateDocumentPath;
    }
}
