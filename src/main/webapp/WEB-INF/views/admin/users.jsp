<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>

<%
    String userName = (String) session.getAttribute("userName");

    if (userName == null || userName.isBlank()) {
        userName = "Administrator";
    }

    List<Map<String, Object>> entrepreneurs =
            (List<Map<String, Object>>) request.getAttribute("entrepreneurs");

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Entrepreneurs | CHAPERON</title>

<style>

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, Helvetica, sans-serif;
    background: #f5f7fb;
    color: #17233c;
}

a {
    text-decoration: none;
}

button {
    font-family: inherit;
}


/* =========================
   LAYOUT
   ========================= */

.layout {
    min-height: 100vh;
    display: flex;
}

.sidebar {
    width: 260px;
    min-height: 100vh;
    background: #10233f;
    color: white;
    position: fixed;
    left: 0;
    top: 0;
    padding: 25px 18px;
    overflow-y: auto;
}

.brand {
    padding: 5px 12px 28px;
    border-bottom: 1px solid rgba(255,255,255,0.12);
    margin-bottom: 22px;
}

.brand-name {
    font-size: 25px;
    font-weight: 900;
    letter-spacing: 1px;
}

.brand-subtitle {
    margin-top: 5px;
    font-size: 12px;
    color: #aebbd0;
}

.menu-title {
    padding: 0 12px;
    margin: 22px 0 10px;
    color: #8495ad;
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 1px;
}

.menu-item {
    display: block;
    color: #dbe5f2;
    padding: 12px 14px;
    border-radius: 9px;
    margin-bottom: 6px;
    font-size: 14px;
    font-weight: 700;
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
    display: inline-block;
    width: 25px;
}

.logout {
    margin-top: 25px;
    border-top: 1px solid rgba(255,255,255,0.12);
    padding-top: 18px;
}


/* =========================
   MAIN
   ========================= */

.main {
    margin-left: 260px;
    width: calc(100% - 260px);
    min-height: 100vh;
}

.topbar {
    height: 75px;
    background: white;
    border-bottom: 1px solid #e3e8ef;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 32px;
    position: sticky;
    top: 0;
    z-index: 10;
}

.topbar-title {
    font-size: 18px;
    font-weight: 800;
}

.admin-info {
    display: flex;
    align-items: center;
    gap: 12px;
}

.avatar {
    width: 40px;
    height: 40px;
    background: #e9f3ff;
    color: #1677e8;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 900;
}

.admin-name {
    font-size: 14px;
    font-weight: 800;
}

.admin-role {
    font-size: 11px;
    color: #748196;
    margin-top: 3px;
}

.content {
    padding: 32px;
}


/* =========================
   HEADER
   ========================= */

.page-header {
    margin-bottom: 25px;
}

.page-header h1 {
    margin: 0;
    font-size: 28px;
}

.page-header p {
    margin: 8px 0 0;
    color: #6e7b8d;
    line-height: 1.6;
}


/* =========================
   ALERTS
   ========================= */

.alert {
    padding: 13px 16px;
    border-radius: 10px;
    margin-bottom: 22px;
    font-size: 14px;
    font-weight: 700;
}

.alert-success {
    background: #ecfaf3;
    border: 1px solid #bce9d1;
    color: #18784d;
}

.alert-error {
    background: #fff0ef;
    border: 1px solid #ffd2cf;
    color: #b9342d;
}


/* =========================
   SUMMARY
   ========================= */

.summary-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 18px;
    margin-bottom: 25px;
}

.summary-card {
    background: white;
    border: 1px solid #e4e9f0;
    border-radius: 14px;
    padding: 20px;
}

.summary-label {
    color: #718095;
    font-size: 13px;
    font-weight: 700;
}

.summary-number {
    margin-top: 10px;
    font-size: 28px;
    font-weight: 900;
}


/* =========================
   TABLE
   ========================= */

.table-card {
    background: white;
    border: 1px solid #e4e9f0;
    border-radius: 15px;
    overflow: hidden;
}

.table-header {
    padding: 20px 22px;
    border-bottom: 1px solid #e7ebf1;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.table-header h2 {
    margin: 0;
    font-size: 18px;
}

.table-header span {
    color: #7a8798;
    font-size: 13px;
}

.table-wrapper {
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 1550px;
}

th {
    background: #f8fafc;
    color: #657287;
    text-align: left;
    padding: 14px 18px;
    font-size: 12px;
    font-weight: 800;
    border-bottom: 1px solid #e7ebf1;
}

