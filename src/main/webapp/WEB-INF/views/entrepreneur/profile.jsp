<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

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

    if (userName == null || userName.isBlank()) {
        userName = "Entrepreneur";
    }


    String profileFullName =
            (String) request.getAttribute("profileFullName");

    String profileEmail =
            (String) request.getAttribute("profileEmail");

    String profileMobile =
            (String) request.getAttribute("profileMobile");

    String profileRole =
            (String) request.getAttribute("profileRole");

    Timestamp profileCreatedAt =
            (Timestamp) request.getAttribute("profileCreatedAt");

    Timestamp profileLastLogin =
            (Timestamp) request.getAttribute("profileLastLogin");

    Boolean profileCompleted =
            (Boolean) request.getAttribute("profileCompleted");


    String success =
            request.getParameter("success");

    String message =
            request.getParameter("message");


    if (profileFullName == null) {
        profileFullName = userName;
    }

    if (profileEmail == null) {
        profileEmail = "";
    }

    if (profileMobile == null) {
        profileMobile = "";
    }

    if (profileRole == null) {
        profileRole = "ENTREPRENEUR";
    }

    if (profileCompleted == null) {
        profileCompleted = false;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>My Profile | CHAPERON</title>

<style>

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, Helvetica, sans-serif;
    background: #f4f7fb;
    color: #17233c;
}

.layout {
    display: flex;
    min-height: 100vh;
}


/* ==============================
   SIDEBAR
   ============================== */

.sidebar {
    width: 260px;
    background: #10233f;
    color: white;
    padding: 24px 18px;
    position: fixed;
    top: 0;
    bottom: 0;
    left: 0;
    overflow-y: auto;
}

.logo {
    font-size: 25px;
    font-weight: 900;
    margin-bottom: 6px;
}

.tagline {
    color: #b7c4d6;
    font-size: 11px;
    line-height: 1.5;
    margin-bottom: 25px;
}

.user-box {
    background: rgba(255,255,255,0.08);
    border-radius: 12px;
    padding: 15px;
    margin-bottom: 24px;
}

.user-small {
    color: #aebed2;
    font-size: 11px;
    margin-bottom: 5px;
}

.user-name {
    font-size: 14px;
    font-weight: 800;
}

.menu {
    display: flex;
    flex-direction: column;
    gap: 5px;
}

.menu-heading {
    color: #8296b1;
    font-size: 10px;
    font-weight: 900;
    letter-spacing: 1px;
    margin: 15px 10px 7px;
}

