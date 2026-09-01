package com.chaperon.dao;

import java.sql.SQLException;

import com.chaperon.model.OfficerProfile;

public interface OfficerProfileDAO {

    OfficerProfile findByUserId(
            long userId
    ) throws SQLException;
}