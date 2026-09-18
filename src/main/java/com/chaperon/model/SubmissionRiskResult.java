package com.chaperon.model;

import java.util.ArrayList;
import java.util.List;

public class SubmissionRiskResult {

    private int riskScore;

    private String riskLevel;

    private int readinessPercentage;

    private int totalMandatoryDocuments;

    private int readyMandatoryDocuments;

    private int missingMandatoryDocuments;

    private int rejectedMandatoryDocuments;

    private int expiredMandatoryDocuments;

    private boolean profileComplete;

    private boolean safeToSubmit;

    private String summary;

    private List<String> riskReasons;

    private List<String> recommendations;


    public SubmissionRiskResult() {

        this.riskReasons =
                new ArrayList<>();

        this.recommendations =
                new ArrayList<>();
    }


    public int getRiskScore() {
        return riskScore;
    }

    public void setRiskScore(
            int riskScore
    ) {
        this.riskScore =
                riskScore;
    }


    public String getRiskLevel() {
        return riskLevel;
    }

    public void setRiskLevel(
            String riskLevel
    ) {
        this.riskLevel =
                riskLevel;
    }


    public int getReadinessPercentage() {
        return readinessPercentage;
    }

    public void setReadinessPercentage(
            int readinessPercentage
    ) {
        this.readinessPercentage =
                readinessPercentage;
    }


    public int getTotalMandatoryDocuments() {
        return totalMandatoryDocuments;
    }

    public void setTotalMandatoryDocuments(
            int totalMandatoryDocuments
    ) {
        this.totalMandatoryDocuments =
                totalMandatoryDocuments;
    }


    public int getReadyMandatoryDocuments() {
        return readyMandatoryDocuments;
    }

    public void setReadyMandatoryDocuments(
            int readyMandatoryDocuments
    ) {
        this.readyMandatoryDocuments =
                readyMandatoryDocuments;
    }


    public int getMissingMandatoryDocuments() {
        return missingMandatoryDocuments;
    }

    public void setMissingMandatoryDocuments(
            int missingMandatoryDocuments
    ) {
        this.missingMandatoryDocuments =
                missingMandatoryDocuments;
    }


    public int getRejectedMandatoryDocuments() {
        return rejectedMandatoryDocuments;
    }

    public void setRejectedMandatoryDocuments(
            int rejectedMandatoryDocuments
    ) {
        this.rejectedMandatoryDocuments =
                rejectedMandatoryDocuments;
    }


    public int getExpiredMandatoryDocuments() {
        return expiredMandatoryDocuments;
    }

    public void setExpiredMandatoryDocuments(
            int expiredMandatoryDocuments
    ) {
        this.expiredMandatoryDocuments =
                expiredMandatoryDocuments;
    }


    public boolean isProfileComplete() {
        return profileComplete;
    }

    public void setProfileComplete(
            boolean profileComplete
    ) {
        this.profileComplete =
                profileComplete;
    }


    public boolean isSafeToSubmit() {
        return safeToSubmit;
    }

    public void setSafeToSubmit(
            boolean safeToSubmit
    ) {
        this.safeToSubmit =
                safeToSubmit;
    }


    public String getSummary() {
        return summary;
    }

    public void setSummary(
            String summary
    ) {
        this.summary =
                summary;
    }


    public List<String> getRiskReasons() {
        return riskReasons;
    }

    public void setRiskReasons(
            List<String> riskReasons
    ) {

        if (riskReasons == null) {

            this.riskReasons =
                    new ArrayList<>();

        } else {

            this.riskReasons =
                    riskReasons;
        }
    }


    public List<String> getRecommendations() {
        return recommendations;
    }

    public void setRecommendations(
            List<String> recommendations
    ) {

        if (recommendations == null) {

            this.recommendations =
                    new ArrayList<>();

        } else {

            this.recommendations =
                    recommendations;
        }
    }


    public void addRiskReason(
            String reason
    ) {

        if (reason == null ||
            reason.isBlank()) {

            return;
        }

        this.riskReasons.add(
                reason
        );
    }


    public void addRecommendation(
            String recommendation
    ) {

        if (recommendation == null ||
            recommendation.isBlank()) {

            return;
        }

        this.recommendations.add(
                recommendation
        );
    }
}