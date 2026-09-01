package com.chaperon.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
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


@WebServlet("/entrepreneur/inspections")
public class EntrepreneurInspectionsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    private static final String FIND_INSPECTIONS =

            "SELECT " +
            "i.inspection_id, " +
            "i.application_id, " +
            "i.inspection_type, " +
            "i.department_id, " +
            "i.officer_profile_id, " +
            "i.inspection_date, " +
            "i.inspection_time, " +
            "i.location, " +
            "i.remarks, " +
            "i.status, " +
            "i.result, " +
            "i.inspection_notes, " +
            "i.recommendation, " +
            "i.created_at, " +
            "i.updated_at, " +

            "a.application_number, " +
            "a.current_status AS application_status, " +

            "ap.approval_name, " +
            "ap.approval_code, " +

            "d.department_name, " +
            "d.department_code, " +

            "u.full_name AS officer_name, " +
            "op.designation AS officer_designation, " +
            "op.employee_code " +

            "FROM inspections i " +

            "INNER JOIN applications a " +
            "ON i.application_id = a.application_id " +

            "INNER JOIN approvals ap " +
            "ON a.approval_id = ap.approval_id " +

            "LEFT JOIN departments d " +
            "ON i.department_id = d.department_id " +

            "LEFT JOIN officer_profiles op " +
            "ON i.officer_profile_id = op.officer_profile_id " +

            "LEFT JOIN users u " +
            "ON op.user_id = u.user_id " +

            "WHERE a.user_id = ? " +

            "ORDER BY " +
            "i.inspection_date DESC, " +
            "i.inspection_time DESC, " +
            "i.inspection_id DESC";


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {


        /*
         * ==========================================
         * 1. SESSION CHECK
         * ==========================================
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


        if (!"ENTREPRENEUR".equalsIgnoreCase(
                String.valueOf(
                        session.getAttribute("userRole")
                )
        )) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "This page is only available for entrepreneurs."
            );

            return;
        }


        long userId =
                ((Number)
                session.getAttribute("userId"))
                .longValue();


        /*
         * ==========================================
         * 2. LOAD INSPECTIONS
         * ==========================================
         */

        List<Map<String, Object>> inspections =
                new ArrayList<>();


        int totalInspections = 0;

        int scheduledInspections = 0;

        int completedInspections = 0;

        int passedInspections = 0;


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(
                            FIND_INSPECTIONS
                    )
        ) {


            statement.setLong(
                    1,
                    userId
            );


            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {


                while (resultSet.next()) {


                    Map<String, Object> inspection =
                            new HashMap<>();


                    /*
                     * ==================================
                     * INSPECTION BASIC DATA
                     * ==================================
                     */

                    inspection.put(
                            "inspectionId",
                            resultSet.getLong(
                                    "inspection_id"
                            )
                    );


                    inspection.put(
                            "applicationId",
                            resultSet.getLong(
                                    "application_id"
                            )
                    );


                    inspection.put(
                            "inspectionType",
                            resultSet.getString(
                                    "inspection_type"
                            )
                    );


                    /*
                     * ==================================
                     * DATE / TIME
                     * ==================================
                     */

                    Date inspectionDate =
                            resultSet.getDate(
                                    "inspection_date"
                            );


                    Time inspectionTime =
                            resultSet.getTime(
                                    "inspection_time"
                            );


                    inspection.put(
                            "inspectionDate",
                            inspectionDate
                    );


                    inspection.put(
                            "inspectionTime",
                            inspectionTime
                    );


                    /*
                     * ==================================
                     * LOCATION
                     * ==================================
                     */

                    inspection.put(
                            "location",
                            resultSet.getString(
                                    "location"
                            )
                    );


                    /*
                     * ==================================
                     * STATUS / RESULT
                     * ==================================
                     */

                    String status =
                            resultSet.getString(
                                    "status"
                            );


                    String result =
                            resultSet.getString(
                                    "result"
                            );


                    inspection.put(
                            "status",
                            status
                    );


                    inspection.put(
                            "result",
                            result
                    );


                    /*
                     * ==================================
                     * REMARKS
                     * ==================================
                     */

                    inspection.put(
                            "remarks",
                            resultSet.getString(
                                    "remarks"
                            )
                    );


                    inspection.put(
                            "inspectionNotes",
                            resultSet.getString(
                                    "inspection_notes"
                            )
                    );


                    inspection.put(
                            "recommendation",
                            resultSet.getString(
                                    "recommendation"
                            )
                    );


                    /*
                     * ==================================
                     * APPLICATION
                     * ==================================
                     */

                    inspection.put(
                            "applicationNumber",
                            resultSet.getString(
                                    "application_number"
                            )
                    );


                    inspection.put(
                            "applicationStatus",
                            resultSet.getString(
                                    "application_status"
                            )
                    );


                    /*
                     * ==================================
                     * APPROVAL
                     * ==================================
                     */

                    inspection.put(
                            "approvalName",
                            resultSet.getString(
                                    "approval_name"
                            )
                    );


                    inspection.put(
                            "approvalCode",
                            resultSet.getString(
                                    "approval_code"
                            )
                    );


                    /*
                     * ==================================
                     * DEPARTMENT
                     * ==================================
                     */

                    inspection.put(
                            "departmentName",
                            resultSet.getString(
                                    "department_name"
                            )
                    );


                    inspection.put(
                            "departmentCode",
                            resultSet.getString(
                                    "department_code"
                            )
                    );


                    /*
                     * ==================================
                     * OFFICER
                     * ==================================
                     */

                    inspection.put(
                            "officerName",
                            resultSet.getString(
                                    "officer_name"
                            )
                    );


                    inspection.put(
                            "officerDesignation",
                            resultSet.getString(
                                    "officer_designation"
                            )
                    );


                    inspection.put(
                            "employeeCode",
                            resultSet.getString(
                                    "employee_code"
                            )
                    );


                    /*
                     * ==================================
                     * TIMESTAMPS
                     * ==================================
                     */

                    Timestamp createdAt =
                            resultSet.getTimestamp(
                                    "created_at"
                            );


                    Timestamp updatedAt =
                            resultSet.getTimestamp(
                                    "updated_at"
                            );


                    inspection.put(
                            "createdAt",
                            createdAt
                    );


                    inspection.put(
                            "updatedAt",
                            updatedAt
                    );


                    /*
                     * ==================================
                     * SUMMARY COUNTS
                     * ==================================
                     */

                    totalInspections++;


                    if ("SCHEDULED".equalsIgnoreCase(
                            status
                    )) {

                        scheduledInspections++;
                    }


                    if ("COMPLETED".equalsIgnoreCase(
                            status
                    )) {

                        completedInspections++;
                    }


                    if ("PASSED".equalsIgnoreCase(
                            result
                    )) {

                        passedInspections++;
                    }


                    inspections.add(
                            inspection
                    );
                }
            }


            /*
             * ==========================================
             * 3. SEND DATA TO JSP
             * ==========================================
             */

            request.setAttribute(
                    "inspections",
                    inspections
            );


            request.setAttribute(
                    "totalInspections",
                    totalInspections
            );


            request.setAttribute(
                    "scheduledInspections",
                    scheduledInspections
            );


            request.setAttribute(
                    "completedInspections",
                    completedInspections
            );


            request.setAttribute(
                    "passedInspections",
                    passedInspections
            );


            /*
             * ==========================================
             * 4. OPEN JSP
             * ==========================================
             */

            request.getRequestDispatcher(
                    "/WEB-INF/views/entrepreneur/inspections.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (SQLException e) {


            log(
                    "Unable to load entrepreneur inspections.",
                    e
            );


            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load inspections."
            );
        }
    }
}