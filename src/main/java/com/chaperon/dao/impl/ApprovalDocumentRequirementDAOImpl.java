package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.ApprovalDocumentRequirementDAO;
import com.chaperon.model.ApprovalDocumentRequirement;
import com.chaperon.util.DBConnection;

public class ApprovalDocumentRequirementDAOImpl
        implements ApprovalDocumentRequirementDAO {

    private static final String FIND_BY_APPROVAL_ID =
            "SELECT requirement_id, approval_id, " +
            "document_type, description, mandatory, active " +
            "FROM approval_document_requirements " +
            "WHERE approval_id = ? AND active = 1 " +
            "ORDER BY mandatory DESC, requirement_id ASC";

    @Override
    public List<ApprovalDocumentRequirement> findByApprovalId(
            long approvalId
    ) throws SQLException {

        List<ApprovalDocumentRequirement> requirements =
                new ArrayList<>();

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement preparedStatement =
                    connection.prepareStatement(
                            FIND_BY_APPROVAL_ID
                    )
        ) {

            preparedStatement.setLong(
                    1,
                    approvalId
            );

            try (
                ResultSet resultSet =
                        preparedStatement.executeQuery()
            ) {

                while (resultSet.next()) {

                    ApprovalDocumentRequirement requirement =
                            new ApprovalDocumentRequirement();

                    requirement.setRequirementId(
                            resultSet.getLong(
                                    "requirement_id"
                            )
                    );

                    requirement.setApprovalId(
                            resultSet.getLong(
                                    "approval_id"
                            )
                    );

                    requirement.setDocumentType(
                            resultSet.getString(
                                    "document_type"
                            )
                    );

                    requirement.setDescription(
                            resultSet.getString(
                                    "description"
                            )
                    );

                    requirement.setMandatory(
                            resultSet.getBoolean(
                                    "mandatory"
                            )
                    );

                    requirement.setActive(
                            resultSet.getBoolean(
                                    "active"
                            )
                    );

                    requirements.add(
                            requirement
                    );
                }
            }
        }

        return requirements;
    }
}