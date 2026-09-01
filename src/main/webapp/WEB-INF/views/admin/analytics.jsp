<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>

<%
    String userName = (String) session.getAttribute("userName");

    if (userName == null || userName.isBlank()) {
        userName = "Administrator";
    }

    Integer totalApplications =
            (Integer) request.getAttribute("totalApplications");

    Integer approvedApplications =
            (Integer) request.getAttribute("approvedApplications");

    Integer rejectedApplications =
            (Integer) request.getAttribute("rejectedApplications");

    Integer pendingApplications =
            (Integer) request.getAttribute("pendingApplications");

    Double approvalRate =
            (Double) request.getAttribute("approvalRate");

    Double rejectionRate =
            (Double) request.getAttribute("rejectionRate");

    List<String> departmentLabels =
            (List<String>) request.getAttribute("departmentLabels");

    List<Integer> departmentCounts =
            (List<Integer>) request.getAttribute("departmentCounts");

    List<String> statusLabels =
            (List<String>) request.getAttribute("statusLabels");

    List<Integer> statusCounts =
            (List<Integer>) request.getAttribute("statusCounts");

    List<String> monthLabels =
            (List<String>) request.getAttribute("monthLabels");

    List<Integer> monthCounts =
            (List<Integer>) request.getAttribute("monthCounts");


    if (totalApplications == null) totalApplications = 0;
    if (approvedApplications == null) approvedApplications = 0;
    if (rejectedApplications == null) rejectedApplications = 0;
    if (pendingApplications == null) pendingApplications = 0;

    if (approvalRate == null) approvalRate = 0.0;
    if (rejectionRate == null) rejectionRate = 0.0;
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Analytics | CHAPERON</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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


/* SUMMARY */

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

.summary-subtext {
    margin-top: 6px;
    font-size: 12px;
    color: #8390a2;
}


/* RATE CARDS */

.rate-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 18px;
    margin-bottom: 25px;
}

.rate-card {
    background: white;
    border: 1px solid #e4e9f0;
    border-radius: 14px;
    padding: 22px;
}

.rate-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.rate-label {
    color: #718095;
    font-size: 13px;
    font-weight: 800;
}

.rate-number {
    font-size: 24px;
    font-weight: 900;
}

.progress {
    width: 100%;
    height: 9px;
    background: #eef1f5;
    border-radius: 20px;
    margin-top: 17px;
    overflow: hidden;
}

.progress-fill {
    height: 100%;
    background: #1677e8;
    border-radius: 20px;
}


/* CHARTS */

.charts-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
    margin-bottom: 25px;
}

.chart-card {
    background: white;
    border: 1px solid #e4e9f0;
    border-radius: 15px;
    padding: 22px;
    min-height: 390px;
}

.chart-card.full {
    grid-column: 1 / -1;
}

.chart-header {
    margin-bottom: 20px;
}

.chart-header h2 {
    margin: 0;
    font-size: 18px;
}

.chart-header p {
    margin: 6px 0 0;
    color: #7c8899;
    font-size: 12px;
}

.chart-container {
    position: relative;
    height: 300px;
}


/* INSIGHTS */

.insight-card {
    background: #10233f;
    color: white;
    border-radius: 16px;
    padding: 24px;
}

.insight-card h2 {
    margin: 0 0 15px;
    font-size: 19px;
}

.insight-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 15px;
}

.insight-box {
    background: rgba(255,255,255,0.08);
    padding: 15px;
    border-radius: 10px;
}

.insight-label {
    color: #afbdd0;
    font-size: 11px;
    font-weight: 800;
}

.insight-value {
    margin-top: 7px;
    font-size: 17px;
    font-weight: 900;
}


/* RESPONSIVE */

@media (max-width: 1050px) {

    .summary-grid {
        grid-template-columns: repeat(2, 1fr);
    }

    .charts-grid {
        grid-template-columns: 1fr;
    }

    .chart-card.full {
        grid-column: auto;
    }
}

@media (max-width: 900px) {

    .sidebar {
        display: none;
    }

    .main {
        margin-left: 0;
        width: 100%;
    }
}

