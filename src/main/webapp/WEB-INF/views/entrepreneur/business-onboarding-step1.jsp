<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="com.chaperon.model.Business" %>

<%
    Business business =
            (Business) request.getAttribute("business");

    String businessName = "";
    String businessConstitution = "";
    String businessActivity = "";

    if (business != null) {

        if (business.getBusinessName() != null) {
            businessName = business.getBusinessName();
        }

        if (business.getBusinessConstitution() != null) {
            businessConstitution =
                    business.getBusinessConstitution();
        }

        if (business.getBusinessActivity() != null) {
            businessActivity =
                    business.getBusinessActivity();
        }
    }

    String errorMessage =
            (String) request.getAttribute("errorMessage");

    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Business Profile | CHAPERON</title>

<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

:root {
    --primary: #1267e8;
    --primary-dark: #0748aa;
    --primary-soft: #edf5ff;
    --cyan: #16b8e8;
    --navy: #071d3d;
    --text: #172a46;
    --muted: #718198;
    --border: #dce6f2;
    --background: #f4f8fd;
    --white: #ffffff;
    --danger: #dc3545;
}

html {
    scroll-behavior: smooth;
}

body {
    margin: 0;
    min-height: 100vh;
    font-family: "Segoe UI", Arial, Helvetica, sans-serif;
    background:
        radial-gradient(
            circle at 8% 15%,
            rgba(22, 103, 232, 0.08),
            transparent 25%
        ),
        radial-gradient(
            circle at 92% 70%,
            rgba(22, 184, 232, 0.07),
            transparent 25%
        ),
        var(--background);
    color: var(--text);
}


/* =========================================================
   TOP HEADER
   ========================================================= */

.topbar {
    height: 82px;
    background: rgba(255,255,255,0.96);
    border-bottom: 1px solid #e6edf6;

    display: flex;
    align-items: center;
    justify-content: space-between;

    padding: 0 6%;

    position: sticky;
    top: 0;
    z-index: 100;

    box-shadow: 0 4px 20px rgba(15,45,85,0.04);
}

.brand {
    display: flex;
    align-items: center;
    gap: 13px;
}

.logo-box {
    width: 49px;
    height: 49px;

    border-radius: 12px;

    display: flex;
    align-items: center;
    justify-content: center;

    overflow: hidden;

    background: #ffffff;
    border: 1px solid #e1e9f3;

    box-shadow: 0 5px 14px rgba(10,65,150,0.10);
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
    font-size: 23px;
    line-height: 1;
    font-weight: 800;
    letter-spacing: 0.7px;
    color: var(--navy);
}

.brand-tagline {
    margin-top: 6px;
    font-size: 9px;
    letter-spacing: 1.15px;
    font-weight: 700;
    color: #69809d;
}

.top-right {
    display: flex;
    align-items: center;
    gap: 10px;

    font-size: 13px;
    color: #6c7f99;
}

.top-right-icon {
    width: 34px;
    height: 34px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 50%;

    background: #edf5ff;
    color: var(--primary);

    font-weight: 800;
}


/* =========================================================
   MAIN PAGE
   ========================================================= */

.page {
    padding: 35px 20px 60px;
}

.container {
    width: 100%;
    max-width: 1030px;
    margin: 0 auto;
}


/* =========================================================
   BACK LINK
   ========================================================= */

.back-link {
    display: inline-flex;
    align-items: center;
    gap: 8px;

    text-decoration: none;

    color: #62758f;

    font-size: 14px;
    font-weight: 600;

    margin-bottom: 25px;

    transition: 0.2s;
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

    border-radius: 8px;

    background: #ffffff;
    border: 1px solid #dce6f2;

    box-shadow: 0 3px 10px rgba(20,50,90,0.05);
}


/* =========================================================
   PAGE INTRO
   ========================================================= */

.page-heading {
    margin-bottom: 26px;
}

.page-badge {
    display: inline-flex;
    align-items: center;
    gap: 7px;

    padding: 7px 12px;

    background: #eaf4ff;
    color: var(--primary);

    border: 1px solid #d3e8ff;
    border-radius: 20px;

    font-size: 11px;
    font-weight: 800;

    text-transform: uppercase;
    letter-spacing: 0.8px;

    margin-bottom: 12px;
}

.page-heading h1 {
    color: var(--navy);
    font-size: 29px;
    line-height: 1.2;
    font-weight: 800;
    margin-bottom: 7px;
}

