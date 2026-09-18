package com.chaperon.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class SpatialScreeningResult {

    private long clearanceApplicationId;
    private long clearanceMapId;

    private BigDecimal projectAreaHectares;

    private boolean analysisCompleted;
    private boolean manualReviewRequired;

    private int checkedLayerCount;
    private int intersectingFeatureCount;
    private int nearbyFeatureCount;
    private int recommendationCount;

    private String analysisStatus;
    private String summaryMessage;
    private String errorMessage;

    private List<SpatialFinding> findings;
    private List<GisRecommendation> recommendations;

    public SpatialScreeningResult() {
        this.findings = new ArrayList<>();
        this.recommendations = new ArrayList<>();
        this.analysisStatus = "PENDING";
    }

    public long getClearanceApplicationId() {
        return clearanceApplicationId;
    }

    public void setClearanceApplicationId(
            long clearanceApplicationId
    ) {
        this.clearanceApplicationId =
                clearanceApplicationId;
    }

    public long getClearanceMapId() {
        return clearanceMapId;
    }

    public void setClearanceMapId(long clearanceMapId) {
        this.clearanceMapId = clearanceMapId;
    }

    public BigDecimal getProjectAreaHectares() {
        return projectAreaHectares;
    }

    public void setProjectAreaHectares(
            BigDecimal projectAreaHectares
    ) {
        this.projectAreaHectares =
                projectAreaHectares;
    }

    public boolean isAnalysisCompleted() {
        return analysisCompleted;
    }

    public void setAnalysisCompleted(
            boolean analysisCompleted
    ) {
        this.analysisCompleted = analysisCompleted;
    }

    public boolean isManualReviewRequired() {
        return manualReviewRequired;
    }

    public void setManualReviewRequired(
            boolean manualReviewRequired
    ) {
        this.manualReviewRequired =
                manualReviewRequired;
    }

    public int getCheckedLayerCount() {
        return checkedLayerCount;
    }

    public void setCheckedLayerCount(
            int checkedLayerCount
    ) {
        this.checkedLayerCount = checkedLayerCount;
    }

    public int getIntersectingFeatureCount() {
        return intersectingFeatureCount;
    }

    public void setIntersectingFeatureCount(
            int intersectingFeatureCount
    ) {
        this.intersectingFeatureCount =
                intersectingFeatureCount;
    }

    public int getNearbyFeatureCount() {
        return nearbyFeatureCount;
    }

    public void setNearbyFeatureCount(
            int nearbyFeatureCount
    ) {
        this.nearbyFeatureCount = nearbyFeatureCount;
    }

    public int getRecommendationCount() {
        return recommendationCount;
    }

    public void setRecommendationCount(
            int recommendationCount
    ) {
        this.recommendationCount =
                recommendationCount;
    }

    public String getAnalysisStatus() {
        return analysisStatus;
    }

    public void setAnalysisStatus(
            String analysisStatus
    ) {
        this.analysisStatus = analysisStatus;
    }

    public String getSummaryMessage() {
        return summaryMessage;
    }

    public void setSummaryMessage(
            String summaryMessage
    ) {
        this.summaryMessage = summaryMessage;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(
            String errorMessage
    ) {
        this.errorMessage = errorMessage;
    }

    public List<SpatialFinding> getFindings() {
        return findings;
    }

    public void setFindings(
            List<SpatialFinding> findings
    ) {
        this.findings = findings == null
                ? new ArrayList<>()
                : findings;
    }

    public void addFinding(SpatialFinding finding) {
        if (finding != null) {
            this.findings.add(finding);
        }
    }

    public List<GisRecommendation> getRecommendations() {
        return recommendations;
    }

    public void setRecommendations(
            List<GisRecommendation> recommendations
    ) {
        this.recommendations = recommendations == null
                ? new ArrayList<>()
                : recommendations;
    }

    public void addRecommendation(
            GisRecommendation recommendation
    ) {
        if (recommendation != null) {
            this.recommendations.add(recommendation);
        }
    }

    public boolean hasIntersections() {
        return intersectingFeatureCount > 0;
    }

    public boolean hasRecommendations() {
        return recommendationCount > 0
                || !recommendations.isEmpty();
    }

    public static class SpatialFinding {

        private long spatialAnalysisId;
        private Long gisRuleId;
        private Long gisFeatureId;

        private String layerCode;
        private String layerName;
        private String layerCategory;

        private String featureCode;
        private String featureName;

        private String spatialRelation;
        private BigDecimal distanceKilometres;
        private BigDecimal intersectionAreaHectares;
        private BigDecimal intersectionPercentage;

        private String recommendationLevel;
        private String findingMessage;
        private boolean officerVerified;

        public long getSpatialAnalysisId() {
            return spatialAnalysisId;
        }

        public void setSpatialAnalysisId(
                long spatialAnalysisId
        ) {
            this.spatialAnalysisId =
                    spatialAnalysisId;
        }

        public Long getGisRuleId() {
            return gisRuleId;
        }

        public void setGisRuleId(Long gisRuleId) {
            this.gisRuleId = gisRuleId;
        }

        public Long getGisFeatureId() {
            return gisFeatureId;
        }

        public void setGisFeatureId(
                Long gisFeatureId
        ) {
            this.gisFeatureId = gisFeatureId;
        }

        public String getLayerCode() {
            return layerCode;
        }

        public void setLayerCode(String layerCode) {
            this.layerCode = layerCode;
        }

        public String getLayerName() {
            return layerName;
        }

        public void setLayerName(String layerName) {
            this.layerName = layerName;
        }

        public String getLayerCategory() {
            return layerCategory;
        }

        public void setLayerCategory(
                String layerCategory
        ) {
            this.layerCategory = layerCategory;
        }

        public String getFeatureCode() {
            return featureCode;
        }

        public void setFeatureCode(
                String featureCode
        ) {
            this.featureCode = featureCode;
        }

        public String getFeatureName() {
            return featureName;
        }

        public void setFeatureName(
                String featureName
        ) {
            this.featureName = featureName;
        }

        public String getSpatialRelation() {
            return spatialRelation;
        }

        public void setSpatialRelation(
                String spatialRelation
        ) {
            this.spatialRelation = spatialRelation;
        }

        public BigDecimal getDistanceKilometres() {
            return distanceKilometres;
        }

        public void setDistanceKilometres(
                BigDecimal distanceKilometres
        ) {
            this.distanceKilometres =
                    distanceKilometres;
        }

        public BigDecimal getIntersectionAreaHectares() {
            return intersectionAreaHectares;
        }

        public void setIntersectionAreaHectares(
                BigDecimal intersectionAreaHectares
        ) {
            this.intersectionAreaHectares =
                    intersectionAreaHectares;
        }

        public BigDecimal getIntersectionPercentage() {
            return intersectionPercentage;
        }

        public void setIntersectionPercentage(
                BigDecimal intersectionPercentage
        ) {
            this.intersectionPercentage =
                    intersectionPercentage;
        }

        public String getRecommendationLevel() {
            return recommendationLevel;
        }

        public void setRecommendationLevel(
                String recommendationLevel
        ) {
            this.recommendationLevel =
                    recommendationLevel;
        }

        public String getFindingMessage() {
            return findingMessage;
        }

        public void setFindingMessage(
                String findingMessage
        ) {
            this.findingMessage = findingMessage;
        }

        public boolean isOfficerVerified() {
            return officerVerified;
        }

        public void setOfficerVerified(
                boolean officerVerified
        ) {
            this.officerVerified = officerVerified;
        }

        public boolean isIntersection() {
            return "INTERSECTS".equalsIgnoreCase(
                    spatialRelation
            );
        }
    }

    public static class GisRecommendation {

        private long gisRecommendationId;

        private Long gisRuleId;
        private Long clearanceTypeId;
        private Long approvalId;

        private String clearanceCode;
        private String clearanceName;

        private String recommendationLevel;
        private String recommendationReason;
        private String generatedFrom;
        private String status;

        public long getGisRecommendationId() {
            return gisRecommendationId;
        }

        public void setGisRecommendationId(
                long gisRecommendationId
        ) {
            this.gisRecommendationId =
                    gisRecommendationId;
        }

        public Long getGisRuleId() {
            return gisRuleId;
        }

        public void setGisRuleId(Long gisRuleId) {
            this.gisRuleId = gisRuleId;
        }

        public Long getClearanceTypeId() {
            return clearanceTypeId;
        }

        public void setClearanceTypeId(
                Long clearanceTypeId
        ) {
            this.clearanceTypeId = clearanceTypeId;
        }

        public Long getApprovalId() {
            return approvalId;
        }

        public void setApprovalId(Long approvalId) {
            this.approvalId = approvalId;
        }

        public String getClearanceCode() {
            return clearanceCode;
        }

        public void setClearanceCode(
                String clearanceCode
        ) {
            this.clearanceCode = clearanceCode;
        }

        public String getClearanceName() {
            return clearanceName;
        }

        public void setClearanceName(
                String clearanceName
        ) {
            this.clearanceName = clearanceName;
        }

        public String getRecommendationLevel() {
            return recommendationLevel;
        }

        public void setRecommendationLevel(
                String recommendationLevel
        ) {
            this.recommendationLevel =
                    recommendationLevel;
        }

        public String getRecommendationReason() {
            return recommendationReason;
        }

        public void setRecommendationReason(
                String recommendationReason
        ) {
            this.recommendationReason =
                    recommendationReason;
        }

        public String getGeneratedFrom() {
            return generatedFrom;
        }

        public void setGeneratedFrom(
                String generatedFrom
        ) {
            this.generatedFrom = generatedFrom;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public boolean isRequired() {
            return "REQUIRED".equalsIgnoreCase(
                    recommendationLevel
            );
        }

        public boolean isReviewRequired() {
            return "REVIEW_REQUIRED".equalsIgnoreCase(
                    recommendationLevel
            );
        }

        public boolean isSystemRecommended() {
            return "SYSTEM_RECOMMENDED".equalsIgnoreCase(
                    status
            );
        }
    }
}