package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;

import com.chaperon.dao.ClearanceMapDAO;
import com.chaperon.model.ClearanceApplicationMap;
import com.chaperon.util.DBConnection;

public class ClearanceMapDAOImpl
        implements ClearanceMapDAO {

    private static final String INSERT_MAP_SQL =
            "INSERT INTO clearance_application_maps "
            + "(clearance_application_id, map_name, map_type, "
            + "boundary_source, geojson_data, map_document_id, "
            + "centre_latitude, centre_longitude, "
            + "calculated_area_hectares, "
            + "protected_area_intersection, "
            + "eco_sensitive_zone_intersection, "
            + "nearest_protected_area, "
            + "distance_from_protected_area_km, "
            + "validation_status, validation_message, "
            + "uploaded_by_user_id) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String UPDATE_MAP_SQL =
            "UPDATE clearance_application_maps SET "
            + "map_name = ?, "
            + "map_type = ?, "
            + "boundary_source = ?, "
            + "geojson_data = ?, "
            + "map_document_id = ?, "
            + "centre_latitude = ?, "
            + "centre_longitude = ?, "
            + "calculated_area_hectares = ?, "
            + "protected_area_intersection = ?, "
            + "eco_sensitive_zone_intersection = ?, "
            + "nearest_protected_area = ?, "
            + "distance_from_protected_area_km = ?, "
            + "validation_status = ?, "
            + "validation_message = ? "
            + "WHERE clearance_application_id = ?";

    private static final String SELECT_BY_APPLICATION_SQL =
            "SELECT * "
            + "FROM clearance_application_maps "
            + "WHERE clearance_application_id = ? "
            + "ORDER BY clearance_map_id DESC "
            + "LIMIT 1";

    private static final String EXISTS_SQL =
            "SELECT COUNT(*) "
            + "FROM clearance_application_maps "
            + "WHERE clearance_application_id = ?";

    private static final String DELETE_SQL =
            "DELETE FROM clearance_application_maps "
            + "WHERE clearance_application_id = ?";

    @Override
    public long saveMap(
            ClearanceApplicationMap clearanceMap)
            throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            INSERT_MAP_SQL,
                            Statement.RETURN_GENERATED_KEYS)
        ) {
            statement.setLong(
                    1,
                    clearanceMap
                            .getClearanceApplicationId());

            statement.setString(
                    2,
                    clearanceMap.getMapName());

            statement.setString(
                    3,
                    valueOrDefault(
                            clearanceMap.getMapType(),
                            "PROJECT_BOUNDARY"));

            statement.setString(
                    4,
                    valueOrDefault(
                            clearanceMap.getBoundarySource(),
                            "DRAWN_ON_MAP"));

            statement.setString(
                    5,
                    clearanceMap.getGeojsonData());

            setNullableLong(
                    statement,
                    6,
                    clearanceMap.getMapDocumentId());

            statement.setBigDecimal(
                    7,
                    clearanceMap.getCentreLatitude());

            statement.setBigDecimal(
                    8,
                    clearanceMap.getCentreLongitude());

            statement.setBigDecimal(
                    9,
                    clearanceMap.getCalculatedAreaHectares());

            setNullableBoolean(
                    statement,
                    10,
                    clearanceMap
                            .getProtectedAreaIntersection());

            setNullableBoolean(
                    statement,
                    11,
                    clearanceMap
                            .getEcoSensitiveZoneIntersection());

            statement.setString(
                    12,
                    clearanceMap.getNearestProtectedArea());

            statement.setBigDecimal(
                    13,
                    clearanceMap
                            .getDistanceFromProtectedAreaKm());

            statement.setString(
                    14,
                    valueOrDefault(
                            clearanceMap.getValidationStatus(),
                            "PENDING"));

            statement.setString(
                    15,
                    clearanceMap.getValidationMessage());

            statement.setLong(
                    16,
                    clearanceMap.getUploadedByUserId());

            int rowsAffected =
                    statement.executeUpdate();

            if (rowsAffected == 0) {
                throw new SQLException(
                        "Project map could not be saved.");
            }

            try (
                ResultSet generatedKeys =
                        statement.getGeneratedKeys()
            ) {
                if (generatedKeys.next()) {
                    return generatedKeys.getLong(1);
                }
            }

            throw new SQLException(
                    "Map saved but generated ID was not returned.");
        }
    }

    @Override
    public boolean updateMap(
            ClearanceApplicationMap clearanceMap)
            throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            UPDATE_MAP_SQL)
        ) {
            statement.setString(
                    1,
                    clearanceMap.getMapName());

            statement.setString(
                    2,
                    valueOrDefault(
                            clearanceMap.getMapType(),
                            "PROJECT_BOUNDARY"));

            statement.setString(
                    3,
                    valueOrDefault(
                            clearanceMap.getBoundarySource(),
                            "DRAWN_ON_MAP"));

            statement.setString(
                    4,
                    clearanceMap.getGeojsonData());

            setNullableLong(
                    statement,
                    5,
                    clearanceMap.getMapDocumentId());

            statement.setBigDecimal(
                    6,
                    clearanceMap.getCentreLatitude());

            statement.setBigDecimal(
                    7,
                    clearanceMap.getCentreLongitude());

            statement.setBigDecimal(
                    8,
                    clearanceMap.getCalculatedAreaHectares());

            setNullableBoolean(
                    statement,
                    9,
                    clearanceMap
                            .getProtectedAreaIntersection());

            setNullableBoolean(
                    statement,
                    10,
                    clearanceMap
                            .getEcoSensitiveZoneIntersection());

            statement.setString(
                    11,
                    clearanceMap.getNearestProtectedArea());

            statement.setBigDecimal(
                    12,
                    clearanceMap
                            .getDistanceFromProtectedAreaKm());

            statement.setString(
                    13,
                    valueOrDefault(
                            clearanceMap.getValidationStatus(),
                            "PENDING"));

            statement.setString(
                    14,
                    clearanceMap.getValidationMessage());

            statement.setLong(
                    15,
                    clearanceMap
                            .getClearanceApplicationId());

            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public ClearanceApplicationMap getMapByApplicationId(
            long clearanceApplicationId)
            throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            SELECT_BY_APPLICATION_SQL)
        ) {
            statement.setLong(
                    1,
                    clearanceApplicationId);

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                if (resultSet.next()) {
                    return mapRow(resultSet);
                }
            }
        }

        return null;
    }

    @Override
    public boolean mapExists(
            long clearanceApplicationId)
            throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            EXISTS_SQL)
        ) {
            statement.setLong(
                    1,
                    clearanceApplicationId);

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {
                return resultSet.next()
                        && resultSet.getLong(1) > 0;
            }
        }
    }

    @Override
    public boolean deleteMap(
            long clearanceApplicationId)
            throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            DELETE_SQL)
        ) {
            statement.setLong(
                    1,
                    clearanceApplicationId);

            return statement.executeUpdate() > 0;
        }
    }

    private ClearanceApplicationMap mapRow(
            ResultSet resultSet)
            throws SQLException {

        ClearanceApplicationMap clearanceMap =
                new ClearanceApplicationMap();

        clearanceMap.setClearanceMapId(
                resultSet.getLong(
                        "clearance_map_id"));

        clearanceMap.setClearanceApplicationId(
                resultSet.getLong(
                        "clearance_application_id"));

        clearanceMap.setMapName(
                resultSet.getString("map_name"));

        clearanceMap.setMapType(
                resultSet.getString("map_type"));

        clearanceMap.setBoundarySource(
                resultSet.getString("boundary_source"));

        clearanceMap.setGeojsonData(
                resultSet.getString("geojson_data"));

        long mapDocumentId =
                resultSet.getLong("map_document_id");

        if (!resultSet.wasNull()) {
            clearanceMap.setMapDocumentId(
                    mapDocumentId);
        }

        clearanceMap.setCentreLatitude(
                resultSet.getBigDecimal(
                        "centre_latitude"));

        clearanceMap.setCentreLongitude(
                resultSet.getBigDecimal(
                        "centre_longitude"));

        clearanceMap.setCalculatedAreaHectares(
                resultSet.getBigDecimal(
                        "calculated_area_hectares"));

        Object protectedAreaValue =
                resultSet.getObject(
                        "protected_area_intersection");

        if (protectedAreaValue != null) {
            clearanceMap.setProtectedAreaIntersection(
                    resultSet.getBoolean(
                            "protected_area_intersection"));
        }

        Object ecoSensitiveValue =
                resultSet.getObject(
                        "eco_sensitive_zone_intersection");

        if (ecoSensitiveValue != null) {
            clearanceMap.setEcoSensitiveZoneIntersection(
                    resultSet.getBoolean(
                            "eco_sensitive_zone_intersection"));
        }

        clearanceMap.setNearestProtectedArea(
                resultSet.getString(
                        "nearest_protected_area"));

        clearanceMap.setDistanceFromProtectedAreaKm(
                resultSet.getBigDecimal(
                        "distance_from_protected_area_km"));

        clearanceMap.setValidationStatus(
                resultSet.getString(
                        "validation_status"));

        clearanceMap.setValidationMessage(
                resultSet.getString(
                        "validation_message"));

        clearanceMap.setUploadedByUserId(
                resultSet.getLong(
                        "uploaded_by_user_id"));

        long verifiedByUserId =
                resultSet.getLong(
                        "verified_by_user_id");

        if (!resultSet.wasNull()) {
            clearanceMap.setVerifiedByUserId(
                    verifiedByUserId);
        }

        clearanceMap.setVerifiedAt(
                resultSet.getTimestamp(
                        "verified_at"));

        clearanceMap.setCreatedAt(
                resultSet.getTimestamp(
                        "created_at"));

        clearanceMap.setUpdatedAt(
                resultSet.getTimestamp(
                        "updated_at"));

        return clearanceMap;
    }

    private void setNullableLong(
            PreparedStatement statement,
            int index,
            Long value)
            throws SQLException {

        if (value == null) {
            statement.setNull(
                    index,
                    Types.BIGINT);
        } else {
            statement.setLong(
                    index,
                    value);
        }
    }

    private void setNullableBoolean(
            PreparedStatement statement,
            int index,
            Boolean value)
            throws SQLException {

        if (value == null) {
            statement.setNull(
                    index,
                    Types.BOOLEAN);
        } else {
            statement.setBoolean(
                    index,
                    value);
        }
    }

    private String valueOrDefault(
            String value,
            String defaultValue) {

        if (value == null
                || value.trim().isEmpty()) {

            return defaultValue;
        }

        return value.trim();
    }
}