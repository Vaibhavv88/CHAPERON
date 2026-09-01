package com.chaperon.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.chaperon.model.BusinessApproval;
import com.chaperon.service.ApprovalRecommendationService;
import com.chaperon.service.impl.ApprovalRecommendationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/generate-approvals")
public class GenerateApprovalsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ApprovalRecommendationService
            approvalRecommendationService;

    @Override
    public void init() throws ServletException {

        approvalRecommendationService =
                new ApprovalRecommendationServiceImpl();
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
                ((Number) session.getAttribute("userId"))
                        .longValue();

        try {

            List<BusinessApproval> recommendations =
                    approvalRecommendationService
                            .generateRecommendations(
                                    userId
                            );

            request.setAttribute(
                    "recommendations",
                    recommendations
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/approval-roadmap.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            log(
                    "Unable to generate approval recommendations",
                    e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to generate your approval roadmap."
            );
        }
    }
}