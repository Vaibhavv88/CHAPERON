package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.ApprovalDependencyDAO;
import com.chaperon.model.ApprovalDependency;
import com.chaperon.util.DBConnection;

public class ApprovalDependencyDAOImpl
        implements ApprovalDependencyDAO {


    /*
     * ============================================================
     * FIND ALL ACTIVE DEPENDENCIES
     * ============================================================
     */
    @Override
    public List<ApprovalDependency> findAllActive()
            throws SQLException {

        List<ApprovalDependency> dependencies =
                new ArrayList<>();

        String sql = """
                SELECT
                    ad.dependency_id,
                    ad.approval_id,
                    ad.depends_on_approval_id,
                    ad.dependency_type,
                    ad.condition_description,
                    ad.active,
                    ad.created_at,
                    ad.updated_at,

                    a1.approval_name AS approval_name,
                    a1.approval_code AS approval_code,

                    a2.approval_name AS depends_on_approval_name,
                    a2.approval_code AS depends_on_approval_code

                FROM approval_dependencies ad

                INNER JOIN approvals a1
                    ON ad.approval_id = a1.approval_id

                INNER JOIN approvals a2
                    ON ad.depends_on_approval_id = a2.approval_id

                WHERE ad.active = 1
                  AND a1.active = 1
                  AND a2.active = 1

                ORDER BY
                    ad.approval_id,
                    ad.dependency_id
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                dependencies.add(
                        mapDependency(resultSet)
                );
            }
        }

        return dependencies;
    }


    /*
     * ============================================================
     * FIND DEPENDENCIES FOR ONE APPROVAL
     * ============================================================
     */
    @Override
    public List<ApprovalDependency> findByApprovalId(
            long approvalId)
            throws SQLException {

        List<ApprovalDependency> dependencies =
                new ArrayList<>();

        String sql = """
                SELECT
                    ad.dependency_id,
                    ad.approval_id,
                    ad.depends_on_approval_id,
                    ad.dependency_type,
                    ad.condition_description,
                    ad.active,
                    ad.created_at,
                    ad.updated_at,

                    a1.approval_name AS approval_name,
                    a1.approval_code AS approval_code,

                    a2.approval_name AS depends_on_approval_name,
                    a2.approval_code AS depends_on_approval_code

                FROM approval_dependencies ad

                INNER JOIN approvals a1
                    ON ad.approval_id = a1.approval_id

                INNER JOIN approvals a2
                    ON ad.depends_on_approval_id = a2.approval_id

                WHERE ad.active = 1
                  AND a1.active = 1
                  AND a2.active = 1
                  AND ad.approval_id = ?

                ORDER BY ad.dependency_id
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    approvalId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    dependencies.add(
                            mapDependency(resultSet)
                    );
                }
            }
        }

        return dependencies;
    }


    /*
     * ============================================================
     * FIND DEPENDENCIES FOR A BUSINESS
     * ============================================================
     *
     * Only relationships where BOTH approvals are part of the
     * entrepreneur's approval journey are returned.
     *
     * business_approvals is used because recommendation engine
     * already stores the entrepreneur's recommended approvals there.
     */
    @Override
    public List<ApprovalDependency> findByBusinessId(
            long businessId)
            throws SQLException {

        List<ApprovalDependency> dependencies =
                new ArrayList<>();

        String sql = """
                SELECT DISTINCT
                    ad.dependency_id,
                    ad.approval_id,
                    ad.depends_on_approval_id,
                    ad.dependency_type,
                    ad.condition_description,
                    ad.active,
                    ad.created_at,
                    ad.updated_at,

                    a1.approval_name AS approval_name,
                    a1.approval_code AS approval_code,

                    a2.approval_name AS depends_on_approval_name,
                    a2.approval_code AS depends_on_approval_code

                FROM approval_dependencies ad

                INNER JOIN approvals a1
                    ON ad.approval_id = a1.approval_id

                INNER JOIN approvals a2
                    ON ad.depends_on_approval_id = a2.approval_id

                INNER JOIN business_approvals ba1
                    ON ba1.approval_id = ad.approval_id
                   AND ba1.business_id = ?

                INNER JOIN business_approvals ba2
                    ON ba2.approval_id = ad.depends_on_approval_id
                   AND ba2.business_id = ?

                WHERE ad.active = 1
                  AND a1.active = 1
                  AND a2.active = 1

                ORDER BY
                    ad.approval_id,
                    ad.dependency_id
                """;

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setLong(
                    1,
                    businessId
            );

            statement.setLong(
                    2,
                    businessId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    dependencies.add(
                            mapDependency(resultSet)
                    );
                }
            }
        }

        return dependencies;
    }


    /*
     * ============================================================
     * RESULTSET -> MODEL
     * ============================================================
     */
    private ApprovalDependency mapDependency(
            ResultSet resultSet)
            throws SQLException {

        ApprovalDependency dependency =
                new ApprovalDependency();

        dependency.setDependencyId(
                resultSet.getLong(
                        "dependency_id"
                )
        );

        dependency.setApprovalId(
                resultSet.getLong(
                        "approval_id"
                )
        );

        dependency.setDependsOnApprovalId(
                resultSet.getLong(
                        "depends_on_approval_id"
                )
        );

        dependency.setDependencyType(
                resultSet.getString(
                        "dependency_type"
                )
        );

        dependency.setConditionDescription(
                resultSet.getString(
                        "condition_description"
                )
        );

        dependency.setActive(
                resultSet.getBoolean(
                        "active"
                )
        );

        dependency.setCreatedAt(
                resultSet.getTimestamp(
                        "created_at"
                )
        );

        dependency.setUpdatedAt(
                resultSet.getTimestamp(
                        "updated_at"
                )
        );

        dependency.setApprovalName(
                resultSet.getString(
                        "approval_name"
                )
        );

        dependency.setApprovalCode(
                resultSet.getString(
                        "approval_code"
                )
        );

        dependency.setDependsOnApprovalName(
                resultSet.getString(
                        "depends_on_approval_name"
                )
        );

        dependency.setDependsOnApprovalCode(
                resultSet.getString(
                        "depends_on_approval_code"
                )
        );

        return dependency;
    }
}