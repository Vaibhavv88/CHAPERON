<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    String userName = (String) session.getAttribute("userName");

    if (userName == null || userName.isBlank()) {
        userName = "Administrator";
    }

    List<Map<String, Object>> approvals =
            (List<Map<String, Object>>) request.getAttribute("approvals");

    List<Map<String, Object>> departments =
            (List<Map<String, Object>>) request.getAttribute("departments");

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Approval Master | CHAPERON</title>

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

button,
input,
select,
textarea {
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
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 20px;
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

.add-btn {
    border: none;
    background: #1677e8;
    color: white;
    padding: 13px 18px;
    border-radius: 10px;
    cursor: pointer;
    font-weight: 800;
}


/* =========================
   ALERT
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
    min-width: 1500px;
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

.code-badge {
    display: inline-block;
    padding: 6px 9px;
    background: #edf5ff;
    color: #1768c7;
    border-radius: 7px;
    font-size: 11px;
    font-weight: 900;
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
    background: #f1f3f6;
    color: #687487;
}

.yes-badge {
    display: inline-block;
    background: #fff4dd;
    color: #a66800;
    padding: 5px 8px;
    border-radius: 7px;
    font-size: 11px;
    font-weight: 800;
}

.no-badge {
    display: inline-block;
    background: #f0f2f5;
    color: #687487;
    padding: 5px 8px;
    border-radius: 7px;
    font-size: 11px;
    font-weight: 800;
}

.action-group {
    display: flex;
    gap: 7px;
    align-items: center;
}

.edit-btn {
    border: 1px solid #cbd7e5;
    background: white;
    color: #31506f;
    padding: 8px 11px;
    border-radius: 7px;
    cursor: pointer;
    font-size: 12px;
    font-weight: 800;
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
    max-width: 820px;
    max-height: 94vh;
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

.form-section-title {
    font-size: 14px;
    font-weight: 900;
    margin: 6px 0 15px;
    padding-bottom: 8px;
    border-bottom: 1px solid #edf0f4;
}

.form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
}

.form-row-three {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16px;
}

.form-group {
    margin-bottom: 17px;
}

label {
    display: block;
    font-size: 13px;
    font-weight: 800;
    margin-bottom: 8px;
}

.required {
    color: #d94747;
}

input,
select,
textarea {
    width: 100%;
    border: 1px solid #d6dee8;
    border-radius: 9px;
    padding: 12px 13px;
    font-size: 14px;
    outline: none;
}

textarea {
    min-height: 95px;
    resize: vertical;
}

input:focus,
select:focus,
textarea:focus {
    border-color: #1677e8;
}

.checkbox-row {
    display: flex;
    gap: 25px;
    flex-wrap: wrap;
    margin: 8px 0 18px;
}

.checkbox-item {
    display: flex;
    gap: 8px;
    align-items: center;
    font-size: 13px;
    font-weight: 800;
}

.checkbox-item input {
    width: auto;
}

.field-help {
    margin-top: 5px;
    color: #8290a3;
    font-size: 11px;
}

.modal-footer {
    padding: 18px 24px;
    border-top: 1px solid #e6eaf0;
    display: flex;
    justify-content: flex-end;
    gap: 10px;
}

.cancel-btn {
    border: 1px solid #d4dde8;
    background: white;
    padding: 11px 17px;
    border-radius: 9px;
    font-weight: 800;
    cursor: pointer;
}

.save-btn {
    border: none;
    background: #1677e8;
    color: white;
    padding: 11px 18px;
    border-radius: 9px;
    font-weight: 800;
    cursor: pointer;
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

    .page-header {
        display: block;
    }

    .add-btn {
        width: 100%;
        margin-top: 16px;
    }

    .summary-grid,
    .form-row,
    .form-row-three {
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

    <div class="menu-title">OVERVIEW</div>

    <a class="menu-item"
       href="<%= request.getContextPath() %>/admin/dashboard">

        <span class="menu-icon">▦</span>
        Dashboard

    </a>

    <div class="menu-title">MANAGEMENT</div>

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

    <a class="menu-item active"
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

    <div class="menu-title">MONITORING</div>

    <a class="menu-item"
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
        Approval Master Management
    </div>

    <div class="admin-info">

        <div class="avatar">A</div>

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

    <div>

        <h1>
            Approval Master
        </h1>

        <p>
            Configure approval timelines, validity,
            renewals, inspections and department ownership.
        </p>

    </div>

    <button type="button"
            class="add-btn"
            onclick="openAddModal()">

        + Add Approval

    </button>

</div>


<%
if ("added".equals(success)) {
%>

<div class="alert alert-success">
    Approval added successfully.
</div>

<%
} else if ("updated".equals(success)) {
%>

<div class="alert alert-success">
    Approval updated successfully.
</div>

<%
} else if ("status".equals(success)) {
%>

<div class="alert alert-success">
    Approval status updated successfully.
</div>

<%
}
%>


<%
if ("required".equals(error)) {
%>

<div class="alert alert-error">
    Approval name and approval code are required.
</div>

<%
} else if ("duplicate-code".equals(error)) {
%>

<div class="alert alert-error">
    This approval code already exists.
</div>

<%
} else if ("invalid-department".equals(error)) {
%>

<div class="alert alert-error">
    Please select a valid active department.
</div>

<%
} else if ("invalid-number".equals(error)) {
%>

<div class="alert alert-error">
    Processing, SLA, validity and renewal values must be valid non-negative numbers.
</div>

<%
} else if ("processing-range".equals(error)) {
%>

<div class="alert alert-error">
    Minimum processing days cannot exceed maximum processing days.
</div>

<%
} else if ("invalid-validity".equals(error)) {
%>

<div class="alert alert-error">
    Invalid approval validity type.
</div>

<%
} else if ("validity-value".equals(error)) {
%>

<div class="alert alert-error">
    Please enter a positive validity value for DAYS, MONTHS or YEARS.
</div>

<%
} else if ("invalid-id".equals(error)) {
%>

<div class="alert alert-error">
    Invalid approval selected.
</div>

<%
} else if ("invalid-action".equals(error)) {
%>

<div class="alert alert-error">
    Invalid approval operation.
</div>

<%
}
%>


<%
    int totalApprovals = 0;
    int activeApprovals = 0;
    int renewalApprovals = 0;
    int inspectionApprovals = 0;

    if (approvals != null) {

        totalApprovals = approvals.size();

        for (Map<String, Object> approval : approvals) {

            if (Boolean.TRUE.equals(
                    (Boolean) approval.get("active"))) {
                activeApprovals++;
            }

            if (Boolean.TRUE.equals(
                    (Boolean) approval.get("renewalRequired"))) {
                renewalApprovals++;
            }

            if (Boolean.TRUE.equals(
                    (Boolean) approval.get("inspectionRequired"))) {
                inspectionApprovals++;
            }
        }
    }
%>


<div class="summary-grid">

    <div class="summary-card">
        <div class="summary-label">
            Total Approvals
        </div>
        <div class="summary-number">
            <%= totalApprovals %>
        </div>
    </div>

    <div class="summary-card">
        <div class="summary-label">
            Active Approvals
        </div>
        <div class="summary-number">
            <%= activeApprovals %>
        </div>
    </div>

    <div class="summary-card">
        <div class="summary-label">
            Renewal Required
        </div>
        <div class="summary-number">
            <%= renewalApprovals %>
        </div>
    </div>

    <div class="summary-card">
        <div class="summary-label">
            Inspection Required
        </div>
        <div class="summary-number">
            <%= inspectionApprovals %>
        </div>
    </div>

</div>


<div class="table-card">

    <div class="table-header">

        <h2>
            Approval Directory
        </h2>

        <span>
            <%= totalApprovals %> approval(s)
        </span>

    </div>

    <div class="table-wrapper">


    <%
    if (approvals == null || approvals.isEmpty()) {
    %>

        <div class="empty-state">
            No approvals found.
        </div>

    <%
    } else {
    %>

        <table>

            <thead>

                <tr>
                    <th>Approval</th>
                    <th>Department</th>
                    <th>Processing</th>
                    <th>SLA</th>
                    <th>Validity</th>
                    <th>Renewal</th>
                    <th>Inspection</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>

            </thead>

            <tbody>


            <%
            for (Map<String, Object> approval : approvals) {

                Long approvalId =
                        (Long) approval.get("approvalId");

                Long departmentId =
                        (Long) approval.get("departmentId");

                String approvalName =
                        (String) approval.get("approvalName");

                String approvalCode =
                        (String) approval.get("approvalCode");

                String departmentName =
                        (String) approval.get("departmentName");

                String departmentCode =
                        (String) approval.get("departmentCode");

                String description =
                        (String) approval.get("description");

                Integer minimumProcessingDays =
                        (Integer) approval.get("minimumProcessingDays");

                Integer maximumProcessingDays =
                        (Integer) approval.get("maximumProcessingDays");

                Integer slaDays =
                        (Integer) approval.get("slaDays");

                String validityType =
                        (String) approval.get("validityType");

                Integer validityValue =
                        (Integer) approval.get("validityValue");

                Boolean renewalRequired =
                        (Boolean) approval.get("renewalRequired");

                Integer renewalBeforeDays =
                        (Integer) approval.get("renewalBeforeDays");

                Boolean inspectionRequired =
                        (Boolean) approval.get("inspectionRequired");

                String officialReferenceUrl =
                        (String) approval.get("officialReferenceUrl");

                Boolean active =
                        (Boolean) approval.get("active");


                if (description == null) description = "";
                if (validityType == null) validityType = "";
                if (officialReferenceUrl == null) officialReferenceUrl = "";
            %>


                <tr>

                    <td>

                        <div class="name">
                            <%= approvalName %>
                        </div>

                        <div class="small-text">
                            <span class="code-badge">
                                <%= approvalCode %>
                            </span>
                        </div>

                        <%
                        if (!description.isBlank()) {
                        %>

                        <div class="small-text">
                            <%= description %>
                        </div>

                        <%
                        }
                        %>

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
                        if (minimumProcessingDays != null
                                || maximumProcessingDays != null) {
                        %>

                            <%= minimumProcessingDays != null
                                    ? minimumProcessingDays
                                    : "-" %>

                            -

                            <%= maximumProcessingDays != null
                                    ? maximumProcessingDays
                                    : "-" %>

                            days

                        <%
                        } else {
                        %>

                            -

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <%= slaDays != null
                                ? slaDays + " days"
                                : "-" %>

                    </td>


                    <td>

                        <%
                        if ("PERMANENT".equals(validityType)) {
                        %>

                            Permanent

                        <%
                        } else if ("UNTIL_CONDITION_CHANGES".equals(validityType)) {
                        %>

                            Until condition changes

                        <%
                        } else if (!validityType.isBlank()) {
                        %>

                            <%= validityValue != null
                                    ? validityValue
                                    : "-" %>
                            <%= validityType %>

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
                        if (Boolean.TRUE.equals(renewalRequired)) {
                        %>

                            <span class="yes-badge">
                                YES
                            </span>

                            <div class="small-text">

                                <%= renewalBeforeDays != null
                                        ? renewalBeforeDays + " days before"
                                        : "Reminder not set" %>

                            </div>

                        <%
                        } else {
                        %>

                            <span class="no-badge">
                                NO
                            </span>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <%
                        if (Boolean.TRUE.equals(inspectionRequired)) {
                        %>

                            <span class="yes-badge">
                                REQUIRED
                            </span>

                        <%
                        } else {
                        %>

                            <span class="no-badge">
                                NOT REQUIRED
                            </span>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <%
                        if (Boolean.TRUE.equals(active)) {
                        %>

                            <span class="status status-active">
                                ACTIVE
                            </span>

                        <%
                        } else {
                        %>

                            <span class="status status-inactive">
                                INACTIVE
                            </span>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <div class="action-group">


                            <button type="button"
                                    class="edit-btn"
                                    onclick="openEditModal(
                                        '<%= approvalId %>',
                                        '<%= departmentId %>',
                                        '<%= escapeJs(approvalName) %>',
                                        '<%= escapeJs(approvalCode) %>',
                                        '<%= escapeJs(description) %>',
                                        '<%= minimumProcessingDays != null ? minimumProcessingDays : "" %>',
                                        '<%= maximumProcessingDays != null ? maximumProcessingDays : "" %>',
                                        '<%= slaDays != null ? slaDays : "" %>',
                                        '<%= escapeJs(validityType) %>',
                                        '<%= validityValue != null ? validityValue : "" %>',
                                        '<%= Boolean.TRUE.equals(renewalRequired) %>',
                                        '<%= renewalBeforeDays != null ? renewalBeforeDays : "" %>',
                                        '<%= Boolean.TRUE.equals(inspectionRequired) %>',
                                        '<%= escapeJs(officialReferenceUrl) %>'
                                    )">

                                Edit

                            </button>


                            <form method="post"
                                  action="<%= request.getContextPath() %>/admin/approvals"
                                  onsubmit="return confirmApprovalStatus('<%= Boolean.TRUE.equals(active) ? "deactivate" : "activate" %>');">

                                <input type="hidden"
                                       name="action"
                                       value="toggle">

                                <input type="hidden"
                                       name="approvalId"
                                       value="<%= approvalId %>">


                                <%
                                if (Boolean.TRUE.equals(active)) {
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
     ADD MODAL
     ========================= -->

<div id="addModal"
     class="modal">

    <div class="modal-content">

        <div class="modal-header">

            <h2>
                Add Approval
            </h2>

            <button type="button"
                    class="close-btn"
                    onclick="closeAddModal()">
                ×
            </button>

        </div>


        <form method="post"
              action="<%= request.getContextPath() %>/admin/approvals">

            <input type="hidden"
                   name="action"
                   value="add">


            <div class="modal-body">


                <div class="form-section-title">
                    Basic Information
                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Approval Name
                            <span class="required">*</span>
                        </label>

                        <input type="text"
                               name="approvalName"
                               maxlength="200"
                               required
                               placeholder="Example: Fire NOC">

                    </div>


                    <div class="form-group">

                        <label>
                            Approval Code
                            <span class="required">*</span>
                        </label>

                        <input type="text"
                               name="approvalCode"
                               maxlength="50"
                               required
                               placeholder="Example: FIRE_NOC">

                    </div>

                </div>


                <div class="form-group">

                    <label>
                        Department
                        <span class="required">*</span>
                    </label>

                    <select name="departmentId"
                            required>

                        <option value="">
                            Select Department
                        </option>

                        <%
                        if (departments != null) {

                            for (Map<String, Object> department : departments) {
                        %>

                            <option value="<%= department.get("departmentId") %>">

                                <%= department.get("departmentName") %>
                                (<%= department.get("departmentCode") %>)

                            </option>

                        <%
                            }
                        }
                        %>

                    </select>

                </div>


                <div class="form-group">

                    <label>
                        Description
                    </label>

                    <textarea name="description"
                              placeholder="Explain what this approval is for"></textarea>

                </div>


                <div class="form-section-title">
                    Processing & SLA
                </div>


                <div class="form-row-three">

                    <div class="form-group">

                        <label>
                            Minimum Processing Days
                        </label>

                        <input type="number"
                               min="0"
                               name="minimumProcessingDays"
                               placeholder="7">

                    </div>

                    <div class="form-group">

                        <label>
                            Maximum Processing Days
                        </label>

                        <input type="number"
                               min="0"
                               name="maximumProcessingDays"
                               placeholder="15">

                    </div>

                    <div class="form-group">

                        <label>
                            SLA Days
                        </label>

                        <input type="number"
                               min="0"
                               name="slaDays"
                               placeholder="15">

                    </div>

                </div>


                <div class="form-section-title">
                    Validity & Renewal
                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Validity Type
                        </label>

                        <select name="validityType"
                                id="addValidityType"
                                onchange="handleValidityType('add')">

                            <option value="">
                                Not Specified
                            </option>

                            <option value="DAYS">
                                Days
                            </option>

                            <option value="MONTHS">
                                Months
                            </option>

                            <option value="YEARS">
                                Years
                            </option>

                            <option value="PERMANENT">
                                Permanent
                            </option>

                            <option value="UNTIL_CONDITION_CHANGES">
                                Until Condition Changes
                            </option>

                        </select>

                    </div>


                    <div class="form-group">

                        <label>
                            Validity Value
                        </label>

                        <input type="number"
                               min="1"
                               id="addValidityValue"
                               name="validityValue"
                               placeholder="Example: 1">

                    </div>

                </div>


                <div class="checkbox-row">

                    <label class="checkbox-item">

                        <input type="checkbox"
                               id="addRenewalRequired"
                               name="renewalRequired"
                               onchange="handleRenewal('add')">

                        Renewal Required

                    </label>


                    <label class="checkbox-item">

                        <input type="checkbox"
                               name="inspectionRequired">

                        Inspection Required

                    </label>

                </div>


                <div class="form-group">

                    <label>
                        Renewal Reminder Before Days
                    </label>

                    <input type="number"
                           min="0"
                           id="addRenewalBeforeDays"
                           name="renewalBeforeDays"
                           disabled
                           placeholder="Example: 30">

                    <div class="field-help">
                        Enabled only when renewal is required.
                    </div>

                </div>


                <div class="form-section-title">
                    Official Reference
                </div>


                <div class="form-group">

                    <label>
                        Official Reference URL
                    </label>

                    <input type="url"
                           name="officialReferenceUrl"
                           maxlength="500"
                           placeholder="https://official-government-website...">

                </div>


            </div>


            <div class="modal-footer">

                <button type="button"
                        class="cancel-btn"
                        onclick="closeAddModal()">

                    Cancel

                </button>

                <button type="submit"
                        class="save-btn">

                    Add Approval

                </button>

            </div>

        </form>

    </div>

</div>


<!-- =========================
     EDIT MODAL
     ========================= -->

<div id="editModal"
     class="modal">

    <div class="modal-content">

        <div class="modal-header">

            <h2>
                Edit Approval
            </h2>

            <button type="button"
                    class="close-btn"
                    onclick="closeEditModal()">
                ×
            </button>

        </div>


        <form method="post"
              action="<%= request.getContextPath() %>/admin/approvals">

            <input type="hidden"
                   name="action"
                   value="update">

            <input type="hidden"
                   id="editApprovalId"
                   name="approvalId">


            <div class="modal-body">


                <div class="form-section-title">
                    Basic Information
                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Approval Name
                            <span class="required">*</span>
                        </label>

                        <input type="text"
                               id="editApprovalName"
                               name="approvalName"
                               maxlength="200"
                               required>

                    </div>


                    <div class="form-group">

                        <label>
                            Approval Code
                            <span class="required">*</span>
                        </label>

                        <input type="text"
                               id="editApprovalCode"
                               name="approvalCode"
                               maxlength="50"
                               required>

                    </div>

                </div>


                <div class="form-group">

                    <label>
                        Department
                        <span class="required">*</span>
                    </label>

                    <select id="editDepartmentId"
                            name="departmentId"
                            required>

                        <option value="">
                            Select Department
                        </option>

                        <%
                        if (departments != null) {

                            for (Map<String, Object> department : departments) {
                        %>

                            <option value="<%= department.get("departmentId") %>">

                                <%= department.get("departmentName") %>
                                (<%= department.get("departmentCode") %>)

                            </option>

                        <%
                            }
                        }
                        %>

                    </select>

                </div>


                <div class="form-group">

                    <label>
                        Description
                    </label>

                    <textarea id="editDescription"
                              name="description"></textarea>

                </div>


                <div class="form-section-title">
                    Processing & SLA
                </div>


                <div class="form-row-three">

                    <div class="form-group">

                        <label>
                            Minimum Processing Days
                        </label>

                        <input type="number"
                               min="0"
                               id="editMinimumProcessingDays"
                               name="minimumProcessingDays">

                    </div>

                    <div class="form-group">

                        <label>
                            Maximum Processing Days
                        </label>

                        <input type="number"
                               min="0"
                               id="editMaximumProcessingDays"
                               name="maximumProcessingDays">

                    </div>

                    <div class="form-group">

                        <label>
                            SLA Days
                        </label>

                        <input type="number"
                               min="0"
                               id="editSlaDays"
                               name="slaDays">

                    </div>

                </div>


                <div class="form-section-title">
                    Validity & Renewal
                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Validity Type
                        </label>

                        <select id="editValidityType"
                                name="validityType"
                                onchange="handleValidityType('edit')">

                            <option value="">
                                Not Specified
                            </option>

                            <option value="DAYS">
                                Days
                            </option>

                            <option value="MONTHS">
                                Months
                            </option>

                            <option value="YEARS">
                                Years
                            </option>

                            <option value="PERMANENT">
                                Permanent
                            </option>

                            <option value="UNTIL_CONDITION_CHANGES">
                                Until Condition Changes
                            </option>

                        </select>

                    </div>


                    <div class="form-group">

                        <label>
                            Validity Value
                        </label>

                        <input type="number"
                               min="1"
                               id="editValidityValue"
                               name="validityValue">

                    </div>

                </div>


                <div class="checkbox-row">

                    <label class="checkbox-item">

                        <input type="checkbox"
                               id="editRenewalRequired"
                               name="renewalRequired"
                               onchange="handleRenewal('edit')">

                        Renewal Required

                    </label>


                    <label class="checkbox-item">

                        <input type="checkbox"
                               id="editInspectionRequired"
                               name="inspectionRequired">

                        Inspection Required

                    </label>

                </div>


                <div class="form-group">

                    <label>
                        Renewal Reminder Before Days
                    </label>

                    <input type="number"
                           min="0"
                           id="editRenewalBeforeDays"
                           name="renewalBeforeDays">

                </div>


                <div class="form-section-title">
                    Official Reference
                </div>


                <div class="form-group">

                    <label>
                        Official Reference URL
                    </label>

                    <input type="url"
                           id="editOfficialReferenceUrl"
                           name="officialReferenceUrl"
                           maxlength="500">

                </div>


            </div>


            <div class="modal-footer">

                <button type="button"
                        class="cancel-btn"
                        onclick="closeEditModal()">

                    Cancel

                </button>

                <button type="submit"
                        class="save-btn">

                    Save Changes

                </button>

            </div>

        </form>

    </div>

</div>


<script>

function openAddModal() {

    document
        .getElementById("addModal")
        .classList.add("show");

    handleValidityType("add");
    handleRenewal("add");
}


function closeAddModal() {

    document
        .getElementById("addModal")
        .classList.remove("show");
}


function openEditModal(
        approvalId,
        departmentId,
        approvalName,
        approvalCode,
        description,
        minimumProcessingDays,
        maximumProcessingDays,
        slaDays,
        validityType,
        validityValue,
        renewalRequired,
        renewalBeforeDays,
        inspectionRequired,
        officialReferenceUrl
) {

    document.getElementById(
        "editApprovalId"
    ).value = approvalId;

    document.getElementById(
        "editDepartmentId"
    ).value = departmentId;

    document.getElementById(
        "editApprovalName"
    ).value = approvalName;

    document.getElementById(
        "editApprovalCode"
    ).value = approvalCode;

    document.getElementById(
        "editDescription"
    ).value = description;

    document.getElementById(
        "editMinimumProcessingDays"
    ).value = minimumProcessingDays;

    document.getElementById(
        "editMaximumProcessingDays"
    ).value = maximumProcessingDays;

    document.getElementById(
        "editSlaDays"
    ).value = slaDays;

    document.getElementById(
        "editValidityType"
    ).value = validityType;

    document.getElementById(
        "editValidityValue"
    ).value = validityValue;

    document.getElementById(
        "editRenewalRequired"
    ).checked =
        renewalRequired === "true";

    document.getElementById(
        "editRenewalBeforeDays"
    ).value = renewalBeforeDays;

    document.getElementById(
        "editInspectionRequired"
    ).checked =
        inspectionRequired === "true";

    document.getElementById(
        "editOfficialReferenceUrl"
    ).value = officialReferenceUrl;


    handleValidityType("edit");
    handleRenewal("edit");


    document
        .getElementById("editModal")
        .classList.add("show");
}


function closeEditModal() {

    document
        .getElementById("editModal")
        .classList.remove("show");
}


function handleValidityType(mode) {

    const type =
        document.getElementById(
            mode + "ValidityType"
        ).value;

    const valueInput =
        document.getElementById(
            mode + "ValidityValue"
        );

    if (
        type === "PERMANENT" ||
        type === "UNTIL_CONDITION_CHANGES" ||
        type === ""
    ) {

        valueInput.disabled = true;

        if (
            type === "PERMANENT" ||
            type === "UNTIL_CONDITION_CHANGES"
        ) {
            valueInput.value = "";
        }

    } else {

        valueInput.disabled = false;
    }
}


function handleRenewal(mode) {

    const checkbox =
        document.getElementById(
            mode + "RenewalRequired"
        );

    const days =
        document.getElementById(
            mode + "RenewalBeforeDays"
        );

    days.disabled =
        !checkbox.checked;

    if (!checkbox.checked) {
        days.value = "";
    }
}


function confirmApprovalStatus(action) {

    return confirm(
        "Are you sure you want to "
        + action
        + " this approval?"
    );
}


window.onclick = function(event) {

    const addModal =
        document.getElementById("addModal");

    const editModal =
        document.getElementById("editModal");

    if (event.target === addModal) {
        closeAddModal();
    }

    if (event.target === editModal) {
        closeEditModal();
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