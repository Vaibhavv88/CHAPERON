<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="com.chaperon.model.Business" %>

<%
    Business business =
            (Business) request.getAttribute("business");

    String projectStage = "";
    String estimatedInvestment = "";
    String expectedEmployees = "";
    String landArea = "";
    String builtUpArea = "";
    String powerRequirement = "";
    String waterRequirement = "";

    if (business != null) {

        if (business.getProjectStage() != null) {
            projectStage =
                    business.getProjectStage();
        }

        if (business.getInvestmentAmount() != null) {
            estimatedInvestment =
                    String.valueOf(
                            business.getInvestmentAmount()
                    );
        }

        if (business.getEmployeeCount() > 0) {
            expectedEmployees =
                    String.valueOf(
                            business.getEmployeeCount()
                    );
        }

        if (business.getLandArea() != null) {
            landArea =
                    String.valueOf(
                            business.getLandArea()
                    );
        }

        if (business.getBuiltUpArea() != null) {
            builtUpArea =
                    String.valueOf(
                            business.getBuiltUpArea()
                    );
        }

        if (business.getPowerRequirement() != null) {
            powerRequirement =
                    String.valueOf(
                            business.getPowerRequirement()
                    );
        }

        if (business.getWaterRequirement() != null) {
            waterRequirement =
                    String.valueOf(
                            business.getWaterRequirement()
                    );
        }
    }

    String errorMessage =
            (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Project Details | CHAPERON</title>

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
    border-bottom: 1px solid #e4eaf1;

    display: flex;
    align-items: center;
    justify-content: space-between;

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
    max-width: 900px;
    margin: auto;
}

.back-link {
    text-decoration: none;
    color: #617086;
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
    width: 80%;
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

.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 22px;
}

.full-width {
    grid-column: 1 / -1;
}

label {
    display: block;
    font-size: 14px;
    font-weight: 700;
    margin-bottom: 8px;
}

.required {
    color: #d13c3c;
}

input,
select {
    width: 100%;
    height: 50px;

    padding: 0 14px;

    border: 1px solid #ccd6e2;
    border-radius: 10px;

    background: white;

    font-size: 15px;

    outline: none;
}

input:focus,
select:focus {
    border-color: #1677e8;

    box-shadow:
        0 0 0 3px rgba(22,119,232,0.10);
}

.unit-field {
    position: relative;
}

.unit-field input {
    padding-right: 75px;
}

.unit {
    position: absolute;
    right: 14px;
    top: 16px;

    font-size: 13px;
    color: #718096;
}

.help {
    margin-top: 6px;

    color: #8491a3;
    font-size: 12px;

    line-height: 1.4;
}

.error-box {
    background: #fff1f1;

    border: 1px solid #f3caca;

    color: #a62c2c;

    padding: 13px 15px;

    border-radius: 9px;

    margin-bottom: 22px;
}

.info-box {
    margin-top: 28px;

    padding: 17px;

    border-radius: 12px;

    background: #eef6ff;

    border: 1px solid #d6e9ff;

    color: #46627e;

    font-size: 14px;

    line-height: 1.5;
}

.actions {
    display: flex;
    align-items: center;
    justify-content: space-between;

    margin-top: 35px;
}

.back-btn {
    text-decoration: none;

    color: #5f6e82;

    padding: 13px 18px;

    font-weight: 600;
}

.continue-btn {
    border: none;

    background: #1677e8;

    color: white;

    padding: 14px 25px;

    border-radius: 10px;

    font-size: 15px;

    font-weight: 700;

    cursor: pointer;
}

.continue-btn:hover {
    background: #0e67cb;
}

