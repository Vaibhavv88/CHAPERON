package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.chaperon.dao.GisLayerDAO;
import com.chaperon.model.GisFeature;
import com.chaperon.model.GisLayer;
import com.chaperon.util.DBConnection;

public class GisLayerDAOImpl implements GisLayerDAO {

    private static final String INSERT_LAYER_SQL =
            "INSERT INTO gis_layers (" +
            "layer_code, layer_name, layer_category, " +
            "description, data_source, source_authority, " +
            "source_version, source_date, state_name, " +
            "district_name, coordinate_system, active, " +
            "uploaded_by_user_id" +
            ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String UPDATE_LAYER_SQL =
            "UPDATE gis_layers SET " +
            "layer_name = ?, " +
            "layer_category = ?, " +
            "description = ?, " +
            "data_source = ?, " +
            "source_authority = ?, " +
            "source_version = ?, " +
            "source_date = ?, " +
            "state_name = ?, " +
            "district_name = ?, " +
            "coordinate_system = ?, " +
            "active = ? " +
            "WHERE gis_layer_id = ?";

    private static final String SELECT_LAYER_BASE_SQL =
            "SELECT " +
            "gl.*, " +
            "COUNT(gf.gis_feature_id) AS feature_count " +
            "FROM gis_layers gl " +
            "LEFT JOIN gis_features gf " +
            "ON gf.gis_layer_id = gl.gis_layer_id ";

    private static final String LAYER_GROUP_BY_SQL =
            "GROUP BY " +
            "gl.gis_layer_id, gl.layer_code, gl.layer_name, " +
            "gl.layer_category, gl.description, gl.data_source, " +
            "gl.source_authority, gl.source_version, " +
            "gl.source_date, gl.state_name, gl.district_name, " +
            "gl.coordinate_system, gl.active, " +
            "gl.uploaded_by_user_id, gl.created_at, gl.updated_at ";

    private static final String INSERT_FEATURE_SQL =
            "INSERT INTO gis_features (" +
            "gis_layer_id, feature_code, feature_name, " +
            "feature_type, state_name, district_name, " +
            "source_properties, boundary_geometry, " +
            "calculated_area_hectares, active" +
            ") VALUES (" +
            "?, ?, ?, ?, ?, ?, CAST(? AS JSON), " +
            "ST_GeomFromGeoJSON(?, 1, 4326), ?, ?" +
            ")";

    private static final String SELECT_FEATURE_BASE_SQL =
            "SELECT " +
            "gf.gis_feature_id, " +
            "gf.gis_layer_id, " +
            "gf.feature_code, " +
            "gf.feature_name, " +
            "gf.feature_type, " +
            "gf.state_name, " +
            "gf.district_name, " +
            "CAST(gf.source_properties AS CHAR) " +
            "AS source_properties, " +
            "ST_AsGeoJSON(gf.boundary_geometry) " +
            "AS boundary_geojson, " +
            "gf.calculated_area_hectares, " +
            "gf.active, " +
            "gf.created_at, " +
            "gf.updated_at, " +
            "gl.layer_code, " +
            "gl.layer_name, " +
            "gl.layer_category " +
            "FROM gis_features gf " +
            "JOIN gis_layers gl " +
            "ON gl.gis_layer_id = gf.gis_layer_id ";