.page-heading p {
    color: var(--muted);
    font-size: 14px;
    line-height: 1.6;
}


/* =========================================================
   JOURNEY STEPPER
   ========================================================= */

.journey-card {
    background: rgba(255,255,255,0.96);

    border: 1px solid #e0e9f4;
    border-radius: 18px;

    padding: 22px 28px;

    margin-bottom: 24px;

    box-shadow: 0 10px 30px rgba(22,55,95,0.06);
}

.journey-top {
    display: flex;
    align-items: center;
    justify-content: space-between;

    margin-bottom: 21px;
}

.journey-title {
    font-size: 14px;
    font-weight: 800;
    color: var(--navy);
}

.completion {
    display: flex;
    align-items: center;
    gap: 8px;

    font-size: 13px;
    font-weight: 700;
    color: var(--primary);
}

.completion-dot {
    width: 8px;
    height: 8px;

    background: var(--primary);
    border-radius: 50%;

    box-shadow: 0 0 0 5px rgba(18,103,232,0.09);
}

.steps {
    display: grid;
    grid-template-columns: repeat(5, 1fr);

    position: relative;
}

.steps::before {
    content: "";

    position: absolute;

    top: 18px;
    left: 9%;
    right: 9%;

    height: 3px;

    background: #e3ebf5;

    z-index: 0;
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

    border-radius: 50%;

    display: flex;
    align-items: center;
    justify-content: center;

    background: #ffffff;

    border: 2px solid #d7e2ef;

    color: #8495aa;

    font-size: 13px;
    font-weight: 800;

    margin-bottom: 9px;
}

.step.active .step-circle {
    color: #ffffff;

    border-color: var(--primary);

    background:
        linear-gradient(
            135deg,
            var(--primary),
            #1a9bea
        );

    box-shadow:
        0 5px 15px rgba(18,103,232,0.28);
}

.step-name {
    font-size: 11px;
    font-weight: 700;
    color: #8a98aa;
}

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
    background: rgba(255,255,255,0.98);

    border: 1px solid #dfe8f2;

    border-radius: 22px;

    overflow: hidden;

    box-shadow:
        0 18px 50px rgba(17,50,90,0.08);
}

.form-card-header {
    position: relative;

    padding: 31px 38px 27px;

    background:
        linear-gradient(
            110deg,
            #f9fcff 0%,
            #edf6ff 100%
        );

    border-bottom: 1px solid #e0eaf5;
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
    color: var(--primary);

    font-size: 11px;
    font-weight: 800;

    letter-spacing: 1px;
    text-transform: uppercase;

    margin-bottom: 8px;
}

.form-card-header h2 {
    color: var(--navy);

    font-size: 26px;
    font-weight: 800;

    margin-bottom: 8px;
}

.form-card-header p {
    color: #6d7e94;

    font-size: 14px;
    line-height: 1.6;

    max-width: 700px;
}

.form-content {
    padding: 34px 38px 38px;
}


/* =========================================================
   ERROR
   ========================================================= */

.error-box {
    display: flex;
    align-items: flex-start;
    gap: 10px;

    padding: 14px 16px;

    background: #fff4f4;
    border: 1px solid #f3cccc;

    border-radius: 11px;

    color: #a72b2b;

    font-size: 13px;
    line-height: 1.5;

    margin-bottom: 24px;
}

.error-icon {
    font-weight: 900;
}


/* =========================================================
   FORM
   ========================================================= */

.form-group {
    margin-bottom: 27px;
}

.form-label {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 5px;

    margin-bottom: 9px;

    color: #203754;

    font-size: 14px;
    font-weight: 750;
}

.required {
    color: #dc3d4c;
}

.help {
    color: #8492a5;

    font-size: 12px;
    font-weight: 500;
}

.input-wrap {
    position: relative;
}

input[type="text"],
select {
    width: 100%;
    height: 52px;

    padding: 0 15px;

    border: 1px solid #cedbea;
    border-radius: 11px;

    outline: none;

    background: #ffffff;

    color: #263a54;

    font-family: inherit;
    font-size: 14px;

    transition: 0.2s ease;
}

input[type="text"]:hover,
select:hover {
    border-color: #aabfd8;
}

