package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.ClearanceRequirementDAO;
import com.chaperon.model.ClearanceRequirement;
import com.chaperon.util.DBConnection;

public class ClearanceRequirementDAOImpl
        implements ClearanceRequirementDAO {

    private static final String BASE_SELECT =
            "SELECT cr.*, ct.clearance_name " +
            "FROM clearance_requirements cr " +
            "JOIN clearance_types ct " +
            "ON ct.clearance_type_id = cr.clearance_type_id ";

    private static final String FIND_ACTIVE_BY_TYPE =
            BASE_SELECT +
            "WHERE cr.clearance_type_id = ? " +
            "AND cr.active = TRUE " +
            "ORDER BY cr.display_order, cr.requirement_id";

    private static final String FIND_ALL_BY_TYPE =
            BASE_SELECT +
            "WHERE cr.clearance_type_id = ? " +
            "ORDER BY cr.display_order, cr.requirement_id";

    private static final String FIND_ACTIVE_BY_TYPE_AND_ROLE =
            BASE_SELECT +
            "WHERE cr.clearance_type_id = ? " +
            "AND cr.responsible_role = ? " +
            "AND cr.active = TRUE " +
            "ORDER BY cr.display_order, cr.requirement_id";

    private static final String FIND_BY_ID =
            BASE_SELECT +
            "WHERE cr.requirement_id = ?";

    private static final String INSERT_REQUIREMENT =
            "INSERT INTO clearance_requirements " +
            "(clearance_type_id, category, requirement_name, " +
            "description, requirement_type, responsible_role, " +
            "mandatory, display_order, active) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String UPDATE_REQUIREMENT =
            "UPDATE clearance_requirements SET " +
            "clearance_type_id = ?, category = ?, requirement_name = ?, " +
            "description = ?, requirement_type = ?, responsible_role = ?, " +
            "mandatory = ?, display_order = ?, active = ? " +
            "WHERE requirement_id = ?";

    private static final String UPDATE_ACTIVE_STATUS =
            "UPDATE clearance_requirements SET active = ? " +
            "WHERE requirement_id = ?";

    @Override
    public List<ClearanceRequirement> findActiveByClearanceTypeId(
            long clearanceTypeId
    ) throws SQLException {

        return findByType(FIND_ACTIVE_BY_TYPE, clearanceTypeId);
    }

    @Override
    public List<ClearanceRequirement> findAllByClearanceTypeId(
            long clearanceTypeId
    ) throws SQLException {

        return findByType(FIND_ALL_BY_TYPE, clearanceTypeId);
    }

    private List<ClearanceRequirement> findByType(
            String sql,
            long clearanceTypeId
    ) throws SQLException {

        List<ClearanceRequirement> requirements = new ArrayList<>();

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(sql)
        ) {
            preparedStatement.setLong(1, clearanceTypeId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    requirements.add(mapRequirement(resultSet));
                }
            }
        }

        return requirements;
    }

    @Override
    public List<ClearanceRequirement> findActiveByClearanceTypeAndRole(
            long clearanceTypeId,
            String responsibleRole
    ) throws SQLException {

        List<ClearanceRequirement> requirements = new ArrayList<>();

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(
                    FIND_ACTIVE_BY_TYPE_AND_ROLE
            )
        ) {
            preparedStatement.setLong(1, clearanceTypeId);
            preparedStatement.setString(2, responsibleRole);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    requirements.add(mapRequirement(resultSet));
                }
            }
        }

        return requirements;
    }

    @Override
    public ClearanceRequirement findById(long requirementId)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(FIND_BY_ID)
        ) {
            preparedStatement.setLong(1, requirementId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return mapRequirement(resultSet);
                }
            }
        }

        return null;
    }

    @Override
    public long createRequirement(ClearanceRequirement requirement)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(
                    INSERT_REQUIREMENT,
                    Statement.RETURN_GENERATED_KEYS
            )
        ) {
            setCommonParameters(preparedStatement, requirement);

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
    public boolean updateRequirement(ClearanceRequirement requirement)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(
                    UPDATE_REQUIREMENT
            )
        ) {
            setCommonParameters(preparedStatement, requirement);
            preparedStatement.setLong(10, requirement.getRequirementId());

            return preparedStatement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean updateActiveStatus(
            long requirementId,
            boolean active
    ) throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(
                    UPDATE_ACTIVE_STATUS
            )
        ) {
            preparedStatement.setBoolean(1, active);
            preparedStatement.setLong(2, requirementId);

            return preparedStatement.executeUpdate() > 0;
        }
    }

    private void setCommonParameters(
            PreparedStatement preparedStatement,
            ClearanceRequirement requirement
    ) throws SQLException {

        preparedStatement.setLong(1, requirement.getClearanceTypeId());
        preparedStatement.setString(2, requirement.getCategory());
        preparedStatement.setString(3, requirement.getRequirementName());
        preparedStatement.setString(4, requirement.getDescription());
        preparedStatement.setString(5, requirement.getRequirementType());
        preparedStatement.setString(6, requirement.getResponsibleRole());
        preparedStatement.setBoolean(7, requirement.isMandatory());
        preparedStatement.setInt(8, requirement.getDisplayOrder());
        preparedStatement.setBoolean(9, requirement.isActive());
    }

    private ClearanceRequirement mapRequirement(ResultSet resultSet)
            throws SQLException {

        ClearanceRequirement requirement = new ClearanceRequirement();

        requirement.setRequirementId(
                resultSet.getLong("requirement_id")
        );
        requirement.setClearanceTypeId(
                resultSet.getLong("clearance_type_id")
        );
        requirement.setCategory(resultSet.getString("category"));
        requirement.setRequirementName(
                resultSet.getString("requirement_name")
        );
        requirement.setDescription(resultSet.getString("description"));
        requirement.setRequirementType(
                resultSet.getString("requirement_type")
        );
        requirement.setResponsibleRole(
                resultSet.getString("responsible_role")
        );
        requirement.setMandatory(resultSet.getBoolean("mandatory"));
        requirement.setDisplayOrder(resultSet.getInt("display_order"));
        requirement.setActive(resultSet.getBoolean("active"));
        requirement.setCreatedAt(resultSet.getTimestamp("created_at"));
        requirement.setUpdatedAt(resultSet.getTimestamp("updated_at"));
        requirement.setClearanceName(
                resultSet.getString("clearance_name")
        );

        return requirement;
    }
}