.menu-item {
    text-decoration: none;
    color: #d6e0ec;
    padding: 12px 13px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 700;
    display: flex;
    gap: 10px;
    align-items: center;
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

.separator {
    height: 1px;
    background: rgba(255,255,255,0.12);
    margin: 12px 0;
}


/* ==============================
   MAIN
   ============================== */

.main {
    margin-left: 260px;
    width: calc(100% - 260px);
}

.topbar {
    height: 70px;
    background: white;
    border-bottom: 1px solid #e5eaf1;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 35px;
}

.topbar-title {
    font-size: 18px;
    font-weight: 900;
}

.topbar-user {
    color: #64748b;
    font-size: 13px;
}

.content {
    padding: 35px;
    max-width: 1250px;
    margin: auto;
}


/* ==============================
   HERO
   ============================== */

.hero {
    background: white;
    border: 1px solid #e4eaf1;
    border-radius: 20px;
    padding: 28px;
    margin-bottom: 22px;
    box-shadow: 0 10px 30px rgba(24,50,84,0.05);
}

.hero h1 {
    margin: 0 0 8px;
    font-size: 30px;
}

.hero p {
    margin: 0;
    color: #68778a;
    line-height: 1.6;
}


/* ==============================
   ALERTS
   ============================== */

.alert {
    border-radius: 12px;
    padding: 15px 18px;
    margin-bottom: 20px;
    font-size: 14px;
    line-height: 1.6;
}

.alert-success {
    background: #e8f7ed;
    border: 1px solid #ccebd6;
    color: #267a42;
}

.alert-error {
    background: #fff0ee;
    border: 1px solid #efceca;
    color: #b8342a;
}


/* ==============================
   PROFILE SUMMARY
   ============================== */

.profile-header {
    background: white;
    border: 1px solid #e4eaf1;
    border-radius: 18px;
    padding: 25px;
    display: flex;
    align-items: center;
    gap: 20px;
    margin-bottom: 22px;
}

.avatar {
    width: 75px;
    height: 75px;
    border-radius: 50%;
    background: #e9f3ff;
    color: #1677e8;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 30px;
    font-weight: 900;
}

.profile-name {
    font-size: 22px;
    font-weight: 900;
    margin-bottom: 5px;
}

.profile-email {
    color: #6f7d90;
    font-size: 14px;
    margin-bottom: 8px;
}

.role-badge {
    display: inline-block;
    background: #e8f2ff;
    color: #1768c7;
    padding: 6px 10px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 900;
}


/* ==============================
   GRID
   ============================== */

.grid {
    display: grid;
    grid-template-columns: 1.4fr 1fr;
    gap: 20px;
}

.card {
    background: white;
    border: 1px solid #e4eaf1;
    border-radius: 18px;
    padding: 25px;
}

.card h2 {
    margin: 0 0 6px;
    font-size: 20px;
}

.card-subtitle {
    color: #748196;
    font-size: 13px;
    line-height: 1.6;
    margin-bottom: 22px;
}


/* ==============================
   FORM
   ============================== */

.form-group {
    margin-bottom: 19px;
}

.form-label {
    display: block;
    font-size: 13px;
    font-weight: 800;
    margin-bottom: 8px;
}

.form-control {
    width: 100%;
    padding: 13px 14px;
    border: 1px solid #d6dee8;
    border-radius: 10px;
    font-family: Arial, Helvetica, sans-serif;
    font-size: 14px;
    outline: none;
    background: white;
}

.form-control:focus {
    border-color: #1677e8;
}

.form-control[readonly] {
    background: #f5f7fa;
    color: #6d7989;
    cursor: not-allowed;
}

.helper {
    color: #8995a5;
    font-size: 11px;
    margin-top: 6px;
    line-height: 1.5;
}

.primary-btn {
    border: none;
    background: #1677e8;
    color: white;
    padding: 13px 20px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 800;
    cursor: pointer;
}

.primary-btn:hover {
    background: #0f67c8;
}


/* ==============================
   ACCOUNT INFO
   ============================== */

.info-row {
    padding: 15px 0;
    border-bottom: 1px solid #edf1f5;
}

.info-row:last-child {
    border-bottom: none;
}

.info-label {
    color: #7b8797;
    font-size: 11px;
    font-weight: 900;
    text-transform: uppercase;
    margin-bottom: 6px;
}

.info-value {
    color: #26374d;
    font-size: 14px;
    font-weight: 800;
    word-break: break-word;
}

.complete {
    color: #267a42;
}

.incomplete {
    color: #a96c00;
}

.security-note {
    margin-top: 20px;
    background: #f5f9ff;
    border: 1px solid #dae9fb;
    padding: 15px;
    border-radius: 12px;
    color: #506d8d;
    font-size: 13px;
    line-height: 1.6;
}


/* ==============================
   RESPONSIVE
   ============================== */

@media(max-width: 900px) {

    .grid {
        grid-template-columns: 1fr;
    }
}

@media(max-width: 750px) {

    .layout {
        display: block;
    }

    .sidebar {
        width: 100%;
        position: static;
    }

    .main {
        margin-left: 0;
        width: 100%;
    }

    .content {
        padding: 20px;
    }

    .topbar {
        padding: 0 20px;
    }
}

</style>

</head>


<body>

<div class="layout">


<!-- ======================================
     SIDEBAR
     ====================================== -->

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

        <div class="user-small">
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


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/notifications">

            <span class="menu-icon">●</span>
            Notifications

        </a>


        <a class="menu-item"
           href="javascript:void(0)"
           onclick="alert('Help module will be connected in Step 15B.')">

            <span class="menu-icon">?</span>
            Help

        </a>


        <div class="menu-heading">
            ACCOUNT
        </div>


        <a class="menu-item active"
           href="<%= request.getContextPath() %>/entrepreneur/profile">

            <span class="menu-icon">♟</span>
            Profile

        </a>


        <div class="separator"></div>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/logout">

            <span class="menu-icon">↪</span>
            Logout

        </a>

    </nav>

</aside>



<!-- ======================================
     MAIN
     ====================================== -->

<main class="main">


    <div class="topbar">

        <div class="topbar-title">
            My Profile
        </div>

        <div class="topbar-user">
            <%= esc(userName) %>
        </div>

    </div>


    <div class="content">


        <%
        if ("profile-updated".equals(success)) {
        %>

        <div class="alert alert-success">
            Profile updated successfully.
        </div>

        <%
        }
        %>


        <%
        if (message != null &&
            !message.isBlank()) {
        %>

        <div class="alert alert-error">
            <%= esc(message) %>
        </div>

        <%
        }
        %>



        <!-- HERO -->

        <div class="hero">

            <h1>
                My Profile
            </h1>

            <p>
                Manage your personal account information
                used across your CHAPERON approval journey.
            </p>

        </div>



        <!-- PROFILE HEADER -->

        <div class="profile-header">

            <div class="avatar">

                <%
                if (profileFullName != null &&
                    !profileFullName.isBlank()) {
                %>

                    <%= esc(
                            profileFullName
                            .substring(0, 1)
                            .toUpperCase()
                    ) %>

                <%
                } else {
                %>

                    U

                <%
                }
                %>

            </div>


            <div>

                <div class="profile-name">
                    <%= esc(profileFullName) %>
                </div>

                <div class="profile-email">
                    <%= esc(profileEmail) %>
                </div>

                <span class="role-badge">
                    <%= esc(profileRole) %>
                </span>

            </div>

        </div>



        <div class="grid">


            <!-- ==========================
                 EDIT PROFILE
                 ========================== -->

            <div class="card">

                <h2>
                    Personal Information
                </h2>

                <div class="card-subtitle">

                    You can update your name and
                    mobile number here.

                    Your registered email is kept
                    read-only for account security.

                </div>


                <form method="post"
                      action="<%= request.getContextPath() %>/entrepreneur/profile">


                    <div class="form-group">

                        <label class="form-label">
                            Full Name *
                        </label>

                        <input type="text"
                               name="fullName"
                               class="form-control"
                               minlength="2"
                               maxlength="150"
                               value="<%= esc(profileFullName) %>"
                               required>

                    </div>



                    <div class="form-group">

                        <label class="form-label">
                            Email Address
                        </label>

                        <input type="email"
                               class="form-control"
                               value="<%= esc(profileEmail) %>"
                               readonly>

                        <div class="helper">

                            Your login email cannot be
                            changed from this page.

                        </div>

                    </div>



                    <div class="form-group">

                        <label class="form-label">
                            Mobile Number *
                        </label>

                        <input type="text"
                               name="mobile"
                               class="form-control"
                               maxlength="10"
                               pattern="[6-9][0-9]{9}"
                               value="<%= esc(profileMobile) %>"
                               placeholder="10-digit mobile number"
                               required>

                        <div class="helper">

                            Enter a valid 10-digit
                            Indian mobile number.

                        </div>

                    </div>



                    <button type="submit"
                            class="primary-btn">

                        Save Changes

                    </button>

                </form>

            </div>



            <!-- ==========================
                 ACCOUNT DETAILS
                 ========================== -->

            <div class="card">

                <h2>
                    Account Information
                </h2>

                <div class="card-subtitle">

                    Basic account and profile
                    status information.

                </div>



                <div class="info-row">

                    <div class="info-label">
                        Account Role
                    </div>

                    <div class="info-value">
                        <%= esc(profileRole) %>
                    </div>

                </div>



                <div class="info-row">

                    <div class="info-label">
                        Registered Email
                    </div>

                    <div class="info-value">
                        <%= esc(profileEmail) %>
                    </div>

                </div>



                <div class="info-row">

                    <div class="info-label">
                        Business Profile
                    </div>


                    <%
                    if (profileCompleted) {
                    %>

                    <div class="info-value complete">
                        ✓ Completed
                    </div>

                    <%
                    } else {
                    %>

                    <div class="info-value incomplete">
                        Pending
                    </div>

                    <%
                    }
                    %>

                </div>



                <div class="info-row">

                    <div class="info-label">
                        Account Created
                    </div>

                    <div class="info-value">

                        <%= profileCreatedAt != null
                                ? esc(profileCreatedAt)
                                : "Not Available" %>

                    </div>

                </div>



                <div class="info-row">

                    <div class="info-label">
                        Last Login
                    </div>

                    <div class="info-value">

                        <%= profileLastLogin != null
                                ? esc(profileLastLogin)
                                : "Not Available" %>

                    </div>

                </div>


                <div class="security-note">

                    <strong>Account Security</strong>

                    <br><br>

                    Never share your CHAPERON password
                    or login credentials with anyone.

                    Your business information and approval
                    applications remain associated with
                    this account.

                </div>

            </div>


        </div>


    </div>

</main>

</div>

</body>

</html>