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

    List<Map<String, Object>> officers =
            (List<Map<String, Object>>) request.getAttribute("officers");

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

<title>Officer Management | CHAPERON</title>

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
select {
    font-family: inherit;
}


/* =====================================
   LAYOUT
   ===================================== */

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


/* =====================================
   MAIN
   ===================================== */

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


/* =====================================
   HEADER
   ===================================== */

.page-header {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
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

.add-btn:hover {
    background: #0f67c8;
}


/* =====================================
   ALERTS
   ===================================== */

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


/* =====================================
   SUMMARY
   ===================================== */

.summary-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
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


/* =====================================
   TABLE
   ===================================== */

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
    min-width: 1200px;
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
}

.code-badge {
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


/* =====================================
   MODAL
   ===================================== */

.modal {
    display: none;
    position: fixed;
    z-index: 100;
    inset: 0;
    background: rgba(16,35,63,0.55);
    align-items: center;
    justify-content: center;
    padding: 20px;
}

.modal.show {
    display: flex;
}

.modal-content {
    background: white;
    width: 100%;
    max-width: 700px;
    max-height: 92vh;
    overflow-y: auto;
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
select {
    width: 100%;
    padding: 12px 13px;
    border: 1px solid #d6dee8;
    border-radius: 9px;
    font-size: 14px;
    outline: none;
}

input:focus,
select:focus {
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


/* =====================================
   RESPONSIVE
   ===================================== */

@media (max-width: 900px) {

    .sidebar {
        display: none;
    }

    .main {
        margin-left: 0;
        width: 100%;
    }

    .summary-grid {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 650px) {

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
        margin-top: 16px;
        width: 100%;
    }

    .form-row {
        grid-template-columns: 1fr;
        gap: 0;
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

    <a class="menu-item active"
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
        Officer Management
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
            Government Officers
        </h1>

        <p>
            Create officer accounts, assign departments,
            maintain officer profiles and control access.
        </p>

    </div>

    <button class="add-btn"
            type="button"
            onclick="openAddModal()">

        + Add Officer

    </button>

</div>


<%
if ("added".equals(success)) {
%>

<div class="alert alert-success">
    Officer created successfully.
</div>

<%
} else if ("updated".equals(success)) {
%>

<div class="alert alert-success">
    Officer details updated successfully.
</div>

<%
} else if ("status".equals(success)) {
%>

<div class="alert alert-success">
    Officer account status updated successfully.
</div>

<%
}
%>


<%
if ("required".equals(error)) {
%>

<div class="alert alert-error">
    Please fill all required officer fields.
</div>

<%
} else if ("duplicate-email".equals(error)) {
%>

<div class="alert alert-error">
    This email address already belongs to another account.
</div>

<%
} else if ("duplicate-code".equals(error)) {
%>

<div class="alert alert-error">
    This employee code already exists.
</div>

<%
} else if ("invalid-department".equals(error)) {
%>

<div class="alert alert-error">
    Please select a valid active department.
</div>

<%
} else if ("invalid-id".equals(error)) {
%>

<div class="alert alert-error">
    Invalid officer selected.
</div>

<%
} else if ("invalid-action".equals(error)) {
%>

<div class="alert alert-error">
    Invalid officer operation.
</div>

<%
}
%>


<%
    int totalOfficers = 0;
    int activeOfficers = 0;
    int inactiveOfficers = 0;

    if (officers != null) {

        totalOfficers = officers.size();

        for (Map<String, Object> officer : officers) {

            Boolean active =
                    (Boolean) officer.get("active");

            if (Boolean.TRUE.equals(active)) {
                activeOfficers++;
            } else {
                inactiveOfficers++;
            }
        }
    }
%>


<div class="summary-grid">

    <div class="summary-card">

        <div class="summary-label">
            Total Officers
        </div>

        <div class="summary-number">
            <%= totalOfficers %>
        </div>

    </div>

    <div class="summary-card">

        <div class="summary-label">
            Active Officers
        </div>

        <div class="summary-number">
            <%= activeOfficers %>
        </div>

    </div>

    <div class="summary-card">

        <div class="summary-label">
            Inactive Officers
        </div>

        <div class="summary-number">
            <%= inactiveOfficers %>
        </div>

    </div>

</div>


<div class="table-card">

    <div class="table-header">

        <h2>
            Officer Directory
        </h2>

        <span>
            <%= totalOfficers %> officer(s)
        </span>

    </div>


    <div class="table-wrapper">


    <%
    if (officers == null || officers.isEmpty()) {
    %>

        <div class="empty-state">
            No officer accounts found.
        </div>

    <%
    } else {
    %>

        <table>

            <thead>

                <tr>

                    <th>Officer</th>

                    <th>Employee Code</th>

                    <th>Department</th>

                    <th>Designation</th>

                    <th>Contact</th>

                    <th>Status</th>

                    <th>Actions</th>

                </tr>

            </thead>

            <tbody>


            <%
            for (Map<String, Object> officer : officers) {

                Long officerProfileId =
                        (Long) officer.get("officerProfileId");

                Long userId =
                        (Long) officer.get("userId");

                Long departmentId =
                        (Long) officer.get("departmentId");

                String fullName =
                        (String) officer.get("fullName");

                String email =
                        (String) officer.get("email");

                String mobile =
                        (String) officer.get("mobile");

                String designation =
                        (String) officer.get("designation");

                String employeeCode =
                        (String) officer.get("employeeCode");

                String departmentName =
                        (String) officer.get("departmentName");

                String departmentCode =
                        (String) officer.get("departmentCode");

                String accountStatus =
                        (String) officer.get("accountStatus");

                Boolean active =
                        (Boolean) officer.get("active");


                if (mobile == null) mobile = "";
                if (designation == null) designation = "";
                if (employeeCode == null) employeeCode = "";
            %>


                <tr>

                    <td>

                        <div class="name">
                            <%= fullName %>
                        </div>

                        <div class="small-text">
                            <%= email %>
                        </div>

                    </td>


                    <td>

                        <span class="code-badge">
                            <%= employeeCode %>
                        </span>

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
                        if (!designation.isBlank()) {
                        %>

                        <%= designation %>

                        <%
                        } else {
                        %>

                        <span class="small-text">
                            Not specified
                        </span>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <div>
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
                        if (Boolean.TRUE.equals(active)
                                && "ACTIVE".equalsIgnoreCase(accountStatus)) {
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
                                        '<%= officerProfileId %>',
                                        '<%= userId %>',
                                        '<%= departmentId %>',
                                        '<%= escapeJs(fullName) %>',
                                        '<%= escapeJs(email) %>',
                                        '<%= escapeJs(mobile) %>',
                                        '<%= escapeJs(designation) %>',
                                        '<%= escapeJs(employeeCode) %>'
                                    )">

                                Edit

                            </button>


                            <form method="post"
                                  action="<%= request.getContextPath() %>/admin/officers"
                                  onsubmit="return confirmOfficerStatus('<%= Boolean.TRUE.equals(active) ? "deactivate" : "activate" %>');">

                                <input type="hidden"
                                       name="action"
                                       value="toggle">

                                <input type="hidden"
                                       name="officerProfileId"
                                       value="<%= officerProfileId %>">

                                <input type="hidden"
                                       name="userId"
                                       value="<%= userId %>">


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


<!-- =====================================
     ADD OFFICER MODAL
     ===================================== -->

<div id="addModal"
     class="modal">

    <div class="modal-content">


        <div class="modal-header">

            <h2>
                Add Government Officer
            </h2>

            <button type="button"
                    class="close-btn"
                    onclick="closeAddModal()">

                ×

            </button>

        </div>


        <form method="post"
              action="<%= request.getContextPath() %>/admin/officers">

            <input type="hidden"
                   name="action"
                   value="add">


            <div class="modal-body">


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Full Name
                            <span class="required">*</span>
                        </label>

                        <input type="text"
                               name="fullName"
                               required
                               maxlength="100"
                               placeholder="Officer full name">

                    </div>


                    <div class="form-group">

                        <label>
                            Email
                            <span class="required">*</span>
                        </label>

                        <input type="email"
                               name="email"
                               required
                               maxlength="150"
                               placeholder="officer@chaperon.gov">

                    </div>

                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Mobile
                        </label>

                        <input type="text"
                               name="mobile"
                               maxlength="15"
                               placeholder="Mobile number">

                    </div>


                    <div class="form-group">

                        <label>
                            Initial Password
                            <span class="required">*</span>
                        </label>

                        <input type="password"
                               name="password"
                               required
                               minlength="6"
                               maxlength="100"
                               placeholder="Temporary password">

                        <div class="field-help">
                            Password will be stored as a secure hash.
                        </div>

                    </div>

                </div>


                <div class="form-row">

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
                            Designation
                        </label>

                        <input type="text"
                               name="designation"
                               maxlength="100"
                               value="Approval Officer"
                               placeholder="Example: Approval Officer">

                    </div>

                </div>


                <div class="form-group">

                    <label>
                        Employee Code
                        <span class="required">*</span>
                    </label>

                    <input type="text"
                           name="employeeCode"
                           required
                           maxlength="50"
                           placeholder="Example: FIRE-OFF-002">

                    <div class="field-help">
                        Employee code must be unique.
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

                    Create Officer

                </button>

            </div>

        </form>

    </div>

</div>


<!-- =====================================
     EDIT OFFICER MODAL
     ===================================== -->

<div id="editModal"
     class="modal">

    <div class="modal-content">


        <div class="modal-header">

            <h2>
                Edit Government Officer
            </h2>

            <button type="button"
                    class="close-btn"
                    onclick="closeEditModal()">

                ×

            </button>

        </div>


        <form method="post"
              action="<%= request.getContextPath() %>/admin/officers">

            <input type="hidden"
                   name="action"
                   value="update">

            <input type="hidden"
                   id="editOfficerProfileId"
                   name="officerProfileId">

            <input type="hidden"
                   id="editUserId"
                   name="userId">


            <div class="modal-body">


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Full Name
                            <span class="required">*</span>
                        </label>

                        <input type="text"
                               id="editFullName"
                               name="fullName"
                               required
                               maxlength="100">

                    </div>


                    <div class="form-group">

                        <label>
                            Email
                            <span class="required">*</span>
                        </label>

                        <input type="email"
                               id="editEmail"
                               name="email"
                               required
                               maxlength="150">

                    </div>

                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Mobile
                        </label>

                        <input type="text"
                               id="editMobile"
                               name="mobile"
                               maxlength="15">

                    </div>


                    <div class="form-group">

                        <label>
                            New Password
                        </label>

                        <input type="password"
                               name="newPassword"
                               minlength="6"
                               maxlength="100"
                               placeholder="Leave blank to keep current password">

                        <div class="field-help">
                            Optional password reset.
                        </div>

                    </div>

                </div>


                <div class="form-row">

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
                            Designation
                        </label>

                        <input type="text"
                               id="editDesignation"
                               name="designation"
                               maxlength="100">

                    </div>

                </div>


                <div class="form-group">

                    <label>
                        Employee Code
                        <span class="required">*</span>
                    </label>

                    <input type="text"
                           id="editEmployeeCode"
                           name="employeeCode"
                           required
                           maxlength="50">

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
        officerProfileId,
        userId,
        departmentId,
        fullName,
        email,
        mobile,
        designation,
        employeeCode
) {

    document.getElementById(
        "editOfficerProfileId"
    ).value = officerProfileId;

    document.getElementById(
        "editUserId"
    ).value = userId;

    document.getElementById(
        "editDepartmentId"
    ).value = departmentId;

    document.getElementById(
        "editFullName"
    ).value = fullName;

    document.getElementById(
        "editEmail"
    ).value = email;

    document.getElementById(
        "editMobile"
    ).value = mobile;

    document.getElementById(
        "editDesignation"
    ).value = designation;

    document.getElementById(
        "editEmployeeCode"
    ).value = employeeCode;


    document
        .getElementById("editModal")
        .classList.add("show");
}


function closeEditModal() {

    document
        .getElementById("editModal")
        .classList.remove("show");
}


function confirmOfficerStatus(action) {

    return confirm(
        "Are you sure you want to "
        + action
        + " this officer account?"
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