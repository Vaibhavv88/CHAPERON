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

    String ctx =
            request.getContextPath();
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

    --success: #25aa72;
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
    max-width: 760px;

    color: var(--muted);

    font-size: 14px;
    line-height: 1.6;
}


/* =========================================================
   JOURNEY STEPPER
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

    color: var(--success);

    font-size: 13px;
    font-weight: 700;
}

.completion-dot {
    width: 8px;
    height: 8px;

    border-radius: 50%;

    background: var(--success);

    box-shadow:
        0 0 0 5px
        rgba(37,170,114,.10);
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

    width: 80%;

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
   FORM CARD
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
    line-height: 1.5;
}


/* =========================================================
   INTRO BOX
========================================================= */

.compliance-intro {
    margin-bottom: 26px;

    padding: 17px 18px;

    display: flex;
    align-items: center;

    gap: 14px;

    border: 1px solid #d7e9fc;
    border-radius: 14px;

    background:
        linear-gradient(
            105deg,
            #eef7ff,
            #f9fcff
        );
}

.intro-icon {
    width: 43px;
    height: 43px;

    min-width: 43px;

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

    font-size: 19px;

    box-shadow:
        0 6px 15px
        rgba(18,103,232,.18);
}

.compliance-intro strong {
    display: block;

    margin-bottom: 3px;

    color: #23405f;

    font-size: 13px;
}

.compliance-intro span {
    color: #71849d;

    font-size: 11.5px;
    line-height: 1.45;
}


/* =========================================================
   QUESTIONS
========================================================= */

.questions-grid {
    display: grid;

    grid-template-columns:
        repeat(2, 1fr);

    gap: 17px;
}

.question-card {
    padding: 20px;

    border: 1px solid #dfe8f2;
    border-radius: 14px;

    background: #ffffff;

    transition: .2s ease;
}

.question-card:hover {
    border-color: #b9d4f4;

    box-shadow:
        0 7px 20px
        rgba(22,72,130,.06);
}

.question-number {
    margin-bottom: 10px;

    color: var(--primary);

    font-size: 10px;
    font-weight: 800;

    text-transform: uppercase;

    letter-spacing: .8px;
}

.question-title {
    min-height: 42px;

    margin-bottom: 15px;

    color: #203754;

    font-size: 14px;
    font-weight: 750;

    line-height: 1.45;
}

.options {
    display: grid;

    grid-template-columns:
        1fr 1fr;

    gap: 9px;
}

.option {
    position: relative;

    min-height: 44px;

    padding: 0 13px;

    display: flex;
    align-items: center;

    gap: 8px;

    border: 1px solid #d6e1ed;
    border-radius: 9px;

    color: #52677f;

    background: #fbfdff;

    font-size: 12px;
    font-weight: 750;

    cursor: pointer;

    transition: .2s;
}

.option:hover {
    border-color: #8dbcf2;

    color: var(--primary);

    background: #f2f8ff;
}

.option input {
    width: 16px;
    height: 16px;

    margin: 0;

    accent-color: var(--primary);

    cursor: pointer;
}

.option:has(input:checked) {
    border-color: var(--primary);

    color: var(--primary);

    background: #edf5ff;

    box-shadow:
        inset 0 0 0 1px
        rgba(18,103,232,.08);
}


/* =========================================================
   POLLUTION CATEGORY
========================================================= */

.category-section {
    margin-top: 27px;

    padding-top: 27px;

    border-top: 1px solid #edf1f6;
}

.category-header {
    margin-bottom: 15px;

    display: flex;
    align-items: center;

    gap: 12px;
}

.category-icon {
    width: 37px;
    height: 37px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 10px;

    color: var(--primary);

    background: #edf5ff;

    font-size: 16px;
    font-weight: 800;
}

.category-header h3 {
    color: var(--navy);

    font-size: 15px;
    font-weight: 800;
}

.category-header p {
    margin-top: 2px;

    color: #8795a8;

    font-size: 11.5px;
}

.category-label {
    margin-bottom: 8px;

    display: block;

    color: #29405c;

    font-size: 13px;
    font-weight: 750;
}

.required {
    color: var(--danger);
}

