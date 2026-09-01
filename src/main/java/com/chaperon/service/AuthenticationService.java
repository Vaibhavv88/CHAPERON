package com.chaperon.service;

import java.sql.SQLException;

import com.chaperon.model.User;

public interface AuthenticationService {

    boolean registerEntrepreneur(
            String fullName,
            String email,
            String mobile,
            String password
    ) throws SQLException;

    User login(
            String email,
            String password
    ) throws SQLException;

    boolean emailExists(
            String email
    ) throws SQLException;
}