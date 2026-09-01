package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/entrepreneur/schemes")
public class EntrepreneurSchemesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (!isEntrepreneur(request, response)) {
            return;
        }

        List<Map<String, Object>> schemes =
                new ArrayList<>();

        String sql =
                "SELECT " +
                "gs.scheme_id, " +
                "gs.scheme_name, " +
                "gs.description, " +
                "gs.eligibility, " +
                "gs.benefit, " +
                "gs.deadline, " +
                "gs.official_information_url, " +
                "gs.department_id, " +
                "d.department_name, " +
                "d.department_code " +
                "FROM government_schemes gs " +
                "LEFT JOIN departments d " +
                "ON gs.department_id = d.department_id " +
                "WHERE gs.active = 1 " +
                "ORDER BY " +
                "CASE " +
                "WHEN gs.deadline IS NULL THEN 2 " +
                "WHEN gs.deadline >= CURDATE() THEN 1 " +
                "ELSE 3 " +
                "END, " +
                "gs.deadline ASC, " +
                "gs.scheme_name ASC";

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {

            while (resultSet.next()) {

                Map<String, Object> scheme =
                        new HashMap<>();

                scheme.put(
                        "schemeId",
                        resultSet.getLong("scheme_id")
                );

                scheme.put(
                        "schemeName",
                        resultSet.getString("scheme_name")
                );

                scheme.put(
                        "description",
                        resultSet.getString("description")
                );

                scheme.put(
                        "eligibility",
                        resultSet.getString("eligibility")
                );

                scheme.put(
                        "benefit",
                        resultSet.getString("benefit")
                );

                scheme.put(
                        "deadline",
                        resultSet.getDate("deadline")
                );

                scheme.put(
                        "officialInformationUrl",
                        resultSet.getString(
                                "official_information_url"
                        )
                );

                long departmentId =
                        resultSet.getLong("department_id");

                if (resultSet.wasNull()) {

                    scheme.put(
                            "departmentId",
                            null
                    );

                } else {

                    scheme.put(
                            "departmentId",
                            departmentId
                    );
                }

                scheme.put(
                        "departmentName",
                        resultSet.getString(
                                "department_name"
                        )
                );

                scheme.put(
                        "departmentCode",
                        resultSet.getString(
                                "department_code"
                        )
                );

                schemes.add(scheme);
            }

            request.setAttribute(
                    "schemes",
                    schemes
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/government-schemes.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            log(
                    "Unable to load government schemes for entrepreneur.",
                    e
            );

            throw new ServletException(
                    "Unable to load government schemes.",
                    e
            );
        }
    }

    private boolean isEntrepreneur(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null ||
            !"ENTREPRENEUR".equalsIgnoreCase(
                    String.valueOf(
                            session.getAttribute(
                                    "userRole"
                            )
                    )
            )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return false;
        }

        return true;
    }
}