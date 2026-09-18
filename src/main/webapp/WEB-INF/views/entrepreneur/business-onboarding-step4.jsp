<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="com.chaperon.model.Business" %>

<%
    Business business =
            (Business) request.getAttribute("business");

    String projectStage = "";
    String estimatedInvestment = "";
    String annualTurnover = "";
    boolean interstateSupply = false;
    String expectedEmployees = "";
    String landArea = "";
    String builtUpArea = "";
    String powerRequirement = "";
    String waterRequirement = "";

    if (business != null) {

        if (business.getProjectStage() != null) {
            projectStage = business.getProjectStage();
        }

        if (business.getInvestmentAmount() != null) {
            estimatedInvestment =
                    String.valueOf(
                            business.getInvestmentAmount()
                    );
        }

        if (business.getAnnualTurnover() != null) {
            annualTurnover =
                    String.valueOf(
                            business.getAnnualTurnover()
                    );
        }

        interstateSupply = business.isInterstateSupply();

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

    String ctx =
            request.getContextPath();
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
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

:root {
    --primary: #1267e8;
    --primary-dark: #0748aa;
    --cyan: #16b8e8;

    --navy: #071d3d;
    --text: #172a46;
    --muted: #718198;

    --border: #dce6f2;
    --background: #f4f8fd;
    --white: #ffffff;

    --success: #24ad75;
    --danger: #dc3545;
}

html {
    scroll-behavior: smooth;
}

body {
    min-height: 100vh;

    font-family:
        "Segoe UI",
        Arial,
        Helvetica,
        sans-serif;

    color: var(--text);

    background:
        radial-gradient(
            circle at 8% 15%,
            rgba(22,103,232,.08),
            transparent 25%
        ),
        radial-gradient(
            circle at 92% 70%,
            rgba(22,184,232,.07),
            transparent 25%
        ),
        var(--background);
}


/* =========================================================
   HEADER
========================================================= */

.topbar {
    height: 82px;

    padding: 0 6%;

    display: flex;
    align-items: center;
    justify-content: space-between;

    position: sticky;
    top: 0;
    z-index: 100;

    background: rgba(255,255,255,.96);

    border-bottom: 1px solid #e6edf6;

    box-shadow:
        0 4px 20px
        rgba(15,45,85,.04);
}

.brand {
    display: flex;
    align-items: center;
    gap: 13px;
}

.logo-box {
    width: 49px;
    height: 49px;

    display: flex;
    align-items: center;
    justify-content: center;

    overflow: hidden;

    border: 1px solid #e1e9f3;
    border-radius: 12px;

    background: white;

    box-shadow:
        0 5px 14px
        rgba(10,65,150,.10);
}

.logo-box img {
    width: 100%;
    height: 100%;
    object-fit: contain;
}

.brand-info {
    display: flex;
    flex-direction: column;
}

.brand-name {
    color: var(--navy);

    font-size: 23px;
    line-height: 1;

    font-weight: 800;
    letter-spacing: .7px;
}

.brand-tagline {
    margin-top: 6px;

    color: #69809d;

    font-size: 9px;
    font-weight: 700;

    letter-spacing: 1.15px;
}

.top-right {
    display: flex;
    align-items: center;

    gap: 10px;

    color: #6c7f99;

    font-size: 13px;
}

.top-right-icon {
    width: 34px;
    height: 34px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 50%;

    color: var(--primary);

    background: #edf5ff;

    font-weight: 800;
}


/* =========================================================
   PAGE
========================================================= */

.page {
    padding: 35px 20px 60px;
}

.container {
    width: 100%;
    max-width: 1030px;
    margin: auto;
}


/* =========================================================
   BACK
========================================================= */

.back-link {
    margin-bottom: 25px;

    display: inline-flex;
    align-items: center;

    gap: 8px;

    color: #62758f;

    text-decoration: none;

    font-size: 14px;
    font-weight: 600;

    transition: .2s;
}

.back-link:hover {
    color: var(--primary);
    transform: translateX(-2px);
}

.back-circle {
    width: 29px;
    height: 29px;

    display: inline-flex;
    align-items: center;
    justify-content: center;

    border: 1px solid #dce6f2;
    border-radius: 8px;

    background: white;

    box-shadow:
        0 3px 10px
        rgba(20,50,90,.05);
}


/* =========================================================
   PAGE HEADING
========================================================= */

.page-heading {
    margin-bottom: 26px;
}

.page-badge {
    width: max-content;

    margin-bottom: 12px;

    padding: 7px 12px;

    display: inline-flex;
    align-items: center;

    gap: 7px;

    border: 1px solid #d3e8ff;
    border-radius: 20px;

    color: var(--primary);

    background: #eaf4ff;

    font-size: 11px;
    font-weight: 800;

    text-transform: uppercase;

    letter-spacing: .8px;
}

.page-heading h1 {
    margin-bottom: 7px;

    color: var(--navy);

    font-size: 29px;
    line-height: 1.2;

    font-weight: 800;
}

.page-heading p {
    max-width: 720px;

    color: var(--muted);

    font-size: 14px;
    line-height: 1.6;
}


/* =========================================================
   JOURNEY
========================================================= */

.journey-card {
    margin-bottom: 24px;

    padding: 22px 28px;

    border: 1px solid #e0e9f4;
    border-radius: 18px;

    background: rgba(255,255,255,.96);

    box-shadow:
        0 10px 30px
        rgba(22,55,95,.06);
}

.journey-top {
    margin-bottom: 21px;

    display: flex;
    align-items: center;
    justify-content: space-between;
}

.journey-title {
    color: var(--navy);

    font-size: 14px;
    font-weight: 800;
}

.completion {
    display: flex;
    align-items: center;

    gap: 8px;

    color: var(--primary);

    font-size: 13px;
    font-weight: 700;
}

.completion-dot {
    width: 8px;
    height: 8px;

    border-radius: 50%;

    background: var(--primary);

    box-shadow:
        0 0 0 5px
        rgba(18,103,232,.09);
}

.steps {
    position: relative;

    display: grid;

    grid-template-columns:
        repeat(5,1fr);
}

.steps::before {
    content: "";

    position: absolute;

    top: 18px;
    left: 9%;
    right: 9%;

    height: 3px;

    z-index: 0;

    background: #e3ebf5;
}

.steps::after {
    content: "";

    position: absolute;

    top: 18px;
    left: 9%;

    width: 60%;

    height: 3px;

    z-index: 0;

    background:
        linear-gradient(
            90deg,
            var(--primary),
            var(--cyan)
        );
}

.step {
    position: relative;
    z-index: 1;

    display: flex;
    flex-direction: column;
    align-items: center;

    text-align: center;
}

.step-circle {
    width: 38px;
    height: 38px;

    margin-bottom: 9px;

    display: flex;
    align-items: center;
    justify-content: center;

    border: 2px solid #d7e2ef;
    border-radius: 50%;

    color: #8495aa;

    background: white;

    font-size: 13px;
    font-weight: 800;
}

.step.complete .step-circle {
    color: white;

    border-color: var(--primary);

    background: var(--primary);
}

.step.active .step-circle {
    color: white;

    border-color: var(--primary);

    background:
        linear-gradient(
            135deg,
            var(--primary),
            var(--cyan)
        );

    box-shadow:
        0 5px 15px
        rgba(18,103,232,.28);
}

.step-name {
    color: #8a98aa;

    font-size: 11px;
    font-weight: 700;
}

.step.complete .step-name,
.step.active .step-name {
    color: var(--primary);
}

.progress-mobile {
    display: none;
}


/* =========================================================
   MAIN FORM CARD
========================================================= */

.form-card {
    overflow: hidden;

    border: 1px solid #dfe8f2;
    border-radius: 22px;

    background: rgba(255,255,255,.98);

    box-shadow:
        0 18px 50px
        rgba(17,50,90,.08);
}

.form-card-header {
    position: relative;

    padding: 31px 38px 27px;

    border-bottom: 1px solid #e0eaf5;

    background:
        linear-gradient(
            110deg,
            #f9fcff,
            #edf6ff
        );
}

.form-card-header::before {
    content: "";

    position: absolute;

    left: 0;
    top: 0;
    bottom: 0;

    width: 5px;

    background:
        linear-gradient(
            180deg,
            var(--primary),
            var(--cyan)
        );
}

.section-label {
    margin-bottom: 8px;

    color: var(--primary);

    font-size: 11px;
    font-weight: 800;

    text-transform: uppercase;

    letter-spacing: 1px;
}

.form-card-header h2 {
    margin-bottom: 8px;

    color: var(--navy);

    font-size: 26px;
    font-weight: 800;
}

.form-card-header p {
    max-width: 760px;

    color: #6d7e94;

    font-size: 14px;
    line-height: 1.6;
}

.form-content {
    padding: 34px 38px 38px;
}


/* =========================================================
   ERROR
========================================================= */

.error-box {
    margin-bottom: 24px;

    padding: 14px 16px;

    display: flex;
    align-items: flex-start;

    gap: 10px;

    border: 1px solid #f3cccc;
    border-radius: 11px;

    color: #a72b2b;

    background: #fff4f4;

    font-size: 13px;
}


/* =========================================================
   PROJECT STAGE
========================================================= */

.field-title {
    margin-bottom: 11px;

    color: #203754;

    font-size: 14px;
    font-weight: 750;
}

.required {
    color: var(--danger);
}

.stage-select {
    width: 100%;
    height: 53px;

    padding: 0 15px;

    border: 1px solid #cedbea;
    border-radius: 11px;

    outline: none;

    color: #263a54;

    background: white;

    font-family: inherit;
    font-size: 14px;

    transition: .2s;
}

.stage-select:hover {
    border-color: #aabfd8;
}

.stage-select:focus {
    border-color: var(--primary);

    box-shadow:
        0 0 0 4px
        rgba(18,103,232,.09);
}


/* =========================================================
   SECTION DIVIDER
========================================================= */

.form-section {
    margin-top: 29px;
}

.form-section-header {
    margin-bottom: 18px;

    display: flex;
    align-items: center;

    gap: 12px;
}

.section-icon {
    width: 37px;
    height: 37px;

    min-width: 37px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 10px;

    color: var(--primary);

    background: #edf5ff;

    font-weight: 800;
}

.form-section-header h3 {
    color: var(--navy);

    font-size: 15px;
    font-weight: 800;
}

.form-section-header p {
    margin-top: 2px;

    color: #8795a8;

    font-size: 11.5px;
}


/* =========================================================
   GRID
========================================================= */

.form-grid {
    display: grid;

    grid-template-columns:
        repeat(2,1fr);

    gap: 20px;
}

.form-group {
    min-width: 0;
}

.form-label {
    margin-bottom: 8px;

    display: block;

    color: #29405c;

    font-size: 13px;
    font-weight: 750;
}

.input-wrapper {
    position: relative;
}

.form-input {
    width: 100%;
    height: 52px;

    padding: 0 15px;

    border: 1px solid #cedbea;
    border-radius: 11px;

    outline: none;

    color: #263a54;

    background: white;

    font-family: inherit;
    font-size: 14px;

    transition: .2s;
}

.input-wrapper .form-input {
    padding-right: 82px;
}

.form-input:hover {
    border-color: #aabfd8;
}

.form-input:focus {
    border-color: var(--primary);

    box-shadow:
        0 0 0 4px
        rgba(18,103,232,.09);
}

.form-input::placeholder {
    color: #a0adbd;
}

.unit {
    position: absolute;

    top: 50%;
    right: 13px;

    transform: translateY(-50%);

    padding: 5px 8px;

    border-radius: 6px;

    color: #58708c;

    background: #f1f6fb;

    font-size: 11px;
    font-weight: 700;

    pointer-events: none;
}

.help-text {
    margin-top: 6px;

    color: #8492a5;

    font-size: 11.5px;
    line-height: 1.45;
}


/* =========================================================
   PROJECT SCALE SUMMARY
========================================================= */

.scale-box {
    margin-top: 28px;

    padding: 18px;

    display: grid;

    grid-template-columns:
        46px
        1fr;

    gap: 14px;

    border: 1px solid #d6e9ff;
    border-radius: 14px;

    background:
        linear-gradient(
            110deg,
            #eef7ff,
            #f8fcff
        );
}

.scale-icon {
    width: 46px;
    height: 46px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 12px;

    color: white;

    background:
        linear-gradient(
            135deg,
            var(--primary),
            var(--cyan)
        );

    font-size: 20px;

    box-shadow:
        0 7px 16px
        rgba(18,103,232,.18);
}

.scale-box strong {
    display: block;

    margin-bottom: 5px;

    color: #244c7c;

    font-size: 13px;
}

.scale-box p {
    color: #58718f;

    font-size: 12.5px;
    line-height: 1.55;
}


/* =========================================================
   ACTIONS
========================================================= */

.actions {
    margin-top: 32px;

    padding-top: 27px;

    display: flex;
    align-items: center;
    justify-content: space-between;

    border-top: 1px solid #edf1f6;
}

.back-btn {
    padding: 12px 16px;

    display: inline-flex;
    align-items: center;

    gap: 7px;

    border-radius: 9px;

    color: #64768d;

    text-decoration: none;

    font-size: 13px;
    font-weight: 700;

    transition: .2s;
}

.back-btn:hover {
    color: var(--navy);
    background: #f2f6fa;
}

.continue-btn {
    min-width: 180px;

    padding: 14px 22px;

    display: inline-flex;
    align-items: center;
    justify-content: center;

    gap: 9px;

    border: none;
    border-radius: 10px;

    color: white;

    background:
        linear-gradient(
            135deg,
            #1267e8,
            #087ddc
        );

    box-shadow:
        0 7px 18px
        rgba(18,103,232,.23);

    font-family: inherit;

    font-size: 13px;
    font-weight: 750;

    cursor: pointer;

    transition: .2s;
}

.continue-btn:hover {
    transform: translateY(-2px);

    box-shadow:
        0 10px 22px
        rgba(18,103,232,.30);
}

.save-note {
    margin-top: 19px;

    display: flex;
    align-items: center;
    justify-content: center;

    gap: 7px;

    color: #8a98a9;

    font-size: 11.5px;
}

.save-dot {
    width: 6px;
    height: 6px;

    border-radius: 50%;

    background: var(--success);
}


/* =========================================================
   RESPONSIVE
========================================================= */

@media(max-width: 800px) {

    .steps {
        display: none;
    }

    .progress-mobile {
        display: block;

        height: 7px;

        overflow: hidden;

        border-radius: 20px;

        background: #e5edf6;
    }

    .progress-mobile div {
        width: 80%;
        height: 100%;

        background:
            linear-gradient(
                90deg,
                var(--primary),
                var(--cyan)
            );
    }
}

@media(max-width: 650px) {

    .topbar {
        height: 72px;
        padding: 0 18px;
    }

    .logo-box {
        width: 42px;
        height: 42px;
    }

    .brand-name {
        font-size: 19px;
    }

    .brand-tagline {
        font-size: 7px;
    }

    .top-right {
        display: none;
    }

    .page {
        padding: 25px 14px 45px;
    }

    .page-heading h1 {
        font-size: 25px;
    }

    .form-card-header {
        padding: 25px 22px 22px;
    }

    .form-card-header h2 {
        font-size: 22px;
    }

    .form-content {
        padding: 26px 22px;
    }

    .form-grid {
        grid-template-columns: 1fr;
    }

    .actions {
        flex-direction: column-reverse;
        gap: 12px;
    }

    .continue-btn,
    .back-btn {
        width: 100%;

        justify-content: center;

        text-align: center;
    }
}

</style>

</head>


<body>


<!-- =========================================================
     HEADER
========================================================= -->

<header class="topbar">

    <div class="brand">

        <div class="logo-box">

            <img
                src="<%= ctx %>/images/chaperon-logo.jpeg"
                alt="CHAPERON Logo">

        </div>

        <div class="brand-info">

            <div class="brand-name">
                CHAPERON
            </div>

            <div class="brand-tagline">
                GUIDE. CONNECT. COMPLY. GET APPROVED.
            </div>

        </div>

    </div>


    <div class="top-right">

        <div class="top-right-icon">
            ✓
        </div>

        <span>
            Guided Business Approval Journey
        </span>

    </div>

</header>


<!-- =========================================================
     PAGE
========================================================= -->

<main class="page">

<div class="container">


<!-- BACK -->

<a
    class="back-link"
    href="<%= ctx %>/entrepreneur/business-onboarding/step3">

    <span class="back-circle">
        ←
    </span>

    Back to Step 3

</a>


<!-- PAGE HEADING -->

<section class="page-heading">

    <div class="page-badge">
        ◆ Project Configuration
    </div>

    <h1>
        Build Your Business Profile
    </h1>

    <p>
        Tell CHAPERON about your project's stage,
        investment, workforce and infrastructure so
        regulatory requirements can be matched more accurately.
    </p>

</section>


<!-- =========================================================
     STEPPER
========================================================= -->

<section class="journey-card">

    <div class="journey-top">

        <div class="journey-title">
            Business Profile Setup
        </div>

        <div class="completion">

            <span class="completion-dot"></span>

            80% Complete

        </div>

    </div>


    <div class="steps">

        <div class="step complete">

            <div class="step-circle">
                ✓
            </div>

            <div class="step-name">
                Business Basics
            </div>

        </div>


        <div class="step complete">

            <div class="step-circle">
                ✓
            </div>

            <div class="step-name">
                Industry
            </div>

        </div>


        <div class="step complete">

            <div class="step-circle">
                ✓
            </div>

            <div class="step-name">
                Location
            </div>

        </div>


        <div class="step active">

            <div class="step-circle">
                4
            </div>

            <div class="step-name">
                Project Details
            </div>

        </div>


        <div class="step">

            <div class="step-circle">
                5
            </div>

            <div class="step-name">
                Compliance
            </div>

        </div>

    </div>


    <div class="progress-mobile">
        <div></div>
    </div>

</section>


<!-- =========================================================
     FORM
========================================================= -->

<section class="form-card">


<div class="form-card-header">

    <div class="section-label">
        Step 04 · Project Details
    </div>

    <h2>
        Tell us about your project
    </h2>

    <p>
        Project stage, scale, workforce and resource
        requirements can influence licences, environmental
        permissions, inspections and other statutory approvals.
    </p>

</div>


<div class="form-content">


<% if (errorMessage != null) { %>

    <div class="error-box">

        <strong>!</strong>

        <span>
            <%= errorMessage %>
        </span>

    </div>

<% } %>


<form
    method="post"
    action="<%= ctx %>/entrepreneur/business-onboarding/step4">


<!-- =========================================================
     PROJECT STAGE
========================================================= -->

<div class="field-title">

    Current Project Stage

    <span class="required">*</span>

</div>


<select
    id="projectStage"
    name="projectStage"
    class="stage-select"
    required>

    <option value="">
        Select Project Stage
    </option>

    <option
        value="Planning"
        <%= "Planning".equals(projectStage)
                ? "selected" : "" %>>

        Planning / Proposed

    </option>

    <option
        value="Land Acquired"
        <%= "Land Acquired".equals(projectStage)
                ? "selected" : "" %>>

        Land Acquired

    </option>

    <option
        value="Under Construction"
        <%= "Under Construction".equals(projectStage)
                ? "selected" : "" %>>

        Under Construction

    </option>

    <option
        value="Ready to Operate"
        <%= "Ready to Operate".equals(projectStage)
                ? "selected" : "" %>>

        Ready to Operate

    </option>

    <option
        value="Operational"
        <%= "Operational".equals(projectStage)
                ? "selected" : "" %>>

        Already Operational

    </option>

</select>


<!-- =========================================================
     BUSINESS SCALE
========================================================= -->

<div class="form-section">

    <div class="form-section-header">

        <div class="section-icon">
            ₹
        </div>

        <div>

            <h3>
                Business Scale
            </h3>

            <p>
                Investment and expected workforce
            </p>

        </div>

    </div>


    <div class="form-grid">


        <!-- INVESTMENT -->

        <div class="form-group">

            <label
                class="form-label"
                for="estimatedInvestment">

                Estimated Investment

                <span class="required">*</span>

            </label>


            <div class="input-wrapper">

                <input
                    type="number"
                    id="estimatedInvestment"
                    name="estimatedInvestment"
                    class="form-input"
                    value="<%= estimatedInvestment %>"
                    min="0"
                    step="0.01"
                    placeholder="Example: 75"
                    required>

                <span class="unit">
                    ₹ Lakh
                </span>

            </div>


            <div class="help-text">
                Approximate total project investment.
            </div>

        </div>


        <!-- ANNUAL TURNOVER -->

        <div class="form-group">

            <label
                class="form-label"
                for="annualTurnover">

                Annual Turnover

            </label>


            <div class="input-wrapper">

                <input
                    type="number"
                    id="annualTurnover"
                    name="annualTurnover"
                    class="form-input"
                    value="<%= annualTurnover %>"
                    min="0"
                    step="0.01"
                    placeholder="Example: 40">

                <span class="unit">
                    ₹ Lakh
                </span>

            </div>


            <div class="help-text">
                Enter the approximate yearly turnover, if available.
            </div>

        </div>


        <!-- INTERSTATE SUPPLY -->

        <div class="form-group">

            <label
                class="form-label"
                for="interstateSupply">

                Interstate Supply

            </label>


            <select
                id="interstateSupply"
                name="interstateSupply"
                class="stage-select">

                <option value="false"
                    <%= !interstateSupply ? "selected" : "" %>>
                    No
                </option>

                <option value="true"
                    <%= interstateSupply ? "selected" : "" %>>
                    Yes
                </option>

            </select>


            <div class="help-text">
                Select Yes if goods or services will be supplied to another state.
            </div>

        </div>


        <!-- EMPLOYEES -->

        <div class="form-group">

            <label
                class="form-label"
                for="expectedEmployees">

                Expected Employees

                <span class="required">*</span>

            </label>


            <div class="input-wrapper">

                <input
                    type="number"
                    id="expectedEmployees"
                    name="expectedEmployees"
                    class="form-input"
                    value="<%= expectedEmployees %>"
                    min="0"
                    step="1"
                    placeholder="Example: 50"
                    required>

                <span class="unit">
                    People
                </span>

            </div>


            <div class="help-text">
                Approximate number of people employed.
            </div>

        </div>


    </div>

</div>


<!-- =========================================================
     LAND & INFRASTRUCTURE
========================================================= -->

<div class="form-section">

    <div class="form-section-header">

        <div class="section-icon">
            ◇
        </div>

        <div>

            <h3>
                Land & Infrastructure
            </h3>

            <p>
                Physical scale of your business unit
            </p>

        </div>

    </div>


    <div class="form-grid">


        <!-- LAND AREA -->

        <div class="form-group">

            <label
                class="form-label"
                for="landArea">

                Land Area

            </label>


            <div class="input-wrapper">

                <input
                    type="number"
                    id="landArea"
                    name="landArea"
                    class="form-input"
                    value="<%= landArea %>"
                    min="0"
                    step="0.01"
                    placeholder="Example: 5000">

                <span class="unit">
                    sq. m
                </span>

            </div>

        </div>


        <!-- BUILT UP AREA -->

        <div class="form-group">

            <label
                class="form-label"
                for="builtUpArea">

                Built-up Area

            </label>


            <div class="input-wrapper">

                <input
                    type="number"
                    id="builtUpArea"
                    name="builtUpArea"
                    class="form-input"
                    value="<%= builtUpArea %>"
                    min="0"
                    step="0.01"
                    placeholder="Example: 2500">

                <span class="unit">
                    sq. m
                </span>

            </div>

        </div>


    </div>

</div>


<!-- =========================================================
     RESOURCE REQUIREMENTS
========================================================= -->

<div class="form-section">

    <div class="form-section-header">

        <div class="section-icon">
            ⚡
        </div>

        <div>

            <h3>
                Resource Requirements
            </h3>

            <p>
                Estimated power and water requirements
            </p>

        </div>

    </div>


    <div class="form-grid">


        <!-- POWER -->

        <div class="form-group">

            <label
                class="form-label"
                for="powerRequirement">

                Power Requirement

            </label>


            <div class="input-wrapper">

                <input
                    type="number"
                    id="powerRequirement"
                    name="powerRequirement"
                    class="form-input"
                    value="<%= powerRequirement %>"
                    min="0"
                    step="0.01"
                    placeholder="Example: 100">

                <span class="unit">
                    kW
                </span>

            </div>

        </div>


        <!-- WATER -->

        <div class="form-group">

            <label
                class="form-label"
                for="waterRequirement">

                Water Requirement

            </label>


            <div class="input-wrapper">

                <input
                    type="number"
                    id="waterRequirement"
                    name="waterRequirement"
                    class="form-input"
                    value="<%= waterRequirement %>"
                    min="0"
                    step="0.01"
                    placeholder="Example: 15">

                <span class="unit">
                    KLD
                </span>

            </div>


            <div class="help-text">
                KLD = kilolitres per day.
            </div>

        </div>


    </div>

</div>


<!-- =========================================================
     INFORMATION
========================================================= -->

<div class="scale-box">

    <div class="scale-icon">
        ◎
    </div>

    <div>

        <strong>
            Why does project scale matter?
        </strong>

        <p>
            CHAPERON uses your project stage, investment,
            workforce, land area and resource requirements
            to identify approvals that may apply to the
            size and nature of your proposed or existing unit.
        </p>

    </div>

</div>


<!-- =========================================================
     ACTIONS
========================================================= -->

<div class="actions">


    <a
        class="back-btn"
        href="<%= ctx %>/entrepreneur/business-onboarding/step3">

        ← Previous

    </a>


    <button
        type="submit"
        class="continue-btn">

        Save & Continue →

    </button>


</div>


</form>


<div class="save-note">

    <span class="save-dot"></span>

    Project details will be saved with your
    CHAPERON business profile.

</div>


</div>

</section>


</div>

</main>

</body>

</html>
