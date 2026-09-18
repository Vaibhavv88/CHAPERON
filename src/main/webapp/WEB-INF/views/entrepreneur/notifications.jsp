<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    String userName = (String) session.getAttribute("userName");
    if (userName == null || userName.isBlank()) {
        userName = "Entrepreneur";
    }
    String avatarLetter = userName.substring(0, 1).toUpperCase();
    String ctx = request.getContextPath();

    @SuppressWarnings("unchecked")
    List<Map<String, Object>> notifications = (List<Map<String, Object>>) request.getAttribute("notifications");

    Integer totalNotifications = (Integer) request.getAttribute("totalNotifications");
    Integer unreadNotifications = (Integer) request.getAttribute("unreadNotifications");
    Integer applicationNotifications = (Integer) request.getAttribute("applicationNotifications");
    Integer actionNotifications = (Integer) request.getAttribute("actionNotifications");

    if (totalNotifications == null) totalNotifications = 0;
    if (unreadNotifications == null) unreadNotifications = 0;
    if (applicationNotifications == null) applicationNotifications = 0;
    if (actionNotifications == null) actionNotifications = 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications | CHAPERON</title>
    <link rel="stylesheet" href="<%= ctx %>/assets/css/entrepreneur-enhancements.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --blue: #0962e8; --blue-dark: #0646b5; --cyan: #27b5ed;
            --navy: #102446; --text: #263954; --muted: #7b8ca5;
            --green: #149a61; --orange: #e58b29; --red: #d94c4c;
            --bg: #f2f6fc;
            --shadow: 0 10px 30px rgba(35, 66, 111, 0.07);
            --shadow-hover: 0 16px 38px rgba(35, 66, 111, 0.12);
        }

        body {
            min-height: 100vh;
            font-family: Inter, "Segoe UI", Arial, sans-serif;
            color: var(--text);
            background: radial-gradient(circle at 90% 4%, rgba(39, 181, 237, 0.08), transparent 22%), var(--bg);
            font-size: 15px;
        }

        a { color: inherit; text-decoration: none; }

        .app-shell {
            min-height: 100vh;
            display: grid;
            grid-template-columns: 238px minmax(0, 1fr);
        }

        /* SIDEBAR */
        .sidebar {
            position: sticky; top: 0; height: 100vh; padding: 26px 20px;
            display: flex; flex-direction: column;
            border-right: 1px solid #dce7f4;
            background: rgba(255, 255, 255, 0.96);
            backdrop-filter: blur(16px);
            box-shadow: 8px 0 32px rgba(32, 74, 123, 0.055);
        }
        .sidebar-brand { width: 100%; min-width: 0; margin-bottom: 34px; padding: 0 4px; display: flex; align-items: center; gap: 11px; }
        .logo-wrap { width: 47px; height: 47px; min-width: 47px; overflow: hidden; border-radius: 10px; background: white; box-shadow: 0 4px 12px rgba(16, 36, 70, 0.08); }
        .logo-wrap img { width: 100%; height: 100%; object-fit: contain; }
        .brand-title { color: #1053c4; font-size: 21px; font-weight: 900; line-height: 1; white-space: nowrap; }
        .brand-subtitle { margin-top: 4px; color: #667c9c; font-size: 7px; font-weight: 800; line-height: 1.25; letter-spacing: 0.1px; }
        
        .nav-label { margin: 0 10px 10px; color: #9aa8ba; font-size: 10px; font-weight: 900; letter-spacing: 1.2px; }
        .nav-list { display: flex; flex-direction: column; gap: 7px; }
        .nav-item { min-height: 45px; padding: 0 14px; display: flex; align-items: center; gap: 12px; border-radius: 11px; color: #526783; font-size: 13px; font-weight: 700; transition: all 0.2s ease; }
        .nav-item svg { width: 19px; height: 19px; min-width: 19px; }
        .nav-item:hover { color: var(--blue); background: #edf5ff; transform: translateX(3px); }
        .nav-item.active { color: white; background: linear-gradient(135deg, #0962e8, #268de9); box-shadow: 0 9px 20px rgba(9, 98, 232, 0.25); }
        
        .sidebar-spacer { flex: 1; }
        .sidebar-profile { margin-top: 19px; padding: 14px; border: 1px solid #dce7f4; border-radius: 14px; background: linear-gradient(145deg, #ffffff, #f6f9fd); }
        .sidebar-user { display: flex; align-items: center; gap: 10px; }
        .sidebar-avatar { width: 40px; height: 40px; min-width: 40px; display: flex; align-items: center; justify-content: center; border-radius: 50%; color: white; background: linear-gradient(135deg, #0962e9, #68a2ff); font-size: 14px; font-weight: 900; }
        .sidebar-user strong { display: block; max-width: 120px; overflow: hidden; color: #1e3558; font-size: 14px; white-space: nowrap; text-overflow: ellipsis; }
        .sidebar-user span { display: block; margin-top: 2px; color: #8998ac; font-size: 11px; }
        .sidebar-bottom-links { margin-top: 11px; padding-top: 10px; display: flex; justify-content: space-between; border-top: 1px solid #e8eef6; }
        .sidebar-bottom-links a { color: #6b7e98; font-size: 11px; font-weight: 800; }
        .sidebar-bottom-links a:hover { color: var(--blue); }
        .sidebar-bottom-links .logout-link { color: #c24949; }

        /* MAIN CONTENT */
        .main { min-width: 0; padding: 32px; background: radial-gradient(circle at 90% 0, #dcefff 0, transparent 29%), #f3f7fd; }
        
        .topbar { margin-bottom: 25px; display: flex; align-items: center; justify-content: space-between; gap: 20px; }
        .topbar-title h1 { color: #152b4d; font-size: 26px; font-weight: 850; }
        .topbar-title p { margin-top: 4px; color: #8796aa; font-size: 13px; }
        .top-profile { min-height: 42px; padding: 0 16px; display: flex; align-items: center; gap: 8px; border: 1px solid #dce7f5; border-radius: 50px; background: white; color: #425d7e; font-size: 13px; font-weight: 800; box-shadow: 0 6px 18px rgba(26, 72, 122, 0.05); }

        /* HERO */
        .hero { position: relative; overflow: hidden; padding: 32px 34px; margin-bottom: 22px; border: 1px solid #cfe1f5; border-radius: 20px; background: linear-gradient(125deg, #075ecb, #1688ef 65%, #35a9ef); box-shadow: 0 11px 31px rgba(27, 65, 107, 0.1); color: white; display: flex; justify-content: space-between; align-items: flex-start; gap: 20px; flex-wrap: wrap; }
        .hero-text h2 { margin: 0 0 8px; font-size: 28px; font-weight: 900; }
        .hero-text p { max-width: 720px; margin: 0; font-size: 14px; line-height: 1.5; color: #eaf5ff; }

        /* MARK ALL READ BTN */
        .mark-all-btn { display: inline-flex; align-items: center; padding: 12px 18px; border: 1px solid rgba(255,255,255,0.3); border-radius: 10px; background: rgba(255,255,255,0.15); color: white; font-size: 12px; font-weight: 800; cursor: pointer; transition: 0.2s; backdrop-filter: blur(5px); }
        .mark-all-btn:hover { background: rgba(255,255,255,0.25); }
        .mark-all-btn svg { width: 16px; height: 16px; margin-right: 6px; }

        /* SUMMARY METRICS */
        .summary-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 16px; margin-bottom: 24px; }
        .summary-card { background: white; border: 1px solid #dfe8f4; border-radius: 16px; padding: 20px; box-shadow: var(--shadow); transition: 0.2s ease; }
        .summary-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-hover); }
        .summary-label { color: #6e819b; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.3px; margin-bottom: 8px; }
        .summary-value { font-size: 29px; font-weight: 900; color: #102446; line-height: 1; }

        /* NOTIFICATIONS LIST */
        .section-card { background: white; border: 1px solid #dfe8f4; border-radius: 18px; padding: 24px; box-shadow: var(--shadow); }
        .section-header-wrap { margin-bottom: 22px; border-bottom: 1px solid #edf2f9; padding-bottom: 15px; }
        .section-header-wrap h3 { font-size: 19px; font-weight: 850; color: #152b4d; margin-bottom: 4px; }
        .section-header-wrap p { color: #728096; font-size: 13px; margin: 0; }
        
        .notification-list { display: grid; gap: 16px; }
        .notification-card { display: flex; gap: 16px; padding: 20px; border: 1px solid #e2eaf5; border-radius: 14px; background: #ffffff; transition: 0.2s; position: relative; overflow: hidden; }
        .notification-card:hover { transform: translateY(-2px); border-color: #c9dcf5; box-shadow: 0 8px 20px rgba(35, 66, 111, 0.05); }
        
        .notification-card.unread { background: #f4f8ff; border-color: #cde0f7; }
        .notification-card.unread::before { content: ""; position: absolute; left: 0; top: 0; bottom: 0; width: 5px; background: #0962e8; }

        .notif-content { flex: 1; min-width: 0; }
        .notif-header { display: flex; justify-content: space-between; align-items: flex-start; gap: 10px; margin-bottom: 8px; flex-wrap: wrap; }
        .notif-title { font-size: 16px; font-weight: 850; color: #102446; line-height: 1.3; margin-bottom: 4px; }
        .notif-time { font-size: 11px; font-weight: 700; color: #8394ab; }
        
        .notif-message { font-size: 14px; color: #425d7e; line-height: 1.5; margin-bottom: 15px; }

        .badges { display: flex; gap: 6px; flex-wrap: wrap; }
        .badge { display: inline-flex; align-items: center; min-height: 22px; padding: 0 8px; border-radius: 6px; font-size: 9px; font-weight: 900; text-transform: uppercase; white-space: nowrap; }
        
        /* Badges Colors */
        .badge-unread { background: #eef4fc; color: #0962e8; }
        .badge-read { background: #f0f3f7; color: #6b7e98; }
        .badge-query { background: #fff3e4; color: #ba711c; }
        .badge-inspection { background: #edf5ff; color: #0646b5; }
        .badge-approved { background: #e9f8f1; color: #11784c; }
        .badge-rejected { background: #fff0f0; color: #b53a3a; }
        .badge-renewal { background: #f0edff; color: #7458d9; }
        .badge-default { background: #f0f3f7; color: #526783; }

        /* Related Application Box */
        .application-box { background: #f9fbfe; border: 1px solid #eaf0f8; border-radius: 10px; padding: 14px; margin-bottom: 15px; }
        .application-label { font-size: 10px; color: #8394ab; font-weight: 850; text-transform: uppercase; margin-bottom: 6px; letter-spacing: 0.5px; }
        .application-value { font-size: 13px; font-weight: 700; color: #263954; line-height: 1.5; }
        .application-value span { font-weight: 500; color: #6b7e98; }

        /* Actions */
        .actions { display: flex; flex-wrap: wrap; gap: 10px; }
        .primary-btn, .secondary-btn, .read-btn { display: inline-flex; align-items: center; justify-content: center; min-height: 38px; padding: 0 16px; border-radius: 9px; font-size: 12px; font-weight: 800; transition: 0.2s ease; text-decoration: none; border: 0; cursor: pointer; font-family: inherit; }
        .primary-btn { background: linear-gradient(135deg, #0962e8, #0750c5); color: white; box-shadow: 0 6px 14px rgba(9, 98, 232, 0.2); }
        .primary-btn:hover { transform: translateY(-1px); }
        .secondary-btn { background: #edf3fa; color: #435b7a; }
        .secondary-btn:hover { background: #e1ebf7; }
        .read-btn { background: white; border: 1px solid #dce4ed; color: #526783; }
        .read-btn:hover { background: #f8fbfe; color: #102446; border-color: #c9dcf5; }

        .empty-state { text-align: center; padding: 55px 20px; border: 1px dashed #dbe5f2; border-radius: 12px; background: #f9fbfe; }
        .empty-icon { font-size: 40px; margin-bottom: 12px; color: #a9b9cc; }
        .empty-state h3 { font-size: 18px; color: #1a3356; margin-bottom: 8px; }
        .empty-state p { color: #7a8ea5; font-size: 13px; max-width: 500px; margin: 0 auto 15px; line-height: 1.5; }

        @media (max-width: 1050px) {
            .summary-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        }
        @media (max-width: 850px) {
            .app-shell { grid-template-columns: 75px minmax(0, 1fr); }
            .sidebar { padding: 20px 10px; width: 75px; }
            .sidebar-brand { padding: 0; justify-content: center; }
            .sidebar-brand > div:last-child, .nav-label, .nav-item span, .sidebar-profile { display: none; }
            .nav-item { width: 45px; margin: auto; padding: 0; justify-content: center; }
            .main { padding: 20px; }
        }
        @media (max-width: 600px) {
            .app-shell { display: block; }
            .sidebar { position: static; width: 100%; height: auto; padding: 10px 12px; flex-direction: row; align-items: center; overflow-x: auto; }
            .sidebar-brand { margin: 0 15px 0 0; width: auto; }
            .nav-list { flex-direction: row; gap: 5px; }
            .sidebar-spacer { display: none; }
            .summary-grid { grid-template-columns: 1fr; }
            .hero { flex-direction: column; }
            .notif-header { flex-direction: column; gap: 10px; }
            .actions { flex-direction: column; width: 100%; }
            .primary-btn, .secondary-btn, .read-btn { width: 100%; }
        }
    </style>
</head>
<body>

<div class="app-shell">

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <a href="<%= ctx %>/entrepreneur/dashboard" class="sidebar-brand">
            <div class="logo-wrap">
                <img src="<%= ctx %>/images/chaperon-logo.jpeg" alt="CHAPERON Logo">
            </div>
            <div>
                <div class="brand-title">CHAPERON</div>
                <div class="brand-subtitle">GUIDE. CONNECT. COMPLY. GET APPROVED.</div>
            </div>
        </a>

        <div class="nav-label">WORKSPACE</div>

        <nav class="nav-list">
            <a href="<%= ctx %>/entrepreneur/dashboard" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none"><path d="M3 11L12 4L21 11V21H15V15H9V21H3V11Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/></svg>
                <span>Dashboard</span>
            </a>
            <a href="<%= ctx %>/entrepreneur/business-onboarding" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none"><path d="M4 21V8L12 3L20 8V21" stroke="currentColor" stroke-width="2"/><path d="M9 21V14H15V21" stroke="currentColor" stroke-width="2"/></svg>
                <span>My Business</span>
            </a>
            <a href="<%= ctx %>/entrepreneur/generate-approvals" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none"><circle cx="5" cy="6" r="2" stroke="currentColor" stroke-width="2"/><circle cx="19" cy="18" r="2" stroke="currentColor" stroke-width="2"/><path d="M7 6H16C18 6 19 8 19 10V11M17 18H8C6 18 5 16 5 14V13" stroke="currentColor" stroke-width="2"/></svg>
                <span>Approval Journey</span>
            </a>
            <a href="<%= ctx %>/entrepreneur/documents" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none"><path d="M6 2H14L19 7V22H6Z" stroke="currentColor" stroke-width="2"/><path d="M14 2V7H19" stroke="currentColor" stroke-width="2"/></svg>
                <span>Documents</span>
            </a>
            <a href="<%= ctx %>/entrepreneur/my-applications" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none"><rect x="4" y="3" width="16" height="18" rx="2" stroke="currentColor" stroke-width="2"/><path d="M8 8H16M8 12H16M8 16H13" stroke="currentColor" stroke-width="2"/></svg>
                <span>Applications</span>
            </a>
            <a href="<%= ctx %>/entrepreneur/inspections" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none"><rect x="3" y="5" width="18" height="16" rx="2" stroke="currentColor" stroke-width="2"/><path d="M8 3V7M16 3V7M3 10H21" stroke="currentColor" stroke-width="2"/></svg>
                <span>Inspections</span>
            </a>
            <a href="<%= ctx %>/entrepreneur/schemes" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none"><path d="M12 3L20 7L12 11L4 7L12 3Z" stroke="currentColor" stroke-width="2"/><path d="M5 10V16L12 20L19 16V10" stroke="currentColor" stroke-width="2"/></svg>
                <span>Schemes</span>
            </a>
            <a href="<%= ctx %>/entrepreneur/compliance" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none"><path d="M12 3L20 6V11C20 16 17 20 12 22C7 20 4 16 4 11V6L12 3Z" stroke="currentColor" stroke-width="2"/><path d="M8.5 12L11 14.5L16 9.5" stroke="currentColor" stroke-width="2"/></svg>
                <span>Compliance</span>
            </a>
            <!-- Notifications (ACTIVE) -->
            <a href="<%= ctx %>/entrepreneur/notifications" class="nav-item active">
                <svg viewBox="0 0 24 24" fill="none"><path d="M18 8A6 6 0 0 0 6 8C6 15 3 16 3 16H21C21 16 18 15 18 8Z" stroke="currentColor" stroke-width="2"/><path d="M10 20H14" stroke="currentColor" stroke-width="2"/></svg>
                <span>Notifications</span>
            </a>
        </nav>

        <div class="sidebar-spacer"></div>

        <div class="sidebar-profile">
            <div class="sidebar-user">
                <div class="sidebar-avatar"><%= avatarLetter %></div>
                <div>
                    <strong><%= esc(userName) %></strong>
                    <span>Entrepreneur</span>
                </div>
            </div>
            <div class="sidebar-bottom-links">
                <a href="<%= ctx %>/entrepreneur/profile">Profile</a>
                <a href="<%= ctx %>/logout" class="logout-link">Logout</a>
            </div>
        </div>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="main">

        <header class="topbar">
            <div class="topbar-title">
                <h1>Notification Center</h1>
                <p>Stay updated on approvals, messages from officers, and compliance alerts.</p>
            </div>
            <div class="top-actions">
                <div class="top-profile">
                    <%= avatarLetter %>&nbsp;<%= esc(userName) %>
                </div>
            </div>
        </header>

        <!-- HERO SECTION -->
        <section class="hero">
            <div class="hero-text">
                <h2>Your communication hub</h2>
                <p>Every important update regarding your business compliance, application queries, and inspection schedules is delivered here securely.</p>
            </div>

            <% if (unreadNotifications > 0) { %>
                <form method="post" action="<%= ctx %>/entrepreneur/notifications">
                    <input type="hidden" name="action" value="markAllRead">
                    <button class="mark-all-btn" type="submit">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 6L9 17l-5-5"/></svg>
                        Mark All as Read
                    </button>
                </form>
            <% } %>
        </section>

        <!-- SUMMARY METRICS -->
        <section class="summary-grid">
            <div class="summary-card">
                <div>
                    <div class="summary-label">Total Notifications</div>
                    <div class="summary-value"><%= totalNotifications %></div>
                </div>
            </div>
            <div class="summary-card">
                <div>
                    <div class="summary-label">Unread Alerts</div>
                    <div class="summary-value" style="color: var(--blue);"><%= unreadNotifications %></div>
                </div>
            </div>
            <div class="summary-card">
                <div>
                    <div class="summary-label">Application Updates</div>
                    <div class="summary-value" style="color: var(--green);"><%= applicationNotifications %></div>
                </div>
            </div>
            <div class="summary-card">
                <div>
                    <div class="summary-label">Action Required</div>
                    <div class="summary-value" style="color: var(--orange);"><%= actionNotifications %></div>
                </div>
            </div>
        </section>

        <!-- NOTIFICATIONS LIST -->
        <section class="section-card">
            
            <div class="section-header-wrap">
                <h3>Recent Notifications</h3>
                <p>Unread notifications are shown first.</p>
            </div>

            <% if (notifications == null || notifications.isEmpty()) { %>
                
                <!-- EMPTY STATE -->
                <div class="empty-state">
                    <div class="empty-icon">
                        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M18 8A6 6 0 0 0 6 8C6 15 3 16 3 16H21C21 16 18 15 18 8Z"/><path d="M10 20H14"/></svg>
                    </div>
                    <h3>No notifications yet</h3>
                    <p>Important application updates, inspection schedules, officer queries, approvals and renewal reminders will appear here securely.</p>
                    <a class="primary-btn" href="<%= ctx %>/entrepreneur/my-applications" style="margin-top:10px;">View Applications</a>
                </div>

            <% } else { %>
                
                <div class="notification-list">

                <%
                for (Map<String, Object> notificationRow : notifications) {

                    Long notificationId = notificationRow.get("notificationId") != null ? ((Number) notificationRow.get("notificationId")).longValue() : null;
                    Long applicationId = notificationRow.get("applicationId") != null ? ((Number) notificationRow.get("applicationId")).longValue() : null;
                    String type = notificationRow.get("notificationType") != null ? String.valueOf(notificationRow.get("notificationType")) : "GENERAL";
                    String title = notificationRow.get("title") != null ? String.valueOf(notificationRow.get("title")) : "Notification";
                    String message = notificationRow.get("message") != null ? String.valueOf(notificationRow.get("message")) : "";
                    String actionUrl = notificationRow.get("actionUrl") != null ? String.valueOf(notificationRow.get("actionUrl")) : null;
                    boolean read = notificationRow.get("read") != null && Boolean.TRUE.equals(notificationRow.get("read"));
                    Timestamp createdAt = (Timestamp) notificationRow.get("createdAt");
                    String applicationNumber = notificationRow.get("applicationNumber") != null ? String.valueOf(notificationRow.get("applicationNumber")) : null;
                    String applicationStatus = notificationRow.get("applicationStatus") != null ? String.valueOf(notificationRow.get("applicationStatus")) : null;
                    String approvalName = notificationRow.get("approvalName") != null ? String.valueOf(notificationRow.get("approvalName")) : null;

                    String typeUpper = type.toUpperCase();
                    String typeBadgeClass = "badge-default";

                    if (typeUpper.contains("QUERY")) typeBadgeClass = "badge-query";
                    else if (typeUpper.contains("INSPECTION")) typeBadgeClass = "badge-inspection";
                    else if (typeUpper.contains("APPROV")) typeBadgeClass = "badge-approved";
                    else if (typeUpper.contains("REJECT")) typeBadgeClass = "badge-rejected";
                    else if (typeUpper.contains("RENEW") || typeUpper.contains("COMPLIANCE")) typeBadgeClass = "badge-renewal";
                %>

                <article class="notification-card <%= !read ? "unread" : "" %>">
                    <div class="notif-content">
                        
                        <div class="notif-header">
                            <div>
                                <h4 class="notif-title"><%= esc(title) %></h4>
                                <span class="notif-time"><%= createdAt != null ? createdAt : "" %></span>
                            </div>
                            <div class="badges">
                                <span class="badge <%= typeBadgeClass %>"><%= esc(type.replace("_", " ")) %></span>
                                <span class="badge <%= read ? "badge-read" : "badge-unread" %>"><%= read ? "READ" : "NEW" %></span>
                            </div>
                        </div>

                        <div class="notif-message">
                            <%= esc(message) %>
                        </div>

                        <!-- RELATED APPLICATION BOX -->
                        <% if (applicationId != null || applicationNumber != null || approvalName != null) { %>
                            <div class="application-box">
                                <div class="application-label">Related Application</div>
                                <div class="application-value">
                                    <% if (approvalName != null) { %> <%= esc(approvalName) %> <% } %>
                                    <% if (applicationNumber != null) { %> <br><span>Application ID:</span> <%= esc(applicationNumber) %> <% } %>
                                    <% if (applicationStatus != null) { %> <br><span>Current Status:</span> <%= esc(applicationStatus.replace("_", " ")) %> <% } %>
                                </div>
                            </div>
                        <% } %>

                        <!-- ACTIONS -->
                        <div class="actions">
                            <% if (applicationId != null) { %>
                                <a class="primary-btn" href="<%= ctx %>/entrepreneur/application-details?id=<%= applicationId %>">View Application</a>
                            <% } %>

                            <%
                            /* Action URL logic ported perfectly from original code */
                            String finalActionUrl = null;
                            if (actionUrl != null && !actionUrl.isBlank()) {
                                String cleanActionUrl = actionUrl.trim();
                                if (cleanActionUrl.startsWith(ctx + "/")) {
                                    finalActionUrl = cleanActionUrl;
                                } else if (cleanActionUrl.startsWith("/")) {
                                    finalActionUrl = ctx + cleanActionUrl;
                                } else if (!cleanActionUrl.contains("://") && !cleanActionUrl.startsWith("//")) {
                                    finalActionUrl = ctx + "/" + cleanActionUrl;
                                }
                            }
                            if (finalActionUrl != null) {
                            %>
                                <a class="secondary-btn" href="<%= esc(finalActionUrl) %>">Open Action</a>
                            <% } %>

                            <% if (!read && notificationId != null) { %>
                                <form method="post" action="<%= ctx %>/entrepreneur/notifications" style="display:inline;">
                                    <input type="hidden" name="action" value="markRead">
                                    <input type="hidden" name="notificationId" value="<%= notificationId %>">
                                    <button class="read-btn" type="submit">Mark as Read</button>
                                </form>
                            <% } %>
                        </div>

                    </div>
                </article>

                <% } %>

                </div>

            <% } %>

        </section>

    </main>
</div>

</body>
</html>