package com.chaperon.service;

import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.ClearanceApplication;
import com.chaperon.model.ClearanceApplicationRequirement;
import com.chaperon.model.ClearanceRequirement;
import com.chaperon.model.ClearanceStatusHistory;
import com.chaperon.model.ClearanceType;

public interface ClearanceApplicationService {

    List<ClearanceType> getActiveClearanceTypes()
            throws SQLException;

    List<ClearanceRequirement> getActiveRequirements(
            long clearanceTypeId
    ) throws SQLException;

    long createDraft(ClearanceApplication application)
            throws SQLException;

    boolean updateDraft(ClearanceApplication application)
            throws SQLException;

    boolean submitApplication(
            long clearanceApplicationId,
            long entrepreneurUserId
    ) throws SQLException;

    ClearanceApplication getApplicationForUser(
            long clearanceApplicationId,
            long entrepreneurUserId
    ) throws SQLException;

    List<ClearanceApplication> getApplicationsForUser(long userId)
            throws SQLException;

    List<ClearanceApplication> getApplicationsForOfficer(long officerUserId)
            throws SQLException;

    List<ClearanceApplication> getAllApplications()
            throws SQLException;

    List<ClearanceApplicationRequirement> getApplicationChecklist(
            long clearanceApplicationId
    ) throws SQLException;

    int calculateReadinessPercentage(long clearanceApplicationId)
            throws SQLException;

    boolean attachRequirementDocument(
            long clearanceApplicationId,
            long applicationRequirementId,
            long documentId,
            long entrepreneurUserId,
            String applicantRemarks
    ) throws SQLException;

    boolean verifyRequirement(
            long applicationRequirementId,
            String requirementStatus,
            long officerUserId,
            String officerRemarks
    ) throws SQLException;

    boolean assignOfficer(
            long clearanceApplicationId,
            long officerUserId,
            long adminUserId
    ) throws SQLException;

    boolean changeStatus(
            long clearanceApplicationId,
            String newStatus,
            long changedByUserId,
            String changedByRole,
            String remarks,
            String rejectionReason
    ) throws SQLException;

    List<ClearanceStatusHistory> getTimeline(
            long clearanceApplicationId
    ) throws SQLException;
}
