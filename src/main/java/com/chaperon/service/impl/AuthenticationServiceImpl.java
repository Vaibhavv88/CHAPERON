package com.chaperon.service.impl;

import java.sql.SQLException;

import com.chaperon.dao.UserDAO;
import com.chaperon.dao.impl.UserDAOImpl;
import com.chaperon.model.User;
import com.chaperon.service.AuthenticationService;
import com.chaperon.util.PasswordUtil;


public class AuthenticationServiceImpl
        implements AuthenticationService {

    private final UserDAO userDAO;

    public AuthenticationServiceImpl() {

        this.userDAO = new UserDAOImpl();
    }

    @Override
    public boolean registerEntrepreneur(
            String fullName,
            String email,
            String mobile,
            String password
    ) throws SQLException {

        if (fullName == null ||
            fullName.isBlank()) {

            return false;
        }

        if (email == null ||
            email.isBlank()) {

            return false;
        }

        if (password == null ||
            password.isBlank()) {

            return false;
        }

        email = email.trim().toLowerCase();

        if (userDAO.emailExists(email)) {

            return false;
        }

        String hashedPassword =
                PasswordUtil.hashPassword(password);

        User user = new User();

        user.setFullName(fullName.trim());

        user.setEmail(email);

        if (mobile != null) {

            user.setMobile(
                    mobile.trim()
            );
        }

        user.setPasswordHash(
                hashedPassword
        );

        user.setRole(
                "ENTREPRENEUR"
        );

        return userDAO.saveUser(user);
    }

    @Override
    public User login(
            String email,
            String password
    ) throws SQLException {

        if (email == null ||
            email.isBlank() ||
            password == null ||
            password.isBlank()) {

            return null;
        }

        email = email.trim().toLowerCase();

        User user =
                userDAO.findByEmail(email);

        if (user == null) {

            return null;
        }

        if (!"ACTIVE".equalsIgnoreCase(
                user.getAccountStatus())) {

            return null;
        }

        boolean passwordCorrect =
                PasswordUtil.checkPassword(
                        password,
                        user.getPasswordHash()
                );

        if (!passwordCorrect) {

            return null;
        }

        userDAO.updateLastLogin(
                user.getUserId()
        );

        return user;
    }

    @Override
    public boolean emailExists(
            String email
    ) throws SQLException {

        if (email == null ||
            email.isBlank()) {

            return false;
        }

        return userDAO.emailExists(
                email.trim().toLowerCase()
        );
    }
}
