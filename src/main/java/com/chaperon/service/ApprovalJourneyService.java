package com.chaperon.service;

import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.ApprovalDependency;

public interface ApprovalJourneyService {

    /*
     * Get all dependency relationships
     * relevant to a particular business.
     */
    List<ApprovalDependency> getBusinessJourney(
            long businessId)
            throws SQLException;


    /*
     * Get PARALLEL approvals.
     *
     * These approvals can potentially be
     * processed alongside each other.
     */
    List<ApprovalDependency> getParallelApprovals(
            long businessId)
            throws SQLException;


    /*
     * Get CONDITIONAL approval relationships.
     *
     * These are applicable only when
     * specified business conditions are met.
     */
    List<ApprovalDependency> getConditionalApprovals(
            long businessId)
            throws SQLException;


    /*
     * Get prerequisite/dependency relationships
     * if such records exist in database.
     */
    List<ApprovalDependency> getDependentApprovals(
            long businessId)
            throws SQLException;


    /*
     * Creates simple entrepreneur-friendly
     * explanation for a dependency relationship.
     */
    String getRelationshipMessage(
            ApprovalDependency dependency);
}