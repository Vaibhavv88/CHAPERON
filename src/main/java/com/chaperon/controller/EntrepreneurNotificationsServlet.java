package com.chaperon.controller;

import com.chaperon.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/entrepreneur/notifications")
public class EntrepreneurNotificationsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    /*
     * =========================================================
     * LOAD ENTREPRENEUR NOTIFICATIONS
     * =========================================================
     */

    private static final String FIND_NOTIFICATIONS =
            "SELECT " +
            "n.notification_id, " +
            "n.user_id, " +
            "n.application_id, " +
            "n.notification_type, " +
            "n.title, " +
            "n.message, " +
            "n.action_url, " +
            "n.is_read, " +
            "n.created_at, " +
            "a.application_number, " +
            "a.current_status AS application_status, " +
            "ap.approval_name, " +
            "ap.approval_code " +

            "FROM notifications n " +

            "LEFT JOIN applications a " +
            "ON n.application_id = a.application_id " +

            "LEFT JOIN approvals ap " +
            "ON a.approval_id = ap.approval_id " +

            "WHERE n.user_id = ? " +

            "ORDER BY n.is_read ASC, " +
            "n.created_at DESC, " +
            "n.notification_id DESC";


    /*
     * =========================================================
     * MARK SINGLE NOTIFICATION AS READ
     * =========================================================
     */

    private static final String MARK_AS_READ =
            "UPDATE notifications " +
            "SET is_read = 1 " +
            "WHERE notification_id = ? " +
            "AND user_id = ?";


    /*
     * =========================================================
     * MARK ALL AS READ
     * =========================================================
     */

    private static final String MARK_ALL_AS_READ =
            "UPDATE notifications " +
            "SET is_read = 1 " +
            "WHERE user_id = ? " +
            "AND is_read = 0";


    /*
     * =========================================================
     * GET
     * =========================================================
     */

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);


        /*
         * Check login
         */
        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }


        Object userIdObject =
                session.getAttribute("userId");

        String userRole =
                (String)
                session.getAttribute("userRole");


        /*
         * Check entrepreneur role
         */
        if (userIdObject == null ||
            userRole == null ||
            !"ENTREPRENEUR".equalsIgnoreCase(userRole)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }


        long userId =
                ((Number) userIdObject)
                .longValue();


        List<Map<String, Object>> notifications =
                new ArrayList<>();


        int totalNotifications = 0;
        int unreadNotifications = 0;
        int applicationNotifications = 0;
        int actionNotifications = 0;


        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(
                             FIND_NOTIFICATIONS)) {


            statement.setLong(
                    1,
                    userId
            );


            try (ResultSet rs =
                         statement.executeQuery()) {


                while (rs.next()) {

                    Map<String, Object> notification =
                            new HashMap<>();


                    long notificationId =
                            rs.getLong(
                                    "notification_id"
                            );


                    long applicationId =
                            rs.getLong(
                                    "application_id"
                            );

                    boolean applicationIdWasNull =
                            rs.wasNull();


                    String notificationType =
                            rs.getString(
                                    "notification_type"
                            );


                    boolean isRead =
                            rs.getBoolean(
                                    "is_read"
                            );


                    /*
                     * Summary counts
                     */
                    totalNotifications++;


                    if (!isRead) {

                        unreadNotifications++;
                    }


                    if (!applicationIdWasNull) {

                        applicationNotifications++;
                    }


                    /*
                     * Notifications that normally
                     * require entrepreneur attention.
                     */
                    if (notificationType != null) {

                        String type =
                                notificationType
                                .toUpperCase();


                        if (type.contains("QUERY") ||
                            type.contains("INSPECTION") ||
                            type.contains("RENEWAL") ||
                            type.contains("COMPLIANCE") ||
                            type.contains("REJECT")) {

                            actionNotifications++;
                        }
                    }


                    /*
                     * Notification data
                     */
                    notification.put(
                            "notificationId",
                            notificationId
                    );

                    notification.put(
                            "applicationId",
                            applicationIdWasNull
                            ? null
                            : applicationId
                    );

                    notification.put(
                            "notificationType",
                            notificationType
                    );

                    notification.put(
                            "title",
                            rs.getString(
                                    "title"
                            )
                    );

                    notification.put(
                            "message",
                            rs.getString(
                                    "message"
                            )
                    );

                    notification.put(
                            "actionUrl",
                            rs.getString(
                                    "action_url"
                            )
                    );

                    notification.put(
                            "read",
                            isRead
                    );

                    notification.put(
                            "createdAt",
                            rs.getTimestamp(
                                    "created_at"
                            )
                    );


                    /*
                     * Application information
                     */
                    notification.put(
                            "applicationNumber",
                            rs.getString(
                                    "application_number"
                            )
                    );

                    notification.put(
                            "applicationStatus",
                            rs.getString(
                                    "application_status"
                            )
                    );

                    notification.put(
                            "approvalName",
                            rs.getString(
                                    "approval_name"
                            )
                    );

                    notification.put(
                            "approvalCode",
                            rs.getString(
                                    "approval_code"
                            )
                    );


                    notifications.add(
                            notification
                    );
                }
            }


        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load notifications.",
                    e
            );
        }


        /*
         * Send data to JSP
         */
        request.setAttribute(
                "notifications",
                notifications
        );

        request.setAttribute(
                "totalNotifications",
                totalNotifications
        );

        request.setAttribute(
                "unreadNotifications",
                unreadNotifications
        );

        request.setAttribute(
                "applicationNotifications",
                applicationNotifications
        );

        request.setAttribute(
                "actionNotifications",
                actionNotifications
        );


        request.getRequestDispatcher(
                "/WEB-INF/views/entrepreneur/notifications.jsp"
        ).forward(
                request,
                response
        );
    }


    /*
     * =========================================================
     * POST
     *
     * Handles:
     *
     * 1. Mark one notification read
     * 2. Mark all notifications read
     * =========================================================
     */

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        HttpSession session =
                request.getSession(false);


        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }


        Object userIdObject =
                session.getAttribute("userId");

        String userRole =
                (String)
                session.getAttribute("userRole");


        if (userIdObject == null ||
            userRole == null ||
            !"ENTREPRENEUR".equalsIgnoreCase(userRole)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur-login"
            );

            return;
        }


        long userId =
                ((Number) userIdObject)
                .longValue();


        String action =
                request.getParameter("action");


        if (action == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/entrepreneur/notifications"
            );

            return;
        }


        try {

            /*
             * =============================================
             * MARK ALL READ
             * =============================================
             */
            if ("markAllRead".equalsIgnoreCase(action)) {

                markAllAsRead(
                        userId
                );
            }


            /*
             * =============================================
             * MARK ONE READ
             * =============================================
             */
            else if ("markRead".equalsIgnoreCase(action)) {

                String notificationIdText =
                        request.getParameter(
                                "notificationId"
                        );


                if (notificationIdText != null &&
                    !notificationIdText.isBlank()) {


                    long notificationId =
                            Long.parseLong(
                                    notificationIdText
                            );


                    markAsRead(
                            notificationId,
                            userId
                    );
                }
            }


        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to update notification.",
                    e
            );

        } catch (NumberFormatException e) {

            throw new ServletException(
                    "Invalid notification ID.",
                    e
            );
        }


        /*
         * PRG pattern:
         * POST -> Redirect -> GET
         */
        response.sendRedirect(
                request.getContextPath()
                + "/entrepreneur/notifications"
        );
    }


    /*
     * =========================================================
     * MARK ONE AS READ
     * =========================================================
     */

    private void markAsRead(
            long notificationId,
            long userId)
            throws SQLException {


        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(
                             MARK_AS_READ)) {


            statement.setLong(
                    1,
                    notificationId
            );

            statement.setLong(
                    2,
                    userId
            );


            statement.executeUpdate();
        }
    }


    /*
     * =========================================================
     * MARK ALL AS READ
     * =========================================================
     */

    private void markAllAsRead(
            long userId)
            throws SQLException {


        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(
                             MARK_ALL_AS_READ)) {


            statement.setLong(
                    1,
                    userId
            );


            statement.executeUpdate();
        }
    }
}