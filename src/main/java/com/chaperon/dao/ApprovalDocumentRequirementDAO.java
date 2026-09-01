package com.chaperon.dao;

import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.ApprovalDocumentRequirement;

public interface ApprovalDocumentRequirementDAO {

    List<ApprovalDocumentRequirement> findByApprovalId(
            long approvalId
    ) throws SQLException;
}