td {
    padding: 17px 18px;
    border-bottom: 1px solid #edf0f4;
    font-size: 13px;
    vertical-align: top;
}

tbody tr:hover {
    background: #fbfcfe;
}

.name {
    font-weight: 900;
}

.small-text {
    margin-top: 5px;
    color: #788598;
    font-size: 12px;
    line-height: 1.5;
}

.badge {
    display: inline-block;
    padding: 6px 9px;
    border-radius: 7px;
    font-size: 11px;
    font-weight: 900;
}

.badge-blue {
    background: #edf5ff;
    color: #1768c7;
}

.badge-green {
    background: #e8f8ef;
    color: #188052;
}

.badge-grey {
    background: #f0f2f5;
    color: #687487;
}

.badge-orange {
    background: #fff4dc;
    color: #9c6700;
}

.status {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 900;
}

.status-active {
    background: #e8f8ef;
    color: #188052;
}

.status-inactive {
    background: #fff0ef;
    color: #b23d36;
}

.toggle-btn {
    border: none;
    padding: 8px 11px;
    border-radius: 7px;
    cursor: pointer;
    font-size: 12px;
    font-weight: 800;
}

.deactivate-btn {
    background: #fff0ef;
    color: #ba3b34;
}

.activate-btn {
    background: #e8f8ef;
    color: #157849;
}

.details-btn {
    border: 1px solid #cbd7e5;
    background: white;
    color: #31506f;
    padding: 8px 11px;
    border-radius: 7px;
    cursor: pointer;
    font-size: 12px;
    font-weight: 800;
}

.action-group {
    display: flex;
    gap: 7px;
}

.empty-state {
    padding: 50px 20px;
    text-align: center;
    color: #7a8798;
}


/* =========================
   MODAL
   ========================= */

.modal {
    display: none;
    position: fixed;
    inset: 0;
    z-index: 100;
    background: rgba(16,35,63,0.55);
    align-items: center;
    justify-content: center;
    padding: 20px;
}

.modal.show {
    display: flex;
}

.modal-content {
    width: 100%;
    max-width: 800px;
    max-height: 92vh;
    overflow-y: auto;
    background: white;
    border-radius: 18px;
}

.modal-header {
    padding: 22px 24px;
    border-bottom: 1px solid #e6eaf0;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.modal-header h2 {
    margin: 0;
    font-size: 19px;
}

.close-btn {
    border: none;
    background: #f2f4f7;
    width: 35px;
    height: 35px;
    border-radius: 50%;
    font-size: 20px;
    cursor: pointer;
}

.modal-body {
    padding: 24px;
}

.detail-section {
    margin-bottom: 25px;
}

.detail-section:last-child {
    margin-bottom: 0;
}

.detail-section h3 {
    margin: 0 0 14px;
    font-size: 15px;
    padding-bottom: 8px;
    border-bottom: 1px solid #edf0f4;
}

.detail-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 14px;
}

.detail-box {
    background: #f8fafc;
    border: 1px solid #e8edf3;
    border-radius: 10px;
    padding: 13px;
}

.detail-label {
    font-size: 11px;
    color: #758296;
    font-weight: 800;
    margin-bottom: 6px;
}

.detail-value {
    font-size: 13px;
    font-weight: 700;
    word-break: break-word;
}


/* =========================
   RESPONSIVE
   ========================= */

@media (max-width: 1000px) {

    .sidebar {
        display: none;
    }

    .main {
        margin-left: 0;
        width: 100%;
    }

    .summary-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 700px) {

    .content {
        padding: 20px;
    }

    .topbar {
        padding: 0 20px;
    }

    .summary-grid,
    .detail-grid {
        grid-template-columns: 1fr;
    }
}

</style>

</head>

<body>

<div class="layout">


