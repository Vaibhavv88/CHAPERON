package com.chaperon.dao;

import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.ClearanceRequirement;

public interface ClearanceRequirementDAO {

    List<ClearanceRequirement> findActiveByClearanceTypeId(
            long clearanceTypeId
    ) throws SQLException;

    List<ClearanceRequirement> findAllByClearanceTypeId(
            long clearanceTypeId
    ) throws SQLException;

    List<ClearanceRequirement> findActiveByClearanceTypeAndRole(
            long clearanceTypeId,
            String responsibleRole
    ) throws SQLException;

    ClearanceRequirement findById(long requirementId)
            throws SQLException;

    long createRequirement(ClearanceRequirement requirement)
            throws SQLException;

    boolean updateRequirement(ClearanceRequirement requirement)
            throws SQLException;

    boolean updateActiveStatus(long requirementId, boolean active)
            throws SQLException;
}
