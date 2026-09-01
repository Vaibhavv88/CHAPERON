<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>

<%@ page import="com.chaperon.model.Application" %>
<%@ page import="com.chaperon.model.Approval" %>
<%@ page import="com.chaperon.model.Business" %>
<%@ page import="com.chaperon.model.BusinessApproval" %>
<%@ page import="com.chaperon.model.DocumentReadiness" %>


<%
    Approval approval =
            (Approval)
            request.getAttribute(
                    "approval"
            );

    Business business =
            (Business)
            request.getAttribute(
                    "business"
            );

    BusinessApproval businessApproval =
            (BusinessApproval)
            request.getAttribute(
                    "businessApproval"
            );

    List<DocumentReadiness>
            documentReadinessList =
            (List<DocumentReadiness>)
            request.getAttribute(
                    "documentReadinessList"
            );

    Integer readinessPercentage =
            (Integer)
            request.getAttribute(
                    "readinessPercentage"
            );

    if (readinessPercentage == null) {

        readinessPercentage = 0;
    }


    /*
     * IMPORTANT
     *
     * Existing application yahan receive ho rahi hai.
     */

    Application currentApplication =
            (Application)
            request.getAttribute(
                    "currentApplication"
            );


    String applicationError =
            request.getParameter(
                    "applicationError"
            );
%>


<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    Approval Details | CHAPERON
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


/* =========================================
   TOP BAR
   ========================================= */

