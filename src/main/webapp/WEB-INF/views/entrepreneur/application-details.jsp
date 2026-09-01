<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.sql.Date" %>

<%@ page import="com.chaperon.model.Application" %>
<%@ page import="com.chaperon.model.Approval" %>
<%@ page import="com.chaperon.model.Business" %>
<%@ page import="com.chaperon.model.DocumentReadiness" %>

<%!
    private String esc(Object value) {

        if (value == null) {
            return "";
        }

        String text = String.valueOf(value);

        return text
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    Application userApplication =
            (Application) request.getAttribute("application");

    Approval approval =
            (Approval) request.getAttribute("approval");

    Business business =
            (Business) request.getAttribute("business");


    @SuppressWarnings("unchecked")
    List<DocumentReadiness> documentReadinessList =
            (List<DocumentReadiness>)
            request.getAttribute("documentReadinessList");


    Integer readinessPercentage =
            (Integer)
            request.getAttribute("readinessPercentage");

    if (readinessPercentage == null) {
        readinessPercentage = 0;
    }


    /*
     * ==========================================
     * QUERY DATA
     * ==========================================
     */

    Long queryId =
            (Long) request.getAttribute("queryId");

    String queryDescription =
            (String) request.getAttribute("queryDescription");

    Timestamp queryRaisedDate =
            (Timestamp) request.getAttribute("queryRaisedDate");

    Date queryResponseDeadline =
            (Date) request.getAttribute("queryResponseDeadline");

    String queryStatus =
            (String) request.getAttribute("queryStatus");

    String entrepreneurResponse =
            (String) request.getAttribute("entrepreneurResponse");

    Timestamp queryRespondedAt =
            (Timestamp) request.getAttribute("queryRespondedAt");

    Timestamp queryResolvedAt =
            (Timestamp) request.getAttribute("queryResolvedAt");


    /*
     * ==========================================
     * CERTIFICATE DATA
     * ==========================================
     */

    Long certificateId =
            (Long) request.getAttribute("certificateId");

    String certificateApprovalNumber =
            (String)
            request.getAttribute("certificateApprovalNumber");

    Long certificateApprovedBy =
            (Long)
            request.getAttribute("certificateApprovedBy");

    String certificateApprovedByName =
            (String)
            request.getAttribute("certificateApprovedByName");

    Date certificateApprovalDate =
            (Date)
            request.getAttribute("certificateApprovalDate");

    Date certificateValidFrom =
            (Date)
            request.getAttribute("certificateValidFrom");

    Date certificateValidUntil =
            (Date)
            request.getAttribute("certificateValidUntil");

    String certificateRemarks =
            (String)
            request.getAttribute("certificateRemarks");

    Timestamp certificateCreatedAt =
            (Timestamp)
            request.getAttribute("certificateCreatedAt");


    String success =
            request.getParameter("success");

    String message =
            request.getParameter("message");


    String status = null;
    String statusClass = "status-draft";

    if (userApplication != null) {

        status =
                userApplication.getCurrentStatus();

        if ("SUBMITTED".equalsIgnoreCase(status)) {

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
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Application Details | CHAPERON</title>


<style>

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, Helvetica, sans-serif;
    background: #f5f8fc;
    color: #17233c;
}


/* ==============================
   TOP BAR
   ============================== */

.topbar {

    min-height: 70px;
    background: white;
    border-bottom: 1px solid #e5eaf0;

    display: flex;
    justify-content: space-between;
    align-items: center;

    padding: 0 6%;
}

.logo {

    font-size: 25px;
    font-weight: 800;
    color: #10233f;
}

.top-links {

    display: flex;
    align-items: center;
    gap: 18px;
}

.top-links a {

    text-decoration: none;
    color: #46566b;

    font-weight: 700;
    font-size: 14px;
}

.top-links a:hover {
    color: #1677e8;
}


/* ==============================
   PAGE
   ============================== */

.page {
    padding: 45px 20px 70px;
}

.container {

    max-width: 1050px;
    margin: auto;
}


/* ==============================
   ALERT
   ============================== */

.alert {

    padding: 15px 18px;
    border-radius: 12px;

    margin-bottom: 20px;

    font-size: 14px;
    line-height: 1.6;
}

.alert-success {

    background: #e8f7ed;
    border: 1px solid #ccebd6;
    color: #267a42;
}

.alert-warning {

    background: #fff5df;
    border: 1px solid #f3dfae;
    color: #856000;
}


/* ==============================
   HERO
   ============================== */

.hero {

    background: white;

    border: 1px solid #e5eaf1;
    border-radius: 20px;

    padding: 32px;

    box-shadow:
        0 10px 30px rgba(24, 50, 84, 0.07);

    margin-bottom: 22px;
}

.application-number {

    display: inline-block;

    background: #eef5ff;
    color: #1768c7;

    padding: 7px 12px;
    border-radius: 20px;

    font-size: 12px;
    font-weight: 800;

    margin-bottom: 14px;
}

.hero h1 {

    margin: 0 0 10px;
    font-size: 32px;
}

.hero p {

    margin: 0;
    color: #68778a;
    line-height: 1.6;
}


/* ==============================
   GRID / CARD
   ============================== */

.grid {

    display: grid;
    grid-template-columns: repeat(2, 1fr);

    gap: 20px;
}

.card {

    background: white;

    border: 1px solid #e4eaf1;
    border-radius: 17px;

    padding: 24px;
}

.card h2,
.card h3 {

    margin-top: 0;
    margin-bottom: 18px;
}

.detail-row {

    display: flex;

    justify-content: space-between;

    gap: 20px;

    border-bottom:
        1px solid #edf0f4;

    padding: 13px 0;
}

.detail-row:last-child {
    border-bottom: none;
}

.label {

    color: #758297;
    font-size: 14px;
}

.value {

    font-weight: 700;
    text-align: right;

    word-break: break-word;
}


/* ==============================
   STATUS
   ============================== */

.status {

    display: inline-block;

    padding: 6px 11px;

    border-radius: 20px;

    font-size: 12px;
    font-weight: 800;
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
    color: #6845b8;
}

.status-query {

    background: #fff2d9;
    color: #986000;
}

.status-approved {

    background: #e8f7ed;
    color: #267a42;
}

.status-rejected {

    background: #ffe9e7;
    color: #c43329;
}


/* ==============================
   REJECTION CARD
   ============================== */

.rejection-card {

    margin-top: 22px;

    background: #fffafa;

    border:
        1px solid #efc8c5;

    border-left:
        5px solid #c43329;
}

.rejection-header {

    display: flex;

    justify-content: space-between;
    align-items: flex-start;

    gap: 15px;

    margin-bottom: 20px;
}

.rejection-header h2 {

    margin: 0 0 6px;

    color: #a92820;
}

.rejection-header p {

    margin: 0;

    color: #785957;

    line-height: 1.6;
}

.rejected-badge {

    display: inline-block;

    background: #ffe4e1;
    color: #b72f26;

    padding: 7px 12px;

    border-radius: 20px;

    font-size: 11px;
    font-weight: 900;

    white-space: nowrap;
}

.rejection-box {

    margin-top: 15px;

    background: white;

    border:
        1px solid #efd8d6;

    border-radius: 12px;

    padding: 18px;
}

.rejection-label {

    color: #8c5b57;

    font-size: 12px;
    font-weight: 900;

    text-transform: uppercase;

    margin-bottom: 8px;
}

.rejection-value {

    color: #3c2928;

    font-size: 15px;
    line-height: 1.7;

    white-space: pre-wrap;
    word-break: break-word;
}

.reapply-yes {

    color: #267a42;
    font-weight: 900;
}

.reapply-no {

    color: #c43329;
    font-weight: 900;
}

.reapply-message {

    margin-top: 18px;

    padding: 16px;

    border-radius: 12px;

    background: #fff6e4;

    border:
        1px solid #f0ddaf;

    color: #755a17;

    line-height: 1.6;
}


/* ==============================
   QUERY
   ============================== */

.query-card {

    margin-top: 22px;

    border:
        1px solid #f0d99d;

    background: #fffdf7;
}

.query-title {

    display: flex;

    justify-content: space-between;
    align-items: flex-start;

    gap: 15px;

    margin-bottom: 18px;
}

.query-title h3 {
    margin: 0;
}

.query-status {

    display: inline-block;

    padding: 6px 10px;

    border-radius: 20px;

    background: #fff0c5;
    color: #8a6000;

    font-size: 11px;
    font-weight: 900;
}

.query-message {

    background: white;

    border:
        1px solid #eadfbf;

    border-radius: 12px;

    padding: 18px;

    color: #37475a;

    line-height: 1.7;

    white-space: pre-wrap;
}

.query-meta {

    display: grid;

    grid-template-columns:
        repeat(2, 1fr);

    gap: 12px;

    margin-top: 15px;
}

.query-meta-box {

    background: white;

    border:
        1px solid #eee6d1;

    border-radius: 10px;

    padding: 13px;
}

.query-meta-label {

    color: #7c8898;

    font-size: 11px;
    font-weight: 800;

    text-transform: uppercase;

    margin-bottom: 5px;
}

.query-meta-value {

    font-size: 14px;
    font-weight: 800;
}

.response-box {

    margin-top: 20px;

    background: white;

    border:
        1px solid #e4eaf1;

    border-radius: 14px;

    padding: 20px;
}

.response-history {

    margin-top: 18px;

    background: #edf8f0;

    border:
        1px solid #d2ead8;

    padding: 17px;

    border-radius: 12px;

    color: #326344;

    line-height: 1.7;
}


/* ==============================
   FORM
   ============================== */

.form-label {

    display: block;

    margin-bottom: 8px;

    font-weight: 800;
    font-size: 14px;
}

.form-control {

    width: 100%;

    border:
        1px solid #d5dee8;

    border-radius: 10px;

    padding: 13px;

    font-family:
        Arial, Helvetica, sans-serif;

    font-size: 14px;

    min-height: 130px;

    resize: vertical;

    outline: none;
}

.form-control:focus {
    border-color: #1677e8;
}


/* ==============================
   READINESS
   ============================== */

.readiness-card {
    margin-top: 22px;
}

.readiness-top {

    display: flex;

    justify-content: space-between;
    align-items: center;

    gap: 15px;
}

.percentage {

    font-size: 28px;
    font-weight: 900;

    color: #1768c7;
}

.progress {

    margin-top: 15px;

    height: 12px;

    border-radius: 20px;

    background: #e8eef5;

    overflow: hidden;
}

.progress-fill {

    height: 100%;

    background: #1677e8;
}

.document-list {

    margin-top: 22px;

    display: grid;

    gap: 11px;
}

.document {

    border:
        1px solid #e5eaf0;

    border-radius: 13px;

    padding: 15px;

    display: flex;

    justify-content: space-between;
    align-items: center;

    gap: 14px;
}

.document-name {

    font-weight: 800;

    margin-bottom: 5px;
}

.document-description {

    color: #68778a;

    font-size: 13px;

    line-height: 1.5;
}

.badge {

    padding: 6px 10px;

    border-radius: 20px;

    font-size: 11px;
    font-weight: 900;

    white-space: nowrap;
}

.ready {

    background: #e8f7ed;
    color: #267a42;
}

.missing {

    background: #fff2d9;
    color: #986000;
}

.rejected {

    background: #ffe9e7;
    color: #c43329;
}

.expired {

    background: #fff2d9;
    color: #986000;
}


/* ==============================
   NEXT ACTION
   ============================== */

.info-box {

    margin-top: 22px;

    background: #eef6ff;

    border:
        1px solid #d9e9fb;

    border-radius: 14px;

    padding: 18px;

    color: #3f648a;

    line-height: 1.6;
}


/* ==============================
   CERTIFICATE
   ============================== */

.certificate {

    margin-top: 22px;

    border:
        1px solid #cbe7d3;

    border-radius: 18px;

    overflow: hidden;

    background: white;
}

.certificate-header {

    padding: 25px;

    background: #edf8f0;

    border-bottom:
        1px solid #d4ead9;
}

.certificate-header h2 {

    margin: 0 0 7px;

    color: #236d3d;
}

.certificate-header p {

    margin: 0;

    color: #567663;

    line-height: 1.6;
}

.certificate-body {
    padding: 25px;
}

.certificate-number {

    background: #f5faf6;

    border:
        1px dashed #a9d2b4;

    padding: 17px;

    border-radius: 12px;

    margin-bottom: 18px;
}

.certificate-number-label {

    color: #6c8172;

    font-size: 11px;
    font-weight: 800;

    text-transform: uppercase;

    margin-bottom: 6px;
}

.certificate-number-value {

    color: #1e6637;

    font-size: 20px;
    font-weight: 900;

    word-break: break-word;
}

.certificate-grid {

    display: grid;

    grid-template-columns:
        repeat(2, 1fr);

    gap: 12px 25px;
}

.certificate-row {

    padding: 12px 0;

    border-bottom:
        1px solid #edf1ee;
}

.certificate-label {

    font-size: 12px;

    color: #7b8b80;

    margin-bottom: 5px;
}

.certificate-value {

    font-size: 14px;
    font-weight: 800;

    color: #243c2c;
}

.certificate-remarks {

    margin-top: 18px;

    padding: 16px;

    background: #f7faf8;

    border-radius: 12px;

    color: #4e6556;

    line-height: 1.7;
}


/* ==============================
   BUTTONS
   ============================== */

.actions {

    margin-top: 25px;

    display: flex;

    gap: 12px;

    flex-wrap: wrap;
}

.primary-btn,
.secondary-btn {

    padding: 13px 20px;

    border-radius: 10px;

    text-decoration: none;

    font-weight: 700;

    display: inline-block;

    font-size: 14px;
}

.primary-btn {

    border: none;

    background: #1677e8;
    color: white;

    cursor: pointer;
}

.primary-btn:hover {
    background: #0f67c8;
}

.secondary-btn {

    background: #eef2f6;
    color: #43546a;
}

.disabled-btn {

    padding: 13px 20px;

    border: none;

    border-radius: 10px;

    background: #abb7c5;
    color: white;

    font-weight: 700;

    cursor: not-allowed;

    opacity: 0.65;
}


/* ==============================
   RESPONSIVE
   ============================== */

@media(max-width: 750px) {

    .grid,
    .certificate-grid,
    .query-meta {

        grid-template-columns: 1fr;
    }

    .readiness-top,
    .rejection-header {

        align-items: flex-start;
        flex-direction: column;
    }

    .topbar {

        padding: 15px 20px;
    }

    .actions {

        flex-direction: column;
    }

    .actions a,
    .actions button,
    .actions form {

        width: 100%;
    }

    .actions button {
        width: 100%;
    }
}


/* ==============================
   PRINT
   ============================== */

@media print {

    .topbar,
    .actions,
    .readiness-card,
    .query-card,
    .rejection-card,
    .info-box,
    .hero,
    .grid {

        display: none !important;
    }

    body {
        background: white;
    }

    .page {
        padding: 20px;
    }

    .certificate {

        border:
            2px solid #333;

        margin: 0;
    }
}

</style>

</head>


<body>


<!-- ==============================
     TOP BAR
     ============================== -->

<div class="topbar">

    <div class="logo">
        CHAPERON
    </div>

    <div class="top-links">

        <a href="<%= request.getContextPath() %>/entrepreneur/dashboard">
            Dashboard
        </a>

        <a href="<%= request.getContextPath() %>/entrepreneur/generate-approvals">
            Approval Roadmap
        </a>

        <a href="<%= request.getContextPath() %>/entrepreneur/my-applications">
            My Applications
        </a>

    </div>

</div>


<div class="page">

<div class="container">


<%
if ("query-responded".equals(success)) {
%>

<div class="alert alert-success">

    Your response has been submitted successfully.
    The application has been sent back to the
    concerned officer for review.

</div>

<%
}
%>


<%
if (message != null &&
    !message.isBlank()) {
%>

<div class="alert alert-warning">

    <%= esc(message) %>

</div>

<%
}
%>


<%
if (userApplication != null) {
%>


<!-- ==============================
     HERO
     ============================== -->

<div class="hero">

    <div class="application-number">

        <%= esc(
                userApplication
                        .getApplicationNumber()
        ) %>

    </div>

    <h1>

        <%= approval != null
                ? esc(
                    approval.getApprovalName()
                  )
                : "Application" %>

    </h1>

    <p>

        Track application progress, officer queries,
        documents, final decision and approval
        certificate from one place.

    </p>

</div>



<!-- ==============================
     APPLICATION + BUSINESS INFO
     ============================== -->

<div class="grid">


<div class="card">

    <h3>
        Application Information
    </h3>


    <div class="detail-row">

        <div class="label">
            Application Number
        </div>

        <div class="value">

            <%= esc(
                    userApplication
                            .getApplicationNumber()
            ) %>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            Current Status
        </div>

        <div class="value">

            <span class="status <%= statusClass %>">

                <%= status != null
                        ? esc(
                            status.replace(
                                "_",
                                " "
                            )
                          )
                        : "DRAFT" %>

            </span>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            SLA
        </div>

        <div class="value">

            <%= userApplication
                    .getSlaDays() != null
                    ? userApplication
                            .getSlaDays()
                            + " Days"
                    : "Not Configured" %>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            Expected Completion
        </div>

        <div class="value">

            <%= userApplication
                    .getExpectedCompletionDate()
                    != null

                    ? esc(
                        userApplication
                            .getExpectedCompletionDate()
                      )

                    : "Not Available" %>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            Risk Level
        </div>

        <div class="value">

            <%= userApplication
                    .getRiskLevel() != null

                    ? esc(
                        userApplication
                            .getRiskLevel()
                      )

                    : "LOW" %>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            Submission Date
        </div>

        <div class="value">

            <%= userApplication
                    .getSubmissionDate() != null

                    ? esc(
                        userApplication
                            .getSubmissionDate()
                      )

                    : "Not Submitted" %>

        </div>

    </div>

</div>



<div class="card">

    <h3>
        Business & Approval
    </h3>


    <div class="detail-row">

        <div class="label">
            Business
        </div>

        <div class="value">

            <%= business != null &&
                business.getBusinessName() != null

                    ? esc(
                        business.getBusinessName()
                      )

                    : "Your Business" %>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            Approval
        </div>

        <div class="value">

            <%= approval != null

                    ? esc(
                        approval.getApprovalName()
                      )

                    : "Approval" %>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            Department
        </div>

        <div class="value">

            <%= approval != null &&
                approval.getDepartmentName() != null

                    ? esc(
                        approval.getDepartmentName()
                      )

                    : "Concerned Department" %>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            Industry
        </div>

        <div class="value">

            <%= business != null &&
                business.getIndustry() != null

                    ? esc(
                        business.getIndustry()
                      )

                    : "Not Available" %>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            Activity
        </div>

        <div class="value">

            <%= business != null &&
                business.getBusinessActivity() != null

                    ? esc(
                        business
                            .getBusinessActivity()
                      )

                    : "Not Available" %>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            Project Stage
        </div>

        <div class="value">

            <%= business != null &&
                business.getProjectStage() != null

                    ? esc(
                        business
                            .getProjectStage()
                      )

                    : "Not Available" %>

        </div>

    </div>

</div>


</div>



<!-- =========================================================
     REJECTION DETAILS
     THIS IS THE MAIN BUG FIX
     ========================================================= -->

<%
if ("REJECTED".equalsIgnoreCase(status)) {

    String rejectionReason =
            userApplication
                    .getRejectionReason();

    String officerRemarks =
            userApplication
                    .getOfficerRemarks();

    Timestamp rejectedAt =
            userApplication
                    .getRejectedAt();

    boolean canReapply =
            userApplication
                    .isCanReapply();
%>


<div class="card rejection-card">

    <div class="rejection-header">

        <div>

            <h2>
                Application Rejected
            </h2>

            <p>

                The concerned officer has rejected
                this application. Review the reason
                below before taking the next action.

            </p>

        </div>

        <span class="rejected-badge">
            REJECTED
        </span>

    </div>


    <!-- REJECTION REASON -->

    <div class="rejection-box">

        <div class="rejection-label">
            Rejection Reason
        </div>

        <div class="rejection-value">

            <%= rejectionReason != null &&
                !rejectionReason.isBlank()

                    ? esc(rejectionReason)

                    : "No rejection reason was provided." %>

        </div>

    </div>


    <!-- OFFICER REMARKS -->

    <div class="rejection-box">

        <div class="rejection-label">
            Officer Remarks
        </div>

        <div class="rejection-value">

            <%= officerRemarks != null &&
                !officerRemarks.isBlank()

                    ? esc(officerRemarks)

                    : "No additional officer remarks." %>

        </div>

    </div>


    <!-- REJECTED DATE -->

    <div class="rejection-box">

        <div class="rejection-label">
            Rejected On
        </div>

        <div class="rejection-value">

            <%= rejectedAt != null

                    ? esc(rejectedAt)

                    : "Not Available" %>

        </div>

    </div>


    <!-- REAPPLY PERMISSION -->

    <div class="rejection-box">

        <div class="rejection-label">
            Reapplication Permission
        </div>


        <%
        if (canReapply) {
        %>

        <div class="reapply-yes">

            YES — You are allowed to reapply
            after correcting the issue.

        </div>

        <%
        } else {
        %>

        <div class="reapply-no">

            NO — Reapplication is currently
            not permitted for this application.

        </div>

        <%
        }
        %>

    </div>


    <%
    if (canReapply) {
    %>

    <div class="reapply-message">

        <strong>
            What should you do next?
        </strong>

        <br><br>

        Review the rejection reason carefully.
        Correct the information or documents
        mentioned by the officer, then return
        to your Approval Roadmap for the
        next available action.

    </div>

    <div class="actions">

        <a class="primary-btn"
           href="<%= request.getContextPath() %>/entrepreneur/documents">

            Manage Documents

        </a>

        <a class="secondary-btn"
           href="<%= request.getContextPath() %>/entrepreneur/generate-approvals">

            Go to Approval Roadmap

        </a>

    </div>

    <%
    }
    %>

</div>


<%
}
%>



<!-- ==============================
     OFFICER QUERY
     ============================== -->

<%
if (queryId != null) {
%>

<div class="card query-card">

    <div class="query-title">

        <div>

            <h3>
                Officer Query
            </h3>

            <div style="
                color:#7a8797;
                font-size:13px;
                margin-top:6px;">

                The concerned department has
                requested additional information.

            </div>

        </div>


        <span class="query-status">

            <%= queryStatus != null
                    ? esc(queryStatus)
                    : "OPEN" %>

        </span>

    </div>


    <div class="query-message">

        <%= queryDescription != null
                ? esc(queryDescription)
                : "No description available." %>

    </div>


    <div class="query-meta">


        <div class="query-meta-box">

            <div class="query-meta-label">
                Raised On
            </div>

            <div class="query-meta-value">

                <%= queryRaisedDate != null
                        ? esc(queryRaisedDate)
                        : "Not Available" %>

            </div>

        </div>


        <div class="query-meta-box">

            <div class="query-meta-label">
                Response Deadline
            </div>

            <div class="query-meta-value">

                <%= queryResponseDeadline != null
                        ? esc(queryResponseDeadline)
                        : "No Deadline" %>

            </div>

        </div>

    </div>



    <!-- OPEN QUERY RESPONSE FORM -->

    <%
    if ("OPEN".equalsIgnoreCase(queryStatus)) {
    %>


    <div class="response-box">

        <h3>
            Respond to Officer
        </h3>

        <p style="
            color:#68778a;
            line-height:1.6;">

            Provide a clear response to the
            officer's query.

            If a corrected document is required,
            upload it from Document Vault before
            responding.

        </p>


        <form method="post"
              action="<%= request.getContextPath() %>/entrepreneur/respond-query">


            <input type="hidden"
                   name="queryId"
                   value="<%= queryId %>">


            <input type="hidden"
                   name="applicationId"
                   value="<%= userApplication.getApplicationId() %>">


            <label class="form-label">
                Your Response *
            </label>


            <textarea
                name="entrepreneurResponse"
                class="form-control"
                maxlength="3000"
                required
                placeholder="Enter your response to the officer."></textarea>


            <div class="actions">

                <button type="submit"
                        class="primary-btn">

                    Submit Response

                </button>


                <a class="secondary-btn"
                   href="<%= request.getContextPath() %>/entrepreneur/documents">

                    Manage Documents

                </a>

            </div>

        </form>

    </div>


    <%
    }
    %>



    <!-- RESPONSE HISTORY -->

    <%
    if ("RESPONDED".equalsIgnoreCase(queryStatus) ||
        "RESOLVED".equalsIgnoreCase(queryStatus)) {
    %>


    <div class="response-history">

        <strong>
            Your Response
        </strong>

        <br><br>


        <%= entrepreneurResponse != null
                ? esc(entrepreneurResponse)
                : "Response submitted." %>


        <%
        if (queryRespondedAt != null) {
        %>

        <br><br>

        <small>

            Responded on:
            <%= esc(queryRespondedAt) %>

        </small>

        <%
        }
        %>


        <%
        if ("RESOLVED"
                .equalsIgnoreCase(queryStatus)) {
        %>

        <br><br>

        <strong>
            Query Resolved
        </strong>


        <%
        if (queryResolvedAt != null) {
        %>

        <br>

        <small>

            Resolved on:
            <%= esc(queryResolvedAt) %>

        </small>

        <%
        }
        %>


        <%
        }
        %>

    </div>


    <%
    }
    %>


</div>


<%
}
%>



<!-- ==============================
     DOCUMENT READINESS
     ============================== -->

<div class="card readiness-card">

    <div class="readiness-top">

        <div>

            <h3 style="margin-bottom:5px;">
                Application Readiness
            </h3>

            <div style="
                color:#68778a;
                font-size:14px;">

                Mandatory documents available
                for this application.

            </div>

        </div>


        <div class="percentage">

            <%= readinessPercentage %>%

        </div>

    </div>


    <div class="progress">

        <div class="progress-fill"
             style="width:<%= readinessPercentage %>%;">

        </div>

    </div>


    <%
    if (documentReadinessList != null &&
        !documentReadinessList.isEmpty()) {
    %>


    <div class="document-list">


    <%
    for (
        DocumentReadiness document
        : documentReadinessList
    ) {

        String documentStatus =
                document.getStatus();

        String badgeClass =
                "missing";


        if ("READY"
                .equalsIgnoreCase(
                        documentStatus
                )) {

            badgeClass =
                    "ready";

        } else if ("REJECTED"
                .equalsIgnoreCase(
                        documentStatus
                )) {

            badgeClass =
                    "rejected";

        } else if ("EXPIRED"
                .equalsIgnoreCase(
                        documentStatus
                )) {

            badgeClass =
                    "expired";
        }


        String documentName =
                document.getDocumentType();

        if (documentName != null) {

            documentName =
                    documentName.replace(
                            "_",
                            " "
                    );
        }
    %>


    <div class="document">

        <div>

            <div class="document-name">

                <%= documentName != null
                        ? esc(documentName)
                        : "Document" %>

            </div>


            <div class="document-description">

                <%= document
                        .getDescription() != null

                        ? esc(
                            document
                                .getDescription()
                          )

                        : "Required document" %>


                <%
                if (document
                        .getUploadedFileName()
                        != null) {
                %>

                <br>

                File:

                <strong>

                    <%= esc(
                            document
                                .getUploadedFileName()
                    ) %>

                </strong>

                <%
                }
                %>

            </div>

        </div>


        <span class="badge <%= badgeClass %>">

            <%= documentStatus != null
                    ? esc(documentStatus)
                    : "MISSING" %>

        </span>

    </div>


    <%
    }
    %>


    </div>


    <%
    } else {
    %>


    <div class="info-box">

        No document requirements have been
        configured for this approval.

    </div>


    <%
    }
    %>


</div>



<!-- ==============================
     APPROVAL CERTIFICATE
     ============================== -->

<%
if ("APPROVED".equalsIgnoreCase(status) &&
    certificateId != null) {
%>


<div class="certificate"
     id="approvalCertificate">


    <div class="certificate-header">

        <h2>
            Approval Certificate
        </h2>

        <p>

            This application has been approved
            by the concerned government department.

        </p>

    </div>


    <div class="certificate-body">


        <div class="certificate-number">

            <div class="certificate-number-label">
                Approval Number
            </div>

            <div class="certificate-number-value">

                <%= certificateApprovalNumber != null

                        ? esc(
                            certificateApprovalNumber
                          )

                        : "Not Available" %>

            </div>

        </div>



        <div class="certificate-grid">


            <div class="certificate-row">

                <div class="certificate-label">
                    Application Number
                </div>

                <div class="certificate-value">

                    <%= esc(
                            userApplication
                                .getApplicationNumber()
                    ) %>

                </div>

            </div>


            <div class="certificate-row">

                <div class="certificate-label">
                    Approval
                </div>

                <div class="certificate-value">

                    <%= approval != null

                            ? esc(
                                approval
                                    .getApprovalName()
                              )

                            : "Approval" %>

                </div>

            </div>


            <div class="certificate-row">

                <div class="certificate-label">
                    Business
                </div>

                <div class="certificate-value">

                    <%= business != null &&
                        business.getBusinessName()
                        != null

                            ? esc(
                                business
                                    .getBusinessName()
                              )

                            : "Your Business" %>

                </div>

            </div>


            <div class="certificate-row">

                <div class="certificate-label">
                    Department
                </div>

                <div class="certificate-value">

                    <%= approval != null &&
                        approval.getDepartmentName()
                        != null

                            ? esc(
                                approval
                                    .getDepartmentName()
                              )

                            : "Concerned Department" %>

                </div>

            </div>


            <div class="certificate-row">

                <div class="certificate-label">
                    Approved By
                </div>

                <div class="certificate-value">

                    <%= certificateApprovedByName
                            != null

                            ? esc(
                                certificateApprovedByName
                              )

                            : "Authorized Officer" %>

                </div>

            </div>


            <div class="certificate-row">

                <div class="certificate-label">
                    Approval Date
                </div>

                <div class="certificate-value">

                    <%= certificateApprovalDate
                            != null

                            ? esc(
                                certificateApprovalDate
                              )

                            : "Not Available" %>

                </div>

            </div>


            <div class="certificate-row">

                <div class="certificate-label">
                    Valid From
                </div>

                <div class="certificate-value">

                    <%= certificateValidFrom
                            != null

                            ? esc(
                                certificateValidFrom
                              )

                            : "Not Available" %>

                </div>

            </div>


            <div class="certificate-row">

                <div class="certificate-label">
                    Valid Until
                </div>

                <div class="certificate-value">

                    <%= certificateValidUntil
                            != null

                            ? esc(
                                certificateValidUntil
                              )

                            : "Permanent / As Applicable" %>

                </div>

            </div>

        </div>


        <%
        if (certificateRemarks != null &&
            !certificateRemarks.isBlank()) {
        %>


        <div class="certificate-remarks">

            <strong>
                Remarks
            </strong>

            <br><br>

            <%= esc(certificateRemarks) %>

        </div>


        <%
        }
        %>


        <div class="actions">

            <button type="button"
                    class="primary-btn"
                    onclick="window.print();">

                Print / Save Certificate

            </button>

        </div>


    </div>

</div>


<%
}
%>



<!-- ==============================
     NEXT ACTION
     ============================== -->

<div class="info-box">

    <strong>
        Your Next Step
    </strong>

    <br><br>


    <%
    if ("DRAFT".equalsIgnoreCase(status)) {
    %>

        Complete all mandatory document
        requirements and submit this application.


    <%
    } else if ("SUBMITTED"
            .equalsIgnoreCase(status)) {
    %>

        Your application has been submitted.
        Wait for the concerned department
        to begin its review.


    <%
    } else if ("UNDER_REVIEW"
            .equalsIgnoreCase(status)) {
    %>

        Your application is currently being
        reviewed by the concerned officer.


    <%
    } else if ("QUERY_RAISED"
            .equalsIgnoreCase(status)) {
    %>

        An officer has requested additional
        information. Review the query above
        and submit your response before the
        deadline.


    <%
    } else if ("APPROVED"
            .equalsIgnoreCase(status)) {
    %>

        Congratulations. Your application
        has been approved.

        <%
        if (certificateId != null) {
        %>

        Your approval certificate is available
        above. You can print it or save it as PDF.

        <%
        }
        %>


    <%
    } else if ("REJECTED"
            .equalsIgnoreCase(status)) {
    %>

        This application has been rejected.

        Review the detailed rejection reason
        shown above.

        <%
        if (userApplication.isCanReapply()) {
        %>

        Correct the mentioned issue before
        starting the reapplication process.

        <%
        } else {
        %>

        Reapplication is currently not permitted.

        <%
        }
        %>


    <%
    } else {
    %>

        Your application is currently

        <strong>

            <%= status != null
                    ? esc(
                        status.replace(
                            "_",
                            " "
                        )
                      )
                    : "PROCESSING" %>

        </strong>.

    <%
    }
    %>

</div>



<!-- ==============================
     ACTION BUTTONS
     ============================== -->

<div class="actions">


    <%
    if ("DRAFT".equalsIgnoreCase(status) &&
        readinessPercentage == 100) {
    %>


    <form method="post"
          action="<%= request.getContextPath() %>/entrepreneur/submit-application"
          style="margin:0;">


        <input type="hidden"
               name="applicationId"
               value="<%= userApplication.getApplicationId() %>">


        <button type="submit"
                class="primary-btn">

            Submit Application

        </button>

    </form>


    <%
    } else if ("DRAFT"
            .equalsIgnoreCase(status)) {
    %>


    <button type="button"
            class="disabled-btn"
            disabled>

        Submit Application

    </button>


    <%
    }
    %>



    <a class="secondary-btn"
       href="<%= request.getContextPath() %>/entrepreneur/documents">

        Manage Documents

    </a>



    <%
    if (approval != null) {
    %>


    <a class="secondary-btn"
       href="<%= request.getContextPath() %>/entrepreneur/approval-details?id=<%= approval.getApprovalId() %>">

        Approval Details

    </a>


    <%
    }
    %>



    <%
    if ("APPROVED".equalsIgnoreCase(status) &&
        certificateId != null) {
    %>


    <a class="primary-btn"
       href="#approvalCertificate">

        View Certificate

    </a>


    <%
    }
    %>



    <a class="secondary-btn"
       href="<%= request.getContextPath() %>/entrepreneur/my-applications">

        My Applications

    </a>


    <a class="secondary-btn"
       href="<%= request.getContextPath() %>/entrepreneur/generate-approvals">

        Back to Roadmap

    </a>


</div>


<%
} else {
%>


<div class="hero">

    <h1>
        Application Not Available
    </h1>

    <p>

        Application information could not
        be loaded.

    </p>


    <div class="actions">

        <a class="primary-btn"
           href="<%= request.getContextPath() %>/entrepreneur/my-applications">

            My Applications

        </a>

    </div>

</div>


<%
}
%>


</div>
</div>


</body>
</html>