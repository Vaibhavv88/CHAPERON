<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>

<%@ page import="com.chaperon.dto.ApplicationView" %>
<%@ page import="com.chaperon.model.Application" %>

<%
    List<ApplicationView> applicationViews =
            (List<ApplicationView>)
            request.getAttribute(
                    "applicationViews"
            );
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    My Applications | CHAPERON
</title>

<style>

* {
    box-sizing: border-box;
}

body {
    margin: 0;

    font-family:
        Arial,
        Helvetica,
        sans-serif;

    background: #f5f8fc;

    color: #17233c;
}

.topbar {

    min-height: 72px;

    background: white;

    border-bottom:
        1px solid #e4eaf1;

    display: flex;

    align-items: center;

    justify-content:
        space-between;

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

    text-decoration: none;

    color: #46566b;

    font-weight: 700;

    font-size: 14px;
}

.nav a:hover {

    color: #1768c7;
}

.page {

    padding:
        45px 20px 70px;
}

.container {

    max-width: 1150px;

    margin: auto;
}

.hero {

    background: white;

    border:
        1px solid #e4eaf1;

    border-radius: 20px;

    padding: 32px;

    margin-bottom: 24px;

    box-shadow:
        0 10px 30px
        rgba(
            24,
            50,
            84,
            0.07
        );
}

.hero-badge {

    display: inline-block;

    background: #eef5ff;

    color: #1768c7;

    padding: 7px 12px;

    border-radius: 20px;

    font-size: 12px;

    font-weight: 800;

    margin-bottom: 13px;
}

.hero h1 {

    margin:
        0 0 10px;

    font-size: 34px;
}

.hero p {

    margin: 0;

    color: #68778a;

    line-height: 1.6;
}

.summary {

    display: grid;

    grid-template-columns:
        repeat(3, 1fr);

    gap: 18px;

    margin-bottom: 25px;
}

