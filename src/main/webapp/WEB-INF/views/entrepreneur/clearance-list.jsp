<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.chaperon.model.ClearanceApplication" %>
<%@ page import="com.chaperon.model.ClearanceType" %>

<%!
    private String h(Object value) {
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
    List<ClearanceApplication> clearanceApplications =
            (List<ClearanceApplication>) request.getAttribute(
                    "clearanceApplications"
            );

    List<ClearanceType> clearanceTypes =
            (List<ClearanceType>) request.getAttribute("clearanceTypes");

    Map<Long, Integer> readinessByApplication =
            (Map<Long, Integer>) request.getAttribute(
                    "readinessByApplication"
            );

    int totalApplications = clearanceApplications == null
            ? 0
            : clearanceApplications.size();
    int activeApplications = 0;
    int approvedApplications = 0;

    if (clearanceApplications != null) {
        for (ClearanceApplication clearanceApplication : clearanceApplications) {
            String status = clearanceApplication.getCurrentStatus();

            if ("APPROVED".equalsIgnoreCase(status)) {
                approvedApplications++;
            }
            else if (!"REJECTED".equalsIgnoreCase(status) &&
                     !"WITHDRAWN".equalsIgnoreCase(status)) {
                activeApplications++;
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Environmental Clearances | CHAPERON</title>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, Helvetica, sans-serif;
    background: #f4f8fc;
    color: #17233c;
}

.topbar {
    min-height: 72px;
    background: #ffffff;
    border-bottom: 1px solid #e2e9f1;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 6%;
}

.logo {
    font-size: 25px;
    font-weight: 900;
    color: #10233f;
}

.nav {
    display: flex;
    align-items: center;
    gap: 18px;
}

.nav a {
    color: #46566b;
    font-size: 14px;
    font-weight: 700;
    text-decoration: none;
}

.nav a:hover,
.nav a.active {
    color: #1768c7;
}

.page {
    padding: 42px 20px 70px;
}

.container {
    max-width: 1180px;
    margin: auto;
}

.hero {
    color: #ffffff;
    background: linear-gradient(135deg, #0d5ea8, #138f79);
    border-radius: 22px;
    padding: 34px;
    box-shadow: 0 16px 38px rgba(23, 104, 199, 0.16);
}

.hero-badge {
    display: inline-block;
    padding: 7px 12px;
    margin-bottom: 14px;
    border: 1px solid rgba(255,255,255,0.28);
    border-radius: 20px;
    background: rgba(255,255,255,0.14);
    font-size: 12px;
    font-weight: 800;
}

.hero h1 {
    margin: 0 0 10px;
    font-size: 35px;
}

.hero p {
    max-width: 760px;
    margin: 0;
    color: #eaf6ff;
    line-height: 1.65;
}

.summary {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 17px;
    margin: 24px 0;
}

.summary-card {
    padding: 21px;
    background: #ffffff;
    border: 1px solid #e2e9f1;
    border-radius: 16px;
}

.summary-number {
    font-size: 30px;
    font-weight: 900;
    color: #1768c7;
}

.summary-label {
    margin-top: 5px;
    color: #68778a;
    font-size: 14px;
}

.section-heading {
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
    gap: 20px;
    margin: 31px 0 16px;
}

.section-heading h2 {
    margin: 0 0 5px;
    font-size: 25px;
}

.section-heading p {
    margin: 0;
    color: #68778a;
    font-size: 14px;
}

.type-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 17px;
}

.type-card {
    position: relative;
    overflow: hidden;
    padding: 23px;
    background: #ffffff;
    border: 1px solid #e2e9f1;
    border-radius: 17px;
    transition: transform .2s ease, box-shadow .2s ease;
}

.type-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 12px 30px rgba(24, 50, 84, 0.09);
}

.type-icon {
    width: 46px;
    height: 46px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 15px;
    border-radius: 13px;
    background: #eaf5ff;
    color: #1768c7;
    font-size: 22px;
    font-weight: 900;
}

.type-code {
    color: #138f79;
    font-size: 11px;
    font-weight: 900;
    letter-spacing: .6px;
}

.type-card h3 {
    min-height: 48px;
    margin: 7px 0 9px;
    font-size: 18px;
    line-height: 1.35;
}

.type-card p {
    min-height: 65px;
    margin: 0 0 17px;
    color: #68778a;
    font-size: 13px;
    line-height: 1.55;
}

.feature-row {
    min-height: 24px;
    margin-bottom: 14px;
}

.feature {
    display: inline-block;
    margin: 0 5px 5px 0;
    padding: 5px 8px;
    border-radius: 8px;
    background: #f0f4f8;
    color: #506176;
    font-size: 10px;
    font-weight: 800;
}

.primary-btn,
.secondary-btn {
    display: inline-block;
    padding: 11px 16px;
    border-radius: 9px;
    font-size: 13px;
    font-weight: 800;
    text-decoration: none;
}

.primary-btn {
    background: #1677e8;
    color: #ffffff;
}

.primary-btn:hover {
    background: #0f67c8;
}

.secondary-btn {
    background: #eef3f8;
    color: #40536b;
}

.applications {
    display: grid;
    gap: 17px;
}

.application-card {
    padding: 24px;
    background: #ffffff;
    border: 1px solid #e2e9f1;
    border-radius: 17px;
}

.application-top {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: 20px;
}

.application-number {
    margin-bottom: 6px;
    color: #1768c7;
    font-size: 12px;
    font-weight: 900;
}

.application-card h3 {
    margin: 0 0 7px;
    font-size: 21px;
}

.clearance-name {
    color: #68778a;
    font-size: 14px;
}

.status {
    display: inline-block;
    padding: 7px 11px;
    border-radius: 20px;
    background: #eef2f6;
    color: #56667a;
    font-size: 10px;
    font-weight: 900;
    white-space: nowrap;
}

.status-draft { background: #fff2d9; color: #986000; }
.status-process { background: #e8f2ff; color: #1768c7; }
.status-query { background: #fff0e2; color: #a45400; }
.status-approved { background: #e8f7ed; color: #267a42; }
.status-rejected { background: #ffe9e7; color: #c43329; }

.readiness-row {
    display: flex;
    align-items: center;
    gap: 15px;
    margin-top: 20px;
}

.progress-track {
    flex: 1;
    height: 9px;
    overflow: hidden;
    border-radius: 20px;
    background: #e8edf3;
}

.progress-fill {
    height: 100%;
    border-radius: 20px;
    background: linear-gradient(90deg, #1768c7, #17a184);
}

.readiness-value {
    min-width: 45px;
    color: #31506f;
    font-size: 13px;
    font-weight: 900;
}

.details-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 13px;
    margin-top: 18px;
}

.detail-box {
    padding: 13px;
    border-radius: 11px;
    background: #f8fafc;
}

.detail-label {
    margin-bottom: 5px;
    color: #7b8798;
    font-size: 11px;
}

.detail-value {
    color: #2b3b51;
    font-size: 13px;
    font-weight: 700;
    word-break: break-word;
}

.actions {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
    margin-top: 18px;
}

.empty {
    padding: 42px 20px;
    text-align: center;
    background: #ffffff;
    border: 1px dashed #c7d3e0;
    border-radius: 17px;
}

.empty h3 {
    margin: 0 0 8px;
}

.empty p {
    margin: 0;
    color: #68778a;
}

@media (max-width: 960px) {
    .type-grid { grid-template-columns: repeat(2, 1fr); }
    .details-grid { grid-template-columns: repeat(2, 1fr); }
}

@media (max-width: 620px) {
    .nav { display: none; }
    .summary, .type-grid, .details-grid { grid-template-columns: 1fr; }
    .application-top { flex-direction: column; }
    .hero h1 { font-size: 28px; }
}
</style>
</head>

<body>

<div class="topbar">
    <div class="logo">CHAPERON</div>

    <div class="nav">
        <a href="<%= request.getContextPath() %>/entrepreneur/dashboard">
            Dashboard
        </a>
        <a href="<%= request.getContextPath() %>/entrepreneur/generate-approvals">
            Approval Roadmap
        </a>
        <a href="<%= request.getContextPath() %>/entrepreneur/my-applications">
            Applications
        </a>
        <a class="active" href="<%= request.getContextPath() %>/entrepreneur/clearances">
            Clearances
        </a>
        <a href="<%= request.getContextPath() %>/entrepreneur/documents">
            Document Vault
        </a>
    </div>
</div>

<main class="page">
<div class="container">

    <section class="hero">
        <div class="hero-badge">UNIFIED CLEARANCE WORKSPACE</div>
        <h1>Environmental & Location Clearances</h1>
        <p>
            Apply for Environmental, Forest, Wildlife and CRZ clearances
            without leaving CHAPERON. Upload documents, add map boundaries,
            respond to queries and track every review stage in one place.
        </p>
    </section>

    <section class="summary">
        <div class="summary-card">
            <div class="summary-number"><%= totalApplications %></div>
            <div class="summary-label">Total Clearance Applications</div>
        </div>
        <div class="summary-card">
            <div class="summary-number"><%= activeApplications %></div>
            <div class="summary-label">Draft or In Process</div>
        </div>
        <div class="summary-card">
            <div class="summary-number"><%= approvedApplications %></div>
            <div class="summary-label">Approved Clearances</div>
        </div>
    </section>

    <div class="section-heading">
        <div>
            <h2>Start a Clearance Application</h2>
            <p>Select the clearance applicable to your project.</p>
        </div>
    </div>

    <section class="type-grid">
    <% if (clearanceTypes != null && !clearanceTypes.isEmpty()) {
           for (ClearanceType type : clearanceTypes) { %>

        <article class="type-card">
            <div class="type-icon">
                <%= h(type.getClearanceName().substring(0, 1)) %>
            </div>
            <div class="type-code"><%= h(type.getClearanceCode()) %></div>
            <h3><%= h(type.getClearanceName()) %></h3>
            <p><%= h(type.getDescription()) %></p>

            <div class="feature-row">
                <% if (type.isRequiresMap()) { %>
                    <span class="feature">MAP REQUIRED</span>
                <% } %>
                <% if (type.isRequiresKml()) { %>
                    <span class="feature">KML SUPPORTED</span>
                <% } %>
            </div>

            <a class="primary-btn"
               href="<%= request.getContextPath() %>/entrepreneur/clearances/new?typeId=<%= type.getClearanceTypeId() %>">
                Start Application
            </a>
        </article>

    <%     }
       } %>
    </section>

    <div class="section-heading">
        <div>
            <h2>My Clearance Applications</h2>
            <p>Continue drafts and track submitted applications.</p>
        </div>
    </div>

    <% if (clearanceApplications != null &&
           !clearanceApplications.isEmpty()) { %>

    <section class="applications">
    <% for (ClearanceApplication clearanceApplication : clearanceApplications) {
           String status = clearanceApplication.getCurrentStatus();
           String statusClass = "status-process";

           if ("DRAFT".equalsIgnoreCase(status)) {
               statusClass = "status-draft";
           }
           else if ("QUERY_RAISED".equalsIgnoreCase(status)) {
               statusClass = "status-query";
           }
           else if ("APPROVED".equalsIgnoreCase(status)) {
               statusClass = "status-approved";
           }
           else if ("REJECTED".equalsIgnoreCase(status) ||
                    "WITHDRAWN".equalsIgnoreCase(status)) {
               statusClass = "status-rejected";
           }

           int readiness = 0;
           if (readinessByApplication != null &&
               readinessByApplication.get(
                       clearanceApplication.getClearanceApplicationId()
               ) != null) {
               readiness = readinessByApplication.get(
                       clearanceApplication.getClearanceApplicationId()
               );
           }
    %>

        <article class="application-card">
            <div class="application-top">
                <div>
                    <div class="application-number">
                        <%= clearanceApplication.getApplicationNumber() == null
                                ? "DRAFT #" + clearanceApplication.getClearanceApplicationId()
                                : h(clearanceApplication.getApplicationNumber()) %>
                    </div>
                    <h3><%= h(clearanceApplication.getProjectTitle()) %></h3>
                    <div class="clearance-name">
                        <%= h(clearanceApplication.getClearanceName()) %>
                    </div>
                </div>

                <span class="status <%= statusClass %>">
                    <%= h(status == null
                            ? "UNKNOWN"
                            : status.replace('_', ' ')) %>
                </span>
            </div>

            <div class="readiness-row">
                <div class="progress-track">
                    <div class="progress-fill"
                         style="width: <%= readiness %>%;"></div>
                </div>
                <div class="readiness-value"><%= readiness %>%</div>
            </div>

            <div class="details-grid">
                <div class="detail-box">
                    <div class="detail-label">Business</div>
                    <div class="detail-value"><%= h(clearanceApplication.getBusinessName()) %></div>
                </div>
                <div class="detail-box">
                    <div class="detail-label">Location</div>
                    <div class="detail-value">
                        <%= h(clearanceApplication.getDistrict()) %>,
                        <%= h(clearanceApplication.getState()) %>
                    </div>
                </div>
                <div class="detail-box">
                    <div class="detail-label">Assigned Officer</div>
                    <div class="detail-value">
                        <%= clearanceApplication.getAssignedOfficerName() == null
                                ? "Not Assigned"
                                : h(clearanceApplication.getAssignedOfficerName()) %>
                    </div>
                </div>
                <div class="detail-box">
                    <div class="detail-label">Submitted On</div>
                    <div class="detail-value">
                        <%= clearanceApplication.getSubmissionDate() == null
                                ? "Not Submitted"
                                : h(clearanceApplication.getSubmissionDate()) %>
                    </div>
                </div>
            </div>

            <div class="actions">
                <a class="primary-btn"
                   href="<%= request.getContextPath() %>/entrepreneur/clearances/view?id=<%= clearanceApplication.getClearanceApplicationId() %>">
                    View Application
                </a>

                <% if ("DRAFT".equalsIgnoreCase(status)) { %>
                    <a class="secondary-btn"
                       href="<%= request.getContextPath() %>/entrepreneur/clearances/new?id=<%= clearanceApplication.getClearanceApplicationId() %>">
                        Continue Draft
                    </a>
                <% } %>
            </div>
        </article>

    <% } %>
    </section>

    <% } else { %>

    <section class="empty">
        <h3>No clearance application yet</h3>
        <p>Select a clearance above to create your first application.</p>
    </section>

    <% } %>

</div>
</main>

</body>
</html>
