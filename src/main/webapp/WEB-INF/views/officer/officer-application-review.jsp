<%@ page language="java"

         contentType="text/html; charset=UTF-8"

         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>

<%@ page import="java.sql.Timestamp" %>

<%@ page import="java.sql.Date" %>

<%@ page import="com.chaperon.model.DocumentReadiness" %>

<%

    Long applicationId =

            (Long) request.getAttribute("applicationId");

    String applicationNumber =

            (String) request.getAttribute("applicationNumber");

    String currentStatus =

            (String) request.getAttribute("currentStatus");

    Integer readinessPercentage =

            (Integer) request.getAttribute("readinessPercentage");

    List<DocumentReadiness> documents =

            (List<DocumentReadiness>)

            request.getAttribute("documents");





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

     * INSPECTION DATA

     * ==========================================

     */

    Long inspectionId =

            (Long) request.getAttribute("inspectionId");

    String inspectionType =

            (String) request.getAttribute("inspectionType");

    Date inspectionDate =

            (Date) request.getAttribute("inspectionDate");

    java.sql.Time inspectionTime =

            (java.sql.Time) request.getAttribute("inspectionTime");

    String inspectionLocation =

            (String) request.getAttribute("inspectionLocation");

    String inspectionRemarks =

            (String) request.getAttribute("inspectionRemarks");

    String inspectionStatus =

            (String) request.getAttribute("inspectionStatus");

    String inspectionResult =

            (String) request.getAttribute("inspectionResult");

    String inspectionNotes =

            (String) request.getAttribute("inspectionNotes");

    String inspectionRecommendation =

            (String) request.getAttribute("inspectionRecommendation");





    /*

     * ==========================================

     * URL MESSAGES

     * ==========================================

     */

    String success =

            request.getParameter("success");

    String message =

            request.getParameter("message");





    /*

     * Final decision tabhi allowed hai jab

     * query pending na ho.

     */

    boolean queryAllowsFinalDecision =

            queryStatus == null ||

            "RESOLVED".equalsIgnoreCase(queryStatus);

    boolean inspectionAllowsFinalDecision =

            inspectionId == null ||

            "COMPLETED".equalsIgnoreCase(inspectionStatus) ||

            "CANCELLED".equalsIgnoreCase(inspectionStatus);

    boolean finalDecisionAllowed =

            queryAllowsFinalDecision &&

            inspectionAllowsFinalDecision;

%>





<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"

      content="width=device-width, initial-scale=1.0">

<title>

    Application Review | CHAPERON

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

    background: #f4f7fb;

    color: #17233c;

}





/* =========================================

   TOP BAR

   \========================================= */

.topbar {

    min-height: 72px;

    background: white;

    border-bottom:

        1px solid #e4eaf1;

    padding: 0 5%;

    display: flex;

    align-items: center;

    justify-content:

        space-between;

}





.logo {

    font-size: 25px;

    font-weight: 900;

    color: #10233f;

}





.nav {

    display: flex;

    gap: 16px;

    align-items: center;

}





.nav a {

    text-decoration: none;

    color: #4e6075;

    font-size: 14px;

    font-weight: 700;

}





/* =========================================

   PAGE

   \========================================= */

.page {

    padding:

        40px 20px 70px;

}





.container {

    max-width: 1180px;

    margin: auto;

}





/* =========================================

   ALERTS

   \========================================= */

.notice {

    padding: 14px 16px;

    border-radius: 10px;

    background: #fff7e6;

    color: #896000;

    font-size: 13px;

    line-height: 1.6;

    margin-bottom: 15px;

}





.success-notice {

    background: #e7f7ed;

    color: #27804a;

}





.review-notice {

    background: #e7f1ff;

    color: #1768c7;

    margin-top: 18px;

}





.error-notice {

    background: #ffe9e7;

    color: #bd3c33;

}





/* =========================================

   HERO

   \========================================= */

.hero {

    background: #102d53;

    color: white;

    border-radius: 20px;

    padding: 30px;

    margin-bottom: 22px;

}





.badge {

    display: inline-block;

    padding: 7px 11px;

    border-radius: 20px;

    background:

        rgba(255,255,255,0.12);

    font-size: 11px;

    font-weight: 900;

    margin-bottom: 12px;

}





.hero h1 {

    margin:

        0 0 9px;

    font-size: 30px;

}





.hero p {

    color: #d7e3f1;

    margin:

        8px 0;

}





.status {

    display: inline-block;

    margin-top: 15px;

    padding: 8px 12px;

    border-radius: 20px;

    background: #e7f1ff;

    color: #1768c7;

    font-size: 12px;

    font-weight: 900;

}





/* =========================================

   GRID

   \========================================= */

.grid {

    display: grid;

    grid-template-columns:

        repeat(2, 1fr);

    gap: 20px;

    margin-bottom: 20px;

}





/* =========================================

   CARDS

   \========================================= */

.card {

    background: white;

    border:

        1px solid #e3e9f0;

    border-radius: 17px;

    padding: 23px;

}





.card h2 {

    margin:

        0 0 18px;

    font-size: 20px;

}





/* =========================================

   INFORMATION ROW

   \========================================= */

.info-row {

    display: flex;

    justify-content:

        space-between;

    gap: 20px;

    padding: 10px 0;

    border-bottom:

        1px solid #edf1f5;

}





.info-row:last-child {

    border-bottom: none;

}





.label {

    color: #79889b;

    font-size: 13px;

}





.value {

    font-size: 13px;

    font-weight: 800;

    text-align: right;

    word-break: break-word;

}





/* =========================================

   QUERY CARD

   \========================================= */

.query-card {

    background: #fffdf7;

    border:

        1px solid #eddca9;

    border-radius: 17px;

    padding: 23px;

    margin-bottom: 20px;

}





.query-header {

    display: flex;

    justify-content:

        space-between;

    align-items:

        flex-start;

    gap: 15px;

    flex-wrap: wrap;

}





.query-header h2 {

    margin: 0;

}





.query-status {

    display: inline-block;

    padding: 7px 11px;

    border-radius: 20px;

    background: #fff0c5;

    color: #8a6000;

    font-size: 11px;

    font-weight: 900;

}





