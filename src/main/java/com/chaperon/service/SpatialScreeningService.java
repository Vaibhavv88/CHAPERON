package com.chaperon.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.chaperon.dao.SpatialScreeningDAO;
import com.chaperon.dao.impl.SpatialScreeningDAOImpl;
import com.chaperon.model.SpatialScreeningResult;
import com.chaperon.model.SpatialScreeningResult.GisRecommendation;
import com.chaperon.model.SpatialScreeningResult.SpatialFinding;

public class SpatialScreeningService {

    /*
     * Maximum search radius used to collect nearby GIS
     * features. The actual applicability distance still comes
     * from gis_applicability_rules.
     */
    private static final BigDecimal MAXIMUM_SEARCH_DISTANCE_KM =
            new BigDecimal("30.000");

    private final SpatialScreeningDAO spatialScreeningDAO;

    public SpatialScreeningService() {
        this.spatialScreeningDAO =
                new SpatialScreeningDAOImpl();
    }

    public SpatialScreeningService(
            SpatialScreeningDAO spatialScreeningDAO
    ) {

        if (spatialScreeningDAO == null) {
            throw new IllegalArgumentException(
                    "SpatialScreeningDAO cannot be null."
            );
        }

        this.spatialScreeningDAO =
                spatialScreeningDAO;
    }

    public SpatialScreeningResult runScreening(
            long clearanceApplicationId
    ) throws SQLException {

        if (clearanceApplicationId <= 0) {
            throw new IllegalArgumentException(
                    "Valid clearance application ID is required."
            );
        }

        SpatialScreeningResult result =
                new SpatialScreeningResult();

        result.setClearanceApplicationId(
                clearanceApplicationId
        );

        Long clearanceMapId =
                spatialScreeningDAO
                        .findLatestProjectMapId(
                                clearanceApplicationId
                        );

        if (clearanceMapId == null) {
            result.setAnalysisStatus(
                    "BOUNDARY_REQUIRED"
            );

            result.setSummaryMessage(
                    "Draw and save the project boundary "
                    + "before running GIS screening."
            );

            result.setAnalysisCompleted(false);

            return result;
        }

        result.setClearanceMapId(clearanceMapId);

        boolean validBoundary =
                spatialScreeningDAO
                        .projectBoundaryExists(
                                clearanceApplicationId,
                                clearanceMapId
                        );

        if (!validBoundary) {
            result.setAnalysisStatus(
                    "INVALID_BOUNDARY"
            );

            result.setSummaryMessage(
                    "The saved project boundary is missing "
                    + "or contains invalid GeoJSON."
            );

            result.setAnalysisCompleted(false);

            return result;
        }

        BigDecimal projectArea =
                spatialScreeningDAO
                        .findProjectAreaHectares(
                                clearanceMapId
                        );

        result.setProjectAreaHectares(projectArea);

        String projectState =
                spatialScreeningDAO.findProjectState(
                        clearanceApplicationId
                );

        String projectDistrict =
                spatialScreeningDAO.findProjectDistrict(
                        clearanceApplicationId
                );

        int checkedLayerCount =
                spatialScreeningDAO
                        .countApplicableActiveLayers(
                                projectState,
                                projectDistrict
                        );

        result.setCheckedLayerCount(
                checkedLayerCount
        );

        if (checkedLayerCount <= 0) {
            result.setAnalysisStatus(
                    "NO_ACTIVE_LAYERS"
            );

            result.setAnalysisCompleted(false);

            result.setManualReviewRequired(true);

            result.setSummaryMessage(
                    "No verified active GIS layer is "
                    + "available for this project location. "
                    + "Manual departmental review is required."
            );

            return result;
        }

        /*
         * Remove only previous system-generated screening
         * results. Officer-rejected/confirmed recommendations
         * are preserved by the DAO.
         */
        spatialScreeningDAO
                .deletePreviousSpatialAnalysis(
                        clearanceApplicationId
                );

        spatialScreeningDAO
                .deletePreviousSystemRecommendations(
                        clearanceApplicationId
                );

        List<SpatialFinding> intersectionFindings =
                spatialScreeningDAO
                        .findIntersectingFeatures(
                                clearanceMapId,
                                projectState,
                                projectDistrict
                        );

        List<SpatialFinding> nearbyFindings =
                spatialScreeningDAO
                        .findNearbyFeatures(
                                clearanceMapId,
                                projectState,
                                projectDistrict,
                                MAXIMUM_SEARCH_DISTANCE_KM
                        );

        result.setIntersectingFeatureCount(
                intersectionFindings.size()
        );

        result.setNearbyFeatureCount(
                nearbyFindings.size()
        );

        List<GisRecommendation> generatedRecommendations =
                new ArrayList<>();

        Set<String> recommendationKeys =
                new HashSet<>();

        /*
         * Pollution category can later be loaded from the
         * business profile. NULL still allows GIS rules whose
         * pollution_category is NULL.
         */
        String pollutionCategory = null;

        processFindings(
                clearanceApplicationId,
                clearanceMapId,
                intersectionFindings,
                "INTERSECTS",
                projectArea,
                pollutionCategory,
                projectState,
                generatedRecommendations,
                recommendationKeys
        );

        processFindings(
                clearanceApplicationId,
                clearanceMapId,
                nearbyFindings,
                "DISTANCE_WITHIN",
                projectArea,
                pollutionCategory,
                projectState,
                generatedRecommendations,
                recommendationKeys
        );

        List<SpatialFinding> savedFindings =
                spatialScreeningDAO
                        .findSavedFindings(
                                clearanceApplicationId
                        );

        List<GisRecommendation> savedRecommendations =
                spatialScreeningDAO
                        .findSavedRecommendations(
                                clearanceApplicationId
                        );

        result.setFindings(savedFindings);
        result.setRecommendations(
                savedRecommendations
        );

        result.setRecommendationCount(
                savedRecommendations.size()
        );

        result.setAnalysisCompleted(true);
        result.setAnalysisStatus("COMPLETED");

        boolean reviewRequired =
                hasReviewRequiredFinding(
                        savedFindings,
                        savedRecommendations
                );

        result.setManualReviewRequired(
                reviewRequired
        );

        result.setSummaryMessage(
                buildSummaryMessage(
                        savedFindings,
                        savedRecommendations,
                        reviewRequired
                )
        );

        return result;
    }

