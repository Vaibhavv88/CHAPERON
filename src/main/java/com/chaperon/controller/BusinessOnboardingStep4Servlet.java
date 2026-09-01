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

@WebServlet("/entrepreneur/business-onboarding/step4")
public class BusinessOnboardingStep4Servlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BusinessService businessService;

    @Override
    public void init() throws ServletException {
        businessService = new BusinessServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

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
                    "/WEB-INF/views/entrepreneur/business-onboarding-step4.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            log("Unable to load onboarding Step 4", e);

            request.setAttribute(
                    "errorMessage",
                    "We could not load your project details."
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/business-onboarding-step4.jsp"
            ).forward(request, response);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

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

        String projectStage =
                clean(request.getParameter("projectStage"));

        String investmentText =
                clean(request.getParameter("estimatedInvestment"));

        String employeesText =
                clean(request.getParameter("expectedEmployees"));

        String landAreaText =
                clean(request.getParameter("landArea"));

        String builtUpAreaText =
                clean(request.getParameter("builtUpArea"));

        String powerText =
                clean(request.getParameter("powerRequirement"));

        String waterText =
                clean(request.getParameter("waterRequirement"));

        if (projectStage == null ||
            investmentText == null ||
            employeesText == null) {

            request.setAttribute(
                    "errorMessage",
                    "Please complete all required project details."
            );

            doGet(request, response);
            return;
        }

        try {

            double estimatedInvestment =
                    Double.parseDouble(investmentText);

            int expectedEmployees =
                    Integer.parseInt(employeesText);

            Double landArea =
                    parseOptionalDouble(landAreaText);

            Double builtUpArea =
                    parseOptionalDouble(builtUpAreaText);

            Double powerRequirement =
                    parseOptionalDouble(powerText);

            Double waterRequirement =
                    parseOptionalDouble(waterText);

            if (estimatedInvestment < 0 ||
                expectedEmployees < 0) {

                request.setAttribute(
                        "errorMessage",
                        "Investment and employee count cannot be negative."
                );

                doGet(request, response);
                return;
            }

            Business business =
                    businessService.getBusinessByUserId(userId);

            if (business == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/entrepreneur/business-onboarding"
                );

                return;
            }

            business.setProjectStage(projectStage);
            business.setInvestmentAmount(
                    java.math.BigDecimal.valueOf(estimatedInvestment)
            		);

            		business.setEmployeeCount(expectedEmployees);
            		business.setLandArea(
            		        landArea == null
            		                ? null
            		                : java.math.BigDecimal.valueOf(landArea)
            		);

            		business.setBuiltUpArea(
            		        builtUpArea == null
            		                ? null
            		                : java.math.BigDecimal.valueOf(builtUpArea)
            		);

            		business.setPowerRequirement(
            		        powerRequirement == null
            		                ? null
            		                : java.math.BigDecimal.valueOf(powerRequirement)
            		);

            		business.setWaterRequirement(
            		        waterRequirement == null
            		                ? null
            		                : java.math.BigDecimal.valueOf(waterRequirement)
            		);

            boolean updated =
                    businessService.updateBusiness(business);

            if (!updated) {

                request.setAttribute(
                        "errorMessage",
                        "Your project details could not be saved."
                );

                request.setAttribute("business", business);

                request.getRequestDispatcher(
                        "/WEB-INF/views/entrepreneur/business-onboarding-step4.jsp"
                ).forward(request, response);

                return;
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur/business-onboarding/step5"
            );

        } catch (NumberFormatException e) {

            request.setAttribute(
                    "errorMessage",
                    "Please enter valid numbers in the project detail fields."
            );

            doGet(request, response);

        } catch (SQLException e) {

            log("Unable to save onboarding Step 4", e);

            request.setAttribute(
                    "errorMessage",
                    "Something went wrong while saving your project details."
            );

            doGet(request, response);
        }
    }

    private String clean(String value) {

        if (value == null) {
            return null;
        }

        value = value.trim();

        return value.isEmpty() ? null : value;
    }

    private Double parseOptionalDouble(String value) {

        if (value == null) {
            return null;
        }

        return Double.parseDouble(value);
    }
}