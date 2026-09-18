package com.chaperon.dao;

import java.sql.SQLException;

import com.chaperon.model.ClearanceApplicationMap;

public interface ClearanceMapDAO {

    /*
     * Save new project map/location.
     */
    long saveMap(
            ClearanceApplicationMap clearanceMap)
            throws SQLException;

    /*
     * Update existing project map.
     */
    boolean updateMap(
            ClearanceApplicationMap clearanceMap)
            throws SQLException;

    /*
     * Get map using clearance application ID.
     */
    ClearanceApplicationMap getMapByApplicationId(
            long clearanceApplicationId)
            throws SQLException;

    /*
     * Check whether application already has a map.
     */
    boolean mapExists(
            long clearanceApplicationId)
            throws SQLException;

    /*
     * Delete application map.
     */
    boolean deleteMap(
            long clearanceApplicationId)
            throws SQLException;
}