    private void processFindings(
            long clearanceApplicationId,
            long clearanceMapId,
            List<SpatialFinding> findings,
            String spatialRelation,
            BigDecimal projectArea,
            String pollutionCategory,
            String projectState,
            List<GisRecommendation> generatedRecommendations,
            Set<String> recommendationKeys
    ) throws SQLException {

        if (findings == null || findings.isEmpty()) {
            return;
        }

        for (SpatialFinding finding : findings) {

            BigDecimal actualDistance =
                    finding.getDistanceKilometres();

            List<GisRecommendation> matchingRules =
                    spatialScreeningDAO
                            .findApplicableRules(
                                    finding.getLayerCategory(),
                                    spatialRelation,
                                    actualDistance,
                                    projectArea,
                                    pollutionCategory,
                                    projectState
                            );

            if (matchingRules == null
                    || matchingRules.isEmpty()) {

                finding.setRecommendationLevel(
                        "REVIEW_REQUIRED"
                );

                finding.setFindingMessage(
                        finding.getFindingMessage()
                        + " No active automatic rule matched; "
                        + "officer review is required."
                );

                spatialScreeningDAO.saveSpatialFinding(
                        clearanceApplicationId,
                        clearanceMapId,
                        finding
                );

                continue;
            }

            /*
             * If multiple rules match one GIS feature, store
             * the strongest recommendation level on the
             * spatial finding.
             */
            finding.setRecommendationLevel(
                    strongestRecommendationLevel(
                            matchingRules
                    )
            );

            if (!matchingRules.isEmpty()) {
                finding.setGisRuleId(
                        matchingRules
                                .get(0)
                                .getGisRuleId()
                );
            }

            spatialScreeningDAO.saveSpatialFinding(
                    clearanceApplicationId,
                    clearanceMapId,
                    finding
            );

            for (GisRecommendation recommendation
                    : matchingRules) {

                /*
                 * The current clearance_gis_recommendations
                 * table stores unified clearance types.
                 */
                if (recommendation
                        .getClearanceTypeId() == null) {
                    continue;
                }

                String key =
                        buildRecommendationKey(
                                recommendation
                        );

                if (!recommendationKeys.add(key)) {
                    continue;
                }

                boolean alreadyExists =
                        spatialScreeningDAO
                                .recommendationExists(
                                        clearanceApplicationId,
                                        recommendation
                                                .getClearanceTypeId(),
                                        recommendation
                                                .getApprovalId()
                                );

                if (alreadyExists) {
                    continue;
                }

                recommendation.setRecommendationReason(
                        buildRecommendationReason(
                                recommendation,
                                finding
                        )
                );

                long recommendationId =
                        spatialScreeningDAO
                                .saveRecommendation(
                                        clearanceApplicationId,
                                        recommendation
                                );

                recommendation.setGisRecommendationId(
                        recommendationId
                );

                generatedRecommendations.add(
                        recommendation
                );
            }
        }
    }

