package com.chaperon.dao;

import java.sql.SQLException;

import com.chaperon.model.User;

public interface UserDAO {

    boolean saveUser(User user) throws SQLException;

    User findByEmail(String email) throws SQLException;

    boolean emailExists(String email) throws SQLException;

    boolean updateLastLogin(long userId) throws SQLException;
}