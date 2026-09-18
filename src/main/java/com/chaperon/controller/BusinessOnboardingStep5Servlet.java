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

@WebServlet("/entrepreneur/business-onboarding/step5")
public class BusinessOnboardingStep5Servlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BusinessService businessService;

    @Override
    public void init()
            throws ServletException {

        businessService =
                new BusinessServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }

        long userId =
                ((Number)
                    session.getAttribute("userId"))
                    .longValue();

        try {

            Business business =
                    businessService
                        .getBusinessByUserId(userId);

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
                    "/WEB-INF/views/entrepreneur/business-onboarding-step5.jsp"
            ).forward(request, response);

        } catch (SQLException e) {

            log(
                    "Unable to load onboarding Step 5",
                    e
            );

            request.setAttribute(
                    "errorMessage",
                    "We could not load this step."
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/business-onboarding-step5.jsp"
            ).forward(request, response);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }

        long userId =
                ((Number)
                    session.getAttribute("userId"))
                    .longValue();

        String hazardous =
                request.getParameter(
                        "hazardousMaterial"
                );

        String boiler =
                request.getParameter(
                        "boilerUsed"
                );

        String waste =
                request.getParameter(
                        "industrialWaste"
                );

        String groundwater =
                request.getParameter(
                        "groundwaterRequired"
                );

        String pollutionCategory =
                request.getParameter(
                        "pollutionCategory"
                );

        String handlesPersonalData =
                request.getParameter(
                        "handlesPersonalData"
                );

        String seeksStpiBenefits =
                request.getParameter(
                        "seeksStpiBenefits"
                );

        String locatedInSez =
                request.getParameter(
                        "locatedInSez"
                );

        String certInApplicable =
                request.getParameter(
                        "certInApplicable"
                );

        String seeksTrademarkProtection =
                request.getParameter(
                        "seeksTrademarkProtection"
                );

        String seeksSoftwareCopyright =
                request.getParameter(
                        "seeksSoftwareCopyright"
                );

        if (hazardous == null ||
            boiler == null ||
            waste == null ||
            groundwater == null ||
            handlesPersonalData == null ||
            seeksStpiBenefits == null ||
            locatedInSez == null ||
            certInApplicable == null ||
            seeksTrademarkProtection == null ||
            seeksSoftwareCopyright == null ||
            pollutionCategory == null ||
            pollutionCategory.isBlank()) {

            request.setAttribute(
                    "errorMessage",
                    "Please answer all required questions."
            );

            doGet(request, response);

            return;
        }

        try {

            Business business =
                    businessService
                        .getBusinessByUserId(userId);

            if (business == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/entrepreneur/business-onboarding"
                );

                return;
            }

            business.setHazardousMaterial(
                    "YES".equalsIgnoreCase(
                            hazardous
                    )
            );

            business.setBoilerUsed(
                    "YES".equalsIgnoreCase(
                            boiler
                    )
            );

            business.setIndustrialWaste(
                    "YES".equalsIgnoreCase(
                            waste
                    )
            );

            business.setGroundwaterRequired(
                    "YES".equalsIgnoreCase(
                            groundwater
                    )
            );

            business.setPollutionCategory(
                    pollutionCategory.trim()
            );

            business.setHandlesPersonalData(
                    isYes(handlesPersonalData)
            );

            business.setSeeksStpiBenefits(
                    isYes(seeksStpiBenefits)
            );

            business.setLocatedInSez(
                    isYes(locatedInSez)
            );

            business.setCertInApplicable(
                    isYes(certInApplicable)
            );

            business.setSeeksTrademarkProtection(
                    isYes(seeksTrademarkProtection)
            );

            business.setSeeksSoftwareCopyright(
                    isYes(seeksSoftwareCopyright)
            );

            boolean businessUpdated =
                    businessService
                        .updateBusiness(business);

            if (!businessUpdated) {

                request.setAttribute(
                        "errorMessage",
                        "Your compliance details could not be saved."
                );

                request.setAttribute(
                        "business",
                        business
                );

                request.getRequestDispatcher(
                        "/WEB-INF/views/entrepreneur/business-onboarding-step5.jsp"
                ).forward(request, response);

                return;
            }

            boolean onboardingCompleted =
                    businessService
                        .completeOnboarding(
                                userId,
                                business.getBusinessId()
                        );

            if (!onboardingCompleted) {

                request.setAttribute(
                        "errorMessage",
                        "Your profile was saved, but completion status could not be updated."
                );

                request.setAttribute(
                        "business",
                        business
                );

                request.getRequestDispatcher(
                        "/WEB-INF/views/entrepreneur/business-onboarding-step5.jsp"
                ).forward(request, response);

                return;
            }

            session.setAttribute(
                    "businessId",
                    business.getBusinessId()
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur/business-profile-complete"
            );

        } catch (SQLException e) {

            log(
                    "Unable to save onboarding Step 5",
                    e
            );

            request.setAttribute(
                    "errorMessage",
                    "Something went wrong while completing your profile."
            );

            doGet(request, response);
        }
    }

    private boolean isYes(String value) {

        return "YES".equalsIgnoreCase(value) ||
               "TRUE".equalsIgnoreCase(value) ||
               "ON".equalsIgnoreCase(value);
    }
}