    private String buildRecommendationKey(
            GisRecommendation recommendation
    ) {

        if (recommendation.getClearanceTypeId() != null) {
            return "CLEARANCE:"
                    + recommendation.getClearanceTypeId();
        }

        if (recommendation.getApprovalId() != null) {
            return "APPROVAL:"
                    + recommendation.getApprovalId();
        }

        return "UNKNOWN:"
                + String.valueOf(
                        recommendation.getClearanceName()
                );
    }

    private String strongestRecommendationLevel(
            List<GisRecommendation> recommendations
    ) {

        String strongest = "MAY_BE_REQUIRED";

        for (GisRecommendation recommendation
                : recommendations) {

            String level =
                    recommendation
                            .getRecommendationLevel();

            if ("REQUIRED".equalsIgnoreCase(level)) {
                return "REQUIRED";
            }

            if ("REVIEW_REQUIRED"
                    .equalsIgnoreCase(level)) {
                strongest = "REVIEW_REQUIRED";
            }
        }

        return strongest;
    }

    private String buildRecommendationReason(
            GisRecommendation recommendation,
            SpatialFinding finding
    ) {

        String ruleReason =
                recommendation
                        .getRecommendationReason();

        StringBuilder reason =
                new StringBuilder();

        if (ruleReason != null
                && !ruleReason.isBlank()) {
            reason.append(ruleReason);
            reason.append(". ");
        }

        reason.append("GIS screening found ");

        if ("INTERSECTS".equalsIgnoreCase(
                finding.getSpatialRelation())) {

            reason.append(
                    "an intersection with "
            );

        } else {
            reason.append(
                    "a nearby regulatory feature "
            );
        }

        reason.append(
                finding.getFeatureName() == null
                        ? "an identified feature"
                        : finding.getFeatureName()
        );

        reason.append(" in the ");

        reason.append(
                finding.getLayerName() == null
                        ? finding.getLayerCategory()
                        : finding.getLayerName()
        );

        reason.append(" layer");

        if (finding.getDistanceKilometres() != null
                && finding.getDistanceKilometres()
                        .compareTo(BigDecimal.ZERO) > 0) {

            reason.append(" at approximately ");
            reason.append(
                    finding.getDistanceKilometres()
            );
            reason.append(" km");
        }

        reason.append(
                ". Subject to officer verification."
        );

        return reason.toString();
    }

