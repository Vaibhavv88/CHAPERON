package com.chaperon.dao;

import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.Application;

public interface ApplicationDAO {

    long save(
            Application application
    ) throws SQLException;

    Application findById(
            long applicationId
    ) throws SQLException;

    Application findActiveByBusinessAndApproval(
            long businessId,
            long approvalId
    ) throws SQLException;

    List<Application> findByUserId(
            long userId
    ) throws SQLException;

    List<Application> findByDepartmentId(
            long departmentId
    ) throws SQLException;

    void updateStatus(
            long applicationId,
            String newStatus
    ) throws SQLException;

    void submitApplication(
            long applicationId,
            Integer slaDays
    ) throws SQLException;
}