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

    List<Map<String, Object>> rules =
            (List<Map<String, Object>>) request.getAttribute("rules");

    List<Map<String, Object>> approvals =
            (List<Map<String, Object>>) request.getAttribute("approvals");

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Approval Rules | CHAPERON</title>

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
   INFO BOX
   ========================= */

.info-box {
    background: #eef6ff;
    border: 1px solid #cfe4ff;
    border-radius: 13px;
    padding: 17px 19px;
    margin-bottom: 24px;
}

.info-box-title {
    font-weight: 900;
    color: #155da9;
    margin-bottom: 6px;
}

.info-box-text {
    font-size: 13px;
    color: #46627e;
    line-height: 1.6;
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
    min-width: 1800px;
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

.priority {
    display: inline-block;
    padding: 6px 9px;
    border-radius: 8px;
    font-size: 11px;
    font-weight: 900;
}

.priority-high {
    background: #ffe9e7;
    color: #b83932;
}

.priority-medium {
    background: #fff4dc;
    color: #9c6700;
}

.priority-low {
    background: #e9f7ef;
    color: #18784d;
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

.condition {
    display: inline-block;
    margin: 2px 3px 2px 0;
    padding: 5px 8px;
    border-radius: 7px;
    background: #f1f5fa;
    color: #4f6075;
    font-size: 11px;
    font-weight: 700;
}

.yes {
    background: #e7f8ef;
    color: #16754a;
}

.no {
    background: #fff0ef;
    color: #ae3f39;
}

.any {
    background: #eef2f6;
    color: #677488;
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
    max-width: 900px;
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
    min-height: 90px;
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
    line-height: 1.5;
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

    <a class="menu-item active"
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
        Approval Rules Management
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
            Approval Recommendation Rules
        </h1>

        <p>
            Configure the conditions used by CHAPERON
            to recommend applicable approvals to businesses.
        </p>

    </div>

    <button type="button"
            class="add-btn"
            onclick="openAddModal()">

        + Add Rule

    </button>

</div>


<div class="info-box">

    <div class="info-box-title">
        How recommendation rules work
    </div>

    <div class="info-box-text">
        Each rule connects one approval to business conditions.
        Leaving a condition blank means that condition does not restrict
        the rule. For Hazardous Material, Boiler, Groundwater and
        Industrial Waste, <b>ANY</b> means the condition is ignored.
    </div>

</div>


<%
if ("added".equals(success)) {
%>

<div class="alert alert-success">
    Approval recommendation rule added successfully.
</div>

<%
} else if ("updated".equals(success)) {
%>

<div class="alert alert-success">
    Approval recommendation rule updated successfully.
</div>

<%
} else if ("status".equals(success)) {
%>

<div class="alert alert-success">
    Approval rule status updated successfully.
</div>

<%
}
%>


<%
if ("required".equals(error)) {
%>

<div class="alert alert-error">
    Rule name is required.
</div>

<%
} else if ("invalid-approval".equals(error)) {
%>

<div class="alert alert-error">
    Please select a valid active approval.
</div>

<%
} else if ("invalid-number".equals(error)) {
%>

<div class="alert alert-error">
    Employee and investment values must be valid non-negative numbers.
</div>

<%
} else if ("employee-range".equals(error)) {
%>

<div class="alert alert-error">
    Minimum employee count cannot exceed maximum employee count.
</div>

<%
} else if ("investment-range".equals(error)) {
%>

<div class="alert alert-error">
    Minimum investment cannot exceed maximum investment.
</div>

<%
} else if ("invalid-priority".equals(error)) {
%>

<div class="alert alert-error">
    Invalid rule priority.
</div>

<%
} else if ("invalid-id".equals(error)) {
%>

<div class="alert alert-error">
    Invalid recommendation rule selected.
</div>

<%
} else if ("invalid-action".equals(error)) {
%>

<div class="alert alert-error">
    Invalid approval rule operation.
</div>

<%
}
%>


<%
    int totalRules = 0;
    int activeRules = 0;
    int highPriorityRules = 0;
    int inactiveRules = 0;

    if (rules != null) {

        totalRules = rules.size();

        for (Map<String, Object> rule : rules) {

            Boolean active =
                    (Boolean) rule.get("active");

            String priority =
                    (String) rule.get("priority");

            if (Boolean.TRUE.equals(active)) {
                activeRules++;
            } else {
                inactiveRules++;
            }

            if ("HIGH".equalsIgnoreCase(priority)) {
                highPriorityRules++;
            }
        }
    }
%>


<div class="summary-grid">

    <div class="summary-card">

        <div class="summary-label">
            Total Rules
        </div>

        <div class="summary-number">
            <%= totalRules %>
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Active Rules
        </div>

        <div class="summary-number">
            <%= activeRules %>
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            High Priority Rules
        </div>

        <div class="summary-number">
            <%= highPriorityRules %>
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Inactive Rules
        </div>

        <div class="summary-number">
            <%= inactiveRules %>
        </div>

    </div>

</div>


<div class="table-card">

    <div class="table-header">

        <h2>
            Recommendation Rule Directory
        </h2>

        <span>
            <%= totalRules %> rule(s)
        </span>

    </div>


    <div class="table-wrapper">


    <%
    if (rules == null || rules.isEmpty()) {
    %>

        <div class="empty-state">
            No approval recommendation rules found.
        </div>

    <%
    } else {
    %>

        <table>

            <thead>

                <tr>

                    <th>Rule</th>
                    <th>Approval</th>
                    <th>Industry / Activity</th>
                    <th>Stage / Location</th>
                    <th>Pollution</th>
                    <th>Employees</th>
                    <th>Investment</th>
                    <th>Compliance Conditions</th>
                    <th>Priority</th>
                    <th>Reason</th>
                    <th>Status</th>
                    <th>Actions</th>

                </tr>

            </thead>


            <tbody>


            <%
            for (Map<String, Object> rule : rules) {

                Long ruleId =
                        (Long) rule.get("ruleId");

                Long approvalId =
                        (Long) rule.get("approvalId");

                String approvalName =
                        (String) rule.get("approvalName");

                String approvalCode =
                        (String) rule.get("approvalCode");

                String ruleName =
                        (String) rule.get("ruleName");

                String industry =
                        (String) rule.get("industry");

                String businessConstitution =
                        (String) rule.get("businessConstitution");

                String businessActivity =
                        (String) rule.get("businessActivity");

                String projectStage =
                        (String) rule.get("projectStage");

                String pollutionCategory =
                        (String) rule.get("pollutionCategory");

                String state =
                        (String) rule.get("state");

                Integer minimumEmployeeCount =
                        (Integer) rule.get("minimumEmployeeCount");

                Integer maximumEmployeeCount =
                        (Integer) rule.get("maximumEmployeeCount");

                BigDecimal minimumInvestment =
                        (BigDecimal) rule.get("minimumInvestment");

                BigDecimal maximumInvestment =
                        (BigDecimal) rule.get("maximumInvestment");

                BigDecimal minimumAnnualTurnover =
                        (BigDecimal) rule.get("minimumAnnualTurnover");

                BigDecimal maximumAnnualTurnover =
                        (BigDecimal) rule.get("maximumAnnualTurnover");

                Boolean interstateSupplyRequired =
                        (Boolean) rule.get("interstateSupplyRequired");

                Boolean handlesPersonalDataRequired =
                        (Boolean) rule.get("handlesPersonalDataRequired");

                Boolean stpiBenefitsRequired =
                        (Boolean) rule.get("stpiBenefitsRequired");

                Boolean sezUnitRequired =
                        (Boolean) rule.get("sezUnitRequired");

                Boolean certInApplicabilityRequired =
                        (Boolean) rule.get("certInApplicabilityRequired");

                Boolean trademarkProtectionRequired =
                        (Boolean) rule.get("trademarkProtectionRequired");

                Boolean softwareCopyrightRequired =
                        (Boolean) rule.get("softwareCopyrightRequired");

                Boolean hazardousMaterialRequired =
                        (Boolean) rule.get("hazardousMaterialRequired");

                Boolean boilerRequired =
                        (Boolean) rule.get("boilerRequired");

                Boolean groundwaterRequired =
                        (Boolean) rule.get("groundwaterRequired");

                Boolean industrialWasteRequired =
                        (Boolean) rule.get("industrialWasteRequired");

                String priority =
                        (String) rule.get("priority");

                String recommendationReason =
                        (String) rule.get("recommendationReason");

                Boolean active =
                        (Boolean) rule.get("active");


                if (ruleName == null) ruleName = "";
                if (industry == null) industry = "";
                if (businessConstitution == null) businessConstitution = "";
                if (businessActivity == null) businessActivity = "";
                if (projectStage == null) projectStage = "";
                if (pollutionCategory == null) pollutionCategory = "";
                if (state == null) state = "";
                if (priority == null) priority = "MEDIUM";
                if (recommendationReason == null) recommendationReason = "";
            %>


                <tr>

                    <td>

                        <div class="name">
                            <%= ruleName %>
                        </div>

                        <div class="small-text">
                            Rule ID: <%= ruleId %>
                        </div>

                    </td>


                    <td>

                        <div class="name">
                            <%= approvalName %>
                        </div>

                        <div class="small-text">

                            <span class="code-badge">
                                <%= approvalCode %>
                            </span>

                        </div>

                    </td>


                    <td>

                        <div>
                            <b>Industry:</b>
                            <%= industry.isBlank() ? "Any" : industry %>
                        </div>

                        <div class="small-text">
                            <b>Activity:</b>
                            <%= businessActivity.isBlank()
                                    ? "Any"
                                    : businessActivity %>
                        </div>

                        <div class="small-text">
                            <b>Constitution:</b>
                            <%= businessConstitution.isBlank()
                                    ? "Any"
                                    : businessConstitution %>
                        </div>

                    </td>


                    <td>

                        <div>
                            <b>Stage:</b>
                            <%= projectStage.isBlank()
                                    ? "Any"
                                    : projectStage %>
                        </div>

                        <div class="small-text">
                            <b>State:</b>
                            <%= state.isBlank()
                                    ? "Any"
                                    : state %>
                        </div>

                    </td>


                    <td>

                        <%= pollutionCategory.isBlank()
                                ? "Any"
                                : pollutionCategory %>

                    </td>


                    <td>

                        <%
                        if (minimumEmployeeCount == null &&
                            maximumEmployeeCount == null) {
                        %>

                            Any

                        <%
                        } else {
                        %>

                            <%= minimumEmployeeCount != null
                                    ? minimumEmployeeCount
                                    : "0" %>

                            -

                            <%= maximumEmployeeCount != null
                                    ? maximumEmployeeCount
                                    : "No limit" %>

                        <%
                        }
                        %>

                        <div class="small-text">
                            <b>Annual turnover:</b>
                            <%
                            if (minimumAnnualTurnover == null &&
                                maximumAnnualTurnover == null) {
                            %>
                                Any
                            <%
                            } else {
                            %>
                                ₹<%= minimumAnnualTurnover != null ? minimumAnnualTurnover : "0" %>
                                -
                                <%= maximumAnnualTurnover != null ? "₹" + maximumAnnualTurnover : "No limit" %>
                            <%
                            }
                            %>
                        </div>

                    </td>


                    <td>

                        <%
                        if (minimumInvestment == null &&
                            maximumInvestment == null) {
                        %>

                            Any

                        <%
                        } else {
                        %>

                            ₹<%= minimumInvestment != null
                                    ? minimumInvestment
                                    : "0" %>

                            -

                            <%= maximumInvestment != null
                                    ? "₹" + maximumInvestment
                                    : "No limit" %>

                        <%
                        }
                        %>

                    </td>


                    <td>

                        <span class="condition <%= conditionClass(hazardousMaterialRequired) %>">
                            Hazardous:
                            <%= conditionText(hazardousMaterialRequired) %>
                        </span>

                        <span class="condition <%= conditionClass(boilerRequired) %>">
                            Boiler:
                            <%= conditionText(boilerRequired) %>
                        </span>

                        <span class="condition <%= conditionClass(groundwaterRequired) %>">
                            Groundwater:
                            <%= conditionText(groundwaterRequired) %>
                        </span>

                        <span class="condition <%= conditionClass(industrialWasteRequired) %>">
                            Waste:
                            <%= conditionText(industrialWasteRequired) %>
                        </span>

                        <span class="condition <%= conditionClass(interstateSupplyRequired) %>">
                            Interstate: <%= conditionText(interstateSupplyRequired) %>
                        </span>

                        <span class="condition <%= conditionClass(handlesPersonalDataRequired) %>">
                            Personal Data: <%= conditionText(handlesPersonalDataRequired) %>
                        </span>

                        <span class="condition <%= conditionClass(stpiBenefitsRequired) %>">
                            STPI: <%= conditionText(stpiBenefitsRequired) %>
                        </span>

                        <span class="condition <%= conditionClass(sezUnitRequired) %>">
                            SEZ: <%= conditionText(sezUnitRequired) %>
                        </span>

                        <span class="condition <%= conditionClass(certInApplicabilityRequired) %>">
                            CERT-In: <%= conditionText(certInApplicabilityRequired) %>
                        </span>

                        <span class="condition <%= conditionClass(trademarkProtectionRequired) %>">
                            Trademark: <%= conditionText(trademarkProtectionRequired) %>
                        </span>

                        <span class="condition <%= conditionClass(softwareCopyrightRequired) %>">
                            Copyright: <%= conditionText(softwareCopyrightRequired) %>
                        </span>

                    </td>


                    <td>

                        <%
                        String priorityClass =
                                "priority-medium";

                        if ("HIGH".equalsIgnoreCase(priority)) {
                            priorityClass = "priority-high";
                        } else if ("LOW".equalsIgnoreCase(priority)) {
                            priorityClass = "priority-low";
                        }
                        %>

                        <span class="priority <%= priorityClass %>">
                            <%= priority %>
                        </span>

                    </td>


                    <td>

                        <%
                        if (!recommendationReason.isBlank()) {
                        %>

                            <div class="small-text"
                                 style="margin-top:0;max-width:260px;">
                                <%= recommendationReason %>
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
                                        '<%= ruleId %>',
                                        '<%= approvalId %>',
                                        '<%= escapeJs(ruleName) %>',
                                        '<%= escapeJs(industry) %>',
                                        '<%= escapeJs(businessConstitution) %>',
                                        '<%= escapeJs(businessActivity) %>',
                                        '<%= escapeJs(projectStage) %>',
                                        '<%= escapeJs(pollutionCategory) %>',
                                        '<%= escapeJs(state) %>',
                                        '<%= minimumEmployeeCount != null ? minimumEmployeeCount : "" %>',
                                        '<%= maximumEmployeeCount != null ? maximumEmployeeCount : "" %>',
                                        '<%= minimumInvestment != null ? minimumInvestment.toPlainString() : "" %>',
                                        '<%= maximumInvestment != null ? maximumInvestment.toPlainString() : "" %>',
                                        '<%= minimumAnnualTurnover != null ? minimumAnnualTurnover.toPlainString() : "" %>',
                                        '<%= maximumAnnualTurnover != null ? maximumAnnualTurnover.toPlainString() : "" %>',
                                        '<%= booleanFormValue(interstateSupplyRequired) %>',
                                        '<%= booleanFormValue(handlesPersonalDataRequired) %>',
                                        '<%= booleanFormValue(stpiBenefitsRequired) %>',
                                        '<%= booleanFormValue(sezUnitRequired) %>',
                                        '<%= booleanFormValue(certInApplicabilityRequired) %>',
                                        '<%= booleanFormValue(trademarkProtectionRequired) %>',
                                        '<%= booleanFormValue(softwareCopyrightRequired) %>',
                                        '<%= booleanFormValue(hazardousMaterialRequired) %>',
                                        '<%= booleanFormValue(boilerRequired) %>',
                                        '<%= booleanFormValue(groundwaterRequired) %>',
                                        '<%= booleanFormValue(industrialWasteRequired) %>',
                                        '<%= escapeJs(priority) %>',
                                        '<%= escapeJs(recommendationReason) %>'
                                    )">

                                Edit

                            </button>


                            <form method="post"
                                  action="<%= request.getContextPath() %>/admin/approval-rules"
                                  onsubmit="return confirmRuleStatus('<%= Boolean.TRUE.equals(active) ? "deactivate" : "activate" %>');">

                                <input type="hidden"
                                       name="action"
                                       value="toggle">

                                <input type="hidden"
                                       name="ruleId"
                                       value="<%= ruleId %>">


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
     ADD RULE MODAL
     ===================================== -->

<div id="addModal"
     class="modal">

    <div class="modal-content">

        <div class="modal-header">

            <h2>
                Add Approval Rule
            </h2>

            <button type="button"
                    class="close-btn"
                    onclick="closeAddModal()">

                ×

            </button>

        </div>


        <form method="post"
              action="<%= request.getContextPath() %>/admin/approval-rules">

            <input type="hidden"
                   name="action"
                   value="add">


            <div class="modal-body">


                <div class="form-section-title">
                    Rule & Approval
                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Rule Name
                            <span class="required">*</span>
                        </label>

                        <input type="text"
                               name="ruleName"
                               maxlength="200"
                               required
                               placeholder="Example: Food Processing FSSAI Rule">

                    </div>


                    <div class="form-group">

                        <label>
                            Recommended Approval
                            <span class="required">*</span>
                        </label>

                        <select name="approvalId"
                                required>

                            <option value="">
                                Select Approval
                            </option>

                            <%
                            if (approvals != null) {

                                for (Map<String, Object> approval : approvals) {
                            %>

                                <option value="<%= approval.get("approvalId") %>">

                                    <%= approval.get("approvalName") %>
                                    (<%= approval.get("approvalCode") %>)

                                </option>

                            <%
                                }
                            }
                            %>

                        </select>

                    </div>

                </div>


                <div class="form-section-title">
                    Business Conditions
                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Industry
                        </label>

                        <input type="text"
                               name="industry"
                               maxlength="100"
                               placeholder="Example: Food Processing">

                        <div class="field-help">
                            Leave blank for any industry.
                        </div>

                    </div>


                    <div class="form-group">

                        <label>
                            Business Activity
                        </label>

                        <input type="text"
                               name="businessActivity"
                               maxlength="50"
                               placeholder="Example: Manufacturing">

                        <div class="field-help">
                            Leave blank for any activity.
                        </div>

                    </div>

                    <div class="form-group">
                        <label>Business Constitution</label>
                        <input type="text"
                               name="businessConstitution"
                               maxlength="50"
                               placeholder="Example: Private Limited">
                        <div class="field-help">Leave blank for any constitution.</div>
                    </div>

                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Minimum Annual Turnover</label>
                        <input type="number" min="0" step="0.01"
                               name="minimumAnnualTurnover"
                               placeholder="Leave blank for no minimum">
                    </div>
                    <div class="form-group">
                        <label>Maximum Annual Turnover</label>
                        <input type="number" min="0" step="0.01"
                               name="maximumAnnualTurnover"
                               placeholder="Leave blank for no maximum">
                    </div>
                </div>


                <div class="form-row-three">

                    <div class="form-group">

                        <label>
                            Project Stage
                        </label>

                        <input type="text"
                               name="projectStage"
                               maxlength="50"
                               placeholder="Example: Operational">

                    </div>


                    <div class="form-group">

                        <label>
                            Pollution Category
                        </label>

                        <select name="pollutionCategory">

                            <option value="">
                                Any
                            </option>

                            <option value="RED">
                                Red
                            </option>

                            <option value="ORANGE">
                                Orange
                            </option>

                            <option value="GREEN">
                                Green
                            </option>

                            <option value="WHITE">
                                White
                            </option>

                        </select>

                    </div>


                    <div class="form-group">

                        <label>
                            State
                        </label>

                        <input type="text"
                               name="state"
                               maxlength="100"
                               placeholder="Example: Uttar Pradesh">

                    </div>

                </div>


                <div class="form-section-title">
                    Employee & Investment Range
                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Minimum Employees
                        </label>

                        <input type="number"
                               min="0"
                               name="minimumEmployeeCount"
                               placeholder="Example: 10">

                    </div>


                    <div class="form-group">

                        <label>
                            Maximum Employees
                        </label>

                        <input type="number"
                               min="0"
                               name="maximumEmployeeCount"
                               placeholder="Leave blank for no maximum">

                    </div>

                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Minimum Investment
                        </label>

                        <input type="number"
                               min="0"
                               step="0.01"
                               name="minimumInvestment"
                               placeholder="Example: 100000">

                    </div>


                    <div class="form-group">

                        <label>
                            Maximum Investment
                        </label>

                        <input type="number"
                               min="0"
                               step="0.01"
                               name="maximumInvestment"
                               placeholder="Leave blank for no maximum">

                    </div>

                </div>


                <div class="form-section-title">
                    Compliance Conditions
                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Hazardous Material
                        </label>

                        <select name="hazardousMaterialRequired">

                            <option value="ANY">
                                Any
                            </option>

                            <option value="YES">
                                Yes
                            </option>

                            <option value="NO">
                                No
                            </option>

                        </select>

                    </div>


                    <div class="form-group">

                        <label>
                            Boiler Used
                        </label>

                        <select name="boilerRequired">

                            <option value="ANY">
                                Any
                            </option>

                            <option value="YES">
                                Yes
                            </option>

                            <option value="NO">
                                No
                            </option>

                        </select>

                    </div>

                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Groundwater Required
                        </label>

                        <select name="groundwaterRequired">

                            <option value="ANY">
                                Any
                            </option>

                            <option value="YES">
                                Yes
                            </option>

                            <option value="NO">
                                No
                            </option>

                        </select>

                    </div>


                    <div class="form-group">

                        <label>
                            Industrial Waste
                        </label>

                        <select name="industrialWasteRequired">

                            <option value="ANY">
                                Any
                            </option>

                            <option value="YES">
                                Yes
                            </option>

                            <option value="NO">
                                No
                            </option>

                        </select>

                    </div>

                </div>


                <div class="form-section-title">Digital & Location Conditions</div>

                <div class="form-row">
                    <div class="form-group"><label>Interstate Supply</label><select name="interstateSupplyRequired"><option value="ANY">Any</option><option value="YES">Yes</option><option value="NO">No</option></select></div>
                    <div class="form-group"><label>Handles Personal Data</label><select name="handlesPersonalDataRequired"><option value="ANY">Any</option><option value="YES">Yes</option><option value="NO">No</option></select></div>
                </div>
                <div class="form-row">
                    <div class="form-group"><label>STPI Benefits</label><select name="stpiBenefitsRequired"><option value="ANY">Any</option><option value="YES">Yes</option><option value="NO">No</option></select></div>
                    <div class="form-group"><label>SEZ Unit</label><select name="sezUnitRequired"><option value="ANY">Any</option><option value="YES">Yes</option><option value="NO">No</option></select></div>
                </div>
                <div class="form-row">
                    <div class="form-group"><label>CERT-In Applicability</label><select name="certInApplicabilityRequired"><option value="ANY">Any</option><option value="YES">Yes</option><option value="NO">No</option></select></div>
                    <div class="form-group"><label>Trademark Protection</label><select name="trademarkProtectionRequired"><option value="ANY">Any</option><option value="YES">Yes</option><option value="NO">No</option></select></div>
                </div>
                <div class="form-row">
                    <div class="form-group"><label>Software Copyright</label><select name="softwareCopyrightRequired"><option value="ANY">Any</option><option value="YES">Yes</option><option value="NO">No</option></select></div>
                </div>

                <div class="form-section-title">
                    Recommendation Output
                </div>


                <div class="form-group">

                    <label>
                        Priority
                    </label>

                    <select name="priority">

                        <option value="HIGH">
                            High
                        </option>

                        <option value="MEDIUM"
                                selected>
                            Medium
                        </option>

                        <option value="LOW">
                            Low
                        </option>

                    </select>

                </div>


                <div class="form-group">

                    <label>
                        Recommendation Reason
                    </label>

                    <textarea name="recommendationReason"
                              placeholder="Example: Required because the business operates in food processing and handles food products."></textarea>

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

                    Add Rule

                </button>

            </div>

        </form>

    </div>

</div>


<!-- =====================================
     EDIT RULE MODAL
     ===================================== -->

<div id="editModal"
     class="modal">

    <div class="modal-content">

        <div class="modal-header">

            <h2>
                Edit Approval Rule
            </h2>

            <button type="button"
                    class="close-btn"
                    onclick="closeEditModal()">

                ×

            </button>

        </div>


        <form method="post"
              action="<%= request.getContextPath() %>/admin/approval-rules">

            <input type="hidden"
                   name="action"
                   value="update">

            <input type="hidden"
                   id="editRuleId"
                   name="ruleId">


            <div class="modal-body">


                <div class="form-section-title">
                    Rule & Approval
                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Rule Name
                            <span class="required">*</span>
                        </label>

                        <input type="text"
                               id="editRuleName"
                               name="ruleName"
                               maxlength="200"
                               required>

                    </div>


                    <div class="form-group">

                        <label>
                            Recommended Approval
                            <span class="required">*</span>
                        </label>

                        <select id="editApprovalId"
                                name="approvalId"
                                required>

                            <option value="">
                                Select Approval
                            </option>

                            <%
                            if (approvals != null) {

                                for (Map<String, Object> approval : approvals) {
                            %>

                                <option value="<%= approval.get("approvalId") %>">

                                    <%= approval.get("approvalName") %>
                                    (<%= approval.get("approvalCode") %>)

                                </option>

                            <%
                                }
                            }
                            %>

                        </select>

                    </div>

                </div>


                <div class="form-section-title">
                    Business Conditions
                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Industry
                        </label>

                        <input type="text"
                               id="editIndustry"
                               name="industry"
                               maxlength="100">

                    </div>


                    <div class="form-group">

                        <label>
                            Business Activity
                        </label>

                        <input type="text"
                               id="editBusinessActivity"
                               name="businessActivity"
                               maxlength="50">

                    </div>

                    <div class="form-group">
                        <label>Business Constitution</label>
                        <input type="text"
                               id="editBusinessConstitution"
                               name="businessConstitution"
                               maxlength="50">
                    </div>

                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Minimum Annual Turnover</label>
                        <input type="number" min="0" step="0.01"
                               id="editMinimumAnnualTurnover"
                               name="minimumAnnualTurnover">
                    </div>
                    <div class="form-group">
                        <label>Maximum Annual Turnover</label>
                        <input type="number" min="0" step="0.01"
                               id="editMaximumAnnualTurnover"
                               name="maximumAnnualTurnover">
                    </div>
                </div>


                <div class="form-row-three">

                    <div class="form-group">

                        <label>
                            Project Stage
                        </label>

                        <input type="text"
                               id="editProjectStage"
                               name="projectStage"
                               maxlength="50">

                    </div>


                    <div class="form-group">

                        <label>
                            Pollution Category
                        </label>

                        <select id="editPollutionCategory"
                                name="pollutionCategory">

                            <option value="">
                                Any
                            </option>

                            <option value="RED">
                                Red
                            </option>

                            <option value="ORANGE">
                                Orange
                            </option>

                            <option value="GREEN">
                                Green
                            </option>

                            <option value="WHITE">
                                White
                            </option>

                        </select>

                    </div>


                    <div class="form-group">

                        <label>
                            State
                        </label>

                        <input type="text"
                               id="editState"
                               name="state"
                               maxlength="100">

                    </div>

                </div>


                <div class="form-section-title">
                    Employee & Investment Range
                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Minimum Employees
                        </label>

                        <input type="number"
                               min="0"
                               id="editMinimumEmployeeCount"
                               name="minimumEmployeeCount">

                    </div>


                    <div class="form-group">

                        <label>
                            Maximum Employees
                        </label>

                        <input type="number"
                               min="0"
                               id="editMaximumEmployeeCount"
                               name="maximumEmployeeCount">

                    </div>

                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Minimum Investment
                        </label>

                        <input type="number"
                               min="0"
                               step="0.01"
                               id="editMinimumInvestment"
                               name="minimumInvestment">

                    </div>


                    <div class="form-group">

                        <label>
                            Maximum Investment
                        </label>

                        <input type="number"
                               min="0"
                               step="0.01"
                               id="editMaximumInvestment"
                               name="maximumInvestment">

                    </div>

                </div>


                <div class="form-section-title">
                    Compliance Conditions
                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Hazardous Material
                        </label>

                        <select id="editHazardousMaterialRequired"
                                name="hazardousMaterialRequired">

                            <option value="ANY">Any</option>
                            <option value="YES">Yes</option>
                            <option value="NO">No</option>

                        </select>

                    </div>


                    <div class="form-group">

                        <label>
                            Boiler Used
                        </label>

                        <select id="editBoilerRequired"
                                name="boilerRequired">

                            <option value="ANY">Any</option>
                            <option value="YES">Yes</option>
                            <option value="NO">No</option>

                        </select>

                    </div>

                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>
                            Groundwater Required
                        </label>

                        <select id="editGroundwaterRequired"
                                name="groundwaterRequired">

                            <option value="ANY">Any</option>
                            <option value="YES">Yes</option>
                            <option value="NO">No</option>

                        </select>

                    </div>


                    <div class="form-group">

                        <label>
                            Industrial Waste
                        </label>

                        <select id="editIndustrialWasteRequired"
                                name="industrialWasteRequired">

                            <option value="ANY">Any</option>
                            <option value="YES">Yes</option>
                            <option value="NO">No</option>

                        </select>

                    </div>

                </div>

                <div class="form-section-title">Digital & Location Conditions</div>

                <div class="form-row">
                    <div class="form-group"><label>Interstate Supply</label><select id="editInterstateSupplyRequired" name="interstateSupplyRequired"><option value="ANY">Any</option><option value="YES">Yes</option><option value="NO">No</option></select></div>
                    <div class="form-group"><label>Handles Personal Data</label><select id="editHandlesPersonalDataRequired" name="handlesPersonalDataRequired"><option value="ANY">Any</option><option value="YES">Yes</option><option value="NO">No</option></select></div>
                </div>
                <div class="form-row">
                    <div class="form-group"><label>STPI Benefits</label><select id="editStpiBenefitsRequired" name="stpiBenefitsRequired"><option value="ANY">Any</option><option value="YES">Yes</option><option value="NO">No</option></select></div>
                    <div class="form-group"><label>SEZ Unit</label><select id="editSezUnitRequired" name="sezUnitRequired"><option value="ANY">Any</option><option value="YES">Yes</option><option value="NO">No</option></select></div>
                </div>
                <div class="form-row">
                    <div class="form-group"><label>CERT-In Applicability</label><select id="editCertInApplicabilityRequired" name="certInApplicabilityRequired"><option value="ANY">Any</option><option value="YES">Yes</option><option value="NO">No</option></select></div>
                    <div class="form-group"><label>Trademark Protection</label><select id="editTrademarkProtectionRequired" name="trademarkProtectionRequired"><option value="ANY">Any</option><option value="YES">Yes</option><option value="NO">No</option></select></div>
                </div>
                <div class="form-row">
                    <div class="form-group"><label>Software Copyright</label><select id="editSoftwareCopyrightRequired" name="softwareCopyrightRequired"><option value="ANY">Any</option><option value="YES">Yes</option><option value="NO">No</option></select></div>
                </div>


                <div class="form-section-title">
                    Recommendation Output
                </div>


                <div class="form-group">

                    <label>
                        Priority
                    </label>

                    <select id="editPriority"
                            name="priority">

                        <option value="HIGH">
                            High
                        </option>

                        <option value="MEDIUM">
                            Medium
                        </option>

                        <option value="LOW">
                            Low
                        </option>

                    </select>

                </div>


                <div class="form-group">

                    <label>
                        Recommendation Reason
                    </label>

                    <textarea id="editRecommendationReason"
                              name="recommendationReason"></textarea>

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
        ruleId,
        approvalId,
	        ruleName,
	        industry,
	        businessConstitution,
	        businessActivity,
        projectStage,
        pollutionCategory,
        state,
        minimumEmployeeCount,
        maximumEmployeeCount,
	        minimumInvestment,
	        maximumInvestment,
	        minimumAnnualTurnover,
	        maximumAnnualTurnover,
	        interstateSupplyRequired,
	        handlesPersonalDataRequired,
	        stpiBenefitsRequired,
	        sezUnitRequired,
	        certInApplicabilityRequired,
	        trademarkProtectionRequired,
	        softwareCopyrightRequired,
	        hazardousMaterialRequired,
        boilerRequired,
        groundwaterRequired,
        industrialWasteRequired,
        priority,
        recommendationReason
) {

    document.getElementById(
        "editRuleId"
    ).value = ruleId;

    document.getElementById(
        "editApprovalId"
    ).value = approvalId;

    document.getElementById(
        "editRuleName"
    ).value = ruleName;

    document.getElementById(
        "editIndustry"
    ).value = industry;

    document.getElementById(
        "editBusinessConstitution"
    ).value = businessConstitution;

    document.getElementById(
        "editBusinessActivity"
    ).value = businessActivity;

    document.getElementById(
        "editProjectStage"
    ).value = projectStage;

    document.getElementById(
        "editPollutionCategory"
    ).value = pollutionCategory;

    document.getElementById(
        "editState"
    ).value = state;

    document.getElementById(
        "editMinimumEmployeeCount"
    ).value = minimumEmployeeCount;

    document.getElementById(
        "editMaximumEmployeeCount"
    ).value = maximumEmployeeCount;

    document.getElementById(
        "editMinimumInvestment"
    ).value = minimumInvestment;

    document.getElementById(
        "editMaximumInvestment"
    ).value = maximumInvestment;

    document.getElementById("editMinimumAnnualTurnover").value = minimumAnnualTurnover;
    document.getElementById("editMaximumAnnualTurnover").value = maximumAnnualTurnover;
    document.getElementById("editInterstateSupplyRequired").value = interstateSupplyRequired;
    document.getElementById("editHandlesPersonalDataRequired").value = handlesPersonalDataRequired;
    document.getElementById("editStpiBenefitsRequired").value = stpiBenefitsRequired;
    document.getElementById("editSezUnitRequired").value = sezUnitRequired;
    document.getElementById("editCertInApplicabilityRequired").value = certInApplicabilityRequired;
    document.getElementById("editTrademarkProtectionRequired").value = trademarkProtectionRequired;
    document.getElementById("editSoftwareCopyrightRequired").value = softwareCopyrightRequired;

    document.getElementById(
        "editHazardousMaterialRequired"
    ).value = hazardousMaterialRequired;

    document.getElementById(
        "editBoilerRequired"
    ).value = boilerRequired;

    document.getElementById(
        "editGroundwaterRequired"
    ).value = groundwaterRequired;

    document.getElementById(
        "editIndustrialWasteRequired"
    ).value = industrialWasteRequired;

    document.getElementById(
        "editPriority"
    ).value = priority;

    document.getElementById(
        "editRecommendationReason"
    ).value = recommendationReason;


    document
        .getElementById("editModal")
        .classList.add("show");
}


function closeEditModal() {

    document
        .getElementById("editModal")
        .classList.remove("show");
}


function confirmRuleStatus(action) {

    return confirm(
        "Are you sure you want to "
        + action
        + " this recommendation rule?"
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


    private String booleanFormValue(Boolean value) {

        if (value == null) {
            return "ANY";
        }

        return value
                ? "YES"
                : "NO";
    }


    private String conditionText(Boolean value) {

        if (value == null) {
            return "ANY";
        }

        return value
                ? "YES"
                : "NO";
    }


    private String conditionClass(Boolean value) {

        if (value == null) {
            return "any";
        }

        return value
                ? "yes"
                : "no";
    }
%>
