package com.chaperon.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.chaperon.model.IncentiveCalculationRequest;
import com.chaperon.model.IncentiveResult;
import com.chaperon.service.IncentiveCalculatorService;
import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/incentive-calculator")
public class IncentiveCalculatorServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String FIND_BUSINESS =
            "SELECT business_id, business_name, " +
            "industry, state, district, project_stage, " +
            "investment_amount, employee_count, " +
            "industrial_area " +
            "FROM businesses " +
            "WHERE user_id = ? " +
            "ORDER BY business_id DESC LIMIT 1";

    private final IncentiveCalculatorService service =
            new IncentiveCalculatorService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("userId")
                == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }

        try {
            long userId = ((Number) session
                    .getAttribute("userId"))
                    .longValue();

            Map<String, Object> business =
                    findBusiness(userId);

            if (business == null) {
                request.setAttribute(
                        "errorMessage",
                        "Complete your business profile first."
                );
            } else {
                request.setAttribute(
                        "business",
                        business
                );
            }

            forward(request, response);

        } catch (Exception exception) {

            exception.printStackTrace();

            throw new ServletException(
                    "Unable to load incentive calculator.",
                    exception
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("userId")
                == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }

        try {
            long userId = ((Number) session
                    .getAttribute("userId"))
                    .longValue();

            Map<String, Object> business =
                    findBusiness(userId);

            if (business == null) {
                request.setAttribute(
                        "errorMessage",
                        "Business profile was not found."
                );

                forward(request, response);
                return;
            }

            IncentiveCalculationRequest input =
                    createRequest(
                            request,
                            userId,
                            business
                    );

            List<IncentiveResult> results =
                    service.calculate(input);

            BigDecimal estimatedTotal =
                    service.calculateTotal(results);

            request.setAttribute(
                    "business",
                    business
            );

            request.setAttribute(
                    "input",
                    input
            );

            request.setAttribute(
                    "results",
                    results
            );

            request.setAttribute(
                    "estimatedTotal",
                    estimatedTotal
            );

            request.setAttribute(
                    "calculationCompleted",
                    true
            );

            forward(request, response);

        } catch (IllegalArgumentException exception) {

            request.setAttribute(
                    "errorMessage",
                    exception.getMessage()
            );

            try {
                long userId = ((Number) session
                        .getAttribute("userId"))
                        .longValue();

                request.setAttribute(
                        "business",
                        findBusiness(userId)
                );

            } catch (Exception ignored) {
                ignored.printStackTrace();
            }

            forward(request, response);

        } catch (Exception exception) {

            exception.printStackTrace();

            throw new ServletException(
                    "Unable to calculate incentives.",
                    exception
            );
        }
    }

    private IncentiveCalculationRequest createRequest(
            HttpServletRequest request,
            long userId,
            Map<String, Object> business) {

        IncentiveCalculationRequest input =
                new IncentiveCalculationRequest();

        input.setUserId(userId);

        input.setBusinessId(
                ((Number) business.get("businessId"))
                        .longValue()
        );

        input.setState(
                stringValue(
                        business.get("state")
                )
        );

        input.setDistrict(
                stringValue(
                        business.get("district")
                )
        );

        input.setIndustry(
                stringValue(
                        business.get("industry")
                )
        );

        input.setEnterpriseCategory(
                requiredParameter(
                        request,
                        "enterpriseCategory"
                ).toUpperCase()
        );

        input.setProjectType(
                requiredParameter(
                        request,
                        "projectType"
                ).toUpperCase()
        );

        input.setTotalInvestment(
                decimalParameter(
                        request,
                        "totalInvestment"
                )
        );

        input.setEnvironmentalInvestment(
                optionalDecimalParameter(
                        request,
                        "environmentalInvestment"
                )
        );

        input.setRenewableEnergyInvestment(
                optionalDecimalParameter(
                        request,
                        "renewableEnergyInvestment"
                )
        );

        input.setEmployeeCount(
                integerParameter(
                        request,
                        "employeeCount"
                )
        );

        input.setWomenEntrepreneur(
                request.getParameter(
                        "womenEntrepreneur"
                ) != null
        );

        input.setScStEntrepreneur(
                request.getParameter(
                        "scStEntrepreneur"
                ) != null
        );

        input.setLocatedInIndustrialArea(
                request.getParameter(
                        "locatedInIndustrialArea"
                ) != null
        );

        return input;
    }

    private Map<String, Object> findBusiness(
            long userId) throws Exception {

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            FIND_BUSINESS
                    )
        ) {
            statement.setLong(1, userId);

            try (ResultSet resultSet =
                    statement.executeQuery()) {

                if (!resultSet.next()) {
                    return null;
                }

                Map<String, Object> business =
                        new HashMap<>();

                business.put(
                        "businessId",
                        resultSet.getLong(
                                "business_id"
                        )
                );

                business.put(
                        "businessName",
                        resultSet.getString(
                                "business_name"
                        )
                );

                business.put(
                        "industry",
                        resultSet.getString(
                                "industry"
                        )
                );

                business.put(
                        "state",
                        resultSet.getString(
                                "state"
                        )
                );

                business.put(
                        "district",
                        resultSet.getString(
                                "district"
                        )
                );

                business.put(
                        "projectStage",
                        resultSet.getString(
                                "project_stage"
                        )
                );

                business.put(
                        "investmentAmount",
                        resultSet.getBigDecimal(
                                "investment_amount"
                        )
                );

                business.put(
                        "employeeCount",
                        resultSet.getInt(
                                "employee_count"
                        )
                );

                business.put(
                        "industrialArea",
                        resultSet.getString(
                                "industrial_area"
                        )
                );

                return business;
            }
        }
    }

    private String requiredParameter(
            HttpServletRequest request,
            String name) {

        String value =
                request.getParameter(name);

        if (value == null
                || value.isBlank()) {

            throw new IllegalArgumentException(
                    name + " is required."
            );
        }

        return value.trim();
    }

    private BigDecimal decimalParameter(
            HttpServletRequest request,
            String name) {

        try {
            BigDecimal value =
                    new BigDecimal(
                            requiredParameter(
                                    request,
                                    name
                            )
                    );

            if (value.compareTo(
                    BigDecimal.ZERO) <= 0) {

                throw new IllegalArgumentException(
                        name
                        + " must be greater than zero."
                );
            }

            return value;

        } catch (NumberFormatException exception) {

            throw new IllegalArgumentException(
                    "Enter a valid amount for "
                    + name + "."
            );
        }
    }

    private BigDecimal optionalDecimalParameter(
            HttpServletRequest request,
            String name) {

        String value =
                request.getParameter(name);

        if (value == null
                || value.isBlank()) {
            return BigDecimal.ZERO;
        }

        try {
            BigDecimal amount =
                    new BigDecimal(value.trim());

            if (amount.compareTo(
                    BigDecimal.ZERO) < 0) {

                throw new IllegalArgumentException(
                        name + " cannot be negative."
                );
            }

            return amount;

        } catch (NumberFormatException exception) {

            throw new IllegalArgumentException(
                    "Enter a valid amount for "
                    + name + "."
            );
        }
    }

    private int integerParameter(
            HttpServletRequest request,
            String name) {

        try {
            int value = Integer.parseInt(
                    requiredParameter(
                            request,
                            name
                    )
            );

            if (value < 0) {
                throw new IllegalArgumentException(
                        name + " cannot be negative."
                );
            }

            return value;

        } catch (NumberFormatException exception) {

            throw new IllegalArgumentException(
                    "Enter a valid number for "
                    + name + "."
            );
        }
    }

    private String stringValue(Object value) {
        return value == null
                ? ""
                : value.toString();
    }

    private void forward(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/entrepreneur/"
                + "incentive-calculator.jsp"
        ).forward(request, response);
    }
}