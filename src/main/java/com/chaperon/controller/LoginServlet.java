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

@WebServlet("/entrepreneur-login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AuthenticationService authenticationService;

    @Override
    public void init() throws ServletException {
        authenticationService = new AuthenticationServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/auth/entrepreneur-login.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null ||
                email.isBlank() ||
                password == null ||
                password.isBlank()) {

            request.setAttribute(
                    "errorMessage",
                    "Please enter your email and password."
            );

            doGet(request, response);
            return;
        }

        try {

            User user = authenticationService.login(
                    email,
                    password
            );

            if (user == null) {

                request.setAttribute(
                        "errorMessage",
                        "Invalid email or password."
                );

                doGet(request, response);
                return;
            }

            if (!"ENTREPRENEUR".equalsIgnoreCase(
                    user.getRole())) {

                request.setAttribute(
                        "errorMessage",
                        "This login is only for entrepreneurs."
                );

                doGet(request, response);
                return;
            }

            HttpSession oldSession =
                    request.getSession(false);

            if (oldSession != null) {
                oldSession.invalidate();
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

            session.setMaxInactiveInterval(30 * 60);

            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur/dashboard"
            );

        } catch (SQLException e) {

            log("Login database error", e);

            request.setAttribute(
                    "errorMessage",
                    "Something went wrong while signing you in."
            );

            doGet(request, response);
        }
    }
}