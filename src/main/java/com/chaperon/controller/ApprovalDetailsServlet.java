package com.chaperon.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.ApplicationDAO;
import com.chaperon.dao.ApprovalDAO;
import com.chaperon.dao.ApprovalDocumentRequirementDAO;
import com.chaperon.dao.BusinessApprovalDAO;
import com.chaperon.dao.BusinessDAO;
import com.chaperon.dao.DocumentDAO;

import com.chaperon.dao.impl.ApplicationDAOImpl;
import com.chaperon.dao.impl.ApprovalDAOImpl;
import com.chaperon.dao.impl.ApprovalDocumentRequirementDAOImpl;
import com.chaperon.dao.impl.BusinessApprovalDAOImpl;
import com.chaperon.dao.impl.BusinessDAOImpl;
import com.chaperon.dao.impl.DocumentDAOImpl;

import com.chaperon.model.Application;
import com.chaperon.model.Approval;
import com.chaperon.model.ApprovalDocumentRequirement;
import com.chaperon.model.Business;
import com.chaperon.model.BusinessApproval;
import com.chaperon.model.Document;
import com.chaperon.model.DocumentReadiness;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/approval-details")
public class ApprovalDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ApprovalDAO approvalDAO;
    private BusinessDAO businessDAO;
    private BusinessApprovalDAO businessApprovalDAO;
    private ApprovalDocumentRequirementDAO approvalDocumentRequirementDAO;
    private DocumentDAO documentDAO;
    private ApplicationDAO applicationDAO;

    @Override
    public void init() throws ServletException {

        approvalDAO =
                new ApprovalDAOImpl();

        businessDAO =
                new BusinessDAOImpl();

        businessApprovalDAO =
                new BusinessApprovalDAOImpl();

        approvalDocumentRequirementDAO =
                new ApprovalDocumentRequirementDAOImpl();

        documentDAO =
                new DocumentDAOImpl();

        applicationDAO =
                new ApplicationDAOImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        /*
         * ============================================
         * 1. SESSION CHECK
         * ============================================
         */

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null ||
            session.getAttribute("userRole") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }

        if (!"ENTREPRENEUR".equalsIgnoreCase(
                String.valueOf(
                        session.getAttribute("userRole")
                )
        )) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "This page is only available for entrepreneurs."
            );

            return;
        }


        /*
         * ============================================
         * 2. APPROVAL ID CHECK
         * ============================================
         */

        String approvalIdParameter =
                request.getParameter("id");

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
                    ((Number)
                    session.getAttribute("userId"))
                    .longValue();


            /*
             * ============================================
             * 3. LOAD APPROVAL
             * ============================================
             */

            Approval approval =
                    approvalDAO
                            .findApprovalById(
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
             * ============================================
             * 4. LOAD CURRENT USER BUSINESS
             * ============================================
             */

            Business business =
                    businessDAO
                            .findByUserId(
                                    userId
                            );

            if (business == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/entrepreneur/business-onboarding"
                );

                return;
            }


            /*
             * ============================================
             * 5. LOAD BUSINESS APPROVAL
             * ============================================
             */

            BusinessApproval businessApproval =
                    businessApprovalDAO
                            .findByBusinessAndApproval(
                                    business.getBusinessId(),
                                    approvalId
                            );


            /*
             * ============================================
             * 6. LOAD REQUIRED DOCUMENTS
             * ============================================
             */

            List<ApprovalDocumentRequirement>
                    requirements =
                    approvalDocumentRequirementDAO
                            .findByApprovalId(
                                    approvalId
                            );


            /*
             * ============================================
             * 7. BUILD DOCUMENT READINESS
             * ============================================
             */

            List<DocumentReadiness>
                    documentReadinessList =
                    new ArrayList<>();

            int totalMandatoryDocuments = 0;
            int readyMandatoryDocuments = 0;

            for (
                ApprovalDocumentRequirement requirement
                : requirements
            ) {

                DocumentReadiness readiness =
                        new DocumentReadiness();

                readiness.setDocumentType(
                        requirement.getDocumentType()
                );

                readiness.setDescription(
                        requirement.getDescription()
                );

                readiness.setMandatory(
                        requirement.isMandatory()
                );

                if (requirement.isMandatory()) {

                    totalMandatoryDocuments++;
                }


                Document uploadedDocument =
                        documentDAO
                                .findByBusinessIdAndType(
                                        business.getBusinessId(),
                                        requirement.getDocumentType()
                                );


                if (uploadedDocument == null) {

                    readiness.setStatus(
                            "MISSING"
                    );

                } else {

                    readiness.setUploadedDocumentId(
                            uploadedDocument
                                    .getDocumentId()
                    );

                    readiness.setUploadedFileName(
                            uploadedDocument
                                    .getOriginalFileName()
                    );

                    String verificationStatus =
                            uploadedDocument
                                    .getVerificationStatus();

                    boolean expiredByDate =
                            false;

                    if (uploadedDocument
                            .getExpiryDate() != null) {

                        LocalDate expiryDate =
                                uploadedDocument
                                        .getExpiryDate()
                                        .toLocalDate();

                        expiredByDate =
                                expiryDate.isBefore(
                                        LocalDate.now()
                                );
                    }


                    if (expiredByDate) {

                        readiness.setStatus(
                                "EXPIRED"
                        );

                    } else if (
                            "REJECTED"
                            .equalsIgnoreCase(
                                    verificationStatus
                            )
                    ) {

                        readiness.setStatus(
                                "REJECTED"
                        );

                    } else if (
                            "EXPIRED"
                            .equalsIgnoreCase(
                                    verificationStatus
                            )
                    ) {

                        readiness.setStatus(
                                "EXPIRED"
                        );

                    } else {

                        readiness.setStatus(
                                "READY"
                        );

                        if (requirement
                                .isMandatory()) {

                            readyMandatoryDocuments++;
                        }
                    }
                }

                documentReadinessList.add(
                        readiness
                );
            }


            /*
             * ============================================
             * 8. CALCULATE READINESS
             * ============================================
             */

            int readinessPercentage;

            if (totalMandatoryDocuments == 0) {

                readinessPercentage = 100;

            } else {

                readinessPercentage =
                        (readyMandatoryDocuments * 100)
                        / totalMandatoryDocuments;
            }


            /*
             * ============================================
             * 9. FIND EXISTING APPLICATION
             * ============================================
             *
             * Ye important fix hai.
             *
             * Agar application already:
             *
             * DRAFT
             * SUBMITTED
             * UNDER_REVIEW
             * QUERY_RAISED
             *
             * etc. me exist karti hai,
             * to Start Application dobara nahi dikhega.
             */

            Application currentApplication =
                    applicationDAO
                            .findActiveByBusinessAndApproval(
                                    business.getBusinessId(),
                                    approvalId
                            );


            /*
             * ============================================
             * 10. SEND DATA TO JSP
             * ============================================
             */

            request.setAttribute(
                    "approval",
                    approval
            );

            request.setAttribute(
                    "business",
                    business
            );

            request.setAttribute(
                    "businessApproval",
                    businessApproval
            );

            request.setAttribute(
                    "documentReadinessList",
                    documentReadinessList
            );

            request.setAttribute(
                    "readinessPercentage",
                    readinessPercentage
            );

            request.setAttribute(
                    "currentApplication",
                    currentApplication
            );


            /*
             * ============================================
             * 11. OPEN JSP
             * ============================================
             */

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/approval-details.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid approval ID."
            );


        } catch (SQLException e) {

            log(
                    "Unable to load approval details.",
                    e
            );

            response.sendError(
                    HttpServletResponse
                            .SC_INTERNAL_SERVER_ERROR,
                    "Unable to load approval details."
            );
        }
    }
}