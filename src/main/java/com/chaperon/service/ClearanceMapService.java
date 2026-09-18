package com.chaperon.service;

import java.sql.SQLException;

import com.chaperon.model.ClearanceApplicationMap;

public interface ClearanceMapService {

    /*
     * New map save karega ya existing map update karega.
     */
    long saveOrUpdateMap(
            ClearanceApplicationMap clearanceMap)
            throws SQLException;

    /*
     * Application ID se saved map fetch karega.
     */
    ClearanceApplicationMap getMapByApplicationId(
            long clearanceApplicationId)
            throws SQLException;

    /*
     * Application ke map ko delete karega.
     */
    boolean deleteMap(
            long clearanceApplicationId)
            throws SQLException;
}