package com.chaperon.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.chaperon.dao.ApprovalDAO;
import com.chaperon.dao.impl.ApprovalDAOImpl;
import com.chaperon.model.Approval;
import com.chaperon.model.ApprovalRule;
import com.chaperon.model.Business;
import com.chaperon.model.BusinessApproval;
import com.chaperon.service.ApprovalRecommendationService;
import com.chaperon.service.BusinessService;
import com.chaperon.service.impl.ApprovalRecommendationServiceImpl;
import com.chaperon.service.impl.BusinessServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/what-if-simulator")
public class WhatIfSimulatorServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BusinessService businessService;
    private ApprovalRecommendationService approvalRecommendationService;
    private ApprovalDAO approvalDAO;

    @Override
    public void init() throws ServletException {

        businessService =
                new BusinessServiceImpl();

        approvalRecommendationService =
                new ApprovalRecommendationServiceImpl();

        approvalDAO =
                new ApprovalDAOImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (!isValidEntrepreneurSession(session)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }

        try {

            long userId =
                    ((Number)
                    session.getAttribute("userId"))
                    .longValue();

            Business business =
                    businessService
                            .getBusinessByUserId(
                                    userId
                            );

            if (business == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/entrepreneur/business-onboarding"
                );

                return;
            }

            List<BusinessApproval> currentApprovals =
                    approvalRecommendationService
                            .getRecommendations(
                                    userId
                            );

            request.setAttribute(
                    "business",
                    business
            );

            request.setAttribute(
                    "currentApprovals",
                    currentApprovals
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/what-if-simulator.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load What-If Simulator.",
                    e
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session =
                request.getSession(false);

        if (!isValidEntrepreneurSession(session)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }

        try {

            long userId =
                    ((Number)
                    session.getAttribute("userId"))
                    .longValue();

            Business currentBusiness =
                    businessService
                            .getBusinessByUserId(
                                    userId
                            );

            if (currentBusiness == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/entrepreneur/business-onboarding"
                );

                return;
            }

            List<BusinessApproval> currentApprovals =
                    approvalRecommendationService
                            .getRecommendations(
                                    userId
                            );

            /*
             * IMPORTANT:
             * currentBusiness is only a Java object loaded from DB.
             * We are NOT calling updateBusiness().
             *
             * Therefore simulator changes are temporary only.
             */

            applySimulationInputs(
                    request,
                    currentBusiness
            );

            List<BusinessApproval> simulatedApprovals =
                    simulateApprovals(
                            currentBusiness
                    );

            List<BusinessApproval> addedApprovals =
                    new ArrayList<>();

            List<BusinessApproval> removedApprovals =
                    new ArrayList<>();

            List<BusinessApproval> unchangedApprovals =
                    new ArrayList<>();

            Set<Long> currentIds =
                    new HashSet<>();

            Set<Long> simulatedIds =
                    new HashSet<>();

            if (currentApprovals != null) {

                for (BusinessApproval approval
                        : currentApprovals) {

                    currentIds.add(
                            approval.getApprovalId()
                    );
                }
            }

            if (simulatedApprovals != null) {

                for (BusinessApproval approval
                        : simulatedApprovals) {

                    simulatedIds.add(
                            approval.getApprovalId()
                    );

                    if (currentIds.contains(
                            approval.getApprovalId())) {

                        unchangedApprovals.add(
                                approval
                        );

                    } else {

                        addedApprovals.add(
                                approval
                        );
                    }
                }
            }

            if (currentApprovals != null) {

                for (BusinessApproval approval
                        : currentApprovals) {

                    if (!simulatedIds.contains(
                            approval.getApprovalId())) {

                        removedApprovals.add(
                                approval
                        );
                    }
                }
            }

            request.setAttribute(
                    "business",
                    currentBusiness
            );

            request.setAttribute(
                    "currentApprovals",
                    currentApprovals
            );

            request.setAttribute(
                    "simulatedApprovals",
                    simulatedApprovals
            );

            request.setAttribute(
                    "addedApprovals",
                    addedApprovals
            );

            request.setAttribute(
                    "removedApprovals",
                    removedApprovals
            );

            request.setAttribute(
                    "unchangedApprovals",
                    unchangedApprovals
            );

            request.setAttribute(
                    "simulationPerformed",
                    true
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/what-if-simulator.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to simulate approval changes.",
                    e
            );

        } catch (NumberFormatException e) {

            request.setAttribute(
                    "simulationError",
                    "Please enter valid numeric values."
            );

            doGet(
                    request,
                    response
            );
        }
    }

    private boolean isValidEntrepreneurSession(
            HttpSession session) {

        if (session == null
                ||
                session.getAttribute("userId") == null
                ||
                session.getAttribute("userRole") == null) {

            return false;
        }

        return "ENTREPRENEUR"
                .equalsIgnoreCase(
                        String.valueOf(
                                session.getAttribute(
                                        "userRole"
                                )
                        )
                );
    }

    private void applySimulationInputs(
            HttpServletRequest request,
            Business business) {

        String industry =
                clean(
                        request.getParameter(
                                "industry"
                        )
                );

        String projectStage =
                clean(
                        request.getParameter(
                                "projectStage"
                        )
                );

        String pollutionCategory =
                clean(
                        request.getParameter(
                                "pollutionCategory"
                        )
                );

        String employeeCount =
                clean(
                        request.getParameter(
                                "employeeCount"
                        )
                );

        String investmentAmount =
                clean(
                        request.getParameter(
                                "investmentAmount"
                        )
                );

        String annualTurnover =
                clean(
                        request.getParameter(
                                "annualTurnover"
                        )
                );

        if (industry != null) {

            business.setIndustry(
                    industry
            );
        }

        if (projectStage != null) {

            business.setProjectStage(
                    projectStage
            );
        }

        if (pollutionCategory != null) {

            business.setPollutionCategory(
                    pollutionCategory
            );
        }

        if (employeeCount != null) {

            business.setEmployeeCount(
                    Integer.parseInt(
                            employeeCount
                    )
            );
        }

        if (investmentAmount != null) {

            business.setInvestmentAmount(
                    new BigDecimal(
                            investmentAmount
                    )
            );
        }

        if (annualTurnover != null) {

            business.setAnnualTurnover(
                    new BigDecimal(annualTurnover)
            );
        }

        business.setHazardousMaterial(
                "YES".equalsIgnoreCase(
                        request.getParameter(
                                "hazardousMaterial"
                        )
                )
        );

        business.setBoilerUsed(
                "YES".equalsIgnoreCase(
                        request.getParameter(
                                "boilerUsed"
                        )
                )
        );

        business.setIndustrialWaste(
                "YES".equalsIgnoreCase(
                        request.getParameter(
                                "industrialWaste"
                        )
                )
        );

        business.setGroundwaterRequired(
                "YES".equalsIgnoreCase(
                        request.getParameter(
                                "groundwaterRequired"
                        )
                )
        );

        applyOptionalBoolean(request, "interstateSupply",
                business::setInterstateSupply);
        applyOptionalBoolean(request, "handlesPersonalData",
                business::setHandlesPersonalData);
        applyOptionalBoolean(request, "seeksStpiBenefits",
                business::setSeeksStpiBenefits);
        applyOptionalBoolean(request, "locatedInSez",
                business::setLocatedInSez);
        applyOptionalBoolean(request, "certInApplicable",
                business::setCertInApplicable);
        applyOptionalBoolean(request, "seeksTrademarkProtection",
                business::setSeeksTrademarkProtection);
        applyOptionalBoolean(request, "seeksSoftwareCopyright",
                business::setSeeksSoftwareCopyright);
    }

    private List<BusinessApproval> simulateApprovals(
            Business business)
            throws SQLException {

        List<BusinessApproval> result =
                new ArrayList<>();

        List<ApprovalRule> rules =
                approvalDAO
                        .findActiveRules();

        if (rules == null) {

            return result;
        }

        Set<Long> addedApprovalIds =
                new HashSet<>();

        for (ApprovalRule rule : rules) {

            if (rule == null) {
                continue;
            }

            if (!matches(
                    business,
                    rule)) {

                continue;
            }

            if (addedApprovalIds.contains(
                    rule.getApprovalId())) {

                continue;
            }

            Approval approval =
                    approvalDAO
                            .findApprovalById(
                                    rule.getApprovalId()
                            );

            if (approval == null
                    || !approval.isActive()) {

                continue;
            }

            BusinessApproval simulated =
                    new BusinessApproval();

            simulated.setBusinessId(
                    business.getBusinessId()
            );

            simulated.setApprovalId(
                    approval.getApprovalId()
            );

            simulated.setApprovalName(
                    approval.getApprovalName()
            );

            simulated.setApprovalCode(
                    approval.getApprovalCode()
            );

            simulated.setRequirementStatus(
                    "REQUIRED"
            );

            simulated.setPriorityLevel(
                    defaultText(
                            rule.getPriorityLevel(),
                            "MEDIUM"
                    )
            );

            simulated.setReasonText(
                    defaultText(
                            rule.getReasonText(),
                            "Applicable under the simulated business scenario."
                    )
            );

            simulated.setCurrentStatus(
                    "SIMULATED"
            );

            simulated.setMandatory(
                    true
            );

            result.add(
                    simulated
            );

            addedApprovalIds.add(
                    rule.getApprovalId()
            );
        }

        return result;
    }

    /*
     * =========================================================
     * SAME RULE MATCHING LOGIC AS CURRENT RECOMMENDATION ENGINE
     * =========================================================
     */

    private boolean matches(
            Business business,
            ApprovalRule rule) {

        if (!matchesText(
                rule.getIndustry(),
                business.getIndustry())) {

            return false;
        }

        if (!matchesText(
                rule.getBusinessConstitution(),
                business.getBusinessConstitution())) {

            return false;
        }

        if (!matchesText(
                rule.getBusinessActivity(),
                business.getBusinessActivity())) {

            return false;
        }

        if (!matchesText(
                rule.getProjectStage(),
                business.getProjectStage())) {

            return false;
        }

        if (!matchesText(
                rule.getState(),
                business.getState())) {

            return false;
        }

        if (!matchesText(
                rule.getPollutionCategory(),
                business.getPollutionCategory())) {

            return false;
        }

        if (!matchesEmployeeCount(
                business,
                rule)) {

            return false;
        }

        if (!matchesInvestment(
                business,
                rule)) {

            return false;
        }

        if (!matchesAnnualTurnover(business, rule)) {
            return false;
        }

        if (!matchesBoolean(rule.getInterstateSupplyRequired(), business.isInterstateSupply())
                || !matchesBoolean(rule.getHandlesPersonalDataRequired(), business.isHandlesPersonalData())
                || !matchesBoolean(rule.getStpiBenefitsRequired(), business.isSeeksStpiBenefits())
                || !matchesBoolean(rule.getSezUnitRequired(), business.isLocatedInSez())
                || !matchesBoolean(rule.getCertInApplicabilityRequired(), business.isCertInApplicable())
                || !matchesBoolean(rule.getTrademarkProtectionRequired(), business.isSeeksTrademarkProtection())
                || !matchesBoolean(rule.getSoftwareCopyrightRequired(), business.isSeeksSoftwareCopyright())) {

            return false;
        }

        if (!matchesBoolean(
                rule.getHazardousMaterialRequired(),
                business.isHazardousMaterial())) {

            return false;
        }

        if (!matchesBoolean(
                rule.getBoilerRequired(),
                business.isBoilerUsed())) {

            return false;
        }

        if (!matchesBoolean(
                rule.getIndustrialWasteRequired(),
                business.isIndustrialWaste())) {

            return false;
        }

        if (!matchesBoolean(
                rule.getGroundwaterRequired(),
                business.isGroundwaterRequired())) {

            return false;
        }

        return true;
    }

    private boolean matchesText(
            String ruleValue,
            String businessValue) {

        if (ruleValue == null
                || ruleValue.isBlank()) {

            return true;
        }

        if (businessValue == null
                || businessValue.isBlank()) {

            return false;
        }

        return ruleValue
                .trim()
                .equalsIgnoreCase(
                        businessValue.trim()
                );
    }

    private boolean matchesEmployeeCount(
            Business business,
            ApprovalRule rule) {

        int employeeCount =
                business.getEmployeeCount();

        Integer minimum =
                rule.getMinimumEmployees();

        Integer maximum =
                rule.getMaximumEmployees();

        if (minimum != null
                && employeeCount < minimum) {

            return false;
        }

        if (maximum != null
                && employeeCount > maximum) {

            return false;
        }

        return true;
    }

    private boolean matchesInvestment(
            Business business,
            ApprovalRule rule) {

        BigDecimal minimum =
                rule.getMinimumInvestment();

        BigDecimal maximum =
                rule.getMaximumInvestment();

        if (minimum == null
                && maximum == null) {

            return true;
        }

        BigDecimal investment =
                business.getInvestmentAmount();

        if (investment == null) {

            return false;
        }

        if (minimum != null
                && investment.compareTo(
                        minimum) < 0) {

            return false;
        }

        if (maximum != null
                && investment.compareTo(
                        maximum) > 0) {

            return false;
        }

        return true;
    }

    private boolean matchesBoolean(
            Boolean ruleValue,
            boolean businessValue) {

        if (ruleValue == null) {

            return true;
        }

        return ruleValue.booleanValue()
                == businessValue;
    }

    private boolean matchesAnnualTurnover(
            Business business,
            ApprovalRule rule) {

        BigDecimal minimum =
                rule.getMinimumAnnualTurnover();

        BigDecimal maximum =
                rule.getMaximumAnnualTurnover();

        if (minimum == null && maximum == null) {
            return true;
        }

        BigDecimal annualTurnover =
                business.getAnnualTurnover();

        if (annualTurnover == null) {
            return false;
        }

        return (minimum == null ||
                annualTurnover.compareTo(minimum) >= 0) &&
               (maximum == null ||
                annualTurnover.compareTo(maximum) <= 0);
    }

    private void applyOptionalBoolean(
            HttpServletRequest request,
            String parameterName,
            java.util.function.Consumer<Boolean> setter) {

        String value = request.getParameter(parameterName);

        if (value != null) {
            setter.accept(
                    "YES".equalsIgnoreCase(value) ||
                    "TRUE".equalsIgnoreCase(value) ||
                    "ON".equalsIgnoreCase(value)
            );
        }
    }

    private String clean(
            String value) {

        if (value == null
                || value.isBlank()) {

            return null;
        }

        return value.trim();
    }

    private String defaultText(
            String value,
            String defaultValue) {

        if (value == null
                || value.isBlank()) {

            return defaultValue;
        }

        return value;
    }
}
