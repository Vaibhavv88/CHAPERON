<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

    String profileFullName = (String) request.getAttribute("profileFullName");
    String profileEmail = (String) request.getAttribute("profileEmail");
    String profileMobile = (String) request.getAttribute("profileMobile");
    String profileRole = (String) request.getAttribute("profileRole");
    Timestamp profileCreatedAt = (Timestamp) request.getAttribute("profileCreatedAt");
    Timestamp profileLastLogin = (Timestamp) request.getAttribute("profileLastLogin");
    Boolean profileCompleted = (Boolean) request.getAttribute("profileCompleted");

    String success = request.getParameter("success");
    String message = request.getParameter("message");

    if (profileFullName == null) profileFullName = userName;
    if (profileEmail == null) profileEmail = "";
    if (profileMobile == null) profileMobile = "";
    if (profileRole == null) profileRole = "ENTREPRENEUR";
    if (profileCompleted == null) profileCompleted = false;
    
    String profileAvatarLetter = profileFullName.length() > 0 ? profileFullName.substring(0, 1).toUpperCase() : "U";
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | CHAPERON</title>
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

        /* ALERTS */
        .notice { margin-bottom: 22px; padding: 14px 18px; border-radius: 12px; font-size: 14px; font-weight: 600; line-height: 1.5; display: flex; align-items: center; gap: 10px; }
        .notice-success { color: #08794d; background: #e8f8f0; border: 1px solid #c9eedc; }
        .notice-error { color: #b72f2f; background: #fff0f0; border: 1px solid #ffd1d1; }

        /* HERO */
        .hero { position: relative; overflow: hidden; padding: 32px 34px; margin-bottom: 22px; border: 1px solid #cfe1f5; border-radius: 20px; background: linear-gradient(125deg, #075ecb, #1688ef 65%, #35a9ef); box-shadow: 0 11px 31px rgba(27, 65, 107, 0.1); color: white; }
        .hero h2 { margin: 0 0 8px; font-size: 28px; font-weight: 900; }
        .hero p { max-width: 720px; margin: 0; font-size: 14px; line-height: 1.5; color: #eaf5ff; }

        /* PROFILE HEADER */
        .profile-header { background: white; border: 1px solid #dfe8f4; border-radius: 18px; padding: 24px; display: flex; align-items: center; gap: 24px; margin-bottom: 24px; box-shadow: var(--shadow); }
        .avatar-lg { width: 80px; height: 80px; flex: none; border-radius: 50%; background: linear-gradient(135deg, #0962e8, #27b5ed); color: white; display: flex; align-items: center; justify-content: center; font-size: 32px; font-weight: 900; box-shadow: 0 8px 20px rgba(9, 98, 232, 0.2); }
        .profile-name { font-size: 24px; font-weight: 900; color: #102446; margin-bottom: 4px; }
        .profile-email { color: #6b7e98; font-size: 14px; margin-bottom: 10px; font-weight: 600; }
        .role-badge { display: inline-flex; align-items: center; min-height: 24px; padding: 0 10px; border-radius: 6px; font-size: 10px; font-weight: 900; text-transform: uppercase; letter-spacing: 0.5px; background: #eef4fc; color: #0962e8; }

        /* LAYOUT GRID */
        .content-grid { display: grid; grid-template-columns: 1.5fr 1fr; gap: 22px; align-items: start; }
        
        .section-card { background: white; border: 1px solid #dfe8f4; border-radius: 18px; padding: 24px; box-shadow: var(--shadow); }
        .section-header-wrap { margin-bottom: 22px; border-bottom: 1px solid #edf2f9; padding-bottom: 15px; }
        .section-header-wrap h3 { font-size: 19px; font-weight: 850; color: #152b4d; margin-bottom: 4px; }
        .section-header-wrap p { color: #728096; font-size: 13px; margin: 0; line-height: 1.5; }

        /* FORM */
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 13px; font-weight: 800; color: #263954; margin-bottom: 8px; }
        .form-control { width: 100%; min-height: 46px; padding: 10px 14px; border: 1px solid #cfdced; border-radius: 10px; background: #fff; font-family: inherit; font-size: 14px; color: #102446; outline: none; transition: 0.2s; }
        .form-control:focus { border-color: #0962e8; box-shadow: 0 0 0 4px rgba(9, 98, 232, 0.1); }
        .form-control[readonly] { background: #f0f3f7; color: #6b7e98; border-color: #e2eaf5; cursor: not-allowed; }
        .helper { color: #8394ab; font-size: 11px; margin-top: 6px; line-height: 1.4; font-weight: 600; }
        
        .primary-btn { display: inline-flex; align-items: center; justify-content: center; min-height: 46px; padding: 0 24px; border: 0; border-radius: 10px; color: white; background: linear-gradient(135deg, #0962e8, #0750c5); font-size: 14px; font-weight: 800; cursor: pointer; box-shadow: 0 8px 18px rgba(9, 98, 232, 0.2); transition: 0.2s; }
        .primary-btn:hover { transform: translateY(-1px); box-shadow: 0 10px 22px rgba(9, 98, 232, 0.25); }

        /* INFO ROWS */
        .info-list { display: grid; gap: 12px; }
        .info-row { display: flex; flex-direction: column; gap: 4px; padding: 14px; border: 1px solid #eaf0f8; border-radius: 10px; background: #f8fbfe; }
        .info-label { font-size: 10px; color: #8394ab; font-weight: 850; text-transform: uppercase; letter-spacing: 0.5px; }
        .info-value { font-size: 14px; font-weight: 750; color: #243c5d; line-height: 1.4; word-break: break-word; }
        
        .status-complete { color: #11784c; display: flex; align-items: center; gap: 6px; }
        .status-pending { color: #ba711c; display: flex; align-items: center; gap: 6px; }

        .security-note { margin-top: 20px; padding: 16px; border-radius: 12px; background: #fef9f2; border: 1px solid #fbe5cc; color: #a36300; font-size: 12px; line-height: 1.6; font-weight: 600; }
        .security-note strong { color: #8c5300; display: block; margin-bottom: 4px; font-size: 13px; }

        @media (max-width: 1050px) {
            .content-grid { grid-template-columns: 1fr; }
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
            .profile-header { flex-direction: column; text-align: center; gap: 15px; }
            .primary-btn { width: 100%; }
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
            <a href="<%= ctx %>/entrepreneur/notifications" class="nav-item">
                <svg viewBox="0 0 24 24" fill="none"><path d="M18 8A6 6 0 0 0 6 8C6 15 3 16 3 16H21C21 16 18 15 18 8Z" stroke="currentColor" stroke-width="2"/><path d="M10 20H14" stroke="currentColor" stroke-width="2"/></svg>
                <span>Notifications</span>
            </a>
            <!-- Profile (ACTIVE) -->
            <a href="<%= ctx %>/entrepreneur/profile" class="nav-item active">
                <svg viewBox="0 0 24 24" fill="none"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><circle cx="12" cy="7" r="4" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
                <span>Profile</span>
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
                <h1>Account Settings</h1>
                <p>Manage your personal profile and account security preferences.</p>
            </div>
            <div class="top-actions">
                <div class="top-profile">
                    <%= avatarLetter %>&nbsp;<%= esc(userName) %>
                </div>
            </div>
        </header>

        <!-- ALERTS -->
        <% if ("profile-updated".equals(success)) { %>
            <div class="notice notice-success">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                Profile updated successfully.
            </div>
        <% } %>

        <% if (message != null && !message.isBlank()) { %>
            <div class="notice notice-error">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                <%= esc(message) %>
            </div>
        <% } %>

        <!-- HERO SECTION -->
        <section class="hero">
            <h2>My Profile</h2>
            <p>Manage the primary contact information associated with your CHAPERON regulatory journey. Keep these details updated to receive critical application and compliance alerts.</p>
        </section>

        <!-- PROFILE HEADER -->
        <section class="profile-header">
            <div class="avatar-lg">
                <%= profileAvatarLetter %>
            </div>
            <div>
                <div class="profile-name"><%= esc(profileFullName) %></div>
                <div class="profile-email"><%= esc(profileEmail) %></div>
                <span class="role-badge"><%= esc(profileRole) %></span>
            </div>
        </section>

        <div class="content-grid">

            <!-- EDIT PROFILE FORM -->
            <section class="section-card">
                <div class="section-header-wrap">
                    <h3>Personal Information</h3>
                    <p>Update your contact details below.</p>
                </div>

                <form method="post" action="<%= ctx %>/entrepreneur/profile">
                    
                    <div class="form-group">
                        <label class="form-label">Full Name *</label>
                        <input type="text" name="fullName" class="form-control" minlength="2" maxlength="150" value="<%= esc(profileFullName) %>" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Email Address</label>
                        <input type="email" class="form-control" value="<%= esc(profileEmail) %>" readonly>
                        <div class="helper">Your registered email acts as your primary ID and cannot be changed here for security reasons.</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Mobile Number *</label>
                        <input type="text" name="mobile" class="form-control" maxlength="10" pattern="[6-9][0-9]{9}" value="<%= esc(profileMobile) %>" placeholder="10-digit mobile number" required>
                        <div class="helper">Enter a valid 10-digit Indian mobile number for SMS notifications.</div>
                    </div>

                    <button type="submit" class="primary-btn">Save Changes</button>
                </form>
            </section>

            <!-- ACCOUNT DETAILS -->
            <aside class="section-card">
                <div class="section-header-wrap">
                    <h3>Account Status</h3>
                    <p>Basic profile timeline.</p>
                </div>

                <div class="info-list">
                    <div class="info-row">
                        <div class="info-label">Account Role</div>
                        <div class="info-value"><%= esc(profileRole) %></div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">Business Profile Status</div>
                        <% if (profileCompleted) { %>
                            <div class="info-value status-complete">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                                Completed
                            </div>
                        <% } else { %>
                            <div class="info-value status-pending">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                Pending Setup
                            </div>
                        <% } %>
                    </div>

                    <div class="info-row">
                        <div class="info-label">Account Created</div>
                        <div class="info-value"><%= profileCreatedAt != null ? esc(profileCreatedAt) : "Not Available" %></div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">Last Login</div>
                        <div class="info-value"><%= profileLastLogin != null ? esc(profileLastLogin) : "Just Now" %></div>
                    </div>
                </div>

                <div class="security-note">
                    <strong>Account Security</strong>
                    Never share your CHAPERON password with anyone. Your business data and legal applications are tied exclusively to this secure account.
                </div>
            </aside>

        </div>

    </main>
</div>

</body>
</html>