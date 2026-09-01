<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="com.chaperon.model.Business" %>

<%
    Business business =
            (Business) request.getAttribute("business");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Business Profile Complete | CHAPERON</title>

<style>

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, Helvetica, sans-serif;
    background: #f5f8fc;
    color: #14213d;
}

.topbar {
    height: 70px;
    background: white;
    border-bottom: 1px solid #e5eaf0;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 6%;
}

.logo {
    font-size: 25px;
    font-weight: 800;
    color: #0b1f3a;
}

.page {
    min-height: calc(100vh - 70px);
    padding: 60px 20px;
}

.container {
    max-width: 900px;
    margin: auto;
}

.success-card {
    background: white;
    border: 1px solid #e5ebf2;
    border-radius: 20px;
    padding: 45px;
    box-shadow: 0 12px 35px rgba(18, 45, 80, 0.08);
}

.success-icon {
    width: 70px;
    height: 70px;
    border-radius: 50%;
    background: #e9f8ef;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 34px;
    margin-bottom: 24px;
}

h1 {
    margin: 0 0 12px;
    font-size: 34px;
    color: #10213b;
}

.subtitle {
    color: #66758a;
    line-height: 1.6;
    font-size: 17px;
    margin-bottom: 30px;
}

.summary {
    background: #f7faff;
    border: 1px solid #e3ebf5;
    border-radius: 14px;
    padding: 22px;
    margin-bottom: 30px;
}

.summary h3 {
    margin-top: 0;
    margin-bottom: 18px;
}

.grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 14px 28px;
}

.item-label {
    color: #7a8798;
    font-size: 13px;
}

.item-value {
    font-weight: 700;
    margin-top: 4px;
}

.next-box {
    background: #eef6ff;
    border: 1px solid #d6e9ff;
    border-radius: 14px;
    padding: 20px;
    color: #365d84;
    line-height: 1.6;
    margin-bottom: 28px;
}

.actions {
    display: flex;
    gap: 14px;
    flex-wrap: wrap;
}

.primary-btn,
.secondary-btn {
    display: inline-block;
    padding: 14px 22px;
    border-radius: 10px;
    text-decoration: none;
    font-weight: 700;
}

.primary-btn {
    background: #1677e8;
    color: white;
}

.primary-btn:hover {
    background: #0e67cb;
}

.secondary-btn {
    background: #eef2f7;
    color: #42536a;
}

@media (max-width: 650px) {

    .success-card {
        padding: 28px 20px;
    }

    .grid {
        grid-template-columns: 1fr;
    }

    h1 {
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

    <div>
        Business Profile Complete
    </div>

</div>

<div class="page">

<div class="container">

<div class="success-card">

    <div class="success-icon">
        ✓
    </div>

    <h1>
        Great! We understand your business
    </h1>

    <p class="subtitle">
        CHAPERON has saved your business profile.
        We can now analyze your information to identify
        registrations, licences, NOCs and approvals that may apply.
    </p>

    <% if (business != null) { %>

    <div class="summary">

        <h3>
            Business Summary
        </h3>

        <div class="grid">

            <div>
                <div class="item-label">Business Name</div>
                <div class="item-value">
                    <%= business.getBusinessName() %>
                </div>
            </div>

            <div>
                <div class="item-label">Industry</div>
                <div class="item-value">
                    <%= business.getIndustry() %>
                </div>
            </div>

            <div>
                <div class="item-label">Business Activity</div>
                <div class="item-value">
                    <%= business.getBusinessActivity() %>
                </div>
            </div>

            <div>
                <div class="item-label">Project Stage</div>
                <div class="item-value">
                    <%= business.getProjectStage() %>
                </div>
            </div>

            <div>
                <div class="item-label">Location</div>
                <div class="item-value">
                    <%= business.getDistrict() %>,
                    <%= business.getState() %>
                </div>
            </div>

            <div>
                <div class="item-label">Pollution Category</div>
                <div class="item-value">
                    <%= business.getPollutionCategory() %>
                </div>
            </div>

        </div>

    </div>

    <% } %>

    <div class="next-box">

        <strong>What happens next?</strong><br>

        CHAPERON will analyze your industry, business activity,
        location, project scale and compliance information to
        generate your personalized approval roadmap.

    </div>

    <div class="actions">

        <a class="primary-btn"
           href="<%= request.getContextPath() %>/entrepreneur/generate-approvals">

            GENERATE MY APPROVAL ROADMAP

        </a>

        <a class="secondary-btn"
           href="<%= request.getContextPath() %>/entrepreneur/dashboard">

            Back to Dashboard

        </a>

    </div>

</div>

</div>

</div>

</body>
</html>