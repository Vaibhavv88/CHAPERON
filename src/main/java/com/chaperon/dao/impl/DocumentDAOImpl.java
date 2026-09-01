package com.chaperon.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.DocumentDAO;
import com.chaperon.model.Document;
import com.chaperon.util.DBConnection;

public class DocumentDAOImpl
        implements DocumentDAO {

    private static final String INSERT =
            "INSERT INTO documents (" +
            "user_id, business_id, document_type, " +
            "original_file_name, stored_file_name, " +
            "file_path, file_size, file_extension, " +
            "verification_status, active" +
            ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'UPLOADED', 1)";

    private static final String FIND_BY_BUSINESS =
            "SELECT * FROM documents " +
            "WHERE business_id = ? " +
            "AND active = 1 " +
            "ORDER BY upload_date DESC";

    private static final String FIND_BY_TYPE =
            "SELECT * FROM documents " +
            "WHERE business_id = ? " +
            "AND document_type = ? " +
            "AND active = 1 " +
            "ORDER BY upload_date DESC " +
            "LIMIT 1";

    @Override
    public long save(Document document)
            throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            INSERT,
                            Statement.RETURN_GENERATED_KEYS
                    )
        ) {

            statement.setLong(
                    1,
                    document.getUserId()
            );

            statement.setLong(
                    2,
                    document.getBusinessId()
            );

            statement.setString(
                    3,
                    document.getDocumentType()
            );

            statement.setString(
                    4,
                    document.getOriginalFileName()
            );

            statement.setString(
                    5,
                    document.getStoredFileName()
            );

            statement.setString(
                    6,
                    document.getFilePath()
            );

            if (document.getFileSize() != null) {

                statement.setLong(
                        7,
                        document.getFileSize()
                );

            } else {

                statement.setNull(
                        7,
                        java.sql.Types.BIGINT
                );
            }

            statement.setString(
                    8,
                    document.getFileExtension()
            );

            statement.executeUpdate();

            try (
                ResultSet keys =
                        statement.getGeneratedKeys()
            ) {

                if (keys.next()) {

                    return keys.getLong(1);
                }
            }
        }

        return 0;
    }

    @Override
    public List<Document> findByBusinessId(
            long businessId
    ) throws SQLException {

        List<Document> documents =
                new ArrayList<>();

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            FIND_BY_BUSINESS
                    )
        ) {

            statement.setLong(
                    1,
                    businessId
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    documents.add(
                            mapDocument(resultSet)
                    );
                }
            }
        }

        return documents;
    }

    @Override
    public Document findByBusinessIdAndType(
            long businessId,
            String documentType
    ) throws SQLException {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            FIND_BY_TYPE
                    )
        ) {

            statement.setLong(
                    1,
                    businessId
            );

            statement.setString(
                    2,
                    documentType
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    return mapDocument(
                            resultSet
                    );
                }
            }
        }

        return null;
    }

    private Document mapDocument(
            ResultSet resultSet
    ) throws SQLException {

        Document document =
                new Document();

        document.setDocumentId(
                resultSet.getLong(
                        "document_id"
                )
        );

        document.setUserId(
                resultSet.getLong(
                        "user_id"
                )
        );

        document.setBusinessId(
                resultSet.getLong(
                        "business_id"
                )
        );

        document.setDocumentType(
                resultSet.getString(
                        "document_type"
                )
        );

        document.setOriginalFileName(
                resultSet.getString(
                        "original_file_name"
                )
        );

        document.setStoredFileName(
                resultSet.getString(
                        "stored_file_name"
                )
        );

        document.setFilePath(
                resultSet.getString(
                        "file_path"
                )
        );

        long size =
                resultSet.getLong(
                        "file_size"
                );

        if (!resultSet.wasNull()) {

            document.setFileSize(size);
        }

        document.setFileExtension(
                resultSet.getString(
                        "file_extension"
                )
        );

        document.setVerificationStatus(
                resultSet.getString(
                        "verification_status"
                )
        );

        document.setVerificationRemarks(
                resultSet.getString(
                        "verification_remarks"
                )
        );

        long verifiedBy =
                resultSet.getLong(
                        "verified_by"
                );

        if (!resultSet.wasNull()) {

            document.setVerifiedBy(
                    verifiedBy
            );
        }

        document.setUploadDate(
                resultSet.getTimestamp(
                        "upload_date"
                )
        );

        document.setExpiryDate(
                resultSet.getDate(
                        "expiry_date"
                )
        );

        document.setActive(
                resultSet.getBoolean(
                        "active"
                )
        );

        return document;
    }
}