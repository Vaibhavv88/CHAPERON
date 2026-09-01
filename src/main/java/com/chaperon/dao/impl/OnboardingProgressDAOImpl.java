package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.chaperon.dao.OnboardingProgressDAO;
import com.chaperon.util.DBConnection;

public class OnboardingProgressDAOImpl
        implements OnboardingProgressDAO {

    private static final String UPSERT_PROGRESS =
            "INSERT INTO business_onboarding_progress " +
            "(user_id, business_id, current_step, " +
            "completion_percentage, profile_completed) " +
            "VALUES (?, ?, 5, 100, TRUE) " +
            "ON DUPLICATE KEY UPDATE " +
            "business_id = VALUES(business_id), " +
            "current_step = 5, " +
            "completion_percentage = 100, " +
            "profile_completed = TRUE";

    private static final String UPDATE_USER_PROFILE =
            "UPDATE users " +
            "SET profile_completed = TRUE " +
            "WHERE user_id = ?";

    @Override
    public boolean markCompleted(
            long userId,
            long businessId
    ) throws SQLException {

        Connection connection = null;

        try {

            connection = DBConnection.getConnection();

            connection.setAutoCommit(false);

            try (
                PreparedStatement progressStatement =
                        connection.prepareStatement(
                                UPSERT_PROGRESS
                        );

                PreparedStatement userStatement =
                        connection.prepareStatement(
                                UPDATE_USER_PROFILE
                        )
            ) {

                progressStatement.setLong(
                        1,
                        userId
                );

                progressStatement.setLong(
                        2,
                        businessId
                );

                int progressRows =
                        progressStatement.executeUpdate();

                userStatement.setLong(
                        1,
                        userId
                );

                int userRows =
                        userStatement.executeUpdate();

                if (progressRows > 0 &&
                    userRows > 0) {

                    connection.commit();

                    return true;
                }

                connection.rollback();

                return false;
            }

        } catch (SQLException e) {

            if (connection != null) {

                try {
                    connection.rollback();
                }
                catch (SQLException ignored) {
                }
            }

            throw e;

        } finally {

            if (connection != null) {

                try {
                    connection.setAutoCommit(true);
                    connection.close();
                }
                catch (SQLException ignored) {
                }
            }
        }
    }
}