select {
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

select:hover {
    border-color: #aabfd8;
}

select:focus {
    border-color: var(--primary);

    box-shadow:
        0 0 0 4px
        rgba(18,103,232,.09);
}


/* =========================================================
   HELP BOX
========================================================= */

.help-box {
    margin-top: 13px;

    padding: 15px 16px;

    display: flex;

    gap: 12px;

    border: 1px solid #d5e9ff;
    border-radius: 11px;

    color: #526d8c;

    background:
        linear-gradient(
            100deg,
            #eef7ff,
            #f8fcff
        );

    font-size: 12px;
    line-height: 1.55;
}

.help-icon {
    width: 27px;
    height: 27px;

    min-width: 27px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 8px;

    color: var(--primary);

    background: #dceeff;

    font-weight: 800;
}

.help-box strong {
    color: #244c7c;
}


/* =========================================================
   COMPLETE MESSAGE
========================================================= */

.complete-box {
    margin-top: 27px;

    padding: 17px 18px;

    display: flex;
    align-items: center;

    gap: 13px;

    border: 1px solid #d6e9ff;
    border-radius: 13px;

    background:
        linear-gradient(
            105deg,
            #f1f8ff,
            #f9fcff
        );
}

.complete-icon {
    width: 39px;
    height: 39px;

    min-width: 39px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 50%;

    color: white;

    background:
        linear-gradient(
            135deg,
            var(--primary),
            var(--cyan)
        );

    font-weight: 800;
}

.complete-box strong {
    display: block;

    margin-bottom: 3px;

    color: #23405f;

    font-size: 12.5px;
}

.complete-box span {
    color: #70839c;

    font-size: 11.5px;
}


/* =========================================================
   ACTIONS
========================================================= */

.actions {
    margin-top: 31px;

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

.finish-btn {
    min-width: 230px;

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

.finish-btn:hover {
    transform: translateY(-2px);

    box-shadow:
        0 10px 22px
        rgba(18,103,232,.30);
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
        width: 100%;
        height: 100%;

        background:
            linear-gradient(
                90deg,
                var(--primary),
                var(--cyan)
            );
    }

    .questions-grid {
        grid-template-columns: 1fr;
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

    .options {
        grid-template-columns: 1fr 1fr;
    }

    .actions {
        flex-direction: column-reverse;
        gap: 12px;
    }

    .back-btn,
    .finish-btn {
        width: 100%;

        justify-content: center;

        text-align: center;
    }
}

@media(max-width: 400px) {

    .options {
        grid-template-columns: 1fr;
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
    href="<%= ctx %>/entrepreneur/business-onboarding/step4">

    <span class="back-circle">
        ←
    </span>

    Back to Step 4

</a>


<!-- =========================================================
     HEADING
========================================================= -->

<section class="page-heading">

    <div class="page-badge">
        ◆ Compliance Assessment
    </div>

    <h1>
        Complete Your Business Profile
    </h1>

    <p>
        Answer a few final operational and environmental
        questions so CHAPERON can identify approvals and
        compliance requirements relevant to your business.
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

            100% Complete

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


        <div class="step complete">

            <div class="step-circle">
                ✓
            </div>

            <div class="step-name">
                Project Details
            </div>

        </div>


        <div class="step active">

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
     FORM CARD
========================================================= -->

<section class="form-card">


<div class="form-card-header">

    <div class="section-label">
        Step 05 · Compliance
    </div>

    <h2>
        A few final compliance questions
    </h2>

    <p>
        These details help CHAPERON identify
        environmental, safety and operational approvals
        that may apply to your business.
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


<div class="compliance-intro">

    <div class="intro-icon">
        ✓
    </div>

    <div>

        <strong>
            Final regulatory assessment
        </strong>

        <span>
            Your answers will be combined with your industry,
            location and project details to generate a more
            relevant approval journey.
        </span>

    </div>

</div>


<form
    method="post"
    action="<%= ctx %>/entrepreneur/business-onboarding/step5">


<!-- =========================================================
     QUESTIONS
========================================================= -->

<div class="questions-grid">


<!-- HAZARDOUS MATERIAL -->

<div class="question-card">

    <div class="question-number">
        Compliance Check 01
    </div>

    <div class="question-title">
        Does your business use hazardous materials?
    </div>

    <div class="options">

        <label class="option">

            <input
                type="radio"
                name="hazardousMaterial"
                value="YES"
                <%= business != null &&
                    business.isHazardousMaterial()
                    ? "checked" : "" %>
                required>

            YES

        </label>


        <label class="option">

            <input
                type="radio"
                name="hazardousMaterial"
                value="NO"
                <%= business != null &&
                    !business.isHazardousMaterial()
                    ? "checked" : "" %>>

            NO

        </label>

    </div>

</div>


<!-- BOILER -->

<div class="question-card">

    <div class="question-number">
        Compliance Check 02
    </div>

    <div class="question-title">
        Do you use a boiler?
    </div>

    <div class="options">

        <label class="option">

            <input
                type="radio"
                name="boilerUsed"
                value="YES"
                <%= business != null &&
                    business.isBoilerUsed()
                    ? "checked" : "" %>
                required>

            YES

        </label>


        <label class="option">

            <input
                type="radio"
                name="boilerUsed"
                value="NO"
                <%= business != null &&
                    !business.isBoilerUsed()
                    ? "checked" : "" %>>

            NO

        </label>

    </div>

</div>


<!-- INDUSTRIAL WASTE -->

<div class="question-card">

    <div class="question-number">
        Compliance Check 03
    </div>

    <div class="question-title">
        Does your business generate industrial waste?
    </div>

    <div class="options">

        <label class="option">

            <input
                type="radio"
                name="industrialWaste"
                value="YES"
                <%= business != null &&
                    business.isIndustrialWaste()
                    ? "checked" : "" %>
                required>

            YES

        </label>


        <label class="option">

            <input
                type="radio"
                name="industrialWaste"
                value="NO"
                <%= business != null &&
                    !business.isIndustrialWaste()
                    ? "checked" : "" %>>

            NO

        </label>

    </div>

</div>


<!-- GROUND WATER -->

<div class="question-card">

    <div class="question-number">
        Compliance Check 04
    </div>

    <div class="question-title">
        Do you require groundwater?
    </div>

    <div class="options">

        <label class="option">

            <input
                type="radio"
                name="groundwaterRequired"
                value="YES"
                <%= business != null &&
                    business.isGroundwaterRequired()
                    ? "checked" : "" %>
                required>

            YES

        </label>


        <label class="option">

            <input
                type="radio"
                name="groundwaterRequired"
                value="NO"
                <%= business != null &&
                    !business.isGroundwaterRequired()
                    ? "checked" : "" %>>

            NO

        </label>

    </div>

</div>


<!-- PERSONAL DATA -->

<div class="question-card">
    <div class="question-number">Compliance Check 05</div>
    <div class="question-title">Does your business handle customers' or employees' personal data?</div>
    <div class="options">
        <label class="option"><input type="radio" name="handlesPersonalData" value="YES"
            <%= business != null && business.isHandlesPersonalData() ? "checked" : "" %> required> YES</label>
        <label class="option"><input type="radio" name="handlesPersonalData" value="NO"
            <%= business != null && !business.isHandlesPersonalData() ? "checked" : "" %>> NO</label>
    </div>
</div>


<!-- STPI BENEFITS -->

<div class="question-card">
    <div class="question-number">Compliance Check 06</div>
    <div class="question-title">Do you want to seek STPI registration or benefits?</div>
    <div class="options">
        <label class="option"><input type="radio" name="seeksStpiBenefits" value="YES"
            <%= business != null && business.isSeeksStpiBenefits() ? "checked" : "" %> required> YES</label>
        <label class="option"><input type="radio" name="seeksStpiBenefits" value="NO"
            <%= business != null && !business.isSeeksStpiBenefits() ? "checked" : "" %>> NO</label>
    </div>
</div>


<!-- SEZ UNIT -->

<div class="question-card">
    <div class="question-number">Compliance Check 07</div>
    <div class="question-title">Is your business located in, or proposed for, a Special Economic Zone?</div>
    <div class="options">
        <label class="option"><input type="radio" name="locatedInSez" value="YES"
            <%= business != null && business.isLocatedInSez() ? "checked" : "" %> required> YES</label>
        <label class="option"><input type="radio" name="locatedInSez" value="NO"
            <%= business != null && !business.isLocatedInSez() ? "checked" : "" %>> NO</label>
    </div>
</div>


<!-- CERT-IN -->

<div class="question-card">
    <div class="question-number">Compliance Check 08</div>
    <div class="question-title">Is CERT-In cybersecurity compliance applicable to your operations?</div>
    <div class="options">
        <label class="option"><input type="radio" name="certInApplicable" value="YES"
            <%= business != null && business.isCertInApplicable() ? "checked" : "" %> required> YES</label>
        <label class="option"><input type="radio" name="certInApplicable" value="NO"
            <%= business != null && !business.isCertInApplicable() ? "checked" : "" %>> NO</label>
    </div>
</div>


<!-- TRADEMARK -->

<div class="question-card">
    <div class="question-number">Compliance Check 09</div>
    <div class="question-title">Do you want trademark protection for your business or brand?</div>
    <div class="options">
        <label class="option"><input type="radio" name="seeksTrademarkProtection" value="YES"
            <%= business != null && business.isSeeksTrademarkProtection() ? "checked" : "" %> required> YES</label>
        <label class="option"><input type="radio" name="seeksTrademarkProtection" value="NO"
            <%= business != null && !business.isSeeksTrademarkProtection() ? "checked" : "" %>> NO</label>
    </div>
</div>


<!-- SOFTWARE COPYRIGHT -->

<div class="question-card">
    <div class="question-number">Compliance Check 10</div>
    <div class="question-title">Do you want copyright registration for software created by your business?</div>
    <div class="options">
        <label class="option"><input type="radio" name="seeksSoftwareCopyright" value="YES"
            <%= business != null && business.isSeeksSoftwareCopyright() ? "checked" : "" %> required> YES</label>
        <label class="option"><input type="radio" name="seeksSoftwareCopyright" value="NO"
            <%= business != null && !business.isSeeksSoftwareCopyright() ? "checked" : "" %>> NO</label>
    </div>
</div>


</div>


<!-- =========================================================
     POLLUTION CATEGORY
========================================================= -->

<div class="category-section">


    <div class="category-header">

        <div class="category-icon">
            ◎
        </div>

        <div>

            <h3>
                Environmental Classification
            </h3>

            <p>
                Select the pollution category applicable
                to your business.
            </p>

        </div>

    </div>


    <label
        class="category-label"
        for="pollutionCategory">

        Pollution Category

        <span class="required">*</span>

    </label>


    <select
        id="pollutionCategory"
        name="pollutionCategory"
        required>

        <option value="">
            Select Pollution Category
        </option>


        <option
            value="Red"
            <%= "Red".equals(pollutionCategory)
                    ? "selected" : "" %>>

            Red

        </option>


        <option
            value="Orange"
            <%= "Orange".equals(pollutionCategory)
                    ? "selected" : "" %>>

            Orange

        </option>


        <option
            value="Green"
            <%= "Green".equals(pollutionCategory)
                    ? "selected" : "" %>>

            Green

        </option>


        <option
            value="White"
            <%= "White".equals(pollutionCategory)
                    ? "selected" : "" %>>

            White

        </option>


        <option
            value="I DON'T KNOW"
            <%= "I DON'T KNOW".equals(pollutionCategory)
                    ? "selected" : "" %>>

            I Don't Know

        </option>

    </select>


    <div class="help-box">

        <div class="help-icon">
            ?
        </div>

        <div>

            <strong>
                Not sure about your pollution category?
            </strong>

            <br>

            Select “I Don't Know”. CHAPERON can later
            suggest a category based on your configured
            industry rules. Final regulatory classification
            should still be verified against the applicable
            authority's rules.

        </div>

    </div>


</div>


<!-- =========================================================
     COMPLETION INFO
========================================================= -->

<div class="complete-box">

    <div class="complete-icon">
        ✓
    </div>

    <div>

        <strong>
            You're at the final step
        </strong>

        <span>
            Complete your profile to let CHAPERON use
            your business information for personalized
            approval recommendations.
        </span>

    </div>

</div>


<!-- =========================================================
     ACTIONS
========================================================= -->

<div class="actions">


    <a
        class="back-btn"
        href="<%= ctx %>/entrepreneur/business-onboarding/step4">

        ← Previous

    </a>


    <button
        type="submit"
        class="finish-btn">

        Complete Business Profile →

    </button>


</div>


</form>


</div>

</section>


</div>

</main>

</body>

</html>
