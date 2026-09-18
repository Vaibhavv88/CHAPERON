package com.chaperon.dao.impl;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.SpatialScreeningDAO;
import com.chaperon.model.SpatialScreeningResult.GisRecommendation;
import com.chaperon.model.SpatialScreeningResult.SpatialFinding;
import com.chaperon.util.DBConnection;

public class SpatialScreeningDAOImpl
        implements SpatialScreeningDAO {

    @Override
    public Long findLatestProjectMapId(
            long clearanceApplicationId
    ) throws SQLException {

        String sql =
                "SELECT clearance_map_id "
              + "FROM clearance_application_maps "
              + "WHERE clearance_application_id = ? "
              + "AND geojson_data IS NOT NULL "
              + "AND TRIM(geojson_data) <> '' "
              + "ORDER BY clearance_map_id DESC "
              + "LIMIT 1";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, clearanceApplicationId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {
                    return resultSet.getLong(
                            "clearance_map_id"
                    );
                }
            }
        }

        return null;
    }

    @Override
    public boolean projectBoundaryExists(
            long clearanceApplicationId,
            long clearanceMapId
    ) throws SQLException {

        String sql =
                "SELECT 1 "
              + "FROM clearance_application_maps "
              + "WHERE clearance_map_id = ? "
              + "AND clearance_application_id = ? "
              + "AND geojson_data IS NOT NULL "
              + "AND TRIM(geojson_data) <> '' "
              + "AND ST_IsValid("
              + "ST_GeomFromGeoJSON(geojson_data, 1, 4326)"
              + ") = 1";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, clearanceMapId);
            statement.setLong(2, clearanceApplicationId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                return resultSet.next();
            }
        }
    }

    @Override
    public BigDecimal findProjectAreaHectares(
            long clearanceMapId
    ) throws SQLException {

        String sql =
                "SELECT calculated_area_hectares "
              + "FROM clearance_application_maps "
              + "WHERE clearance_map_id = ?";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, clearanceMapId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (resultSet.next()) {
                    return resultSet.getBigDecimal(
                            "calculated_area_hectares"
                    );
                }
            }
        }

        return null;
    }

    @Override
    public String findProjectState(
            long clearanceApplicationId
    ) throws SQLException {

        return findLocationValue(
                clearanceApplicationId,
                new String[] {
                        "state_name",
                        "project_state",
                        "state"
                }
        );
    }

    @Override
    public String findProjectDistrict(
            long clearanceApplicationId
    ) throws SQLException {

        return findLocationValue(
                clearanceApplicationId,
                new String[] {
                        "district_name",
                        "project_district",
                        "district"
                }
        );
    }

    private String findLocationValue(
            long clearanceApplicationId,
            String[] candidateColumns
    ) throws SQLException {

        SQLException lastException = null;

        for (String column : candidateColumns) {

            String sql =
                    "SELECT " + column + " "
                  + "FROM clearance_applications "
                  + "WHERE clearance_application_id = ?";

            try (Connection connection =
                         DBConnection.getConnection();
                 PreparedStatement statement =
                         connection.prepareStatement(sql)) {

                statement.setLong(
                        1,
                        clearanceApplicationId
                );

                try (ResultSet resultSet =
                             statement.executeQuery()) {

                    if (resultSet.next()) {
                        String value =
                                resultSet.getString(column);

                        return clean(value);
                    }
                }

            } catch (SQLException exception) {
                lastException = exception;

                if (!isUnknownColumn(exception)) {
                    throw exception;
                }
            }
        }

        /*
         * Location is optional for All-India GIS layers.
         * If none of the candidate columns exists, return null.
         */
        if (lastException != null
                && !isUnknownColumn(lastException)) {
            throw lastException;
        }

        return null;
    }

    @Override
    public int countApplicableActiveLayers(
            String projectState,
            String projectDistrict
    ) throws SQLException {

        String sql =
                "SELECT COUNT(*) AS total "
              + "FROM gis_layers gl "
              + "WHERE gl.active = 1 "
              + "AND ("
              + "gl.state_name IS NULL "
              + "OR TRIM(gl.state_name) = '' "
              + "OR LOWER(gl.state_name) = LOWER(?)"
              + ") "
              + "AND ("
              + "gl.district_name IS NULL "
              + "OR TRIM(gl.district_name) = '' "
              + "OR LOWER(gl.district_name) = LOWER(?)"
              + ")";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, safe(projectState));
            statement.setString(2, safe(projectDistrict));

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                return resultSet.next()
                        ? resultSet.getInt("total")
                        : 0;
            }
        }
    }

    @Override
    public List<SpatialFinding> findIntersectingFeatures(
            long clearanceMapId,
            String projectState,
            String projectDistrict
    ) throws SQLException {

        List<SpatialFinding> findings =
                new ArrayList<>();

        String sql =
                "SELECT "
              + "gf.gis_feature_id, "
              + "gf.feature_code, "
              + "gf.feature_name, "
              + "gl.layer_code, "
              + "gl.layer_name, "
              + "gl.layer_category, "
              + "cam.calculated_area_hectares, "
              + "ST_Area("
              + "ST_Intersection("
              + "gf.boundary_geometry, "
              + "ST_GeomFromGeoJSON(cam.geojson_data, 1, 4326)"
              + ")"
              + ") / 10000 AS intersection_hectares "
              + "FROM clearance_application_maps cam "
              + "JOIN gis_features gf "
              + "ON gf.active = 1 "
              + "JOIN gis_layers gl "
              + "ON gl.gis_layer_id = gf.gis_layer_id "
              + "AND gl.active = 1 "
              + "WHERE cam.clearance_map_id = ? "
              + "AND ST_Intersects("
              + "gf.boundary_geometry, "
              + "ST_GeomFromGeoJSON("
              + "cam.geojson_data, 1, 4326"
              + ")"
              + ") = 1 "
              + "AND ("
              + "gl.state_name IS NULL "
              + "OR TRIM(gl.state_name) = '' "
              + "OR LOWER(gl.state_name) = LOWER(?)"
              + ") "
              + "AND ("
              + "gl.district_name IS NULL "
              + "OR TRIM(gl.district_name) = '' "
              + "OR LOWER(gl.district_name) = LOWER(?)"
              + ")";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, clearanceMapId);
            statement.setString(2, safe(projectState));
            statement.setString(3, safe(projectDistrict));

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    SpatialFinding finding =
                            mapFinding(resultSet);

                    finding.setSpatialRelation(
                            "INTERSECTS"
                    );

                    BigDecimal intersectionArea =
                            resultSet.getBigDecimal(
                                    "intersection_hectares"
                            );

                    BigDecimal projectArea =
                            resultSet.getBigDecimal(
                                    "calculated_area_hectares"
                            );

                    finding.setIntersectionAreaHectares(
                            intersectionArea
                    );

                    finding.setIntersectionPercentage(
                            calculatePercentage(
                                    intersectionArea,
                                    projectArea
                            )
                    );

                    finding.setDistanceKilometres(
                            BigDecimal.ZERO
                    );

                    finding.setFindingMessage(
                            "Project boundary intersects "
                            + finding.getFeatureName()
                            + " in the "
                            + finding.getLayerName()
                            + " GIS layer."
                    );

                    findings.add(finding);
                }
            }
        }

        return findings;
    }

    @Override
    public List<SpatialFinding> findNearbyFeatures(
            long clearanceMapId,
            String projectState,
            String projectDistrict,
            BigDecimal maximumDistanceKilometres
    ) throws SQLException {

        List<SpatialFinding> findings =
                new ArrayList<>();

        if (maximumDistanceKilometres == null
                || maximumDistanceKilometres
                        .compareTo(BigDecimal.ZERO) <= 0) {
            return findings;
        }

        String distanceExpression =
                "ST_Distance("
              + "gf.boundary_geometry, "
              + "ST_GeomFromGeoJSON("
              + "cam.geojson_data, 1, 4326"
              + "), 'kilometre'"
              + ")";

        String sql =
                "SELECT "
              + "gf.gis_feature_id, "
              + "gf.feature_code, "
              + "gf.feature_name, "
              + "gl.layer_code, "
              + "gl.layer_name, "
              + "gl.layer_category, "
              + distanceExpression
              + " AS distance_km "
              + "FROM clearance_application_maps cam "
              + "JOIN gis_features gf "
              + "ON gf.active = 1 "
              + "JOIN gis_layers gl "
              + "ON gl.gis_layer_id = gf.gis_layer_id "
              + "AND gl.active = 1 "
              + "WHERE cam.clearance_map_id = ? "
              + "AND ST_Intersects("
              + "gf.boundary_geometry, "
              + "ST_GeomFromGeoJSON("
              + "cam.geojson_data, 1, 4326"
              + ")"
              + ") = 0 "
              + "AND " + distanceExpression + " <= ? "
              + "AND ("
              + "gl.state_name IS NULL "
              + "OR TRIM(gl.state_name) = '' "
              + "OR LOWER(gl.state_name) = LOWER(?)"
              + ") "
              + "AND ("
              + "gl.district_name IS NULL "
              + "OR TRIM(gl.district_name) = '' "
              + "OR LOWER(gl.district_name) = LOWER(?)"
              + ") "
              + "ORDER BY distance_km";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, clearanceMapId);

            statement.setBigDecimal(
                    2,
                    maximumDistanceKilometres
            );

            statement.setString(3, safe(projectState));
            statement.setString(4, safe(projectDistrict));

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    SpatialFinding finding =
                            mapFinding(resultSet);

                    finding.setSpatialRelation(
                            "DISTANCE_WITHIN"
                    );

                    finding.setDistanceKilometres(
                            resultSet.getBigDecimal(
                                    "distance_km"
                            )
                    );

                    finding.setFindingMessage(
                            finding.getFeatureName()
                            + " is approximately "
                            + finding.getDistanceKilometres()
                            + " km from the project boundary."
                    );

                    findings.add(finding);
                }
            }
        }

        return findings;
    }

    @Override
    public List<GisRecommendation> findApplicableRules(
            String layerCategory,
            String spatialRelation,
            BigDecimal actualDistanceKilometres,
            BigDecimal projectAreaHectares,
            String pollutionCategory,
            String projectState
    ) throws SQLException {

        List<GisRecommendation> recommendations =
                new ArrayList<>();

        String sql =
                "SELECT "
              + "gar.gis_rule_id, "
              + "gar.clearance_type_id, "
              + "gar.approval_id, "
              + "gar.recommendation_level, "
              + "gar.rule_name, "
              + "gar.spatial_condition, "
              + "gar.distance_km, "
              + "ct.clearance_code, "
              + "ct.clearance_name, "
              + "a.approval_name "
              + "FROM gis_applicability_rules gar "
              + "LEFT JOIN clearance_types ct "
              + "ON ct.clearance_type_id = "
              + "gar.clearance_type_id "
              + "LEFT JOIN approvals a "
              + "ON a.approval_id = gar.approval_id "
              + "WHERE gar.active = 1 "
              + "AND UPPER(gar.layer_category) = UPPER(?) "
              + "AND UPPER(gar.spatial_condition) = UPPER(?) "
              + "AND ("
              + "gar.applicable_state IS NULL "
              + "OR TRIM(gar.applicable_state) = '' "
              + "OR LOWER(gar.applicable_state) = LOWER(?)"
              + ") "
              + "AND ("
              + "gar.pollution_category IS NULL "
              + "OR TRIM(gar.pollution_category) = '' "
              + "OR UPPER(gar.pollution_category) = UPPER(?)"
              + ") "
              + "AND ("
              + "gar.minimum_project_area_hectares IS NULL "
              + "OR ? >= gar.minimum_project_area_hectares"
              + ") "
              + "AND ("
              + "gar.maximum_project_area_hectares IS NULL "
              + "OR ? <= gar.maximum_project_area_hectares"
              + ") "
              + "AND ("
              + "gar.distance_km IS NULL "
              + "OR ? <= gar.distance_km"
              + ") "
              + "ORDER BY gar.priority, gar.gis_rule_id";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            BigDecimal area =
                    projectAreaHectares == null
                            ? BigDecimal.ZERO
                            : projectAreaHectares;

            BigDecimal distance =
                    actualDistanceKilometres == null
                            ? BigDecimal.ZERO
                            : actualDistanceKilometres;

            statement.setString(1, layerCategory);
            statement.setString(2, spatialRelation);
            statement.setString(3, safe(projectState));
            statement.setString(
                    4,
                    safe(pollutionCategory)
            );
            statement.setBigDecimal(5, area);
            statement.setBigDecimal(6, area);
            statement.setBigDecimal(7, distance);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    GisRecommendation recommendation =
                            new GisRecommendation();

                    recommendation.setGisRuleId(
                            getNullableLong(
                                    resultSet,
                                    "gis_rule_id"
                            )
                    );

                    recommendation.setClearanceTypeId(
                            getNullableLong(
                                    resultSet,
                                    "clearance_type_id"
                            )
                    );

                    recommendation.setApprovalId(
                            getNullableLong(
                                    resultSet,
                                    "approval_id"
                            )
                    );

                    recommendation.setClearanceCode(
                            resultSet.getString(
                                    "clearance_code"
                            )
                    );

                    String clearanceName =
                            resultSet.getString(
                                    "clearance_name"
                            );

                    if (clearanceName == null) {
                        clearanceName =
                                resultSet.getString(
                                        "approval_name"
                                );
                    }

                    recommendation.setClearanceName(
                            clearanceName
                    );

                    recommendation.setRecommendationLevel(
                            resultSet.getString(
                                    "recommendation_level"
                            )
                    );

                    recommendation.setRecommendationReason(
                            resultSet.getString(
                                    "rule_name"
                            )
                    );

                    recommendation.setGeneratedFrom(
                            "INTERSECTS".equalsIgnoreCase(
                                    spatialRelation
                            )
                                    ? "GIS_INTERSECTION"
                                    : "GIS_DISTANCE"
                    );

                    recommendation.setStatus(
                            "SYSTEM_RECOMMENDED"
                    );

                    recommendations.add(recommendation);
                }
            }
        }

        return recommendations;
    }

    @Override
    public int deletePreviousSpatialAnalysis(
            long clearanceApplicationId
    ) throws SQLException {

        String sql =
                "DELETE FROM clearance_spatial_analysis "
              + "WHERE clearance_application_id = ?";

        return executeDelete(sql, clearanceApplicationId);
    }

    @Override
    public int deletePreviousSystemRecommendations(
            long clearanceApplicationId
    ) throws SQLException {

        String sql =
                "DELETE FROM clearance_gis_recommendations "
              + "WHERE clearance_application_id = ? "
              + "AND status = 'SYSTEM_RECOMMENDED'";

        return executeDelete(sql, clearanceApplicationId);
    }

    @Override
    public long saveSpatialFinding(
            long clearanceApplicationId,
            long clearanceMapId,
            SpatialFinding finding
    ) throws SQLException {

        String sql =
                "INSERT INTO clearance_spatial_analysis ("
              + "clearance_application_id, "
              + "clearance_map_id, "
              + "gis_feature_id, "
              + "gis_rule_id, "
              + "layer_category, "
              + "spatial_relation, "
              + "distance_km, "
              + "intersection_area_hectares, "
              + "intersection_percentage, "
              + "recommendation_level, "
              + "analysis_message, "
              + "verification_status"
              + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             sql,
                             Statement.RETURN_GENERATED_KEYS
                     )) {

            statement.setLong(1, clearanceApplicationId);
            statement.setLong(2, clearanceMapId);

            setNullableLong(
                    statement,
                    3,
                    finding.getGisFeatureId()
            );

            setNullableLong(
                    statement,
                    4,
                    finding.getGisRuleId()
            );

            statement.setString(
                    5,
                    finding.getLayerCategory()
            );

            statement.setString(
                    6,
                    finding.getSpatialRelation()
            );

            statement.setBigDecimal(
                    7,
                    finding.getDistanceKilometres()
            );

            statement.setBigDecimal(
                    8,
                    finding.getIntersectionAreaHectares()
            );

            statement.setBigDecimal(
                    9,
                    finding.getIntersectionPercentage()
            );

            statement.setString(
                    10,
                    finding.getRecommendationLevel()
            );

            statement.setString(
                    11,
                    finding.getFindingMessage()
            );

            statement.setString(12, "PENDING");

            statement.executeUpdate();

            try (ResultSet keys =
                         statement.getGeneratedKeys()) {

                return keys.next()
                        ? keys.getLong(1)
                        : 0L;
            }
        }
    }

    @Override
    public long saveRecommendation(
            long clearanceApplicationId,
            GisRecommendation recommendation
    ) throws SQLException {

        String sql =
                "INSERT INTO clearance_gis_recommendations ("
              + "clearance_application_id, "
              + "recommended_clearance_type_id, "
              + "recommendation_level, "
              + "recommendation_reason, "
              + "generated_from, "
              + "status"
              + ") VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             sql,
                             Statement.RETURN_GENERATED_KEYS
                     )) {

            statement.setLong(1, clearanceApplicationId);

            setNullableLong(
                    statement,
                    2,
                    recommendation.getClearanceTypeId()
            );

            statement.setString(
                    3,
                    recommendation.getRecommendationLevel()
            );

            statement.setString(
                    4,
                    recommendation.getRecommendationReason()
            );

            statement.setString(
                    5,
                    recommendation.getGeneratedFrom()
            );

            statement.setString(
                    6,
                    recommendation.getStatus()
            );

            statement.executeUpdate();

            try (ResultSet keys =
                         statement.getGeneratedKeys()) {

                return keys.next()
                        ? keys.getLong(1)
                        : 0L;
            }
        }
    }

    @Override
    public boolean recommendationExists(
            long clearanceApplicationId,
            Long clearanceTypeId,
            Long approvalId
    ) throws SQLException {

        String sql =
                "SELECT 1 "
              + "FROM clearance_gis_recommendations "
              + "WHERE clearance_application_id = ? "
              + "AND recommended_clearance_type_id "
              + "<=> ? "
              + "AND status <> 'OFFICER_REJECTED' "
              + "LIMIT 1";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, clearanceApplicationId);
            setNullableLong(statement, 2, clearanceTypeId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                return resultSet.next();
            }
        }
    }

    @Override
    public List<SpatialFinding> findSavedFindings(
            long clearanceApplicationId
    ) throws SQLException {

        List<SpatialFinding> findings =
                new ArrayList<>();

        String sql =
                "SELECT "
              + "csa.*, "
              + "gf.feature_code, "
              + "gf.feature_name, "
              + "gl.layer_code, "
              + "gl.layer_name "
              + "FROM clearance_spatial_analysis csa "
              + "LEFT JOIN gis_features gf "
              + "ON gf.gis_feature_id = csa.gis_feature_id "
              + "LEFT JOIN gis_layers gl "
              + "ON gl.gis_layer_id = gf.gis_layer_id "
              + "WHERE csa.clearance_application_id = ? "
              + "ORDER BY csa.spatial_analysis_id";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, clearanceApplicationId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    SpatialFinding finding =
                            mapFinding(resultSet);

                    finding.setSpatialAnalysisId(
                            resultSet.getLong(
                                    "spatial_analysis_id"
                            )
                    );

                    finding.setGisRuleId(
                            getNullableLong(
                                    resultSet,
                                    "gis_rule_id"
                            )
                    );

                    finding.setSpatialRelation(
                            resultSet.getString(
                                    "spatial_relation"
                            )
                    );

                    finding.setDistanceKilometres(
                            resultSet.getBigDecimal(
                                    "distance_km"
                            )
                    );

                    finding.setIntersectionAreaHectares(
                            resultSet.getBigDecimal(
                                    "intersection_area_hectares"
                            )
                    );

                    finding.setIntersectionPercentage(
                            resultSet.getBigDecimal(
                                    "intersection_percentage"
                            )
                    );

                    finding.setRecommendationLevel(
                            resultSet.getString(
                                    "recommendation_level"
                            )
                    );

                    finding.setFindingMessage(
                            resultSet.getString(
                                    "analysis_message"
                            )
                    );

                    String status =
                            resultSet.getString(
                                    "verification_status"
                            );

                    finding.setOfficerVerified(
                            "VERIFIED".equalsIgnoreCase(status)
                    );

                    findings.add(finding);
                }
            }
        }

        return findings;
    }

    @Override
    public List<GisRecommendation>
            findSavedRecommendations(
                    long clearanceApplicationId
            ) throws SQLException {

        List<GisRecommendation> recommendations =
                new ArrayList<>();

        String sql =
                "SELECT "
              + "cgr.*, "
              + "ct.clearance_code, "
              + "ct.clearance_name "
              + "FROM clearance_gis_recommendations cgr "
              + "LEFT JOIN clearance_types ct "
              + "ON ct.clearance_type_id = "
              + "cgr.recommended_clearance_type_id "
              + "WHERE cgr.clearance_application_id = ? "
              + "ORDER BY cgr.gis_recommendation_id";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, clearanceApplicationId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    GisRecommendation recommendation =
                            new GisRecommendation();

                    recommendation.setGisRecommendationId(
                            resultSet.getLong(
                                    "gis_recommendation_id"
                            )
                    );

                    recommendation.setClearanceTypeId(
                            getNullableLong(
                                    resultSet,
                                    "recommended_clearance_type_id"
                            )
                    );

                    recommendation.setClearanceCode(
                            resultSet.getString(
                                    "clearance_code"
                            )
                    );

                    recommendation.setClearanceName(
                            resultSet.getString(
                                    "clearance_name"
                            )
                    );

                    recommendation.setRecommendationLevel(
                            resultSet.getString(
                                    "recommendation_level"
                            )
                    );

                    recommendation.setRecommendationReason(
                            resultSet.getString(
                                    "recommendation_reason"
                            )
                    );

                    recommendation.setGeneratedFrom(
                            resultSet.getString(
                                    "generated_from"
                            )
                    );

                    recommendation.setStatus(
                            resultSet.getString("status")
                    );

                    recommendations.add(recommendation);
                }
            }
        }

        return recommendations;
    }

    @Override
    public boolean updateRecommendationDecision(
            long gisRecommendationId,
            String status,
            long officerUserId,
            String officerRemarks
    ) throws SQLException {

        if (!"OFFICER_CONFIRMED".equals(status)
                && !"OFFICER_REJECTED".equals(status)) {
            throw new IllegalArgumentException(
                    "Invalid recommendation decision."
            );
        }

        String sql =
                "UPDATE clearance_gis_recommendations "
              + "SET status = ?, "
              + "confirmed_by_user_id = ?, "
              + "officer_remarks = ?, "
              + "confirmed_at = CURRENT_TIMESTAMP "
              + "WHERE gis_recommendation_id = ?";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, status);
            statement.setLong(2, officerUserId);
            statement.setString(3, clean(officerRemarks));
            statement.setLong(4, gisRecommendationId);

            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean verifySpatialFinding(
            long spatialAnalysisId,
            long officerUserId,
            String verificationStatus,
            String verificationRemarks
    ) throws SQLException {

        if (!"VERIFIED".equals(verificationStatus)
                && !"REJECTED".equals(verificationStatus)) {
            throw new IllegalArgumentException(
                    "Invalid finding verification status."
            );
        }

        String sql =
                "UPDATE clearance_spatial_analysis "
              + "SET verification_status = ?, "
              + "verified_by_user_id = ?, "
              + "verification_remarks = ?, "
              + "verified_at = CURRENT_TIMESTAMP "
              + "WHERE spatial_analysis_id = ?";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, verificationStatus);
            statement.setLong(2, officerUserId);
            statement.setString(
                    3,
                    clean(verificationRemarks)
            );
            statement.setLong(4, spatialAnalysisId);

            return statement.executeUpdate() > 0;
        }
    }

    private SpatialFinding mapFinding(
            ResultSet resultSet
    ) throws SQLException {

        SpatialFinding finding =
                new SpatialFinding();

        finding.setGisFeatureId(
                getNullableLong(
                        resultSet,
                        "gis_feature_id"
                )
        );

        finding.setFeatureCode(
                resultSet.getString("feature_code")
        );

        finding.setFeatureName(
                resultSet.getString("feature_name")
        );

        finding.setLayerCode(
                resultSet.getString("layer_code")
        );

        finding.setLayerName(
                resultSet.getString("layer_name")
        );

        finding.setLayerCategory(
                resultSet.getString("layer_category")
        );

        return finding;
    }

    private int executeDelete(
            String sql,
            long clearanceApplicationId
    ) throws SQLException {

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setLong(1, clearanceApplicationId);

            return statement.executeUpdate();
        }
    }

    private BigDecimal calculatePercentage(
            BigDecimal intersectionArea,
            BigDecimal projectArea
    ) {

        if (intersectionArea == null
                || projectArea == null
                || projectArea.compareTo(
                        BigDecimal.ZERO
                ) <= 0) {
            return null;
        }

        return intersectionArea
                .multiply(BigDecimal.valueOf(100))
                .divide(
                        projectArea,
                        4,
                        java.math.RoundingMode.HALF_UP
                );
    }

    private Long getNullableLong(
            ResultSet resultSet,
            String columnName
    ) throws SQLException {

        long value = resultSet.getLong(columnName);

        return resultSet.wasNull() ? null : value;
    }

    private void setNullableLong(
            PreparedStatement statement,
            int index,
            Long value
    ) throws SQLException {

        if (value == null) {
            statement.setNull(
                    index,
                    java.sql.Types.BIGINT
            );
        } else {
            statement.setLong(index, value);
        }
    }

    private boolean isUnknownColumn(
            SQLException exception
    ) {

        return exception.getErrorCode() == 1054
                || "42S22".equals(
                        exception.getSQLState()
                );
    }

    private String clean(String value) {

        if (value == null) {
            return null;
        }

        String cleaned = value.trim();

        return cleaned.isEmpty() ? null : cleaned;
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }
}