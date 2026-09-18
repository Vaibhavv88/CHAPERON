package com.chaperon.model;

import java.sql.Date;
import java.sql.Timestamp;

public class ClearanceQuery {

    private long clearanceQueryId;
    private long clearanceApplicationId;
    private long raisedByUserId;
    private Long respondedByUserId;

    private String querySubject;
    private String queryDescription;
    private Date responseDeadline;
    private String applicantResponse;
    private Long responseDocumentId;
    private String queryStatus;

    private Timestamp raisedAt;
    private Timestamp respondedAt;
    private Timestamp resolvedAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Joined display fields.
    private String raisedByName;
    private String respondedByName;
    private String responseDocumentPath;

    public ClearanceQuery() {
    }

    public long getClearanceQueryId() {
        return clearanceQueryId;
    }

    public void setClearanceQueryId(long clearanceQueryId) {
        this.clearanceQueryId = clearanceQueryId;
    }

    public long getClearanceApplicationId() {
        return clearanceApplicationId;
    }

    public void setClearanceApplicationId(long clearanceApplicationId) {
        this.clearanceApplicationId = clearanceApplicationId;
    }

    public long getRaisedByUserId() {
        return raisedByUserId;
    }

    public void setRaisedByUserId(long raisedByUserId) {
        this.raisedByUserId = raisedByUserId;
    }

    public Long getRespondedByUserId() {
        return respondedByUserId;
    }

    public void setRespondedByUserId(Long respondedByUserId) {
        this.respondedByUserId = respondedByUserId;
    }

    public String getQuerySubject() {
        return querySubject;
    }

    public void setQuerySubject(String querySubject) {
        this.querySubject = querySubject;
    }

    public String getQueryDescription() {
        return queryDescription;
    }

    public void setQueryDescription(String queryDescription) {
        this.queryDescription = queryDescription;
    }

    public Date getResponseDeadline() {
        return responseDeadline;
    }

    public void setResponseDeadline(Date responseDeadline) {
        this.responseDeadline = responseDeadline;
    }

    public String getApplicantResponse() {
        return applicantResponse;
    }

    public void setApplicantResponse(String applicantResponse) {
        this.applicantResponse = applicantResponse;
    }

    public Long getResponseDocumentId() {
        return responseDocumentId;
    }

    public void setResponseDocumentId(Long responseDocumentId) {
        this.responseDocumentId = responseDocumentId;
    }

    public String getQueryStatus() {
        return queryStatus;
    }

    public void setQueryStatus(String queryStatus) {
        this.queryStatus = queryStatus;
    }

    public Timestamp getRaisedAt() {
        return raisedAt;
    }

    public void setRaisedAt(Timestamp raisedAt) {
        this.raisedAt = raisedAt;
    }

    public Timestamp getRespondedAt() {
        return respondedAt;
    }

    public void setRespondedAt(Timestamp respondedAt) {
        this.respondedAt = respondedAt;
    }

    public Timestamp getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(Timestamp resolvedAt) {
        this.resolvedAt = resolvedAt;
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

    public String getRaisedByName() {
        return raisedByName;
    }

    public void setRaisedByName(String raisedByName) {
        this.raisedByName = raisedByName;
    }

    public String getRespondedByName() {
        return respondedByName;
    }

    public void setRespondedByName(String respondedByName) {
        this.respondedByName = respondedByName;
    }

    public String getResponseDocumentPath() {
        return responseDocumentPath;
    }

    public void setResponseDocumentPath(String responseDocumentPath) {
        this.responseDocumentPath = responseDocumentPath;
    }
}
