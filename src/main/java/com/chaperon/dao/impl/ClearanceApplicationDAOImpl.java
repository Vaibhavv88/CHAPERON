package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.ClearanceApplicationDAO;
import com.chaperon.model.ClearanceApplication;
import com.chaperon.util.DBConnection;

public class ClearanceApplicationDAOImpl
        implements ClearanceApplicationDAO {

    private static final String BASE_SELECT =
            "SELECT ca.*, ct.clearance_name, " +
            "applicant.full_name AS applicant_name, " +
            "b.business_name, " +
            "officer.full_name AS assigned_officer_name " +
            "FROM clearance_applications ca " +
            "JOIN clearance_types ct " +
            "ON ct.clearance_type_id = ca.clearance_type_id " +
            "JOIN users applicant ON applicant.user_id = ca.user_id " +
            "JOIN businesses b ON b.business_id = ca.business_id " +
            "LEFT JOIN users officer " +
            "ON officer.user_id = ca.assigned_officer_id ";

    private static final String INSERT_APPLICATION =
            "INSERT INTO clearance_applications " +
            "(application_number, clearance_type_id, user_id, business_id, " +
            "assigned_officer_id, project_title, project_description, " +
            "state, district, location_address, latitude, longitude, " +
            "project_area_hectares, current_status, submission_date, " +
            "expected_completion_date, applicant_declaration, " +
            "officer_remarks, rejection_reason) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String UPDATE_APPLICATION =
            "UPDATE clearance_applications SET " +
            "clearance_type_id = ?, business_id = ?, project_title = ?, " +
            "project_description = ?, state = ?, district = ?, " +
            "location_address = ?, latitude = ?, longitude = ?, " +
            "project_area_hectares = ?, applicant_declaration = ? " +
            "WHERE clearance_application_id = ? " +
            "AND user_id = ? AND current_status = 'DRAFT'";

    private static final String FIND_BY_ID =
            BASE_SELECT + "WHERE ca.clearance_application_id = ?";

    private static final String FIND_BY_NUMBER =
            BASE_SELECT + "WHERE ca.application_number = ?";

    private static final String FIND_BY_USER =
            BASE_SELECT +
            "WHERE ca.user_id = ? " +
            "ORDER BY ca.created_at DESC";

    private static final String FIND_BY_OFFICER =
            BASE_SELECT +
            "WHERE ca.assigned_officer_id = ? " +
            "ORDER BY ca.updated_at DESC";

    private static final String FIND_BY_STATUS =
            BASE_SELECT +
            "WHERE ca.current_status = ? " +
            "ORDER BY ca.updated_at DESC";

    private static final String FIND_ALL =
            BASE_SELECT + "ORDER BY ca.created_at DESC";

    private static final String SUBMIT_APPLICATION =
            "UPDATE clearance_applications SET " +
            "application_number = ?, current_status = 'SUBMITTED', " +
            "submission_date = CURRENT_TIMESTAMP " +
            "WHERE clearance_application_id = ? " +
            "AND current_status = 'DRAFT' " +
            "AND applicant_declaration = TRUE";

    private static final String ASSIGN_OFFICER =
            "UPDATE clearance_applications SET assigned_officer_id = ? " +
            "WHERE clearance_application_id = ?";

    private static final String UPDATE_STATUS =
            "UPDATE clearance_applications SET current_status = ?, " +
            "officer_remarks = ?, rejection_reason = ? " +
            "WHERE clearance_application_id = ?";

    private static final String BELONGS_TO_USER =
            "SELECT 1 FROM clearance_applications " +
            "WHERE clearance_application_id = ? AND user_id = ?";

    @Override
    public long createApplication(ClearanceApplication application)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(
                    INSERT_APPLICATION,
                    Statement.RETURN_GENERATED_KEYS
            )
        ) {
            setInsertParameters(preparedStatement, application);

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
    public boolean updateApplication(ClearanceApplication application)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(
                    UPDATE_APPLICATION
            )
        ) {
            preparedStatement.setLong(1, application.getClearanceTypeId());
            preparedStatement.setLong(2, application.getBusinessId());
            preparedStatement.setString(3, application.getProjectTitle());
            preparedStatement.setString(4, application.getProjectDescription());
            preparedStatement.setString(5, application.getState());
            preparedStatement.setString(6, application.getDistrict());
            preparedStatement.setString(7, application.getLocationAddress());
            preparedStatement.setBigDecimal(8, application.getLatitude());
            preparedStatement.setBigDecimal(9, application.getLongitude());
            preparedStatement.setBigDecimal(
                    10,
                    application.getProjectAreaHectares()
            );
            preparedStatement.setBoolean(
                    11,
                    application.isApplicantDeclaration()
            );
            preparedStatement.setLong(
                    12,
                    application.getClearanceApplicationId()
            );
            preparedStatement.setLong(13, application.getUserId());

            return preparedStatement.executeUpdate() > 0;
        }
    }

    @Override
    public ClearanceApplication findById(long clearanceApplicationId)
            throws SQLException {

        return findOneByLong(FIND_BY_ID, clearanceApplicationId);
    }

    @Override
    public ClearanceApplication findByApplicationNumber(
            String applicationNumber
    ) throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(FIND_BY_NUMBER)
        ) {
            preparedStatement.setString(1, applicationNumber);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return mapApplication(resultSet);
                }
            }
        }

        return null;
    }

    @Override
    public List<ClearanceApplication> findByUserId(long userId)
            throws SQLException {

        return findListByLong(FIND_BY_USER, userId);
    }

    @Override
    public List<ClearanceApplication> findByAssignedOfficerId(
            long officerUserId
    ) throws SQLException {

        return findListByLong(FIND_BY_OFFICER, officerUserId);
    }

    @Override
    public List<ClearanceApplication> findByStatus(String currentStatus)
            throws SQLException {

        List<ClearanceApplication> applications = new ArrayList<>();

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(FIND_BY_STATUS)
        ) {
            preparedStatement.setString(1, currentStatus);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    applications.add(mapApplication(resultSet));
                }
            }
        }

        return applications;
    }

    @Override
    public List<ClearanceApplication> findAll()
            throws SQLException {

        List<ClearanceApplication> applications = new ArrayList<>();

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(FIND_ALL);
            ResultSet resultSet = preparedStatement.executeQuery()
        ) {
            while (resultSet.next()) {
                applications.add(mapApplication(resultSet));
            }
        }

        return applications;
    }

    @Override
    public boolean submitApplication(
            long clearanceApplicationId,
            String applicationNumber
    ) throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(
                    SUBMIT_APPLICATION
            )
        ) {
            preparedStatement.setString(1, applicationNumber);
            preparedStatement.setLong(2, clearanceApplicationId);

            return preparedStatement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean assignOfficer(
            long clearanceApplicationId,
            long officerUserId
    ) throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(ASSIGN_OFFICER)
        ) {
            preparedStatement.setLong(1, officerUserId);
            preparedStatement.setLong(2, clearanceApplicationId);

            return preparedStatement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean updateStatus(
            long clearanceApplicationId,
            String currentStatus,
            String officerRemarks,
            String rejectionReason
    ) throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(UPDATE_STATUS)
        ) {
            preparedStatement.setString(1, currentStatus);
            preparedStatement.setString(2, officerRemarks);
            preparedStatement.setString(3, rejectionReason);
            preparedStatement.setLong(4, clearanceApplicationId);

            return preparedStatement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean belongsToUser(
            long clearanceApplicationId,
            long userId
    ) throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(BELONGS_TO_USER)
        ) {
            preparedStatement.setLong(1, clearanceApplicationId);
            preparedStatement.setLong(2, userId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                return resultSet.next();
            }
        }
    }

    private ClearanceApplication findOneByLong(String sql, long value)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(sql)
        ) {
            preparedStatement.setLong(1, value);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return mapApplication(resultSet);
                }
            }
        }

        return null;
    }

    private List<ClearanceApplication> findListByLong(
            String sql,
            long value
    ) throws SQLException {

        List<ClearanceApplication> applications = new ArrayList<>();

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(sql)
        ) {
            preparedStatement.setLong(1, value);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    applications.add(mapApplication(resultSet));
                }
            }
        }

        return applications;
    }

    private void setInsertParameters(
            PreparedStatement preparedStatement,
            ClearanceApplication application
    ) throws SQLException {

        preparedStatement.setString(1, application.getApplicationNumber());
        preparedStatement.setLong(2, application.getClearanceTypeId());
        preparedStatement.setLong(3, application.getUserId());
        preparedStatement.setLong(4, application.getBusinessId());

        if (application.getAssignedOfficerId() == null) {
            preparedStatement.setNull(5, Types.BIGINT);
        }
        else {
            preparedStatement.setLong(5, application.getAssignedOfficerId());
        }

        preparedStatement.setString(6, application.getProjectTitle());
        preparedStatement.setString(7, application.getProjectDescription());
        preparedStatement.setString(8, application.getState());
        preparedStatement.setString(9, application.getDistrict());
        preparedStatement.setString(10, application.getLocationAddress());
        preparedStatement.setBigDecimal(11, application.getLatitude());
        preparedStatement.setBigDecimal(12, application.getLongitude());
        preparedStatement.setBigDecimal(
                13,
                application.getProjectAreaHectares()
        );
        String currentStatus = application.getCurrentStatus();
        if (currentStatus == null || currentStatus.isBlank()) {
            currentStatus = "DRAFT";
        }
        preparedStatement.setString(14, currentStatus);
        preparedStatement.setTimestamp(15, application.getSubmissionDate());
        preparedStatement.setDate(16, application.getExpectedCompletionDate());
        preparedStatement.setBoolean(
                17,
                application.isApplicantDeclaration()
        );
        preparedStatement.setString(18, application.getOfficerRemarks());
        preparedStatement.setString(19, application.getRejectionReason());
    }

    private ClearanceApplication mapApplication(ResultSet resultSet)
            throws SQLException {

        ClearanceApplication application = new ClearanceApplication();

        application.setClearanceApplicationId(
                resultSet.getLong("clearance_application_id")
        );
        application.setApplicationNumber(
                resultSet.getString("application_number")
        );
        application.setClearanceTypeId(
                resultSet.getLong("clearance_type_id")
        );
        application.setUserId(resultSet.getLong("user_id"));
        application.setBusinessId(resultSet.getLong("business_id"));

        long officerId = resultSet.getLong("assigned_officer_id");
        application.setAssignedOfficerId(
                resultSet.wasNull() ? null : officerId
        );

        application.setProjectTitle(resultSet.getString("project_title"));
        application.setProjectDescription(
                resultSet.getString("project_description")
        );
        application.setState(resultSet.getString("state"));
        application.setDistrict(resultSet.getString("district"));
        application.setLocationAddress(
                resultSet.getString("location_address")
        );
        application.setLatitude(resultSet.getBigDecimal("latitude"));
        application.setLongitude(resultSet.getBigDecimal("longitude"));
        application.setProjectAreaHectares(
                resultSet.getBigDecimal("project_area_hectares")
        );
        application.setCurrentStatus(
                resultSet.getString("current_status")
        );
        application.setSubmissionDate(
                resultSet.getTimestamp("submission_date")
        );
        application.setExpectedCompletionDate(
                resultSet.getDate("expected_completion_date")
        );
        application.setApplicantDeclaration(
                resultSet.getBoolean("applicant_declaration")
        );
        application.setOfficerRemarks(
                resultSet.getString("officer_remarks")
        );
        application.setRejectionReason(
                resultSet.getString("rejection_reason")
        );
        application.setCreatedAt(resultSet.getTimestamp("created_at"));
        application.setUpdatedAt(resultSet.getTimestamp("updated_at"));

        application.setClearanceName(
                resultSet.getString("clearance_name")
        );
        application.setApplicantName(
                resultSet.getString("applicant_name")
        );
        application.setBusinessName(resultSet.getString("business_name"));
        application.setAssignedOfficerName(
                resultSet.getString("assigned_officer_name")
        );

        return application;
    }
}
