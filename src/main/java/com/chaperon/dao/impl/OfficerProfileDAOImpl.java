package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.chaperon.dao.OfficerProfileDAO;
import com.chaperon.model.OfficerProfile;
import com.chaperon.util.DBConnection;

public class OfficerProfileDAOImpl
        implements OfficerProfileDAO {

    private static final String FIND_BY_USER_ID =

            "SELECT " +

            "op.officer_profile_id, " +
            "op.user_id, " +
            "op.department_id, " +
            "op.designation, " +
            "op.employee_code, " +
            "op.active, " +
            "op.created_at, " +
            "op.updated_at, " +

            "d.department_name, " +
            "d.department_code " +

            "FROM officer_profiles op " +

            "JOIN departments d " +
            "ON op.department_id = d.department_id " +

            "WHERE op.user_id = ? " +

            "LIMIT 1";

    @Override
    public OfficerProfile findByUserId(
            long userId
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            FIND_BY_USER_ID
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

                if (resultSet.next()) {

                    return mapOfficerProfile(
                            resultSet
                    );
                }
            }
        }

        return null;
    }

    private OfficerProfile mapOfficerProfile(
            ResultSet resultSet
    ) throws SQLException {

        OfficerProfile profile =
                new OfficerProfile();

        profile.setOfficerProfileId(
                resultSet.getLong(
                        "officer_profile_id"
                )
        );

        profile.setUserId(
                resultSet.getLong(
                        "user_id"
                )
        );

        profile.setDepartmentId(
                resultSet.getLong(
                        "department_id"
                )
        );

        profile.setDepartmentName(
                resultSet.getString(
                        "department_name"
                )
        );

        profile.setDepartmentCode(
                resultSet.getString(
                        "department_code"
                )
        );

        profile.setDesignation(
                resultSet.getString(
                        "designation"
                )
        );

        profile.setEmployeeCode(
                resultSet.getString(
                        "employee_code"
                )
        );

        profile.setActive(
                resultSet.getBoolean(
                        "active"
                )
        );

        profile.setCreatedAt(
                resultSet.getTimestamp(
                        "created_at"
                )
        );

        profile.setUpdatedAt(
                resultSet.getTimestamp(
                        "updated_at"
                )
        );

        return profile;
    }
}