input[type="text"]:focus,
select:focus {
    border-color: var(--primary);

    box-shadow:
        0 0 0 4px rgba(18,103,232,0.09);
}

input::placeholder {
    color: #a0adbd;
}


/* =========================================================
   ACTIVITY CARDS
   ========================================================= */

.activity-title-row {
    display: flex;
    align-items: center;
    justify-content: space-between;

    margin-bottom: 12px;
}

.activity-question {
    color: #203754;

    font-size: 14px;
    font-weight: 750;
}

.selection-note {
    color: #8a99ab;
    font-size: 11px;
}

.activity-options {
    display: grid;
    grid-template-columns: repeat(3, 1fr);

    gap: 14px;
}

.activity-card {
    position: relative;

    min-height: 133px;

    padding: 20px 18px;

    border: 1.5px solid #d9e3ef;
    border-radius: 14px;

    background: #ffffff;

    cursor: pointer;

    transition: all 0.2s ease;
}

.activity-card:hover {
    transform: translateY(-3px);

    border-color: #8bbcff;

    box-shadow:
        0 9px 22px rgba(21,92,185,0.09);
}

.activity-card input {
    position: absolute;
    opacity: 0;
    pointer-events: none;
}

.radio-indicator {
    position: absolute;

    right: 14px;
    top: 14px;

    width: 18px;
    height: 18px;

    border: 2px solid #c5d2e1;
    border-radius: 50%;

    background: #ffffff;

    transition: 0.2s;
}

.activity-card:has(input:checked) {
    border-color: var(--primary);

    background:
        linear-gradient(
            145deg,
            #ffffff,
            #f1f7ff
        );

    box-shadow:
        0 8px 22px rgba(18,103,232,0.12);
}

.activity-card:has(input:checked) .radio-indicator {
    border: 5px solid var(--primary);
}

.activity-icon {
    width: 39px;
    height: 39px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 10px;

    background: #edf5ff;

    color: var(--primary);

    font-size: 18px;

    margin-bottom: 13px;
}

.activity-card:has(input:checked) .activity-icon {
    color: #ffffff;

    background:
        linear-gradient(
            135deg,
            var(--primary),
            var(--cyan)
        );
}

.activity-name {
    display: block;

    color: #1d334f;

    font-size: 14px;
    font-weight: 800;

    margin-bottom: 6px;
}

.activity-description {
    display: block;

    color: #7c8b9e;

    font-size: 11.5px;
    line-height: 1.45;

    padding-right: 5px;
}


/* =========================================================
   INFORMATION BOX
   ========================================================= */

.info-box {
    display: flex;
    gap: 13px;

    margin-top: 5px;

    padding: 16px 17px;

    background:
        linear-gradient(
            100deg,
            #eef7ff,
            #f7fbff
        );

    border: 1px solid #d5e9ff;
    border-radius: 12px;

    color: #526d8c;

    font-size: 12.5px;
    line-height: 1.55;
}

.info-icon {
    flex-shrink: 0;

    width: 27px;
    height: 27px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 8px;

    background: #dceeff;
    color: var(--primary);

    font-size: 13px;
    font-weight: 800;
}

.info-box strong {
    color: #244c7c;
}


/* =========================================================
   ACTION BUTTONS
   ========================================================= */

.actions {
    display: flex;
    align-items: center;
    justify-content: space-between;

    margin-top: 32px;

    padding-top: 27px;

    border-top: 1px solid #edf1f6;
}

.cancel-btn {
    display: inline-flex;
    align-items: center;
    gap: 7px;

    padding: 12px 16px;

    color: #64768d;

    text-decoration: none;

    font-size: 13px;
    font-weight: 700;

    border-radius: 9px;

    transition: 0.2s;
}

.cancel-btn:hover {
    color: var(--navy);
    background: #f2f6fa;
}

.continue-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 9px;

    min-width: 180px;

    padding: 14px 22px;

    border: none;
    border-radius: 10px;

    background:
        linear-gradient(
            135deg,
            #1267e8,
            #087ddc
        );

    color: #ffffff;

    font-family: inherit;
    font-size: 13px;
    font-weight: 750;

    cursor: pointer;

    box-shadow:
        0 7px 18px rgba(18,103,232,0.23);

    transition: 0.2s;
}

.continue-btn:hover {
    transform: translateY(-2px);

    box-shadow:
        0 10px 22px rgba(18,103,232,0.30);
}

