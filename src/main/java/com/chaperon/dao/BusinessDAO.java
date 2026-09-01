package com.chaperon.dao;

import java.sql.SQLException;

import com.chaperon.model.Business;

public interface BusinessDAO {

    long createBusiness(Business business)
            throws SQLException;

    Business findByUserId(long userId)
            throws SQLException;

    Business findByBusinessId(long businessId)
            throws SQLException;

    boolean updateBusiness(Business business)
            throws SQLException;

    boolean businessExistsForUser(long userId)
            throws SQLException;
}