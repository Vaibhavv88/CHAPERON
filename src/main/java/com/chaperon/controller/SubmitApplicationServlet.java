package com.chaperon.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

import com.chaperon.dao.ApplicationDAO;
import com.chaperon.dao.ApprovalDocumentRequirementDAO;
import com.chaperon.dao.DocumentDAO;

import com.chaperon.dao.impl.ApplicationDAOImpl;
import com.chaperon.dao.impl.ApprovalDocumentRequirementDAOImpl;
import com.chaperon.dao.impl.DocumentDAOImpl;

import com.chaperon.model.Application;
import com.chaperon.model.ApprovalDocumentRequirement;
import com.chaperon.model.Document;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/submit-application")
public class SubmitApplicationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ApplicationDAO applicationDAO;

    private ApprovalDocumentRequirementDAO
            approvalDocumentRequirementDAO;

    private DocumentDAO documentDAO;

    @Override
    public void init() throws ServletException {

        applicationDAO =
                new ApplicationDAOImpl();

        approvalDocumentRequirementDAO =
                new ApprovalDocumentRequirementDAOImpl();

        documentDAO =
                new DocumentDAOImpl();
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

        String applicationIdParameter =
                request.getParameter(
                        "applicationId"
                );

        if (applicationIdParameter == null ||
            applicationIdParameter.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Application ID is required."
            );

            return;
        }

        try {

            long applicationId =
                    Long.parseLong(
                            applicationIdParameter
                    );

            long userId =
                    ((Number) session
                            .getAttribute("userId"))
                            .longValue();

            /*
             * 1. Load application
             */
            Application application =
                    applicationDAO.findById(
                            applicationId
                    );

            if (application == null) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Application not found."
                );

                return;
            }

            /*
             * 2. Ownership check
             */
            if (application.getUserId()
                    != userId) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "You are not allowed to submit this application."
                );

                return;
            }

            /*
             * 3. Only DRAFT can be submitted
             */
            if (!"DRAFT".equalsIgnoreCase(
                    application.getCurrentStatus())) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/entrepreneur/application-details?id="
                        + applicationId
                        + "&submitError=status"
                );

                return;
            }

            /*
             * 4. Mandatory document check
             */
            List<ApprovalDocumentRequirement>
                    requirements =
                    approvalDocumentRequirementDAO
                            .findByApprovalId(
                                    application.getApprovalId()
                            );

            boolean allMandatoryDocumentsReady =
                    true;

            for (ApprovalDocumentRequirement requirement
                    : requirements) {

                if (!requirement.isMandatory()) {
                    continue;
                }

                Document document =
                        documentDAO
                                .findByBusinessIdAndType(
                                        application.getBusinessId(),
                                        requirement.getDocumentType()
                                );

                if (document == null) {

                    allMandatoryDocumentsReady =
                            false;

                    break;
                }

                String verificationStatus =
                        document.getVerificationStatus();

                if ("REJECTED".equalsIgnoreCase(
                        verificationStatus)
                    ||
                    "EXPIRED".equalsIgnoreCase(
                        verificationStatus)) {

                    allMandatoryDocumentsReady =
                            false;

                    break;
                }

                if (document.getExpiryDate()
                        != null) {

                    LocalDate expiryDate =
                            document
                                    .getExpiryDate()
                                    .toLocalDate();

                    if (expiryDate.isBefore(
                            LocalDate.now())) {

                        allMandatoryDocumentsReady =
                                false;

                        break;
                    }
                }
            }

            /*
             * 5. Stop submission if docs not ready
             */
            if (!allMandatoryDocumentsReady) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/entrepreneur/application-details?id="
                        + applicationId
                        + "&submitError=documents"
                );

                return;
            }

            /*
             * 6. Submit properly
             */
            applicationDAO.submitApplication(
                    applicationId,
                    application.getSlaDays()
            );

            /*
             * 7. Redirect
             */
            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur/application-details?id="
                    + applicationId
                    + "&submitted=1"
            );

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid application ID."
            );

        } catch (SQLException e) {

            log(
                    "Unable to submit application",
                    e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to submit application."
            );
        }
    }
}