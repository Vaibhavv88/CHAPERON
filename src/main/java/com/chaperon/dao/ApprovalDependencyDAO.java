package com.chaperon.dao;

import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.ApprovalDependency;

public interface ApprovalDependencyDAO {

    /*
     * Get all active dependency relationships.
     */
    List<ApprovalDependency> findAllActive()
            throws SQLException;


    /*
     * Get dependency relationships for one approval.
     *
     * Example:
     * Factory License -> Fire NOC -> PARALLEL
     */
    List<ApprovalDependency> findByApprovalId(long approvalId)
            throws SQLException;


    /*
     * Get dependency relationships relevant to
     * approvals recommended for one business.
     *
     * This will later be used by the
     * Journey Optimizer.
     */
    List<ApprovalDependency> findByBusinessId(long businessId)
            throws SQLException;
}