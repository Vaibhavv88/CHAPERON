<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.sql.Time" %>

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
    String userName =
            (String) session.getAttribute("userName");

    if (userName == null ||
        userName.isBlank()) {

        userName = "Entrepreneur";
    }


    @SuppressWarnings("unchecked")
    List<Map<String, Object>> inspections =
            (List<Map<String, Object>>)
            request.getAttribute("inspections");


    Integer totalInspections =
            (Integer)
            request.getAttribute("totalInspections");

    Integer scheduledInspections =
            (Integer)
            request.getAttribute("scheduledInspections");

    Integer completedInspections =
            (Integer)
            request.getAttribute("completedInspections");

    Integer passedInspections =
            (Integer)
            request.getAttribute("passedInspections");


    if (totalInspections == null) {
        totalInspections = 0;
    }

    if (scheduledInspections == null) {
        scheduledInspections = 0;
    }

    if (completedInspections == null) {
        completedInspections = 0;
    }

    if (passedInspections == null) {
        passedInspections = 0;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>My Inspections | CHAPERON</title>


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

.layout {
    display: flex;
    min-height: 100vh;
}


/* ==============================
   SIDEBAR
   ============================== */

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


.user-box .small {

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


/* ==============================
   MAIN
   ============================== */

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


/* ==============================
   HERO
   ============================== */

.hero {

    background: white;

    border:
        1px solid #e5eaf1;

    border-radius: 20px;

    padding: 28px;

    margin-bottom: 25px;

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


/* ==============================
   SUMMARY
   ============================== */

.summary-grid {

    display: grid;

    grid-template-columns:
        repeat(4, 1fr);

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


.summary-label {

    color: #758297;

    font-size: 12px;

    font-weight: 800;

    text-transform: uppercase;

    margin-bottom: 10px;
}


.summary-value {

    font-size: 30px;

    font-weight: 900;

    color: #182c48;
}


/* ==============================
   SECTION
   ============================== */

.section-card {

    background: white;

    border:
        1px solid #e4eaf1;

    border-radius: 18px;

    padding: 25px;
}


.section-title {

    margin-bottom: 22px;
}


.section-title h2 {

    margin: 0 0 7px;

    font-size: 21px;
}


.section-title p {

    margin: 0;

    color: #728096;

    font-size: 14px;

    line-height: 1.6;
}


/* ==============================
   INSPECTIONS
   ============================== */

.inspection-list {

    display: grid;

    gap: 18px;
}


.inspection-card {

    border:
        1px solid #e4eaf1;

    border-radius: 16px;

    padding: 22px;

    background: white;
}


.inspection-header {

    display: flex;

    justify-content:
        space-between;

    align-items:
        flex-start;

    gap: 15px;

    margin-bottom: 18px;
}


.inspection-title {

    font-size: 18px;

    font-weight: 900;

    margin-bottom: 6px;
}


.application-number {

    color: #1768c7;

    font-size: 12px;

    font-weight: 800;
}


.badges {

    display: flex;

    gap: 8px;

    flex-wrap: wrap;

    justify-content:
        flex-end;
}


.badge {

    padding: 6px 10px;

    border-radius: 20px;

    font-size: 11px;

    font-weight: 900;

    white-space: nowrap;
}


.status-scheduled {

    background: #e8f2ff;

    color: #1768c7;
}


.status-completed {

    background: #e8f7ed;

    color: #267a42;
}


.status-rescheduled {

    background: #fff2d9;

    color: #986000;
}


.status-cancelled {

    background: #ffe9e7;

    color: #c43329;
}


.result-passed {

    background: #e8f7ed;

    color: #267a42;
}


.result-failed {

    background: #ffe9e7;

    color: #c43329;
}


.result-partial {

    background: #fff2d9;

    color: #986000;
}


.result-pending {

    background: #eef2f6;

    color: #65758a;
}


.details-grid {

    display: grid;

    grid-template-columns:
        repeat(3, 1fr);

    gap: 14px;
}


.detail-box {

    background: #f8fafc;

    border:
        1px solid #edf1f5;

    padding: 14px;

    border-radius: 12px;
}


.detail-label {

    font-size: 11px;

    font-weight: 800;

    color: #7b8798;

    text-transform: uppercase;

    margin-bottom: 6px;
}


.detail-value {

    font-size: 14px;

    font-weight: 700;

    color: #25364c;

    line-height: 1.5;

    word-break: break-word;
}


.text-section {

    margin-top: 15px;

    padding: 16px;

    border:
        1px solid #edf1f5;

    border-radius: 12px;

    background: #fbfcfe;
}


.text-section-title {

    font-size: 12px;

    color: #68778a;

    font-weight: 900;

    margin-bottom: 8px;
}


.text-section-content {

    font-size: 14px;

    color: #34465c;

    line-height: 1.7;

    white-space: pre-wrap;

    word-break: break-word;
}


/* ==============================
   BUTTONS
   ============================== */

.actions {

    margin-top: 18px;

    display: flex;

    gap: 10px;

    flex-wrap: wrap;
}


.primary-btn,
.secondary-btn {

    text-decoration: none;

    padding: 11px 17px;

    border-radius: 9px;

    font-size: 13px;

    font-weight: 800;

    display: inline-block;
}


.primary-btn {

    background: #1677e8;

    color: white;
}


.primary-btn:hover {

    background: #0f67c8;
}


.secondary-btn {

    background: #eef2f6;

    color: #43546a;
}


.secondary-btn:hover {

    background: #e1e7ed;
}


/* ==============================
   EMPTY STATE
   ============================== */

.empty-state {

    text-align: center;

    padding: 55px 20px;
}


.empty-icon {

    font-size: 40px;

    margin-bottom: 15px;
}


.empty-state h3 {

    margin: 0 0 8px;
}


.empty-state p {

    color: #758297;

    margin:
        0 auto 20px;

    max-width: 500px;

    line-height: 1.6;
}


/* ==============================
   RESPONSIVE
   ============================== */

@media(max-width: 1100px) {

    .summary-grid {

        grid-template-columns:
            repeat(2, 1fr);
    }

    .details-grid {

        grid-template-columns:
            repeat(2, 1fr);
    }
}


@media(max-width: 800px) {

    .sidebar {

        position: static;

        width: 100%;
    }

    .layout {

        display: block;
    }

    .main {

        margin-left: 0;

        width: 100%;
    }

    .summary-grid,
    .details-grid {

        grid-template-columns:
            1fr;
    }

    .inspection-header {

        flex-direction:
            column;
    }

    .badges {

        justify-content:
            flex-start;
    }

    .content {

        padding: 20px;
    }

    .topbar {

        padding: 15px 20px;
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


    <div class="logo">
        CHAPERON
    </div>


    <div class="tagline">

        FROM BUSINESS IDEA TO APPROVAL —

        <br>

        ONE INTELLIGENT JOURNEY

    </div>


    <div class="user-box">

        <div class="small">
            Logged in as
        </div>

        <div class="user-name">
            <%= esc(userName) %>
        </div>

    </div>



    <nav class="menu">


        <!-- HOME -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/dashboard">

            <span class="menu-icon">
                ⌂
            </span>

            Home

        </a>



        <!-- MY BUSINESS -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/business-onboarding">

            <span class="menu-icon">
                ▣
            </span>

            My Business

        </a>



        <!-- APPROVAL JOURNEY -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/generate-approvals">

            <span class="menu-icon">
                ✓
            </span>

            My Approval Journey

        </a>



        <!-- DOCUMENTS -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/documents">

            <span class="menu-icon">
                ▤
            </span>

            Documents

        </a>



        <!-- APPLICATIONS -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/my-applications">

            <span class="menu-icon">
                ▦
            </span>

            Applications

        </a>



        <!-- INSPECTIONS -->

        <a class="menu-item active"
           href="<%= request.getContextPath() %>/entrepreneur/inspections">

            <span class="menu-icon">
                ⌕
            </span>

            Inspections

        </a>



        <!-- GOVERNMENT SCHEMES -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/schemes">

            <span class="menu-icon">
                ★
            </span>

            Government Schemes

        </a>



        <!-- COMPLIANCE -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/compliance">

            <span class="menu-icon">
                ⚙
            </span>

            Compliance

        </a>



        <!-- NOTIFICATIONS -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/notifications">

            <span class="menu-icon">
                🔔
            </span>

            Notifications

        </a>



        <!-- HELP -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/help">

            <span class="menu-icon">
                ?
            </span>

            Help

        </a>



        <!-- PROFILE -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/profile">

            <span class="menu-icon">
                👤
            </span>

            Profile

        </a>



        <div class="menu-separator">
        </div>



        <!-- LOGOUT -->

        <a class="menu-item"
           href="<%= request.getContextPath() %>/logout">

            <span class="menu-icon">
                ↪
            </span>

            Logout

        </a>


    </nav>


</aside>



<!-- =====================================
     MAIN
     ===================================== -->

<main class="main">


    <div class="topbar">


        <div class="topbar-title">
            Inspection Management
        </div>


        <div class="topbar-user">
            <%= esc(userName) %>
        </div>


    </div>



    <div class="content">


        <!-- HERO -->

        <div class="hero">


            <h1>
                My Inspections
            </h1>


            <p>

                View inspection schedules,
                concerned officers, locations,
                findings and final inspection
                results related to your approval
                applications.

            </p>


        </div>



        <!-- SUMMARY -->

        <div class="summary-grid">


            <div class="summary-card">


                <div class="summary-label">
                    Total Inspections
                </div>


                <div class="summary-value">
                    <%= totalInspections %>
                </div>


            </div>



            <div class="summary-card">


                <div class="summary-label">
                    Scheduled
                </div>


                <div class="summary-value">
                    <%= scheduledInspections %>
                </div>


            </div>



            <div class="summary-card">


                <div class="summary-label">
                    Completed
                </div>


                <div class="summary-value">
                    <%= completedInspections %>
                </div>


            </div>



            <div class="summary-card">


                <div class="summary-label">
                    Passed
                </div>


                <div class="summary-value">
                    <%= passedInspections %>
                </div>


            </div>


        </div>



        <!-- INSPECTION HISTORY -->

        <div class="section-card">


            <div class="section-title">


                <h2>
                    Inspection History
                </h2>


                <p>

                    All inspections connected
                    with your applications are
                    listed below.

                </p>


            </div>



            <%
            if (inspections == null ||
                inspections.isEmpty()) {
            %>


            <!-- EMPTY STATE -->

            <div class="empty-state">


                <div class="empty-icon">
                    ⌕
                </div>


                <h3>
                    No inspections scheduled yet
                </h3>


                <p>

                    When a government officer
                    schedules an inspection for
                    one of your applications,
                    its date, time and details
                    will appear here automatically.

                </p>


                <a class="primary-btn"
                   href="<%= request.getContextPath() %>/entrepreneur/my-applications">

                    View My Applications

                </a>


            </div>


            <%
            } else {
            %>


            <div class="inspection-list">


            <%
            for (Map<String, Object> inspectionRow
                    : inspections) {


                Long applicationId =

                        inspectionRow.get(
                                "applicationId"
                        ) != null

                        ? ((Number)
                           inspectionRow.get(
                                   "applicationId"
                           )).longValue()

                        : null;


                String inspectionType =

                        (String)
                        inspectionRow.get(
                                "inspectionType"
                        );


                String applicationNumber =

                        (String)
                        inspectionRow.get(
                                "applicationNumber"
                        );


                String approvalName =

                        (String)
                        inspectionRow.get(
                                "approvalName"
                        );


                String departmentName =

                        (String)
                        inspectionRow.get(
                                "departmentName"
                        );


                String officerName =

                        (String)
                        inspectionRow.get(
                                "officerName"
                        );


                String officerDesignation =

                        (String)
                        inspectionRow.get(
                                "officerDesignation"
                        );


                String employeeCode =

                        (String)
                        inspectionRow.get(
                                "employeeCode"
                        );


                Date inspectionDate =

                        (Date)
                        inspectionRow.get(
                                "inspectionDate"
                        );


                Time inspectionTime =

                        (Time)
                        inspectionRow.get(
                                "inspectionTime"
                        );


                String location =

                        (String)
                        inspectionRow.get(
                                "location"
                        );


                String status =

                        (String)
                        inspectionRow.get(
                                "status"
                        );


                String result =

                        (String)
                        inspectionRow.get(
                                "result"
                        );


                String remarks =

                        (String)
                        inspectionRow.get(
                                "remarks"
                        );


                String inspectionNotes =

                        (String)
                        inspectionRow.get(
                                "inspectionNotes"
                        );


                String recommendation =

                        (String)
                        inspectionRow.get(
                                "recommendation"
                        );



                String statusClass =
                        "status-scheduled";


                if ("COMPLETED"
                        .equalsIgnoreCase(status)) {

                    statusClass =
                            "status-completed";

                } else if ("RESCHEDULED"
                        .equalsIgnoreCase(status)) {

                    statusClass =
                            "status-rescheduled";

                } else if ("CANCELLED"
                        .equalsIgnoreCase(status)) {

                    statusClass =
                            "status-cancelled";
                }



                String resultClass =
                        "result-pending";


                if ("PASSED"
                        .equalsIgnoreCase(result)) {

                    resultClass =
                            "result-passed";

                } else if ("FAILED"
                        .equalsIgnoreCase(result)) {

                    resultClass =
                            "result-failed";

                } else if ("PARTIALLY_COMPLIANT"
                        .equalsIgnoreCase(result)) {

                    resultClass =
                            "result-partial";
                }
            %>



            <!-- =====================================
                 ONE INSPECTION CARD
                 ===================================== -->

            <div class="inspection-card">


                <div class="inspection-header">


                    <div>


                        <div class="inspection-title">

                            <%= inspectionType != null &&
                                !inspectionType.isBlank()

                                ? esc(inspectionType)

                                : "Government Inspection" %>

                        </div>


                        <div class="application-number">

                            Application:

                            <%= applicationNumber != null

                                ? esc(applicationNumber)

                                : "Not Available" %>

                        </div>


                    </div>



                    <div class="badges">


                        <!-- STATUS -->

                        <span class="badge <%= statusClass %>">

                            <%= status != null

                                ? esc(
                                    status.replace(
                                            "_",
                                            " "
                                    )
                                  )

                                : "SCHEDULED" %>

                        </span>



                        <!-- RESULT -->

                        <span class="badge <%= resultClass %>">

                            <%= result != null

                                ? esc(
                                    result.replace(
                                            "_",
                                            " "
                                    )
                                  )

                                : "RESULT PENDING" %>

                        </span>


                    </div>


                </div>



                <!-- DETAILS GRID -->

                <div class="details-grid">


                    <!-- APPROVAL -->

                    <div class="detail-box">


                        <div class="detail-label">
                            Approval
                        </div>


                        <div class="detail-value">

                            <%= approvalName != null

                                ? esc(approvalName)

                                : "Not Available" %>

                        </div>


                    </div>



                    <!-- DEPARTMENT -->

                    <div class="detail-box">


                        <div class="detail-label">
                            Department
                        </div>


                        <div class="detail-value">

                            <%= departmentName != null

                                ? esc(departmentName)

                                : "Concerned Department" %>

                        </div>


                    </div>



                    <!-- DATE -->

                    <div class="detail-box">


                        <div class="detail-label">
                            Inspection Date
                        </div>


                        <div class="detail-value">

                            <%= inspectionDate != null

                                ? esc(inspectionDate)

                                : "Not Scheduled" %>

                        </div>


                    </div>



                    <!-- TIME -->

                    <div class="detail-box">


                        <div class="detail-label">
                            Inspection Time
                        </div>


                        <div class="detail-value">

                            <%= inspectionTime != null

                                ? esc(inspectionTime)

                                : "Not Specified" %>

                        </div>


                    </div>



                    <!-- LOCATION -->

                    <div class="detail-box">


                        <div class="detail-label">
                            Location
                        </div>


                        <div class="detail-value">

                            <%= location != null &&
                                !location.isBlank()

                                ? esc(location)

                                : "Not Specified" %>

                        </div>


                    </div>



                    <!-- OFFICER -->

                    <div class="detail-box">


                        <div class="detail-label">
                            Officer
                        </div>


                        <div class="detail-value">


                            <%= officerName != null &&
                                !officerName.isBlank()

                                ? esc(officerName)

                                : "Assigned Officer" %>


                            <%
                            if (officerDesignation != null &&
                                !officerDesignation.isBlank()) {
                            %>

                            <br>

                            <span style="
                                font-size:12px;
                                color:#748298;">

                                <%= esc(
                                        officerDesignation
                                ) %>

                            </span>

                            <%
                            }
                            %>


                            <%
                            if (employeeCode != null &&
                                !employeeCode.isBlank()) {
                            %>

                            <br>

                            <span style="
                                font-size:11px;
                                color:#8b96a5;">

                                ID:

                                <%= esc(
                                        employeeCode
                                ) %>

                            </span>

                            <%
                            }
                            %>


                        </div>


                    </div>


                </div>



                <!-- =====================================
                     SCHEDULING REMARKS
                     ===================================== -->

                <%
                if (remarks != null &&
                    !remarks.isBlank()) {
                %>


                <div class="text-section">


                    <div class="text-section-title">
                        Scheduling Remarks
                    </div>


                    <div class="text-section-content">
                        <%= esc(remarks) %>
                    </div>


                </div>


                <%
                }
                %>



                <!-- =====================================
                     INSPECTION NOTES
                     ===================================== -->

                <%
                if (inspectionNotes != null &&
                    !inspectionNotes.isBlank()) {
                %>


                <div class="text-section">


                    <div class="text-section-title">
                        Inspection Notes
                    </div>


                    <div class="text-section-content">

                        <%= esc(
                                inspectionNotes
                        ) %>

                    </div>


                </div>


                <%
                }
                %>



                <!-- =====================================
                     OFFICER RECOMMENDATION
                     ===================================== -->

                <%
                if (recommendation != null &&
                    !recommendation.isBlank()) {
                %>


                <div class="text-section">


                    <div class="text-section-title">
                        Officer Recommendation
                    </div>


                    <div class="text-section-content">

                        <%= esc(
                                recommendation
                        ) %>

                    </div>


                </div>


                <%
                }
                %>



                <!-- =====================================
                     ACTIONS
                     ===================================== -->

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
 * Kept for compatibility with any old
 * placeholder menu item if one remains.
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