.query-message {

    margin-top: 18px;

    padding: 18px;

    border-radius: 12px;

    background: white;

    border:

        1px solid #eee2c2;

    line-height: 1.7;

    color: #37475a;

    white-space: pre-wrap;

}





.query-meta {

    margin-top: 15px;

    display: grid;

    grid-template-columns:

        repeat(2,1fr);

    gap: 12px;

}





.query-meta-box {

    background: white;

    border:

        1px solid #eee4ce;

    border-radius: 10px;

    padding: 13px;

}





.meta-label {

    font-size: 11px;

    color: #7b8796;

    font-weight: 800;

    text-transform: uppercase;

    margin-bottom: 5px;

}





.meta-value {

    font-size: 14px;

    font-weight: 800;

}





/* =========================================

   ENTREPRENEUR RESPONSE

   \========================================= */

.response-box {

    margin-top: 20px;

    padding: 20px;

    background: #eef8f1;

    border:

        1px solid #cfe8d6;

    border-radius: 14px;

}





.response-box h3 {

    margin:

        0 0 10px;

    color: #27633c;

}





.response-content {

    background: white;

    border:

        1px solid #d7e7db;

    border-radius: 11px;

    padding: 16px;

    margin-top: 13px;

    line-height: 1.7;

    color: #37475a;

    white-space: pre-wrap;

}





/* =========================================

   DOCUMENTS

   \========================================= */

.documents {

    background: white;

    border:

        1px solid #e3e9f0;

    border-radius: 17px;

    padding: 23px;

    margin-bottom: 20px;

}





.documents-header {

    display: flex;

    justify-content:

        space-between;

    gap: 20px;

    align-items: center;

    margin-bottom: 18px;

}





.documents-header h2 {

    margin: 0;

}





.readiness {

    font-size: 22px;

    font-weight: 900;

    color: #1768c7;

}





.document-row {

    display: flex;

    justify-content:

        space-between;

    gap: 20px;

    padding: 15px 0;

    border-bottom:

        1px solid #edf1f5;

}





.document-row:last-child {

    border-bottom: none;

}





.document-name {

    font-weight: 800;

    margin-bottom: 5px;

}





.document-description {

    font-size: 12px;

    color: #748397;

}





.file-name {

    margin-top: 5px;

    font-size: 12px;

    color: #5f7186;

}





.doc-status {

    height: fit-content;

    padding: 7px 11px;

    border-radius: 20px;

    font-size: 11px;

    font-weight: 900;

}





.ready {

    background: #e7f7ed;

    color: #27804a;

}





.missing {

    background: #fff2db;

    color: #986000;

}





.rejected {

    background: #ffe9e7;

    color: #bd3c33;

}





/* =========================================

   INSPECTION CARD

   \========================================= */

.inspection-card {

    background: #f8fbff;

    border:

        1px solid #cfe2ff;

    border-radius: 17px;

    padding: 23px;

    margin-bottom: 20px;

}

.inspection-card h2 {

    margin: 0 0 18px;

    font-size: 20px;

}

.inspection-badge {

    display: inline-block;

    padding: 7px 11px;

    border-radius: 20px;

    background: #e7f1ff;

    color: #1768c7;

    font-size: 11px;

    font-weight: 900;

}

.inspection-remarks {

    margin-top: 18px;

    padding: 15px;

    border-radius: 10px;

    background: white;

    border: 1px solid #e1eaf5;

    color: #4f6177;

    line-height: 1.6;

}



/* =========================================

   OFFICER ACTIONS

   \========================================= */

.action-card {

    background: white;

    border:

        1px solid #e3e9f0;

    border-radius: 17px;

    padding: 23px;

}





.action-card h2 {

    margin-top: 0;

}





.action-card p {

    color: #68788c;

    line-height: 1.6;

}





.actions {

    display: flex;

    flex-wrap: wrap;

    gap: 12px;

    margin-top: 18px;

}





/* =========================================

   BUTTONS

   \========================================= */

.primary-btn,

.secondary-btn,

.danger-btn {

    display: inline-block;

    text-decoration: none;

    padding: 11px 17px;

    border-radius: 9px;

    font-weight: 800;

    font-size: 13px;

    border: none;

    cursor: pointer;

}





.primary-btn {

    background: #1677e8;

    color: white;

}





.primary-btn:hover {

    opacity: 0.9;

}





.secondary-btn {

    background: #eef2f6;

    color: #42546b;

}





.secondary-btn:disabled {

    opacity: 0.55;

    cursor: not-allowed;

}





.danger-btn {

    background: #c93e36;

    color: white;

}





.resolve-btn {

    background: #27804a;

    color: white;

}





/* =========================================

   FORMS

   \========================================= */

.form-box {

    display: none;

    margin-top: 22px;

    padding: 22px;

    border:

        1px solid #e3e9f0;

    border-radius: 14px;

    background: #f8fafc;

}





.form-box h3 {

    margin-top: 0;

    margin-bottom: 8px;

}





.form-box p {

    color: #68788c;

    line-height: 1.6;

}





.form-group {

    margin-bottom: 18px;

}





.form-label {

    display: block;

    font-size: 13px;

    font-weight: 800;

    margin-bottom: 7px;

}





.form-control {

    width: 100%;

    padding: 12px;

    border:

        1px solid #d5dde7;

    border-radius: 9px;

    font-family:

        Arial,

        Helvetica,

        sans-serif;

    font-size: 14px;

    outline: none;

    background: white;

}





.form-control:focus {

    border-color: #1677e8;

}





textarea.form-control {

    resize: vertical;

    min-height: 120px;

}





.checkbox-row {

    display: flex;

    align-items: center;

    gap: 8px;

    font-size: 13px;

    font-weight: 700;

    color: #42546b;

}





/* =========================================

   RESPONSIVE

   \========================================= */

@media(max-width:800px) {

    .grid {

        grid-template-columns: 1fr;

    }





    .query-meta {

        grid-template-columns: 1fr;

    }





    .topbar {

        padding:

            0 20px;

    }





    .document-row {

        flex-direction: column;

    }





    .actions {

        flex-direction: column;

        align-items: stretch;

    }





    .actions button,

    .actions a {

        width: 100%;

        text-align: center;

    }

}



