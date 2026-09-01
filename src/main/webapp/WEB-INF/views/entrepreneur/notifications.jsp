<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.Timestamp" %>

<%!
    private String esc(Object value) {
        if (value == null) {
            return "";
        }

        return String.valueOf(value)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    String userName =
            (String) session.getAttribute("userName");

    if (userName == null ||
        userName.isBlank()) {

        userName = "Entrepreneur";
    }

    @SuppressWarnings("unchecked")
    List<Map<String, Object>> notifications =
            (List<Map<String, Object>>)
            request.getAttribute("notifications");

    Integer totalNotifications =
            (Integer)
            request.getAttribute("totalNotifications");

    Integer unreadNotifications =
            (Integer)
            request.getAttribute("unreadNotifications");

    Integer applicationNotifications =
            (Integer)
            request.getAttribute("applicationNotifications");

    Integer actionNotifications =
            (Integer)
            request.getAttribute("actionNotifications");

    if (totalNotifications == null) {
        totalNotifications = 0;
    }

    if (unreadNotifications == null) {
        unreadNotifications = 0;
    }

    if (applicationNotifications == null) {
        applicationNotifications = 0;
    }

    if (actionNotifications == null) {
        actionNotifications = 0;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Notifications | CHAPERON</title>

<style>

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, Helvetica, sans-serif;
    background: #f5f8fc;
    color: #17233c;
}

.layout {
    display: flex;
    min-height: 100vh;
}


/* ============================
   SIDEBAR
   ============================ */

.sidebar {
    width: 265px;
    background: #10233f;
    color: white;
    padding: 24px 18px;
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    overflow-y: auto;
}

.logo {
    font-size: 25px;
    font-weight: 900;
    margin-bottom: 6px;
}

.tagline {
    font-size: 11px;
    color: #b7c4d6;
    line-height: 1.5;
    margin-bottom: 28px;
}

.user-box {
    padding: 15px;
    background: rgba(255,255,255,0.08);
    border-radius: 12px;
    margin-bottom: 25px;
}

.user-label {
    font-size: 11px;
    color: #aebed2;
    margin-bottom: 4px;
}

.user-name {
    font-size: 14px;
    font-weight: 800;
}

.menu {
    display: flex;
    flex-direction: column;
    gap: 6px;
}

.menu-heading {
    color: #8296b1;
    font-size: 10px;
    font-weight: 900;
    letter-spacing: 1px;
    margin: 15px 10px 7px;
}

.menu-item {
    color: #d6e0ec;
    text-decoration: none;
    padding: 12px 13px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 700;
    display: flex;
    align-items: center;
    gap: 10px;
}

.menu-item:hover {
    background: rgba(255,255,255,0.08);
    color: white;
}

.menu-item.active {
    background: #1677e8;
    color: white;
}

.menu-icon {
    width: 20px;
    text-align: center;
}

.menu-separator {
    height: 1px;
    background: rgba(255,255,255,0.12);
    margin: 12px 0;
}


/* ============================
   MAIN
   ============================ */

.main {
    margin-left: 265px;
    width: calc(100% - 265px);
}

.topbar {
    min-height: 70px;
    background: white;
    border-bottom: 1px solid #e4eaf1;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 35px;
    position: sticky;
    top: 0;
    z-index: 20;
}

.topbar-title {
    font-size: 18px;
    font-weight: 800;
}

.topbar-user {
    font-size: 13px;
    color: #64748b;
}

.content {
    padding: 35px;
    max-width: 1400px;
    margin: auto;
}


/* ============================
   HERO
   ============================ */

.hero {
    background: white;
    border: 1px solid #e5eaf1;
    border-radius: 20px;
    padding: 28px;
    margin-bottom: 24px;
    box-shadow: 0 10px 30px rgba(24,50,84,0.06);
}

.hero-row {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 20px;
}

.hero h1 {
    margin: 0 0 8px;
    font-size: 30px;
}

.hero p {
    margin: 0;
    color: #68778a;
    line-height: 1.6;
    max-width: 760px;
}

.mark-all-btn {
    border: 0;
    background: #1677e8;
    color: white;
    padding: 11px 16px;
    border-radius: 9px;
    font-weight: 800;
    cursor: pointer;
}

.mark-all-btn:hover {
    background: #0f67c8;
}


/* ============================
   SUMMARY
   ============================ */

.summary-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 16px;
    margin-bottom: 24px;
}

.summary-card {
    background: white;
    border: 1px solid #e4eaf1;
    border-radius: 15px;
    padding: 20px;
}

.summary-label {
    color: #758297;
    font-size: 11px;
    font-weight: 800;
    text-transform: uppercase;
    margin-bottom: 9px;
}

.summary-value {
    font-size: 29px;
    font-weight: 900;
}


/* ============================
   NOTIFICATIONS
   ============================ */