<aside class="sidebar">

    <div class="brand">

        <div class="brand-name">
            CHAPERON
        </div>

        <div class="brand-subtitle">
            Administration Portal
        </div>

    </div>


    <div class="menu-title">
        OVERVIEW
    </div>

    <a class="menu-item"
       href="<%= request.getContextPath() %>/admin/dashboard">

        <span class="menu-icon">▦</span>
        Dashboard

    </a>


    <div class="menu-title">
        MANAGEMENT
    </div>

    <a class="menu-item"
       href="<%= request.getContextPath() %>/admin/departments">

        <span class="menu-icon">🏢</span>
        Departments

    </a>

    <a class="menu-item"
       href="<%= request.getContextPath() %>/admin/officers">

        <span class="menu-icon">👤</span>
        Officers

    </a>

    <a class="menu-item"
       href="<%= request.getContextPath() %>/admin/approvals">

        <span class="menu-icon">✓</span>
        Approvals

    </a>

    <a class="menu-item"
       href="<%= request.getContextPath() %>/admin/approval-rules">

        <span class="menu-icon">⚙</span>
        Approval Rules

    </a>

    <a class="menu-item"
       href="<%= request.getContextPath() %>/admin/schemes">

        <span class="menu-icon">★</span>
        Government Schemes

    </a>


    <div class="menu-title">
        MONITORING
    </div>

    <a class="menu-item active"
       href="<%= request.getContextPath() %>/admin/users">

        <span class="menu-icon">♟</span>
        Entrepreneurs

    </a>

    <a class="menu-item"
       href="<%= request.getContextPath() %>/admin/applications">

        <span class="menu-icon">▤</span>
        Applications

    </a>

    <a class="menu-item"
       href="<%= request.getContextPath() %>/admin/analytics">

        <span class="menu-icon">▥</span>
        Analytics

    </a>


    <div class="logout">

        <a class="menu-item"
           href="<%= request.getContextPath() %>/logout">

            <span class="menu-icon">↪</span>
            Logout

        </a>

    </div>

</aside>


<main class="main">


<header class="topbar">

    <div class="topbar-title">
        Entrepreneur Management
    </div>

    <div class="admin-info">

        <div class="avatar">
            A
        </div>

        <div>

            <div class="admin-name">
                <%= userName %>
            </div>

            <div class="admin-role">
                System Administrator
            </div>

        </div>

    </div>

</header>


<div class="content">


<div class="page-header">

    <h1>
        Entrepreneurs
    </h1>

    <p>
        Monitor registered entrepreneurs, business profiles,
        application activity and account access.
    </p>

</div>


<%
if ("status-updated".equals(success)) {
%>

<div class="alert alert-success">
    Entrepreneur account status updated successfully.
</div>

<%
}
%>


<%
if ("invalid-user".equals(error)) {
%>

<div class="alert alert-error">
    Invalid entrepreneur account selected.
</div>

<%
} else if ("invalid-action".equals(error)) {
%>

<div class="alert alert-error">
    Invalid entrepreneur operation.
</div>

<%
}
%>


<%
    int totalUsers = 0;
    int activeUsers = 0;
    int completedProfiles = 0;
    int usersWithApplications = 0;

    if (entrepreneurs != null) {

        totalUsers = entrepreneurs.size();

        for (Map<String, Object> entrepreneur : entrepreneurs) {

            String accountStatus =
                    (String) entrepreneur.get("accountStatus");

            Boolean profileCompleted =
                    (Boolean) entrepreneur.get("profileCompleted");

            Integer applicationCount =
                    (Integer) entrepreneur.get("applicationCount");


            if ("ACTIVE".equalsIgnoreCase(accountStatus)) {
                activeUsers++;
            }

            if (Boolean.TRUE.equals(profileCompleted)) {
                completedProfiles++;
            }

            if (applicationCount != null &&
                applicationCount > 0) {

                usersWithApplications++;
            }
        }
    }
%>


<div class="summary-grid">

    <div class="summary-card">

        <div class="summary-label">
            Total Entrepreneurs
        </div>

        <div class="summary-number">
            <%= totalUsers %>
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Active Accounts
        </div>

        <div class="summary-number">
            <%= activeUsers %>
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Completed Profiles
        </div>

        <div class="summary-number">
            <%= completedProfiles %>
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Users with Applications
        </div>

        <div class="summary-number">
            <%= usersWithApplications %>
        </div>

    </div>

</div>


