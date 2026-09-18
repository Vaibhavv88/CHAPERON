package com.chaperon.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.ApprovalDependency;
import com.chaperon.model.Business;
import com.chaperon.service.ApprovalJourneyService;
import com.chaperon.service.BusinessService;
import com.chaperon.service.impl.ApprovalJourneyServiceImpl;
import com.chaperon.service.impl.BusinessServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/approval-journey")
public class EntrepreneurApprovalJourneyServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ApprovalJourneyService approvalJourneyService;

    private BusinessService businessService;


    @Override
    public void init() throws ServletException {

        approvalJourneyService =
                new ApprovalJourneyServiceImpl();

        businessService =
                new BusinessServiceImpl();
    }


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);


        /*
         * ============================================================
         * 1. SESSION CHECK
         * ============================================================
         */
        if (session == null
                ||
                session.getAttribute("userId") == null
                ||
                session.getAttribute("userRole") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }


        /*
         * ============================================================
         * 2. ROLE CHECK
         * ============================================================
         */
        String userRole =
                String.valueOf(
                        session.getAttribute("userRole")
                );


        if (!"ENTREPRENEUR".equalsIgnoreCase(
                userRole)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "This page is only available for entrepreneurs."
            );

            return;
        }


        try {

            /*
             * ========================================================
             * 3. GET USER ID FROM SESSION
             * ========================================================
             */
            long userId =
                    ((Number)
                    session.getAttribute("userId"))
                    .longValue();


            /*
             * ========================================================
             * 4. LOAD ENTREPRENEUR BUSINESS
             * ========================================================
             */
            Business business =
                    businessService
                            .getBusinessByUserId(
                                    userId
                            );


            /*
             * ========================================================
             * 5. BUSINESS PROFILE NOT FOUND
             * ========================================================
             */
            if (business == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/entrepreneur/business-onboarding"
                );

                return;
            }


            long businessId =
                    business.getBusinessId();


            /*
             * ========================================================
             * 6. COMPLETE APPROVAL JOURNEY
             * ========================================================
             */
            List<ApprovalDependency> journey =
                    approvalJourneyService
                            .getBusinessJourney(
                                    businessId
                            );


            /*
             * ========================================================
             * 7. PARALLEL APPROVALS
             * ========================================================
             */
            List<ApprovalDependency> parallelApprovals =
                    approvalJourneyService
                            .getParallelApprovals(
                                    businessId
                            );


            /*
             * ========================================================
             * 8. CONDITIONAL APPROVALS
             * ========================================================
             */
            List<ApprovalDependency> conditionalApprovals =
                    approvalJourneyService
                            .getConditionalApprovals(
                                    businessId
                            );


            /*
             * ========================================================
             * 9. DEPENDENT / SEQUENTIAL APPROVALS
             * ========================================================
             */
            List<ApprovalDependency> dependentApprovals =
                    approvalJourneyService
                            .getDependentApprovals(
                                    businessId
                            );


            /*
             * ========================================================
             * 10. SEND DATA TO JSP
             * ========================================================
             */
            request.setAttribute(
                    "business",
                    business
            );

            request.setAttribute(
                    "journey",
                    journey
            );

            request.setAttribute(
                    "parallelApprovals",
                    parallelApprovals
            );

            request.setAttribute(
                    "conditionalApprovals",
                    conditionalApprovals
            );

            request.setAttribute(
                    "dependentApprovals",
                    dependentApprovals
            );


            /*
             * ========================================================
             * 11. SUMMARY COUNTS
             * ========================================================
             */
            request.setAttribute(
                    "totalRelationships",
                    journey == null
                            ? 0
                            : journey.size()
            );

            request.setAttribute(
                    "parallelCount",
                    parallelApprovals == null
                            ? 0
                            : parallelApprovals.size()
            );

            request.setAttribute(
                    "conditionalCount",
                    conditionalApprovals == null
                            ? 0
                            : conditionalApprovals.size()
            );

            request.setAttribute(
                    "dependentCount",
                    dependentApprovals == null
                            ? 0
                            : dependentApprovals.size()
            );


            /*
             * ========================================================
             * 12. OPEN JOURNEY OPTIMIZER JSP
             * ========================================================
             */
            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/approval-journey.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (SQLException e) {

            log(
                    "Unable to load approval journey.",
                    e
            );

            throw new ServletException(
                    "Unable to load approval journey.",
                    e
            );


        } catch (ClassCastException e) {

            log(
                    "Invalid entrepreneur session data.",
                    e
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );
        }
    }
}