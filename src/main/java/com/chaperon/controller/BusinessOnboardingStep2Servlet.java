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

@WebServlet("/entrepreneur/business-onboarding/step2")
public class BusinessOnboardingStep2Servlet extends HttpServlet {

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

            request.setAttribute(
                    "business",
                    business
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/business-onboarding-step2.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            log(
                    "Unable to load onboarding Step 2",
                    e
            );

            request.setAttribute(
                    "errorMessage",
                    "We could not load this step. Please try again."
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/business-onboarding-step2.jsp"
            ).forward(request, response);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

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

        String industry =
                request.getParameter("industry");

        if (industry == null ||
            industry.isBlank()) {

            request.setAttribute(
                    "errorMessage",
                    "Please select your industry before continuing."
            );

            doGet(request, response);
            return;
        }

        industry = industry.trim();

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

            business.setIndustry(industry);

            boolean updated =
                    businessService.updateBusiness(business);

            if (!updated) {

                request.setAttribute(
                        "errorMessage",
                        "Your industry could not be saved. Please try again."
                );

                request.setAttribute(
                        "business",
                        business
                );

                request.getRequestDispatcher(
                        "/WEB-INF/views/entrepreneur/business-onboarding-step2.jsp"
                ).forward(request, response);

                return;
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur/business-onboarding/step3"
            );

        } catch (SQLException e) {

            log(
                    "Unable to save onboarding Step 2",
                    e
            );

            request.setAttribute(
                    "errorMessage",
                    "Something went wrong while saving your industry."
            );

            doGet(request, response);
        }
    }
}