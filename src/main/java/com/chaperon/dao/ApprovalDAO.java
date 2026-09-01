package com.chaperon.dao;

import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.Approval;
import com.chaperon.model.ApprovalRule;

public interface ApprovalDAO {

    List<Approval> findAllActiveApprovals()
            throws SQLException;

    Approval findApprovalById(long approvalId)
            throws SQLException;

    List<ApprovalRule> findActiveRules()
            throws SQLException;

    List<ApprovalRule> findRulesByApprovalId(long approvalId)
            throws SQLException;
}