.arrow {
    font-size: 16px;
}


/* =========================================================
   SAVE NOTE
   ========================================================= */

.save-note {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 7px;

    margin-top: 19px;

    color: #8a98a9;

    font-size: 11.5px;
}

.save-dot {
    width: 6px;
    height: 6px;

    background: #26b37a;
    border-radius: 50%;
}


/* =========================================================
   RESPONSIVE
   ========================================================= */

@media (max-width: 800px) {

    .activity-options {
        grid-template-columns: 1fr;
    }

    .steps {
        display: none;
    }

    .progress-mobile {
        display: block;

        height: 7px;

        background: #e5edf6;

        border-radius: 20px;

        overflow: hidden;
    }

    .progress-mobile div {
        width: 20%;
        height: 100%;

        background:
            linear-gradient(
                90deg,
                var(--primary),
                var(--cyan)
            );
    }

    .journey-card {
        padding: 20px;
    }
}


@media (max-width: 650px) {

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

    .actions {
        flex-direction: column-reverse;
        gap: 12px;
    }

    .continue-btn,
    .cancel-btn {
        width: 100%;
        text-align: center;
        justify-content: center;
    }

    .journey-top {
        margin-bottom: 15px;
    }
}

</style>

</head>


<body>


<!-- ======================================================
     HEADER
     ====================================================== -->

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



<!-- ======================================================
     PAGE
     ====================================================== -->

<main class="page">

