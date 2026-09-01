package com.chaperon.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/help")
public class EntrepreneurHelpServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        /*
         * ==========================================
         * LOGIN CHECK
         * ==========================================
         */
        if (session == null ||
            session.getAttribute("userId") == null ||
            session.getAttribute("userRole") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }


        /*
         * ==========================================
         * ROLE CHECK
         * ==========================================
         */
        String userRole =
                String.valueOf(
                        session.getAttribute(
                                "userRole"
                        )
                );

        if (!"ENTREPRENEUR"
                .equalsIgnoreCase(
                        userRole
                )) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Access denied."
            );

            return;
        }


        /*
         * ==========================================
         * OPEN HELP PAGE
         * ==========================================
         */
        request
        .getRequestDispatcher(
                "/WEB-INF/views/entrepreneur/help.jsp"
        )
        .forward(
                request,
                response
        );
    }
}