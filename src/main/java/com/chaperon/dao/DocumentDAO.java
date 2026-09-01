package com.chaperon.dao;

import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.Document;

public interface DocumentDAO {

    long save(Document document)
            throws SQLException;

    List<Document> findByBusinessId(
            long businessId
    ) throws SQLException;

    Document findByBusinessIdAndType(
            long businessId,
            String documentType
    ) throws SQLException;
}