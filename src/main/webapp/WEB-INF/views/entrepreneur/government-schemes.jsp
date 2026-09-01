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
    List<Map<String, Object>> schemes =
            (List<Map<String, Object>>)
            request.getAttribute("schemes");


    int totalSchemes = 0;
    int openSchemes = 0;
    int noDeadlineSchemes = 0;

    java.time.LocalDate today =
            java.time.LocalDate.now();


    if (schemes != null) {

        totalSchemes =
                schemes.size();

        for (
            Map<String, Object> schemeRow :
            schemes
        ) {

            Date deadline =
                    (Date)
                    schemeRow.get(
                            "deadline"
                    );

            if (deadline == null) {

                noDeadlineSchemes++;

            } else if (
                    !deadline
                    .toLocalDate()
                    .isBefore(today)
            ) {

                openSchemes++;
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Government Schemes | CHAPERON</title>

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


/* ==================================================
   SIDEBAR
   ================================================== */

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


/* ==================================================
   MAIN
   ================================================== */

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

.user-info {
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

.user-name {
    font-size: 14px;
    font-weight: 800;
}

.user-role {
    font-size: 11px;
    color: #748196;
    margin-top: 3px;
}

.content {
    padding: 32px;
}


/* ==================================================
   PAGE HEADER
   ================================================== */

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
    max-width: 850px;
}


/* ==================================================
   INFORMATION
   ================================================== */

.info-box {
    background: #eef6ff;
    border: 1px solid #cfe4ff;
    border-radius: 14px;
    padding: 18px 20px;
    margin-bottom: 25px;
}

.info-title {
    font-weight: 900;
    color: #155da9;
    margin-bottom: 6px;
}

.info-text {
    color: #46627e;
    line-height: 1.6;
    font-size: 13px;
}


/* ==================================================
   SUMMARY
   ================================================== */

.summary-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 18px;
    margin-bottom: 28px;
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


/* ==================================================
   SCHEME CARDS
   ================================================== */

.scheme-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
}

.scheme-card {
    background: white;
    border: 1px solid #e4e9f0;
    border-radius: 16px;
    overflow: hidden;
    transition: 0.2s;
}

.scheme-card:hover {
    transform: translateY(-2px);
    box-shadow:
        0 12px 30px
        rgba(30,55,90,0.07);
}

.scheme-top {
    padding: 22px;
    border-bottom: 1px solid #edf0f4;
}

.scheme-top-row {
    display: flex;
    justify-content: space-between;
    gap: 15px;
    align-items: flex-start;
}

.scheme-name {
    font-size: 18px;
    font-weight: 900;
    line-height: 1.4;
}

.department-badge {
    flex-shrink: 0;
    display: inline-block;
    background: #edf5ff;
    color: #1768c7;
    padding: 6px 9px;
    border-radius: 7px;
    font-size: 11px;
    font-weight: 900;
}

.scheme-description {
    margin-top: 12px;
    color: #6f7c8e;
    font-size: 13px;
    line-height: 1.7;
}

.scheme-body {
    padding: 22px;
}

.detail-section {
    margin-bottom: 18px;
}

.detail-section:last-child {
    margin-bottom: 0;
}

.detail-label {
    font-size: 11px;
    font-weight: 900;
    color: #748196;
    letter-spacing: 0.5px;
    margin-bottom: 7px;
    text-transform: uppercase;
}

.detail-value {
    font-size: 13px;
    color: #25374d;
    line-height: 1.7;
}

.benefit-box {
    background: #edf9f3;
    border: 1px solid #ccebdc;
    color: #206849;
    border-radius: 10px;
    padding: 12px 14px;
}


/* ==================================================
   DEADLINE
   ================================================== */

.deadline {
    display: inline-block;
    padding: 7px 10px;
    border-radius: 8px;
    font-size: 11px;
    font-weight: 900;
}

.deadline-open {
    background: #e8f8ef;
    color: #188052;
}

.deadline-expired {
    background: #fff0ef;
    color: #b23d36;
}

.deadline-none {
    background: #f0f2f5;
    color: #687487;
}


/* ==================================================
   FOOTER
   ================================================== */

.scheme-footer {
    padding: 17px 22px;
    background: #fbfcfe;
    border-top: 1px solid #edf0f4;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 15px;
}

.official-btn {
    display: inline-block;
    padding: 10px 14px;
    background: #1677e8;
    color: white;
    border-radius: 9px;
    font-size: 12px;
    font-weight: 900;
}

.official-btn:hover {
    background: #0f67c8;
}

.no-link {
    font-size: 12px;
    color: #8a95a4;
}

.small-note {
    font-size: 12px;
    color: #7b8798;
}


/* ==================================================
   EMPTY STATE
   ================================================== */

.empty-state {
    background: white;
    border: 1px solid #e4e9f0;
    border-radius: 16px;
    padding: 60px 25px;
    text-align: center;
}

.empty-icon {
    font-size: 42px;
}

.empty-state h2 {
    margin: 15px 0 8px;
}

.empty-state p {
    margin: 0;
    color: #748196;
    line-height: 1.6;
}


/* ==================================================
   RESPONSIVE
   ================================================== */

@media (max-width: 1000px) {

    .sidebar {
        display: none;
    }

    .main {
        margin-left: 0;
        width: 100%;
    }

    .scheme-grid {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 700px) {

    .content {
        padding: 20px;
    }

    .topbar {
        padding: 0 20px;
    }

    .summary-grid {
        grid-template-columns: 1fr;
    }

    .scheme-top-row {
        display: block;
    }

    .department-badge {
        margin-top: 10px;
    }

    .scheme-footer {
        display: block;
    }

    .official-btn {
        margin-top: 10px;
    }
}

</style>

</head>

<body>

<div class="layout">


<!-- ==================================================
     SIDEBAR
     ================================================== -->

<aside class="sidebar">

    <div class="brand">

        <div class="brand-name">
            CHAPERON
        </div>

        <div class="brand-subtitle">
            Business Approval Navigator
        </div>

    </div>


    <div class="menu-title">
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



    <div class="menu-title">
        SUPPORT & COMPLIANCE
    </div>



    <!-- GOVERNMENT SCHEMES -->

    <a class="menu-item active"
       href="<%= request.getContextPath() %>/entrepreneur/schemes">

        <span class="menu-icon">★</span>
        Government Schemes

    </a>



    <!-- COMPLIANCE -->

    <a class="menu-item"
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



    <!-- HELP
         Step 15B me actual module banega -->

    <a class="menu-item"
       href="javascript:void(0)"
       onclick="showComingSoon('Help')">

        <span class="menu-icon">?</span>
        Help

    </a>



    <div class="menu-title">
        ACCOUNT
    </div>



    <!-- PROFILE -->

    <a class="menu-item"
       href="<%= request.getContextPath() %>/entrepreneur/profile">

        <span class="menu-icon">👤</span>
        Profile

    </a>



    <div class="logout">

        <a class="menu-item"
           href="<%= request.getContextPath() %>/logout">

            <span class="menu-icon">↪</span>
            Logout

        </a>

    </div>

</aside>



<!-- ==================================================
     MAIN CONTENT
     ================================================== -->

<main class="main">


<header class="topbar">


    <div class="topbar-title">
        Government Schemes
    </div>


    <div class="user-info">


        <div class="avatar">

            <%= esc(
                    userName
                    .substring(
                            0,
                            1
                    )
                    .toUpperCase()
            ) %>

        </div>


        <div>


            <div class="user-name">

                <%= esc(userName) %>

            </div>


            <div class="user-role">
                Entrepreneur
            </div>


        </div>


    </div>


</header>



<div class="content">


<!-- ==================================================
     PAGE HEADER
     ================================================== -->

<div class="page-header">


    <h1>
        Government Support & Schemes
    </h1>


    <p>

        Explore government schemes,
        incentives and support programs
        that may help your business.

        Always verify current eligibility,
        benefits, deadlines and conditions
        on the official government portal
        before applying.

    </p>


</div>



<!-- ==================================================
     INFORMATION
     ================================================== -->

<div class="info-box">


    <div class="info-title">
        Important
    </div>


    <div class="info-text">

        CHAPERON provides scheme information
        as guidance.

        Scheme eligibility, benefits,
        deadlines and conditions may change.

        Use the official information link
        for the latest authoritative details.

    </div>


</div>



<!-- ==================================================
     SUMMARY
     ================================================== -->

<div class="summary-grid">


    <div class="summary-card">

        <div class="summary-label">
            Available Schemes
        </div>

        <div class="summary-number">
            <%= totalSchemes %>
        </div>

    </div>



    <div class="summary-card">

        <div class="summary-label">
            Open / Upcoming
        </div>

        <div class="summary-number">
            <%= openSchemes %>
        </div>

    </div>



    <div class="summary-card">

        <div class="summary-label">
            No Fixed Deadline
        </div>

        <div class="summary-number">
            <%= noDeadlineSchemes %>
        </div>

    </div>


</div>



<!-- ==================================================
     EMPTY STATE
     ================================================== -->

<%
if (schemes == null ||
    schemes.isEmpty()) {
%>


<div class="empty-state">


    <div class="empty-icon">
        ★
    </div>


    <h2>
        No active schemes currently available
    </h2>


    <p>

        New government schemes added by
        the administrator will appear
        here automatically.

    </p>


</div>


<%
} else {
%>



<!-- ==================================================
     SCHEME LIST
     ================================================== -->

<div class="scheme-grid">


<%
for (
    Map<String, Object> schemeRow :
    schemes
) {


    String schemeName =
            (String)
            schemeRow.get(
                    "schemeName"
            );


    String description =
            (String)
            schemeRow.get(
                    "description"
            );


    String eligibility =
            (String)
            schemeRow.get(
                    "eligibility"
            );


    String benefit =
            (String)
            schemeRow.get(
                    "benefit"
            );


    Date deadline =
            (Date)
            schemeRow.get(
                    "deadline"
            );


    String officialInformationUrl =
            (String)
            schemeRow.get(
                    "officialInformationUrl"
            );


    String departmentName =
            (String)
            schemeRow.get(
                    "departmentName"
            );


    String departmentCode =
            (String)
            schemeRow.get(
                    "departmentCode"
            );


    if (schemeName == null) {
        schemeName = "";
    }

    if (description == null) {
        description = "";
    }

    if (eligibility == null) {
        eligibility = "";
    }

    if (benefit == null) {
        benefit = "";
    }

    if (officialInformationUrl == null) {
        officialInformationUrl = "";
    }

    if (departmentName == null) {
        departmentName = "";
    }

    if (departmentCode == null) {
        departmentCode = "";
    }


    boolean expired =
            deadline != null &&
            deadline
            .toLocalDate()
            .isBefore(today);
%>



<div class="scheme-card">


    <div class="scheme-top">


        <div class="scheme-top-row">


            <div class="scheme-name">

                <%= esc(schemeName) %>

            </div>



            <%
            if (!departmentName.isBlank()) {
            %>


            <span class="department-badge">

                <%= departmentCode.isBlank()
                        ? esc(departmentName)
                        : esc(departmentCode) %>

            </span>


            <%
            } else {
            %>


            <span class="department-badge">
                GENERAL
            </span>


            <%
            }
            %>


        </div>



        <%
        if (!description.isBlank()) {
        %>


        <div class="scheme-description">

            <%= esc(description) %>

        </div>


        <%
        }
        %>


    </div>



    <div class="scheme-body">


        <!-- ==========================================
             ELIGIBILITY
             ========================================== -->

        <div class="detail-section">


            <div class="detail-label">
                Eligibility
            </div>


            <div class="detail-value">

                <%= eligibility.isBlank()
                        ? "Eligibility details are not currently specified."
                        : esc(eligibility) %>

            </div>


        </div>



        <!-- ==========================================
             BENEFITS
             ========================================== -->

        <div class="detail-section">


            <div class="detail-label">
                Benefits
            </div>


            <div class="detail-value benefit-box">

                <%= benefit.isBlank()
                        ? "Benefit details are not currently specified."
                        : esc(benefit) %>

            </div>


        </div>



        <!-- ==========================================
             DEADLINE
             ========================================== -->

        <div class="detail-section">


            <div class="detail-label">
                Application Deadline
            </div>


            <%
            if (deadline == null) {
            %>


            <span class="deadline deadline-none">

                No Fixed Deadline

            </span>


            <%
            } else if (expired) {
            %>


            <span class="deadline deadline-expired">

                <%= deadline %>
                — Deadline Passed

            </span>


            <%
            } else {
            %>


            <span class="deadline deadline-open">

                <%= deadline %>
                — Open / Upcoming

            </span>


            <%
            }
            %>


        </div>



        <!-- ==========================================
             DEPARTMENT
             ========================================== -->

        <%
        if (!departmentName.isBlank()) {
        %>


        <div class="detail-section">


            <div class="detail-label">
                Responsible Department
            </div>


            <div class="detail-value">


                <%= esc(departmentName) %>


                <%
                if (!departmentCode.isBlank()) {
                %>


                (<%= esc(departmentCode) %>)


                <%
                }
                %>


            </div>


        </div>


        <%
        }
        %>


    </div>



    <!-- ==================================================
         FOOTER
         ================================================== -->

    <div class="scheme-footer">


        <div class="small-note">


            <%
            if (expired) {
            %>


            This listed deadline has passed.


            <%
            } else {
            %>


            Verify details before applying.


            <%
            }
            %>


        </div>



        <%
        if (!officialInformationUrl.isBlank()) {
        %>


        <a class="official-btn"
           href="<%= esc(officialInformationUrl) %>"
           target="_blank"
           rel="noopener noreferrer">

            View Official Information ↗

        </a>


        <%
        } else {
        %>


        <span class="no-link">

            Official link not available

        </span>


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
}
%>


</div>

</main>

</div>



<script>

function showComingSoon(moduleName) {

    alert(
        moduleName +
        " module will be added in the next step."
    );
}

</script>


</body>

</html>