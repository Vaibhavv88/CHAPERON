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

    List<Map<String, Object>> schemes =
            (List<Map<String, Object>>) request.getAttribute("schemes");

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

<title>Government Schemes | CHAPERON</title>

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
    min-width: 1450px;
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

.department-badge {
    display: inline-block;
    padding: 6px 9px;
    border-radius: 7px;
    background: #edf5ff;
    color: #1768c7;
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

.deadline-open {
    display: inline-block;
    background: #eaf7ef;
    color: #17784d;
    padding: 6px 9px;
    border-radius: 7px;
    font-size: 11px;
    font-weight: 900;
}

.deadline-expired {
    display: inline-block;
    background: #fff0ef;
    color: #b33e37;
    padding: 6px 9px;
    border-radius: 7px;
    font-size: 11px;
    font-weight: 900;
}

.deadline-none {
    display: inline-block;
    background: #f0f2f5;
    color: #687487;
    padding: 6px 9px;
    border-radius: 7px;
    font-size: 11px;
    font-weight: 900;
}

.official-link {
    color: #1677e8;
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
    min-height: 105px;
    resize: vertical;
}

input:focus,
select:focus,
textarea:focus {
    border-color: #1677e8;
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
    .form-row {
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

    <a class="menu-item active"
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
        Government Schemes Management
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

    <div>

        <h1>
            Government Schemes
        </h1>

        <p>
            Manage government incentives, financial assistance,
            support programs and opportunities available to businesses.
        </p>

    </div>

    <button type="button"
            class="add-btn"
            onclick="openAddModal()">

        + Add Scheme

    </button>

</div>


<%
if ("added".equals(success)) {
%>

<div class="alert alert-success">
    Government scheme added successfully.
</div>

<%
} else if ("updated".equals(success)) {
%>

<div class="alert alert-success">
    Government scheme updated successfully.
</div>

<%
} else if ("status".equals(success)) {
%>

<div class="alert alert-success">
    Government scheme status updated successfully.
</div>

<%
}
%>


<%
if ("required".equals(error)) {
%>

<div class="alert alert-error">
    Scheme name is required.
</div>

<%
} else if ("invalid-department".equals(error)) {
%>

<div class="alert alert-error">
    Please select a valid active department.
</div>

<%
} else if ("invalid-deadline".equals(error)) {
%>

<div class="alert alert-error">
    Please enter a valid scheme deadline.
</div>

<%
} else if ("invalid-id".equals(error)) {
%>

<div class="alert alert-error">
    Invalid government scheme selected.
</div>

<%
} else if ("invalid-action".equals(error)) {
%>

<div class="alert alert-error">
    Invalid government scheme operation.
</div>

<%
}
%>


<%
    int totalSchemes = 0;
    int activeSchemes = 0;
    int inactiveSchemes = 0;
    int schemesWithDeadline = 0;

    if (schemes != null) {

        totalSchemes = schemes.size();

        for (Map<String, Object> scheme : schemes) {

            Boolean active =
                    (Boolean) scheme.get("active");

            Date deadline =
                    (Date) scheme.get("deadline");

            if (Boolean.TRUE.equals(active)) {
                activeSchemes++;
            } else {
                inactiveSchemes++;
            }

            if (deadline != null) {
                schemesWithDeadline++;
            }
        }
    }
%>


<div class="summary-grid">

    <div class="summary-card">

        <div class="summary-label">
            Total Schemes
        </div>

        <div class="summary-number">
            <%= totalSchemes %>
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Active Schemes
        </div>

        <div class="summary-number">
            <%= activeSchemes %>
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Schemes with Deadline
        </div>

        <div class="summary-number">
            <%= schemesWithDeadline %>
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Inactive Schemes
        </div>

        <div class="summary-number">
            <%= inactiveSchemes %>
        </div>

    </div>

</div>


<div class="table-card">

    <div class="table-header">

        <h2>
            Scheme Directory
        </h2>

        <span>
            <%= totalSchemes %> scheme(s)
        </span>

    </div>


    <div class="table-wrapper">


    <%
    if (schemes == null || schemes.isEmpty()) {
    %>

        <div class="empty-state">
            No government schemes found.
        </div>

    <%
    } else {
    %>

        <table>

            <thead>

                <tr>

                    <th>Scheme</th>
                    <th>Department</th>
                    <th>Eligibility</th>
                    <th>Benefit</th>
                    <th>Deadline</th>
                    <th>Official Information</th>
                    <th>Status</th>
                    <th>Actions</th>

                </tr>

            </thead>


            <tbody>


            <%
            java.time.LocalDate today =
                    java.time.LocalDate.now();

            for (Map<String, Object> scheme : schemes) {

                Long schemeId =
                        (Long) scheme.get("schemeId");

                Object departmentIdObject =
                        scheme.get("departmentId");

                String departmentId =
                        departmentIdObject == null
                                ? ""
                                : String.valueOf(departmentIdObject);

                String schemeName =
                        (String) scheme.get("schemeName");

                String departmentName =
                        (String) scheme.get("departmentName");

                String departmentCode =
                        (String) scheme.get("departmentCode");

                String description =
                        (String) scheme.get("description");

                String eligibility =
                        (String) scheme.get("eligibility");

                String benefit =
                        (String) scheme.get("benefit");

                Date deadline =
                        (Date) scheme.get("deadline");

                String officialInformationUrl =
                        (String) scheme.get("officialInformationUrl");

                Boolean active =
                        (Boolean) scheme.get("active");


                if (schemeName == null) schemeName = "";
                if (departmentName == null) departmentName = "";
                if (departmentCode == null) departmentCode = "";
                if (description == null) description = "";
                if (eligibility == null) eligibility = "";
                if (benefit == null) benefit = "";
                if (officialInformationUrl == null) officialInformationUrl = "";


                String deadlineValue =
                        deadline == null
                                ? ""
                                : deadline.toString();
            %>


                <tr>


                    <td>

                        <div class="name">
                            <%= schemeName %>
                        </div>

                        <%
                        if (!description.isBlank()) {
                        %>

                            <div class="small-text"
                                 style="max-width:320px;">
                                <%= description %>
                            </div>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <%
                        if (!departmentName.isBlank()) {
                        %>

                            <div class="name">
                                <%= departmentName %>
                            </div>

                            <div class="small-text">

                                <span class="department-badge">
                                    <%= departmentCode %>
                                </span>

                            </div>

                        <%
                        } else {
                        %>

                            <span class="department-badge">
                                General Scheme
                            </span>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <%
                        if (!eligibility.isBlank()) {
                        %>

                            <div style="max-width:280px;line-height:1.6;">
                                <%= eligibility %>
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
                        if (!benefit.isBlank()) {
                        %>

                            <div style="max-width:280px;line-height:1.6;">
                                <%= benefit %>
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
                        if (deadline == null) {
                        %>

                            <span class="deadline-none">
                                No Deadline
                            </span>

                        <%
                        } else {

                            boolean expired =
                                    deadline.toLocalDate()
                                            .isBefore(today);

                            if (expired) {
                        %>

                                <span class="deadline-expired">
                                    <%= deadline %>
                                </span>

                                <div class="small-text">
                                    Deadline passed
                                </div>

                        <%
                            } else {
                        %>

                                <span class="deadline-open">
                                    <%= deadline %>
                                </span>

                                <div class="small-text">
                                    Applications open / upcoming
                                </div>

                        <%
                            }
                        }
                        %>

                    </td>


                    <td>

                        <%
                        if (!officialInformationUrl.isBlank()) {
                        %>

                            <a href="<%= officialInformationUrl %>"
                               target="_blank"
                               rel="noopener noreferrer"
                               class="official-link">

                                Open Official Page ↗

                            </a>

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
                                        '<%= schemeId %>',
                                        '<%= escapeJs(departmentId) %>',
                                        '<%= escapeJs(schemeName) %>',
                                        '<%= escapeJs(description) %>',
                                        '<%= escapeJs(eligibility) %>',
                                        '<%= escapeJs(benefit) %>',
                                        '<%= escapeJs(deadlineValue) %>',
                                        '<%= escapeJs(officialInformationUrl) %>'
                                    )">

                                Edit

                            </button>


                            <form method="post"
                                  action="<%= request.getContextPath() %>/admin/schemes"
                                  onsubmit="return confirmSchemeStatus('<%= Boolean.TRUE.equals(active) ? "deactivate" : "activate" %>');">

                                <input type="hidden"
                                       name="action"
                                       value="toggle">

                                <input type="hidden"
                                       name="schemeId"
                                       value="<%= schemeId %>">


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


<!-- ================================
     ADD SCHEME MODAL
     ================================ -->

<div id="addModal"
     class="modal">

    <div class="modal-content">


        <div class="modal-header">

            <h2>
                Add Government Scheme
            </h2>

            <button type="button"
                    class="close-btn"
                    onclick="closeAddModal()">

                ×

            </button>

        </div>


        <form method="post"
              action="<%= request.getContextPath() %>/admin/schemes">

            <input type="hidden"
                   name="action"
                   value="add">


            <div class="modal-body">


                <div class="form-section-title">
                    Scheme Information
                </div>


                <div class="form-group">

                    <label>
                        Scheme Name
                        <span class="required">*</span>
                    </label>

                    <input type="text"
                           name="schemeName"
                           maxlength="250"
                           required
                           placeholder="Example: PMEGP">

                </div>


                <div class="form-group">

                    <label>
                        Responsible Department
                    </label>

                    <select name="departmentId">

                        <option value="">
                            General / Not Department Specific
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
                              placeholder="Explain the purpose of this government scheme"></textarea>

                </div>


                <div class="form-section-title">
                    Eligibility & Benefit
                </div>


                <div class="form-group">

                    <label>
                        Eligibility
                    </label>

                    <textarea name="eligibility"
                              placeholder="Example: New micro and small enterprises meeting applicable eligibility requirements"></textarea>

                </div>


                <div class="form-group">

                    <label>
                        Benefit
                    </label>

                    <textarea name="benefit"
                              placeholder="Example: Credit-linked subsidy / financial assistance"></textarea>

                </div>


                <div class="form-section-title">
                    Application Information
                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Deadline
                        </label>

                        <input type="date"
                               name="deadline">

                        <div class="field-help">
                            Leave blank if the scheme does not have a fixed deadline.
                        </div>

                    </div>


                    <div class="form-group">

                        <label>
                            Official Information URL
                        </label>

                        <input type="url"
                               name="officialInformationUrl"
                               maxlength="500"
                               placeholder="https://official.gov.in/...">

                    </div>

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

                    Add Scheme

                </button>

            </div>


        </form>

    </div>

</div>


<!-- ================================
     EDIT SCHEME MODAL
     ================================ -->

<div id="editModal"
     class="modal">

    <div class="modal-content">


        <div class="modal-header">

            <h2>
                Edit Government Scheme
            </h2>

            <button type="button"
                    class="close-btn"
                    onclick="closeEditModal()">

                ×

            </button>

        </div>


        <form method="post"
              action="<%= request.getContextPath() %>/admin/schemes">

            <input type="hidden"
                   name="action"
                   value="update">

            <input type="hidden"
                   id="editSchemeId"
                   name="schemeId">


            <div class="modal-body">


                <div class="form-section-title">
                    Scheme Information
                </div>


                <div class="form-group">

                    <label>
                        Scheme Name
                        <span class="required">*</span>
                    </label>

                    <input type="text"
                           id="editSchemeName"
                           name="schemeName"
                           maxlength="250"
                           required>

                </div>


                <div class="form-group">

                    <label>
                        Responsible Department
                    </label>

                    <select id="editDepartmentId"
                            name="departmentId">

                        <option value="">
                            General / Not Department Specific
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
                    Eligibility & Benefit
                </div>


                <div class="form-group">

                    <label>
                        Eligibility
                    </label>

                    <textarea id="editEligibility"
                              name="eligibility"></textarea>

                </div>


                <div class="form-group">

                    <label>
                        Benefit
                    </label>

                    <textarea id="editBenefit"
                              name="benefit"></textarea>

                </div>


                <div class="form-section-title">
                    Application Information
                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Deadline
                        </label>

                        <input type="date"
                               id="editDeadline"
                               name="deadline">

                    </div>


                    <div class="form-group">

                        <label>
                            Official Information URL
                        </label>

                        <input type="url"
                               id="editOfficialInformationUrl"
                               name="officialInformationUrl"
                               maxlength="500">

                    </div>

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
}


function closeAddModal() {

    document
        .getElementById("addModal")
        .classList.remove("show");
}


function openEditModal(
        schemeId,
        departmentId,
        schemeName,
        description,
        eligibility,
        benefit,
        deadline,
        officialInformationUrl
) {

    document.getElementById(
        "editSchemeId"
    ).value = schemeId;

    document.getElementById(
        "editDepartmentId"
    ).value = departmentId;

    document.getElementById(
        "editSchemeName"
    ).value = schemeName;

    document.getElementById(
        "editDescription"
    ).value = description;

    document.getElementById(
        "editEligibility"
    ).value = eligibility;

    document.getElementById(
        "editBenefit"
    ).value = benefit;

    document.getElementById(
        "editDeadline"
    ).value = deadline;

    document.getElementById(
        "editOfficialInformationUrl"
    ).value = officialInformationUrl;


    document
        .getElementById("editModal")
        .classList.add("show");
}


function closeEditModal() {

    document
        .getElementById("editModal")
        .classList.remove("show");
}


function confirmSchemeStatus(action) {

    return confirm(
        "Are you sure you want to "
        + action
        + " this government scheme?"
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