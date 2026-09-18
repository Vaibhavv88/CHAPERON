package com.chaperon.dao;

import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.ClearanceApplicationRequirement;

public interface ClearanceApplicationRequirementDAO {

    int initializeRequirements(
            long clearanceApplicationId,
            long clearanceTypeId
    ) throws SQLException;

    List<ClearanceApplicationRequirement> findByApplicationId(
            long clearanceApplicationId
    ) throws SQLException;

    ClearanceApplicationRequirement findById(
            long applicationRequirementId
    ) throws SQLException;

    boolean attachDocument(
            long applicationRequirementId,
            long documentId,
            long uploadedByUserId,
            String applicantRemarks
    ) throws SQLException;

    boolean updateVerification(
            long applicationRequirementId,
            String requirementStatus,
            long verifiedByUserId,
            String officerRemarks
    ) throws SQLException;

    boolean updateApplicability(
            long applicationRequirementId,
            boolean applicable,
            boolean mandatory
    ) throws SQLException;

    int countMandatoryApplicable(long clearanceApplicationId)
            throws SQLException;

    int countProvidedMandatory(long clearanceApplicationId)
            throws SQLException;
}
