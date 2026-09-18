package com.chaperon.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Locale;

import com.chaperon.model.ClearanceApplication;
import com.chaperon.model.SpatialScreeningResult;
import com.chaperon.service.ClearanceApplicationService;
import com.chaperon.service.SpatialScreeningService;
import com.chaperon.service.impl.ClearanceApplicationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/gis-screening")
public class SpatialScreeningServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private SpatialScreeningService spatialScreeningService;
    private ClearanceApplicationService clearanceApplicationService;

    @Override
    public void init() throws ServletException {
        spatialScreeningService =
                new SpatialScreeningService();

        clearanceApplicationService =
                new ClearanceApplicationServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session =
                getEntrepreneurSession(request);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );
            return;
        }

        Long entrepreneurUserId =
                getSessionUserId(session);

        Long clearanceApplicationId =
                getApplicationId(request);

        if (entrepreneurUserId == null) {
            invalidateAndRedirect(
                    request,
                    response,
                    session
            );
            return;
        }

        if (clearanceApplicationId == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur/clearances"
                    + "?error=invalid-application"
            );
            return;
        }

        try {
            ClearanceApplication application =
                    clearanceApplicationService
                            .getApplicationForUser(
                                    clearanceApplicationId,
                                    entrepreneurUserId
                            );

            if (application == null) {
                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "You cannot access this "
                        + "clearance application."
                );
                return;
            }

            SpatialScreeningResult result;

            String sessionKey =
                    "gisScreeningResult_"
                    + clearanceApplicationId;

            Object sessionResult =
                    session.getAttribute(sessionKey);

            /*
             * A successful screening may legitimately return
             * zero findings. In that situation no finding row
             * is stored, so getSavedResult() cannot determine
             * that screening was already completed.
             *
             * Therefore, the latest screening result is retained
             * in the entrepreneur session.
             */
            if (sessionResult
                    instanceof SpatialScreeningResult) {

                result =
                        (SpatialScreeningResult) sessionResult;

            } else {
                result =
                        spatialScreeningService
                                .getSavedResult(
                                        clearanceApplicationId
                                );
            }

            request.setAttribute(
                    "clearanceApplication",
                    application
            );

            request.setAttribute(
                    "screeningResult",
                    result
            );

            applyMessage(request);

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/"
                    + "gis-screening.jsp"
            ).forward(request, response);

        } catch (SQLException exception) {
            throw new ServletException(
                    "Unable to load GIS screening result.",
                    exception
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        HttpSession session =
                getEntrepreneurSession(request);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );
            return;
        }

        Long entrepreneurUserId =
                getSessionUserId(session);

        Long clearanceApplicationId =
                getApplicationId(request);

        if (entrepreneurUserId == null) {
            invalidateAndRedirect(
                    request,
                    response,
                    session
            );
            return;
        }

        if (clearanceApplicationId == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur/clearances"
                    + "?error=invalid-application"
            );
            return;
        }

        try {
            ClearanceApplication application =
                    clearanceApplicationService
                            .getApplicationForUser(
                                    clearanceApplicationId,
                                    entrepreneurUserId
                            );

            if (application == null) {
                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "You cannot run screening for "
                        + "this clearance application."
                );
                return;
            }

            SpatialScreeningResult result =
                    spatialScreeningService
                            .runScreening(
                                    clearanceApplicationId
                            );

            /*
             * Preserve the complete result, including the
             * checked-layer count and a successful screening
             * having zero findings.
             */
            session.setAttribute(
                    "gisScreeningResult_"
                    + clearanceApplicationId,
                    result
            );

            String redirectStatus;

            if ("COMPLETED".equalsIgnoreCase(
                    result.getAnalysisStatus()
            )) {
                redirectStatus = "completed";

            } else if ("BOUNDARY_REQUIRED"
                    .equalsIgnoreCase(
                            result.getAnalysisStatus()
                    )) {
                redirectStatus = "boundary-required";

            } else if ("INVALID_BOUNDARY"
                    .equalsIgnoreCase(
                            result.getAnalysisStatus()
                    )) {
                redirectStatus = "invalid-boundary";

            } else if ("NO_ACTIVE_LAYERS"
                    .equalsIgnoreCase(
                            result.getAnalysisStatus()
                    )) {
                redirectStatus = "no-active-layers";

            } else {
                redirectStatus = "not-completed";
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur/gis-screening"
                    + "?applicationId="
                    + clearanceApplicationId
                    + "&status="
                    + redirectStatus
            );

        } catch (IllegalArgumentException exception) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur/gis-screening"
                    + "?applicationId="
                    + clearanceApplicationId
                    + "&error=invalid-request"
            );

        } catch (SQLException exception) {
            throw new ServletException(
                    "GIS screening could not be completed.",
                    exception
            );
        }
    }

    private HttpSession getEntrepreneurSession(
            HttpServletRequest request
    ) {
        HttpSession session =
                request.getSession(false);

        if (session == null) {
            return null;
        }

        Object userId =
                session.getAttribute("userId");

        Object roleValue =
                session.getAttribute("userRole");

        if (userId == null || roleValue == null) {
            return null;
        }

        String role =
                String.valueOf(roleValue)
                        .trim()
                        .toUpperCase(Locale.ROOT);

        if (!"ENTREPRENEUR".equals(role)) {
            return null;
        }

        return session;
    }

    private Long getSessionUserId(
            HttpSession session
    ) {
        Object value =
                session.getAttribute("userId");

        if (value == null) {
            return null;
        }

        if (value instanceof Number) {
            return ((Number) value).longValue();
        }

        try {
            long userId =
                    Long.parseLong(
                            String.valueOf(value).trim()
                    );

            return userId > 0
                    ? userId
                    : null;

        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private Long getApplicationId(
            HttpServletRequest request
    ) {
        String value =
                request.getParameter(
                        "applicationId"
                );

        if (value == null || value.isBlank()) {
            value = request.getParameter("id");
        }

        if (value == null || value.isBlank()) {
            return null;
        }

        try {
            long applicationId =
                    Long.parseLong(value.trim());

            return applicationId > 0
                    ? applicationId
                    : null;

        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private void invalidateAndRedirect(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session
    ) throws IOException {

        if (session != null) {
            session.invalidate();
        }

        response.sendRedirect(
                request.getContextPath()
                + "/entrepreneur-login"
        );
    }

    private void applyMessage(
            HttpServletRequest request
    ) {
        String status =
                clean(
                        request.getParameter("status")
                );

        String error =
                clean(
                        request.getParameter("error")
                );

        if ("completed".equals(status)) {
            request.setAttribute(
                    "successMessage",
                    "GIS spatial screening completed "
                    + "successfully."
            );

        } else if ("boundary-required".equals(status)) {
            request.setAttribute(
                    "warningMessage",
                    "Please draw and save the project "
                    + "boundary before running screening."
            );

        } else if ("invalid-boundary".equals(status)) {
            request.setAttribute(
                    "errorMessage",
                    "The saved project boundary is invalid. "
                    + "Please redraw and save the boundary."
            );

        } else if ("no-active-layers".equals(status)) {
            request.setAttribute(
                    "warningMessage",
                    "No verified active official GIS layer "
                    + "is currently available for this "
                    + "project location."
            );

        } else if ("not-completed".equals(status)) {
            request.setAttribute(
                    "warningMessage",
                    "GIS screening was not completed."
            );
        }

        if ("invalid-request".equals(error)) {
            request.setAttribute(
                    "errorMessage",
                    "The GIS screening request is invalid."
            );
        }
    }

    private String clean(String value) {
        if (value == null) {
            return null;
        }

        String cleaned = value.trim();

        return cleaned.isEmpty()
                ? null
                : cleaned;
    }
}