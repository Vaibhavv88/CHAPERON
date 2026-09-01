<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.chaperon.model.BusinessApproval" %>

<%
    List<BusinessApproval> recommendations =
            (List<BusinessApproval>)
            request.getAttribute("recommendations");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Approval Roadmap | CHAPERON</title>

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

.topbar {
    min-height: 70px;
    background: white;
    border-bottom: 1px solid #e4e9f0;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 6%;
}

.logo {
    font-size: 25px;
    font-weight: 800;
    color: #10233f;
}

.topbar-right {
    display: flex;
    gap: 14px;
    align-items: center;
}

.dashboard-link {
    text-decoration: none;
    color: #44546a;
    font-weight: 600;
}

.page {
    padding: 45px 20px 70px;
}

.container {
    max-width: 1100px;
    margin: auto;
}

.header-card {
    background: white;
    border: 1px solid #e4eaf1;
    border-radius: 20px;
    padding: 34px;
    margin-bottom: 28px;
    box-shadow: 0 10px 30px rgba(31, 61, 96, 0.07);
}

.header-card h1 {
    margin: 0 0 10px;
    font-size: 34px;
}

.header-card p {
    margin: 0;
    color: #66768a;
    line-height: 1.65;
    font-size: 16px;
}

.stats {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 18px;
    margin-top: 26px;
}

.stat {
    background: #f7faff;
    border: 1px solid #e3ebf4;
    border-radius: 14px;
    padding: 18px;
}

.stat-label {
    font-size: 13px;
    color: #748197;
    margin-bottom: 8px;
}

.stat-value {
    font-size: 24px;
    font-weight: 800;
}

.section-title {
    font-size: 22px;
    margin: 30px 0 18px;
}

.approval-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
}

.approval-card {
    background: white;
    border: 1px solid #e3e9f0;
    border-radius: 18px;
    padding: 24px;
    box-shadow: 0 8px 24px rgba(30, 55, 90, 0.06);
}

.card-top {
    display: flex;
    justify-content: space-between;
    gap: 15px;
    align-items: flex-start;
}

.approval-number {
    width: 42px;
    height: 42px;
    border-radius: 12px;
    background: #eef5ff;
    color: #1768c7;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 800;
    flex-shrink: 0;
}

.approval-info {
    flex: 1;
}

.approval-info h3 {
    margin: 0 0 7px;
    font-size: 20px;
}

.small-text {
    font-size: 13px;
    color: #768398;
}

.badges {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
    margin: 18px 0;
}

.badge {
    display: inline-block;
    padding: 7px 11px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 700;
}

.required {
    background: #ffecec;
    color: #b42318;
}

.conditional {
    background: #fff5df;
    color: #9b6300;
}

.recommended {
    background: #eaf4ff;
    color: #1768c7;
}

.high {
    background: #ffe9e7;
    color: #c43329;
}

.medium {
    background: #fff2d9;
    color: #986000;
}

.low {
    background: #eaf7ef;
    color: #267a42;
}

.status {
    background: #eef2f7;
    color: #4c5d72;
}

.mandatory {
    background: #f2eefe;
    color: #6246a8;
}

.reason-box {
    background: #f8fafc;
    border: 1px solid #e7ecf2;
    border-radius: 12px;
    padding: 15px;
    line-height: 1.55;
    color: #56667a;
    min-height: 82px;
}

.reason-title {
    font-weight: 700;
    color: #26384f;
    margin-bottom: 5px;
    font-size: 13px;
}