.section-card {
    background: white;
    border: 1px solid #e4eaf1;
    border-radius: 18px;
    padding: 25px;
}

.section-title {
    margin-bottom: 20px;
}

.section-title h2 {
    margin: 0 0 6px;
    font-size: 21px;
}

.section-title p {
    margin: 0;
    color: #728096;
    font-size: 14px;
}

.notification-list {
    display: grid;
    gap: 14px;
}

.notification-card {
    border: 1px solid #e3e9f0;
    border-radius: 15px;
    padding: 18px;
    background: white;
}

.notification-card.unread {
    border-left: 5px solid #1677e8;
    background: #fbfdff;
}

.notification-header {
    display: flex;
    justify-content: space-between;
    gap: 16px;
    margin-bottom: 10px;
}

.notification-title {
    font-size: 16px;
    font-weight: 900;
    margin-bottom: 5px;
}

.notification-time {
    font-size: 11px;
    color: #8490a0;
}

.notification-message {
    color: #58687d;
    line-height: 1.6;
    font-size: 14px;
    margin-bottom: 14px;
}


/* ============================
   BADGES
   ============================ */

.badges {
    display: flex;
    flex-wrap: wrap;
    gap: 7px;
    margin-bottom: 13px;
}

.badge {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 900;
}

.badge-unread {
    background: #e8f2ff;
    color: #1768c7;
}

.badge-read {
    background: #eef2f6;
    color: #67778a;
}

.badge-query {
    background: #fff2d9;
    color: #986000;
}

.badge-inspection {
    background: #e8f2ff;
    color: #1768c7;
}

.badge-approved {
    background: #e8f7ed;
    color: #267a42;
}

.badge-rejected {
    background: #ffe9e7;
    color: #c43329;
}

.badge-renewal {
    background: #f3eaff;
    color: #7548a8;
}

.badge-default {
    background: #eef2f6;
    color: #58687d;
}


/* ============================
   RELATED APPLICATION
   ============================ */

.application-box {
    background: #f8fafc;
    border: 1px solid #edf1f5;
    border-radius: 11px;
    padding: 12px;
    margin-bottom: 13px;
}

.application-label {
    font-size: 10px;
    color: #7b8798;
    font-weight: 900;
    text-transform: uppercase;
    margin-bottom: 5px;
}

.application-value {
    font-size: 13px;
    font-weight: 700;
    color: #293c53;
    line-height: 1.5;
}


/* ============================
   ACTIONS
   ============================ */

.actions {
    display: flex;
    flex-wrap: wrap;
    gap: 9px;
}

.primary-btn,
.secondary-btn,
.read-btn {
    display: inline-block;
    text-decoration: none;
    padding: 10px 14px;
    border-radius: 9px;
    font-size: 12px;
    font-weight: 800;
}

.primary-btn {
    background: #1677e8;
    color: white;
}

.secondary-btn {
    background: #eef2f6;
    color: #43546a;
}

.read-btn {
    border: 1px solid #dce4ed;
    background: white;
    color: #526276;
    cursor: pointer;
}


/* ============================
   EMPTY
   ============================ */

.empty-state {
    padding: 55px 20px;
    text-align: center;
}

.empty-state h3 {
    margin: 0 0 8px;
}

.empty-state p {
    color: #758297;
    max-width: 560px;
    margin: 0 auto 20px;
    line-height: 1.6;
}


/* ============================
   RESPONSIVE
   ============================ */

