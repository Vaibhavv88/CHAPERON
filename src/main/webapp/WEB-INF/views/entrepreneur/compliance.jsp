<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.Date" %>

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
    List<Map<String, Object>> complianceItems =
            (List<Map<String, Object>>) request.getAttribute("complianceItems");

    Integer totalApprovals = (Integer) request.getAttribute("totalApprovals");
    Integer activeApprovals = (Integer) request.getAttribute("activeApprovals");
    Integer expiringSoon = (Integer) request.getAttribute("expiringSoon");
    Integer expiredApprovals = (Integer) request.getAttribute("expiredApprovals");
    Integer renewalRequired = (Integer) request.getAttribute("renewalRequired");
    Integer pendingCompliance = (Integer) request.getAttribute("pendingCompliance");

    if (totalApprovals == null) totalApprovals = 0;
    if (activeApprovals == null) activeApprovals = 0;
    if (expiringSoon == null) expiringSoon = 0;
    if (expiredApprovals == null) expiredApprovals = 0;
    if (renewalRequired == null) renewalRequired = 0;
    if (pendingCompliance == null) pendingCompliance = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Compliance & Renewals | CHAPERON</title>
    <link rel="stylesheet" href="<%= ctx %>/assets/css/entrepreneur-enhancements.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --blue: #0962e8;
            --blue-dark: #0646b5;
            --blue-soft: #edf5ff;
            --cyan: #27b5ed;
            --navy: #102446;
            --text: #263954;
            --muted: #7b8ca5;
            --green: #149a61;
            --green-soft: #e9f8f1;
            --orange: #e58b29;
            --orange-soft: #fff3e5;
            --purple: #7458d9;
            --purple-soft: #f0edff;
            --red: #d94c4c;
            --red-soft: #fff0f0;
            --border: #e4ebf5;
            --bg: #f2f6fc;
            --white: #ffffff;
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

        a {
            color: inherit;
            text-decoration: none;
        }

        .app-shell {
            min-height: 100vh;
            display: grid;
            grid-template-columns: 238px minmax(0, 1fr);
        }

        /* SIDEBAR (Dashboard Matched) */
        .sidebar {
            position: sticky;
            top: 0;
            height: 100vh;
            padding: 26px 20px;
            display: flex;
            flex-direction: column;
            border-right: 1px solid #dce7f4;
            background: rgba(255, 255, 255, 0.96);
            backdrop-filter: blur(16px);
            box-shadow: 8px 0 32px rgba(32, 74, 123, 0.055);
            width: 238px;
        }

        .sidebar-brand {
            width: 100%;
            min-width: 0;
            margin-bottom: 34px;
            padding: 0 4px;
            display: flex;
            align-items: center;
            gap: 11px;
        }

        .logo-wrap {
            position: relative;
            width: 47px;
            height: 47px;
            min-width: 47px;
            overflow: hidden;
            border-radius: 10px;
            background: white;
            box-shadow: 0 4px 12px rgba(16, 36, 70, 0.08);
        }

        .logo-wrap img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .brand-title {
            color: #1053c4;
            font-size: 21px;
            font-weight: 900;
            line-height: 1;
            white-space: nowrap;
        }

        .brand-subtitle {
            margin-top: 4px;
            color: #667c9c;
            font-size: 7px;
            font-weight: 800;
            line-height: 1.25;
            letter-spacing: 0.1px;
        }

        .nav-label {
            margin: 0 10px 10px;
            color: #9aa8ba;
            font-size: 10px;
            font-weight: 900;
            letter-spacing: 1.2px;
        }

        .nav-list {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        .nav-item {
            min-height: 45px;
            padding: 0 14px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-radius: 11px;
            color: #526783;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.2s ease;
        }

        .nav-item svg {
            width: 19px;
            height: 19px;
            min-width: 19px;
        }

        .nav-item:hover {
            color: var(--blue);
            background: #edf5ff;
            transform: translateX(3px);
        }

        .nav-item.active {
            color: white;
            background: linear-gradient(135deg, #0962e8, #268de9);
            box-shadow: 0 9px 20px rgba(9, 98, 232, 0.25);
        }

        .sidebar-spacer {
            flex: 1;
        }

        .sidebar-profile {
            margin-top: 19px;
            padding: 14px;
            border: 1px solid #dce7f4;
            border-radius: 14px;
            background: linear-gradient(145deg, #ffffff, #f6f9fd);
        }

        .sidebar-user {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sidebar-avatar {
            width: 40px;
            height: 40px;
            min-width: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            color: white;
            background: linear-gradient(135deg, #0962e9, #68a2ff);
            font-size: 14px;
            font-weight: 900;
        }

        .sidebar-user strong {
            display: block;
            max-width: 120px;
            overflow: hidden;
            color: #1e3558;
            font-size: 14px;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .sidebar-user span {
            display: block;
            margin-top: 2px;
            color: #8998ac;
            font-size: 11px;
        }

        .sidebar-bottom-links {
            margin-top: 11px;
            padding-top: 10px;
            display: flex;
            justify-content: space-between;
            border-top: 1px solid #e8eef6;
        }

        .sidebar-bottom-links a {
            color: #6b7e98;
            font-size: 11px;
            font-weight: 800;
        }

        .sidebar-bottom-links a:hover {
            color: var(--blue);
        }

        .sidebar-bottom-links .logout-link {
            color: #c24949;
        }

        /* MAIN BODY */
        .main {
            min-width: 0;
            padding: 32px;
            background: radial-gradient(circle at 90% 0, #dcefff 0, transparent 29%), #f3f7fd;
        }

        .topbar {
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }

        .topbar-title h1 {
            color: #152b4d;
            font-size: 26px;
            font-weight: 850;
        }

        .topbar-title p {
            margin-top: 4px;
            color: #8796aa;
            font-size: 13px;
        }

        .top-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .top-profile {
            min-height: 42px;
            padding: 0 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            border: 1px solid #dce7f5;
            border-radius: 50px;
            background: white;
            color: #425d7e;
            font-size: 13px;
            font-weight: 800;
            box-shadow: 0 6px 18px rgba(26, 72, 122, 0.05);
        }

        /* SUMMARY METRICS */
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(6, minmax(0, 1fr));
            gap: 14px;
            margin-bottom: 22px;
        }

        .summary-card {
            background: white;
            border: 1px solid #dfe8f4;
            border-radius: 16px;
            padding: 16px;
            box-shadow: var(--shadow);
            transition: 0.2s ease;
        }

        .summary-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-hover);
        }

        .summary-label {
            color: #6e819b;
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            margin-bottom: 8px;
        }

        .summary-value {
            font-size: 26px;
            font-weight: 900;
            color: #102446;
        }

        .info-strip {
            margin-bottom: 24px;
            padding: 14px 18px;
            border-radius: 12px;
            background: #edf5ff;
            border: 1px solid #cfe3fb;
            color: #2b5585;
            font-size: 13px;
            line-height: 1.5;
        }

        /* PANEL & COMPLIANCE CARDS */
        .section-card {
            background: white;
            border: 1px solid #dfe8f4;
            border-radius: 18px;
            padding: 24px;
            box-shadow: var(--shadow);
        }

        .section-header-wrap {
            margin-bottom: 20px;
        }

        .section-header-wrap h2 {
            font-size: 20px;
            font-weight: 850;
            color: #152b4d;
            margin-bottom: 4px;
        }

        .section-header-wrap p {
            color: #728096;
            font-size: 13px;
        }

        .compliance-list {
            display: grid;
            gap: 18px;
        }

        .compliance-card {
            border: 1px solid #e2eaf5;
            border-radius: 15px;
            padding: 20px;
            background: #ffffff;
            box-shadow: 0 4px 14px rgba(35, 66, 111, 0.04);
            transition: 0.2s ease;
        }

        .compliance-card:hover {
            transform: translateY(-2px);
            border-color: #c9dcf5;
            box-shadow: 0 10px 24px rgba(35, 66, 111, 0.08);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 15px;
            margin-bottom: 16px;
        }

        .approval-title {
            font-size: 17px;
            font-weight: 900;
            color: #102446;
            margin-bottom: 4px;
        }

        .approval-number {
            font-size: 12px;
            color: var(--blue);
            font-weight: 750;
        }

        .badges {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            min-height: 24px;
            padding: 0 10px;
            border-radius: 6px;
            font-size: 10px;
            font-weight: 900;
            text-transform: uppercase;
        }

        .active-badge {
            background: #e9f8f1;
            color: #11784c;
        }

        .expiring-badge {
            background: #fff3e4;
            color: #ba711c;
        }

        .expired-badge {
            background: #fff0f0;
            color: #b53a3a;
        }

        .renewal-badge {
            background: #edf5ff;
            color: #0962e8;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
        }

        .detail-box {
            background: #f8fbfe;
            border: 1px solid #eaf0f8;
            padding: 12px;
            border-radius: 10px;
        }

        .detail-label {
            font-size: 10px;
            color: #8394ab;
            font-weight: 800;
            text-transform: uppercase;
            margin-bottom: 4px;
        }

        .detail-value {
            font-size: 12px;
            color: #243c5d;
            font-weight: 750;
            line-height: 1.4;
            word-break: break-word;
        }

        .subsection {
            margin-top: 16px;
            border-top: 1px solid #edf2f9;
            padding-top: 14px;
        }

        .subsection-title {
            font-size: 13px;
            font-weight: 850;
            color: #182e4e;
            margin-bottom: 10px;
        }

        .compliance-record {
            background: #f8fbfe;
            border: 1px solid #eaf0f8;
            border-radius: 10px;
            padding: 12px;
            margin-bottom: 8px;
        }

        .record-top {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 4px;
        }

        .record-name {
            font-size: 13px;
            font-weight: 800;
            color: #1b3558;
        }

        .record-meta {
            font-size: 12px;
            color: #68798e;
            line-height: 1.5;
        }

        .reminder-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .reminder-item {
            background: #eef5ff;
            border: 1px solid #d5e5fa;
            color: #1059b8;
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 750;
        }

        .no-records {
            color: #7b8c9f;
            font-size: 12px;
            background: #f9fbfe;
            padding: 12px;
            border-radius: 8px;
            border: 1px dashed #dbe5f2;
        }

        .actions {
            margin-top: 16px;
            display: flex;
            gap: 8px;
        }

        .primary-btn, .secondary-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 38px;
            padding: 0 16px;
            border-radius: 9px;
            font-size: 12px;
            font-weight: 800;
            transition: 0.2s ease;
        }

        .primary-btn {
            background: linear-gradient(135deg, #0962e8, #0750c5);
            color: white;
            box-shadow: 0 6px 14px rgba(9, 98, 232, 0.2);
        }

        .primary-btn:hover {
            transform: translateY(-1px);
        }

        .secondary-btn {
            background: #edf3fa;
            color: #435b7a;
        }

        .secondary-btn:hover {
            background: #e1ebf7;
        }

        .empty-state {
            padding: 45px 20px;
            text-align: center;
        }

        .empty-state h3 {
            font-size: 18px;
            color: #1a3356;
            margin-bottom: 6px;
        }

        .empty-state p {
            color: #7a8ea5;
            max-width: 520px;
            margin: 0 auto 18px;
            font-size: 13px;
            line-height: 1.5;
        }

        @media (max-width: 1200px) {
            .summary-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }
            .details-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 850px) {
            .app-shell {
                grid-template-columns: 75px minmax(0, 1fr);
            }
            .sidebar {
                padding: 20px 10px;
                width: 75px;
            }
            .sidebar-brand {
                padding: 0;
                justify-content: center;
            }
            .sidebar-brand > div:last-child,
            .nav-label,
            .nav-item span,
            .sidebar-profile {
                display: none;
            }
            .nav-item {
                width: 45px;
                margin: auto;
                padding: 0;
                justify-content: center;
            }
            .main {
                padding: 20px;
            }
        }

        @media (max-width: 600px) {
            .app-shell {
                display: block;
            }
            .sidebar {
                position: static;
                width: 100%;
                height: auto;
                padding: 10px 12px;
                flex-direction: row;
                align-items: center;
                overflow-x: auto;
            }
            .sidebar-brand {
                margin: 0 15px 0 0;
                width: auto;
            }
            .nav-list {
                flex-direction: row;
                gap: 5px;
            }
            .sidebar-spacer {
                display: none;
            }
            .summary-grid, .details-grid {
                grid-template-columns: 1fr;
            }
            .card-header {
                flex-direction: column;
            }
            .badges {
                justify-content: flex-start;
            }
        }
    </style>
</head>
<body>

<div class="app-shell">

    <!-- SIDEBAR (DASHBOARD IDENTICAL) -->
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
            <!-- Dashboard -->
            <a href="<%= ctx %>/entrepreneur/dashboard" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none">
                    <path d="M3 11L12 4L21 11V21H15V15H9V21H3V11Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
                </svg>
                <span>Dashboard</span>
            </a>

            <!-- My Business -->
            <a href="<%= ctx %>/entrepreneur/business-onboarding" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none">
                    <path d="M4 21V8L12 3L20 8V21" stroke="currentColor" stroke-width="2"/>
                    <path d="M9 21V14H15V21" stroke="currentColor" stroke-width="2"/>
                </svg>
                <span>My Business</span>
            </a>

            <!-- Approval Journey -->
            <a href="<%= ctx %>/entrepreneur/generate-approvals" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none">
                    <circle cx="5" cy="6" r="2" stroke="currentColor" stroke-width="2"/>
                    <circle cx="19" cy="18" r="2" stroke="currentColor" stroke-width="2"/>
                    <path d="M7 6H16C18 6 19 8 19 10V11M17 18H8C6 18 5 16 5 14V13" stroke="currentColor" stroke-width="2"/>
                </svg>
                <span>Approval Journey</span>
            </a>

            <!-- Documents -->
            <a href="<%= ctx %>/entrepreneur/documents" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none">
                    <path d="M6 2H14L19 7V22H6Z" stroke="currentColor" stroke-width="2"/>
                    <path d="M14 2V7H19" stroke="currentColor" stroke-width="2"/>
                </svg>
                <span>Documents</span>
            </a>

            <!-- Applications -->
            <a href="<%= ctx %>/entrepreneur/my-applications" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none">
                    <rect x="4" y="3" width="16" height="18" rx="2" stroke="currentColor" stroke-width="2"/>
                    <path d="M8 8H16M8 12H16M8 16H13" stroke="currentColor" stroke-width="2"/>
                </svg>
                <span>Applications</span>
            </a>

            <!-- Inspections -->
            <a href="<%= ctx %>/entrepreneur/inspections" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none">
                    <rect x="3" y="5" width="18" height="16" rx="2" stroke="currentColor" stroke-width="2"/>
                    <path d="M8 3V7M16 3V7M3 10H21" stroke="currentColor" stroke-width="2"/>
                </svg>
                <span>Inspections</span>
            </a>

            <!-- Schemes -->
            <a href="<%= ctx %>/entrepreneur/schemes" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none">
                    <path d="M12 3L20 7L12 11L4 7L12 3Z" stroke="currentColor" stroke-width="2"/>
                    <path d="M5 10V16L12 20L19 16V10" stroke="currentColor" stroke-width="2"/>
                </svg>
                <span>Schemes</span>
            </a>

            <!-- Compliance (ACTIVE) -->
            <a href="<%= ctx %>/entrepreneur/compliance" class="nav-item active">
                <svg viewBox="0 0 24 24" fill="none">
                    <path d="M12 3L20 6V11C20 16 17 20 12 22C7 20 4 16 4 11V6L12 3Z" stroke="currentColor" stroke-width="2"/>
                    <path d="M8.5 12L11 14.5L16 9.5" stroke="currentColor" stroke-width="2"/>
                </svg>
                <span>Compliance</span>
            </a>

            <!-- Notifications -->
            <a href="<%= ctx %>/entrepreneur/notifications" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none">
                    <path d="M18 8A6 6 0 0 0 6 8C6 15 3 16 3 16H21C21 16 18 15 18 8Z" stroke="currentColor" stroke-width="2"/>
                    <path d="M10 20H14" stroke="currentColor" stroke-width="2"/>
                </svg>
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

    <!-- MAIN CONTENT -->
    <main class="main">
        <header class="topbar">
            <div class="topbar-title">
                <h1>Compliance &amp; Renewals</h1>
                <p>Track certificate validity, mandatory obligations, and renewal deadlines</p>
            </div>
            <div class="top-actions">
                <a href="<%= ctx %>/entrepreneur/profile" class="top-profile">
                    <%= avatarLetter %>&nbsp;<%= userName %>
                </a>
            </div>
        </header>

        <!-- SUMMARY GRID -->
        <section class="summary-grid">
            <div class="summary-card">
                <div class="summary-label">Total Certificates</div>
                <div class="summary-value"><%= totalApprovals %></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Active</div>
                <div class="summary-value" style="color: var(--green);"><%= activeApprovals %></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Expiring Soon</div>
                <div class="summary-value" style="color: var(--orange);"><%= expiringSoon %></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Expired</div>
                <div class="summary-value" style="color: var(--red);"><%= expiredApprovals %></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Renewal Required</div>
                <div class="summary-value" style="color: var(--blue);"><%= renewalRequired %></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Pending Checks</div>
                <div class="summary-value" style="color: var(--purple);"><%= pendingCompliance %></div>
            </div>
        </section>

        <!-- INFO -->
        <div class="info-strip">
            <strong>SLA &amp; Expiry Policy:</strong> CHAPERON flags a fixed-validity certificate as <strong>Expiring Soon</strong> when 90 days or less remain before expiration. Ensure timely filing of renewal requests to avoid disruptions.
        </div>

        <!-- COMPLIANCE CARDS CONTAINER -->
        <section class="section-card">
            <div class="section-header-wrap">
                <h2>Approved Licences &amp; Regulatory Tracking</h2>
                <p>Review validity terms, renewal requirements, and condition compliance for each issued clearance.</p>
            </div>

            <% if (complianceItems == null || complianceItems.isEmpty()) { %>
                <div class="empty-state">
                    <h3>No approved certificates available</h3>
                    <p>Once your submitted applications receive department approval and certificates are issued, they will populate here for renewal and lifecycle tracking.</p>
                    <a class="primary-btn" href="<%= ctx %>/entrepreneur/my-applications">View Applications</a>
                </div>
            <% } else { %>
                <div class="compliance-list">
                    <%
                    for (Map<String, Object> complianceRow : complianceItems) {
                        Long applicationId = complianceRow.get("applicationId") != null
                                ? ((Number) complianceRow.get("applicationId")).longValue()
                                : null;

                        String approvalName = complianceRow.get("approvalName") != null
                                ? String.valueOf(complianceRow.get("approvalName")) : "Approval";

                        String approvalCode = complianceRow.get("approvalCode") != null
                                ? String.valueOf(complianceRow.get("approvalCode")) : "—";

                        String applicationNumber = complianceRow.get("applicationNumber") != null
                                ? String.valueOf(complianceRow.get("applicationNumber")) : "—";

                        String approvalNumber = complianceRow.get("approvalNumber") != null
                                ? String.valueOf(complianceRow.get("approvalNumber")) : "—";

                        String departmentName = complianceRow.get("departmentName") != null
                                ? String.valueOf(complianceRow.get("departmentName")) : "—";

                        String businessName = complianceRow.get("businessName") != null
                                ? String.valueOf(complianceRow.get("businessName")) : "—";

                        Date approvalDate = (Date) complianceRow.get("approvalDate");
                        Date validFrom = (Date) complianceRow.get("validFrom");
                        Date validUntil = (Date) complianceRow.get("validUntil");

                        String validityStatus = complianceRow.get("validityStatus") != null
                                ? String.valueOf(complianceRow.get("validityStatus")) : "ACTIVE";

                        Long daysRemaining = complianceRow.get("daysRemaining") != null
                                ? ((Number) complianceRow.get("daysRemaining")).longValue() : null;

                        boolean renewalNeeded = Boolean.TRUE.equals(complianceRow.get("renewalRequired"));
                        Object renewalBeforeObject = complianceRow.get("renewalBeforeDays");
                        String certificateRemarks = complianceRow.get("certificateRemarks") != null
                                ? String.valueOf(complianceRow.get("certificateRemarks")) : null;

                        String badgeClass = "active-badge";
                        if ("EXPIRING_SOON".equalsIgnoreCase(validityStatus)) {
                            badgeClass = "expiring-badge";
                        } else if ("EXPIRED".equalsIgnoreCase(validityStatus)) {
                            badgeClass = "expired-badge";
                        }

                        @SuppressWarnings("unchecked")
                        List<Map<String, Object>> complianceRecords =
                                (List<Map<String, Object>>) complianceRow.get("complianceRecords");

                        @SuppressWarnings("unchecked")
                        List<Map<String, Object>> renewalReminders =
                                (List<Map<String, Object>>) complianceRow.get("renewalReminders");
                    %>

                    <div class="compliance-card">
                        <div class="card-header">
                            <div>
                                <div class="approval-title"><%= esc(approvalName) %></div>
                                <div class="approval-number"><%= esc(approvalCode) %> &bull; Certificate No: <%= esc(approvalNumber) %></div>
                            </div>
                            <div class="badges">
                                <span class="badge <%= badgeClass %>"><%= esc(validityStatus.replace("_", " ")) %></span>
                                <% if (renewalNeeded) { %>
                                    <span class="badge renewal-badge">Renewal Required</span>
                                <% } %>
                            </div>
                        </div>

                        <div class="details-grid">
                            <div class="detail-box">
                                <div class="detail-label">Business</div>
                                <div class="detail-value"><%= esc(businessName) %></div>
                            </div>
                            <div class="detail-box">
                                <div class="detail-label">Department</div>
                                <div class="detail-value"><%= esc(departmentName) %></div>
                            </div>
                            <div class="detail-box">
                                <div class="detail-label">Application Number</div>
                                <div class="detail-value"><%= esc(applicationNumber) %></div>
                            </div>
                            <div class="detail-box">
                                <div class="detail-label">Approval Date</div>
                                <div class="detail-value"><%= approvalDate != null ? approvalDate : "—" %></div>
                            </div>
                            <div class="detail-box">
                                <div class="detail-label">Valid From</div>
                                <div class="detail-value"><%= validFrom != null ? validFrom : "—" %></div>
                            </div>
                            <div class="detail-box">
                                <div class="detail-label">Valid Until</div>
                                <div class="detail-value"><%= validUntil != null ? validUntil : "No Fixed Expiry" %></div>
                            </div>
                            <div class="detail-box">
                                <div class="detail-label">Days Remaining</div>
                                <div class="detail-value">
                                    <% if (daysRemaining == null) { %>
                                        No fixed expiry
                                    <% } else if (daysRemaining < 0) { %>
                                        Expired <%= Math.abs(daysRemaining) %> day(s) ago
                                    <% } else { %>
                                        <%= daysRemaining %> day(s)
                                    <% } %>
                                </div>
                            </div>
                            <div class="detail-box">
                                <div class="detail-label">Renewal Window</div>
                                <div class="detail-value">
                                    <% if (renewalNeeded) { %>
                                        Required
                                        <% if (renewalBeforeObject != null) { %>
                                            <br><small style="color: #6a7c93;">(~<%= renewalBeforeObject %> days prior)</small>
                                        <% } %>
                                    <% } else { %>
                                        Not Required
                                    <% } %>
                                </div>
                            </div>
                        </div>

                        <% if (certificateRemarks != null && !certificateRemarks.isBlank()) { %>
                            <div class="subsection">
                                <div class="subsection-title">Certificate Remarks</div>
                                <div class="no-records"><%= esc(certificateRemarks) %></div>
                            </div>
                        <% } %>

                        <div class="subsection">
                            <div class="subsection-title">Compliance Requirements</div>
                            <% if (complianceRecords == null || complianceRecords.isEmpty()) { %>
                                <div class="no-records">No additional compliance conditions recorded for this clearance.</div>
                            <% } else {
                                for (Map<String, Object> record : complianceRecords) {
                                    String complianceName = record.get("complianceName") != null
                                            ? String.valueOf(record.get("complianceName")) : "Condition";
                                    Object dueDate = record.get("dueDate");
                                    String complianceStatus = record.get("status") != null
                                            ? String.valueOf(record.get("status")) : "UPCOMING";
                                    String remarks = record.get("remarks") != null
                                            ? String.valueOf(record.get("remarks")) : null;

                                    String recordBadge = "COMPLETED".equalsIgnoreCase(complianceStatus)
                                            ? "active-badge" : "expiring-badge";
                            %>
                                <div class="compliance-record">
                                    <div class="record-top">
                                        <div class="record-name"><%= esc(complianceName) %></div>
                                        <span class="badge <%= recordBadge %>"><%= esc(complianceStatus.replace("_", " ")) %></span>
                                    </div>
                                    <div class="record-meta">
                                        Due Date: <strong><%= dueDate != null ? esc(dueDate) : "Not Specified" %></strong>
                                        <% if (remarks != null && !remarks.isBlank()) { %>
                                            <br>Remarks: <%= esc(remarks) %>
                                        <% } %>
                                    </div>
                                </div>
                            <% } } %>
                        </div>

                        <div class="subsection">
                            <div class="subsection-title">Renewal Reminders</div>
                            <% if (renewalReminders == null || renewalReminders.isEmpty()) { %>
                                <div class="no-records">
                                    <%= renewalNeeded ? "No scheduled renewal reminders generated yet." : "Renewal schedule not required." %>
                                </div>
                            <% } else { %>
                                <div class="reminder-list">
                                    <% for (Map<String, Object> reminder : renewalReminders) {
                                        Object reminderDays = reminder.get("reminderDaysBefore");
                                        Object reminderDate = reminder.get("reminderDate");
                                        String reminderStatus = reminder.get("status") != null
                                                ? String.valueOf(reminder.get("status")) : "PENDING";
                                    %>
                                        <div class="reminder-item">
                                            <%= reminderDays != null ? esc(reminderDays) : "—" %> days before
                                            <br><small style="font-weight: normal; color: #506f97;"><%= reminderDate != null ? esc(reminderDate) : "Date pending" %></small>
                                            <br><span style="font-size: 10px; text-transform: uppercase;"><%= esc(reminderStatus) %></span>
                                        </div>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>

                        <div class="actions">
                            <% if (applicationId != null) { %>
                                <a class="primary-btn" href="<%= ctx %>/entrepreneur/application-details?id=<%= applicationId %>">View Application</a>
                            <% } %>
                            <a class="secondary-btn" href="<%= ctx %>/entrepreneur/my-applications">My Applications</a>
                        </div>
                    </div>
                    <% } %>
                </div>
            <% } %>
        </section>
    </main>
</div>

</body>
</html>