<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.chaperon.dto.ApplicationView" %>
<%@ page import="com.chaperon.model.Application" %>

<%!
    private String esc(Object value) {
        if (value == null) return "";
        return String.valueOf(value).replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>

<%
    String ctx = request.getContextPath();
    String userName = (String) session.getAttribute("userName");
    if (userName == null || userName.isBlank()) {
        userName = "Entrepreneur";
    }
    String avatarLetter = userName.substring(0, 1).toUpperCase();

    @SuppressWarnings("unchecked")
    List<ApplicationView> applicationViews = (List<ApplicationView>) request.getAttribute("applicationViews");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications | CHAPERON</title>
    <link rel="stylesheet" href="<%= ctx %>/assets/css/entrepreneur-enhancements.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --blue: #0962e8; --blue-dark: #0646b5; --cyan: #27b5ed;
            --navy: #102446; --text: #263954; --muted: #7b8ca5;
            --green: #149a61; --orange: #e58b29; --red: #d94c4c; --purple: #7458d9;
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

        /* SUMMARY METRICS */
        .summary-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 16px; margin-bottom: 24px; }
        .summary-card { background: white; border: 1px solid #dfe8f4; border-radius: 16px; padding: 20px; box-shadow: var(--shadow); transition: 0.2s ease; }
        .summary-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-hover); }
        .summary-label { color: #6e819b; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.3px; margin-bottom: 8px; }
        .summary-value { font-size: 29px; font-weight: 900; color: #102446; }
        
        /* APPLICATION CARDS */
        .section-card { background: white; border: 1px solid #dfe8f4; border-radius: 18px; padding: 24px; box-shadow: var(--shadow); }
        .section-header-wrap { margin-bottom: 22px; }
        .section-header-wrap h2 { font-size: 20px; font-weight: 850; color: #152b4d; margin-bottom: 4px; }
        .section-header-wrap p { color: #728096; font-size: 13px; }

        .application-list { display: grid; gap: 18px; }
        
        .application-card { border: 1px solid #e2eaf5; border-radius: 15px; padding: 22px; background: #ffffff; box-shadow: 0 4px 14px rgba(35, 66, 111, 0.04); transition: 0.2s ease; }
        .application-card:hover { transform: translateY(-2px); border-color: #c9dcf5; box-shadow: 0 10px 24px rgba(35, 66, 111, 0.08); }
        
        .application-header { display: flex; justify-content: space-between; align-items: flex-start; gap: 15px; margin-bottom: 18px; flex-wrap: wrap; }
        .approval-name { font-size: 19px; font-weight: 900; color: #102446; margin-bottom: 4px; }
        .department-name { font-size: 13px; color: #68798e; margin-bottom: 4px; }
        .application-number { font-size: 12px; color: var(--blue); font-weight: 750; }
        
        .approval-code { display: inline-block; margin-top: 6px; background: #f0f3f7; color: #526783; border-radius: 6px; padding: 4px 8px; font-size: 10px; font-weight: 800; }
        
        .badges { display: flex; gap: 6px; flex-wrap: wrap; justify-content: flex-end; }
        .badge { display: inline-flex; align-items: center; min-height: 24px; padding: 0 10px; border-radius: 6px; font-size: 10px; font-weight: 900; text-transform: uppercase; white-space: nowrap; }
        
        /* Utility Colors for Badges */
        .badge-blue { background: #edf5ff; color: #0962e8; }
        .badge-green { background: #e9f8f1; color: #11784c; }
        .badge-orange { background: #fff3e4; color: #ba711c; }
        .badge-red { background: #fff0f0; color: #b53a3a; }
        .badge-purple { background: #f0edff; color: #7458d9; }
        .badge-gray { background: #f0f3f7; color: #526783; }

        .details-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-top: 15px; padding-top: 15px; border-top: 1px solid #edf2f9; }
        .detail-box { background: #f8fbfe; border: 1px solid #eaf0f8; padding: 14px; border-radius: 10px; }
        .detail-label { font-size: 10px; color: #8394ab; font-weight: 800; text-transform: uppercase; margin-bottom: 4px; }
        .detail-value { font-size: 13px; color: #243c5d; font-weight: 750; line-height: 1.4; word-break: break-word; }

        .actions { margin-top: 20px; display: flex; gap: 8px; flex-wrap: wrap; }
        .primary-btn, .secondary-btn { display: inline-flex; align-items: center; justify-content: center; min-height: 38px; padding: 0 16px; border-radius: 9px; font-size: 12px; font-weight: 800; transition: 0.2s ease; text-decoration: none; }
        .primary-btn { background: linear-gradient(135deg, #0962e8, #0750c5); color: white; box-shadow: 0 6px 14px rgba(9, 98, 232, 0.2); }
        .primary-btn:hover { transform: translateY(-1px); }
        .secondary-btn { background: #edf3fa; color: #435b7a; }
        .secondary-btn:hover { background: #e1ebf7; }

        /* EMPTY STATE */
        .empty-state { text-align: center; padding: 55px 20px; border: 1px dashed #dbe5f2; border-radius: 12px; background: #f9fbfe; }
        .empty-icon { font-size: 40px; margin-bottom: 12px; color: #a9b9cc; }
        .empty-state h3 { font-size: 18px; color: #1a3356; margin-bottom: 8px; }
        .empty-state p { color: #7a8ea5; max-width: 520px; margin: 0 auto 18px; font-size: 13px; line-height: 1.5; }

        /* RESPONSIVE */
        @media (max-width: 1100px) {
            .details-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 850px) {
            .app-shell { grid-template-columns: 75px minmax(0, 1fr); }
            .sidebar { padding: 20px 10px; width: 75px; }
            .sidebar-brand { padding: 0; justify-content: center; }
            .sidebar-brand > div:last-child, .nav-label, .nav-item span, .sidebar-profile { display: none; }
            .nav-item { width: 45px; margin: auto; padding: 0; justify-content: center; }
            .main { padding: 20px; }
            .summary-grid { grid-template-columns: 1fr; }
        }
        @media (max-width: 600px) {
            .app-shell { display: block; }
            .sidebar { position: static; width: 100%; height: auto; padding: 10px 12px; flex-direction: row; align-items: center; overflow-x: auto; }
            .sidebar-brand { margin: 0 15px 0 0; width: auto; }
            .nav-list { flex-direction: row; gap: 5px; }
            .sidebar-spacer { display: none; }
            .details-grid { grid-template-columns: 1fr; }
            .application-header { flex-direction: column; gap: 10px; }
            .badges { justify-content: flex-start; }
            .actions { flex-direction: column; }
            .primary-btn, .secondary-btn { width: 100%; }
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
            <!-- Applications (ACTIVE) -->
            <a href="<%= ctx %>/entrepreneur/my-applications" class="nav-item active">
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
            <a href="<%= ctx %>/entrepreneur/notifications" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none"><path d="M18 8A6 6 0 0 0 6 8C6 15 3 16 3 16H21C21 16 18 15 18 8Z" stroke="currentColor" stroke-width="2"/><path d="M10 20H14" stroke="currentColor" stroke-width="2"/></svg>
                <span>Notifications</span>
            </a>
        </nav>

        <div class="sidebar-spacer"></div>

        <div class="sidebar-profile">
            <div class="sidebar-user">
                <div class="sidebar-avatar"><%= avatarLetter %></div>
                <div>
                    <strong><%= userName %></strong>
                    <span>Entrepreneur</span>
                </div>
            </div>
            <div class="sidebar-bottom-links">
                <a href="<%= ctx %>/entrepreneur/profile">Profile</a>
                <a href="<%= ctx %>/logout" class="logout-link">Logout</a>
            </div>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="main">

        <header class="topbar">
            <div class="topbar-title">
                <h1>My Applications</h1>
                <p>Track current processing status, timelines, and action items for your approvals.</p>
            </div>
            <div class="top-actions">
                <div class="top-profile">
                    <%= avatarLetter %>&nbsp;<%= userName %>
                </div>
            </div>
        </header>

        <%
            int totalApplications = 0;
            int inProcessApplications = 0;
            int completedApplications = 0;

            if (applicationViews != null) {
                totalApplications = applicationViews.size();
                for (ApplicationView view : applicationViews) {
                    Application item = view.getApplication();
                    String status = item.getCurrentStatus();

                    if ("SUBMITTED".equalsIgnoreCase(status) ||
                        "UNDER_REVIEW".equalsIgnoreCase(status) ||
                        "QUERY_RAISED".equalsIgnoreCase(status)) {
                        inProcessApplications++;
                    }

                    if ("APPROVED".equalsIgnoreCase(status) ||
                        "REJECTED".equalsIgnoreCase(status)) {
                        completedApplications++;
                    }
                }
            }
        %>

        <!-- SUMMARY -->
        <section class="summary-grid">
            <div class="summary-card">
                <div class="summary-label">Total Applications</div>
                <div class="summary-value"><%= totalApplications %></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">In Process</div>
                <div class="summary-value" style="color: var(--blue);"><%= inProcessApplications %></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Completed</div>
                <div class="summary-value" style="color: var(--green);"><%= completedApplications %></div>
            </div>
        </section>

        <!-- APPLICATION LIST -->
        <section class="section-card">
            
            <div class="section-header-wrap">
                <h2>Application Tracker</h2>
                <p>Monitor your active and completed regulatory applications.</p>
            </div>

            <% if (applicationViews != null && !applicationViews.isEmpty()) { %>
                
                <div class="application-list">

                <%
                for (ApplicationView view : applicationViews) {
                    Application userApplication = view.getApplication();
                    String status = userApplication.getCurrentStatus();

                    String statusClass = "badge-gray";
                    if ("DRAFT".equalsIgnoreCase(status)) statusClass = "badge-orange";
                    else if ("SUBMITTED".equalsIgnoreCase(status)) statusClass = "badge-blue";
                    else if ("UNDER_REVIEW".equalsIgnoreCase(status)) statusClass = "badge-purple";
                    else if ("QUERY_RAISED".equalsIgnoreCase(status)) statusClass = "badge-orange";
                    else if ("APPROVED".equalsIgnoreCase(status)) statusClass = "badge-green";
                    else if ("REJECTED".equalsIgnoreCase(status)) statusClass = "badge-red";
                %>

                <article class="application-card">
                    <div class="application-header">
                        <div>
                            <div class="approval-name"><%= esc(view.getApprovalName()) %></div>
                            <div class="department-name"><%= esc(view.getDepartmentName()) %></div>
                            <div class="application-number">Application ID: <%= esc(userApplication.getApplicationNumber()) %></div>
                            <% if (view.getApprovalCode() != null && !view.getApprovalCode().isBlank()) { %>
                                <div class="approval-code"><%= esc(view.getApprovalCode()) %></div>
                            <% } %>
                        </div>
                        
                        <div class="badges">
                            <span class="badge <%= statusClass %>">
                                <%= status != null ? esc(status.replace("_", " ")) : "UNKNOWN" %>
                            </span>
                        </div>
                    </div>

                    <div class="details-grid">
                        <div class="detail-box">
                            <div class="detail-label">System ID</div>
                            <div class="detail-value">#<%= userApplication.getApplicationId() %></div>
                        </div>
                        <div class="detail-box">
                            <div class="detail-label">Submitted On</div>
                            <div class="detail-value"><%= userApplication.getSubmissionDate() != null ? esc(userApplication.getSubmissionDate()) : "Not Submitted" %></div>
                        </div>
                        <div class="detail-box">
                            <div class="detail-label">Expected Completion</div>
                            <div class="detail-value"><%= userApplication.getExpectedCompletionDate() != null ? esc(userApplication.getExpectedCompletionDate()) : "Not Available" %></div>
                        </div>
                        <div class="detail-box">
                            <div class="detail-label">SLA Timeline</div>
                            <div class="detail-value"><%= userApplication.getSlaDays() != null ? esc(userApplication.getSlaDays()) + " Days" : "Not Available" %></div>
                        </div>
                    </div>

                    <div class="actions">
                        <a class="primary-btn" href="<%= ctx %>/entrepreneur/application-details?id=<%= userApplication.getApplicationId() %>">View Application</a>
                        <a class="secondary-btn" href="<%= ctx %>/entrepreneur/approval-details?id=<%= userApplication.getApprovalId() %>">View Approval Info</a>
                    </div>
                </article>

                <% } %>
                </div>

            <% } else { %>
                
                <!-- EMPTY STATE -->
                <div class="empty-state">
                    <div class="empty-icon">
                        <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5">
                            <rect x="4" y="3" width="16" height="18" rx="2"/>
                            <path d="M8 8H16M8 12H16M8 16H13"/>
                        </svg>
                    </div>
                    <h3>No Applications Yet</h3>
                    <p>You have not started any approval applications yet. Generate your regulatory roadmap to discover and apply for the approvals you need.</p>
                    <a class="primary-btn" href="<%= ctx %>/entrepreneur/generate-approvals" style="margin-top: 10px;">Open Approval Roadmap</a>
                </div>

            <% } %>

        </section>

    </main>

</div>

</body>
</html>