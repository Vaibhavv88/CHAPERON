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

@WebServlet("/entrepreneur/business-onboarding")
public class BusinessOnboardingServlet extends HttpServlet {

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

            request.setAttribute(
                    "business",
                    business
            );

            request.setAttribute(
                    "currentStep",
                    1
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/business-onboarding-step1.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            log(
                    "Unable to load business onboarding",
                    e
            );

            request.setAttribute(
                    "errorMessage",
                    "We could not load your business profile. Please try again."
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/business-onboarding-step1.jsp"
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

        String businessName =
                clean(request.getParameter("businessName"));

        String businessConstitution =
                clean(request.getParameter("businessConstitution"));

        String businessActivity =
                clean(request.getParameter("businessActivity"));

        if (businessName == null ||
            businessConstitution == null ||
            businessActivity == null) {

            request.setAttribute(
                    "errorMessage",
                    "Please complete all three fields before continuing."
            );

            Business enteredBusiness = new Business();

            enteredBusiness.setBusinessName(
                    businessName
            );

            enteredBusiness.setBusinessConstitution(
                    businessConstitution
            );

            enteredBusiness.setBusinessActivity(
                    businessActivity
            );

            request.setAttribute(
                    "business",
                    enteredBusiness
            );

            request.setAttribute(
                    "currentStep",
                    1
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/business-onboarding-step1.jsp"
            ).forward(request, response);

            return;
        }

        try {

            Business business =
                    businessService.getBusinessByUserId(userId);

            if (business == null) {

                business = new Business();

                business.setUserId(userId);

                business.setBusinessName(
                        businessName
                );

                business.setBusinessConstitution(
                        businessConstitution
                );

                business.setBusinessActivity(
                        businessActivity
                );

                long businessId =
                        businessService.createBusiness(
                                business
                        );

                if (businessId <= 0) {

                    request.setAttribute(
                            "errorMessage",
                            "Your business details could not be saved. Please try again."
                    );

                    request.setAttribute(
                            "business",
                            business
                    );

                    request.getRequestDispatcher(
                            "/WEB-INF/views/entrepreneur/business-onboarding-step1.jsp"
                    ).forward(request, response);

                    return;
                }

                business.setBusinessId(
                        businessId
                );

            } else {

                business.setBusinessName(
                        businessName
                );

                business.setBusinessConstitution(
                        businessConstitution
                );

                business.setBusinessActivity(
                        businessActivity
                );

                boolean updated =
                        businessService.updateBusiness(
                                business
                        );

                if (!updated) {

                    request.setAttribute(
                            "errorMessage",
                            "Your changes could not be saved. Please try again."
                    );

                    request.setAttribute(
                            "business",
                            business
                    );

                    request.getRequestDispatcher(
                            "/WEB-INF/views/entrepreneur/business-onboarding-step1.jsp"
                    ).forward(request, response);

                    return;
                }
            }

            session.setAttribute(
                    "businessId",
                    business.getBusinessId()
            );

            /*
             * Step 1 successfully saved.
             * Step 30G will create the Step 2 page.
             */
            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur/business-onboarding/step2"
            );

        } catch (SQLException e) {

            log(
                    "Unable to save business onboarding Step 1",
                    e
            );

            request.setAttribute(
                    "errorMessage",
                    "Something went wrong while saving your business details."
            );

            Business enteredBusiness = new Business();

            enteredBusiness.setBusinessName(
                    businessName
            );

            enteredBusiness.setBusinessConstitution(
                    businessConstitution
            );

            enteredBusiness.setBusinessActivity(
                    businessActivity
            );

            request.setAttribute(
                    "business",
                    enteredBusiness
            );

            request.setAttribute(
                    "currentStep",
                    1
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/business-onboarding-step1.jsp"
            ).forward(request, response);
        }
    }

    private String clean(String value) {

        if (value == null) {
            return null;
        }

        value = value.trim();

        if (value.isEmpty()) {
            return null;
        }

        return value;
    }
}