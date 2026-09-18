package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.ClearanceApplicationRequirementDAO;
import com.chaperon.model.ClearanceApplicationRequirement;
import com.chaperon.util.DBConnection;

public class ClearanceApplicationRequirementDAOImpl
        implements ClearanceApplicationRequirementDAO {

    private static final String INITIALIZE_REQUIREMENTS =
            "INSERT IGNORE INTO clearance_application_requirements " +
            "(clearance_application_id, requirement_id, " +
            "applicable, mandatory, requirement_status) " +
            "SELECT ?, cr.requirement_id, TRUE, cr.mandatory, " +
            "'NOT_PROVIDED' FROM clearance_requirements cr " +
            "WHERE cr.clearance_type_id = ? AND cr.active = TRUE";

    private static final String BASE_SELECT =
            "SELECT car.*, cr.category, cr.requirement_name, " +
            "cr.description AS requirement_description, " +
            "cr.requirement_type, cr.responsible_role, " +
            "d.document_type, d.file_path AS document_file_path " +
            "FROM clearance_application_requirements car " +
            "JOIN clearance_requirements cr " +
            "ON cr.requirement_id = car.requirement_id " +
            "LEFT JOIN documents d ON d.document_id = car.document_id ";

    private static final String FIND_BY_APPLICATION =
            BASE_SELECT +
            "WHERE car.clearance_application_id = ? " +
            "ORDER BY cr.display_order, car.application_requirement_id";

    private static final String FIND_BY_ID =
            BASE_SELECT +
            "WHERE car.application_requirement_id = ?";

    private static final String ATTACH_DOCUMENT =
            "UPDATE clearance_application_requirements SET " +
            "document_id = ?, uploaded_by_user_id = ?, " +
            "applicant_remarks = ?, requirement_status = 'UPLOADED', " +
            "uploaded_at = CURRENT_TIMESTAMP, verified_by_user_id = NULL, " +
            "verified_at = NULL, officer_remarks = NULL " +
            "WHERE application_requirement_id = ? AND applicable = TRUE";

    private static final String UPDATE_VERIFICATION =
            "UPDATE clearance_application_requirements SET " +
            "requirement_status = ?, verified_by_user_id = ?, " +
            "officer_remarks = ?, verified_at = CURRENT_TIMESTAMP " +
            "WHERE application_requirement_id = ? " +
            "AND document_id IS NOT NULL AND applicable = TRUE";

    private static final String UPDATE_APPLICABILITY =
            "UPDATE clearance_application_requirements SET " +
            "applicable = ?, mandatory = ?, " +
            "requirement_status = CASE " +
            "WHEN ? = FALSE THEN 'WAIVED' " +
            "WHEN document_id IS NULL THEN 'NOT_PROVIDED' " +
            "ELSE 'UPLOADED' END " +
            "WHERE application_requirement_id = ?";

    private static final String COUNT_MANDATORY_APPLICABLE =
            "SELECT COUNT(*) FROM clearance_application_requirements " +
            "WHERE clearance_application_id = ? " +
            "AND applicable = TRUE AND mandatory = TRUE";

    private static final String COUNT_PROVIDED_MANDATORY =
            "SELECT COUNT(*) FROM clearance_application_requirements " +
            "WHERE clearance_application_id = ? " +
            "AND applicable = TRUE AND mandatory = TRUE " +
            "AND requirement_status IN " +
            "('UPLOADED', 'UNDER_VERIFICATION', 'VERIFIED')";

    @Override
    public int initializeRequirements(
            long clearanceApplicationId,
            long clearanceTypeId
    ) throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(
                    INITIALIZE_REQUIREMENTS
            )
        ) {
            preparedStatement.setLong(1, clearanceApplicationId);
            preparedStatement.setLong(2, clearanceTypeId);

            return preparedStatement.executeUpdate();
        }
    }

    @Override
    public List<ClearanceApplicationRequirement> findByApplicationId(
            long clearanceApplicationId
    ) throws SQLException {

        List<ClearanceApplicationRequirement> requirements =
                new ArrayList<>();

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(
                    FIND_BY_APPLICATION
            )
        ) {
            preparedStatement.setLong(1, clearanceApplicationId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    requirements.add(mapRequirement(resultSet));
                }
            }
        }

        return requirements;
    }

    @Override
    public ClearanceApplicationRequirement findById(
            long applicationRequirementId
    ) throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(FIND_BY_ID)
        ) {
            preparedStatement.setLong(1, applicationRequirementId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return mapRequirement(resultSet);
                }
            }
        }

        return null;
    }

    @Override
    public boolean attachDocument(
            long applicationRequirementId,
            long documentId,
            long uploadedByUserId,
            String applicantRemarks
    ) throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(ATTACH_DOCUMENT)
        ) {
            preparedStatement.setLong(1, documentId);
            preparedStatement.setLong(2, uploadedByUserId);
            preparedStatement.setString(3, applicantRemarks);
            preparedStatement.setLong(4, applicationRequirementId);

            return preparedStatement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean updateVerification(
            long applicationRequirementId,
            String requirementStatus,
            long verifiedByUserId,
            String officerRemarks
    ) throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(UPDATE_VERIFICATION)
        ) {
            preparedStatement.setString(1, requirementStatus);
            preparedStatement.setLong(2, verifiedByUserId);
            preparedStatement.setString(3, officerRemarks);
            preparedStatement.setLong(4, applicationRequirementId);

            return preparedStatement.executeUpdate() > 0;
        }
    }

    @Override
    public boolean updateApplicability(
            long applicationRequirementId,
            boolean applicable,
            boolean mandatory
    ) throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(UPDATE_APPLICABILITY)
        ) {
            preparedStatement.setBoolean(1, applicable);
            preparedStatement.setBoolean(2, mandatory);
            preparedStatement.setBoolean(3, applicable);
            preparedStatement.setLong(4, applicationRequirementId);

            return preparedStatement.executeUpdate() > 0;
        }
    }

    @Override
    public int countMandatoryApplicable(long clearanceApplicationId)
            throws SQLException {

        return executeCount(COUNT_MANDATORY_APPLICABLE, clearanceApplicationId);
    }

    @Override
    public int countProvidedMandatory(long clearanceApplicationId)
            throws SQLException {

        return executeCount(COUNT_PROVIDED_MANDATORY, clearanceApplicationId);
    }

    private int executeCount(String sql, long clearanceApplicationId)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(sql)
        ) {
            preparedStatement.setLong(1, clearanceApplicationId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                return resultSet.next() ? resultSet.getInt(1) : 0;
            }
        }
    }

    private ClearanceApplicationRequirement mapRequirement(
            ResultSet resultSet
    ) throws SQLException {

        ClearanceApplicationRequirement requirement =
                new ClearanceApplicationRequirement();

        requirement.setApplicationRequirementId(
                resultSet.getLong("application_requirement_id")
        );
        requirement.setClearanceApplicationId(
                resultSet.getLong("clearance_application_id")
        );
        requirement.setRequirementId(resultSet.getLong("requirement_id"));
        requirement.setDocumentId(getNullableLong(resultSet, "document_id"));
        requirement.setUploadedByUserId(
                getNullableLong(resultSet, "uploaded_by_user_id")
        );
        requirement.setVerifiedByUserId(
                getNullableLong(resultSet, "verified_by_user_id")
        );
        requirement.setApplicable(resultSet.getBoolean("applicable"));
        requirement.setMandatory(resultSet.getBoolean("mandatory"));
        requirement.setRequirementStatus(
                resultSet.getString("requirement_status")
        );
        requirement.setApplicantRemarks(
                resultSet.getString("applicant_remarks")
        );
        requirement.setOfficerRemarks(
                resultSet.getString("officer_remarks")
        );
        requirement.setUploadedAt(resultSet.getTimestamp("uploaded_at"));
        requirement.setVerifiedAt(resultSet.getTimestamp("verified_at"));
        requirement.setCreatedAt(resultSet.getTimestamp("created_at"));
        requirement.setUpdatedAt(resultSet.getTimestamp("updated_at"));

        requirement.setCategory(resultSet.getString("category"));
        requirement.setRequirementName(
                resultSet.getString("requirement_name")
        );
        requirement.setRequirementDescription(
                resultSet.getString("requirement_description")
        );
        requirement.setRequirementType(
                resultSet.getString("requirement_type")
        );
        requirement.setResponsibleRole(
                resultSet.getString("responsible_role")
        );
        requirement.setDocumentType(resultSet.getString("document_type"));
        requirement.setDocumentFilePath(
                resultSet.getString("document_file_path")
        );

        return requirement;
    }

    private Long getNullableLong(ResultSet resultSet, String columnName)
            throws SQLException {

        long value = resultSet.getLong(columnName);
        return resultSet.wasNull() ? null : value;
    }
}
