package com.chaperon.controller;

import java.io.IOException;

import java.sql.Connection;

import java.sql.Date;

import java.sql.PreparedStatement;

import java.sql.ResultSet;

import java.sql.SQLException;

import java.sql.Timestamp;

import java.time.LocalDate;

import java.util.ArrayList;

import java.util.List;

import com.chaperon.dao.ApplicationDAO;

import com.chaperon.dao.ApprovalDAO;

import com.chaperon.dao.ApprovalDocumentRequirementDAO;

import com.chaperon.dao.BusinessDAO;

import com.chaperon.dao.DocumentDAO;

import com.chaperon.dao.impl.ApplicationDAOImpl;

import com.chaperon.dao.impl.ApprovalDAOImpl;

import com.chaperon.dao.impl.ApprovalDocumentRequirementDAOImpl;

import com.chaperon.dao.impl.BusinessDAOImpl;

import com.chaperon.dao.impl.DocumentDAOImpl;

import com.chaperon.model.Application;

import com.chaperon.model.Approval;

import com.chaperon.model.ApprovalDocumentRequirement;

import com.chaperon.model.Business;

import com.chaperon.model.Document;

import com.chaperon.model.DocumentReadiness;

import com.chaperon.model.SubmissionRiskResult;

import com.chaperon.service.AIRiskExplanationService;

import com.chaperon.service.SLAService;

import com.chaperon.service.SubmissionRiskService;

import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;

import jakarta.servlet.http.HttpServletRequest;

import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.http.HttpSession;



@WebServlet("/entrepreneur/application-details")

