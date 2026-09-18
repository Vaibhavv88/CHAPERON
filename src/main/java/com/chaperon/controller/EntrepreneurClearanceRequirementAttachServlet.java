package com.chaperon.controller;

import java.io.IOException;
import java.util.List;

import com.chaperon.dao.DocumentDAO;
import com.chaperon.dao.impl.DocumentDAOImpl;
import com.chaperon.model.Business;
import com.chaperon.model.ClearanceApplication;
import com.chaperon.model.Document;
import com.chaperon.service.BusinessService;
import com.chaperon.service.ClearanceApplicationService;
import com.chaperon.service.impl.BusinessServiceImpl;
import com.chaperon.service.impl.ClearanceApplicationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/clearances/requirements/attach")
public class EntrepreneurClearanceRequirementAttachServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ClearanceApplicationService clearanceService;
    private BusinessService businessService;
    private DocumentDAO documentDAO;

    @Override
    public void init() throws ServletException {

        clearanceService =
                new ClearanceApplicationServiceImpl();

        businessService =
                new BusinessServiceImpl();

        documentDAO =
                new DocumentDAOImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath()
                        + "/entrepreneur/clearances");
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("userId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur-login");

            return;
        }

        long userId =
                ((Number) session.getAttribute("userId"))
                        .longValue();

        Long applicationId =
                parseLong(
                        request.getParameter(
                                "applicationId"));

        Long applicationRequirementId =
                parseLong(
                        request.getParameter(
                                "applicationRequirementId"));

        Long documentId =
                parseLong(
                        request.getParameter(
                                "documentId"));

        String applicantRemarks =
                clean(
                        request.getParameter(
                                "applicantRemarks"));

        if (applicationId == null
                || applicationRequirementId == null
                || documentId == null) {

            session.setAttribute(
                    "errorMessage",
                    "Application, requirement and document are required.");

            redirectToApplication(
                    request,
                    response,
                    applicationId);

            return;
        }

        try {
            ClearanceApplication application =
                    clearanceService
                            .getApplicationForUser(
                                    applicationId,
                                    userId);

            if (application == null) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Clearance application not found.");

                return;
            }

            if (!"DRAFT".equalsIgnoreCase(
                    application.getCurrentStatus())) {

                throw new IllegalStateException(
                        "Documents can only be attached to a draft application.");
            }

            Business business =
                    businessService
                            .getBusinessByUserId(userId);

            if (business == null) {

                throw new IllegalStateException(
                        "Business profile was not found.");
            }

            List<Document> businessDocuments =
                    documentDAO.findByBusinessId(
                            business.getBusinessId());

            Document selectedDocument =
                    findDocument(
                            businessDocuments,
                            documentId);

            if (selectedDocument == null) {

                throw new IllegalArgumentException(
                        "Selected document does not belong to your business.");
            }

            boolean attached =
                    clearanceService
                            .attachRequirementDocument(
                                    applicationId,
                                    applicationRequirementId,
                                    documentId,
                                    userId,
                                    applicantRemarks);

            if (!attached) {

                throw new IllegalStateException(
                        "Document could not be attached.");
            }

            session.setAttribute(
                    "successMessage",
                    "Document attached to the requirement successfully.");

        } catch (Exception exception) {

            exception.printStackTrace();

            session.setAttribute(
                    "errorMessage",
                    exception.getMessage());
        }

        redirectToApplication(
                request,
                response,
                applicationId);
    }

    private Document findDocument(
            List<Document> documents,
            long documentId) {

        if (documents == null) {
            return null;
        }

        for (Document document : documents) {

            if (document.getDocumentId() == documentId
                    && document.isActive()) {

                return document;
            }
        }

        return null;
    }

    private void redirectToApplication(
            HttpServletRequest request,
            HttpServletResponse response,
            Long applicationId)
            throws IOException {

        if (applicationId == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur/clearances");

            return;
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/entrepreneur/clearances/new?id="
                        + applicationId);
    }

    private Long parseLong(String value) {

        try {
            if (value == null
                    || value.trim().isEmpty()) {

                return null;
            }

            return Long.valueOf(value.trim());

        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private String clean(String value) {

        if (value == null) {
            return null;
        }

        String cleanedValue = value.trim();

        return cleanedValue.isEmpty()
                ? null
                : cleanedValue;
    }
}