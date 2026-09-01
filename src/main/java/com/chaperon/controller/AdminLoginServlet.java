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

@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {

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

        HttpSession session =
                request.getSession(false);

        /*
         * Agar ADMIN already logged in hai,
         * directly dashboard par bhej do.
         */
        if (session != null &&
            session.getAttribute("userId") != null &&
            "ADMIN".equalsIgnoreCase(
                    String.valueOf(
                            session.getAttribute("userRole")
                    )
            )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/dashboard"
            );

            return;
        }


        request.getRequestDispatcher(
                "/WEB-INF/views/auth/admin-login.jsp"
        ).forward(
                request,
                response
        );
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");


        String email =
                request.getParameter("email");

        String password =
                request.getParameter("password");


        /*
         * =========================================
         * BASIC VALIDATION
         * =========================================
         */

        if (email == null ||
            email.isBlank() ||
            password == null ||
            password.isBlank()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-login?error=invalid"
            );

            return;
        }


        try {

            /*
             * =========================================
             * AUTHENTICATE USER
             * =========================================
             */

            User user =
                    authenticationService.login(
                            email,
                            password
                    );


            /*
             * Invalid email/password/inactive account
             */
            if (user == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-login?error=invalid"
                );

                return;
            }


            /*
             * =========================================
             * ROLE CHECK
             * =========================================
             */

            if (!"ADMIN".equalsIgnoreCase(
                    user.getRole()
            )) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-login?error=role"
                );

                return;
            }


            /*
             * =========================================
             * CREATE SESSION
             * =========================================
             */

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

            session.setAttribute(
                    "userEmail",
                    user.getEmail()
            );


            /*
             * 30 minutes session timeout
             */
            session.setMaxInactiveInterval(
                    30 * 60
            );


            /*
             * =========================================
             * SUCCESS
             * =========================================
             */

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/dashboard"
            );


        } catch (SQLException e) {

            log(
                    "Unable to login administrator.",
                    e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to login administrator."
            );
        }
    }
}