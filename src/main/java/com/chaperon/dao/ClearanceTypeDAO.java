package com.chaperon.dao;

import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.ClearanceType;

public interface ClearanceTypeDAO {

    List<ClearanceType> findAllActive()
            throws SQLException;

    List<ClearanceType> findAll()
            throws SQLException;

    ClearanceType findById(long clearanceTypeId)
            throws SQLException;

    ClearanceType findByCode(String clearanceCode)
            throws SQLException;

    long createClearanceType(ClearanceType clearanceType)
            throws SQLException;

    boolean updateClearanceType(ClearanceType clearanceType)
            throws SQLException;

    boolean updateActiveStatus(long clearanceTypeId, boolean active)
            throws SQLException;
}
