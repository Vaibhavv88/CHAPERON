<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map, java.sql.Date" %>

<%!
    private String esc(Object v) {
        if (v == null) return "";
        return String.valueOf(v).replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>

<%
    String ctx = request.getContextPath();
    String userName = (String) session.getAttribute("userName");
    if (userName == null || userName.isBlank()) userName = "Entrepreneur";
    String avatarLetter = userName.substring(0, 1).toUpperCase();

    @SuppressWarnings("unchecked") 
    List<Map<String, Object>> schemes = (List<Map<String, Object>>) request.getAttribute("schemes");
    
    int total = schemes == null ? 0 : schemes.size();
    int open = 0, noDeadline = 0;
    java.time.LocalDate today = java.time.LocalDate.now();
    
    if (schemes != null) {
        for (Map<String, Object> r : schemes) {
            Date d = (Date) r.get("deadline");
            if (d == null) noDeadline++;
            else if (!d.toLocalDate().isBefore(today)) open++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Government Schemes | CHAPERON</title>
    <link rel="stylesheet" href="<%= ctx %>/assets/css/entrepreneur-enhancements.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --blue: #0962e8;
            --blue-dark: #0646b5;
            --cyan: #27b5ed;
            --navy: #102446;
            --text: #263954;
            --muted: #7b8ca5;
            --green: #149a61;
            --orange: #e58b29;
            --red: #d94c4c;
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

        /* SIDEBAR (Dashboard Matched) */
        .sidebar {
            position: sticky; top: 0; height: 100vh; padding: 26px 20px;
            display: flex; flex-direction: column;
            border-right: 1px solid #dce7f4;
            background: rgba(255, 255, 255, 0.96);
            backdrop-filter: blur(16px);
            box-shadow: 8px 0 32px rgba(32, 74, 123, 0.055);
            width: 238px;
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

        /* MAIN BODY */
        .main { min-width: 0; padding: 32px; background: radial-gradient(circle at 90% 0, #dcefff 0, transparent 29%), #f3f7fd; }
        .topbar { margin-bottom: 25px; display: flex; align-items: center; justify-content: space-between; gap: 20px; }
        .topbar-title h1 { color: #152b4d; font-size: 26px; font-weight: 850; }
        .topbar-title p { margin-top: 4px; color: #8796aa; font-size: 13px; }
        .top-actions { display: flex; align-items: center; gap: 10px; }
        .top-profile { min-height: 42px; padding: 0 16px; display: flex; align-items: center; gap: 8px; border: 1px solid #dce7f5; border-radius: 50px; background: white; color: #425d7e; font-size: 13px; font-weight: 800; box-shadow: 0 6px 18px rgba(26, 72, 122, 0.05); }

        /* HERO & SUMMARY GRID */
        .hero { padding: 28px; border-radius: 22px; color: #fff; background: linear-gradient(125deg, #075ecb, #1688ef 65%, #35b6ef); box-shadow: 0 18px 40px rgba(18, 111, 211, 0.16); margin-bottom: 24px; }
        .hero h2 { margin: 0 0 6px; font-size: 26px; font-weight: 900; }
        .hero p { max-width: 720px; margin: 0; line-height: 1.5; color: #eaf5ff; font-size: 14px; }
        
        .summary-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 16px; margin-bottom: 24px; }
        .summary-card { background: white; border: 1px solid #dfe8f4; border-radius: 16px; padding: 20px; box-shadow: var(--shadow); transition: 0.2s ease; }
        .summary-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-hover); }
        .summary-label { color: #6e819b; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.3px; margin-bottom: 8px; }
        .summary-value { font-size: 29px; font-weight: 900; color: #102446; }
        
        .info-strip { margin-bottom: 24px; padding: 14px 18px; border-radius: 12px; background: #edf5ff; border: 1px solid #cfe3fb; color: #2b5585; font-size: 13px; line-height: 1.5; }
        .info-strip strong { color: #095fbf; }

        /* SECTION & CARDS */
        .section-card { background: white; border: 1px solid #dfe8f4; border-radius: 18px; padding: 24px; box-shadow: var(--shadow); }
        .section-header-wrap { margin-bottom: 20px; }
        .section-header-wrap h2 { font-size: 20px; font-weight: 850; color: #152b4d; margin-bottom: 4px; }
        .section-header-wrap p { color: #728096; font-size: 13px; }

        .schemes-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 18px; }
        .scheme-card { display: flex; flex-direction: column; border: 1px solid #e2eaf5; border-radius: 15px; background: #ffffff; box-shadow: 0 4px 14px rgba(35, 66, 111, 0.04); transition: 0.2s ease; overflow: hidden; }
        .scheme-card:hover { transform: translateY(-3px); border-color: #c9dcf5; box-shadow: 0 10px 24px rgba(35, 66, 111, 0.08); }
        
        .card-top { padding: 20px; border-bottom: 1px solid #edf2f9; background: linear-gradient(135deg, #ffffff, #f8fbff); }
        .title-row { display: flex; justify-content: space-between; align-items: flex-start; gap: 14px; }
        .scheme-name { font-size: 17px; font-weight: 900; color: #102446; line-height: 1.35; }
        .dept-badge { flex: none; padding: 5px 9px; border-radius: 6px; background: #eef4fc; color: #0764ce; font-size: 9px; font-weight: 900; letter-spacing: 0.5px; }
        .desc { margin-top: 10px; color: #68798e; font-size: 13px; line-height: 1.6; }
        
        .card-body { padding: 20px; display: flex; flex-direction: column; gap: 15px; flex: 1; }
        .info-group .label { margin-bottom: 4px; color: #8394ab; font-size: 10px; font-weight: 800; letter-spacing: 0.5px; text-transform: uppercase; }
        .info-group .value { color: #243c5d; font-size: 13px; line-height: 1.5; }
        .benefit-box { padding: 12px; border: 1px solid #cdebdc; border-radius: 9px; background: #eefaf4; color: #11784c; font-weight: 750; }
        
        .badge { display: inline-flex; align-items: center; min-height: 24px; padding: 0 10px; border-radius: 6px; font-size: 10px; font-weight: 900; text-transform: uppercase; }
        .active-badge { background: #e9f8f1; color: #11784c; }
        .expired-badge { background: #fff0f0; color: #b53a3a; }
        .none-badge { background: #f0f3f7; color: #526783; }

        .card-footer { display: flex; justify-content: space-between; align-items: center; padding: 16px 20px; border-top: 1px solid #edf2f9; background: #fbfdff; gap: 10px; }
        .note-text { color: #7a8ba1; font-size: 11px; }
        .primary-btn { display: inline-flex; align-items: center; justify-content: center; min-height: 38px; padding: 0 16px; border-radius: 9px; font-size: 12px; font-weight: 800; color: white; background: linear-gradient(135deg, #0962e8, #0750c5); box-shadow: 0 6px 14px rgba(9, 98, 232, 0.2); transition: 0.2s ease; }
        .primary-btn:hover { transform: translateY(-1px); }
        .no-link { color: #8a98aa; font-size: 12px; font-weight: 700; background: #f0f3f7; padding: 8px 12px; border-radius: 8px; }

        .empty-state { padding: 45px 20px; text-align: center; border: 1px dashed #dbe5f2; border-radius: 12px; background: #f9fbfe; }
        .empty-state h3 { font-size: 18px; color: #1a3356; margin-bottom: 6px; }
        .empty-state p { color: #7a8ea5; margin: 0 auto; font-size: 13px; line-height: 1.5; }

        @media (max-width: 1050px) {
            .schemes-grid { grid-template-columns: 1fr; }
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
            .card-footer { flex-direction: column; align-items: flex-start; }
            .primary-btn { width: 100%; }
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
            <!-- Schemes (ACTIVE) -->
            <a href="<%= ctx %>/entrepreneur/schemes" class="nav-item active">
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

    <!-- MAIN CONTENT -->
    <main class="main">
        <header class="topbar">
            <div class="topbar-title">
                <h1>Government Schemes</h1>
                <p>Discover verified support, subsidies, and incentives for your business.</p>
            </div>
            <div class="top-actions">
                <a href="<%= ctx %>/entrepreneur/profile" class="top-profile">
                    <%= avatarLetter %>&nbsp;<%= userName %>
                </a>
            </div>
        </header>

        <!-- HERO SECTION -->
        <section class="hero">
            <h2>Government support, clearly organised</h2>
            <p>Explore active schemes, understand eligibility and benefits, and access official department information from one consolidated workspace.</p>
        </section>

        <!-- SUMMARY GRID -->
        <section class="summary-grid">
            <div class="summary-card">
                <div class="summary-label">Available Schemes</div>
                <div class="summary-value"><%= total %></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">Open / Upcoming</div>
                <div class="summary-value" style="color: var(--green);"><%= open %></div>
            </div>
            <div class="summary-card">
                <div class="summary-label">No Fixed Deadline</div>
                <div class="summary-value" style="color: var(--blue);"><%= noDeadline %></div>
            </div>
        </section>

        <!-- INFO -->
        <div class="info-strip">
            <strong>Important:</strong> CHAPERON provides scheme information as guidance. Always verify current eligibility criteria, financial benefits, and final deadlines using the official links provided before applying.
        </div>

        <!-- SCHEMES CONTAINER -->
        <section class="section-card">
            <div class="section-header-wrap">
                <h2>Available Government Schemes</h2>
                <p>Review requirements, timelines, and corresponding departments for applicable incentives.</p>
            </div>

            <% if (schemes == null || schemes.isEmpty()) { %>
                <div class="empty-state">
                    <h3>No active schemes currently available</h3>
                    <p>New government schemes and subsidies added by the administrator will automatically appear here based on your business profile.</p>
                </div>
            <% } else { %>
                <div class="schemes-grid">
                    <%
                    for (Map<String, Object> r : schemes) {
                        String name = r.get("schemeName") == null ? "Government Scheme" : String.valueOf(r.get("schemeName"));
                        String description = r.get("description") == null ? "" : String.valueOf(r.get("description"));
                        String eligibility = r.get("eligibility") == null ? "" : String.valueOf(r.get("eligibility"));
                        String benefit = r.get("benefit") == null ? "" : String.valueOf(r.get("benefit"));
                        Date deadline = (Date) r.get("deadline");
                        String url = r.get("officialInformationUrl") == null ? "" : String.valueOf(r.get("officialInformationUrl"));
                        String dept = r.get("departmentName") == null ? "" : String.valueOf(r.get("departmentName"));
                        String code = r.get("departmentCode") == null ? "" : String.valueOf(r.get("departmentCode"));
                        boolean expired = deadline != null && deadline.toLocalDate().isBefore(today);
                    %>
                    <article class="scheme-card">
                        <div class="card-top">
                            <div class="title-row">
                                <div class="scheme-name"><%= esc(name) %></div>
                                <span class="dept-badge"><%= esc(code.isBlank() ? (dept.isBlank() ? "GENERAL" : dept) : code) %></span>
                            </div>
                            <% if (!description.isBlank()) { %>
                                <div class="desc"><%= esc(description) %></div>
                            <% } %>
                        </div>
                        
                        <div class="card-body">
                            <div class="info-group">
                                <div class="label">Eligibility</div>
                                <div class="value"><%= eligibility.isBlank() ? "Eligibility details are not currently specified." : esc(eligibility) %></div>
                            </div>
                            
                            <div class="info-group">
                                <div class="label">Benefits</div>
                                <div class="value benefit-box"><%= benefit.isBlank() ? "Benefit details are not currently specified." : esc(benefit) %></div>
                            </div>
                            
                            <div class="info-group">
                                <div class="label">Application Deadline</div>
                                <% if (deadline == null) { %>
                                    <span class="badge none-badge">No Fixed Deadline</span>
                                <% } else if (expired) { %>
                                    <span class="badge expired-badge"><%= deadline %> &nbsp;—&nbsp; Passed</span>
                                <% } else { %>
                                    <span class="badge active-badge"><%= deadline %> &nbsp;—&nbsp; Open</span>
                                <% } %>
                            </div>
                            
                            <% if (!dept.isBlank()) { %>
                                <div class="info-group">
                                    <div class="label">Responsible Department</div>
                                    <div class="value"><%= esc(dept) %><%= code.isBlank() ? "" : " (" + esc(code) + ")" %></div>
                                </div>
                            <% } %>
                        </div>
                        
                        <footer class="card-footer">
                            <span class="note-text"><%= expired ? "This deadline has passed." : "Verify details before applying." %></span>
                            <% if (!url.isBlank()) { %>
                                <a class="primary-btn" href="<%= esc(url) %>" target="_blank" rel="noopener noreferrer">Official Information ↗</a>
                            <% } else { %>
                                <span class="no-link">Link not available</span>
                            <% } %>
                        </footer>
                    </article>
                    <% } %>
                </div>
            <% } %>
        </section>
    </main>
</div>

</body>
</html>