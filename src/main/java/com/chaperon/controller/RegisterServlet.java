package com.chaperon.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.chaperon.model.User;
import com.chaperon.service.AuthenticationService;
import com.chaperon.service.impl.AuthenticationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur-register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AuthenticationService authenticationService;

    @Override
    public void init() throws ServletException {

        authenticationService =
                new AuthenticationServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/auth/entrepreneur-register.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullName =
                request.getParameter("fullName");

        String email =
                request.getParameter("email");

        String mobile =
                request.getParameter("mobile");

        String password =
                request.getParameter("password");

        String confirmPassword =
                request.getParameter("confirmPassword");

        if (fullName == null ||
            fullName.isBlank() ||
            email == null ||
            email.isBlank() ||
            mobile == null ||
            mobile.isBlank() ||
            password == null ||
            password.isBlank() ||
            confirmPassword == null ||
            confirmPassword.isBlank()) {

            request.setAttribute(
                    "errorMessage",
                    "Please complete all required fields."
            );

            doGet(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {

            request.setAttribute(
                    "errorMessage",
                    "Password and confirm password do not match."
            );

            doGet(request, response);
            return;
        }

        if (password.length() < 6) {

            request.setAttribute(
                    "errorMessage",
                    "Password must be at least 6 characters long."
            );

            doGet(request, response);
            return;
        }

        try {

            if (authenticationService.emailExists(email)) {

                request.setAttribute(
                        "errorMessage",
                        "An account with this email already exists."
                );

                doGet(request, response);
                return;
            }

            boolean registered =
                    authenticationService
                            .registerEntrepreneur(
                                    fullName,
                                    email,
                                    mobile,
                                    password
                            );

            if (!registered) {

                request.setAttribute(
                        "errorMessage",
                        "We could not create your account. Please try again."
                );

                doGet(request, response);
                return;
            }

            User user =
                    authenticationService.login(
                            email,
                            password
                    );

            if (user == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/entrepreneur-login"
                );

                return;
            }

            HttpSession session =
                    request.getSession(true);

            session.setAttribute(
                    "userId",
                    user.getUserId()
            );

            session.setAttribute(
                    "userName",
                    user.getFullName()
            );

            session.setAttribute(
                    "userRole",
                    user.getRole()
            );

            session.setMaxInactiveInterval(
                    30 * 60
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur/dashboard"
            );

        }
        catch (SQLException e) {

            log(
                "Registration database error",
                e
            );

            request.setAttribute(
                    "errorMessage",
                    "Something went wrong while creating your account."
            );

            doGet(request, response);
        }
    }
}