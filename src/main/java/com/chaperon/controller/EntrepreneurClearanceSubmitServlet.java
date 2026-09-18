package com.chaperon.controller;

import java.io.IOException;

import com.chaperon.model.User;
import com.chaperon.service.ClearanceApplicationService;
import com.chaperon.service.impl.ClearanceApplicationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/clearances/submit")
public class EntrepreneurClearanceSubmitServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ClearanceApplicationService clearanceService;

    @Override
    public void init() throws ServletException {

        clearanceService =
                new ClearanceApplicationServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        /*
         * Submission केवल POST request से होगा.
         */
        response.sendRedirect(
                request.getContextPath()
                        + "/entrepreneur/clearances");
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session =
                request.getSession(false);

        Long userId =
                getLoggedInUserId(session);

        String userRole =
                getLoggedInUserRole(session);

        if (userId == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur-login");

            return;
        }

        if (!"ENTREPRENEUR".equalsIgnoreCase(
                userRole)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only entrepreneurs can submit clearance applications.");

            return;
        }

        Long applicationId =
                parseLong(
                        request.getParameter(
                                "applicationId"));

        if (applicationId == null) {

            session.setAttribute(
                    "errorMessage",
                    "Invalid clearance application.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur/clearances");

            return;
        }

        try {
            /*
             * Service verifies ownership, readiness,
             * checklist and draft status.
             */
            boolean submitted =
                    clearanceService
                            .submitApplication(
                                    applicationId,
                                    userId);

            if (!submitted) {

                session.setAttribute(
                        "errorMessage",
                        "Application could not be submitted. "
                        + "Please complete all mandatory requirements.");

                response.sendRedirect(
                        request.getContextPath()
                                + "/entrepreneur/clearances/new?id="
                                + applicationId);

                return;
            }

            session.setAttribute(
                    "successMessage",
                    "Clearance application submitted successfully.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur/clearances");

        } catch (IllegalArgumentException exception) {

            session.setAttribute(
                    "errorMessage",
                    exception.getMessage());

            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur/clearances/new?id="
                            + applicationId);

        } catch (IllegalStateException exception) {

            session.setAttribute(
                    "errorMessage",
                    exception.getMessage());

            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur/clearances/new?id="
                            + applicationId);

        } catch (Exception exception) {

            exception.printStackTrace();

            session.setAttribute(
                    "errorMessage",
                    "Application submission failed. Please try again.");

            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur/clearances/new?id="
                            + applicationId);
        }
    }

    private Long getLoggedInUserId(
            HttpSession session) {

        if (session == null) {
            return null;
        }

        String[] possibleIdKeys = {
            "userId",
            "loggedInUserId",
            "currentUserId",
            "entrepreneurUserId"
        };

        for (String key : possibleIdKeys) {

            Long userId =
                    convertToLong(
                            session.getAttribute(key));

            if (userId != null) {
                return userId;
            }
        }

        String[] possibleUserKeys = {
            "user",
            "loggedInUser",
            "currentUser"
        };

        for (String key : possibleUserKeys) {

            Object value =
                    session.getAttribute(key);

            if (value instanceof User) {

                return ((User) value)
                        .getUserId();
            }
        }

        return null;
    }

    private String getLoggedInUserRole(
            HttpSession session) {

        if (session == null) {
            return null;
        }

        String[] possibleRoleKeys = {
            "userRole",
            "role",
            "loggedInUserRole"
        };

        for (String key : possibleRoleKeys) {

            Object value =
                    session.getAttribute(key);

            if (value != null) {
                return String.valueOf(value);
            }
        }

        String[] possibleUserKeys = {
            "user",
            "loggedInUser",
            "currentUser"
        };

        for (String key : possibleUserKeys) {

            Object value =
                    session.getAttribute(key);

            if (value instanceof User) {

                return ((User) value)
                        .getRole();
            }
        }

        return null;
    }

    private Long convertToLong(Object value) {

        if (value == null) {
            return null;
        }

        if (value instanceof Number) {

            return ((Number) value)
                    .longValue();
        }

        try {
            return Long.valueOf(
                    String.valueOf(value));

        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private Long parseLong(String value) {

        try {
            if (value == null
                    || value.trim().isEmpty()) {

                return null;
            }

            return Long.valueOf(
                    value.trim());

        } catch (NumberFormatException exception) {
            return null;
        }
    }
}