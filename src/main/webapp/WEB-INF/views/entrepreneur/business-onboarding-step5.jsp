<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="com.chaperon.model.Business" %>

<%
    Business business =
            (Business) request.getAttribute("business");

    String errorMessage =
            (String) request.getAttribute("errorMessage");

    String pollutionCategory = "";

    if (business != null &&
        business.getPollutionCategory() != null) {

        pollutionCategory =
                business.getPollutionCategory();
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Compliance Details | CHAPERON</title>

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
    justify-content: space-between;
    align-items: center;
    padding: 0 6%;
}

.logo {
    font-size: 25px;
    font-weight: 800;
}

.top-text {
    color: #718096;
    font-size: 14px;
}

.page {
    padding: 45px 20px;
}

.container {
    max-width: 850px;
    margin: auto;
}

.back-link {
    color: #617086;
    text-decoration: none;
    display: inline-block;
    margin-bottom: 25px;
}

.step-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 12px;
}

.step-label {
    color: #1677e8;
    font-size: 14px;
    font-weight: 700;
}

.percentage {
    color: #66758a;
    font-size: 14px;
}

.progress {
    height: 8px;
    background: #e3eaf3;
    border-radius: 20px;
    overflow: hidden;
    margin-bottom: 35px;
}

.progress-bar {
    width: 100%;
    height: 100%;
    background: #1677e8;
}

.card {
    background: white;
    border: 1px solid #e6ebf1;
    border-radius: 18px;
    padding: 38px;
    box-shadow:
        0 10px 30px rgba(21,45,80,0.07);
}

h1 {
    margin: 0 0 10px;
    font-size: 30px;
}

.intro {
    color: #6d7b8e;
    line-height: 1.6;
    margin-bottom: 30px;
}

.question {
    padding: 20px 0;
    border-bottom: 1px solid #edf0f4;
}

.question-title {
    font-weight: 700;
    margin-bottom: 13px;
}

.options {
    display: flex;
    gap: 12px;
}

.option {
    border: 1px solid #d5dfeb;
    padding: 11px 18px;
    border-radius: 9px;
    cursor: pointer;
}

.option:hover {
    border-color: #1677e8;
    background: #f7fbff;
}

.option input {
    margin-right: 7px;
}

.category {
    margin-top: 25px;
}

.category label {
    font-weight: 700;
    display: block;
    margin-bottom: 8px;
}

select {
    width: 100%;
    height: 50px;

    border: 1px solid #ccd6e2;
    border-radius: 10px;

    padding: 0 14px;

    font-size: 15px;
    background: white;
}

.help-box {
    margin-top: 12px;
    padding: 15px;
    background: #eef6ff;
    border: 1px solid #d6e9ff;
    border-radius: 10px;
    color: #46627e;
    font-size: 13px;
    line-height: 1.5;
}

.error-box {
    background: #fff1f1;
    border: 1px solid #f3caca;
    color: #a62c2c;
    padding: 13px 15px;
    border-radius: 9px;
    margin-bottom: 20px;
}

.actions {
    margin-top: 35px;
    display: flex;
    justify-content: space-between;
}

.back-btn {
    color: #5f6e82;
    text-decoration: none;
    font-weight: 600;
    padding: 13px 18px;
}

.finish-btn {
    border: none;
    background: #1677e8;
    color: white;
    padding: 14px 25px;
    border-radius: 10px;
    font-size: 15px;
    font-weight: 700;
    cursor: pointer;
}

.finish-btn:hover {
    background: #0e67cb;
}

@media (max-width: 600px) {

    .card {
        padding: 25px 20px;
    }

    .options {
        flex-direction: column;
    }
}

</style>

</head>

<body>

<div class="topbar">

    <div class="logo">
        CHAPERON
    </div>

    <div class="top-text">
        Your guided business approval journey
    </div>

</div>

<div class="page">

<div class="container">

<a class="back-link"
   href="<%= request.getContextPath() %>/entrepreneur/business-onboarding/step4">

    ← Back to Step 4

</a>

<div class="step-header">

    <div class="step-label">
        STEP 5 OF 5
    </div>

    <div class="percentage">
        100% Complete
    </div>