    @Override
    public long saveLayer(
            GisLayer gisLayer
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            INSERT_LAYER_SQL,
                            Statement.RETURN_GENERATED_KEYS
                    )
        ) {

            setLayerInsertParameters(
                    statement,
                    gisLayer
            );

            int affectedRows =
                    statement.executeUpdate();

            if (affectedRows == 0) {
                return 0;
            }

            try (
                ResultSet generatedKeys =
                        statement.getGeneratedKeys()
            ) {

                if (generatedKeys.next()) {
                    return generatedKeys.getLong(1);
                }
            }
        }

        return 0;
    }

    @Override
    public boolean updateLayer(
            GisLayer gisLayer
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            UPDATE_LAYER_SQL
                    )
        ) {

            statement.setString(
                    1,
                    gisLayer.getLayerName()
            );

            statement.setString(
                    2,
                    gisLayer.getLayerCategory()
            );

            statement.setString(
                    3,
                    gisLayer.getDescription()
            );

            statement.setString(
                    4,
                    gisLayer.getDataSource()
            );

            statement.setString(
                    5,
                    gisLayer.getSourceAuthority()
            );

            statement.setString(
                    6,
                    gisLayer.getSourceVersion()
            );

            setNullableDate(
                    statement,
                    7,
                    gisLayer.getSourceDate()
            );

            setNullableString(
                    statement,
                    8,
                    gisLayer.getStateName()
            );

            setNullableString(
                    statement,
                    9,
                    gisLayer.getDistrictName()
            );

            statement.setString(
                    10,
                    defaultCoordinateSystem(
                            gisLayer.getCoordinateSystem()
                    )
            );

            statement.setBoolean(
                    11,
                    gisLayer.isActive()
            );

            statement.setLong(
                    12,
                    gisLayer.getGisLayerId()
            );

            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean updateLayerStatus(
            long gisLayerId,
            boolean active
    ) throws SQLException {

        String sql =
                "UPDATE gis_layers " +
                "SET active = ? " +
                "WHERE gis_layer_id = ?";

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setBoolean(
                    1,
                    active
            );

            statement.setLong(
                    2,
                    gisLayerId
            );

            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public GisLayer findLayerById(
            long gisLayerId
    ) throws SQLException {

        String sql =
                SELECT_LAYER_BASE_SQL +
                "WHERE gl.gis_layer_id = ? " +
                LAYER_GROUP_BY_SQL;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    gisLayerId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {
                    return mapLayer(resultSet);
                }
            }
        }

        return null;
    }

    @Override
    public GisLayer findLayerByCode(
            String layerCode
    ) throws SQLException {

        String sql =
                SELECT_LAYER_BASE_SQL +
                "WHERE gl.layer_code = ? " +
                LAYER_GROUP_BY_SQL;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    layerCode
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {
                    return mapLayer(resultSet);
                }
            }
        }

        return null;
    }

    @Override
    public List<GisLayer> findAllLayers()
            throws SQLException {

        String sql =
                SELECT_LAYER_BASE_SQL +
                LAYER_GROUP_BY_SQL +
                "ORDER BY gl.created_at DESC, " +
                "gl.gis_layer_id DESC";

        return executeLayerListQuery(
                sql
        );
    }

    @Override
    public List<GisLayer> findActiveLayers()
            throws SQLException {

        String sql =
                SELECT_LAYER_BASE_SQL +
                "WHERE gl.active = 1 " +
                LAYER_GROUP_BY_SQL +
                "ORDER BY gl.layer_category, " +
                "gl.layer_name";

        return executeLayerListQuery(
                sql
        );
    }

    @Override
    public List<GisLayer> findApplicableLayers(
            String stateName,
            String districtName
    ) throws SQLException {

        String sql =
                SELECT_LAYER_BASE_SQL +
                "WHERE gl.active = 1 " +
                "AND (" +
                "gl.state_name IS NULL " +
                "OR TRIM(gl.state_name) = '' " +
                "OR LOWER(gl.state_name) = LOWER(?)" +
                ") " +
                "AND (" +
                "gl.district_name IS NULL " +
                "OR TRIM(gl.district_name) = '' " +
                "OR LOWER(gl.district_name) = LOWER(?)" +
                ") " +
                LAYER_GROUP_BY_SQL +
                "ORDER BY gl.layer_category, gl.layer_name";

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    stateName != null
                            ? stateName
                            : ""
            );

            statement.setString(
                    2,
                    districtName != null
                            ? districtName
                            : ""
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                List<GisLayer> layers =
                        new ArrayList<>();

                while (resultSet.next()) {

                    layers.add(
                            mapLayer(resultSet)
                    );
                }

                return layers;
            }
        }
    }

    @Override
    public long saveFeature(
            GisFeature gisFeature
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            INSERT_FEATURE_SQL,
                            Statement.RETURN_GENERATED_KEYS
                    )
        ) {

            setFeatureParameters(
                    statement,
                    gisFeature
            );

            int affectedRows =
                    statement.executeUpdate();

            if (affectedRows == 0) {
                return 0;
            }

            try (
                ResultSet generatedKeys =
                        statement.getGeneratedKeys()
            ) {

                if (generatedKeys.next()) {
                    return generatedKeys.getLong(1);
                }
            }
        }

        return 0;
    }

    @Override
    public int saveFeatures(
            List<GisFeature> gisFeatures
    ) throws SQLException {

        if (gisFeatures == null ||
                gisFeatures.isEmpty()) {

            return 0;
        }

        Connection connection = null;

        try {

            connection =
                    DBConnection.getConnection();

            connection.setAutoCommit(false);

            int insertedCount = 0;

            try (
                PreparedStatement statement =
                        connection.prepareStatement(
                                INSERT_FEATURE_SQL
                        )
            ) {

                for (GisFeature feature : gisFeatures) {

                    setFeatureParameters(
                            statement,
                            feature
                    );

                    statement.addBatch();
                }

                int[] results =
                        statement.executeBatch();

                for (int result : results) {

                    if (result > 0 ||
                            result ==
                            Statement.SUCCESS_NO_INFO) {

                        insertedCount++;
                    }
                }
            }

            connection.commit();

            return insertedCount;

        } catch (SQLException exception) {

            if (connection != null) {

                try {
                    connection.rollback();
                } catch (SQLException ignored) {
                }
            }

            throw exception;

        } finally {

            if (connection != null) {

                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }

    @Override
    public GisFeature findFeatureById(
            long gisFeatureId
    ) throws SQLException {

        String sql =
                SELECT_FEATURE_BASE_SQL +
                "WHERE gf.gis_feature_id = ?";

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    gisFeatureId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {
                    return mapFeature(resultSet);
                }
            }
        }

        return null;
    }

    @Override
    public List<GisFeature> findFeaturesByLayerId(
            long gisLayerId
    ) throws SQLException {

        String sql =
                SELECT_FEATURE_BASE_SQL +
                "WHERE gf.gis_layer_id = ? " +
                "ORDER BY gf.feature_name";

        return executeFeatureListQuery(
                sql,
                gisLayerId
        );
    }

    @Override
    public List<GisFeature> findActiveFeaturesByLayerId(
            long gisLayerId
    ) throws SQLException {

        String sql =
                SELECT_FEATURE_BASE_SQL +
                "WHERE gf.gis_layer_id = ? " +
                "AND gf.active = 1 " +
                "ORDER BY gf.feature_name";

        return executeFeatureListQuery(
                sql,
                gisLayerId
        );
    }

    @Override
    public boolean updateFeatureStatus(
            long gisFeatureId,
            boolean active
    ) throws SQLException {

        String sql =
                "UPDATE gis_features " +
                "SET active = ? " +
                "WHERE gis_feature_id = ?";

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setBoolean(
                    1,
                    active
            );

            statement.setLong(
                    2,
                    gisFeatureId
            );

            return statement.executeUpdate() > 0;
        }
    }

    @Override
    public int countFeaturesByLayerId(
            long gisLayerId
    ) throws SQLException {

        String sql =
                "SELECT COUNT(*) " +
                "FROM gis_features " +
                "WHERE gis_layer_id = ?";

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    gisLayerId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        }

        return 0;
    }

    @Override
    public boolean layerCodeExists(
            String layerCode
    ) throws SQLException {

        String sql =
                "SELECT 1 " +
                "FROM gis_layers " +
                "WHERE layer_code = ? " +
                "LIMIT 1";

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(
                    1,
                    layerCode
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                return resultSet.next();
            }
        }
    }

    @Override
    public boolean featureCodeExists(
            long gisLayerId,
            String featureCode
    ) throws SQLException {

        if (featureCode == null ||
                featureCode.isBlank()) {

            return false;
        }

        String sql =
                "SELECT 1 " +
                "FROM gis_features " +
                "WHERE gis_layer_id = ? " +
                "AND feature_code = ? " +
                "LIMIT 1";

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    gisLayerId
            );

            statement.setString(
                    2,
                    featureCode
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                return resultSet.next();
            }
        }
    }

    private List<GisLayer> executeLayerListQuery(
            String sql
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            List<GisLayer> layers =
                    new ArrayList<>();

            while (resultSet.next()) {

                layers.add(
                        mapLayer(resultSet)
                );
            }

            return layers;
        }
    }

    private List<GisFeature> executeFeatureListQuery(
            String sql,
            long gisLayerId
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    gisLayerId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                List<GisFeature> features =
                        new ArrayList<>();

                while (resultSet.next()) {

                    features.add(
                            mapFeature(resultSet)
                    );
                }

                return features;
            }
        }
    }

    private void setLayerInsertParameters(
            PreparedStatement statement,
            GisLayer layer
    ) throws SQLException {

        statement.setString(
                1,
                layer.getLayerCode()
        );

        statement.setString(
                2,
                layer.getLayerName()
        );

        statement.setString(
                3,
                layer.getLayerCategory()
        );

        statement.setString(
                4,
                layer.getDescription()
        );

        statement.setString(
                5,
                layer.getDataSource()
        );

        statement.setString(
                6,
                layer.getSourceAuthority()
        );

        statement.setString(
                7,
                layer.getSourceVersion()
        );

        setNullableDate(
                statement,
                8,
                layer.getSourceDate()
        );

        setNullableString(
                statement,
                9,
                layer.getStateName()
        );

        setNullableString(
                statement,
                10,
                layer.getDistrictName()
        );

        statement.setString(
                11,
                defaultCoordinateSystem(
                        layer.getCoordinateSystem()
                )
        );

        statement.setBoolean(
                12,
                layer.isActive()
        );

        if (layer.getUploadedByUserId() == null) {

            statement.setNull(
                    13,
                    Types.BIGINT
            );

        } else {

            statement.setLong(
                    13,
                    layer.getUploadedByUserId()
            );
        }
    }

    private void setFeatureParameters(
            PreparedStatement statement,
            GisFeature feature
    ) throws SQLException {

        statement.setLong(
                1,
                feature.getGisLayerId()
        );

        setNullableString(
                statement,
                2,
                feature.getFeatureCode()
        );

        statement.setString(
                3,
                feature.getFeatureName()
        );

        setNullableString(
                statement,
                4,
                feature.getFeatureType()
        );

        setNullableString(
                statement,
                5,
                feature.getStateName()
        );

        setNullableString(
                statement,
                6,
                feature.getDistrictName()
        );

        statement.setString(
                7,
                defaultJson(
                        feature.getSourceProperties()
                )
        );

        statement.setString(
                8,
                feature.getBoundaryGeoJson()
        );

        if (feature.getCalculatedAreaHectares()
                == null) {

            statement.setNull(
                    9,
                    Types.DECIMAL
            );

        } else {

            statement.setBigDecimal(
                    9,
                    feature.getCalculatedAreaHectares()
            );
        }

        statement.setBoolean(
                10,
                feature.isActive()
        );
    }

    private GisLayer mapLayer(
            ResultSet resultSet
    ) throws SQLException {

        GisLayer layer =
                new GisLayer();

        layer.setGisLayerId(
                resultSet.getLong(
                        "gis_layer_id"
                )
        );

        layer.setLayerCode(
                resultSet.getString(
                        "layer_code"
                )
        );

        layer.setLayerName(
                resultSet.getString(
                        "layer_name"
                )
        );

        layer.setLayerCategory(
                resultSet.getString(
                        "layer_category"
                )
        );

        layer.setDescription(
                resultSet.getString(
                        "description"
                )
        );

        layer.setDataSource(
                resultSet.getString(
                        "data_source"
                )
        );

        layer.setSourceAuthority(
                resultSet.getString(
                        "source_authority"
                )
        );

        layer.setSourceVersion(
                resultSet.getString(
                        "source_version"
                )
        );

        layer.setSourceDate(
                resultSet.getDate(
                        "source_date"
                )
        );

        layer.setStateName(
                resultSet.getString(
                        "state_name"
                )
        );

        layer.setDistrictName(
                resultSet.getString(
                        "district_name"
                )
        );

        layer.setCoordinateSystem(
                resultSet.getString(
                        "coordinate_system"
                )
        );

        layer.setActive(
                resultSet.getBoolean(
                        "active"
                )
        );

        long uploadedBy =
                resultSet.getLong(
                        "uploaded_by_user_id"
                );

        if (!resultSet.wasNull()) {

            layer.setUploadedByUserId(
                    uploadedBy
            );
        }

        layer.setCreatedAt(
                resultSet.getTimestamp(
                        "created_at"
                )
        );

        layer.setUpdatedAt(
                resultSet.getTimestamp(
                        "updated_at"
                )
        );

        layer.setFeatureCount(
                resultSet.getInt(
                        "feature_count"
                )
        );

        return layer;
    }

    private GisFeature mapFeature(
            ResultSet resultSet
    ) throws SQLException {

        GisFeature feature =
                new GisFeature();

        feature.setGisFeatureId(
                resultSet.getLong(
                        "gis_feature_id"
                )
        );

        feature.setGisLayerId(
                resultSet.getLong(
                        "gis_layer_id"
                )
        );

        feature.setFeatureCode(
                resultSet.getString(
                        "feature_code"
                )
        );

        feature.setFeatureName(
                resultSet.getString(
                        "feature_name"
                )
        );

        feature.setFeatureType(
                resultSet.getString(
                        "feature_type"
                )
        );

        feature.setStateName(
                resultSet.getString(
                        "state_name"
                )
        );

        feature.setDistrictName(
                resultSet.getString(
                        "district_name"
                )
        );

        feature.setSourceProperties(
                resultSet.getString(
                        "source_properties"
                )
        );

        feature.setBoundaryGeoJson(
                resultSet.getString(
                        "boundary_geojson"
                )
        );

        feature.setCalculatedAreaHectares(
                resultSet.getBigDecimal(
                        "calculated_area_hectares"
                )
        );

        feature.setActive(
                resultSet.getBoolean(
                        "active"
                )
        );

        feature.setCreatedAt(
                resultSet.getTimestamp(
                        "created_at"
                )
        );

        feature.setUpdatedAt(
                resultSet.getTimestamp(
                        "updated_at"
                )
        );

        feature.setLayerCode(
                resultSet.getString(
                        "layer_code"
                )
        );

        feature.setLayerName(
                resultSet.getString(
                        "layer_name"
                )
        );

        feature.setLayerCategory(
                resultSet.getString(
                        "layer_category"
                )
        );

        return feature;
    }

    private void setNullableString(
            PreparedStatement statement,
            int parameterIndex,
            String value
    ) throws SQLException {

        if (value == null ||
                value.isBlank()) {

            statement.setNull(
                    parameterIndex,
                    Types.VARCHAR
            );

        } else {

            statement.setString(
                    parameterIndex,
                    value.trim()
            );
        }
    }

    private void setNullableDate(
            PreparedStatement statement,
            int parameterIndex,
            Date value
    ) throws SQLException {

        if (value == null) {

            statement.setNull(
                    parameterIndex,
                    Types.DATE
            );

        } else {

            statement.setDate(
                    parameterIndex,
                    value
            );
        }
    }

    private String defaultCoordinateSystem(
            String coordinateSystem
    ) {

        if (coordinateSystem == null ||
                coordinateSystem.isBlank()) {

            return "EPSG:4326";
        }

        return coordinateSystem.trim();
    }

    private String defaultJson(
            String json
    ) {

        if (json == null ||
                json.isBlank()) {

            return "{}";
        }

        return json.trim();
    }
}