<div class="table-card">

    <div class="table-header">

        <h2>
            Entrepreneur Directory
        </h2>

        <span>
            <%= totalUsers %> entrepreneur(s)
        </span>

    </div>


    <div class="table-wrapper">


    <%
    if (entrepreneurs == null ||
        entrepreneurs.isEmpty()) {
    %>

        <div class="empty-state">
            No entrepreneur accounts found.
        </div>

    <%
    } else {
    %>

        <table>

            <thead>

                <tr>

                    <th>Entrepreneur</th>
                    <th>Business</th>
                    <th>Industry</th>
                    <th>Location</th>
                    <th>Profile</th>
                    <th>Applications</th>
                    <th>Approved</th>
                    <th>Last Login</th>
                    <th>Status</th>
                    <th>Actions</th>

                </tr>

            </thead>


            <tbody>


            <%
            for (Map<String, Object> entrepreneur : entrepreneurs) {

                Long userId =
                        (Long) entrepreneur.get("userId");

                Object businessId =
                        entrepreneur.get("businessId");

                String fullName =
                        (String) entrepreneur.get("fullName");

                String email =
                        (String) entrepreneur.get("email");

                String mobile =
                        (String) entrepreneur.get("mobile");

                Object createdAt =
                        entrepreneur.get("createdAt");

                Object lastLogin =
                        entrepreneur.get("lastLogin");

                Boolean profileCompleted =
                        (Boolean) entrepreneur.get("profileCompleted");

                String accountStatus =
                        (String) entrepreneur.get("accountStatus");

                String businessName =
                        (String) entrepreneur.get("businessName");

                String businessConstitution =
                        (String) entrepreneur.get("businessConstitution");

                String businessActivity =
                        (String) entrepreneur.get("businessActivity");

                String industry =
                        (String) entrepreneur.get("industry");

                String state =
                        (String) entrepreneur.get("state");

                String district =
                        (String) entrepreneur.get("district");

                String taluka =
                        (String) entrepreneur.get("taluka");

                String industrialArea =
                        (String) entrepreneur.get("industrialArea");

                String pinCode =
                        (String) entrepreneur.get("pinCode");

                String projectStage =
                        (String) entrepreneur.get("projectStage");

                BigDecimal investmentAmount =
                        (BigDecimal) entrepreneur.get("investmentAmount");

                Integer employeeCount =
                        (Integer) entrepreneur.get("employeeCount");

                String pollutionCategory =
                        (String) entrepreneur.get("pollutionCategory");

                Integer applicationCount =
                        (Integer) entrepreneur.get("applicationCount");

                Integer approvedCount =
                        (Integer) entrepreneur.get("approvedCount");


                if (fullName == null) fullName = "";
                if (email == null) email = "";
                if (mobile == null) mobile = "";

                if (businessName == null) businessName = "";
                if (businessConstitution == null) businessConstitution = "";
                if (businessActivity == null) businessActivity = "";
                if (industry == null) industry = "";

                if (state == null) state = "";
                if (district == null) district = "";
                if (taluka == null) taluka = "";
                if (industrialArea == null) industrialArea = "";
                if (pinCode == null) pinCode = "";

                if (projectStage == null) projectStage = "";
                if (pollutionCategory == null) pollutionCategory = "";

                if (applicationCount == null) applicationCount = 0;
                if (approvedCount == null) approvedCount = 0;
            %>


                <tr>


                    <td>

                        <div class="name">
                            <%= fullName %>
                        </div>

                        <div class="small-text">
                            <%= email %>
                        </div>

                        <%
                        if (!mobile.isBlank()) {
                        %>

                            <div class="small-text">
                                <%= mobile %>
                            </div>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <%
                        if (businessId != null &&
                            !businessName.isBlank()) {
                        %>

                            <div class="name">
                                <%= businessName %>
                            </div>

                            <div class="small-text">

                                <%= businessConstitution.isBlank()
                                        ? "Business profile created"
                                        : businessConstitution %>

                            </div>

                        <%
                        } else {
                        %>

                            <span class="badge badge-grey">
                                Not Created
                            </span>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <%
                        if (!industry.isBlank()) {
                        %>

                            <span class="badge badge-blue">
                                <%= industry %>
                            </span>

                            <%
                            if (!businessActivity.isBlank()) {
                            %>

                                <div class="small-text">
                                    <%= businessActivity %>
                                </div>

                            <%
                            }
                            %>

                        <%
                        } else {
                        %>

                            -

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <%
                        if (!state.isBlank() ||
                            !district.isBlank()) {
                        %>

                            <div class="name">
                                <%= district.isBlank()
                                        ? state
                                        : district %>
                            </div>

                            <div class="small-text">
                                <%= state %>
                            </div>

                        <%
                        } else {
                        %>

                            -

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <%
                        if (Boolean.TRUE.equals(profileCompleted)) {
                        %>

                            <span class="badge badge-green">
                                COMPLETED
                            </span>

                        <%
                        } else {
                        %>

                            <span class="badge badge-orange">
                                INCOMPLETE
                            </span>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <span class="badge badge-blue">
                            <%= applicationCount %>
                        </span>

                    </td>


                    <td>

                        <span class="badge badge-green">
                            <%= approvedCount %>
                        </span>

                    </td>


                    <td>

                        <%
                        if (lastLogin != null) {
                        %>

                            <%= lastLogin %>

                        <%
                        } else {
                        %>

                            <span class="small-text">
                                Never logged in
                            </span>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <%
                        boolean active =
                                "ACTIVE".equalsIgnoreCase(accountStatus);

                        if (active) {
                        %>

                            <span class="status status-active">
                                ACTIVE
                            </span>

                        <%
                        } else {
                        %>

                            <span class="status status-inactive">
                                <%= accountStatus == null
                                        ? "INACTIVE"
                                        : accountStatus %>
                            </span>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <div class="action-group">


                            <button type="button"
                                    class="details-btn"
                                    onclick="openDetails(
                                        '<%= escapeJs(fullName) %>',
                                        '<%= escapeJs(email) %>',
                                        '<%= escapeJs(mobile) %>',
                                        '<%= escapeJs(businessName) %>',
                                        '<%= escapeJs(businessConstitution) %>',
                                        '<%= escapeJs(businessActivity) %>',
                                        '<%= escapeJs(industry) %>',
                                        '<%= escapeJs(state) %>',
                                        '<%= escapeJs(district) %>',
                                        '<%= escapeJs(taluka) %>',
                                        '<%= escapeJs(industrialArea) %>',
                                        '<%= escapeJs(pinCode) %>',
                                        '<%= escapeJs(projectStage) %>',
                                        '<%= investmentAmount != null ? investmentAmount.toPlainString() : "" %>',
                                        '<%= employeeCount != null ? employeeCount : "" %>',
                                        '<%= escapeJs(pollutionCategory) %>',
                                        '<%= applicationCount %>',
                                        '<%= approvedCount %>',
                                        '<%= escapeJs(String.valueOf(createdAt != null ? createdAt : "")) %>',
                                        '<%= escapeJs(String.valueOf(lastLogin != null ? lastLogin : "")) %>'
                                    )">

                                View

                            </button>


                            <form method="post"
                                  action="<%= request.getContextPath() %>/admin/users"
                                  onsubmit="return confirmAccountStatus('<%= active ? "deactivate" : "activate" %>');">

                                <input type="hidden"
                                       name="action"
                                       value="toggle-status">

                                <input type="hidden"
                                       name="userId"
                                       value="<%= userId %>">


                                <%
                                if (active) {
                                %>

                                    <button type="submit"
                                            class="toggle-btn deactivate-btn">

                                        Deactivate

                                    </button>

                                <%
                                } else {
                                %>

                                    <button type="submit"
                                            class="toggle-btn activate-btn">

                                        Activate

                                    </button>

                                <%
                                }
                                %>

                            </form>


                        </div>

                    </td>


                </tr>


            <%
            }
            %>


            </tbody>

        </table>

    <%
    }
    %>


    </div>

</div>


</div>

</main>

</div>


<!-- =========================
     DETAILS MODAL
     ========================= -->

<div id="detailsModal"
     class="modal">

    <div class="modal-content">


        <div class="modal-header">

            <h2>
                Entrepreneur Details
            </h2>

            <button type="button"
                    class="close-btn"
                    onclick="closeDetails()">

                ×

            </button>

        </div>


        <div class="modal-body">


            <div class="detail-section">

                <h3>
                    Account Information
                </h3>

                <div class="detail-grid">

                    <div class="detail-box">

                        <div class="detail-label">
                            Full Name
                        </div>

                        <div class="detail-value"
                             id="detailFullName">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Email
                        </div>

                        <div class="detail-value"
                             id="detailEmail">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Mobile
                        </div>

                        <div class="detail-value"
                             id="detailMobile">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Registered At
                        </div>

                        <div class="detail-value"
                             id="detailCreatedAt">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Last Login
                        </div>

                        <div class="detail-value"
                             id="detailLastLogin">
                        </div>

                    </div>

                </div>

            </div>


            <div class="detail-section">

                <h3>
                    Business Information
                </h3>

                <div class="detail-grid">


                    <div class="detail-box">

                        <div class="detail-label">
                            Business Name
                        </div>

                        <div class="detail-value"
                             id="detailBusinessName">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Constitution
                        </div>

                        <div class="detail-value"
                             id="detailConstitution">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Industry
                        </div>

                        <div class="detail-value"
                             id="detailIndustry">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Activity
                        </div>

                        <div class="detail-value"
                             id="detailActivity">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Project Stage
                        </div>

                        <div class="detail-value"
                             id="detailProjectStage">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Pollution Category
                        </div>

                        <div class="detail-value"
                             id="detailPollutionCategory">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Investment Amount
                        </div>

                        <div class="detail-value"
                             id="detailInvestment">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Employee Count
                        </div>

                        <div class="detail-value"
                             id="detailEmployees">
                        </div>

                    </div>

                </div>

            </div>


            <div class="detail-section">

                <h3>
                    Location
                </h3>

                <div class="detail-grid">


                    <div class="detail-box">

                        <div class="detail-label">
                            State
                        </div>

                        <div class="detail-value"
                             id="detailState">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            District
                        </div>

                        <div class="detail-value"
                             id="detailDistrict">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Taluka
                        </div>

                        <div class="detail-value"
                             id="detailTaluka">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Industrial Area
                        </div>

                        <div class="detail-value"
                             id="detailIndustrialArea">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            PIN Code
                        </div>

                        <div class="detail-value"
                             id="detailPinCode">
                        </div>

                    </div>

                </div>

            </div>


            <div class="detail-section">

                <h3>
                    Application Activity
                </h3>

                <div class="detail-grid">


                    <div class="detail-box">

                        <div class="detail-label">
                            Total Applications
                        </div>

                        <div class="detail-value"
                             id="detailApplicationCount">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Approved Applications
                        </div>

                        <div class="detail-value"
                             id="detailApprovedCount">
                        </div>

                    </div>

                </div>

            </div>


        </div>

    </div>

</div>


<script>

function displayValue(value) {

    if (
        value === null ||
        value === undefined ||
        value === "" ||
        value === "null"
    ) {

        return "Not provided";
    }

    return value;
}


function openDetails(
        fullName,
        email,
        mobile,
        businessName,
        constitution,
        activity,
        industry,
        state,
        district,
        taluka,
        industrialArea,
        pinCode,
        projectStage,
        investment,
        employees,
        pollutionCategory,
        applicationCount,
        approvedCount,
        createdAt,
        lastLogin
) {

    document.getElementById(
        "detailFullName"
    ).textContent = displayValue(fullName);

    document.getElementById(
        "detailEmail"
    ).textContent = displayValue(email);

    document.getElementById(
        "detailMobile"
    ).textContent = displayValue(mobile);

    document.getElementById(
        "detailBusinessName"
    ).textContent = displayValue(businessName);

    document.getElementById(
        "detailConstitution"
    ).textContent = displayValue(constitution);

    document.getElementById(
        "detailActivity"
    ).textContent = displayValue(activity);

    document.getElementById(
        "detailIndustry"
    ).textContent = displayValue(industry);

    document.getElementById(
        "detailState"
    ).textContent = displayValue(state);

    document.getElementById(
        "detailDistrict"
    ).textContent = displayValue(district);

    document.getElementById(
        "detailTaluka"
    ).textContent = displayValue(taluka);

    document.getElementById(
        "detailIndustrialArea"
    ).textContent = displayValue(industrialArea);

    document.getElementById(
        "detailPinCode"
    ).textContent = displayValue(pinCode);

    document.getElementById(
        "detailProjectStage"
    ).textContent = displayValue(projectStage);

    document.getElementById(
        "detailInvestment"
    ).textContent =
        investment
            ? "₹" + investment
            : "Not provided";

    document.getElementById(
        "detailEmployees"
    ).textContent = displayValue(employees);

    document.getElementById(
        "detailPollutionCategory"
    ).textContent = displayValue(pollutionCategory);

    document.getElementById(
        "detailApplicationCount"
    ).textContent = applicationCount;

    document.getElementById(
        "detailApprovedCount"
    ).textContent = approvedCount;

    document.getElementById(
        "detailCreatedAt"
    ).textContent = displayValue(createdAt);

    document.getElementById(
        "detailLastLogin"
    ).textContent = displayValue(lastLogin);


    document
        .getElementById("detailsModal")
        .classList.add("show");
}


function closeDetails() {

    document
        .getElementById("detailsModal")
        .classList.remove("show");
}


function confirmAccountStatus(action) {

    return confirm(
        "Are you sure you want to "
        + action
        + " this entrepreneur account?"
    );
}


window.onclick = function(event) {

    const modal =
        document.getElementById(
            "detailsModal"
        );

    if (event.target === modal) {
        closeDetails();
    }
};

</script>

</body>
</html>


<%!
    private String escapeJs(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("'", "\\'")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }
%>