package com.chaperon.dao;

import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.BusinessApproval;

public interface BusinessApprovalDAO {

    boolean saveBusinessApproval(
            BusinessApproval businessApproval
    ) throws SQLException;

    List<BusinessApproval> findByBusinessId(
            long businessId
    ) throws SQLException;

    boolean exists(
            long businessId,
            long approvalId
    ) throws SQLException;

    boolean deleteByBusinessId(
            long businessId
    ) throws SQLException;

    /*
     * Deletes only recommendations which have
     * not been started yet.
     *
     * Submitted / approved / rejected history
     * is preserved.
     */
    boolean deleteNotStartedByBusinessId(
            long businessId
    ) throws SQLException;

    BusinessApproval findByBusinessAndApproval(
            long businessId,
            long approvalId
    ) throws SQLException;
}