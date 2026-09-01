package com.chaperon.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.chaperon.dao.OfficerProfileDAO;
import com.chaperon.dao.impl.OfficerProfileDAOImpl;

import com.chaperon.model.OfficerProfile;
import com.chaperon.model.User;

import com.chaperon.service.AuthenticationService;
import com.chaperon.service.impl.AuthenticationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/officer-login")
public class OfficerLoginServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AuthenticationService authenticationService;

    private OfficerProfileDAO officerProfileDAO;

    @Override
    public void init()
            throws ServletException {

        authenticationService =
                new AuthenticationServiceImpl();

        officerProfileDAO =
                new OfficerProfileDAOImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        /*
         * Agar officer already logged in hai
         * to login page dobara mat dikhao.
         */
        HttpSession session =
                request.getSession(false);

        if (session != null &&
            "OFFICER".equalsIgnoreCase(
                    (String)
                    session.getAttribute(
                            "userRole"
                    )
            )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/officer/dashboard"
            );

            return;
        }

        request.getRequestDispatcher(
                "/WEB-INF/views/auth/officer-login.jsp"
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

        request.setCharacterEncoding(
                "UTF-8"
        );

        String email =
                request.getParameter(
                        "email"
                );

        String password =
                request.getParameter(
                        "password"
                );

        /*
         * -----------------------------------
         * 1. BASIC VALIDATION
         * -----------------------------------
         */

        if (email == null ||
            email.isBlank() ||
            password == null ||
            password.isBlank()) {

            request.setAttribute(
                    "errorMessage",
                    "Please enter your official email and password."
            );

            showLoginPage(
                    request,
                    response
            );

            return;
        }

        try {

            /*
             * -----------------------------------
             * 2. EXISTING AUTHENTICATION SERVICE
             * -----------------------------------
             */

            User user =
                    authenticationService.login(
                            email.trim(),
                            password
                    );

            if (user == null) {

                request.setAttribute(
                        "errorMessage",
                        "Invalid email or password."
                );

                showLoginPage(
                        request,
                        response
                );

                return;
            }

            /*
             * -----------------------------------
             * 3. ROLE CHECK
             * -----------------------------------
             */

            if (!"OFFICER".equalsIgnoreCase(
                    user.getRole()
            )) {

                request.setAttribute(
                        "errorMessage",
                        "This login is only for government officers."
                );

                showLoginPage(
                        request,
                        response
                );

                return;
            }

            /*
             * -----------------------------------
             * 4. OFFICER PROFILE LOAD
             * -----------------------------------
             */

            OfficerProfile officerProfile =
                    officerProfileDAO
                            .findByUserId(
                                    user.getUserId()
                            );

            if (officerProfile == null) {

                request.setAttribute(
                        "errorMessage",
                        "Officer profile is not configured. Please contact the administrator."
                );

                showLoginPage(
                        request,
                        response
                );

                return;
            }

            /*
             * -----------------------------------
             * 5. ACTIVE CHECK
             * -----------------------------------
             */

            if (!officerProfile.isActive()) {

                request.setAttribute(
                        "errorMessage",
                        "Your officer account is currently inactive. Please contact the administrator."
                );

                showLoginPage(
                        request,
                        response
                );

                return;
            }

            /*
             * -----------------------------------
             * 6. DESTROY OLD SESSION
             * -----------------------------------
             */

            HttpSession oldSession =
                    request.getSession(false);

            if (oldSession != null) {

                oldSession.invalidate();
            }

            /*
             * -----------------------------------
             * 7. CREATE OFFICER SESSION
             * -----------------------------------
             */

            HttpSession session =
                    request.getSession(true);

            /*
             * Common authentication information
             */
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

            /*
             * Officer-specific information
             */
            session.setAttribute(
                    "officerProfileId",
                    officerProfile
                            .getOfficerProfileId()
            );

            session.setAttribute(
                    "departmentId",
                    officerProfile
                            .getDepartmentId()
            );

            session.setAttribute(
                    "departmentName",
                    officerProfile
                            .getDepartmentName()
            );

            session.setAttribute(
                    "departmentCode",
                    officerProfile
                            .getDepartmentCode()
            );

            session.setAttribute(
                    "employeeCode",
                    officerProfile
                            .getEmployeeCode()
            );

            session.setAttribute(
                    "designation",
                    officerProfile
                            .getDesignation()
            );

            /*
             * 30 minute session
             */
            session.setMaxInactiveInterval(
                    30 * 60
            );

            /*
             * -----------------------------------
             * 8. REDIRECT TO OFFICER DASHBOARD
             * -----------------------------------
             */

            response.sendRedirect(
                    request.getContextPath()
                    + "/officer/dashboard"
            );

        } catch (SQLException e) {

            log(
                    "Officer login database error",
                    e
            );

            request.setAttribute(
                    "errorMessage",
                    "Something went wrong while signing you in."
            );

            showLoginPage(
                    request,
                    response
            );
        }
    }

    private void showLoginPage(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/auth/officer-login.jsp"
        ).forward(
                request,
                response
        );
    }
}