/* ============================================================
   CHAPERON GOVERNMENT OFFICER PREMIUM THEME
   ============================================================ */
:root {
    --officer-green: #0b9c65;
    --officer-green-dark: #087a50;
    --officer-green-deep: #075d3e;
    --officer-soft: #eaf8f1;
    --officer-pale: #f4fbf7;
    --officer-border: #dcebe4;
    --officer-navy: #0d1d39;
}

body {
    font-family: "Segoe UI", Arial, Helvetica, sans-serif;
    background: radial-gradient(circle at 90% 4%, rgba(23,174,111,.08), transparent 27%), linear-gradient(145deg,#f5faf7,#fbfdfc);
    color: #172742;
}

.topbar {
    position: sticky;
    top: 0;
    z-index: 1000;
    min-height: 78px;
    padding: 0 4%;
    background: rgba(255,255,255,.95);
    border-bottom: 1px solid #e1ebe6;
    box-shadow: 0 5px 24px rgba(31,82,61,.05);
    backdrop-filter: blur(16px);
}

.logo {
    position: relative;
    min-height: 52px;
    padding-left: 62px;
    display: flex;
    align-items: center;
    color: #1254c5;
    font-size: 23px;
    font-weight: 900;
    letter-spacing: .2px;
}

.logo::before {
    content: "";
    position: absolute;
    left: 0;
    top: 50%;
    width: 51px;
    height: 51px;
    transform: translateY(-50%);
    border-radius: 50%;
    background-image: url("<%= request.getContextPath() %>/images/chaperon-logo.jpeg");
    background-size: 92px 92px;
    background-position: center -7px;
    background-repeat: no-repeat;
    background-color: #fff;
}

.logo::after {
    content: "GUIDE. CONNECT. COMPLY. GET APPROVED.";
    position: absolute;
    left: 62px;
    top: 39px;
    color: #1454bd;
    font-size: 6px;
    font-weight: 900;
    white-space: nowrap;
}

.nav { gap: 9px; }
.nav a {
    min-height: 39px;
    padding: 0 13px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border-radius: 9px;
    color: #335646;
    background: #f0f8f4;
    border: 1px solid #dbece4;
    font-size: 10px;
    font-weight: 800;
}
.nav a:hover { color: #fff; background: var(--officer-green); }
.nav a:last-child { color:#b63b35; background:#fff1ef; border-color:#f6dedb; }
.nav a:last-child:hover { color:#fff; background:#c4433b; }

.page { padding: 31px 20px 65px; }
.container { max-width: 1240px; }

.hero {
    position: relative;
    overflow: hidden;
    background: radial-gradient(circle at 91% 5%, rgba(64,225,162,.32), transparent 31%), linear-gradient(130deg,#075c3e,#078257);
    border-radius: 21px;
    padding: 31px 34px;
    margin-bottom: 21px;
    box-shadow: 0 17px 38px rgba(7,107,70,.19);
}
.hero::before {
    content:"";
    position:absolute;
    width:230px;
    height:230px;
    right:-90px;
    bottom:-145px;
    border:34px solid rgba(255,255,255,.06);
    border-radius:50%;
}
.hero .badge {
    position: relative;
    z-index: 2;
    background: rgba(255,255,255,.10);
    border: 1px solid rgba(255,255,255,.20);
    color: #dcf8e9;
}
.hero h1, .hero p, .hero strong { position:relative; z-index:2; }
.hero p { color:#dbf5e8; }
.hero .status { position:relative; z-index:2; color:#08784e; background:#dcf7e9; }

.card, .documents, .action-card {
    position: relative;
    overflow: hidden;
    border-color: var(--officer-border);
    box-shadow: 0 7px 22px rgba(38,76,59,.045);
}
.card::before, .documents::before, .action-card::before {
    content:"";
    position:absolute;
    left:0;
    top:0;
    width:4px;
    height:100%;
    background: linear-gradient(180deg,var(--officer-green),#48c28d);
}
.card h2, .documents h2, .action-card h2 { color: var(--officer-navy); }

.info-row { border-bottom-color:#edf2ef; }
.label { color:#8493a4; }
.value { color:#283d55; }

.query-card {
    border-color:#eedba7;
    background:linear-gradient(145deg,#fffdf7,#fffaf0);
    box-shadow:0 7px 22px rgba(103,83,28,.045);
}
.query-status { color:#875c00; background:#ffedbd; }
.response-box { border-color:#cbe8d8; background:linear-gradient(145deg,#edf9f3,#f6fcf8); }
.response-box h3 { color:#167348; }

.readiness { color:#08784e; }
.inspection-card {
    background:linear-gradient(145deg,#f8fcfa,#eff9f4);
    border-color:#cce7da;
    box-shadow:0 7px 22px rgba(34,79,59,.045);
}
.inspection-badge { color:#08774d; background:#e5f7ed; }

.action-card {
    border-color:#cfe4d9;
    background:radial-gradient(circle at 95% 0%,rgba(15,165,101,.07),transparent 31%),#fff;
}

.primary-btn {
    background: linear-gradient(135deg,#0b9c65,#087c51);
    color:#fff;
    box-shadow:0 7px 16px rgba(11,156,101,.18);
}
.primary-btn:hover { opacity:1; transform:translateY(-1px); box-shadow:0 10px 21px rgba(11,156,101,.25); }
.resolve-btn { background:linear-gradient(135deg,#0a975f,#087549); }
.secondary-btn { background:#edf5f1; color:#36584a; border:1px solid #d7e7df; }
.danger-btn { background:linear-gradient(135deg,#d04a42,#b63832); color:#fff; }

.form-box {
    border-color:#d8e8e0;
    background:linear-gradient(145deg,#f7fbf9,#f1f8f5);
}
.form-control { border-color:#d4e1db; font-family:"Segoe UI",Arial,Helvetica,sans-serif; }
.form-control:focus { border-color:var(--officer-green); box-shadow:0 0 0 3px rgba(11,156,101,.10); }

.success-notice { background:#e9f8f0; color:#137147; }
.review-notice { background:#edf9f3; color:#08764d; }

@media(max-width:800px) {
    .logo { font-size:19px; padding-left:54px; }
    .logo::before { width:44px; height:44px; background-size:79px 79px; }
    .logo::after { display:none; }
    .topbar { padding:10px 16px; }
    .hero { padding:25px 21px; }
}

</style>

</head>





<body>





<!-- =========================================

     TOP BAR

     \========================================= -->

<div class="topbar">

    <div class="logo">

        CHAPERON

    </div>





    <div class="nav">

        <a href="<%= request.getContextPath() %>/officer/dashboard">

            Dashboard

        </a>





        <a href="<%= request.getContextPath() %>/logout">

            Logout

        </a>

    </div>

</div>





<div class="page">

<div class="container">





<!-- =========================================

     SUCCESS MESSAGES

     \========================================= -->





<%

if ("review-started".equals(success)) {

%>

<div class="notice success-notice">

    Application review started successfully.

</div>

<%

}

%>





<%

if ("query-raised".equals(success)) {

%>

<div class="notice success-notice">

    Query sent to the applicant successfully.

</div>

<%

}

%>





<%

if ("query-resolved".equals(success)) {

%>

<div class="notice success-notice">

    Query resolved successfully.

    You can continue reviewing the application.

</div>

<%

}

%>





<%

if ("application-approved".equals(success)) {

%>

<div class="notice success-notice">

    Application approved successfully.

    Approval certificate has been generated.

</div>

<%

}

%>





<%

if ("application-rejected".equals(success)) {

%>

<div class="notice error-notice">

    Application rejected successfully.

</div>

<%

}

%>





<%

if ("inspection-scheduled".equals(success)) {

%>

<div class="notice success-notice">

    Inspection scheduled successfully.

    The inspection details have been recorded for this application.

</div>

<%

}

%>



<%

if ("inspection-completed".equals(success)) {

%>

<div class="notice success-notice">

    Inspection completed successfully.

    The inspection result has been recorded for this application.

</div>

<%

}

%>







<%

if (message != null &&

    !message.isBlank()) {

%>

<div class="notice">

    <%= message %>

</div>

<%

}

%>





<!-- =========================================

     HERO

     \========================================= -->

<div class="hero">





    <div class="badge">

        APPLICATION REVIEW

    </div>





    <h1>

        <%= request.getAttribute("approvalName") %>

    </h1>





    <p>

        Application:

        <strong>

            <%= applicationNumber %>

        </strong>

    </p>





    <p>

        Department:

        <strong>

            <%= request.getAttribute("departmentName") %>

        </strong>

    </p>





    <span class="status">

        <%= currentStatus != null

                ? currentStatus.replace("_", " ")

                : "UNKNOWN" %>

    </span>





</div>





<!-- =========================================

     APPLICANT + APPLICATION INFORMATION

     \========================================= -->

<div class="grid">





<div class="card">

    <h2>

        Applicant Information

    </h2>





    <div class="info-row">

        <span class="label">

            Applicant Name

        </span>

        <span class="value">

            <%= request.getAttribute("applicantName") %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Email

        </span>

        <span class="value">

            <%= request.getAttribute("applicantEmail") %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Mobile

        </span>

        <span class="value">

            <%= request.getAttribute("applicantMobile") %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Submitted On

        </span>

        <span class="value">

            <%= request.getAttribute("submissionDate") != null

                    ? request.getAttribute("submissionDate")

                    : "Not Available" %>

        </span>

    </div>

</div>





<div class="card">

    <h2>

        Application Information

    </h2>





    <div class="info-row">

        <span class="label">

            Application Number

        </span>

        <span class="value">

            <%= applicationNumber %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Approval Code

        </span>

        <span class="value">

            <%= request.getAttribute("approvalCode") %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            SLA

        </span>

        <span class="value">

            <%= request.getAttribute("slaDays") != null

                    ? request.getAttribute("slaDays") + " Days"

                    : "Not Available" %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Expected Completion

        </span>

        <span class="value">

            <%= request.getAttribute("expectedCompletionDate") != null

                    ? request.getAttribute("expectedCompletionDate")

                    : "Not Available" %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Risk Level

        </span>

        <span class="value">

            <%= request.getAttribute("riskLevel") != null

                    ? request.getAttribute("riskLevel")

                    : "LOW" %>

        </span>

    </div>

</div>





</div>





<!-- =========================================

     BUSINESS + LOCATION

     \========================================= -->

<div class="grid">





<div class="card">

    <h2>

        Business Information

    </h2>





    <div class="info-row">

        <span class="label">

            Business Name

        </span>

        <span class="value">

            <%= request.getAttribute("businessName") %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Constitution

        </span>

        <span class="value">

            <%= request.getAttribute("businessConstitution") %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Activity

        </span>

        <span class="value">

            <%= request.getAttribute("businessActivity") %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Industry

        </span>

        <span class="value">

            <%= request.getAttribute("industry") %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Project Stage

        </span>

        <span class="value">

            <%= request.getAttribute("projectStage") %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Employees

        </span>

        <span class="value">

            <%= request.getAttribute("employeeCount") %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Investment Amount

        </span>

        <span class="value">

            <%= request.getAttribute("investmentAmount") != null

                    ? request.getAttribute("investmentAmount")

                    : "Not Available" %>

        </span>

    </div>

</div>





<div class="card">

    <h2>

        Location & Compliance

    </h2>





    <div class="info-row">

        <span class="label">

            State

        </span>

        <span class="value">

            <%= request.getAttribute("state") %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            District

        </span>

        <span class="value">

            <%= request.getAttribute("district") %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Taluka

        </span>

        <span class="value">

            <%= request.getAttribute("taluka") %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Industrial Area

        </span>

        <span class="value">

            <%= request.getAttribute("industrialArea") %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            PIN Code

        </span>

        <span class="value">

            <%= request.getAttribute("pinCode") %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Pollution Category

        </span>

        <span class="value">

            <%= request.getAttribute("pollutionCategory") %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Boiler Used

        </span>

        <span class="value">

            <%= Boolean.TRUE.equals(

                    request.getAttribute("boilerUsed"))

                    ? "Yes"

                    : "No" %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Hazardous Material

        </span>

        <span class="value">

            <%= Boolean.TRUE.equals(

                    request.getAttribute("hazardousMaterial"))

                    ? "Yes"

                    : "No" %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Industrial Waste

        </span>

        <span class="value">

            <%= Boolean.TRUE.equals(

                    request.getAttribute("industrialWaste"))

                    ? "Yes"

                    : "No" %>

        </span>

    </div>





    <div class="info-row">

        <span class="label">

            Groundwater Required

        </span>

        <span class="value">

            <%= Boolean.TRUE.equals(

                    request.getAttribute("groundwaterRequired"))

                    ? "Yes"

                    : "No" %>

        </span>

    </div>

</div>





</div>





<!-- =========================================

     QUERY + ENTREPRENEUR RESPONSE

     \========================================= -->

<%

if (queryId != null) {

%>





<div class="query-card">





    <div class="query-header">





        <div>

            <h2>

                Application Query

            </h2>

            <div style="

                 color:#7b8796;

                 font-size:13px;

                 margin-top:6px;">

                Query raised by the reviewing officer.

            </div>

        </div>





        <span class="query-status">

            <%= queryStatus != null

                    ? queryStatus

                    : "OPEN" %>

        </span>

    </div>





    <div class="query-message">

        <strong>

            Officer Query

        </strong>

        <br><br>

        <%= queryDescription != null

                ? queryDescription

                : "No query description available." %>

    </div>





    <div class="query-meta">





        <div class="query-meta-box">

            <div class="meta-label">

                Raised On

            </div>

            <div class="meta-value">

                <%= queryRaisedDate != null

                        ? queryRaisedDate

                        : "Not Available" %>

            </div>

        </div>





        <div class="query-meta-box">

            <div class="meta-label">

                Response Deadline

            </div>

            <div class="meta-value">

                <%= queryResponseDeadline != null

                        ? queryResponseDeadline

                        : "No Deadline" %>

            </div>

        </div>





    </div>





    <%

    if ("RESPONDED".equalsIgnoreCase(queryStatus) ||

        "RESOLVED".equalsIgnoreCase(queryStatus)) {

    %>





    <div class="response-box">





        <h3>

            Entrepreneur Response

        </h3>





        <div style="

             font-size:13px;

             color:#527060;">

            Applicant has responded to the officer query.

        </div>





        <div class="response-content">

            <%= entrepreneurResponse != null

                    ? entrepreneurResponse

                    : "No response text available." %>

        </div>





        <%

        if (queryRespondedAt != null) {

        %>





        <div style="

             margin-top:12px;

             font-size:12px;

             color:#607465;">

            Responded On:

            <strong>

                <%= queryRespondedAt %>

            </strong>

        </div>





        <%

        }

        %>





    </div>





    <%

    }

    %>





    <!-- RESOLVE BUTTON -->

    <%

    if ("RESPONDED".equalsIgnoreCase(queryStatus)) {

    %>





    <form method="post"

          action="<%= request.getContextPath() %>/officer/resolve-query"

          style="margin-top:18px;">





        <input type="hidden"

               name="queryId"

               value="<%= queryId %>">





        <input type="hidden"

               name="applicationId"

               value="<%= applicationId %>">





        <button type="submit"

                class="primary-btn resolve-btn">

            Resolve Query & Continue Review

        </button>





    </form>





    <%

    }

    %>





    <%

    if ("RESOLVED".equalsIgnoreCase(queryStatus)) {

    %>





    <div class="notice success-notice"

         style="margin-top:18px;

                margin-bottom:0;">

        Query has been resolved successfully.

        <%

        if (queryResolvedAt != null) {

        %>

        <br>

        Resolved On:

        <strong>

            <%= queryResolvedAt %>

        </strong>

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





<!-- =========================================

     DOCUMENTS

     \========================================= -->

<div class="documents">





<div class="documents-header">

    <h2>

        Submitted Documents

    </h2>





    <div class="readiness">

        <%= readinessPercentage != null

                ? readinessPercentage

                : 0 %>%

    </div>

</div>





<%

if (documents != null &&

    !documents.isEmpty()) {

    for (DocumentReadiness document

            : documents) {

        String documentStatus =

                document.getStatus();

        String statusClass =

                "missing";





        if ("READY".equalsIgnoreCase(

                documentStatus)) {

            statusClass =

                    "ready";

        } else if (

                "REJECTED".equalsIgnoreCase(

                        documentStatus)

                ||

                "EXPIRED".equalsIgnoreCase(

                        documentStatus)

        ) {

            statusClass =

                    "rejected";

        }

%>





<div class="document-row">





    <div>





        <div class="document-name">

            <%= document.getDocumentType() %>

            <%= document.isMandatory()

                    ? " *"

                    : "" %>

        </div>





        <div class="document-description">

            <%= document.getDescription() != null

                    ? document.getDescription()

                    : "Required document" %>

        </div>





        <%

        if (document.getUploadedFileName() != null) {

        %>





        <div class="file-name">

            Uploaded:

            <strong>

                <%= document.getUploadedFileName() %>

            </strong>

        </div>





        <%

        } else {

        %>





        <div class="file-name">

            No document uploaded.

        </div>





        <%

        }

        %>





    </div>





    <span class="doc-status <%= statusClass %>">

        <%= documentStatus != null

                ? documentStatus

                : "MISSING" %>

    </span>





</div>





<%

    }

} else {

%>





<div class="notice">

    No document requirements are configured

    for this approval.

</div>





<%

}

%>





</div>





<!-- =========================================

     INSPECTION DETAILS

     \========================================= -->

<%

if (inspectionId != null) {

%>

<div class="inspection-card">

    <div style="display:flex; justify-content:space-between; gap:15px; align-items:flex-start; flex-wrap:wrap;">

        <div>

            <h2>

                Inspection Details

            </h2>

            <div style="font-size:13px; color:#6d7e92;">

                Latest inspection scheduled for this application.

            </div>

        </div>

        <span class="inspection-badge">

            <%= inspectionStatus != null

                    ? inspectionStatus.replace("_", " ")

                    : "SCHEDULED" %>

        </span>

    </div>





    <div style="margin-top:18px;">

        <div class="info-row">

            <span class="label">Inspection Type</span>

            <span class="value">

                <%= inspectionType != null

                        ? inspectionType

                        : "Not Available" %>

            </span>

        </div>





        <div class="info-row">

            <span class="label">Inspection Date</span>

            <span class="value">

                <%= inspectionDate != null

                        ? inspectionDate

                        : "Not Available" %>

            </span>

        </div>





        <div class="info-row">

            <span class="label">Inspection Time</span>

            <span class="value">

                <%= inspectionTime != null

                        ? inspectionTime

                        : "Not Available" %>

            </span>

        </div>





        <div class="info-row">

            <span class="label">Location</span>

            <span class="value">

                <%= inspectionLocation != null

                        ? inspectionLocation

                        : "Not Available" %>

            </span>

        </div>





        <%

        if (inspectionResult != null &&

            !inspectionResult.isBlank()) {

        %>

        <div class="info-row">

            <span class="label">Inspection Result</span>

            <span class="value">

                <%= inspectionResult.replace("_", " ") %>

            </span>

        </div>

        <%

        }

        %>

    </div>





    <%

    if (inspectionRemarks != null &&

        !inspectionRemarks.isBlank()) {

    %>

    <div class="inspection-remarks">

        <strong>Officer Remarks</strong>

        <br><br>

        <%= inspectionRemarks %>

    </div>

    <%

    }

    %>







<%

if (inspectionNotes != null && !inspectionNotes.isBlank()) {

%>

<div class="inspection-remarks">

    <strong>Inspection Notes</strong>

    <br><br>

    <%= inspectionNotes %>

</div>

<%

}

%>

<%

if (inspectionRecommendation != null && !inspectionRecommendation.isBlank()) {

%>

<div class="inspection-remarks">

    <strong>Recommendation</strong>

    <br><br>

    <%= inspectionRecommendation %>

</div>

<%

}

%>

<%

    if ("SCHEDULED".equalsIgnoreCase(inspectionStatus) ||

        "RESCHEDULED".equalsIgnoreCase(inspectionStatus)) {

    %>

    <div class="notice" style="margin-top:18px; margin-bottom:0; background:#e7f1ff; color:#1768c7;">

        Inspection is scheduled. Final approval or rejection will remain disabled until the inspection is completed or cancelled.

    </div>

    <%

    }

    %>

</div>

<%

}

%>





<!-- =========================================

     OFFICER ACTIONS

     \========================================= -->

<div class="action-card">





<h2>

    Officer Actions

</h2>





<p>

    Review the applicant information,

    business profile, submitted documents

    and query response before taking

    the final regulatory decision.

</p>





<!-- =========================================

     SUBMITTED

     \========================================= -->

<%

if ("SUBMITTED".equalsIgnoreCase(

        currentStatus)) {

%>





<div class="notice">

    This application has been submitted

    and is waiting for an officer

    to start the review.

</div>





<form method="post"

      action="<%= request.getContextPath() %>/officer/start-review">





    <input type="hidden"

           name="applicationId"

           value="<%= applicationId %>">





    <button type="submit"

            class="primary-btn">

        Start Review

    </button>





</form>





<%

}

%>





<!-- =========================================

     UNDER REVIEW

     \========================================= -->

<%

if ("UNDER_REVIEW".equalsIgnoreCase(

        currentStatus)) {

%>





<div class="notice review-notice">

    This application is currently under review.

</div>





<div class="actions">





    <!-- RAISE QUERY -->

    <%

    if (!"RESPONDED".equalsIgnoreCase(queryStatus)) {

    %>





    <button type="button"

            class="primary-btn"

            onclick="openQueryForm()">

        Raise Query

    </button>





    <%

    }

    %>





    <!-- INSPECTION -->

    <%

    if (inspectionId == null) {

    %>

    <button type="button"

            class="secondary-btn"

            onclick="openInspectionForm()">

        Schedule Inspection

    </button>

    <%

    } else {

    %>

    <button type="button"

            class="secondary-btn"

            disabled>

        Inspection Scheduled

    </button>

    <%

    }

    %>







    <!-- COMPLETE INSPECTION -->

    <%

    if (inspectionId != null &&

        ("SCHEDULED".equalsIgnoreCase(inspectionStatus) ||

         "RESCHEDULED".equalsIgnoreCase(inspectionStatus))) {

    %>

    <button type="button"

            class="primary-btn"

            onclick="openCompleteInspectionForm()">

        Complete Inspection

    </button>

    <%

    }

    %>



<!-- APPROVE / REJECT -->





    <%

    if (finalDecisionAllowed) {

    %>





    <button type="button"

            class="primary-btn"

            onclick="openApproveForm()">

        Approve Application

    </button>





    <button type="button"

            class="danger-btn"

            onclick="openRejectForm()">

        Reject Application

    </button>





    <%

    } else {

    %>





    <button type="button"

            class="secondary-btn"

            disabled>

        Approve Application

    </button>





    <button type="button"

            class="secondary-btn"

            disabled>

        Reject Application

    </button>





    <%

    }

    %>





</div>





<!-- =========================================

     RAISE QUERY FORM

     \========================================= -->

<%

if (!"RESPONDED".equalsIgnoreCase(

        queryStatus)) {

%>





<div id="queryForm"

     class="form-box">





    <h3>

        Raise Query to Applicant

    </h3>





    <p>

        Clearly explain what information

        or document the entrepreneur

        needs to provide.

    </p>





    <form method="post"

          action="<%= request.getContextPath() %>/officer/raise-query">





        <input type="hidden"

               name="applicationId"

               value="<%= applicationId %>">





        <div class="form-group">





            <label class="form-label">

                Query Description *

            </label>





            <textarea

                name="queryDescription"

                class="form-control"

                required

                maxlength="2000"

                placeholder="Example: Please upload a clearer copy of the PAN document."></textarea>





        </div>





        <div class="form-group">





            <label class="form-label">

                Response Deadline *

            </label>





            <input type="date"

                   name="responseDeadline"

                   class="form-control"

                   required

                   min="<%= java.time.LocalDate.now() %>">





        </div>





        <div class="actions">





            <button type="submit"

                    class="primary-btn">

                Send Query

            </button>





            <button type="button"

                    class="secondary-btn"

                    onclick="closeQueryForm()">

                Cancel

            </button>





        </div>





    </form>





</div>





<%

}

%>





<!-- =========================================

     SCHEDULE INSPECTION FORM

     \========================================= -->

<%

if (inspectionId == null) {

%>

<div id="inspectionForm"

     class="form-box">

    <h3>

        Schedule Inspection

    </h3>

    <p>

        Enter the inspection type, date, time and location.

        These details will be stored against this application.

    </p>





    <form method="post"

          action="<%= request.getContextPath() %>/officer/schedule-inspection">

        <input type="hidden"

               name="applicationId"

               value="<%= applicationId %>">





        <div class="form-group">

            <label class="form-label">

                Inspection Type *

            </label>

            <select name="inspectionType"

                    class="form-control"

                    required>

                <option value="">Select Inspection Type</option>

                <option value="Site Inspection">Site Inspection</option>

                <option value="Premises Inspection">Premises Inspection</option>

                <option value="Safety Inspection">Safety Inspection</option>

                <option value="Compliance Inspection">Compliance Inspection</option>

                <option value="Document and Site Verification">Document and Site Verification</option>

                <option value="Other">Other</option>

            </select>

        </div>





        <div class="form-group">

            <label class="form-label">

                Inspection Date *

            </label>

            <input type="date"

                   name="inspectionDate"

                   class="form-control"

                   min="<%= java.time.LocalDate.now() %>"

                   required>

        </div>





        <div class="form-group">

            <label class="form-label">

                Inspection Time *

            </label>

            <input type="time"

                   name="inspectionTime"

                   class="form-control"

                   required>

        </div>





        <div class="form-group">

            <label class="form-label">

                Inspection Location *

            </label>

            <textarea name="location"

                      class="form-control"

                      maxlength="500"

                      required

                      placeholder="Example: Applicant business premises, Industrial Area, District"></textarea>

        </div>





        <div class="form-group">

            <label class="form-label">

                Inspection Remarks

            </label>

            <textarea name="remarks"

                      class="form-control"

                      maxlength="2000"

                      placeholder="Example: Verify site layout, safety arrangements and mandatory compliance requirements."></textarea>

        </div>





        <div class="actions">

            <button type="submit"

                    class="primary-btn">

                Confirm Inspection

            </button>

            <button type="button"

                    class="secondary-btn"

                    onclick="closeInspectionForm()">

                Cancel

            </button>

        </div>

    </form>

</div>

<%

}

%>







<!-- =========================================

     COMPLETE INSPECTION FORM

     \========================================= -->

<%

if (inspectionId != null &&

    ("SCHEDULED".equalsIgnoreCase(inspectionStatus) ||

     "RESCHEDULED".equalsIgnoreCase(inspectionStatus))) {

%>

<div id="completeInspectionForm"

     class="form-box">

    <h3>

        Complete Inspection

    </h3>

    <p>

        Record the inspection result after completing the inspection.

    </p>

    <form method="post"

          action="<%= request.getContextPath() %>/officer/complete-inspection">

        <input type="hidden"

               name="inspectionId"

               value="<%= inspectionId %>">

        <input type="hidden"

               name="applicationId"

               value="<%= applicationId %>">

        <div class="form-group">

            <label class="form-label">

                Inspection Result *

            </label>

            <select name="result"

                    class="form-control"

                    required>

                <option value="">

                    Select Inspection Result

                </option>

                <option value="PASSED">

                    Passed

                </option>

                <option value="FAILED">

                    Failed

                </option>

                <option value="PARTIALLY_COMPLIANT">

                    Partially Compliant

                </option>

            </select>

        </div>

        <div class="form-group">

            <label class="form-label">

                Inspection Notes

            </label>

            <textarea name="inspectionNotes"

                      class="form-control"

                      maxlength="3000"

                      placeholder="Example: Fire exits, extinguishers and emergency access were physically verified."></textarea>

        </div>

        <div class="form-group">

            <label class="form-label">

                Recommendation

            </label>

            <textarea name="recommendation"

                      class="form-control"

                      maxlength="2000"

                      placeholder="Example: Recommended for approval subject to applicable regulatory conditions."></textarea>

        </div>

        <div class="actions">

            <button type="submit"

                    class="primary-btn"

                    onclick="return confirm('Are you sure you want to submit this inspection result?');">

                Submit Inspection Result

            </button>

            <button type="button"

                    class="secondary-btn"

                    onclick="closeCompleteInspectionForm()">

                Cancel

            </button>

        </div>

    </form>

</div>

<%

}

%>



<!-- =========================================

     APPROVE FORM

     \========================================= -->

<%

if (finalDecisionAllowed) {

%>





<div id="approveForm"

     class="form-box">





    <h3>

        Approve Application

    </h3>





    <p>

        Confirm final approval.

        CHAPERON will generate an approval number

        and calculate validity from the configured

        approval rules.

    </p>





    <form method="post"

          action="<%= request.getContextPath() %>/officer/approve-application">





        <input type="hidden"

               name="applicationId"

               value="<%= applicationId %>">





        <div class="form-group">





            <label class="form-label">

                Approval Remarks

            </label>





            <textarea

                name="remarks"

                class="form-control"

                maxlength="2000"

                placeholder="Example: Application verified and approved as per applicable requirements."></textarea>





        </div>





        <div class="actions">





            <button type="submit"

                    class="primary-btn"

                    onclick="return confirm('Are you sure you want to approve this application?');">

                Confirm Approval

            </button>





            <button type="button"

                    class="secondary-btn"

                    onclick="closeApproveForm()">

                Cancel

            </button>





        </div>





    </form>





</div>





<!-- =========================================

     REJECT FORM

     \========================================= -->





<div id="rejectForm"

     class="form-box">





    <h3>

        Reject Application

    </h3>





    <p>

        Select a clear rejection reason.

        The rejection reason will be visible

        to the entrepreneur.

    </p>





    <form method="post"

          action="<%= request.getContextPath() %>/officer/reject-application">





        <input type="hidden"

               name="applicationId"

               value="<%= applicationId %>">





        <div class="form-group">





            <label class="form-label">

                Rejection Category *

            </label>





            <select name="rejectionCategory"

                    class="form-control"

                    required>





                <option value="">

                    Select Reason

                </option>





                <option value="Incomplete Documentation">

                    Incomplete Documentation

                </option>





                <option value="Incorrect Information">

                    Incorrect Information

                </option>





                <option value="Failed Inspection">

                    Failed Inspection

                </option>





                <option value="Eligibility Not Met">

                    Eligibility Not Met

                </option>





                <option value="Invalid Document">

                    Invalid Document

                </option>





                <option value="Duplicate Application">

                    Duplicate Application

                </option>





                <option value="Regulatory Requirements Not Satisfied">

                    Regulatory Requirements Not Satisfied

                </option>





                <option value="Other">

                    Other

                </option>





            </select>





        </div>





        <div class="form-group">





            <label class="form-label">

                Detailed Rejection Reason

            </label>





            <textarea

                name="rejectionDetails"

                class="form-control"

                maxlength="2500"

                placeholder="Clearly explain why the application is being rejected."></textarea>





        </div>





        <div class="form-group">





            <label class="form-label">

                Officer Remarks

            </label>





            <textarea

                name="officerRemarks"

                class="form-control"

                maxlength="2000"

                placeholder="Optional internal officer remarks"></textarea>





        </div>





        <div class="form-group">





            <label class="checkbox-row">





                <input type="checkbox"

                       name="canReapply"

                       value="true"

                       checked>





                Applicant can reapply after correcting the issue





            </label>





        </div>





        <div class="actions">





            <button type="submit"

                    class="danger-btn"

                    onclick="return confirm('Are you sure you want to reject this application?');">

                Confirm Rejection

            </button>





            <button type="button"

                    class="secondary-btn"

                    onclick="closeRejectForm()">

                Cancel

            </button>





        </div>





    </form>





</div>





<%

}

%>





<%

}

%>





<!-- =========================================

     QUERY RAISED

     \========================================= -->

<%

if ("QUERY_RAISED".equalsIgnoreCase(

        currentStatus)) {

%>





<div class="notice">

    A query has been raised for this application.

    The application is currently waiting

    for the entrepreneur's response.

</div>





<%

}

%>





<!-- =========================================

     APPROVED

     \========================================= -->

<%

if ("APPROVED".equalsIgnoreCase(

        currentStatus)) {

%>





<div class="notice success-notice">

    This application has been approved.

    The approval certificate has been generated.

</div>





<%

}

%>





<!-- =========================================

     REJECTED

     \========================================= -->

<%

if ("REJECTED".equalsIgnoreCase(

        currentStatus)) {

%>





<div class="notice error-notice">

    This application has been rejected.

</div>





<%

}

%>





<!-- =========================================

     DASHBOARD

     \========================================= -->

<div class="actions">





    <a class="secondary-btn"

       href="<%= request.getContextPath() %>/officer/dashboard">

        Back to Dashboard

    </a>





</div>





</div>





</div>

</div>





<script>





/*

 * =========================================

 * HIDE ALL FORMS

 * =========================================

 */

function hideAllActionForms() {

    const queryForm =

        document.getElementById(

            "queryForm"

        );

    const inspectionForm =

        document.getElementById(

            "inspectionForm"

        );

    const completeInspectionForm =

        document.getElementById(

            "completeInspectionForm"

        );





    const approveForm =

        document.getElementById(

            "approveForm"

        );

    const rejectForm =

        document.getElementById(

            "rejectForm"

        );





    if (queryForm != null) {

        queryForm.style.display =

            "none";

    }





    if (inspectionForm != null) {

        inspectionForm.style.display =

            "none";

    }

    if (completeInspectionForm != null) {

        completeInspectionForm.style.display =

            "none";

    }









    if (approveForm != null) {

        approveForm.style.display =

            "none";

    }





    if (rejectForm != null) {

        rejectForm.style.display =

            "none";

    }

}





/*

 * =========================================

 * QUERY FORM

 * =========================================

 */

function openQueryForm() {

    hideAllActionForms();





    const form =

        document.getElementById(

            "queryForm"

        );





    if (form != null) {

        form.style.display =

            "block";





        form.scrollIntoView({

            behavior: "smooth",

            block: "center"

        });

    }

}





function closeQueryForm() {

    const form =

        document.getElementById(

            "queryForm"

        );





    if (form != null) {

        form.style.display =

            "none";

    }

}





/*

 * =========================================

 * INSPECTION FORM

 * =========================================

 */

function openInspectionForm() {

    hideAllActionForms();

    const form =

        document.getElementById(

            "inspectionForm"

        );

    if (form != null) {

        form.style.display =

            "block";

        form.scrollIntoView({

            behavior: "smooth",

            block: "center"

        });

    }

}





function closeInspectionForm() {

    const form =

        document.getElementById(

            "inspectionForm"

        );

    if (form != null) {

        form.style.display =

            "none";

    }

}





/*

 * =========================================

 * COMPLETE INSPECTION FORM

 * =========================================

 */

function openCompleteInspectionForm() {

    hideAllActionForms();

    const form =

        document.getElementById(

            "completeInspectionForm"

        );

    if (form != null) {

        form.style.display =

            "block";

        form.scrollIntoView({

            behavior: "smooth",

            block: "center"

        });

    }

}



function closeCompleteInspectionForm() {

    const form =

        document.getElementById(

            "completeInspectionForm"

        );

    if (form != null) {

        form.style.display =

            "none";

    }

}



/*

 * =========================================

 * APPROVE FORM

 * =========================================

 */

function openApproveForm() {

    hideAllActionForms();





    const form =

        document.getElementById(

            "approveForm"

        );





    if (form != null) {

        form.style.display =

            "block";





        form.scrollIntoView({

            behavior: "smooth",

            block: "center"

        });

    }

}





function closeApproveForm() {

    const form =

        document.getElementById(

            "approveForm"

        );





    if (form != null) {

        form.style.display =

            "none";

    }

}





/*

 * =========================================

 * REJECT FORM

 * =========================================

 */

function openRejectForm() {

    hideAllActionForms();





    const form =

        document.getElementById(

            "rejectForm"

        );





    if (form != null) {

        form.style.display =

            "block";





        form.scrollIntoView({

            behavior: "smooth",

            block: "center"

        });

    }

}





function closeRejectForm() {

    const form =

        document.getElementById(

            "rejectForm"

        );





    if (form != null) {

        form.style.display =

            "none";

    }

}





</script>





</body>

</html>