.actions {
    margin-top: 20px;
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

.primary-btn,
.secondary-btn {
    display: inline-block;
    text-decoration: none;
    padding: 12px 17px;
    border-radius: 9px;
    font-size: 14px;
    font-weight: 700;
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
    color: #41536a;
}

.empty-card {
    background: white;
    border: 1px solid #e4eaf1;
    border-radius: 18px;
    padding: 45px;
    text-align: center;
}

.empty-icon {
    font-size: 45px;
    margin-bottom: 15px;
}

.empty-card h2 {
    margin-bottom: 10px;
}

.empty-card p {
    color: #68778a;
    line-height: 1.6;
}

.footer-actions {
    margin-top: 30px;
}

@media (max-width: 800px) {

    .approval-grid {
        grid-template-columns: 1fr;
    }

    .stats {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 600px) {

    .topbar {
        padding: 15px 20px;
        align-items: flex-start;
    }

    .topbar-right {
        flex-direction: column;
        align-items: flex-end;
    }

    .header-card {
        padding: 24px;
    }

    .header-card h1 {
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

    <div class="topbar-right">

        <a class="dashboard-link"
           href="<%= request.getContextPath() %>/entrepreneur/dashboard">

            Dashboard

        </a>

    </div>

</div>

<div class="page">

<div class="container">

    <div class="header-card">

        <h1>
            Your Approval Roadmap
        </h1>

        <p>
            Based on your business profile, CHAPERON has identified
            the approvals and compliance requirements that may apply
            to your business.
        </p>

        <div class="stats">

            <div class="stat">

                <div class="stat-label">
                    Total Approvals
                </div>

                <div class="stat-value">

                    <%= recommendations == null
                            ? 0
                            : recommendations.size() %>

                </div>

            </div>

            <div class="stat">

                <div class="stat-label">
                    Current Stage
                </div>

                <div class="stat-value"
                     style="font-size:18px;">

                    Planning

                </div>

            </div>

            <div class="stat">

                <div class="stat-label">
                    Roadmap Status
                </div>

                <div class="stat-value"
                     style="font-size:18px;">

                    Generated

                </div>

            </div>

        </div>

    </div>

    <h2 class="section-title">
        Recommended Approvals
    </h2>

    <%
        if (recommendations != null &&
            !recommendations.isEmpty()) {

            int count = 1;

            for (BusinessApproval approval
                    : recommendations) {

                String requirementStatus =
                        approval.getRequirementStatus();

                String priority =
                        approval.getPriorityLevel();

                String currentStatus =
                        approval.getCurrentStatus();

                String requirementClass =
                        "recommended";

                if ("REQUIRED".equalsIgnoreCase(
                        requirementStatus)) {

                    requirementClass =
                            "required";

                } else if ("CONDITIONAL"
                        .equalsIgnoreCase(
                                requirementStatus)) {

                    requirementClass =
                            "conditional";
                }

                String priorityClass =
                        "medium";

                if ("HIGH".equalsIgnoreCase(
                        priority)) {

                    priorityClass =
                            "high";

                } else if ("LOW".equalsIgnoreCase(
                        priority)) {

                    priorityClass =
                            "low";
                }
    %>

    <div class="approval-grid"
         style="margin-bottom:20px;">

        <div class="approval-card">

            <div class="card-top">

                <div class="approval-number">
                    <%= count %>
                </div>

                <div class="approval-info">

                   <h3>
    <%= approval.getApprovalName() != null
            ? approval.getApprovalName()
            : "Approval #" + approval.getApprovalId() %>
</h3>

                <div class="small-text">
    <%= approval.getApprovalCode() != null
            ? approval.getApprovalCode()
            : "Approval ID: " + approval.getApprovalId() %>
</div>

                </div>

            </div>

            <div class="badges">

                <span class="badge <%= requirementClass %>">

                    <%= requirementStatus != null
                            ? requirementStatus
                            : "RECOMMENDED" %>

                </span>

                <span class="badge <%= priorityClass %>">

                    <%= priority != null
                            ? priority + " PRIORITY"
                            : "MEDIUM PRIORITY" %>

                </span>

                <span class="badge status">

                    <%= currentStatus != null
                            ? currentStatus.replace("_", " ")
                            : "NOT STARTED" %>

                </span>

                <% if (approval.isMandatory()) { %>

                <span class="badge mandatory">
                    MANDATORY
                </span>

                <% } %>

            </div>

            <div class="reason-box">

                <div class="reason-title">
                    Why is this recommended?
                </div>

                <div>

                    <%= approval.getReasonText() != null
                            ? approval.getReasonText()
                            : "This approval matches your business profile and configured compliance rules." %>

                </div>

            </div>

            <div class="actions">

                <a class="primary-btn"
                   href="<%= request.getContextPath() %>/entrepreneur/approval-details?id=<%= approval.getApprovalId() %>">

                    View Details

                </a>

            </div>

        </div>

    </div>

    <%
                count++;
            }

        } else {
    %>

    <div class="empty-card">

        <div class="empty-icon">
            ✓
        </div>

        <h2>
            No matching approvals found
        </h2>

        <p>
            We could not find any active approval rules matching
            your current business profile. Once approval rules are
            configured in the system, matching approvals will
            automatically appear here.
        </p>

    </div>

    <%
        }
    %>

    <div class="footer-actions">

        <a class="secondary-btn"
           href="<%= request.getContextPath() %>/entrepreneur/dashboard">

            Back to Dashboard

        </a>

    </div>

</div>

</div>

</body>

</html>