public class ApplicationDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;



    private ApplicationDAO applicationDAO;

    private ApprovalDAO approvalDAO;

    private ApprovalDocumentRequirementDAO

            approvalDocumentRequirementDAO;

    private DocumentDAO documentDAO;

    private BusinessDAO businessDAO;

    private SLAService slaService;

    private SubmissionRiskService submissionRiskService;

    private AIRiskExplanationService aiRiskExplanationService;



    /*

     * =====================================================

     * LATEST QUERY

     * =====================================================

     */

    private static final String FIND_LATEST_QUERY =

            "SELECT " +

            "query_id, " +

            "application_id, " +

            "raised_by_officer_id, " +

            "query_description, " +

            "raised_date, " +

            "response_deadline, " +

            "status, " +

            "entrepreneur_response, " +

            "responded_at, " +

            "resolved_at, " +

            "updated_at " +

            "FROM application_queries " +

            "WHERE application_id = ? " +

            "ORDER BY query_id DESC " +

            "LIMIT 1";



    /*

     * =====================================================

     * APPROVAL CERTIFICATE

     * =====================================================

     */

    private static final String FIND_CERTIFICATE =

            "SELECT " +

            "ac.certificate_id, " +

            "ac.application_id, " +

            "ac.approval_number, " +

            "ac.approved_by, " +

            "ac.approval_date, " +

            "ac.valid_from, " +

            "ac.valid_until, " +

            "ac.remarks, " +

            "ac.created_at, " +

            "u.full_name AS approved_by_name " +

            "FROM approval_certificates ac " +

            "LEFT JOIN users u " +

            "ON ac.approved_by = u.user_id " +

            "WHERE ac.application_id = ? " +

            "LIMIT 1";



    /*

     * =====================================================

     * BUSINESS PROFILE COMPLETION

     * =====================================================

     */

    private static final String FIND_PROFILE_COMPLETION =

            "SELECT " +

            "profile_completed, " +

            "completion_percentage " +

            "FROM business_onboarding_progress " +

            "WHERE user_id = ? " +

            "AND business_id = ? " +

            "ORDER BY updated_at DESC " +

            "LIMIT 1";



    /*

     * =====================================================

     * INITIALIZATION

     * =====================================================

     */

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

        businessDAO =

                new BusinessDAOImpl();

        slaService =

                new SLAService();

        submissionRiskService =

                new SubmissionRiskService();

        aiRiskExplanationService =

                new AIRiskExplanationService();

    }



    /*

     * =====================================================

     * GET

     * =====================================================

     */

    @Override

    protected void doGet(

            HttpServletRequest request,

            HttpServletResponse response

    ) throws ServletException, IOException {



        /*

         * =================================================

         * 1. SESSION CHECK

         * =================================================

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



        String role =

                String.valueOf(

                        session.getAttribute(

                                "userRole"

                        )

                );



        if (!"ENTREPRENEUR"

                .equalsIgnoreCase(role)) {

            response.sendError(

                    HttpServletResponse.SC_FORBIDDEN,

                    "This page is only available for entrepreneurs."

            );

            return;

        }



        /*

         * =================================================

         * 2. APPLICATION ID CHECK

         * =================================================

         */

        String applicationIdParameter =

                request.getParameter("id");



        if (applicationIdParameter == null ||

            applicationIdParameter.isBlank()) {

            response.sendError(

                    HttpServletResponse.SC_BAD_REQUEST,

                    "Application ID is required."

            );

            return;

        }



        try {



            /*

             * =============================================

             * APPLICATION ID

             * =============================================

             */

            long applicationId =

                    Long.parseLong(

                            applicationIdParameter

                    );



            long userId =

                    ((Number)

                    session.getAttribute("userId"))

                    .longValue();



            /*

             * =================================================

             * 3. LOAD APPLICATION

             * =================================================

             */

            Application userApplication =

                    applicationDAO.findById(

                            applicationId

                    );



            if (userApplication == null) {

                response.sendError(

                        HttpServletResponse.SC_NOT_FOUND,

                        "Application not found."

                );

                return;

            }



            /*

             * =================================================

             * 4. APPLICATION OWNERSHIP SECURITY

             * =================================================

             */

            if (userApplication.getUserId()

                    != userId) {

                response.sendError(

                        HttpServletResponse.SC_FORBIDDEN,

                        "You are not allowed to view this application."

                );

                return;

            }



            /*

             * =================================================

             * 5. LOAD APPROVAL

             * =================================================

             */

            Approval approval =

                    approvalDAO

                            .findApprovalById(

                                    userApplication

                                            .getApprovalId()

                            );



            if (approval == null) {

                response.sendError(

                        HttpServletResponse.SC_NOT_FOUND,

                        "Approval not found for this application."

                );

                return;

            }



            /*

             * =================================================

             * 6. LOAD BUSINESS

             * =================================================

             */

            Business business =

                    businessDAO

                            .findByUserId(

                                    userId

                            );



            if (business == null) {

                response.sendError(

                        HttpServletResponse.SC_NOT_FOUND,

                        "Business profile not found."

                );

                return;

            }



            /*

             * =================================================

             * 7. BUSINESS OWNERSHIP CHECK

             * =================================================

             */

            if (userApplication.getBusinessId()

                    != business.getBusinessId()) {

                response.sendError(

                        HttpServletResponse.SC_FORBIDDEN,

                        "Application does not belong to your business."

                );

                return;

            }



            /*

             * =================================================

             * 8. LOAD REQUIRED DOCUMENTS

             * =================================================

             */

            List<ApprovalDocumentRequirement>

                    requirements =

                    approvalDocumentRequirementDAO

                            .findByApprovalId(

                                    userApplication

                                            .getApprovalId()

                            );



            /*

             * =================================================

             * 9. BUILD DOCUMENT READINESS

             * =================================================

             */

            List<DocumentReadiness>

                    documentReadinessList =

                    new ArrayList<>();



            int totalMandatoryDocuments = 0;

            int readyMandatoryDocuments = 0;



            if (requirements != null) {

                for (

                    ApprovalDocumentRequirement requirement

                    : requirements

                ) {



                    DocumentReadiness readiness =

                            new DocumentReadiness();



                    readiness.setDocumentType(

                            requirement

                                    .getDocumentType()

                    );



                    readiness.setDescription(

                            requirement

                                    .getDescription()

                    );



                    readiness.setMandatory(

                            requirement

                                    .isMandatory()

                    );



                    if (requirement.isMandatory()) {

                        totalMandatoryDocuments++;

                    }



                    /*

                     * =========================================

                     * CHECK UPLOADED DOCUMENT

                     * =========================================

                     */

                    Document uploadedDocument =

                            documentDAO

                                    .findByBusinessIdAndType(

                                            business

                                                    .getBusinessId(),

                                            requirement

                                                    .getDocumentType()

                                    );



                    /*

                     * =========================================

                     * DOCUMENT NOT UPLOADED

                     * =========================================

                     */

                    if (uploadedDocument == null) {

                        readiness.setStatus(

                                "MISSING"

                        );

                    } else {



                        /*

                         * =====================================

                         * DOCUMENT FOUND

                         * =====================================

                         */

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



                        /*

                         * =====================================

                         * CHECK EXPIRY DATE

                         * =====================================

                         */

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



                        /*

                         * =====================================

                         * EXPIRED BY DATE

                         * =====================================

                         */

                        if (expiredByDate) {

                            readiness.setStatus(

                                    "EXPIRED"

                            );



                        /*

                         * =====================================

                         * REJECTED

                         * =====================================

                         */

                        } else if (

                                "REJECTED"

                                .equalsIgnoreCase(

                                        verificationStatus

                                )

                        ) {

                            readiness.setStatus(

                                    "REJECTED"

                            );



                        /*

                         * =====================================

                         * EXPIRED STATUS

                         * =====================================

                         */

                        } else if (

                                "EXPIRED"

                                .equalsIgnoreCase(

                                        verificationStatus

                                )

                        ) {

                            readiness.setStatus(

                                    "EXPIRED"

                            );



                        /*

                         * =====================================

                         * READY

                         * =====================================

                         */

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

            }



            /*

             * =================================================

             * 10. CALCULATE READINESS PERCENTAGE

             * =================================================

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

             * =================================================

             * 11. PRE-SUBMISSION RISK ANALYZER

             * =================================================

             */

            boolean profileComplete =

                    isBusinessProfileComplete(

                            userId,

                            business.getBusinessId()

                    );



            SubmissionRiskResult submissionRisk =

                    submissionRiskService.analyzeRisk(

                            readinessPercentage,

                            documentReadinessList,

                            profileComplete

                    );



            /*

             * =================================================

             * 12. GEMINI AI RISK EXPLANATION

             * =================================================

             */

            String aiRiskExplanation;



            try {

                aiRiskExplanation =

                        aiRiskExplanationService

                                .generateExplanation(

                                        approval.getApprovalName(),

                                        business.getBusinessName(),

                                        submissionRisk

                                );

            } catch (Exception e) {

                log(

                        "Gemini AI risk explanation failed. "

                        + "Using fallback guidance.",

                        e

                );



                aiRiskExplanation =

                        "AI guidance is temporarily unavailable. "

                        + "Please follow the CHAPERON rule-based "

                        + "risk assessment and recommendations shown above.";

            }



            request.setAttribute(

                    "aiRiskExplanation",

                    aiRiskExplanation

            );



            /*

             * =================================================

             * SEND RISK ANALYSIS TO JSP

             * =================================================

             */

            request.setAttribute(

                    "submissionRisk",

                    submissionRisk

            );



            request.setAttribute(

                    "submissionRiskScore",

                    Integer.valueOf(

                            submissionRisk

                                    .getRiskScore()

                    )

            );



            request.setAttribute(

                    "submissionRiskLevel",

                    submissionRisk

                            .getRiskLevel()

            );



            request.setAttribute(

                    "submissionRiskSafe",

                    Boolean.valueOf(

                            submissionRisk

                                    .isSafeToSubmit()

                    )

            );



            request.setAttribute(

                    "submissionRiskSummary",

                    submissionRisk

                            .getSummary()

            );



            request.setAttribute(

                    "submissionRiskReasons",

                    submissionRisk

                            .getRiskReasons()

            );



            request.setAttribute(

                    "submissionRiskRecommendations",

                    submissionRisk

                            .getRecommendations()

            );



            request.setAttribute(

                    "businessProfileComplete",

                    Boolean.valueOf(

                            profileComplete

                    )

            );



            /*

             * =================================================

             * 12. LOAD LATEST OFFICER QUERY

             * =================================================

             */

            loadLatestQuery(

                    applicationId,

                    request

            );



            /*

             * =================================================

             * 13. LOAD APPROVAL CERTIFICATE

             * =================================================

             */

            loadApprovalCertificate(

                    applicationId,

                    request

            );



            /*

             * =================================================

             * 14. SLA MONITORING

             * =================================================

             */

            String slaStatus =

                    slaService.getSLAStatus(

                            userApplication

                    );



            String slaStatusLabel =

                    slaService.getSLAStatusLabel(

                            slaStatus

                    );



            long slaDaysRemaining =

                    slaService.getDaysRemaining(

                            userApplication

                    );



            String slaDeadlineMessage =

                    slaService.getDeadlineMessage(

                            userApplication

                    );



            int slaProgress =

                    slaService.getSLAProgressPercentage(

                            userApplication

                    );



            boolean slaBreached =

                    slaService.isSLABreached(

                            userApplication

                    );



            boolean slaNearDeadline =

                    slaService.isNearDeadline(

                            userApplication

                    );



            boolean slaActive =

                    slaService.isSLAActive(

                            userApplication

                    );



            /*

             * =================================================

             * SEND SLA DATA TO JSP

             * =================================================

             */

            request.setAttribute(

                    "slaStatus",

                    slaStatus

            );



            request.setAttribute(

                    "slaStatusLabel",

                    slaStatusLabel

            );



            request.setAttribute(

                    "slaDaysRemaining",

                    Long.valueOf(

                            slaDaysRemaining

                    )

            );



            request.setAttribute(

                    "slaDeadlineMessage",

                    slaDeadlineMessage

            );



            request.setAttribute(

                    "slaProgress",

                    Integer.valueOf(

                            slaProgress

                    )

            );



            request.setAttribute(

                    "slaBreached",

                    Boolean.valueOf(

                            slaBreached

                    )

            );



            request.setAttribute(

                    "slaNearDeadline",

                    Boolean.valueOf(

                            slaNearDeadline

                    )

            );



            request.setAttribute(

                    "slaActive",

                    Boolean.valueOf(

                            slaActive

                    )

            );



            /*

             * =================================================

             * 15. SEND APPLICATION TO JSP

             * =================================================

             */

            request.setAttribute(

                    "application",

                    userApplication

            );



            /*

             * =================================================

             * 16. SEND APPROVAL TO JSP

             * =================================================

             */

            request.setAttribute(

                    "approval",

                    approval

            );



            /*

             * =================================================

             * 17. SEND BUSINESS TO JSP

             * =================================================

             */

            request.setAttribute(

                    "business",

                    business

            );



            /*

             * =================================================

             * 18. SEND READINESS DATA

             * =================================================

             */

            request.setAttribute(

                    "documentReadinessList",

                    documentReadinessList

            );



            request.setAttribute(

                    "readinessPercentage",

                    readinessPercentage

            );



            /*

             * =================================================

             * 19. OPEN JSP

             * =================================================

             */

            request.getRequestDispatcher(

                    "/WEB-INF/views/entrepreneur/application-details.jsp"

            ).forward(

                    request,

                    response

            );



        } catch (NumberFormatException e) {



            response.sendError(

                    HttpServletResponse.SC_BAD_REQUEST,

                    "Invalid application ID."

            );



        } catch (SQLException e) {



            log(

                    "Unable to load application details.",

                    e

            );



            response.sendError(

                    HttpServletResponse

                            .SC_INTERNAL_SERVER_ERROR,

                    "Unable to load application details."

            );

        }

    }



    /*

     * =====================================================

     * CHECK BUSINESS PROFILE COMPLETION

     * =====================================================

     */

    private boolean isBusinessProfileComplete(

            long userId,

            long businessId

    ) throws SQLException {



        try (

            Connection connection =

                    DBConnection.getConnection();

            PreparedStatement statement =

                    connection.prepareStatement(

                            FIND_PROFILE_COMPLETION

                    )

        ) {



            statement.setLong(

                    1,

                    userId

            );



            statement.setLong(

                    2,

                    businessId

            );



            try (

                ResultSet resultSet =

                        statement.executeQuery()

            ) {



                if (!resultSet.next()) {

                    return false;

                }



                boolean profileCompleted =

                        resultSet.getBoolean(

                                "profile_completed"

                        );



                int completionPercentage =

                        resultSet.getInt(

                                "completion_percentage"

                        );



                return profileCompleted

                        &&

                        completionPercentage >= 100;

            }

        }

    }



    /*

     * =====================================================

     * LOAD LATEST APPLICATION QUERY

     * =====================================================

     */

    private void loadLatestQuery(

            long applicationId,

            HttpServletRequest request

    ) throws SQLException {



        try (

            Connection connection =

                    DBConnection.getConnection();

            PreparedStatement statement =

                    connection.prepareStatement(

                            FIND_LATEST_QUERY

                    )

        ) {



            statement.setLong(

                    1,

                    applicationId

            );



            try (

                ResultSet resultSet =

                        statement.executeQuery()

            ) {



                if (resultSet.next()) {



                    long queryId =

                            resultSet.getLong(

                                    "query_id"

                            );



                    long raisedByOfficerId =

                            resultSet.getLong(

                                    "raised_by_officer_id"

                            );



                    String queryDescription =

                            resultSet.getString(

                                    "query_description"

                            );



                    Timestamp raisedDate =

                            resultSet.getTimestamp(

                                    "raised_date"

                            );



                    Date responseDeadline =

                            resultSet.getDate(

                                    "response_deadline"

                            );



                    String queryStatus =

                            resultSet.getString(

                                    "status"

                            );



                    String entrepreneurResponse =

                            resultSet.getString(

                                    "entrepreneur_response"

                            );



                    Timestamp respondedAt =

                            resultSet.getTimestamp(

                                    "responded_at"

                            );



                    Timestamp resolvedAt =

                            resultSet.getTimestamp(

                                    "resolved_at"

                            );



                    /*

                     * =========================================

                     * SEND QUERY DATA

                     * =========================================

                     */

                    request.setAttribute(

                            "queryId",

                            queryId

                    );



                    request.setAttribute(

                            "queryRaisedByOfficerId",

                            raisedByOfficerId

                    );



                    request.setAttribute(

                            "queryDescription",

                            queryDescription

                    );



                    request.setAttribute(

                            "queryRaisedDate",

                            raisedDate

                    );



                    request.setAttribute(

                            "queryResponseDeadline",

                            responseDeadline

                    );



                    request.setAttribute(

                            "queryStatus",

                            queryStatus

                    );



                    request.setAttribute(

                            "entrepreneurResponse",

                            entrepreneurResponse

                    );



                    request.setAttribute(

                            "queryRespondedAt",

                            respondedAt

                    );



                    request.setAttribute(

                            "queryResolvedAt",

                            resolvedAt

                    );



                } else {



                    /*

                     * =========================================

                     * NO QUERY FOUND

                     * =========================================

                     */

                    request.setAttribute(

                            "queryId",

                            null

                    );



                    request.setAttribute(

                            "queryRaisedByOfficerId",

                            null

                    );



                    request.setAttribute(

                            "queryDescription",

                            null

                    );



                    request.setAttribute(

                            "queryRaisedDate",

                            null

                    );



                    request.setAttribute(

                            "queryResponseDeadline",

                            null

                    );



                    request.setAttribute(

                            "queryStatus",

                            null

                    );



                    request.setAttribute(

                            "entrepreneurResponse",

                            null

                    );



                    request.setAttribute(

                            "queryRespondedAt",

                            null

                    );



                    request.setAttribute(

                            "queryResolvedAt",

                            null

                    );

                }

            }

        }

    }



    /*

     * =====================================================

     * LOAD APPROVAL CERTIFICATE

     * =====================================================

     */

    private void loadApprovalCertificate(

            long applicationId,

            HttpServletRequest request

    ) throws SQLException {



        try (

            Connection connection =

                    DBConnection.getConnection();

            PreparedStatement statement =

                    connection.prepareStatement(

                            FIND_CERTIFICATE

                    )

        ) {



            statement.setLong(

                    1,

                    applicationId

            );



            try (

                ResultSet resultSet =

                        statement.executeQuery()

            ) {



                if (resultSet.next()) {



                    /*

                     * =========================================

                     * CERTIFICATE ID

                     * =========================================

                     */

                    long certificateId =

                            resultSet.getLong(

                                    "certificate_id"

                            );



                    /*

                     * =========================================

                     * APPROVAL NUMBER

                     * =========================================

                     */

                    String approvalNumber =

                            resultSet.getString(

                                    "approval_number"

                            );



                    /*

                     * =========================================

                     * APPROVED BY

                     * =========================================

                     */

                    long approvedBy =

                            resultSet.getLong(

                                    "approved_by"

                            );



                    Long approvedByValue =

                            resultSet.wasNull()

                            ? null

                            : approvedBy;



                    /*

                     * =========================================

                     * APPROVED BY NAME

                     * =========================================

                     */

                    String approvedByName =

                            resultSet.getString(

                                    "approved_by_name"

                            );



                    /*

                     * =========================================

                     * DATES

                     * =========================================

                     */

                    Date approvalDate =

                            resultSet.getDate(

                                    "approval_date"

                            );



                    Date validFrom =

                            resultSet.getDate(

                                    "valid_from"

                            );



                    Date validUntil =

                            resultSet.getDate(

                                    "valid_until"

                            );



                    /*

                     * =========================================

                     * REMARKS

                     * =========================================

                     */

                    String remarks =

                            resultSet.getString(

                                    "remarks"

                            );



                    /*

                     * =========================================

                     * CREATED AT

                     * =========================================

                     */

                    Timestamp createdAt =

                            resultSet.getTimestamp(

                                    "created_at"

                            );



                    /*

                     * =========================================

                     * SEND CERTIFICATE DATA TO JSP

                     * =========================================

                     */

                    request.setAttribute(

                            "certificateId",

                            Long.valueOf(

                                    certificateId

                            )

                    );



                    request.setAttribute(

                            "certificateApprovalNumber",

                            approvalNumber

                    );



                    request.setAttribute(

                            "certificateApprovedBy",

                            approvedByValue

                    );



                    request.setAttribute(

                            "certificateApprovedByName",

                            approvedByName

                    );



                    request.setAttribute(

                            "certificateApprovalDate",

                            approvalDate

                    );



                    request.setAttribute(

                            "certificateValidFrom",

                            validFrom

                    );



                    request.setAttribute(

                            "certificateValidUntil",

                            validUntil

                    );



                    request.setAttribute(

                            "certificateRemarks",

                            remarks

                    );



                    request.setAttribute(

                            "certificateCreatedAt",

                            createdAt

                    );



                } else {



                    /*

                     * =========================================

                     * NO CERTIFICATE FOUND

                     * =========================================

                     */

                    request.setAttribute(

                            "certificateId",

                            null

                    );



                    request.setAttribute(

                            "certificateApprovalNumber",

                            null

                    );



                    request.setAttribute(

                            "certificateApprovedBy",

                            null

                    );



                    request.setAttribute(

                            "certificateApprovedByName",

                            null

                    );



                    request.setAttribute(

                            "certificateApprovalDate",

                            null

                    );



                    request.setAttribute(

                            "certificateValidFrom",

                            null

                    );



                    request.setAttribute(

                            "certificateValidUntil",

                            null

                    );



                    request.setAttribute(

                            "certificateRemarks",

                            null

                    );



                    request.setAttribute(

                            "certificateCreatedAt",

                            null

                    );

                }

            }

        }

    }

}