@media (max-width: 650px) {

    .content {
        padding: 20px;
    }

    .topbar {
        padding: 0 20px;
    }

    .summary-grid,
    .rate-grid,
    .insight-grid {
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

    <a class="menu-item"
       href="<%= request.getContextPath() %>/admin/applications">

        <span class="menu-icon">▤</span>
        Applications

    </a>

    <a class="menu-item active"
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
        Analytics & Performance
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
        Platform Analytics
    </h1>

    <p>
        Monitor application outcomes, departmental workload
        and application trends across the CHAPERON platform.
    </p>

</div>


<div class="summary-grid">


    <div class="summary-card">

        <div class="summary-label">
            Total Applications
        </div>

        <div class="summary-number">
            <%= totalApplications %>
        </div>

        <div class="summary-subtext">
            All applications created
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Pending / In Process
        </div>

        <div class="summary-number">
            <%= pendingApplications %>
        </div>

        <div class="summary-subtext">
            Currently moving through workflow
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Approved
        </div>

        <div class="summary-number">
            <%= approvedApplications %>
        </div>

        <div class="summary-subtext">
            Successfully approved applications
        </div>

    </div>


    <div class="summary-card">

        <div class="summary-label">
            Rejected
        </div>

        <div class="summary-number">
            <%= rejectedApplications %>
        </div>

        <div class="summary-subtext">
            Applications with final rejection
        </div>

    </div>


</div>


<div class="rate-grid">


    <div class="rate-card">

        <div class="rate-top">

            <div class="rate-label">
                Approval Rate
            </div>

            <div class="rate-number">
                <%= String.format("%.1f", approvalRate) %>%
            </div>

        </div>

        <div class="progress">

            <div class="progress-fill"
                 style="width:<%= Math.min(approvalRate, 100.0) %>%">
            </div>

        </div>

    </div>


    <div class="rate-card">

        <div class="rate-top">

            <div class="rate-label">
                Rejection Rate
            </div>

            <div class="rate-number">
                <%= String.format("%.1f", rejectionRate) %>%
            </div>

        </div>

        <div class="progress">

            <div class="progress-fill"
                 style="width:<%= Math.min(rejectionRate, 100.0) %>%">
            </div>

        </div>

    </div>


</div>


<div class="charts-grid">


    <div class="chart-card">

        <div class="chart-header">

            <h2>
                Application Status Distribution
            </h2>

            <p>
                Distribution of applications across workflow stages.
            </p>

        </div>

        <div class="chart-container">

            <canvas id="statusChart"></canvas>

        </div>

    </div>


    <div class="chart-card">

        <div class="chart-header">

            <h2>
                Department Workload
            </h2>

            <p>
                Number of applications handled by each department.
            </p>

        </div>

        <div class="chart-container">

            <canvas id="departmentChart"></canvas>

        </div>

    </div>


    <div class="chart-card full">

        <div class="chart-header">

            <h2>
                Monthly Application Trend
            </h2>

            <p>
                Application creation trend across recent months.
            </p>

        </div>

        <div class="chart-container">

            <canvas id="monthlyChart"></canvas>

        </div>

    </div>


</div>


<div class="insight-card">

    <h2>
        Administrative Insights
    </h2>

    <div class="insight-grid">


        <div class="insight-box">

            <div class="insight-label">
                APPROVAL SUCCESS RATE
            </div>

            <div class="insight-value">
                <%= String.format("%.1f", approvalRate) %>%
            </div>

        </div>


        <div class="insight-box">

            <div class="insight-label">
                ACTIVE WORKFLOW LOAD
            </div>

            <div class="insight-value">
                <%= pendingApplications %> applications
            </div>

        </div>


        <div class="insight-box">

            <div class="insight-label">
                FINAL DECISIONS
            </div>

            <div class="insight-value">
                <%= approvedApplications + rejectedApplications %>
            </div>

        </div>


    </div>

</div>


</div>

</main>

</div>


<script>

/*
 * ==========================================
 * SERVER DATA → JAVASCRIPT
 * ==========================================
 */

const statusLabels = [
<%
if (statusLabels != null) {

    for (int i = 0; i < statusLabels.size(); i++) {

        if (i > 0) {
            out.print(",");
        }

        out.print(
            "\"" +
            escapeJs(statusLabels.get(i)) +
            "\""
        );
    }
}
%>
];


const statusCounts = [
<%
if (statusCounts != null) {

    for (int i = 0; i < statusCounts.size(); i++) {

        if (i > 0) {
            out.print(",");
        }

        out.print(
            statusCounts.get(i)
        );
    }
}
%>
];


const departmentLabels = [
<%
if (departmentLabels != null) {

    for (int i = 0; i < departmentLabels.size(); i++) {

        if (i > 0) {
            out.print(",");
        }

        out.print(
            "\"" +
            escapeJs(departmentLabels.get(i)) +
            "\""
        );
    }
}
%>
];


const departmentCounts = [
<%
if (departmentCounts != null) {

    for (int i = 0; i < departmentCounts.size(); i++) {

        if (i > 0) {
            out.print(",");
        }

        out.print(
            departmentCounts.get(i)
        );
    }
}
%>
];


const monthLabels = [
<%
if (monthLabels != null) {

    for (int i = 0; i < monthLabels.size(); i++) {

        if (i > 0) {
            out.print(",");
        }

        out.print(
            "\"" +
            escapeJs(monthLabels.get(i)) +
            "\""
        );
    }
}
%>
];


const monthCounts = [
<%
if (monthCounts != null) {

    for (int i = 0; i < monthCounts.size(); i++) {

        if (i > 0) {
            out.print(",");
        }

        out.print(
            monthCounts.get(i)
        );
    }
}
%>
];


/*
 * ==========================================
 * STATUS CHART
 * ==========================================
 */

new Chart(
    document.getElementById("statusChart"),
    {
        type: "doughnut",

        data: {

            labels: statusLabels,

            datasets: [
                {
                    data: statusCounts
                }
            ]
        },

        options: {

            responsive: true,

            maintainAspectRatio: false,

            plugins: {

                legend: {
                    position: "bottom"
                }
            }
        }
    }
);


/*
 * ==========================================
 * DEPARTMENT CHART
 * ==========================================
 */

new Chart(
    document.getElementById("departmentChart"),
    {
        type: "bar",

        data: {

            labels: departmentLabels,

            datasets: [
                {
                    label: "Applications",
                    data: departmentCounts
                }
            ]
        },

        options: {

            responsive: true,

            maintainAspectRatio: false,

            scales: {

                y: {
                    beginAtZero: true,
                    ticks: {
                        precision: 0
                    }
                }
            },

            plugins: {

                legend: {
                    display: false
                }
            }
        }
    }
);


/*
 * ==========================================
 * MONTHLY TREND CHART
 * ==========================================
 */

new Chart(
    document.getElementById("monthlyChart"),
    {
        type: "line",

        data: {

            labels: monthLabels,

            datasets: [
                {
                    label: "Applications",
                    data: monthCounts,
                    tension: 0.25
                }
            ]
        },

        options: {

            responsive: true,

            maintainAspectRatio: false,

            scales: {

                y: {
                    beginAtZero: true,
                    ticks: {
                        precision: 0
                    }
                }
            }
        }
    }
);

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
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }
%>