package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.ClearanceTypeDAO;
import com.chaperon.model.ClearanceType;
import com.chaperon.util.DBConnection;

public class ClearanceTypeDAOImpl implements ClearanceTypeDAO {

    private static final String FIND_ALL_ACTIVE =
            "SELECT * FROM clearance_types " +
            "WHERE active = TRUE " +
            "ORDER BY clearance_name";

    private static final String FIND_ALL =
            "SELECT * FROM clearance_types " +
            "ORDER BY clearance_name";

    private static final String FIND_BY_ID =
            "SELECT * FROM clearance_types " +
            "WHERE clearance_type_id = ?";

    private static final String FIND_BY_CODE =
            "SELECT * FROM clearance_types " +
            "WHERE clearance_code = ?";

    private static final String INSERT_CLEARANCE_TYPE =
            "INSERT INTO clearance_types " +
            "(clearance_code, clearance_name, description, " +
            "requires_map, requires_kml, active) " +
            "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String UPDATE_CLEARANCE_TYPE =
            "UPDATE clearance_types SET " +
            "clearance_code = ?, clearance_name = ?, description = ?, " +
            "requires_map = ?, requires_kml = ?, active = ? " +
            "WHERE clearance_type_id = ?";

    private static final String UPDATE_ACTIVE_STATUS =
            "UPDATE clearance_types SET active = ? " +
            "WHERE clearance_type_id = ?";

    @Override
    public List<ClearanceType> findAllActive()
            throws SQLException {

        return findList(FIND_ALL_ACTIVE);
    }

    @Override
    public List<ClearanceType> findAll()
            throws SQLException {

        return findList(FIND_ALL);
    }

    private List<ClearanceType> findList(String sql)
            throws SQLException {

        List<ClearanceType> clearanceTypes = new ArrayList<>();

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(sql);
            ResultSet resultSet = preparedStatement.executeQuery()
        ) {
            while (resultSet.next()) {
                clearanceTypes.add(mapClearanceType(resultSet));
            }
        }

        return clearanceTypes;
    }

    @Override
    public ClearanceType findById(long clearanceTypeId)
            throws SQLException {

        return findOne(FIND_BY_ID, clearanceTypeId);
    }

    @Override
    public ClearanceType findByCode(String clearanceCode)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(FIND_BY_CODE)
        ) {
            preparedStatement.setString(1, clearanceCode);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return mapClearanceType(resultSet);
                }
            }
        }

        return null;
    }

    private ClearanceType findOne(String sql, long id)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(sql)
        ) {
            preparedStatement.setLong(1, id);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return mapClearanceType(resultSet);
                }
            }
        }

        return null;
    }

    @Override
    public long createClearanceType(ClearanceType clearanceType)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            INSERT_CLEARANCE_TYPE,
                            Statement.RETURN_GENERATED_KEYS
                    )
        ) {
            setCommonParameters(preparedStatement, clearanceType);

            int affectedRows = preparedStatement.executeUpdate();
            if (affectedRows == 0) {
                return 0;
            }

            try (ResultSet generatedKeys =
                    preparedStatement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getLong(1);
                }
            }
        }

        return 0;
    }

    @Override
    public boolean updateClearanceType(ClearanceType clearanceType)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(UPDATE_CLEARANCE_TYPE)
        ) {
            setCommonParameters(preparedStatement, clearanceType);
            preparedStatement.setLong(
                    7,
                    clearanceType.getClearanceTypeId()
            );

            return preparedStatement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean updateActiveStatus(
            long clearanceTypeId,
            boolean active
    ) throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(UPDATE_ACTIVE_STATUS)
        ) {
            preparedStatement.setBoolean(1, active);
            preparedStatement.setLong(2, clearanceTypeId);

            return preparedStatement.executeUpdate() > 0;
        }
    }

    private void setCommonParameters(
            PreparedStatement preparedStatement,
            ClearanceType clearanceType
    ) throws SQLException {

        preparedStatement.setString(1, clearanceType.getClearanceCode());
        preparedStatement.setString(2, clearanceType.getClearanceName());
        preparedStatement.setString(3, clearanceType.getDescription());
        preparedStatement.setBoolean(4, clearanceType.isRequiresMap());
        preparedStatement.setBoolean(5, clearanceType.isRequiresKml());
        preparedStatement.setBoolean(6, clearanceType.isActive());
    }

    private ClearanceType mapClearanceType(ResultSet resultSet)
            throws SQLException {

        ClearanceType clearanceType = new ClearanceType();

        clearanceType.setClearanceTypeId(
                resultSet.getLong("clearance_type_id")
        );
        clearanceType.setClearanceCode(
                resultSet.getString("clearance_code")
        );
        clearanceType.setClearanceName(
                resultSet.getString("clearance_name")
        );
        clearanceType.setDescription(
                resultSet.getString("description")
        );
        clearanceType.setRequiresMap(
                resultSet.getBoolean("requires_map")
        );
        clearanceType.setRequiresKml(
                resultSet.getBoolean("requires_kml")
        );
        clearanceType.setActive(
                resultSet.getBoolean("active")
        );
        clearanceType.setCreatedAt(
                resultSet.getTimestamp("created_at")
        );
        clearanceType.setUpdatedAt(
                resultSet.getTimestamp("updated_at")
        );

        return clearanceType;
    }
}
