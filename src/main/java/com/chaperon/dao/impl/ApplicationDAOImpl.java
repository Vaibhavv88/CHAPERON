package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.ApplicationDAO;
import com.chaperon.model.Application;
import com.chaperon.util.DBConnection;

public class ApplicationDAOImpl
        implements ApplicationDAO {

    private static final String INSERT_APPLICATION =
            "INSERT INTO applications (" +
            "application_number, " +
            "user_id, " +
            "business_id, " +
            "approval_id, " +
            "department_id, " +
            "assigned_officer_id, " +
            "previous_application_id, " +
            "submission_date, " +
            "current_status, " +
            "sla_days, " +
            "expected_completion_date, " +
            "risk_level, " +
            "officer_remarks, " +
            "rejection_reason, " +
            "can_reapply, " +
            "rejected_by, " +
            "rejected_at" +
            ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String FIND_BY_ID =
            "SELECT * " +
            "FROM applications " +
            "WHERE application_id = ?";

    private static final String FIND_ACTIVE_BY_BUSINESS_AND_APPROVAL =
            "SELECT * " +
            "FROM applications " +
            "WHERE business_id = ? " +
            "AND approval_id = ? " +
            "AND current_status <> 'REJECTED' " +
            "ORDER BY " +
            "CASE " +
            "WHEN current_status = 'APPROVED' THEN 1 " +
            "WHEN current_status = 'QUERY_RAISED' THEN 2 " +
            "WHEN current_status = 'UNDER_REVIEW' THEN 3 " +
            "WHEN current_status = 'SUBMITTED' THEN 4 " +
            "WHEN current_status = 'DRAFT' THEN 5 " +
            "ELSE 6 " +
            "END, " +
            "application_id DESC " +
            "LIMIT 1";
    
    private static final String FIND_BY_USER =
            "SELECT * " +
            "FROM applications " +
            "WHERE user_id = ? " +
            "ORDER BY created_at DESC";

    private static final String FIND_BY_DEPARTMENT =
            "SELECT * " +
            "FROM applications " +
            "WHERE department_id = ? " +
            "AND current_status <> 'DRAFT' " +
            "ORDER BY submission_date DESC, created_at DESC";

    private static final String UPDATE_STATUS =
            "UPDATE applications " +
            "SET current_status = ? " +
            "WHERE application_id = ?";

    private static final String SUBMIT_APPLICATION =
            "UPDATE applications " +
            "SET current_status = 'SUBMITTED', " +
            "submission_date = CURRENT_TIMESTAMP, " +
            "expected_completion_date = " +
            "CASE " +
            "WHEN ? IS NOT NULL " +
            "THEN DATE_ADD(CURDATE(), INTERVAL ? DAY) " +
            "ELSE NULL " +
            "END, " +
            "updated_at = CURRENT_TIMESTAMP " +
            "WHERE application_id = ? " +
            "AND current_status = 'DRAFT'";

    @Override
    public long save(
            Application application
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            INSERT_APPLICATION,
                            Statement.RETURN_GENERATED_KEYS
                    )
        ) {

            statement.setString(
                    1,
                    application.getApplicationNumber()
            );

            statement.setLong(
                    2,
                    application.getUserId()
            );

            statement.setLong(
                    3,
                    application.getBusinessId()
            );

            statement.setLong(
                    4,
                    application.getApprovalId()
            );

            statement.setLong(
                    5,
                    application.getDepartmentId()
            );

            if (application.getAssignedOfficerId()
                    != null) {

                statement.setLong(
                        6,
                        application.getAssignedOfficerId()
                );

            } else {

                statement.setNull(
                        6,
                        java.sql.Types.BIGINT
                );
            }

            if (application.getPreviousApplicationId()
                    != null) {

                statement.setLong(
                        7,
                        application.getPreviousApplicationId()
                );

            } else {

                statement.setNull(
                        7,
                        java.sql.Types.BIGINT
                );
            }

            if (application.getSubmissionDate()
                    != null) {

                statement.setTimestamp(
                        8,
                        application.getSubmissionDate()
                );

            } else {

                statement.setNull(
                        8,
                        java.sql.Types.TIMESTAMP
                );
            }

            statement.setString(
                    9,
                    application.getCurrentStatus()
            );

            if (application.getSlaDays()
                    != null) {

                statement.setInt(
                        10,
                        application.getSlaDays()
                );

            } else {

                statement.setNull(
                        10,
                        java.sql.Types.INTEGER
                );
            }

            if (application.getExpectedCompletionDate()
                    != null) {

                statement.setDate(
                        11,
                        application.getExpectedCompletionDate()
                );

            } else {

                statement.setNull(
                        11,
                        java.sql.Types.DATE
                );
            }

            statement.setString(
                    12,
                    application.getRiskLevel()
            );

            statement.setString(
                    13,
                    application.getOfficerRemarks()
            );

            statement.setString(
                    14,
                    application.getRejectionReason()
            );

            statement.setBoolean(
                    15,
                    application.isCanReapply()
            );

            if (application.getRejectedBy()
                    != null) {

                statement.setLong(
                        16,
                        application.getRejectedBy()
                );

            } else {

                statement.setNull(
                        16,
                        java.sql.Types.BIGINT
                );
            }

            if (application.getRejectedAt()
                    != null) {

                statement.setTimestamp(
                        17,
                        application.getRejectedAt()
                );

            } else {

                statement.setNull(
                        17,
                        java.sql.Types.TIMESTAMP
                );
            }

            statement.executeUpdate();

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
    public Application findById(
            long applicationId
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            FIND_BY_ID
                    )
        ) {

            statement.setLong(
                    1,
                    applicationId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return mapApplication(
                            resultSet
                    );
                }
            }
        }

        return null;
    }

    @Override
    public Application findActiveByBusinessAndApproval(
            long businessId,
            long approvalId
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            FIND_ACTIVE_BY_BUSINESS_AND_APPROVAL
                    )
        ) {

            statement.setLong(
                    1,
                    businessId
            );

            statement.setLong(
                    2,
                    approvalId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return mapApplication(
                            resultSet
                    );
                }
            }
        }

        return null;
    }

    @Override
    public List<Application> findByUserId(
            long userId
    ) throws SQLException {

        List<Application> applications =
                new ArrayList<>();

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            FIND_BY_USER
                    )
        ) {

            statement.setLong(
                    1,
                    userId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    applications.add(
                            mapApplication(
                                    resultSet
                            )
                    );
                }
            }
        }

        return applications;
    }

    @Override
    public List<Application> findByDepartmentId(
            long departmentId
    ) throws SQLException {

        List<Application> applications =
                new ArrayList<>();

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            FIND_BY_DEPARTMENT
                    )
        ) {

            statement.setLong(
                    1,
                    departmentId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    applications.add(
                            mapApplication(
                                    resultSet
                            )
                    );
                }
            }
        }

        return applications;
    }

    @Override
    public void updateStatus(
            long applicationId,
            String newStatus
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            UPDATE_STATUS
                    )
        ) {

            statement.setString(
                    1,
                    newStatus
            );

            statement.setLong(
                    2,
                    applicationId
            );

            statement.executeUpdate();
        }
    }

    @Override
    public void submitApplication(
            long applicationId,
            Integer slaDays
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            SUBMIT_APPLICATION
                    )
        ) {

            if (slaDays != null) {

                statement.setInt(
                        1,
                        slaDays
                );

                statement.setInt(
                        2,
                        slaDays
                );

            } else {

                statement.setNull(
                        1,
                        java.sql.Types.INTEGER
                );

                statement.setNull(
                        2,
                        java.sql.Types.INTEGER
                );
            }

            statement.setLong(
                    3,
                    applicationId
            );

            statement.executeUpdate();
        }
    }

    private Application mapApplication(
            ResultSet resultSet
    ) throws SQLException {

        Application application =
                new Application();

        application.setApplicationId(
                resultSet.getLong(
                        "application_id"
                )
        );

        application.setApplicationNumber(
                resultSet.getString(
                        "application_number"
                )
        );

        application.setUserId(
                resultSet.getLong(
                        "user_id"
                )
        );

        application.setBusinessId(
                resultSet.getLong(
                        "business_id"
                )
        );

        application.setApprovalId(
                resultSet.getLong(
                        "approval_id"
                )
        );

        application.setDepartmentId(
                resultSet.getLong(
                        "department_id"
                )
        );

        long assignedOfficerId =
                resultSet.getLong(
                        "assigned_officer_id"
                );

        if (!resultSet.wasNull()) {

            application.setAssignedOfficerId(
                    assignedOfficerId
            );
        }

        long previousApplicationId =
                resultSet.getLong(
                        "previous_application_id"
                );

        if (!resultSet.wasNull()) {

            application.setPreviousApplicationId(
                    previousApplicationId
            );
        }

        application.setSubmissionDate(
                resultSet.getTimestamp(
                        "submission_date"
                )
        );

        application.setCurrentStatus(
                resultSet.getString(
                        "current_status"
                )
        );

        int slaDays =
                resultSet.getInt(
                        "sla_days"
                );

        if (!resultSet.wasNull()) {

            application.setSlaDays(
                    slaDays
            );
        }

        application.setExpectedCompletionDate(
                resultSet.getDate(
                        "expected_completion_date"
                )
        );

        application.setRiskLevel(
                resultSet.getString(
                        "risk_level"
                )
        );

        application.setOfficerRemarks(
                resultSet.getString(
                        "officer_remarks"
                )
        );

        application.setRejectionReason(
                resultSet.getString(
                        "rejection_reason"
                )
        );

        application.setCanReapply(
                resultSet.getBoolean(
                        "can_reapply"
                )
        );

        long rejectedBy =
                resultSet.getLong(
                        "rejected_by"
                );

        if (!resultSet.wasNull()) {

            application.setRejectedBy(
                    rejectedBy
            );
        }

        application.setRejectedAt(
                resultSet.getTimestamp(
                        "rejected_at"
                )
        );

        application.setCreatedAt(
                resultSet.getTimestamp(
                        "created_at"
                )
        );

        application.setUpdatedAt(
                resultSet.getTimestamp(
                        "updated_at"
                )
        );

        return application;
    }
}