package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.BusinessApprovalDAO;
import com.chaperon.model.BusinessApproval;
import com.chaperon.util.DBConnection;

public class BusinessApprovalDAOImpl
        implements BusinessApprovalDAO {

    private static final String INSERT_BUSINESS_APPROVAL =
            "INSERT INTO business_approvals " +
            "(business_id, approval_id, requirement_status, " +
            "priority_level, reason_text, current_status, " +
            "mandatory, generated_at, updated_at) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, " +
            "CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";

    private static final String FIND_BY_BUSINESS_ID =
            "SELECT ba.*, " +
            "a.approval_name, " +
            "a.approval_code " +
            "FROM business_approvals ba " +
            "JOIN approvals a " +
            "ON ba.approval_id = a.approval_id " +
            "WHERE ba.business_id = ? " +
            "ORDER BY ba.business_approval_id";

    private static final String FIND_BY_BUSINESS_AND_APPROVAL =
            "SELECT ba.*, " +
            "a.approval_name, " +
            "a.approval_code " +
            "FROM business_approvals ba " +
            "JOIN approvals a " +
            "ON ba.approval_id = a.approval_id " +
            "WHERE ba.business_id = ? " +
            "AND ba.approval_id = ? " +
            "LIMIT 1";

    private static final String CHECK_EXISTS =
            "SELECT business_approval_id " +
            "FROM business_approvals " +
            "WHERE business_id = ? " +
            "AND approval_id = ? " +
            "LIMIT 1";

    private static final String DELETE_BY_BUSINESS_ID =
            "DELETE FROM business_approvals " +
            "WHERE business_id = ?";

    /*
     * IMPORTANT:
     * Only recommendations that were never started
     * are regenerated when business profile changes.
     *
     * Existing application history is preserved.
     */
    private static final String DELETE_NOT_STARTED_BY_BUSINESS_ID =
            "DELETE FROM business_approvals " +
            "WHERE business_id = ? " +
            "AND (current_status IS NULL " +
            "OR UPPER(current_status) = 'NOT_STARTED')";

    @Override
    public boolean saveBusinessApproval(
            BusinessApproval businessApproval
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            INSERT_BUSINESS_APPROVAL
                    )
        ) {

            preparedStatement.setLong(
                    1,
                    businessApproval.getBusinessId()
            );

            preparedStatement.setLong(
                    2,
                    businessApproval.getApprovalId()
            );

            preparedStatement.setString(
                    3,
                    businessApproval.getRequirementStatus()
            );

            preparedStatement.setString(
                    4,
                    businessApproval.getPriorityLevel()
            );

            preparedStatement.setString(
                    5,
                    businessApproval.getReasonText()
            );

            preparedStatement.setString(
                    6,
                    businessApproval.getCurrentStatus()
            );

            preparedStatement.setBoolean(
                    7,
                    businessApproval.isMandatory()
            );

            int rows =
                    preparedStatement.executeUpdate();

            return rows > 0;
        }
    }

    @Override
    public List<BusinessApproval> findByBusinessId(
            long businessId
    ) throws SQLException {

        List<BusinessApproval> businessApprovals =
                new ArrayList<>();

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            FIND_BY_BUSINESS_ID
                    )
        ) {

            preparedStatement.setLong(
                    1,
                    businessId
            );

            try (
                ResultSet resultSet =
                        preparedStatement.executeQuery()
            ) {

                while (resultSet.next()) {

                    BusinessApproval businessApproval =
                            mapBusinessApproval(
                                    resultSet
                            );

                    businessApprovals.add(
                            businessApproval
                    );
                }
            }
        }

        return businessApprovals;
    }

    @Override
    public BusinessApproval findByBusinessAndApproval(
            long businessId,
            long approvalId
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            FIND_BY_BUSINESS_AND_APPROVAL
                    )
        ) {

            preparedStatement.setLong(
                    1,
                    businessId
            );

            preparedStatement.setLong(
                    2,
                    approvalId
            );

            try (
                ResultSet resultSet =
                        preparedStatement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return mapBusinessApproval(
                            resultSet
                    );
                }
            }
        }

        return null;
    }

    @Override
    public boolean exists(
            long businessId,
            long approvalId
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            CHECK_EXISTS
                    )
        ) {

            preparedStatement.setLong(
                    1,
                    businessId
            );

            preparedStatement.setLong(
                    2,
                    approvalId
            );

            try (
                ResultSet resultSet =
                        preparedStatement.executeQuery()
            ) {

                return resultSet.next();
            }
        }
    }

    @Override
    public boolean deleteByBusinessId(
            long businessId
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            DELETE_BY_BUSINESS_ID
                    )
        ) {

            preparedStatement.setLong(
                    1,
                    businessId
            );

            preparedStatement.executeUpdate();

            return true;
        }
    }

    @Override
    public boolean deleteNotStartedByBusinessId(
            long businessId
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            DELETE_NOT_STARTED_BY_BUSINESS_ID
                    )
        ) {

            preparedStatement.setLong(
                    1,
                    businessId
            );

            preparedStatement.executeUpdate();

            return true;
        }
    }

    private BusinessApproval mapBusinessApproval(
            ResultSet resultSet
    ) throws SQLException {

        BusinessApproval businessApproval =
                new BusinessApproval();

        businessApproval.setBusinessApprovalId(
                resultSet.getLong(
                        "business_approval_id"
                )
        );

        businessApproval.setBusinessId(
                resultSet.getLong(
                        "business_id"
                )
        );

        businessApproval.setApprovalName(
                resultSet.getString(
                        "approval_name"
                )
        );

        businessApproval.setApprovalCode(
                resultSet.getString(
                        "approval_code"
                )
        );

        businessApproval.setApprovalId(
                resultSet.getLong(
                        "approval_id"
                )
        );

        businessApproval.setRequirementStatus(
                resultSet.getString(
                        "requirement_status"
                )
        );

        businessApproval.setPriorityLevel(
                resultSet.getString(
                        "priority_level"
                )
        );

        businessApproval.setReasonText(
                resultSet.getString(
                        "reason_text"
                )
        );

        businessApproval.setCurrentStatus(
                resultSet.getString(
                        "current_status"
                )
        );

        businessApproval.setMandatory(
                resultSet.getBoolean(
                        "mandatory"
                )
        );

        businessApproval.setGeneratedAt(
                resultSet.getTimestamp(
                        "generated_at"
                )
        );

        businessApproval.setUpdatedAt(
                resultSet.getTimestamp(
                        "updated_at"
                )
        );

        return businessApproval;
    }
}