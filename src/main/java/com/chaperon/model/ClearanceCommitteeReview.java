package com.chaperon.model;

import java.sql.Date;
import java.sql.Timestamp;

public class ClearanceCommitteeReview {

    private long committeeReviewId;
    private long clearanceApplicationId;
    private String committeeName;
    private String committeeLevel;
    private String reviewStage;
    private Date meetingDate;
    private String meetingNumber;
    private String reviewStatus;
    private String decision;

    private String agendaSummary;
    private String committeeObservations;
    private String recommendation;
    private String approvalConditions;

    private Long agendaDocumentId;
    private Long minutesDocumentId;
    private Long recommendationDocumentId;
    private long recordedByUserId;
    private Timestamp decidedAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Joined display fields.
    private String recordedByName;
    private String agendaDocumentPath;
    private String minutesDocumentPath;
    private String recommendationDocumentPath;

    public ClearanceCommitteeReview() {
    }

    public long getCommitteeReviewId() {
        return committeeReviewId;
    }

    public void setCommitteeReviewId(long committeeReviewId) {
        this.committeeReviewId = committeeReviewId;
    }

    public long getClearanceApplicationId() {
        return clearanceApplicationId;
    }

    public void setClearanceApplicationId(long clearanceApplicationId) {
        this.clearanceApplicationId = clearanceApplicationId;
    }

    public String getCommitteeName() {
        return committeeName;
    }

    public void setCommitteeName(String committeeName) {
        this.committeeName = committeeName;
    }

    public String getCommitteeLevel() {
        return committeeLevel;
    }

    public void setCommitteeLevel(String committeeLevel) {
        this.committeeLevel = committeeLevel;
    }

    public String getReviewStage() {
        return reviewStage;
    }

    public void setReviewStage(String reviewStage) {
        this.reviewStage = reviewStage;
    }

    public Date getMeetingDate() {
        return meetingDate;
    }

    public void setMeetingDate(Date meetingDate) {
        this.meetingDate = meetingDate;
    }

    public String getMeetingNumber() {
        return meetingNumber;
    }

    public void setMeetingNumber(String meetingNumber) {
        this.meetingNumber = meetingNumber;
    }

    public String getReviewStatus() {
        return reviewStatus;
    }

    public void setReviewStatus(String reviewStatus) {
        this.reviewStatus = reviewStatus;
    }

    public String getDecision() {
        return decision;
    }

    public void setDecision(String decision) {
        this.decision = decision;
    }

    public String getAgendaSummary() {
        return agendaSummary;
    }

    public void setAgendaSummary(String agendaSummary) {
        this.agendaSummary = agendaSummary;
    }

    public String getCommitteeObservations() {
        return committeeObservations;
    }

    public void setCommitteeObservations(String committeeObservations) {
        this.committeeObservations = committeeObservations;
    }

    public String getRecommendation() {
        return recommendation;
    }

    public void setRecommendation(String recommendation) {
        this.recommendation = recommendation;
    }

    public String getApprovalConditions() {
        return approvalConditions;
    }

    public void setApprovalConditions(String approvalConditions) {
        this.approvalConditions = approvalConditions;
    }

    public Long getAgendaDocumentId() {
        return agendaDocumentId;
    }

    public void setAgendaDocumentId(Long agendaDocumentId) {
        this.agendaDocumentId = agendaDocumentId;
    }

    public Long getMinutesDocumentId() {
        return minutesDocumentId;
    }

    public void setMinutesDocumentId(Long minutesDocumentId) {
        this.minutesDocumentId = minutesDocumentId;
    }

    public Long getRecommendationDocumentId() {
        return recommendationDocumentId;
    }

    public void setRecommendationDocumentId(Long recommendationDocumentId) {
        this.recommendationDocumentId = recommendationDocumentId;
    }

    public long getRecordedByUserId() {
        return recordedByUserId;
    }

    public void setRecordedByUserId(long recordedByUserId) {
        this.recordedByUserId = recordedByUserId;
    }

    public Timestamp getDecidedAt() {
        return decidedAt;
    }

    public void setDecidedAt(Timestamp decidedAt) {
        this.decidedAt = decidedAt;
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

    public String getRecordedByName() {
        return recordedByName;
    }

    public void setRecordedByName(String recordedByName) {
        this.recordedByName = recordedByName;
    }

    public String getAgendaDocumentPath() {
        return agendaDocumentPath;
    }

    public void setAgendaDocumentPath(String agendaDocumentPath) {
        this.agendaDocumentPath = agendaDocumentPath;
    }

    public String getMinutesDocumentPath() {
        return minutesDocumentPath;
    }

    public void setMinutesDocumentPath(String minutesDocumentPath) {
        this.minutesDocumentPath = minutesDocumentPath;
    }

    public String getRecommendationDocumentPath() {
        return recommendationDocumentPath;
    }

    public void setRecommendationDocumentPath(String recommendationDocumentPath) {
        this.recommendationDocumentPath = recommendationDocumentPath;
    }
}