    private boolean hasReviewRequiredFinding(
            List<SpatialFinding> findings,
            List<GisRecommendation> recommendations
    ) {

        if (findings != null) {
            for (SpatialFinding finding : findings) {

                if ("REVIEW_REQUIRED".equalsIgnoreCase(
                        finding.getRecommendationLevel()
                )) {
                    return true;
                }
            }
        }

        if (recommendations != null) {
            for (GisRecommendation recommendation
                    : recommendations) {

                String level =
                        recommendation
                                .getRecommendationLevel();

                if ("REQUIRED".equalsIgnoreCase(level)
                        || "REVIEW_REQUIRED"
                                .equalsIgnoreCase(level)
                        || "MAY_BE_REQUIRED"
                                .equalsIgnoreCase(level)) {
                    return true;
                }
            }
        }

        return false;
    }

    private String buildSummaryMessage(
            List<SpatialFinding> findings,
            List<GisRecommendation> recommendations,
            boolean reviewRequired
    ) {

        int findingCount =
                findings == null
                        ? 0
                        : findings.size();

        int recommendationCount =
                recommendations == null
                        ? 0
                        : recommendations.size();

        if (findingCount == 0
                && recommendationCount == 0) {

            return "No intersection or proximity condition "
                    + "was found in the currently active GIS "
                    + "layers. This is a screening result and "
                    + "does not replace departmental review.";
        }

        String message =
                findingCount
                + " spatial finding(s) and "
                + recommendationCount
                + " clearance recommendation(s) "
                + "were generated.";

        if (reviewRequired) {
            message += " Government officer verification "
                    + "is required.";
        }

        return message;
    }

    public SpatialScreeningResult getSavedResult(
            long clearanceApplicationId
    ) throws SQLException {

        if (clearanceApplicationId <= 0) {
            throw new IllegalArgumentException(
                    "Valid clearance application ID is required."
            );
        }

        SpatialScreeningResult result =
                new SpatialScreeningResult();

        result.setClearanceApplicationId(
                clearanceApplicationId
        );

        Long mapId =
                spatialScreeningDAO
                        .findLatestProjectMapId(
                                clearanceApplicationId
                        );

        if (mapId != null) {
            result.setClearanceMapId(mapId);

            result.setProjectAreaHectares(
                    spatialScreeningDAO
                            .findProjectAreaHectares(
                                    mapId
                            )
            );
        }

        List<SpatialFinding> findings =
                spatialScreeningDAO
                        .findSavedFindings(
                                clearanceApplicationId
                        );

        List<GisRecommendation> recommendations =
                spatialScreeningDAO
                        .findSavedRecommendations(
                                clearanceApplicationId
                        );

        result.setFindings(findings);
        result.setRecommendations(recommendations);

        result.setIntersectingFeatureCount(
                countIntersections(findings)
        );

        result.setNearbyFeatureCount(
                countNearbyFindings(findings)
        );

        result.setRecommendationCount(
                recommendations.size()
        );

        result.setAnalysisCompleted(
                !findings.isEmpty()
                || !recommendations.isEmpty()
        );

        result.setAnalysisStatus(
                result.isAnalysisCompleted()
                        ? "COMPLETED"
                        : "NOT_RUN"
        );

        result.setManualReviewRequired(
                hasReviewRequiredFinding(
                        findings,
                        recommendations
                )
        );

        result.setSummaryMessage(
                buildSummaryMessage(
                        findings,
                        recommendations,
                        result.isManualReviewRequired()
                )
        );

        return result;
    }

    private int countIntersections(
            List<SpatialFinding> findings
    ) {

        int count = 0;

        for (SpatialFinding finding : findings) {
            if ("INTERSECTS".equalsIgnoreCase(
                    finding.getSpatialRelation()
            )) {
                count++;
            }
        }

        return count;
    }

    private int countNearbyFindings(
            List<SpatialFinding> findings
    ) {

        int count = 0;

        for (SpatialFinding finding : findings) {
            if ("DISTANCE_WITHIN".equalsIgnoreCase(
                    finding.getSpatialRelation()
            )) {
                count++;
            }
        }

        return count;
    }
}