<div class="container">


    <!-- BACK -->

    <a class="back-link"
       href="<%= ctx %>/entrepreneur/dashboard">

        <span class="back-circle">
            ←
        </span>

        Back to Dashboard

    </a>



    <!-- PAGE INTRO -->

    <section class="page-heading">

        <div class="page-badge">
            ◆ Business Setup
        </div>

        <h1>
            Build Your Business Profile
        </h1>

        <p>
            Tell us about your business and CHAPERON will
            personalize your approval and compliance journey.
        </p>

    </section>



    <!-- ==================================================
         JOURNEY STEPPER
         ================================================== -->

    <section class="journey-card">

        <div class="journey-top">

            <div class="journey-title">
                Business Profile Setup
            </div>

            <div class="completion">

                <span class="completion-dot"></span>

                20% Complete

            </div>

        </div>


        <div class="steps">

            <div class="step active">

                <div class="step-circle">
                    1
                </div>

                <div class="step-name">
                    Business Basics
                </div>

            </div>


            <div class="step">

                <div class="step-circle">
                    2
                </div>

                <div class="step-name">
                    Industry
                </div>

            </div>


            <div class="step">

                <div class="step-circle">
                    3
                </div>

                <div class="step-name">
                    Location
                </div>

            </div>


            <div class="step">

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



    <!-- ==================================================
         FORM CARD
         ================================================== -->

    <section class="form-card">


        <div class="form-card-header">

            <div class="section-label">
                Step 01 · Business Basics
            </div>

            <h2>
                Tell us about your business
            </h2>

            <p>
                Start with the basics. CHAPERON uses this
                information to understand your business and
                identify approvals that may apply to you.
            </p>

        </div>



        <div class="form-content">


            <% if (errorMessage != null) { %>

                <div class="error-box">

                    <span class="error-icon">
                        !
                    </span>

                    <span>
                        <%= errorMessage %>
                    </span>

                </div>

            <% } %>



            <form
                method="post"
                action="<%= ctx %>/entrepreneur/business-onboarding">


                <!-- ======================================
                     BUSINESS NAME
                     ====================================== -->

                <div class="form-group">

                    <label
                        class="form-label"
                        for="businessName">

                        Business Name

                        <span class="required">
                            *
                        </span>

                    </label>


                    <div class="input-wrap">

                        <input
                            type="text"
                            id="businessName"
                            name="businessName"
                            value="<%= businessName %>"
                            placeholder="Example: ABC Foods Pvt Ltd"
                            maxlength="150"
                            autocomplete="organization"
                            required>

                    </div>

                </div>



                <!-- ======================================
                     BUSINESS CONSTITUTION
                     ====================================== -->

                <div class="form-group">

                    <label
                        class="form-label"
                        for="businessConstitution">

                        Business Constitution

                        <span class="required">
                            *
                        </span>

                        <span class="help">
                            — How is your business legally structured?
                        </span>

                    </label>


                    <select
                        id="businessConstitution"
                        name="businessConstitution"
                        required>

                        <option value="">
                            Select business constitution
                        </option>


                        <option
                            value="Proprietorship"
                            <%= "Proprietorship".equals(businessConstitution)
                                    ? "selected" : "" %>>

                            Proprietorship

                        </option>


                        <option
                            value="Partnership"
                            <%= "Partnership".equals(businessConstitution)
                                    ? "selected" : "" %>>

                            Partnership

                        </option>


                        <option
                            value="LLP"
                            <%= "LLP".equals(businessConstitution)
                                    ? "selected" : "" %>>

                            LLP

                        </option>


                        <option
                            value="Private Limited"
                            <%= "Private Limited".equals(businessConstitution)
                                    ? "selected" : "" %>>

                            Private Limited

                        </option>


                        <option
                            value="Public Limited"
                            <%= "Public Limited".equals(businessConstitution)
                                    ? "selected" : "" %>>

                            Public Limited

                        </option>


                        <option
                            value="Startup"
                            <%= "Startup".equals(businessConstitution)
                                    ? "selected" : "" %>>

                            Startup

                        </option>


                        <option
                            value="Cooperative"
                            <%= "Cooperative".equals(businessConstitution)
                                    ? "selected" : "" %>>

                            Cooperative

                        </option>

                    </select>

                </div>



                <!-- ======================================
                     MAIN BUSINESS ACTIVITY
                     ====================================== -->

                <div class="form-group">

                    <div class="activity-title-row">

                        <div class="activity-question">

                            Main Business Activity

                            <span class="required">
                                *
                            </span>

                        </div>

                        <div class="selection-note">
                            Select one
                        </div>

                    </div>



                    <div class="activity-options">


                        <!-- MANUFACTURING -->

                        <label class="activity-card">

                            <input
                                type="radio"
                                name="businessActivity"
                                value="Manufacturing"
                                <%= "Manufacturing".equals(businessActivity)
                                        ? "checked" : "" %>
                                required>

                            <span class="radio-indicator"></span>


                            <span class="activity-icon">
                                ⚙
                            </span>

                            <span class="activity-name">
                                Manufacturing
                            </span>

                            <span class="activity-description">
                                You manufacture or process
                                physical products.
                            </span>

                        </label>



                        <!-- SERVICE -->

                        <label class="activity-card">

                            <input
                                type="radio"
                                name="businessActivity"
                                value="Service"
                                <%= "Service".equals(businessActivity)
                                        ? "checked" : "" %>>

                            <span class="radio-indicator"></span>


                            <span class="activity-icon">
                                ◇
                            </span>

                            <span class="activity-name">
                                Service
                            </span>

                            <span class="activity-description">
                                You primarily provide professional
                                or commercial services.
                            </span>

                        </label>



                        <!-- TRADING -->

                        <label class="activity-card">

                            <input
                                type="radio"
                                name="businessActivity"
                                value="Trading"
                                <%= "Trading".equals(businessActivity)
                                        ? "checked" : "" %>>

                            <span class="radio-indicator"></span>


                            <span class="activity-icon">
                                ⇄
                            </span>

                            <span class="activity-name">
                                Trading
                            </span>

                            <span class="activity-description">
                                You primarily buy and sell
                                products or goods.
                            </span>

                        </label>


                    </div>

                </div>



                <!-- ======================================
                     INFORMATION
                     ====================================== -->

                <div class="info-box">

                    <div class="info-icon">
                        i
                    </div>

                    <div>

                        <strong>
                            Why do we need this information?
                        </strong>

                        <br>

                        Your business structure and primary
                        activity help CHAPERON determine which
                        registrations, licences, NOCs and
                        compliance requirements may apply.

                    </div>

                </div>



                <!-- ======================================
                     ACTIONS
                     ====================================== -->

                <div class="actions">


                    <a
                        class="cancel-btn"
                        href="<%= ctx %>/entrepreneur/dashboard">

                        ← Cancel & Return

                    </a>


                    <button
                        type="submit"
                        class="continue-btn">

                        Save & Continue

                        <span class="arrow">
                            →
                        </span>

                    </button>


                </div>


            </form>



            <div class="save-note">

                <span class="save-dot"></span>

                Your information will be saved securely
                as you complete each step.

            </div>


        </div>

    </section>


</div>

</main>


</body>
</html>