.topbar {

    min-height: 70px;

    background: white;

    border-bottom:
        1px solid #e5eaf0;

    display: flex;

    align-items: center;

    justify-content:
        space-between;

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


/* =========================================
   PAGE
   ========================================= */

.page {

    padding:
        45px 20px 70px;
}

.container {

    max-width: 1050px;

    margin: auto;
}


/* =========================================
   HERO
   ========================================= */

.hero {

    background: white;

    border:
        1px solid #e5eaf1;

    border-radius: 20px;

    padding: 35px;

    box-shadow:
        0 10px 30px
        rgba(24,50,84,0.07);

    margin-bottom: 24px;
}

.approval-code {

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

    margin: 0 0 12px;

    font-size: 34px;
}

.department {

    margin: 0 0 12px;

    color: #1768c7;

    font-weight: 700;
}

.description {

    color: #66768a;

    font-size: 16px;

    line-height: 1.65;

    margin: 0;
}


/* =========================================
   GRID
   ========================================= */

.grid {

    display: grid;

    grid-template-columns:
        repeat(2,1fr);

    gap: 20px;
}


/* =========================================
   CARDS
   ========================================= */

.card {

    background: white;

    border:
        1px solid #e4eaf1;

    border-radius: 17px;

    padding: 24px;
}

.card h3 {

    margin-top: 0;

    margin-bottom: 18px;

    font-size: 19px;
}


/* =========================================
   DETAILS
   ========================================= */

.detail-row {

    display: flex;

    justify-content:
        space-between;

    gap: 20px;

    padding: 13px 0;

    border-bottom:
        1px solid #edf0f4;
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
}

.yes {

    color: #267a42;
}

.no {

    color: #68778a;
}


/* =========================================
   EXISTING APPLICATION
   ========================================= */

.application-card {

    margin-top: 22px;

    border:
        1px solid #cfe2ff;

    background:
        #f8fbff;
}

.application-header {

    display: flex;

    align-items: flex-start;

    justify-content:
        space-between;

    gap: 15px;

    flex-wrap: wrap;
}

.application-status {

    display: inline-block;

    padding: 7px 11px;

    border-radius: 20px;

    font-size: 11px;

    font-weight: 900;

    background: #e8f2ff;

    color: #1768c7;
}

.query-status {

    background: #fff2d9;

    color: #986000;
}

.review-status {

    background: #eee9ff;

    color: #6749a7;
}


/* =========================================
   REASON CARD
   ========================================= */

.reason-card {

    margin-top: 22px;
}

.reason-card p {

    margin: 0;

    color: #5e6e82;

    line-height: 1.7;
}


/* =========================================
   READINESS
   ========================================= */

.readiness-card {

    margin-top: 22px;
}

.readiness-top {

    display: flex;

    justify-content:
        space-between;

    gap: 20px;

    align-items: center;

    margin-bottom: 16px;
}

.readiness-percentage {

    font-size: 28px;

    font-weight: 900;

    color: #1768c7;
}

.progress-track {

    width: 100%;

    height: 12px;

    background: #e8eef5;

    border-radius: 20px;

    overflow: hidden;

    margin-bottom: 24px;
}

.progress-fill {

    height: 100%;

    background: #1677e8;

    border-radius: 20px;
}


/* =========================================
   DOCUMENT LIST
   ========================================= */

.document-list {

    display: grid;

    gap: 12px;
}

.document-item {

    display: flex;

    gap: 14px;

    align-items: flex-start;

    border:
        1px solid #e5eaf0;

    border-radius: 14px;

    padding: 16px;

    background: #fafcff;
}

.document-icon {

    width: 38px;

    height: 38px;

    min-width: 38px;

    border-radius: 11px;

    display: flex;

    align-items: center;

    justify-content: center;

    font-weight: 900;

    font-size: 17px;
}

.icon-ready {

    background: #e8f7ed;

    color: #267a42;
}

.icon-missing {

    background: #fff2d9;

    color: #986000;
}

.icon-rejected {

    background: #ffe9e7;

    color: #c43329;
}

.icon-expired {

    background: #fff2d9;

    color: #986000;
}

.document-content {

    flex: 1;
}

.document-title-row {

    display: flex;

    justify-content:
        space-between;

    gap: 12px;

    align-items: flex-start;

    flex-wrap: wrap;
}

.document-title {

    font-weight: 800;

    color: #20324a;
}

.document-description {

    margin-top: 6px;

    color: #68778a;

    line-height: 1.55;

    font-size: 14px;
}

.file-name {

    margin-top: 8px;

    font-size: 13px;

    color: #46566b;
}


/* =========================================
   BADGES
   ========================================= */

.status-badge {

    display: inline-block;

    padding: 6px 10px;

    border-radius: 20px;

    font-size: 11px;

    font-weight: 900;
}

.status-ready {

    background: #e8f7ed;

    color: #267a42;
}

.status-missing {

    background: #fff2d9;

    color: #986000;
}

.status-rejected {

    background: #ffe9e7;

    color: #c43329;
}

.status-expired {

    background: #fff2d9;

    color: #986000;
}

.mandatory-badge {

    background: #f2eefe;

    color: #6246a8;

    padding: 5px 9px;

    border-radius: 20px;

    font-size: 11px;

    font-weight: 800;
}

.optional-badge {

    background: #eef2f6;

    color: #56667a;

    padding: 5px 9px;

    border-radius: 20px;

    font-size: 11px;

    font-weight: 800;
}

.badge-group {

    display: flex;

    gap: 7px;

    flex-wrap: wrap;
}


/* =========================================
   INFO BOX
   ========================================= */

.info-box {

    margin-top: 22px;

    background: #eef6ff;

    border:
        1px solid #d9e9fb;

    border-radius: 14px;

    padding: 18px;

    line-height: 1.7;

    color: #3f648a;
}


/* =========================================
   ERROR
   ========================================= */

.error-box {

    margin-bottom: 22px;

    background: #fff1f0;

    border:
        1px solid #ffd4d1;

    color: #b52d26;

    border-radius: 14px;

    padding: 16px 18px;

    font-weight: 700;
}


/* =========================================
   BUTTONS
   ========================================= */

.actions {

    margin-top: 28px;

    display: flex;

    gap: 12px;

    flex-wrap: wrap;

    align-items: center;
}

.primary-btn,
.secondary-btn,
.disabled-btn {

    text-decoration: none;

    padding: 13px 20px;

    border-radius: 10px;

    font-weight: 700;

    display: inline-block;

    font-size: 14px;
}

.primary-btn {

    background: #1677e8;

    color: white;

    border: none;

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

    background: #aab6c4;

    color: white;

    border: none;

    cursor: not-allowed;

    opacity: 0.65;
}

.application-note {

    margin-top: 10px;

    font-size: 13px;

    color: #68778a;
}


/* =========================================
   EMPTY
   ========================================= */

.empty {

    text-align: center;

    border:
        1px dashed #cad5e2;

    border-radius: 14px;

    padding: 26px;

    color: #68778a;
}


/* =========================================
   RESPONSIVE
   ========================================= */

@media(max-width:750px) {

    .grid {

        grid-template-columns: 1fr;
    }

    .hero {

        padding: 26px;
    }

    .hero h1 {

        font-size: 28px;
    }

    .readiness-top {

        align-items:
            flex-start;
    }

    .actions {

        flex-direction: column;

        align-items: stretch;
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

</style>

</head>


<body>


<!-- =========================================
     TOP BAR
     ========================================= -->

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

    </div>

</div>


<div class="page">

<div class="container">


<!-- =========================================
     START APPLICATION ERROR
     ========================================= -->

<%
if ("documents".equals(applicationError)) {
%>

<div class="error-box">

    Application start nahi ho sakti.
    Pehle saare mandatory documents upload karo.

</div>

<%
}
%>


<%
if (approval != null) {
%>


<!-- =========================================
     APPROVAL HERO
     ========================================= -->

<div class="hero">


    <div class="approval-code">

        <%= approval.getApprovalCode() != null
                ? approval.getApprovalCode()
                : "APPROVAL" %>

    </div>


    <h1>

        <%= approval.getApprovalName() %>

    </h1>


    <p class="department">

        Department:

        <%= approval.getDepartmentName() != null
                ? approval.getDepartmentName()
                : "Concerned Government Department" %>

    </p>


    <p class="description">

        <%= approval.getDescription() != null
                ? approval.getDescription()
                : "Approval information is currently being maintained by the concerned department." %>

    </p>

</div>


<!-- =========================================
     EXISTING APPLICATION CARD
     ========================================= -->

<%
if (currentApplication != null) {

    String existingStatus =
            currentApplication
                    .getCurrentStatus();

    String existingStatusClass =
            "application-status";

    if ("QUERY_RAISED"
            .equalsIgnoreCase(
                    existingStatus
            )) {

        existingStatusClass +=
                " query-status";

    } else if (
            "UNDER_REVIEW"
            .equalsIgnoreCase(
                    existingStatus
            )
    ) {

        existingStatusClass +=
                " review-status";
    }
%>


<div class="card application-card">


    <div class="application-header">


        <div>

            <h3 style="margin-bottom:7px;">

                Existing Application

            </h3>


            <div style="
                 color:#68778a;
                 font-size:14px;">

                Application Number:

                <strong>

                    <%= currentApplication
                            .getApplicationNumber() %>

                </strong>

            </div>

        </div>


        <span class="<%= existingStatusClass %>">

            <%= existingStatus != null
                    ? existingStatus.replace(
                            "_",
                            " "
                    )
                    : "PROCESSING" %>

        </span>


    </div>


    <div style="
         margin-top:18px;
         color:#516174;
         line-height:1.7;">


        <%
        if ("QUERY_RAISED"
                .equalsIgnoreCase(
                        existingStatus
                )) {
        %>

            The concerned officer has raised a query
            on this application.

            Please open the application and submit
            your response.


        <%
        } else if (
                "UNDER_REVIEW"
                .equalsIgnoreCase(
                        existingStatus
                )
        ) {
        %>

            Your application is currently being
            reviewed by the concerned department.


        <%
        } else if (
                "SUBMITTED"
                .equalsIgnoreCase(
                        existingStatus
                )
        ) {
        %>

            Your application has already been
            submitted and is waiting for review.


        <%
        } else if (
                "DRAFT"
                .equalsIgnoreCase(
                        existingStatus
                )
        ) {
        %>

            You already started this application.
            Continue the existing application instead
            of creating another one.


        <%
        } else {
        %>

            An existing application is already
            available for this approval.

        <%
        }
        %>


    </div>


</div>


<%
}
%>


<!-- =========================================
     PROCESSING + VALIDITY
     ========================================= -->

<div class="grid"
     style="margin-top:22px;">


<div class="card">


    <h3>
        Processing & Application Status
    </h3>


    <%
    if (businessApproval != null) {
    %>


    <div class="detail-row">

        <div class="label">
            Requirement
        </div>

        <div class="value">

            <%= businessApproval
                    .getRequirementStatus()
                    != null
                    ? businessApproval
                            .getRequirementStatus()
                    : "RECOMMENDED" %>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            Priority
        </div>

        <div class="value">

            <%= businessApproval
                    .getPriorityLevel()
                    != null
                    ? businessApproval
                            .getPriorityLevel()
                    : "MEDIUM" %>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            Recommendation Status
        </div>

        <div class="value">

            <%= businessApproval
                    .getCurrentStatus()
                    != null
                    ? businessApproval
                            .getCurrentStatus()
                            .replace(
                                    "_",
                                    " "
                            )
                    : "NOT STARTED" %>

        </div>

    </div>


    <%
    }
    %>


    <div class="detail-row">

        <div class="label">
            Estimated Processing Time
        </div>

        <div class="value">

            <%
            Integer minDays =
                    approval
                            .getMinimumProcessingDays();

            Integer maxDays =
                    approval
                            .getMaximumProcessingDays();

            if (minDays != null &&
                maxDays != null) {
            %>

                <%= minDays %>
                -
                <%= maxDays %>
                Days

            <%
            } else if (maxDays != null) {
            %>

                Up to
                <%= maxDays %>
                Days

            <%
            } else if (minDays != null) {
            %>

                From
                <%= minDays %>
                Days

            <%
            } else {
            %>

                Configurable

            <%
            }
            %>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            SLA
        </div>

        <div class="value">

            <%= approval.getSlaDays() != null
                    ? approval.getSlaDays()
                            + " Days"
                    : "Not Configured" %>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            Inspection Required
        </div>

        <div class="value
             <%= approval.isInspectionRequired()
                     ? "yes"
                     : "no" %>">

            <%= approval.isInspectionRequired()
                    ? "Yes"
                    : "No" %>

        </div>

    </div>


</div>


<div class="card">


    <h3>
        Validity & Renewal
    </h3>


    <div class="detail-row">

        <div class="label">
            Validity Type
        </div>

        <div class="value">

            <%= approval.getValidityType() != null
                    ? approval.getValidityType()
                            .replace(
                                    "_",
                                    " "
                            )
                    : "Not Configured" %>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            Validity
        </div>

        <div class="value">

            <%
            String validityType =
                    approval.getValidityType();

            Integer validityValue =
                    approval.getValidityValue();

            if ("PERMANENT"
                    .equalsIgnoreCase(
                            validityType
                    )) {
            %>

                Permanent

            <%
            } else if (
                    validityValue != null &&
                    validityType != null
            ) {
            %>

                <%= validityValue %>

                <%= validityType
                        .replace(
                                "_",
                                " "
                        ) %>

            <%
            } else {
            %>

                As per approval conditions

            <%
            }
            %>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            Renewal Required
        </div>

        <div class="value
             <%= approval.isRenewalRequired()
                     ? "yes"
                     : "no" %>">

            <%= approval.isRenewalRequired()
                    ? "Yes"
                    : "No" %>

        </div>

    </div>


    <%
    if (approval.isRenewalRequired()) {
    %>


    <div class="detail-row">

        <div class="label">
            Renew Before Expiry
        </div>

        <div class="value">

            <%= approval
                    .getRenewalBeforeDays()
                    != null
                    ? approval
                            .getRenewalBeforeDays()
                            + " Days"
                    : "As notified" %>

        </div>

    </div>


    <%
    }
    %>


    <%
    if (business != null) {
    %>


    <div class="detail-row">

        <div class="label">
            Business
        </div>

        <div class="value">

            <%= business.getBusinessName()
                    != null
                    ? business.getBusinessName()
                    : "Your Business" %>

        </div>

    </div>


    <div class="detail-row">

        <div class="label">
            Project Stage
        </div>

        <div class="value">

            <%= business.getProjectStage()
                    != null
                    ? business.getProjectStage()
                    : "Not Available" %>

        </div>

    </div>


    <%
    }
    %>


</div>

</div>


<!-- =========================================
     WHY RECOMMENDED
     ========================================= -->

<%
if (businessApproval != null &&
    businessApproval.getReasonText()
            != null &&
    !businessApproval.getReasonText()
            .isBlank()) {
%>


<div class="card reason-card">

    <h3>
        Why does your business need this?
    </h3>

    <p>

        <%= businessApproval
                .getReasonText() %>

    </p>

</div>


<%
}
%>


<!-- =========================================
     DOCUMENT READINESS
     ========================================= -->

<div class="card readiness-card">


    <div class="readiness-top">


        <div>

            <h3 style="margin-bottom:6px;">

                Document Readiness

            </h3>

            <div style="
                 color:#68778a;
                 font-size:14px;">

                Mandatory documents currently
                available in your Document Vault.

            </div>

        </div>


        <div class="readiness-percentage">

            <%= readinessPercentage %>%

        </div>


    </div>


    <div class="progress-track">

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

        String statusClass =
                "status-missing";

        String iconClass =
                "icon-missing";

        String iconText =
                "!";


        if ("READY"
                .equalsIgnoreCase(
                        documentStatus
                )) {

            statusClass =
                    "status-ready";

            iconClass =
                    "icon-ready";

            iconText =
                    "✓";

        } else if (
                "REJECTED"
                .equalsIgnoreCase(
                        documentStatus
                )
        ) {

            statusClass =
                    "status-rejected";

            iconClass =
                    "icon-rejected";

            iconText =
                    "×";

        } else if (
                "EXPIRED"
                .equalsIgnoreCase(
                        documentStatus
                )
        ) {

            statusClass =
                    "status-expired";

            iconClass =
                    "icon-expired";

            iconText =
                    "!";
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


    <div class="document-item">


        <div class="document-icon <%= iconClass %>">

            <%= iconText %>

        </div>


        <div class="document-content">


            <div class="document-title-row">


                <div class="document-title">

                    <%= documentName != null
                            ? documentName
                            : "Required Document" %>

                </div>


                <div class="badge-group">


                    <%
                    if (document.isMandatory()) {
                    %>

                    <span class="mandatory-badge">

                        MANDATORY

                    </span>

                    <%
                    } else {
                    %>

                    <span class="optional-badge">

                        OPTIONAL

                    </span>

                    <%
                    }
                    %>


                    <span class="status-badge <%= statusClass %>">

                        <%= documentStatus != null
                                ? documentStatus
                                : "MISSING" %>

                    </span>


                </div>


            </div>


            <div class="document-description">

                <%= document.getDescription()
                        != null
                        ? document.getDescription()
                        : "Document required for this approval." %>

            </div>


            <%
            if (document.getUploadedFileName()
                    != null) {
            %>


            <div class="file-name">

                Uploaded File:

                <strong>

                    <%= document
                            .getUploadedFileName() %>

                </strong>

            </div>


            <%
            }
            %>


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

        No document requirements are currently
        configured for this approval.

    </div>


    <%
    }
    %>


</div>


<!-- =========================================
     NEXT STEP
     ========================================= -->

<div class="info-box">


    <strong>

        What should you do next?

    </strong>


    <br><br>


    <%
    /*
     * ==========================================
     * EXISTING APPLICATION
     * ==========================================
     */

    if (currentApplication != null) {

        String currentStatus =
                currentApplication
                        .getCurrentStatus();


        if ("QUERY_RAISED"
                .equalsIgnoreCase(
                        currentStatus
                )) {
    %>


        The concerned officer has raised
        a query on your application.

        <strong>
            Open the existing application
            and respond to the officer.
        </strong>


    <%
        } else if (
                "UNDER_REVIEW"
                .equalsIgnoreCase(
                        currentStatus
                )
        ) {
    %>


        Your application is currently

        <strong>
            under review
        </strong>

        by the concerned department.


    <%
        } else if (
                "SUBMITTED"
                .equalsIgnoreCase(
                        currentStatus
                )
        ) {
    %>


        Your application has already
        been submitted.

        It is waiting for review by
        the concerned department.


    <%
        } else if (
                "DRAFT"
                .equalsIgnoreCase(
                        currentStatus
                )
        ) {
    %>


        You already started this application.

        Continue the existing application
        instead of creating another one.


    <%
        } else {
    %>


        An application already exists
        for this approval.

        Current status:

        <strong>

            <%= currentStatus != null
                    ? currentStatus.replace(
                            "_",
                            " "
                    )
                    : "PROCESSING" %>

        </strong>


    <%
        }


    /*
     * ==========================================
     * NO APPLICATION + READY
     * ==========================================
     */

    } else if (
            readinessPercentage == 100
    ) {
    %>


        All mandatory documents are available.

        You can now start your application.


    <%
    /*
     * ==========================================
     * NO APPLICATION + NOT READY
     * ==========================================
     */

    } else {
    %>


        Upload all missing mandatory documents.

        Once document readiness reaches

        <strong>
            100%
        </strong>,

        the Start Application button
        will become available.


    <%
    }
    %>


</div>


<!-- =========================================
     ACTIONS
     ========================================= -->

<div class="actions">


    <%
    /*
     * ==========================================
     * EXISTING APPLICATION BUTTON
     * ==========================================
     */

    if (currentApplication != null) {

        String currentStatus =
                currentApplication
                        .getCurrentStatus();
    %>


    <a class="primary-btn"
       href="<%= request.getContextPath() %>/entrepreneur/application-details?id=<%= currentApplication.getApplicationId() %>">


        <%
        if ("QUERY_RAISED"
                .equalsIgnoreCase(
                        currentStatus
                )) {
        %>

            Respond to Officer Query

        <%
        } else if (
                "DRAFT"
                .equalsIgnoreCase(
                        currentStatus
                )
        ) {
        %>

            Continue Application

        <%
        } else {
        %>

            View Application

        <%
        }
        %>


    </a>


    <%
    /*
     * ==========================================
     * NO APPLICATION + DOCUMENTS READY
     * ==========================================
     */

    } else if (
            readinessPercentage == 100
    ) {
    %>


    <form method="post"
          action="<%= request.getContextPath() %>/entrepreneur/start-application"
          style="margin:0;">


        <input type="hidden"
               name="approvalId"
               value="<%= approval.getApprovalId() %>">


        <button type="submit"
                class="primary-btn">

            Start Application

        </button>


    </form>


    <%
    /*
     * ==========================================
     * NO APPLICATION + DOCUMENTS MISSING
     * ==========================================
     */

    } else {
    %>


    <button type="button"
            class="disabled-btn"
            disabled>

        Start Application

    </button>


    <%
    }
    %>


    <!-- =====================================
         DOCUMENT VAULT
         ===================================== -->


    <a class="secondary-btn"
       href="<%= request.getContextPath() %>/entrepreneur/documents">

        Upload / Manage Documents

    </a>


    <!-- =====================================
         OFFICIAL PORTAL
         ===================================== -->


    <%
    if (approval
            .getOfficialReferenceUrl()
            != null &&
        !approval
            .getOfficialReferenceUrl()
            .isBlank()) {
    %>


    <a class="secondary-btn"
       href="<%= approval.getOfficialReferenceUrl() %>"
       target="_blank"
       rel="noopener noreferrer">

        Visit Official Portal

    </a>


    <%
    }
    %>


    <!-- =====================================
         ROADMAP
         ===================================== -->


    <a class="secondary-btn"
       href="<%= request.getContextPath() %>/entrepreneur/generate-approvals">

        Back to Approval Roadmap

    </a>


</div>


<!-- =========================================
     DOCUMENT NOTE
     ========================================= -->


<%
if (currentApplication == null &&
    readinessPercentage < 100) {
%>


<div class="application-note">

    Start Application tabhi active hoga
    jab saare mandatory documents ready honge.

</div>


<%
}
%>


<%
} else {
%>


<!-- =========================================
     APPROVAL NOT FOUND
     ========================================= -->


<div class="hero">

    <h1>

        Approval information not available

    </h1>

    <p class="description">

        CHAPERON could not load
        the selected approval.

    </p>

</div>


<div class="actions">

    <a class="secondary-btn"
       href="<%= request.getContextPath() %>/entrepreneur/generate-approvals">

        Back to Approval Roadmap

    </a>

</div>


<%
}
%>


</div>

</div>


</body>

</html>