@media (max-width: 650px) {

    .form-grid {
        grid-template-columns: 1fr;
    }

    .full-width {
        grid-column: auto;
    }

    .card {
        padding: 25px 20px;
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
   href="<%= request.getContextPath() %>/entrepreneur/business-onboarding/step3">

    ← Back to Step 3

</a>

<div class="step-header">

    <div class="step-label">
        STEP 4 OF 5
    </div>

    <div class="percentage">
        80% Complete
    </div>

</div>

<div class="progress">
    <div class="progress-bar"></div>
</div>

<div class="card">

<h1>
    Tell us about your project
</h1>

<p class="intro">

    Project scale can affect applicable registrations,
    environmental permissions, inspections and other
    statutory approvals.

</p>

<% if (errorMessage != null) { %>

<div class="error-box">
    <%= errorMessage %>
</div>

<% } %>

<form method="post"
      action="<%= request.getContextPath() %>/entrepreneur/business-onboarding/step4">

<div class="form-grid">

<div class="full-width">

<label for="projectStage">

    Project Stage
    <span class="required">*</span>

</label>

<select id="projectStage"
        name="projectStage"
        required>

<option value="">
    Select Project Stage
</option>

<option value="Planning"
    <%= "Planning".equals(projectStage)
        ? "selected" : "" %>>
    Planning / Proposed
</option>

<option value="Land Acquired"
    <%= "Land Acquired".equals(projectStage)
        ? "selected" : "" %>>
    Land Acquired
</option>

<option value="Under Construction"
    <%= "Under Construction".equals(projectStage)
        ? "selected" : "" %>>
    Under Construction
</option>

<option value="Ready to Operate"
    <%= "Ready to Operate".equals(projectStage)
        ? "selected" : "" %>>
    Ready to Operate
</option>

<option value="Operational"
    <%= "Operational".equals(projectStage)
        ? "selected" : "" %>>
    Already Operational
</option>

</select>

</div>


<div>

<label for="estimatedInvestment">

    Estimated Investment
    <span class="required">*</span>

</label>

<div class="unit-field">

<input
    type="number"
    id="estimatedInvestment"
    name="estimatedInvestment"
    value="<%= estimatedInvestment %>"
    min="0"
    step="0.01"
    placeholder="Example: 75"
    required>

<span class="unit">
    ₹ Lakh
</span>

</div>

<div class="help">
    Enter approximate total project investment.
</div>

</div>


<div>

<label for="expectedEmployees">

    Expected Employees
    <span class="required">*</span>

</label>

<input
    type="number"
    id="expectedEmployees"
    name="expectedEmployees"
    value="<%= expectedEmployees %>"
    min="0"
    step="1"
    placeholder="Example: 50"
    required>

<div class="help">
    Approximate number of people employed by the unit.
</div>

</div>


<div>

<label for="landArea">
    Land Area
</label>

<div class="unit-field">

<input
    type="number"
    id="landArea"
    name="landArea"
    value="<%= landArea %>"
    min="0"
    step="0.01"
    placeholder="Example: 5000">

<span class="unit">
    sq. m
</span>

</div>

</div>


<div>

<label for="builtUpArea">
    Built-up Area
</label>

<div class="unit-field">

<input
    type="number"
    id="builtUpArea"
    name="builtUpArea"
    value="<%= builtUpArea %>"
    min="0"
    step="0.01"
    placeholder="Example: 2500">

<span class="unit">
    sq. m
</span>

</div>

</div>


<div>

<label for="powerRequirement">
    Power Requirement
</label>

<div class="unit-field">

<input
    type="number"
    id="powerRequirement"
    name="powerRequirement"
    value="<%= powerRequirement %>"
    min="0"
    step="0.01"
    placeholder="Example: 100">

<span class="unit">
    kW
</span>

</div>

</div>


<div>

<label for="waterRequirement">
    Water Requirement
</label>

<div class="unit-field">

<input
    type="number"
    id="waterRequirement"
    name="waterRequirement"
    value="<%= waterRequirement %>"
    min="0"
    step="0.01"
    placeholder="Example: 15">

<span class="unit">
    KLD
</span>

</div>

<div class="help">
    KLD = kilolitres per day.
</div>

</div>

</div>


<div class="info-box">

    These details will help CHAPERON determine which
    approvals may apply based on the size and stage of
    your proposed or existing unit.

</div>


<div class="actions">

<a class="back-btn"
   href="<%= request.getContextPath() %>/entrepreneur/business-onboarding/step3">

    ← Previous

</a>

<button type="submit"
        class="continue-btn">

    Save & Continue →

</button>

</div>

</form>

</div>

</div>

</div>

</body>
</html>