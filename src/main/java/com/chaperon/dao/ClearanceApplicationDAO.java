package com.chaperon.dao;

import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.ClearanceApplication;

public interface ClearanceApplicationDAO {

    long createApplication(ClearanceApplication application)
            throws SQLException;

    boolean updateApplication(ClearanceApplication application)
            throws SQLException;

    ClearanceApplication findById(long clearanceApplicationId)
            throws SQLException;

    ClearanceApplication findByApplicationNumber(String applicationNumber)
            throws SQLException;

    List<ClearanceApplication> findByUserId(long userId)
            throws SQLException;

    List<ClearanceApplication> findByAssignedOfficerId(long officerUserId)
            throws SQLException;

    List<ClearanceApplication> findByStatus(String currentStatus)
            throws SQLException;

    List<ClearanceApplication> findAll()
            throws SQLException;

    boolean submitApplication(
            long clearanceApplicationId,
            String applicationNumber
    ) throws SQLException;

    boolean assignOfficer(
            long clearanceApplicationId,
            long officerUserId
    ) throws SQLException;

    boolean updateStatus(
            long clearanceApplicationId,
            String currentStatus,
            String officerRemarks,
            String rejectionReason
    ) throws SQLException;

    boolean belongsToUser(
            long clearanceApplicationId,
            long userId
    ) throws SQLException;
}
