package com.chaperon.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.chaperon.model.Business;
import com.chaperon.service.BusinessService;
import com.chaperon.service.impl.BusinessServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/business-profile-complete")
public class BusinessProfileCompleteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BusinessService businessService;

    @Override
    public void init() throws ServletException {
        businessService = new BusinessServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );
            return;
        }

        long userId =
                ((Number) session.getAttribute("userId"))
                .longValue();

        try {

            Business business =
                    businessService.getBusinessByUserId(userId);

            if (business == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/entrepreneur/business-onboarding"
                );
                return;
            }

            request.setAttribute("business", business);

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/business-profile-complete.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            log("Unable to load completed business profile", e);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );
        }
    }
}