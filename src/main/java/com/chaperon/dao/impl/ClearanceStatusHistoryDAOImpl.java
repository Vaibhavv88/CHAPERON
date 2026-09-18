package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.ClearanceStatusHistoryDAO;
import com.chaperon.model.ClearanceStatusHistory;
import com.chaperon.util.DBConnection;

public class ClearanceStatusHistoryDAOImpl
        implements ClearanceStatusHistoryDAO {

    private static final String INSERT_HISTORY =
            "INSERT INTO clearance_application_status_history " +
            "(clearance_application_id, old_status, new_status, " +
            "changed_by_user_id, changed_by_role, remarks, changed_at) " +
            "VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

    private static final String BASE_SELECT =
            "SELECT cash.*, u.full_name AS changed_by_name " +
            "FROM clearance_application_status_history cash " +
            "LEFT JOIN users u ON u.user_id = cash.changed_by_user_id ";

    private static final String FIND_BY_APPLICATION =
            BASE_SELECT +
            "WHERE cash.clearance_application_id = ? " +
            "ORDER BY cash.changed_at, cash.history_id";

    private static final String FIND_LATEST_BY_APPLICATION =
            BASE_SELECT +
            "WHERE cash.clearance_application_id = ? " +
            "ORDER BY cash.changed_at DESC, cash.history_id DESC " +
            "LIMIT 1";

    @Override
    public long createHistory(ClearanceStatusHistory history)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(
                    INSERT_HISTORY,
                    Statement.RETURN_GENERATED_KEYS
            )
        ) {
            preparedStatement.setLong(
                    1,
                    history.getClearanceApplicationId()
            );

            if (history.getOldStatus() == null) {
                preparedStatement.setNull(2, Types.VARCHAR);
            }
            else {
                preparedStatement.setString(2, history.getOldStatus());
            }

            preparedStatement.setString(3, history.getNewStatus());

            if (history.getChangedByUserId() == null) {
                preparedStatement.setNull(4, Types.BIGINT);
            }
            else {
                preparedStatement.setLong(4, history.getChangedByUserId());
            }

            preparedStatement.setString(5, history.getChangedByRole());
            preparedStatement.setString(6, history.getRemarks());

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
    public List<ClearanceStatusHistory> findByApplicationId(
            long clearanceApplicationId
    ) throws SQLException {

        List<ClearanceStatusHistory> historyList = new ArrayList<>();

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(
                    FIND_BY_APPLICATION
            )
        ) {
            preparedStatement.setLong(1, clearanceApplicationId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    historyList.add(mapHistory(resultSet));
                }
            }
        }

        return historyList;
    }

    @Override
    public ClearanceStatusHistory findLatestByApplicationId(
            long clearanceApplicationId
    ) throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(
                    FIND_LATEST_BY_APPLICATION
            )
        ) {
            preparedStatement.setLong(1, clearanceApplicationId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return mapHistory(resultSet);
                }
            }
        }

        return null;
    }

    private ClearanceStatusHistory mapHistory(ResultSet resultSet)
            throws SQLException {

        ClearanceStatusHistory history = new ClearanceStatusHistory();

        history.setHistoryId(resultSet.getLong("history_id"));
        history.setClearanceApplicationId(
                resultSet.getLong("clearance_application_id")
        );
        history.setOldStatus(resultSet.getString("old_status"));
        history.setNewStatus(resultSet.getString("new_status"));

        long changedByUserId = resultSet.getLong("changed_by_user_id");
        history.setChangedByUserId(
                resultSet.wasNull() ? null : changedByUserId
        );

        history.setChangedByRole(resultSet.getString("changed_by_role"));
        history.setRemarks(resultSet.getString("remarks"));
        history.setChangedAt(resultSet.getTimestamp("changed_at"));
        history.setChangedByName(resultSet.getString("changed_by_name"));

        return history;
    }
}
