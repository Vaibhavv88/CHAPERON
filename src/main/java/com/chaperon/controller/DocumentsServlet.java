package com.chaperon.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.chaperon.dao.DocumentDAO;
import com.chaperon.dao.impl.DocumentDAOImpl;
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

@WebServlet("/entrepreneur/documents")
public class DocumentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DocumentDAO documentDAO;
    private BusinessService businessService;

    @Override
    public void init() throws ServletException {

        documentDAO =
                new DocumentDAOImpl();

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
                ((Number) session
                        .getAttribute("userId"))
                        .longValue();

        try {

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

            List<Document> documents =
                    documentDAO.findByBusinessId(
                            business.getBusinessId()
                    );

            request.setAttribute(
                    "business",
                    business
            );

            request.setAttribute(
                    "documents",
                    documents
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/documents.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            log(
                    "Unable to load document vault",
                    e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load document vault."
            );
        }
    }
}