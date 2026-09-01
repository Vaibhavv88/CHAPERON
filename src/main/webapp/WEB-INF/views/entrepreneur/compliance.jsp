<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.Date" %>

<%!
    private String esc(Object value) {

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
    String userName =
            (String) session.getAttribute("userName");

    if (userName == null ||
        userName.isBlank()) {

        userName = "Entrepreneur";
    }


    @SuppressWarnings("unchecked")
    List<Map<String, Object>> complianceItems =
            (List<Map<String, Object>>)
            request.getAttribute("complianceItems");


    Integer totalApprovals =
            (Integer)
            request.getAttribute("totalApprovals");

    Integer activeApprovals =
            (Integer)
            request.getAttribute("activeApprovals");

    Integer expiringSoon =
            (Integer)
            request.getAttribute("expiringSoon");

    Integer expiredApprovals =
            (Integer)
            request.getAttribute("expiredApprovals");

    Integer renewalRequired =
            (Integer)
            request.getAttribute("renewalRequired");

    Integer pendingCompliance =
            (Integer)
            request.getAttribute("pendingCompliance");


    if (totalApprovals == null) {
        totalApprovals = 0;
    }

    if (activeApprovals == null) {
        activeApprovals = 0;
    }

    if (expiringSoon == null) {
        expiringSoon = 0;
    }

    if (expiredApprovals == null) {
        expiredApprovals = 0;
    }

    if (renewalRequired == null) {
        renewalRequired = 0;
    }

    if (pendingCompliance == null) {
        pendingCompliance = 0;
    }
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Compliance | CHAPERON</title>

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

.layout {
    display: flex;
    min-height: 100vh;
}


/* =========================================
   SIDEBAR
   ========================================= */

.sidebar {

    width: 265px;

    background: #10233f;

    color: white;

    padding: 24px 18px;

    position: fixed;

    top: 0;

    left: 0;

    bottom: 0;

    overflow-y: auto;
}

.logo {

    font-size: 25px;

    font-weight: 900;

    margin-bottom: 6px;
}

.tagline {

    font-size: 11px;

    color: #b7c4d6;

    line-height: 1.5;

    margin-bottom: 28px;
}

.user-box {

    padding: 15px;

    background:
        rgba(255,255,255,0.08);

    border-radius: 12px;

    margin-bottom: 25px;
}

.user-label {

    font-size: 11px;

    color: #aebed2;

    margin-bottom: 4px;
}

.user-name {

    font-size: 14px;

    font-weight: 800;
}

.menu {

    display: flex;

    flex-direction: column;

    gap: 6px;
}

.menu-heading {

    color: #8296b1;

    font-size: 10px;

    font-weight: 900;

    letter-spacing: 1px;

    margin: 15px 10px 7px;
}

.menu-item {

    color: #d6e0ec;

    text-decoration: none;

    padding: 12px 13px;

    border-radius: 10px;

    font-size: 14px;

    font-weight: 700;

    display: flex;

    align-items: center;

    gap: 10px;
}

.menu-item:hover {

    background:
        rgba(255,255,255,0.08);

    color: white;
}

.menu-item.active {

    background: #1677e8;

    color: white;
}

.menu-icon {

    width: 20px;

    text-align: center;
}

.menu-separator {

    height: 1px;

    background:
        rgba(255,255,255,0.12);

    margin: 12px 0;
}


/* =========================================
   MAIN
   ========================================= */

.main {

    margin-left: 265px;

    width:
        calc(100% - 265px);
}

.topbar {

    min-height: 70px;

    background: white;

    border-bottom:
        1px solid #e4eaf1;

    display: flex;

    justify-content:
        space-between;

    align-items: center;

    padding: 0 35px;

    position: sticky;

    top: 0;

    z-index: 20;
}

.topbar-title {

    font-size: 18px;

    font-weight: 800;
}

.topbar-user {

    font-size: 13px;

    color: #64748b;
}

.content {

    padding: 35px;

    max-width: 1400px;

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

    padding: 28px;

    margin-bottom: 24px;

    box-shadow:
        0 10px 30px
        rgba(24,50,84,0.06);
}

.hero h1 {

    margin: 0 0 8px;

    font-size: 30px;
}

.hero p {

    margin: 0;

    color: #68778a;

    line-height: 1.6;
}


/* =========================================
   SUMMARY
   ========================================= */

.summary-grid {

    display: grid;

    grid-template-columns:
        repeat(3,1fr);

    gap: 16px;

    margin-bottom: 24px;
}

.summary-card {

    background: white;

    border:
        1px solid #e4eaf1;

    border-radius: 15px;

    padding: 20px;
}

.summary-label {

    color: #758297;

    font-size: 11px;

    font-weight: 800;

    text-transform: uppercase;

    margin-bottom: 9px;
}

.summary-value {

    font-size: 29px;

    font-weight: 900;
}


/* =========================================
   INFO
   ========================================= */

.info-box {

    padding: 17px 20px;

    background: #eef6ff;

    border:
        1px solid #d9e9fb;

    color: #3f648a;

    border-radius: 14px;

    line-height: 1.6;

    font-size: 14px;

    margin-bottom: 24px;
}


/* =========================================
   SECTION
   ========================================= */

.section-card {

    background: white;

    border:
        1px solid #e4eaf1;

    border-radius: 18px;

    padding: 25px;
}

.section-title {

    margin-bottom: 20px;
}

.section-title h2 {

    margin: 0 0 6px;

    font-size: 21px;
}

.section-title p {

    margin: 0;

    color: #728096;

    font-size: 14px;

    line-height: 1.6;
}


/* =========================================
   COMPLIANCE CARDS
   ========================================= */

.compliance-list {

    display: grid;

    gap: 20px;
}

.compliance-card {

    border:
        1px solid #e3e9f0;

    border-radius: 17px;

    padding: 22px;
}

.card-header {

    display: flex;

    justify-content:
        space-between;

    gap: 20px;

    align-items:
        flex-start;

    margin-bottom: 18px;
}

.approval-title {

    font-size: 19px;

    font-weight: 900;

    margin-bottom: 6px;
}

.approval-number {

    font-size: 12px;

    color: #1768c7;

    font-weight: 800;
}

.badges {

    display: flex;

    gap: 7px;

    flex-wrap: wrap;

    justify-content:
        flex-end;
}

.badge {

    display: inline-block;

    padding: 6px 10px;

    border-radius: 20px;

    font-size: 11px;

    font-weight: 900;
}

.active-badge {

    background: #e8f7ed;

    color: #267a42;
}

.expiring-badge {

    background: #fff2d9;

    color: #986000;
}

.expired-badge {

    background: #ffe9e7;

    color: #c43329;
}

.renewal-badge {

    background: #e8f2ff;

    color: #1768c7;
}


/* =========================================
   DETAILS
   ========================================= */

.details-grid {

    display: grid;

    grid-template-columns:
        repeat(4,1fr);

    gap: 12px;
}

.detail-box {

    background: #f8fafc;

    border:
        1px solid #edf1f5;

    padding: 13px;

    border-radius: 11px;
}

.detail-label {

    font-size: 10px;

    color: #7b8798;

    font-weight: 900;

    text-transform: uppercase;

    margin-bottom: 6px;
}

.detail-value {

    font-size: 13px;

    color: #293c53;

    font-weight: 700;

    line-height: 1.5;

    word-break: break-word;
}


/* =========================================
   SUBSECTIONS
   ========================================= */

.subsection {

    margin-top: 18px;

    border-top:
        1px solid #edf1f5;

    padding-top: 18px;
}

.subsection-title {

    font-size: 14px;

    font-weight: 900;

    margin-bottom: 12px;
}

.compliance-record {

    background: #f8fafc;

    border:
        1px solid #edf1f5;

    border-radius: 11px;

    padding: 13px;

    margin-bottom: 9px;
}

.record-top {

    display: flex;

    justify-content:
        space-between;

    gap: 12px;

    margin-bottom: 5px;
}

.record-name {

    font-size: 13px;

    font-weight: 800;
}

.record-meta {

    font-size: 12px;

    color: #718096;

    line-height: 1.6;
}

.reminder-list {

    display: flex;

    flex-wrap: wrap;

    gap: 9px;
}

.reminder-item {

    background: #eef5ff;

    border:
        1px solid #d9e7fa;

    color: #315f96;

    padding: 9px 11px;

    border-radius: 10px;

    font-size: 12px;

    font-weight: 700;
}

.no-records {

    color: #7b8798;

    font-size: 13px;

    background: #f8fafc;

    padding: 13px;

    border-radius: 10px;

    line-height: 1.6;
}


/* =========================================
   BUTTONS
   ========================================= */

.actions {

    margin-top: 18px;
}

.primary-btn,
.secondary-btn {

    display: inline-block;

    text-decoration: none;

    padding: 10px 15px;

    border-radius: 9px;

    font-size: 13px;

    font-weight: 800;

    margin-right: 8px;
}

.primary-btn {

    background: #1677e8;

    color: white;
}

.secondary-btn {

    background: #eef2f6;

    color: #43546a;
}


/* =========================================
   EMPTY STATE
   ========================================= */

.empty-state {

    padding: 55px 20px;

    text-align: center;
}

.empty-state h3 {

    margin-bottom: 8px;
}

.empty-state p {

    color: #758297;

    max-width: 560px;

    margin:
        0 auto 20px;

    line-height: 1.6;
}


/* =========================================
   RESPONSIVE
   ========================================= */

@media(max-width:1150px) {

    .details-grid {

        grid-template-columns:
            repeat(2,1fr);
    }

    .summary-grid {

        grid-template-columns:
            repeat(2,1fr);
    }
}


@media(max-width:800px) {

    .layout {

        display: block;
    }

    .sidebar {

        position: static;

        width: 100%;
    }

    .main {

        margin-left: 0;

        width: 100%;
    }

    .content {

        padding: 20px;
    }

    .summary-grid,
    .details-grid {

        grid-template-columns:
            1fr;
    }

    .card-header {

        flex-direction:
            column;
    }

    .badges {

        justify-content:
            flex-start;
    }
}

</style>

</head>


<body>

<div class="layout">


<!-- =========================================
     SIDEBAR
     ========================================= -->

<aside class="sidebar">


    <div class="logo">

        CHAPERON

    </div>


    <div class="tagline">

        FROM BUSINESS IDEA TO APPROVAL —

        <br>

        ONE INTELLIGENT JOURNEY

    </div>


    <div class="user-box">


        <div class="user-label">

            Logged in as

        </div>


        <div class="user-name">

            <%= esc(userName) %>

        </div>


    </div>



    <nav class="menu">


        <div class="menu-heading">

            YOUR JOURNEY

        </div>



        <!-- HOME -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/dashboard">

            <span class="menu-icon">⌂</span>

            Home

        </a>



        <!-- MY BUSINESS -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/business-onboarding">

            <span class="menu-icon">▣</span>

            My Business

        </a>



        <!-- APPROVAL JOURNEY -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/generate-approvals">

            <span class="menu-icon">✓</span>

            My Approval Journey

        </a>



        <!-- DOCUMENTS -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/documents">

            <span class="menu-icon">▤</span>

            Documents

        </a>



        <!-- APPLICATIONS -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/my-applications">

            <span class="menu-icon">▦</span>

            Applications

        </a>



        <!-- INSPECTIONS -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/inspections">

            <span class="menu-icon">⌕</span>

            Inspections

        </a>



        <div class="menu-heading">

            SUPPORT & COMPLIANCE

        </div>



        <!-- GOVERNMENT SCHEMES -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/schemes">

            <span class="menu-icon">★</span>

            Government Schemes

        </a>



        <!-- COMPLIANCE -->

        <a class="menu-item active"
           href="<%= request.getContextPath() %>/entrepreneur/compliance">

            <span class="menu-icon">⚙</span>

            Compliance

        </a>



        <!-- NOTIFICATIONS -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/notifications">

            <span class="menu-icon">●</span>

            Notifications

        </a>



        <!-- HELP -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/help">

            <span class="menu-icon">?</span>

            Help

        </a>



        <div class="menu-heading">

            ACCOUNT

        </div>



        <!-- PROFILE -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/profile">

            <span class="menu-icon">👤</span>

            Profile

        </a>



        <div class="menu-separator"></div>



        <!-- LOGOUT -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/logout">

            <span class="menu-icon">↪</span>

            Logout

        </a>


    </nav>


</aside>



<!-- =========================================
     MAIN CONTENT
     ========================================= -->

<main class="main">


    <div class="topbar">


        <div class="topbar-title">

            Compliance Management

        </div>


        <div class="topbar-user">

            <%= esc(userName) %>

        </div>


    </div>



    <div class="content">


        <!-- =========================================
             HERO
             ========================================= -->

        <div class="hero">


            <h1>

                Compliance & Renewals

            </h1>


            <p>

                Monitor approved licences,
                certificate validity,
                expiry dates,
                renewal requirements
                and ongoing compliance
                obligations from one place.

            </p>


        </div>



        <!-- =========================================
             SUMMARY
             ========================================= -->

        <div class="summary-grid">


            <div class="summary-card">

                <div class="summary-label">

                    Approved Certificates

                </div>

                <div class="summary-value">

                    <%= totalApprovals %>

                </div>

            </div>



            <div class="summary-card">

                <div class="summary-label">

                    Active

                </div>

                <div class="summary-value">

                    <%= activeApprovals %>

                </div>

            </div>



            <div class="summary-card">

                <div class="summary-label">

                    Expiring Soon

                </div>

                <div class="summary-value">

                    <%= expiringSoon %>

                </div>

            </div>



            <div class="summary-card">

                <div class="summary-label">

                    Expired

                </div>

                <div class="summary-value">

                    <%= expiredApprovals %>

                </div>

            </div>



            <div class="summary-card">

                <div class="summary-label">

                    Renewal Required

                </div>

                <div class="summary-value">

                    <%= renewalRequired %>

                </div>

            </div>



            <div class="summary-card">

                <div class="summary-label">

                    Pending Compliance

                </div>

                <div class="summary-value">

                    <%= pendingCompliance %>

                </div>

            </div>


        </div>



        <!-- INFO -->

        <div class="info-box">

            CHAPERON considers a fixed-validity
            approval

            <strong>
                Expiring Soon
            </strong>

            when 90 days or less remain
            before the certificate expiry date.

        </div>



        <!-- =========================================
             APPROVED LICENCES SECTION
             ========================================= -->

        <div class="section-card">


            <div class="section-title">


                <h2>

                    Your Approved Licences & Compliance

                </h2>


                <p>

                    Review validity,
                    renewal information
                    and compliance requirements
                    for each approved application.

                </p>


            </div>



            <%
            if (complianceItems == null ||
                complianceItems.isEmpty()) {
            %>


            <!-- EMPTY STATE -->

            <div class="empty-state">


                <h3>

                    No approved certificates available

                </h3>


                <p>

                    Once one of your applications
                    is approved and a certificate
                    is issued, its validity and
                    compliance information will
                    appear here.

                </p>


                <a class="primary-btn"
                   href="<%= request.getContextPath() %>/entrepreneur/my-applications">

                    View Applications

                </a>


            </div>


            <%
            } else {
            %>



            <div class="compliance-list">


            <%

            for (
                    Map<String, Object> complianceRow
                    : complianceItems
            ) {


                Long applicationId =

                        complianceRow.get(
                                "applicationId"
                        ) != null

                        ? ((Number)
                           complianceRow.get(
                                   "applicationId"
                           )).longValue()

                        : null;



                String approvalName =

                        complianceRow.get(
                                "approvalName"
                        ) != null

                        ? String.valueOf(
                            complianceRow.get(
                                    "approvalName"
                            )
                          )

                        : "Approval";



                String approvalCode =

                        complianceRow.get(
                                "approvalCode"
                        ) != null

                        ? String.valueOf(
                            complianceRow.get(
                                    "approvalCode"
                            )
                          )

                        : "—";



                String applicationNumber =

                        complianceRow.get(
                                "applicationNumber"
                        ) != null

                        ? String.valueOf(
                            complianceRow.get(
                                    "applicationNumber"
                            )
                          )

                        : "—";



                String approvalNumber =

                        complianceRow.get(
                                "approvalNumber"
                        ) != null

                        ? String.valueOf(
                            complianceRow.get(
                                    "approvalNumber"
                            )
                          )

                        : "—";



                String departmentName =

                        complianceRow.get(
                                "departmentName"
                        ) != null

                        ? String.valueOf(
                            complianceRow.get(
                                    "departmentName"
                            )
                          )

                        : "—";



                String businessName =

                        complianceRow.get(
                                "businessName"
                        ) != null

                        ? String.valueOf(
                            complianceRow.get(
                                    "businessName"
                            )
                          )

                        : "—";



                Date approvalDate =

                        (Date)
                        complianceRow.get(
                                "approvalDate"
                        );



                Date validFrom =

                        (Date)
                        complianceRow.get(
                                "validFrom"
                        );



                Date validUntil =

                        (Date)
                        complianceRow.get(
                                "validUntil"
                        );



                String validityStatus =

                        complianceRow.get(
                                "validityStatus"
                        ) != null

                        ? String.valueOf(
                            complianceRow.get(
                                    "validityStatus"
                            )
                          )

                        : "ACTIVE";



                Long daysRemaining =

                        complianceRow.get(
                                "daysRemaining"
                        ) != null

                        ? ((Number)
                           complianceRow.get(
                                   "daysRemaining"
                           )).longValue()

                        : null;



                boolean renewalNeeded =

                        Boolean.TRUE.equals(
                                complianceRow.get(
                                        "renewalRequired"
                                )
                        );



                Object renewalBeforeObject =

                        complianceRow.get(
                                "renewalBeforeDays"
                        );



                String certificateRemarks =

                        complianceRow.get(
                                "certificateRemarks"
                        ) != null

                        ? String.valueOf(
                            complianceRow.get(
                                    "certificateRemarks"
                            )
                          )

                        : null;



                String badgeClass =
                        "active-badge";


                if ("EXPIRING_SOON"
                        .equalsIgnoreCase(
                                validityStatus
                        )) {

                    badgeClass =
                            "expiring-badge";

                } else if ("EXPIRED"
                        .equalsIgnoreCase(
                                validityStatus
                        )) {

                    badgeClass =
                            "expired-badge";
                }



                @SuppressWarnings("unchecked")
                List<Map<String, Object>>
                complianceRecords =

                        (List<Map<String, Object>>)
                        complianceRow.get(
                                "complianceRecords"
                        );



                @SuppressWarnings("unchecked")
                List<Map<String, Object>>
                renewalReminders =

                        (List<Map<String, Object>>)
                        complianceRow.get(
                                "renewalReminders"
                        );

            %>



            <!-- =========================================
                 ONE COMPLIANCE CARD
                 ========================================= -->

            <div class="compliance-card">


                <div class="card-header">


                    <div>


                        <div class="approval-title">

                            <%= esc(approvalName) %>

                        </div>


                        <div class="approval-number">

                            <%= esc(approvalCode) %>

                            |

                            Certificate:

                            <%= esc(approvalNumber) %>

                        </div>


                    </div>



                    <div class="badges">


                        <span class="badge <%= badgeClass %>">

                            <%= esc(
                                    validityStatus
                                    .replace(
                                            "_",
                                            " "
                                    )
                            ) %>

                        </span>


                        <%
                        if (renewalNeeded) {
                        %>


                        <span class="badge renewal-badge">

                            RENEWAL REQUIRED

                        </span>


                        <%
                        }
                        %>


                    </div>


                </div>



                <!-- =========================================
                     DETAILS GRID
                     ========================================= -->

                <div class="details-grid">


                    <!-- BUSINESS -->

                    <div class="detail-box">


                        <div class="detail-label">

                            Business

                        </div>


                        <div class="detail-value">

                            <%= esc(businessName) %>

                        </div>


                    </div>



                    <!-- DEPARTMENT -->

                    <div class="detail-box">


                        <div class="detail-label">

                            Department

                        </div>


                        <div class="detail-value">

                            <%= esc(departmentName) %>

                        </div>


                    </div>



                    <!-- APPLICATION NUMBER -->

                    <div class="detail-box">


                        <div class="detail-label">

                            Application Number

                        </div>


                        <div class="detail-value">

                            <%= esc(applicationNumber) %>

                        </div>


                    </div>



                    <!-- APPROVAL DATE -->

                    <div class="detail-box">


                        <div class="detail-label">

                            Approval Date

                        </div>


                        <div class="detail-value">

                            <%= approvalDate != null
                                    ? approvalDate
                                    : "—" %>

                        </div>


                    </div>



                    <!-- VALID FROM -->

                    <div class="detail-box">


                        <div class="detail-label">

                            Valid From

                        </div>


                        <div class="detail-value">

                            <%= validFrom != null
                                    ? validFrom
                                    : "—" %>

                        </div>


                    </div>



                    <!-- VALID UNTIL -->

                    <div class="detail-box">


                        <div class="detail-label">

                            Valid Until

                        </div>


                        <div class="detail-value">

                            <%= validUntil != null
                                    ? validUntil
                                    : "No Fixed Expiry" %>

                        </div>


                    </div>



                    <!-- DAYS REMAINING -->

                    <div class="detail-box">


                        <div class="detail-label">

                            Days Remaining

                        </div>


                        <div class="detail-value">


                            <%
                            if (daysRemaining == null) {
                            %>


                            No fixed expiry


                            <%
                            } else if (daysRemaining < 0) {
                            %>


                            Expired

                            <%= Math.abs(
                                    daysRemaining
                            ) %>

                            day(s) ago


                            <%
                            } else {
                            %>


                            <%= daysRemaining %>

                            day(s)


                            <%
                            }
                            %>


                        </div>


                    </div>



                    <!-- RENEWAL -->

                    <div class="detail-box">


                        <div class="detail-label">

                            Renewal

                        </div>


                        <div class="detail-value">


                            <%
                            if (renewalNeeded) {
                            %>


                            Required


                            <%
                            if (renewalBeforeObject != null) {
                            %>


                            <br>

                            Apply approximately

                            <%= renewalBeforeObject %>

                            days before expiry


                            <%
                            }
                            %>


                            <%
                            } else {
                            %>


                            Not Required


                            <%
                            }
                            %>


                        </div>


                    </div>


                </div>



                <!-- =========================================
                     CERTIFICATE REMARKS
                     ========================================= -->

                <%
                if (certificateRemarks != null &&
                    !certificateRemarks.isBlank()) {
                %>


                <div class="subsection">


                    <div class="subsection-title">

                        Certificate Remarks

                    </div>


                    <div class="no-records">

                        <%= esc(
                                certificateRemarks
                        ) %>

                    </div>


                </div>


                <%
                }
                %>



                <!-- =========================================
                     COMPLIANCE RECORDS
                     ========================================= -->

                <div class="subsection">


                    <div class="subsection-title">

                        Compliance Requirements

                    </div>


                    <%
                    if (complianceRecords == null ||
                        complianceRecords.isEmpty()) {
                    %>


                    <div class="no-records">

                        No additional compliance
                        requirement has been recorded
                        for this approval.

                    </div>


                    <%
                    } else {


                        for (
                                Map<String, Object> record
                                : complianceRecords
                        ) {


                            String complianceName =

                                    record.get(
                                            "complianceName"
                                    ) != null

                                    ? String.valueOf(
                                        record.get(
                                                "complianceName"
                                        )
                                      )

                                    : "Compliance Requirement";



                            Object dueDate =

                                    record.get(
                                            "dueDate"
                                    );



                            String complianceStatus =

                                    record.get(
                                            "status"
                                    ) != null

                                    ? String.valueOf(
                                        record.get(
                                                "status"
                                        )
                                      )

                                    : "UPCOMING";



                            String remarks =

                                    record.get(
                                            "remarks"
                                    ) != null

                                    ? String.valueOf(
                                        record.get(
                                                "remarks"
                                        )
                                      )

                                    : null;



                            String recordBadge =

                                    "COMPLETED"
                                    .equalsIgnoreCase(
                                            complianceStatus
                                    )

                                    ? "active-badge"

                                    : "expiring-badge";

                    %>



                    <div class="compliance-record">


                        <div class="record-top">


                            <div class="record-name">

                                <%= esc(
                                        complianceName
                                ) %>

                            </div>


                            <span class="badge <%= recordBadge %>">

                                <%= esc(
                                        complianceStatus
                                        .replace(
                                                "_",
                                                " "
                                        )
                                ) %>

                            </span>


                        </div>



                        <div class="record-meta">


                            Due Date:

                            <strong>

                                <%= dueDate != null
                                        ? esc(dueDate)
                                        : "Not Specified" %>

                            </strong>


                            <%
                            if (remarks != null &&
                                !remarks.isBlank()) {
                            %>


                            <br>

                            Remarks:

                            <%= esc(remarks) %>


                            <%
                            }
                            %>


                        </div>


                    </div>


                    <%
                        }
                    }
                    %>


                </div>



                <!-- =========================================
                     RENEWAL REMINDERS
                     ========================================= -->

                <div class="subsection">


                    <div class="subsection-title">

                        Renewal Reminder Schedule

                    </div>


                    <%
                    if (renewalReminders == null ||
                        renewalReminders.isEmpty()) {
                    %>


                    <div class="no-records">


                        <%
                        if (renewalNeeded) {
                        %>


                        No renewal reminders have
                        been generated yet.


                        <%
                        } else {
                        %>


                        Renewal reminder is not
                        required for this approval.


                        <%
                        }
                        %>


                    </div>


                    <%
                    } else {
                    %>



                    <div class="reminder-list">


                    <%

                    for (
                            Map<String, Object> reminder
                            : renewalReminders
                    ) {


                        Object reminderDays =

                                reminder.get(
                                        "reminderDaysBefore"
                                );



                        Object reminderDate =

                                reminder.get(
                                        "reminderDate"
                                );



                        String reminderStatus =

                                reminder.get(
                                        "status"
                                ) != null

                                ? String.valueOf(
                                    reminder.get(
                                            "status"
                                    )
                                  )

                                : "PENDING";

                    %>



                    <div class="reminder-item">


                        <%= reminderDays != null
                                ? esc(reminderDays)
                                : "—" %>

                        days before


                        <br>


                        <span style="font-weight:normal;">

                            <%= reminderDate != null
                                    ? esc(reminderDate)
                                    : "Date pending" %>

                        </span>


                        <br>


                        <%= esc(
                                reminderStatus
                        ) %>


                    </div>


                    <%
                    }
                    %>


                    </div>


                    <%
                    }
                    %>


                </div>



                <!-- =========================================
                     ACTIONS
                     ========================================= -->

                <div class="actions">


                    <%
                    if (applicationId != null) {
                    %>


                    <a class="primary-btn"
                       href="<%= request.getContextPath() %>/entrepreneur/application-details?id=<%= applicationId %>">

                        View Application

                    </a>


                    <%
                    }
                    %>



                    <a class="secondary-btn"
                       href="<%= request.getContextPath() %>/entrepreneur/my-applications">

                        My Applications

                    </a>


                </div>


            </div>


            <%
            }
            %>


            </div>


            <%
            }
            %>


        </div>


    </div>


</main>


</div>



<script>

/*
 * Compatibility function.
 * Ab Help/Profile real pages hain,
 * lekin final cleanup tak function rehne de rahe hain.
 */

function showComingSoon(moduleName) {

    alert(
        moduleName +
        " module will be added in the upcoming steps."
    );
}

</script>


</body>

</html>