@media(max-width: 1000px) {

    .summary-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media(max-width: 800px) {

    .layout {
        display: block;
    }

    .sidebar {
        position: static;
        width: 100%;
    }

    .main {
        margin-left: 0;
        width: 100%;
    }

    .content {
        padding: 20px;
    }

    .summary-grid {
        grid-template-columns: 1fr;
    }

    .hero-row {
        flex-direction: column;
    }

    .notification-header {
        flex-direction: column;
    }
}

</style>

</head>

<body>

<div class="layout">


<!-- ============================
     SIDEBAR
     ============================ -->

<aside class="sidebar">

    <div class="logo">
        CHAPERON
    </div>

    <div class="tagline">
        FROM BUSINESS IDEA TO APPROVAL —
        <br>
        ONE INTELLIGENT JOURNEY
    </div>

    <div class="user-box">

        <div class="user-label">
            Logged in as
        </div>

        <div class="user-name">
            <%= esc(userName) %>
        </div>

    </div>


    <nav class="menu">


        <div class="menu-heading">
            YOUR JOURNEY
        </div>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/dashboard">

            <span class="menu-icon">⌂</span>

            Home

        </a>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/business-onboarding">

            <span class="menu-icon">▣</span>

            My Business

        </a>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/generate-approvals">

            <span class="menu-icon">✓</span>

            My Approval Journey

        </a>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/documents">

            <span class="menu-icon">▤</span>

            Documents

        </a>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/my-applications">

            <span class="menu-icon">▦</span>

            Applications

        </a>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/inspections">

            <span class="menu-icon">⌕</span>

            Inspections

        </a>


        <div class="menu-heading">
            SUPPORT & COMPLIANCE
        </div>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/schemes">

            <span class="menu-icon">★</span>

            Government Schemes

        </a>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/compliance">

            <span class="menu-icon">⚙</span>

            Compliance

        </a>


        <a class="menu-item active"
           href="<%= request.getContextPath() %>/entrepreneur/notifications">

            <span class="menu-icon">●</span>

            Notifications

        </a>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/help">

            <span class="menu-icon">?</span>

            Help

        </a>


        <div class="menu-heading">
            ACCOUNT
        </div>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/profile">

            <span class="menu-icon">👤</span>

            Profile

        </a>


        <div class="menu-separator"></div>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/logout">

            <span class="menu-icon">↪</span>

            Logout

        </a>


    </nav>

</aside>


<!-- ============================
     MAIN
     ============================ -->

<main class="main">


    <div class="topbar">

        <div class="topbar-title">
            Notification Center
        </div>

        <div class="topbar-user">
            <%= esc(userName) %>
        </div>

    </div>


    <div class="content">


        <!-- HERO -->

        <div class="hero">

            <div class="hero-row">

                <div>

                    <h1>
                        Notifications
                    </h1>

                    <p>
                        Track important updates related to your
                        applications, officer queries, inspections,
                        approvals, rejections, compliance and renewals.
                    </p>

                </div>


                <%
                if (unreadNotifications > 0) {
                %>

                <form method="post"
                      action="<%= request.getContextPath() %>/entrepreneur/notifications">

                    <input type="hidden"
                           name="action"
                           value="markAllRead">

                    <button class="mark-all-btn"
                            type="submit">

                        Mark All as Read

                    </button>

                </form>

                <%
                }
                %>


            </div>

        </div>


        <!-- SUMMARY -->

        <div class="summary-grid">


            <div class="summary-card">

                <div class="summary-label">
                    Total Notifications
                </div>

                <div class="summary-value">
                    <%= totalNotifications %>
                </div>

            </div>


            <div class="summary-card">

                <div class="summary-label">
                    Unread
                </div>

                <div class="summary-value">
                    <%= unreadNotifications %>
                </div>

            </div>


            <div class="summary-card">

                <div class="summary-label">
                    Application Updates
                </div>

                <div class="summary-value">
                    <%= applicationNotifications %>
                </div>

            </div>


            <div class="summary-card">

                <div class="summary-label">
                    Action Required
                </div>

                <div class="summary-value">
                    <%= actionNotifications %>
                </div>

            </div>


        </div>


        <!-- NOTIFICATION LIST -->

        <div class="section-card">


            <div class="section-title">

                <h2>
                    Recent Notifications
                </h2>

                <p>
                    Unread notifications are shown first.
                </p>

            </div>


            <%
            if (notifications == null ||
                notifications.isEmpty()) {
            %>


            <div class="empty-state">

                <h3>
                    No notifications yet
                </h3>

                <p>
                    Important application updates,
                    inspection schedules,
                    officer queries,
                    approvals and renewal reminders
                    will appear here.
                </p>

                <a class="primary-btn"
                   href="<%= request.getContextPath() %>/entrepreneur/my-applications">

                    View Applications

                </a>

            </div>


            <%
            } else {
            %>


            <div class="notification-list">


            <%
            for (Map<String, Object> notificationRow
                    : notifications) {


                Long notificationId =
                        notificationRow.get("notificationId") != null
                        ? ((Number)
                           notificationRow.get("notificationId"))
                           .longValue()
                        : null;


                Long applicationId =
                        notificationRow.get("applicationId") != null
                        ? ((Number)
                           notificationRow.get("applicationId"))
                           .longValue()
                        : null;


                String type =
                        notificationRow.get("notificationType") != null
                        ? String.valueOf(
                                notificationRow.get("notificationType"))
                        : "GENERAL";


                String title =
                        notificationRow.get("title") != null
                        ? String.valueOf(
                                notificationRow.get("title"))
                        : "Notification";


                String message =
                        notificationRow.get("message") != null
                        ? String.valueOf(
                                notificationRow.get("message"))
                        : "";


                String actionUrl =
                        notificationRow.get("actionUrl") != null
                        ? String.valueOf(
                                notificationRow.get("actionUrl"))
                        : null;


                boolean read =
                        notificationRow.get("read") != null
                        && Boolean.TRUE.equals(
                                notificationRow.get("read"));


                Timestamp createdAt =
                        (Timestamp)
                        notificationRow.get("createdAt");


                String applicationNumber =
                        notificationRow.get("applicationNumber") != null
                        ? String.valueOf(
                                notificationRow.get("applicationNumber"))
                        : null;


                String applicationStatus =
                        notificationRow.get("applicationStatus") != null
                        ? String.valueOf(
                                notificationRow.get("applicationStatus"))
                        : null;


                String approvalName =
                        notificationRow.get("approvalName") != null
                        ? String.valueOf(
                                notificationRow.get("approvalName"))
                        : null;


                String typeUpper =
                        type.toUpperCase();


                String typeBadgeClass =
                        "badge-default";


                if (typeUpper.contains("QUERY")) {

                    typeBadgeClass =
                            "badge-query";

                } else if (
                        typeUpper.contains("INSPECTION")) {

                    typeBadgeClass =
                            "badge-inspection";

                } else if (
                        typeUpper.contains("APPROV")) {

                    typeBadgeClass =
                            "badge-approved";

                } else if (
                        typeUpper.contains("REJECT")) {

                    typeBadgeClass =
                            "badge-rejected";

                } else if (
                        typeUpper.contains("RENEW") ||
                        typeUpper.contains("COMPLIANCE")) {

                    typeBadgeClass =
                            "badge-renewal";
                }
            %>


            <div class="notification-card <%= !read ? "unread" : "" %>">


                <div class="notification-header">


                    <div>

                        <div class="notification-title">
                            <%= esc(title) %>
                        </div>

                        <div class="notification-time">

                            <%= createdAt != null
                                    ? createdAt
                                    : "" %>

                        </div>

                    </div>


                    <div class="badges">

                        <span class="badge <%= typeBadgeClass %>">

                            <%= esc(
                                    type.replace(
                                            "_",
                                            " ")
                            ) %>

                        </span>


                        <span class="badge <%= read
                                ? "badge-read"
                                : "badge-unread" %>">

                            <%= read
                                    ? "READ"
                                    : "UNREAD" %>

                        </span>

                    </div>


                </div>


                <div class="notification-message">

                    <%= esc(message) %>

                </div>


                <%
                if (applicationId != null ||
                    applicationNumber != null ||
                    approvalName != null) {
                %>


                <div class="application-box">


                    <div class="application-label">
                        Related Application
                    </div>


                    <div class="application-value">


                        <%
                        if (approvalName != null) {
                        %>

                        <%= esc(approvalName) %>

                        <%
                        }
                        %>


                        <%
                        if (applicationNumber != null) {
                        %>

                        <br>

                        Application:

                        <%= esc(applicationNumber) %>

                        <%
                        }
                        %>


                        <%
                        if (applicationStatus != null) {
                        %>

                        <br>

                        Current Status:

                        <%= esc(
                                applicationStatus
                                .replace(
                                        "_",
                                        " ")
                        ) %>

                        <%
                        }
                        %>


                    </div>


                </div>


                <%
                }
                %>


                <div class="actions">


                    <%
                    if (applicationId != null) {
                    %>


                    <a class="primary-btn"
                       href="<%= request.getContextPath() %>/entrepreneur/application-details?id=<%= applicationId %>">

                        View Application

                    </a>


                    <%
                    }
                    %>


                    <%
                    /*
                     * Security:
                     * Notification action URLs are restricted
                     * to CHAPERON's own context.
                     */

                    String finalActionUrl = null;

                    if (actionUrl != null &&
                        !actionUrl.isBlank()) {

                        String cleanActionUrl =
                                actionUrl.trim();

                        if (cleanActionUrl.startsWith(
                                request.getContextPath() + "/")) {

                            finalActionUrl =
                                    cleanActionUrl;

                        } else if (
                                cleanActionUrl.startsWith("/")) {

                            finalActionUrl =
                                    request.getContextPath()
                                    + cleanActionUrl;

                        } else if (
                                !cleanActionUrl.contains("://") &&
                                !cleanActionUrl.startsWith("//")) {

                            finalActionUrl =
                                    request.getContextPath()
                                    + "/"
                                    + cleanActionUrl;
                        }
                    }


                    if (finalActionUrl != null) {
                    %>


                    <a class="secondary-btn"
                       href="<%= esc(finalActionUrl) %>">

                        Open Action

                    </a>


                    <%
                    }
                    %>


                    <%
                    if (!read &&
                        notificationId != null) {
                    %>


                    <form method="post"
                          action="<%= request.getContextPath() %>/entrepreneur/notifications"
                          style="display:inline;">


                        <input type="hidden"
                               name="action"
                               value="markRead">


                        <input type="hidden"
                               name="notificationId"
                               value="<%= notificationId %>">


                        <button class="read-btn"
                                type="submit">

                            Mark as Read

                        </button>


                    </form>


                    <%
                    }
                    %>


                </div>


            </div>


            <%
            }
            %>


            </div>


            <%
            }
            %>


        </div>


    </div>


</main>


</div>

</body>

</html>