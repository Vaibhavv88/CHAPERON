package com.chaperon.dao;

import java.sql.SQLException;

public interface OnboardingProgressDAO {

    boolean markCompleted(
            long userId,
            long businessId
    ) throws SQLException;
}