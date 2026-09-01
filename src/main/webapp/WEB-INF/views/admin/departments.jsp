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

<title>Departments | CHAPERON</title>

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
textarea {
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
    transition: 0.2s;
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
    font-size: 14px;
    font-weight: 800;
}

.add-btn:hover {
    background: #0f67c8;
}


/* =====================================
   ALERT
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
    align-items: center;
    justify-content: space-between;
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
    min-width: 1100px;
}

th {
    text-align: left;
    background: #f8fafc;
    color: #657287;
    padding: 14px 18px;
    font-size: 12px;
    font-weight: 800;
    border-bottom: 1px solid #e7ebf1;
}

td {
    padding: 17px 18px;
    font-size: 13px;
    border-bottom: 1px solid #edf0f4;
    vertical-align: top;
}

tbody tr:hover {
    background: #fbfcfe;
}

.department-name {
    font-weight: 800;
    color: #17233c;
}

.department-description {
    margin-top: 5px;
    color: #788598;
    line-height: 1.5;
    max-width: 300px;
}

.code-badge {
    display: inline-block;
    background: #edf5ff;
    color: #1768c7;
    padding: 6px 9px;
    border-radius: 7px;
    font-size: 11px;
    font-weight: 900;
}

.status {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 800;
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
    font-weight: 800;
    font-size: 12px;
}

.edit-btn:hover {
    background: #f2f7fd;
}

.toggle-btn {
    border: none;
    padding: 8px 11px;
    border-radius: 7px;
    cursor: pointer;
    font-weight: 800;
    font-size: 12px;
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
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background: rgba(16, 35, 63, 0.55);
    align-items: center;
    justify-content: center;
    padding: 20px;
}

.modal.show {
    display: flex;
}

.modal-content {
    width: 100%;
    max-width: 620px;
    max-height: 92vh;
    overflow-y: auto;
    background: white;
    border-radius: 18px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.2);
}

.modal-header {
    padding: 22px 24px;
    border-bottom: 1px solid #e6eaf0;
    display: flex;
    align-items: center;
    justify-content: space-between;
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
textarea {
    width: 100%;
    border: 1px solid #d6dee8;
    border-radius: 9px;
    padding: 12px 13px;
    font-size: 14px;
    outline: none;
}

textarea {
    min-height: 100px;
    resize: vertical;
}

input:focus,
textarea:focus {
    border-color: #1677e8;
}

.field-help {
    color: #8290a3;
    margin-top: 5px;
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
    color: #536277;
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


<!-- =====================================
     SIDEBAR
     ===================================== -->

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


    <a class="menu-item active"
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



<!-- =====================================
     MAIN
     ===================================== -->

<main class="main">


<header class="topbar">

    <div class="topbar-title">
        Department Management
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


<!-- =====================================
     PAGE HEADER
     ===================================== -->

<div class="page-header">

    <div>

        <h1>
            Government Departments
        </h1>

        <p>
            Manage departments responsible for processing
            industrial approvals and compliance applications.
        </p>

    </div>


    <button type="button"
            class="add-btn"
            onclick="openAddModal()">

        + Add Department

    </button>

</div>



<!-- =====================================
     SUCCESS MESSAGES
     ===================================== -->

<%
if ("added".equals(success)) {
%>

<div class="alert alert-success">
    Department added successfully.
</div>

<%
} else if ("updated".equals(success)) {
%>

<div class="alert alert-success">
    Department updated successfully.
</div>

<%
} else if ("status".equals(success)) {
%>

<div class="alert alert-success">
    Department status updated successfully.
</div>

<%
}
%>



<!-- =====================================
     ERROR MESSAGES
     ===================================== -->

<%
if ("required".equals(error)) {
%>

<div class="alert alert-error">
    Department name and department code are required.
</div>

<%
} else if ("duplicate-code".equals(error)) {
%>

<div class="alert alert-error">
    This department code already exists.
</div>

<%
} else if ("invalid-id".equals(error)) {
%>

<div class="alert alert-error">
    Invalid department selected.
</div>

<%
} else if ("invalid-action".equals(error)) {
%>

<div class="alert alert-error">
    Invalid department operation.
</div>

<%
}
%>



<!-- =====================================
     SUMMARY
     ===================================== -->

<%
    int total = 0;
    int activeCount = 0;
    int inactiveCount = 0;

    if (departments != null) {

        total = departments.size();

        for (Map<String, Object> department : departments) {

            Boolean active =
                    (Boolean) department.get("active");

            if (Boolean.TRUE.equals(active)) {
                activeCount++;
            } else {
                inactiveCount++;
            }
        }
    }
%>


<div class="summary-grid">

    <div class="summary-card">

        <div class="summary-label">
            Total Departments
        </div>

        <div class="summary-number">
            <%= total %>
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Active Departments
        </div>

        <div class="summary-number">
            <%= activeCount %>
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Inactive Departments
        </div>

        <div class="summary-number">
            <%= inactiveCount %>
        </div>

    </div>

</div>



<!-- =====================================
     DEPARTMENT TABLE
     ===================================== -->

<div class="table-card">

    <div class="table-header">

        <h2>
            Department Directory
        </h2>

        <span>
            <%= total %> department(s)
        </span>

    </div>


    <div class="table-wrapper">


    <%
    if (departments == null || departments.isEmpty()) {
    %>

        <div class="empty-state">

            No departments found.

        </div>

    <%
    } else {
    %>


        <table>

            <thead>

                <tr>

                    <th>
                        Department
                    </th>

                    <th>
                        Code
                    </th>

                    <th>
                        Contact
                    </th>

                    <th>
                        Status
                    </th>

                    <th>
                        Created
                    </th>

                    <th>
                        Actions
                    </th>

                </tr>

            </thead>


            <tbody>


            <%
            for (Map<String, Object> department : departments) {

                Long departmentId =
                        (Long) department.get(
                                "departmentId"
                        );

                String departmentName =
                        (String) department.get(
                                "departmentName"
                        );

                String departmentCode =
                        (String) department.get(
                                "departmentCode"
                        );

                String description =
                        (String) department.get(
                                "description"
                        );

                String contactEmail =
                        (String) department.get(
                                "contactEmail"
                        );

                String contactPhone =
                        (String) department.get(
                                "contactPhone"
                        );

                Boolean active =
                        (Boolean) department.get(
                                "active"
                        );

                Object createdAt =
                        department.get(
                                "createdAt"
                        );


                if (description == null) {
                    description = "";
                }

                if (contactEmail == null) {
                    contactEmail = "";
                }

                if (contactPhone == null) {
                    contactPhone = "";
                }
            %>


                <tr>

                    <td>

                        <div class="department-name">
                            <%= departmentName %>
                        </div>

                        <%
                        if (!description.isBlank()) {
                        %>

                        <div class="department-description">
                            <%= description %>
                        </div>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <span class="code-badge">
                            <%= departmentCode %>
                        </span>

                    </td>


                    <td>

                        <%
                        if (!contactEmail.isBlank()) {
                        %>

                        <div>
                            <%= contactEmail %>
                        </div>

                        <%
                        }

                        if (!contactPhone.isBlank()) {
                        %>

                        <div style="margin-top:5px;color:#738095;">
                            <%= contactPhone %>
                        </div>

                        <%
                        }

                        if (contactEmail.isBlank()
                                && contactPhone.isBlank()) {
                        %>

                        <span style="color:#9aa5b3;">
                            Not provided
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

                        <%
                        if (createdAt != null) {
                        %>

                        <%= createdAt %>

                        <%
                        } else {
                        %>

                        -

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <div class="action-group">


                            <button type="button"
                                    class="edit-btn"
                                    onclick="openEditModal(
                                        '<%= departmentId %>',
                                        '<%= escapeJs(departmentName) %>',
                                        '<%= escapeJs(departmentCode) %>',
                                        '<%= escapeJs(description) %>',
                                        '<%= escapeJs(contactEmail) %>',
                                        '<%= escapeJs(contactPhone) %>'
                                    )">

                                Edit

                            </button>


                            <form method="post"
                                  action="<%= request.getContextPath() %>/admin/departments"
                                  onsubmit="return confirmStatusChange('<%= Boolean.TRUE.equals(active) ? "deactivate" : "activate" %>');">

                                <input type="hidden"
                                       name="action"
                                       value="toggle">

                                <input type="hidden"
                                       name="departmentId"
                                       value="<%= departmentId %>">


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
     ADD DEPARTMENT MODAL
     ===================================== -->

<div id="addModal"
     class="modal">

    <div class="modal-content">


        <div class="modal-header">

            <h2>
                Add Department
            </h2>

            <button type="button"
                    class="close-btn"
                    onclick="closeAddModal()">

                ×

            </button>

        </div>


        <form method="post"
              action="<%= request.getContextPath() %>/admin/departments">

            <input type="hidden"
                   name="action"
                   value="add">


            <div class="modal-body">


                <div class="form-row">


                    <div class="form-group">

                        <label>
                            Department Name
                            <span class="required">*</span>
                        </label>

                        <input type="text"
                               name="departmentName"
                               required
                               maxlength="200"
                               placeholder="Example: Environment Department">

                    </div>


                    <div class="form-group">

                        <label>
                            Department Code
                            <span class="required">*</span>
                        </label>

                        <input type="text"
                               name="departmentCode"
                               required
                               maxlength="30"
                               placeholder="Example: ENV">

                        <div class="field-help">
                            Code must be unique.
                        </div>

                    </div>


                </div>


                <div class="form-group">

                    <label>
                        Description
                    </label>

                    <textarea name="description"
                              placeholder="Describe the department's responsibility"></textarea>

                </div>


                <div class="form-row">


                    <div class="form-group">

                        <label>
                            Contact Email
                        </label>

                        <input type="email"
                               name="contactEmail"
                               maxlength="150"
                               placeholder="department@example.gov">

                    </div>


                    <div class="form-group">

                        <label>
                            Contact Phone
                        </label>

                        <input type="text"
                               name="contactPhone"
                               maxlength="20"
                               placeholder="Contact number">

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

                    Add Department

                </button>

            </div>


        </form>


    </div>

</div>



<!-- =====================================
     EDIT DEPARTMENT MODAL
     ===================================== -->

<div id="editModal"
     class="modal">

    <div class="modal-content">


        <div class="modal-header">

            <h2>
                Edit Department
            </h2>

            <button type="button"
                    class="close-btn"
                    onclick="closeEditModal()">

                ×

            </button>

        </div>


        <form method="post"
              action="<%= request.getContextPath() %>/admin/departments">

            <input type="hidden"
                   name="action"
                   value="update">

            <input type="hidden"
                   id="editDepartmentId"
                   name="departmentId">


            <div class="modal-body">


                <div class="form-row">


                    <div class="form-group">

                        <label>
                            Department Name
                            <span class="required">*</span>
                        </label>

                        <input type="text"
                               id="editDepartmentName"
                               name="departmentName"
                               required
                               maxlength="200">

                    </div>


                    <div class="form-group">

                        <label>
                            Department Code
                            <span class="required">*</span>
                        </label>

                        <input type="text"
                               id="editDepartmentCode"
                               name="departmentCode"
                               required
                               maxlength="30">

                    </div>


                </div>


                <div class="form-group">

                    <label>
                        Description
                    </label>

                    <textarea id="editDescription"
                              name="description"></textarea>

                </div>


                <div class="form-row">


                    <div class="form-group">

                        <label>
                            Contact Email
                        </label>

                        <input type="email"
                               id="editContactEmail"
                               name="contactEmail"
                               maxlength="150">

                    </div>


                    <div class="form-group">

                        <label>
                            Contact Phone
                        </label>

                        <input type="text"
                               id="editContactPhone"
                               name="contactPhone"
                               maxlength="20">

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
        id,
        name,
        code,
        description,
        email,
        phone
) {

    document.getElementById(
        "editDepartmentId"
    ).value = id;

    document.getElementById(
        "editDepartmentName"
    ).value = name;

    document.getElementById(
        "editDepartmentCode"
    ).value = code;

    document.getElementById(
        "editDescription"
    ).value = description;

    document.getElementById(
        "editContactEmail"
    ).value = email;

    document.getElementById(
        "editContactPhone"
    ).value = phone;


    document
        .getElementById("editModal")
        .classList.add("show");
}


function closeEditModal() {

    document
        .getElementById("editModal")
        .classList.remove("show");
}


function confirmStatusChange(action) {

    return confirm(
        "Are you sure you want to "
        + action
        + " this department?"
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
    /*
     * JavaScript string safety helper.
     * Prevents quotes/new lines from breaking
     * the Edit button onclick.
     */
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