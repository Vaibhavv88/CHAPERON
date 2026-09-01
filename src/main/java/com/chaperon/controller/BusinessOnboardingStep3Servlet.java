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

@WebServlet("/entrepreneur/business-onboarding/step3")
public class BusinessOnboardingStep3Servlet extends HttpServlet {

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
                    "/WEB-INF/views/entrepreneur/business-onboarding-step3.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            log(
                    "Unable to load onboarding Step 3",
                    e
            );

            request.setAttribute(
                    "errorMessage",
                    "We could not load your location details."
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/business-onboarding-step3.jsp"
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

        String state =
                clean(request.getParameter("state"));

        String district =
                clean(request.getParameter("district"));

        String taluka =
                clean(request.getParameter("taluka"));

        String industrialArea =
                clean(request.getParameter("industrialArea"));

        String pinCode =
                clean(request.getParameter("pinCode"));

        if (state == null ||
            district == null ||
            taluka == null ||
            pinCode == null) {

            request.setAttribute(
                    "errorMessage",
                    "Please complete all required location fields."
            );

            doGet(request, response);
            return;
        }

        if (!pinCode.matches("[0-9]{6}")) {

            request.setAttribute(
                    "errorMessage",
                    "Please enter a valid 6-digit PIN code."
            );

            doGet(request, response);
            return;
        }

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

            business.setState(state);
            business.setDistrict(district);
            business.setTaluka(taluka);
            business.setIndustrialArea(industrialArea);
            business.setPinCode(pinCode);

            boolean updated =
                    businessService.updateBusiness(business);

            if (!updated) {

                request.setAttribute(
                        "errorMessage",
                        "Your location details could not be saved."
                );

                request.setAttribute(
                        "business",
                        business
                );

                request.getRequestDispatcher(
                        "/WEB-INF/views/entrepreneur/business-onboarding-step3.jsp"
                ).forward(request, response);

                return;
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur/business-onboarding/step4"
            );

        } catch (SQLException e) {

            log(
                    "Unable to save onboarding Step 3",
                    e
            );

            request.setAttribute(
                    "errorMessage",
                    "Something went wrong while saving your location."
            );

            doGet(request, response);
        }
    }

    private String clean(String value) {

        if (value == null) {
            return null;
        }

        value = value.trim();

        return value.isEmpty()
                ? null
                : value;
    }
}