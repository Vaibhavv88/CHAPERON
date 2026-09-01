package com.chaperon.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.chaperon.dao.ApplicationDAO;
import com.chaperon.dao.ApprovalDAO;

import com.chaperon.dao.impl.ApplicationDAOImpl;
import com.chaperon.dao.impl.ApprovalDAOImpl;

import com.chaperon.dto.ApplicationView;

import com.chaperon.model.Application;
import com.chaperon.model.Approval;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/my-applications")
public class MyApplicationsServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ApplicationDAO applicationDAO;

    private ApprovalDAO approvalDAO;

    @Override
    public void init()
            throws ServletException {

        applicationDAO =
                new ApplicationDAOImpl();

        approvalDAO =
                new ApprovalDAOImpl();
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

        try {

            long userId =
                    ((Number)
                    session.getAttribute("userId"))
                    .longValue();

            /*
             * Load all applications
             */
            List<Application> applications =
                    applicationDAO
                            .findByUserId(
                                    userId
                            );

            /*
             * Prepare richer view data
             */
            List<ApplicationView> applicationViews =
                    new ArrayList<>();

            for (Application application
                    : applications) {

                Approval approval =
                        approvalDAO
                                .findApprovalById(
                                        application
                                                .getApprovalId()
                                );

                String approvalName =
                        "Approval";

                String approvalCode =
                        "";

                String departmentName =
                        "Department not available";

                if (approval != null) {

                    if (approval.getApprovalName()
                            != null) {

                        approvalName =
                                approval
                                        .getApprovalName();
                    }

                    if (approval.getApprovalCode()
                            != null) {

                        approvalCode =
                                approval
                                        .getApprovalCode();
                    }

                    if (approval.getDepartmentName()
                            != null) {

                        departmentName =
                                approval
                                        .getDepartmentName();
                    }
                }

                ApplicationView view =
                        new ApplicationView(
                                application,
                                approvalName,
                                approvalCode,
                                departmentName
                        );

                applicationViews.add(
                        view
                );
            }

            request.setAttribute(
                    "applicationViews",
                    applicationViews
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/my-applications.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            log(
                    "Unable to load applications",
                    e
            );

            response.sendError(
                    HttpServletResponse
                            .SC_INTERNAL_SERVER_ERROR,
                    "Unable to load applications."
            );
        }
    }
}