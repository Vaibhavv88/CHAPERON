package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.chaperon.model.Business;
import com.chaperon.service.BusinessService;
import com.chaperon.service.impl.BusinessServiceImpl;
import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/regulation-impact")
public class RegulationImpactServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BusinessService businessService;

    @Override
    public void init() throws ServletException {

        businessService =
                new BusinessServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null
                || session.getAttribute("userId") == null
                || session.getAttribute("userRole") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }

        String role =
                String.valueOf(
                        session.getAttribute("userRole")
                );

        if (!"ENTREPRENEUR"
                .equalsIgnoreCase(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN
            );

            return;
        }

        try {

            long userId =
                    ((Number)
                    session.getAttribute("userId"))
                    .longValue();

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

            List<Map<String, Object>>
                    impacts =
                    loadImpacts(
                            business
                    );

            int high = 0;
            int medium = 0;
            int info = 0;

            for (Map<String, Object> item
                    : impacts) {

                String severity =
                        String.valueOf(
                                item.get("severity")
                        );

                if ("HIGH".equalsIgnoreCase(
                        severity)) {

                    high++;

                } else if ("MEDIUM"
                        .equalsIgnoreCase(
                                severity)) {

                    medium++;

                } else {

                    info++;
                }
            }

            request.setAttribute(
                    "business",
                    business
            );

            request.setAttribute(
                    "impacts",
                    impacts
            );

            request.setAttribute(
                    "highCount",
                    high
            );

            request.setAttribute(
                    "mediumCount",
                    medium
            );

            request.setAttribute(
                    "infoCount",
                    info
            );

            request.setAttribute(
                    "totalCount",
                    impacts.size()
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/regulation-impact.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load regulation impact.",
                    e
            );
        }
    }

    private List<Map<String, Object>>
            loadImpacts(
            Business business)
            throws SQLException {

        String sql = """
                SELECT DISTINCT
                    rc.change_id,
                    rc.title,
                    rc.description,
                    rc.approval_id,
                    rc.industry,
                    rc.state,
                    rc.effective_date,
                    rc.severity,
                    rc.action_required,
                    a.approval_name,
                    a.approval_code
                FROM regulation_changes rc
                LEFT JOIN approvals a
                    ON rc.approval_id = a.approval_id
                WHERE rc.active = 1
                  AND (
                        rc.industry IS NULL
                        OR TRIM(rc.industry) = ''
                        OR LOWER(TRIM(rc.industry))
                           = LOWER(TRIM(?))
                      )
                  AND (
                        rc.state IS NULL
                        OR TRIM(rc.state) = ''
                        OR LOWER(TRIM(rc.state))
                           = LOWER(TRIM(?))
                      )
                  AND (
                        rc.approval_id IS NULL
                        OR EXISTS (
                            SELECT 1
                            FROM business_approvals ba
                            WHERE ba.business_id = ?
                              AND ba.approval_id =
                                  rc.approval_id
                        )
                      )
                ORDER BY
                    CASE
                        WHEN rc.severity = 'HIGH'
                            THEN 1
                        WHEN rc.severity = 'MEDIUM'
                            THEN 2
                        ELSE 3
                    END,
                    rc.effective_date DESC,
                    rc.change_id DESC
                """;

        List<Map<String, Object>>
                result =
                new ArrayList<>();

        try (
                Connection connection =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        connection.prepareStatement(sql)
        ) {

            ps.setString(
                    1,
                    business.getIndustry()
            );

            ps.setString(
                    2,
                    business.getState()
            );

            ps.setLong(
                    3,
                    business.getBusinessId()
            );

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                while (rs.next()) {

                    Map<String, Object> row =
                            new HashMap<>();

                    row.put(
                            "changeId",
                            rs.getLong(
                                    "change_id"
                            )
                    );

                    row.put(
                            "title",
                            rs.getString(
                                    "title"
                            )
                    );

                    row.put(
                            "description",
                            rs.getString(
                                    "description"
                            )
                    );

                    row.put(
                            "approvalName",
                            rs.getString(
                                    "approval_name"
                            )
                    );

                    row.put(
                            "approvalCode",
                            rs.getString(
                                    "approval_code"
                            )
                    );

                    row.put(
                            "effectiveDate",
                            rs.getDate(
                                    "effective_date"
                            )
                    );

                    row.put(
                            "severity",
                            rs.getString(
                                    "severity"
                            )
                    );

                    row.put(
                            "actionRequired",
                            rs.getString(
                                    "action_required"
                            )
                    );

                    result.add(row);
                }
            }
        }

        return result;
    }
}