.summary-card {

    background: white;

    border:
        1px solid #e4eaf1;

    border-radius: 16px;

    padding: 22px;
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

.applications {

    display: grid;

    gap: 18px;
}

.application-card {

    background: white;

    border:
        1px solid #e4eaf1;

    border-radius: 18px;

    padding: 25px;

    transition:
        box-shadow 0.2s ease,
        transform 0.2s ease;
}

.application-card:hover {

    transform:
        translateY(-2px);

    box-shadow:
        0 10px 28px
        rgba(
            24,
            50,
            84,
            0.07
        );
}

.application-top {

    display: flex;

    justify-content:
        space-between;

    align-items:
        flex-start;

    gap: 20px;

    flex-wrap: wrap;
}

.application-number {

    color: #1768c7;

    font-size: 13px;

    font-weight: 800;

    margin-bottom: 7px;
}

.approval-name {

    font-size: 21px;

    font-weight: 900;

    color: #17233c;

    margin-bottom: 7px;
}

.department-name {

    font-size: 14px;

    color: #68778a;
}

.approval-code {

    display: inline-block;

    margin-top: 9px;

    background: #f2f5f9;

    color: #526378;

    border-radius: 7px;

    padding: 5px 8px;

    font-size: 11px;

    font-weight: 800;
}

.status {

    display: inline-block;

    padding:
        7px 12px;

    border-radius: 20px;

    font-size: 11px;

    font-weight: 900;
}

.status-draft {

    background: #fff2d9;

    color: #986000;
}

.status-submitted {

    background: #e8f2ff;

    color: #1768c7;
}

.status-review {

    background: #eee9ff;

    color: #6642b5;
}

.status-approved {

    background: #e8f7ed;

    color: #267a42;
}

.status-rejected {

    background: #ffe9e7;

    color: #c43329;
}

.status-query {

    background: #fff4df;

    color: #a36300;
}

.status-default {

    background: #eef2f6;

    color: #56667a;
}

.details-grid {

    margin-top: 21px;

    display: grid;

    grid-template-columns:
        repeat(4, 1fr);

    gap: 15px;
}

.detail-box {

    background: #f8fafc;

    border-radius: 12px;

    padding: 14px;
}

.detail-label {

    font-size: 12px;

    color: #7b8798;

    margin-bottom: 6px;
}

.detail-value {

    font-size: 14px;

    font-weight: 700;

    color: #2b3b51;

    word-break: break-word;
}

.actions {

    margin-top: 20px;

    display: flex;

    gap: 12px;

    flex-wrap: wrap;
}

.primary-btn {

    display: inline-block;

    text-decoration: none;

    background: #1677e8;

    color: white;

    padding:
        11px 17px;

    border-radius: 9px;

    font-weight: 700;

    font-size: 14px;
}

.primary-btn:hover {

    background: #0f67c8;
}

.secondary-btn {

    display: inline-block;

    text-decoration: none;

    background: #eef2f6;

    color: #43546a;

    padding:
        11px 17px;

    border-radius: 9px;

    font-weight: 700;

    font-size: 14px;
}

.empty {

    background: white;

    border:
        1px dashed #cad5e2;

    border-radius: 17px;

    padding: 45px 20px;

    text-align: center;
}

.empty h3 {

    margin-top: 0;
}

.empty p {

    color: #68778a;
}

@media(max-width:850px) {

    .summary {

        grid-template-columns:
            1fr;
    }

    .details-grid {

        grid-template-columns:
            repeat(2, 1fr);
    }
}

@media(max-width:600px) {

    .details-grid {

        grid-template-columns:
            1fr;
    }

    .nav {

        display: none;
    }

    .hero h1 {

        font-size: 28px;
    }
}

</style>

</head>


<body>


<div class="topbar">

    <div class="logo">
        CHAPERON
    </div>

    <div class="nav">

        <a href="<%= request.getContextPath() %>/entrepreneur/dashboard">
            Dashboard
        </a>

        <a href="<%= request.getContextPath() %>/entrepreneur/generate-approvals">
            Approval Roadmap
        </a>

        <a href="<%= request.getContextPath() %>/entrepreneur/documents">
            Document Vault
        </a>

    </div>

</div>


<div class="page">

<div class="container">


<div class="hero">

    <div class="hero-badge">
        APPLICATION TRACKER
    </div>

    <h1>
        My Applications
    </h1>

    <p>
        Track every approval application,
        current processing status,
        submission timeline and expected
        completion date from one place.
    </p>

</div>


<%

    int totalApplications = 0;

    int inProcessApplications = 0;

    int completedApplications = 0;

    if (applicationViews != null) {

        totalApplications =
                applicationViews.size();

        for (ApplicationView view
                : applicationViews) {

            Application item =
                    view.getApplication();

            String status =
                    item.getCurrentStatus();

            if ("SUBMITTED".equalsIgnoreCase(status) ||
                "UNDER_REVIEW".equalsIgnoreCase(status) ||
                "QUERY_RAISED".equalsIgnoreCase(status)) {

                inProcessApplications++;
            }

            if ("APPROVED".equalsIgnoreCase(status) ||
                "REJECTED".equalsIgnoreCase(status)) {

                completedApplications++;
            }
        }
    }

%>


<div class="summary">


<div class="summary-card">

    <div class="summary-number">
        <%= totalApplications %>
    </div>

    <div class="summary-label">
        Total Applications
    </div>

</div>


<div class="summary-card">

    <div class="summary-number">
        <%= inProcessApplications %>
    </div>

    <div class="summary-label">
        In Process
    </div>

</div>


<div class="summary-card">

    <div class="summary-number">
        <%= completedApplications %>
    </div>

    <div class="summary-label">
        Completed
    </div>

</div>


</div>


<%

if (applicationViews != null &&
    !applicationViews.isEmpty()) {

%>


<div class="applications">


<%

for (ApplicationView view
        : applicationViews) {

    Application userApplication =
            view.getApplication();

    String status =
            userApplication
                    .getCurrentStatus();

    String statusClass =
            "status-default";

    if ("DRAFT".equalsIgnoreCase(status)) {

        statusClass =
                "status-draft";

    } else if ("SUBMITTED"
            .equalsIgnoreCase(status)) {

        statusClass =
                "status-submitted";

    } else if ("UNDER_REVIEW"
            .equalsIgnoreCase(status)) {

        statusClass =
                "status-review";

    } else if ("QUERY_RAISED"
            .equalsIgnoreCase(status)) {

        statusClass =
                "status-query";

    } else if ("APPROVED"
            .equalsIgnoreCase(status)) {

        statusClass =
                "status-approved";

    } else if ("REJECTED"
            .equalsIgnoreCase(status)) {

        statusClass =
                "status-rejected";
    }

%>


<div class="application-card">


<div class="application-top">


<div>

    <div class="application-number">

        <%= userApplication
                .getApplicationNumber() %>

    </div>


    <div class="approval-name">

        <%= view.getApprovalName() %>

    </div>


    <div class="department-name">

        <%= view.getDepartmentName() %>

    </div>


    <%
        if (view.getApprovalCode() != null &&
            !view.getApprovalCode().isBlank()) {
    %>

    <div class="approval-code">

        <%= view.getApprovalCode() %>

    </div>

    <%
        }
    %>

</div>


<div>

<span class="status <%= statusClass %>">

    <%= status != null
            ? status.replace("_", " ")
            : "UNKNOWN" %>

</span>

</div>


</div>


<div class="details-grid">


<div class="detail-box">

    <div class="detail-label">
        Application ID
    </div>

    <div class="detail-value">

        #<%= userApplication
                .getApplicationId() %>

    </div>

</div>


<div class="detail-box">

    <div class="detail-label">
        Submitted On
    </div>

    <div class="detail-value">

        <%= userApplication
                .getSubmissionDate() != null

                ? userApplication
                        .getSubmissionDate()

                : "Not Submitted" %>

    </div>

</div>


<div class="detail-box">

    <div class="detail-label">
        Expected Completion
    </div>

    <div class="detail-value">

        <%= userApplication
                .getExpectedCompletionDate() != null

                ? userApplication
                        .getExpectedCompletionDate()

                : "Not Available" %>

    </div>

</div>


<div class="detail-box">

    <div class="detail-label">
        SLA
    </div>

    <div class="detail-value">

        <%= userApplication
                .getSlaDays() != null

                ? userApplication
                        .getSlaDays()
                        + " Days"

                : "Not Available" %>

    </div>

</div>


</div>


<div class="actions">

<a class="primary-btn"

   href="<%= request.getContextPath() %>/entrepreneur/application-details?id=<%= userApplication.getApplicationId() %>">

    View Application

</a>


<a class="secondary-btn"

   href="<%= request.getContextPath() %>/entrepreneur/approval-details?id=<%= userApplication.getApprovalId() %>">

    View Approval

</a>

</div>


</div>


<%
}
%>


</div>


<%

} else {

%>


<div class="empty">

<h3>
    No Applications Yet
</h3>

<p>
    You have not started any approval
    applications yet.
</p>

<a class="primary-btn"

   href="<%= request.getContextPath() %>/entrepreneur/generate-approvals">

    Open Approval Roadmap

</a>

</div>


<%

}

%>


</div>

</div>


</body>

</html>