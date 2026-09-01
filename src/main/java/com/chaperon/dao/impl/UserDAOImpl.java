package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import com.chaperon.dao.UserDAO;
import com.chaperon.model.User;
import com.chaperon.util.DBConnection;

public class UserDAOImpl implements UserDAO {

    private static final String INSERT_USER =
            "INSERT INTO users " +
            "(full_name, email, mobile, password_hash, role) " +
            "VALUES (?, ?, ?, ?, ?)";

    private static final String FIND_BY_EMAIL =
            "SELECT * FROM users WHERE email = ?";

    private static final String EMAIL_EXISTS =
            "SELECT user_id FROM users WHERE email = ?";

    private static final String UPDATE_LAST_LOGIN =
            "UPDATE users SET last_login = CURRENT_TIMESTAMP " +
            "WHERE user_id = ?";

    @Override
    public boolean saveUser(User user) throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(INSERT_USER)
        ) {

            preparedStatement.setString(
                    1,
                    user.getFullName()
            );

            preparedStatement.setString(
                    2,
                    user.getEmail()
            );

            preparedStatement.setString(
                    3,
                    user.getMobile()
            );

            preparedStatement.setString(
                    4,
                    user.getPasswordHash()
            );

            preparedStatement.setString(
                    5,
                    user.getRole()
            );

            int rowsAffected =
                    preparedStatement.executeUpdate();

            return rowsAffected > 0;
        }
    }

    @Override
    public User findByEmail(String email)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(FIND_BY_EMAIL)
        ) {

            preparedStatement.setString(1, email);

            try (
                ResultSet resultSet =
                        preparedStatement.executeQuery()
            ) {

                if (resultSet.next()) {

                    User user = new User();

                    user.setUserId(
                            resultSet.getLong("user_id")
                    );

                    user.setFullName(
                            resultSet.getString("full_name")
                    );

                    user.setEmail(
                            resultSet.getString("email")
                    );

                    user.setMobile(
                            resultSet.getString("mobile")
                    );

                    user.setPasswordHash(
                            resultSet.getString("password_hash")
                    );

                    user.setRole(
                            resultSet.getString("role")
                    );

                    user.setCreatedAt(
                            resultSet.getTimestamp("created_at")
                    );

                    Timestamp lastLogin =
                            resultSet.getTimestamp("last_login");

                    user.setLastLogin(lastLogin);

                    user.setProfileCompleted(
                            resultSet.getBoolean(
                                    "profile_completed"
                            )
                    );

                    user.setAccountStatus(
                            resultSet.getString(
                                    "account_status"
                            )
                    );

                    return user;
                }
            }
        }

        return null;
    }

    @Override
    public boolean emailExists(String email)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(EMAIL_EXISTS)
        ) {

            preparedStatement.setString(1, email);

            try (
                ResultSet resultSet =
                        preparedStatement.executeQuery()
            ) {

                return resultSet.next();
            }
        }
    }

    @Override
    public boolean updateLastLogin(long userId)
            throws SQLException {

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            UPDATE_LAST_LOGIN
                    )
        ) {

            preparedStatement.setLong(
                    1,
                    userId
            );

            int rowsAffected =
                    preparedStatement.executeUpdate();

            return rowsAffected > 0;
        }
    }
}