</div>

<div class="progress">
    <div class="progress-bar"></div>
</div>

<div class="card">

<h1>
    A few final compliance questions
</h1>

<p class="intro">

    These details help CHAPERON identify environmental,
    safety and operational approvals that may apply
    to your business.

</p>

<% if (errorMessage != null) { %>

<div class="error-box">
    <%= errorMessage %>
</div>

<% } %>

<form method="post"
      action="<%= request.getContextPath() %>/entrepreneur/business-onboarding/step5">

<div class="question">

<div class="question-title">
    Does your business use hazardous materials?
</div>

<div class="options">

<label class="option">
<input type="radio"
       name="hazardousMaterial"
       value="YES"
       <%= business != null &&
           business.isHazardousMaterial()
           ? "checked" : "" %>
       required>
YES
</label>

<label class="option">
<input type="radio"
       name="hazardousMaterial"
       value="NO"
       <%= business != null &&
           !business.isHazardousMaterial()
           ? "checked" : "" %>>
NO
</label>

</div>

</div>


<div class="question">

<div class="question-title">
    Do you use a boiler?
</div>

<div class="options">

<label class="option">
<input type="radio"
       name="boilerUsed"
       value="YES"
       <%= business != null &&
           business.isBoilerUsed()
           ? "checked" : "" %>
       required>
YES
</label>

<label class="option">
<input type="radio"
       name="boilerUsed"
       value="NO"
       <%= business != null &&
           !business.isBoilerUsed()
           ? "checked" : "" %>>
NO
</label>

</div>

</div>


<div class="question">

<div class="question-title">
    Does your business generate industrial waste?
</div>

<div class="options">

<label class="option">
<input type="radio"
       name="industrialWaste"
       value="YES"
       <%= business != null &&
           business.isIndustrialWaste()
           ? "checked" : "" %>
       required>
YES
</label>

<label class="option">
<input type="radio"
       name="industrialWaste"
       value="NO"
       <%= business != null &&
           !business.isIndustrialWaste()
           ? "checked" : "" %>>
NO
</label>

</div>

</div>


<div class="question">

<div class="question-title">
    Do you require groundwater?
</div>

<div class="options">

<label class="option">
<input type="radio"
       name="groundwaterRequired"
       value="YES"
       <%= business != null &&
           business.isGroundwaterRequired()
           ? "checked" : "" %>
       required>
YES
</label>

<label class="option">
<input type="radio"
       name="groundwaterRequired"
       value="NO"
       <%= business != null &&
           !business.isGroundwaterRequired()
           ? "checked" : "" %>>
NO
</label>

</div>

</div>


<div class="category">

<label for="pollutionCategory">
    Pollution Category
</label>

<select id="pollutionCategory"
        name="pollutionCategory"
        required>

<option value="">
    Select Pollution Category
</option>

<option value="Red"
    <%= "Red".equals(pollutionCategory)
        ? "selected" : "" %>>
    Red
</option>

<option value="Orange"
    <%= "Orange".equals(pollutionCategory)
        ? "selected" : "" %>>
    Orange
</option>

<option value="Green"
    <%= "Green".equals(pollutionCategory)
        ? "selected" : "" %>>
    Green
</option>

<option value="White"
    <%= "White".equals(pollutionCategory)
        ? "selected" : "" %>>
    White
</option>

<option value="I DON'T KNOW"
    <%= "I DON'T KNOW".equals(pollutionCategory)
        ? "selected" : "" %>>
    I Don't Know
</option>

</select>

<div class="help-box">

    <strong>Not sure about your pollution category?</strong><br>

    Select “I Don't Know”. CHAPERON can later suggest
    a category based on your configured industry rules.
    The final regulatory classification should still be
    verified against the applicable authority's rules.

</div>

</div>


<div class="actions">

<a class="back-btn"
   href="<%= request.getContextPath() %>/entrepreneur/business-onboarding/step4">

    ← Previous

</a>

<button type="submit"
        class="finish-btn">

    Complete Business Profile →

</button>

</div>

</form>

</div>

</div>

</div>

</body>
</html>