<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.Date" %>

<%
    String userName = (String) session.getAttribute("userName");

    if (userName == null || userName.isBlank()) {
        userName = "Administrator";
    }

    List<Map<String, Object>> applications =
            (List<Map<String, Object>>) request.getAttribute("applications");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Applications Monitoring | CHAPERON</title>

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

.summary-grid {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
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
    min-width: 1750px;
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

.badge-grey {
    background: #f0f2f5;
    color: #687487;
}

.badge-orange {
    background: #fff4dc;
    color: #9c6700;
}

.badge-green {
    background: #e8f8ef;
    color: #188052;
}

.badge-red {
    background: #fff0ef;
    color: #b23d36;
}

.status {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 900;
    white-space: nowrap;
}

.status-draft {
    background: #f0f2f5;
    color: #687487;
}

.status-submitted {
    background: #edf5ff;
    color: #1768c7;
}

.status-review {
    background: #fff4dc;
    color: #9c6700;
}

.status-query {
    background: #fff0d9;
    color: #a26100;
}

.status-approved {
    background: #e8f8ef;
    color: #188052;
}

.status-rejected {
    background: #fff0ef;
    color: #b23d36;
}

.status-other {
    background: #eef0f4;
    color: #556276;
}

.sla {
    display: inline-block;
    padding: 6px 9px;
    border-radius: 7px;
    font-size: 11px;
    font-weight: 900;
}

.sla-ontrack {
    background: #e8f8ef;
    color: #188052;
}

.sla-near {
    background: #fff4dc;
    color: #9c6700;
}

.sla-breached {
    background: #fff0ef;
    color: #b23d36;
}

.sla-na {
    background: #f0f2f5;
    color: #687487;
}

.view-btn {
    border: 1px solid #cbd7e5;
    background: white;
    color: #31506f;
    padding: 8px 11px;
    border-radius: 7px;
    cursor: pointer;
    font-size: 12px;
    font-weight: 800;
}

.view-btn:hover {
    background: #f2f7fd;
}

.empty-state {
    padding: 50px 20px;
    text-align: center;
    color: #7a8798;
}

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
    max-width: 850px;
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

.detail-wide {
    grid-column: 1 / -1;
}

@media (max-width: 1100px) {

    .summary-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 1000px) {

    .sidebar {
        display: none;
    }

    .main {
        margin-left: 0;
        width: 100%;
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

    <a class="menu-item"
       href="<%= request.getContextPath() %>/admin/users">

        <span class="menu-icon">♟</span>
        Entrepreneurs

    </a>

    <a class="menu-item active"
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
        Application Monitoring
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
        All Applications
    </h1>

    <p>
        Monitor application movement across departments,
        officers, approval types, SLA timelines and outcomes.
    </p>

</div>


<%
    int totalApplications = 0;
    int draftApplications = 0;
    int pendingApplications = 0;
    int approvedApplications = 0;
    int rejectedApplications = 0;

    if (applications != null) {

        totalApplications = applications.size();

        for (Map<String, Object> appRow : applications) {

            String status =
                    (String) appRow.get("currentStatus");

            if ("DRAFT".equalsIgnoreCase(status)) {

                draftApplications++;

            } else if ("APPROVED".equalsIgnoreCase(status)) {

                approvedApplications++;

            } else if ("REJECTED".equalsIgnoreCase(status)) {

                rejectedApplications++;

            } else {

                pendingApplications++;
            }
        }
    }
%>


<div class="summary-grid">

    <div class="summary-card">

        <div class="summary-label">
            Total Applications
        </div>

        <div class="summary-number">
            <%= totalApplications %>
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Draft
        </div>

        <div class="summary-number">
            <%= draftApplications %>
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Pending / In Process
        </div>

        <div class="summary-number">
            <%= pendingApplications %>
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Approved
        </div>

        <div class="summary-number">
            <%= approvedApplications %>
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Rejected
        </div>

        <div class="summary-number">
            <%= rejectedApplications %>
        </div>

    </div>

</div>


<div class="table-card">

    <div class="table-header">

        <h2>
            Application Directory
        </h2>

        <span>
            <%= totalApplications %> application(s)
        </span>

    </div>


    <div class="table-wrapper">


    <%
    if (applications == null ||
        applications.isEmpty()) {
    %>

        <div class="empty-state">
            No applications found.
        </div>

    <%
    } else {
    %>


        <table>

            <thead>

                <tr>

                    <th>Application</th>
                    <th>Entrepreneur</th>
                    <th>Business</th>
                    <th>Approval</th>
                    <th>Department</th>
                    <th>Officer</th>
                    <th>Status</th>
                    <th>SLA</th>
                    <th>Expected Completion</th>
                    <th>Risk</th>
                    <th>Submitted</th>
                    <th>Actions</th>

                </tr>

            </thead>


            <tbody>


            <%
            java.time.LocalDate today =
                    java.time.LocalDate.now();

            for (Map<String, Object> appRow : applications) {

                Long applicationId =
                        (Long) appRow.get("applicationId");

                String applicationNumber =
                        (String) appRow.get("applicationNumber");

                String entrepreneurName =
                        (String) appRow.get("entrepreneurName");

                String entrepreneurEmail =
                        (String) appRow.get("entrepreneurEmail");

                String businessName =
                        (String) appRow.get("businessName");

                String industry =
                        (String) appRow.get("industry");

                String approvalName =
                        (String) appRow.get("approvalName");

                String approvalCode =
                        (String) appRow.get("approvalCode");

                String departmentName =
                        (String) appRow.get("departmentName");

                String departmentCode =
                        (String) appRow.get("departmentCode");

                Object assignedOfficerId =
                        appRow.get("assignedOfficerId");

                String officerName =
                        (String) appRow.get("officerName");

                String employeeCode =
                        (String) appRow.get("employeeCode");

                Object submissionDate =
                        appRow.get("submissionDate");

                String currentStatus =
                        (String) appRow.get("currentStatus");

                Integer slaDays =
                        (Integer) appRow.get("slaDays");

                Date expectedCompletionDate =
                        (Date) appRow.get("expectedCompletionDate");

                String riskLevel =
                        (String) appRow.get("riskLevel");

                String officerRemarks =
                        (String) appRow.get("officerRemarks");

                String rejectionReason =
                        (String) appRow.get("rejectionReason");

                Boolean canReapply =
                        (Boolean) appRow.get("canReapply");

                Object createdAt =
                        appRow.get("createdAt");

                Object updatedAt =
                        appRow.get("updatedAt");


                if (applicationNumber == null) applicationNumber = "";
                if (entrepreneurName == null) entrepreneurName = "";
                if (entrepreneurEmail == null) entrepreneurEmail = "";
                if (businessName == null) businessName = "";
                if (industry == null) industry = "";
                if (approvalName == null) approvalName = "";
                if (approvalCode == null) approvalCode = "";
                if (departmentName == null) departmentName = "";
                if (departmentCode == null) departmentCode = "";
                if (officerName == null) officerName = "";
                if (employeeCode == null) employeeCode = "";
                if (currentStatus == null) currentStatus = "UNKNOWN";
                if (riskLevel == null) riskLevel = "LOW";
                if (officerRemarks == null) officerRemarks = "";
                if (rejectionReason == null) rejectionReason = "";


                String statusClass =
                        "status-other";

                if ("DRAFT".equalsIgnoreCase(currentStatus)) {

                    statusClass = "status-draft";

                } else if ("SUBMITTED".equalsIgnoreCase(currentStatus)) {

                    statusClass = "status-submitted";

                } else if ("UNDER_REVIEW".equalsIgnoreCase(currentStatus)
                        || "DOCUMENT_VERIFIED".equalsIgnoreCase(currentStatus)
                        || "FINAL_REVIEW".equalsIgnoreCase(currentStatus)) {

                    statusClass = "status-review";

                } else if ("QUERY_RAISED".equalsIgnoreCase(currentStatus)
                        || "QUERY".equalsIgnoreCase(currentStatus)) {

                    statusClass = "status-query";

                } else if ("APPROVED".equalsIgnoreCase(currentStatus)) {

                    statusClass = "status-approved";

                } else if ("REJECTED".equalsIgnoreCase(currentStatus)) {

                    statusClass = "status-rejected";
                }


                String slaText =
                        "Not Applicable";

                String slaClass =
                        "sla-na";


                if (expectedCompletionDate != null &&
                    !"APPROVED".equalsIgnoreCase(currentStatus) &&
                    !"REJECTED".equalsIgnoreCase(currentStatus) &&
                    !"DRAFT".equalsIgnoreCase(currentStatus)) {

                    java.time.LocalDate expected =
                            expectedCompletionDate.toLocalDate();

                    long daysRemaining =
                            java.time.temporal.ChronoUnit.DAYS.between(
                                    today,
                                    expected
                            );


                    if (daysRemaining < 0) {

                        slaText =
                                "SLA Breached";

                        slaClass =
                                "sla-breached";

                    } else if (daysRemaining <= 2) {

                        slaText =
                                "Near Deadline";

                        slaClass =
                                "sla-near";

                    } else {

                        slaText =
                                "On Track";

                        slaClass =
                                "sla-ontrack";
                    }
                }
            %>


                <tr>


                    <td>

                        <div class="name">
                            <%= applicationNumber %>
                        </div>

                        <div class="small-text">
                            ID: <%= applicationId %>
                        </div>

                    </td>


                    <td>

                        <div class="name">
                            <%= entrepreneurName %>
                        </div>

                        <div class="small-text">
                            <%= entrepreneurEmail %>
                        </div>

                    </td>


                    <td>

                        <div class="name">
                            <%= businessName %>
                        </div>

                        <%
                        if (!industry.isBlank()) {
                        %>

                            <div class="small-text">

                                <span class="badge badge-blue">
                                    <%= industry %>
                                </span>

                            </div>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <div class="name">
                            <%= approvalName %>
                        </div>

                        <div class="small-text">

                            <span class="badge badge-blue">
                                <%= approvalCode %>
                            </span>

                        </div>

                    </td>


                    <td>

                        <div class="name">
                            <%= departmentName %>
                        </div>

                        <div class="small-text">
                            <%= departmentCode %>
                        </div>

                    </td>


                    <td>

                        <%
                        if (assignedOfficerId != null &&
                            !officerName.isBlank()) {
                        %>

                            <div class="name">
                                <%= officerName %>
                            </div>

                            <div class="small-text">
                                <%= employeeCode %>
                            </div>

                        <%
                        } else {
                        %>

                            <span class="badge badge-grey">
                                Not Assigned
                            </span>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <span class="status <%= statusClass %>">

                            <%= currentStatus.replace("_", " ") %>

                        </span>

                    </td>


                    <td>

                        <span class="sla <%= slaClass %>">
                            <%= slaText %>
                        </span>

                        <%
                        if (slaDays != null) {
                        %>

                            <div class="small-text">
                                SLA: <%= slaDays %> days
                            </div>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <%
                        if (expectedCompletionDate != null) {
                        %>

                            <%= expectedCompletionDate %>

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
                        if ("HIGH".equalsIgnoreCase(riskLevel)) {
                        %>

                            <span class="badge badge-red">
                                HIGH
                            </span>

                        <%
                        } else if ("MEDIUM".equalsIgnoreCase(riskLevel)) {
                        %>

                            <span class="badge badge-orange">
                                MEDIUM
                            </span>

                        <%
                        } else {
                        %>

                            <span class="badge badge-green">
                                <%= riskLevel %>
                            </span>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <%
                        if (submissionDate != null) {
                        %>

                            <%= submissionDate %>

                        <%
                        } else {
                        %>

                            <span class="small-text">
                                Not submitted
                            </span>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <button type="button"
                                class="view-btn"
                                onclick="openDetails(
                                    '<%= escapeJs(applicationNumber) %>',
                                    '<%= escapeJs(entrepreneurName) %>',
                                    '<%= escapeJs(entrepreneurEmail) %>',
                                    '<%= escapeJs(businessName) %>',
                                    '<%= escapeJs(industry) %>',
                                    '<%= escapeJs(approvalName) %>',
                                    '<%= escapeJs(approvalCode) %>',
                                    '<%= escapeJs(departmentName) %>',
                                    '<%= escapeJs(departmentCode) %>',
                                    '<%= escapeJs(officerName) %>',
                                    '<%= escapeJs(employeeCode) %>',
                                    '<%= escapeJs(currentStatus) %>',
                                    '<%= slaDays != null ? slaDays : "" %>',
                                    '<%= expectedCompletionDate != null ? expectedCompletionDate : "" %>',
                                    '<%= escapeJs(riskLevel) %>',
                                    '<%= escapeJs(String.valueOf(submissionDate != null ? submissionDate : "")) %>',
                                    '<%= escapeJs(officerRemarks) %>',
                                    '<%= escapeJs(rejectionReason) %>',
                                    '<%= canReapply != null ? canReapply : false %>',
                                    '<%= escapeJs(String.valueOf(createdAt != null ? createdAt : "")) %>',
                                    '<%= escapeJs(String.valueOf(updatedAt != null ? updatedAt : "")) %>'
                                )">

                            View

                        </button>

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


<div id="detailsModal"
     class="modal">

    <div class="modal-content">


        <div class="modal-header">

            <h2>
                Application Details
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
                    Application
                </h3>

                <div class="detail-grid">


                    <div class="detail-box">

                        <div class="detail-label">
                            Application Number
                        </div>

                        <div class="detail-value"
                             id="detailApplicationNumber">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Current Status
                        </div>

                        <div class="detail-value"
                             id="detailStatus">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Submission Date
                        </div>

                        <div class="detail-value"
                             id="detailSubmissionDate">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Expected Completion
                        </div>

                        <div class="detail-value"
                             id="detailExpectedCompletion">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            SLA Days
                        </div>

                        <div class="detail-value"
                             id="detailSlaDays">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Risk Level
                        </div>

                        <div class="detail-value"
                             id="detailRisk">
                        </div>

                    </div>


                </div>

            </div>


            <div class="detail-section">

                <h3>
                    Entrepreneur & Business
                </h3>

                <div class="detail-grid">


                    <div class="detail-box">

                        <div class="detail-label">
                            Entrepreneur
                        </div>

                        <div class="detail-value"
                             id="detailEntrepreneur">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Entrepreneur Email
                        </div>

                        <div class="detail-value"
                             id="detailEntrepreneurEmail">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Business
                        </div>

                        <div class="detail-value"
                             id="detailBusiness">
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


                </div>

            </div>


            <div class="detail-section">

                <h3>
                    Approval & Department
                </h3>

                <div class="detail-grid">


                    <div class="detail-box">

                        <div class="detail-label">
                            Approval
                        </div>

                        <div class="detail-value"
                             id="detailApproval">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Approval Code
                        </div>

                        <div class="detail-value"
                             id="detailApprovalCode">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Department
                        </div>

                        <div class="detail-value"
                             id="detailDepartment">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Department Code
                        </div>

                        <div class="detail-value"
                             id="detailDepartmentCode">
                        </div>

                    </div>


                </div>

            </div>


            <div class="detail-section">

                <h3>
                    Assigned Officer
                </h3>

                <div class="detail-grid">


                    <div class="detail-box">

                        <div class="detail-label">
                            Officer Name
                        </div>

                        <div class="detail-value"
                             id="detailOfficer">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Employee Code
                        </div>

                        <div class="detail-value"
                             id="detailEmployeeCode">
                        </div>

                    </div>


                </div>

            </div>


            <div class="detail-section">

                <h3>
                    Officer Decision Information
                </h3>

                <div class="detail-grid">


                    <div class="detail-box detail-wide">

                        <div class="detail-label">
                            Officer Remarks
                        </div>

                        <div class="detail-value"
                             id="detailOfficerRemarks">
                        </div>

                    </div>


                    <div class="detail-box detail-wide">

                        <div class="detail-label">
                            Rejection Reason
                        </div>

                        <div class="detail-value"
                             id="detailRejectionReason">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Reapply Allowed
                        </div>

                        <div class="detail-value"
                             id="detailCanReapply">
                        </div>

                    </div>


                </div>

            </div>


            <div class="detail-section">

                <h3>
                    System Information
                </h3>

                <div class="detail-grid">


                    <div class="detail-box">

                        <div class="detail-label">
                            Created At
                        </div>

                        <div class="detail-value"
                             id="detailCreatedAt">
                        </div>

                    </div>


                    <div class="detail-box">

                        <div class="detail-label">
                            Last Updated
                        </div>

                        <div class="detail-value"
                             id="detailUpdatedAt">
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

        return "Not available";
    }

    return value;
}


function openDetails(
        applicationNumber,
        entrepreneurName,
        entrepreneurEmail,
        businessName,
        industry,
        approvalName,
        approvalCode,
        departmentName,
        departmentCode,
        officerName,
        employeeCode,
        currentStatus,
        slaDays,
        expectedCompletion,
        riskLevel,
        submissionDate,
        officerRemarks,
        rejectionReason,
        canReapply,
        createdAt,
        updatedAt
) {

    document.getElementById(
        "detailApplicationNumber"
    ).textContent =
        displayValue(applicationNumber);

    document.getElementById(
        "detailStatus"
    ).textContent =
        displayValue(currentStatus)
            .replaceAll("_", " ");

    document.getElementById(
        "detailSubmissionDate"
    ).textContent =
        displayValue(submissionDate);

    document.getElementById(
        "detailExpectedCompletion"
    ).textContent =
        displayValue(expectedCompletion);

    document.getElementById(
        "detailSlaDays"
    ).textContent =
        slaDays
            ? slaDays + " days"
            : "Not configured";

    document.getElementById(
        "detailRisk"
    ).textContent =
        displayValue(riskLevel);

    document.getElementById(
        "detailEntrepreneur"
    ).textContent =
        displayValue(entrepreneurName);

    document.getElementById(
        "detailEntrepreneurEmail"
    ).textContent =
        displayValue(entrepreneurEmail);

    document.getElementById(
        "detailBusiness"
    ).textContent =
        displayValue(businessName);

    document.getElementById(
        "detailIndustry"
    ).textContent =
        displayValue(industry);

    document.getElementById(
        "detailApproval"
    ).textContent =
        displayValue(approvalName);

    document.getElementById(
        "detailApprovalCode"
    ).textContent =
        displayValue(approvalCode);

    document.getElementById(
        "detailDepartment"
    ).textContent =
        displayValue(departmentName);

    document.getElementById(
        "detailDepartmentCode"
    ).textContent =
        displayValue(departmentCode);

    document.getElementById(
        "detailOfficer"
    ).textContent =
        displayValue(officerName);

    document.getElementById(
        "detailEmployeeCode"
    ).textContent =
        displayValue(employeeCode);

    document.getElementById(
        "detailOfficerRemarks"
    ).textContent =
        displayValue(officerRemarks);

    document.getElementById(
        "detailRejectionReason"
    ).textContent =
        displayValue(rejectionReason);

    document.getElementById(
        "detailCanReapply"
    ).textContent =
        canReapply === "true"
            ? "Yes"
            : "No";

    document.getElementById(
        "detailCreatedAt"
    ).textContent =
        displayValue(createdAt);

    document.getElementById(
        "detailUpdatedAt"
    ).textContent =
        displayValue(updatedAt);


    document
        .getElementById("detailsModal")
        .classList.add("show");
}


function closeDetails() {

    document
        .getElementById("detailsModal")
        .classList.remove("show");
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