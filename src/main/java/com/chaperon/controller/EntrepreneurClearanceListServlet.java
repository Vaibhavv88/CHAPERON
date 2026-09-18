package com.chaperon.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.chaperon.model.ClearanceApplication;
import com.chaperon.model.ClearanceType;
import com.chaperon.service.ClearanceApplicationService;
import com.chaperon.service.impl.ClearanceApplicationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/clearances")
public class EntrepreneurClearanceListServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ClearanceApplicationService clearanceService;

    @Override
    public void init() throws ServletException {
        clearanceService = new ClearanceApplicationServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null ||
            session.getAttribute("userRole") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/entrepreneur-login"
            );
            return;
        }

        String userRole = String.valueOf(
                session.getAttribute("userRole")
        );

        if (!"ENTREPRENEUR".equalsIgnoreCase(userRole)) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "This page is only available for entrepreneurs."
            );
            return;
        }

        long userId = ((Number) session.getAttribute("userId")).longValue();

        try {
            List<ClearanceApplication> applications =
                    clearanceService.getApplicationsForUser(userId);

            List<ClearanceType> clearanceTypes =
                    clearanceService.getActiveClearanceTypes();

            Map<Long, Integer> readinessByApplication =
                    new LinkedHashMap<>();

            for (ClearanceApplication application : applications) {
                int readiness = clearanceService.calculateReadinessPercentage(
                        application.getClearanceApplicationId()
                );
                readinessByApplication.put(
                        application.getClearanceApplicationId(),
                        readiness
                );
            }

            request.setAttribute("clearanceApplications", applications);
            request.setAttribute("clearanceTypes", clearanceTypes);
            request.setAttribute(
                    "readinessByApplication",
                    readinessByApplication
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/clearance-list.jsp"
            ).forward(request, response);

        } catch (SQLException e) {
            log("Unable to load clearance applications", e);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load clearance applications."
            );
        }
    }
}
