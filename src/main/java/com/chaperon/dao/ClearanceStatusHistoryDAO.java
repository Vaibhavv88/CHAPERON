package com.chaperon.dao;

import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.ClearanceStatusHistory;

public interface ClearanceStatusHistoryDAO {

    long createHistory(ClearanceStatusHistory history)
            throws SQLException;

    List<ClearanceStatusHistory> findByApplicationId(
            long clearanceApplicationId
    ) throws SQLException;

    ClearanceStatusHistory findLatestByApplicationId(
            long clearanceApplicationId
    ) throws SQLException;
}
