package com.chaperon.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.chaperon.dao.DocumentDAO;
import com.chaperon.dao.impl.DocumentDAOImpl;
import com.chaperon.model.Business;
import com.chaperon.model.Document;
import com.chaperon.service.BusinessService;
import com.chaperon.service.DocumentTypeCatalogService;
import com.chaperon.service.impl.BusinessServiceImpl;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/documents")
public class DocumentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BusinessService businessService;
    private DocumentDAO documentDAO;
    private DocumentTypeCatalogService documentTypeCatalogService;

    @Override
    public void init() throws ServletException {

        businessService =
                new BusinessServiceImpl();

        documentDAO =
                new DocumentDAOImpl();

        documentTypeCatalogService =
                new DocumentTypeCatalogService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session =
                request.getSession(false);

        /*
         * Session validation.
         */
        if (session == null ||
                session.getAttribute("userId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur-login"
            );
            return;
        }

        Object userIdObject =
                session.getAttribute("userId");

        if (!(userIdObject instanceof Number)) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath()
                            + "/entrepreneur-login"
            );
            return;
        }

        long userId =
                ((Number) userIdObject)
                        .longValue();

        /*
         * Optional role validation.
         */
        Object userRoleObject =
                session.getAttribute("userRole");

        if (userRoleObject != null) {

            String userRole =
                    String.valueOf(userRoleObject);

            if (!"ENTREPRENEUR"
                    .equalsIgnoreCase(userRole)) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Entrepreneur access is required."
                );
                return;
            }
        }

        try {

            /*
             * Load entrepreneur business.
             */
            Business business =
                    businessService
                            .getBusinessByUserId(
                                    userId
                            );

            if (business == null) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/entrepreneur/onboarding"
                );
                return;
            }

            long businessId =
                    business.getBusinessId();

            /*
             * Load already uploaded documents.
             */
            List<Document> documents =
                    documentDAO
                            .findByBusinessId(
                                    businessId
                            );

            if (documents == null) {
                documents =
                        Collections.emptyList();
            }

            /*
             * Load document types dynamically from:
             *
             * 1. approval_document_requirements
             * 2. clearance_requirements
             * 3. general document types
             */
            Map<String, Map<String, String>>
                    documentTypeGroups =
                    documentTypeCatalogService
                            .getGroupedDocumentTypes();

            if (documentTypeGroups == null) {

                documentTypeGroups =
                        new LinkedHashMap<>();
            }

            /*
             * JSP request attributes.
             */
            request.setAttribute(
                    "business",
                    business
            );

            request.setAttribute(
                    "documents",
                    documents
            );

            request.setAttribute(
                    "documentTypeGroups",
                    documentTypeGroups
            );

            request.setAttribute(
                    "documentTypeCount",
                    countDocumentTypes(
                            documentTypeGroups
                    )
            );

            RequestDispatcher dispatcher =
                    request.getRequestDispatcher(
                            "/WEB-INF/views/entrepreneur/documents.jsp"
                    );

            dispatcher.forward(
                    request,
                    response
            );

        } catch (SQLException exception) {

            log(
                    "Unable to load Document Vault for user ID: "
                            + userId,
                    exception
            );

            response.sendError(
                    HttpServletResponse
                            .SC_INTERNAL_SERVER_ERROR,
                    "Unable to load the Document Vault."
            );
        }
    }

    private int countDocumentTypes(
            Map<String, Map<String, String>>
                    documentTypeGroups
    ) {

        if (documentTypeGroups == null ||
                documentTypeGroups.isEmpty()) {

            return 0;
        }

        int count = 0;

        for (Map<String, String> group
                : documentTypeGroups.values()) {

            if (group != null) {
                count += group.size();
            }
        }

        return count;
    }
}