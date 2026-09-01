package com.chaperon.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.Year;
import java.util.List;

import com.chaperon.dao.ApplicationDAO;
import com.chaperon.dao.ApprovalDAO;
import com.chaperon.dao.ApprovalDocumentRequirementDAO;
import com.chaperon.dao.DocumentDAO;

import com.chaperon.dao.impl.ApplicationDAOImpl;
import com.chaperon.dao.impl.ApprovalDAOImpl;
import com.chaperon.dao.impl.ApprovalDocumentRequirementDAOImpl;
import com.chaperon.dao.impl.DocumentDAOImpl;

import com.chaperon.model.Application;
import com.chaperon.model.Approval;
import com.chaperon.model.ApprovalDocumentRequirement;
import com.chaperon.model.Business;
import com.chaperon.model.Document;

import com.chaperon.service.BusinessService;
import com.chaperon.service.impl.BusinessServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/start-application")
public class StartApplicationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ApplicationDAO applicationDAO;
    private ApprovalDAO approvalDAO;
    private ApprovalDocumentRequirementDAO
            approvalDocumentRequirementDAO;
    private DocumentDAO documentDAO;
    private BusinessService businessService;

    @Override
    public void init() throws ServletException {

        applicationDAO =
                new ApplicationDAOImpl();

        approvalDAO =
                new ApprovalDAOImpl();

        approvalDocumentRequirementDAO =
                new ApprovalDocumentRequirementDAOImpl();

        documentDAO =
                new DocumentDAOImpl();

        businessService =
                new BusinessServiceImpl();
    }

    @Override
    protected void doPost(
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

        String approvalIdParameter =
                request.getParameter("approvalId");

        if (approvalIdParameter == null ||
            approvalIdParameter.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Approval ID is required."
            );

            return;
        }

        try {

            long approvalId =
                    Long.parseLong(
                            approvalIdParameter
                    );

            long userId =
                    ((Number) session
                            .getAttribute("userId"))
                            .longValue();

            /*
             * 1. Load approval
             */
            Approval approval =
                    approvalDAO.findApprovalById(
                            approvalId
                    );

            if (approval == null) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Approval not found."
                );

                return;
            }

            /*
             * 2. Load business
             */
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

            long businessId =
                    business.getBusinessId();

            /*
             * 3. Check mandatory document readiness
             */
            List<ApprovalDocumentRequirement>
                    requirements =
                    approvalDocumentRequirementDAO
                            .findByApprovalId(
                                    approvalId
                            );

            boolean allMandatoryDocumentsReady =
                    true;

            for (ApprovalDocumentRequirement requirement
                    : requirements) {

                if (!requirement.isMandatory()) {
                    continue;
                }

                Document uploadedDocument =
                        documentDAO
                                .findByBusinessIdAndType(
                                        businessId,
                                        requirement.getDocumentType()
                                );

                if (uploadedDocument == null) {

                    allMandatoryDocumentsReady =
                            false;

                    break;
                }

                String verificationStatus =
                        uploadedDocument
                                .getVerificationStatus();

                if ("REJECTED".equalsIgnoreCase(
                        verificationStatus)
                    ||
                    "EXPIRED".equalsIgnoreCase(
                        verificationStatus)) {

                    allMandatoryDocumentsReady =
                            false;

                    break;
                }
            }

            if (!allMandatoryDocumentsReady) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/entrepreneur/approval-details?id="
                        + approvalId
                        + "&applicationError=documents"
                );

                return;
            }

            /*
             * 4. Prevent duplicate active application
             */
            Application existingApplication =
                    applicationDAO
                            .findActiveByBusinessAndApproval(
                                    businessId,
                                    approvalId
                            );

            if (existingApplication != null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/entrepreneur/application-details?id="
                        + existingApplication.getApplicationId()
                );

                return;
            }

            /*
             * 5. Create application number
             */
            String approvalCode =
                    approval.getApprovalCode();

            if (approvalCode == null ||
                approvalCode.isBlank()) {

                approvalCode =
                        "APP";
            }

            approvalCode =
                    approvalCode
                            .replaceAll(
                                    "[^A-Za-z0-9]",
                                    ""
                            )
                            .toUpperCase();

            String year =
                    String.valueOf(
                            Year.now().getValue()
                    );

            /*
             * Temporary unique suffix.
             * Later we can improve this with sequence logic.
             */
            String suffix =
                    String.valueOf(
                            System.currentTimeMillis()
                    );

            if (suffix.length() > 6) {

                suffix =
                        suffix.substring(
                                suffix.length() - 6
                        );
            }

            String applicationNumber =
                    "CHP-"
                    + approvalCode
                    + "-"
                    + year
                    + "-"
                    + suffix;

            /*
             * 6. Create DRAFT application
             */
            Application application =
                    new Application();

            application.setApplicationNumber(
                    applicationNumber
            );

            application.setUserId(
                    userId
            );

            application.setBusinessId(
                    businessId
            );

            application.setApprovalId(
                    approvalId
            );

            application.setDepartmentId(
                    approval.getDepartmentId()
            );

            application.setCurrentStatus(
                    "DRAFT"
            );

            application.setSlaDays(
                    approval.getSlaDays()
            );

            application.setRiskLevel(
                    "LOW"
            );

            application.setCanReapply(
                    true
            );

            long applicationId =
                    applicationDAO.save(
                            application
                    );

            if (applicationId <= 0) {

                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Unable to create application."
                );

                return;
            }

            /*
             * 7. Redirect to application details
             */
            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur/application-details?id="
                    + applicationId
            );

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid approval ID."
            );

        } catch (SQLException e) {

            log(
                    "Unable to start application",
                    e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to start application."
            );
        }
    }
}