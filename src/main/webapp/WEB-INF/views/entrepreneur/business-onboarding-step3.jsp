<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="com.chaperon.model.Business" %>

<%
    Business business =
            (Business) request.getAttribute("business");

    String state = "";
    String district = "";
    String taluka = "";
    String industrialArea = "";
    String pinCode = "";

    if (business != null) {

        if (business.getState() != null) {
            state = business.getState();
        }

        if (business.getDistrict() != null) {
            district = business.getDistrict();
        }

        if (business.getTaluka() != null) {
            taluka = business.getTaluka();
        }

        if (business.getIndustrialArea() != null) {
            industrialArea =
                    business.getIndustrialArea();
        }

        if (business.getPinCode() != null) {
            pinCode = business.getPinCode();
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

<title>
    Business Location | CHAPERON
</title>

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
   TOPBAR
========================================================= */

.topbar {

    height: 82px;

    padding:
        0
        6%;

    display: flex;
    align-items: center;
    justify-content: space-between;

    background:
        rgba(255,255,255,.96);

    border-bottom:
        1px solid #e6edf6;

    position: sticky;
    top: 0;
    z-index: 100;

    box-shadow:
        0 4px 20px
        rgba(15,45,85,.04);
}


/* =========================================================
   BRAND
========================================================= */

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

    border:
        1px solid #e1e9f3;

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

    padding:
        35px
        20px
        60px;
}

.container {

    width: 100%;

    max-width: 1030px;

    margin: auto;
}


/* =========================================================
   BACK LINK
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

    transform:
        translateX(-2px);
}

.back-circle {

    width: 29px;
    height: 29px;

    display: inline-flex;
    align-items: center;
    justify-content: center;

    border:
        1px solid #dce6f2;

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

    padding:
        7px
        12px;

    display: inline-flex;
    align-items: center;

    gap: 7px;

    border:
        1px solid #d3e8ff;

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

    color: var(--muted);

    font-size: 14px;
    line-height: 1.6;
}


/* =========================================================
   JOURNEY
========================================================= */

.journey-card {

    margin-bottom: 24px;

    padding:
        22px
        28px;

    border:
        1px solid #e0e9f4;

    border-radius: 18px;

    background:
        rgba(255,255,255,.96);

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

    width: 40%;

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

    border:
        2px solid #d7e2ef;

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

    border:
        1px solid #dfe8f2;

    border-radius: 22px;

    background:
        rgba(255,255,255,.98);

    box-shadow:
        0 18px 50px
        rgba(17,50,90,.08);
}

.form-card-header {

    position: relative;

    padding:
        31px
        38px
        27px;

    border-bottom:
        1px solid #e0eaf5;

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

    max-width: 720px;

    color: #6d7e94;

    font-size: 14px;
    line-height: 1.6;
}

.form-content {

    padding:
        34px
        38px
        38px;
}


/* =========================================================
   ERROR
========================================================= */

.error-box {

    margin-bottom: 24px;

    padding:
        14px
        16px;

    display: flex;
    align-items: flex-start;

    gap: 10px;

    border:
        1px solid #f3cccc;

    border-radius: 11px;

    color: #a72b2b;

    background: #fff4f4;

    font-size: 13px;
    line-height: 1.5;
}


/* =========================================================
   FORM GRID
========================================================= */

.form-grid {

    display: grid;

    grid-template-columns:
        1fr
        1fr;

    gap:
        24px
        20px;
}

.form-group {
    min-width: 0;
}

.full-width {
    grid-column: 1 / -1;
}

.form-label {

    margin-bottom: 9px;

    display: flex;
    align-items: center;

    gap: 5px;

    color: #203754;

    font-size: 14px;
    font-weight: 750;
}

.required {
    color: #dc3545;
}

.input-wrap {
    position: relative;
}

input,
select {

    width: 100%;
    height: 52px;

    padding:
        0
        15px;

    border:
        1px solid #cedbea;

    border-radius: 11px;

    outline: none;

    color: #263a54;

    background: white;

    font-family: inherit;
    font-size: 14px;

    transition: .2s ease;
}

input:hover,
select:hover {
    border-color: #aabfd8;
}

input:focus,
select:focus {

    border-color: var(--primary);

    box-shadow:
        0 0 0 4px
        rgba(18,103,232,.09);
}

input::placeholder {
    color: #a0adbd;
}

.field-icon {

    position: absolute;

    right: 14px;
    top: 50%;

    transform:
        translateY(-50%);

    color: #87a0bd;

    font-size: 15px;

    pointer-events: none;
}

.with-icon input {
    padding-right: 42px;
}

.help-text {

    margin-top: 6px;

    color: #8492a5;

    font-size: 11.5px;
    line-height: 1.45;
}


/* =========================================================
   LOCATION HIGHLIGHT
========================================================= */

.location-highlight {

    margin-bottom: 24px;

    padding:
        16px
        18px;

    display: flex;
    align-items: center;

    gap: 13px;

    border:
        1px solid #d9e9fb;

    border-radius: 13px;

    background:
        linear-gradient(
            100deg,
            #f0f7ff,
            #f8fcff
        );
}

.location-icon {

    width: 39px;
    height: 39px;

    min-width: 39px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 11px;

    color: white;

    background:
        linear-gradient(
            135deg,
            var(--primary),
            var(--cyan)
        );

    font-size: 18px;

    box-shadow:
        0 6px 14px
        rgba(18,103,232,.18);
}

.location-highlight strong {

    display: block;

    color: #23405f;

    font-size: 12.5px;

    margin-bottom: 3px;
}

.location-highlight span {

    color: #6f839e;

    font-size: 11.5px;
}


/* =========================================================
   INFO BOX
========================================================= */

.info-box {

    margin-top: 26px;

    padding:
        16px
        17px;

    display: flex;

    gap: 13px;

    border:
        1px solid #d5e9ff;

    border-radius: 12px;

    color: #526d8c;

    background:
        linear-gradient(
            100deg,
            #eef7ff,
            #f7fbff
        );

    font-size: 12.5px;
    line-height: 1.55;
}

.info-icon {

    width: 27px;
    height: 27px;

    min-width: 27px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 8px;

    color: var(--primary);

    background: #dceeff;

    font-size: 13px;
    font-weight: 800;
}

.info-box strong {
    color: #244c7c;
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

    border-top:
        1px solid #edf1f6;
}

.back-btn {

    padding:
        12px
        16px;

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

    padding:
        14px
        22px;

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

    transform:
        translateY(-2px);

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

    background: #26b37a;
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

        width: 60%;
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

        padding:
            0
            18px;
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

        padding:
            25px
            14px
            45px;
    }

    .page-heading h1 {
        font-size: 25px;
    }

    .form-card-header {

        padding:
            25px
            22px
            22px;
    }

    .form-card-header h2 {
        font-size: 22px;
    }

    .form-content {

        padding:
            26px
            22px;
    }

    .form-grid {
        grid-template-columns: 1fr;
    }

    .full-width {
        grid-column: auto;
    }

    .actions {

        flex-direction:
            column-reverse;

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
    href="<%= ctx %>/entrepreneur/business-onboarding/step2">

    <span class="back-circle">
        ←
    </span>

    Back to Step 2

</a>


<!-- PAGE HEADING -->

<section class="page-heading">


    <div class="page-badge">
        ◆ Business Location
    </div>


    <h1>
        Build Your Business Profile
    </h1>


    <p>
        Add your business location so CHAPERON can
        understand which state, local and industrial
        requirements may apply.
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

            60% Complete

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


        <div class="step active">

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


<!-- =========================================================
     FORM CARD
========================================================= -->

<section class="form-card">


    <div class="form-card-header">


        <div class="section-label">
            Step 03 · Location
        </div>


        <h2>
            Where is your business located?
        </h2>


        <p>
            Location can affect state-level permissions,
            local authority requirements, industrial-area
            approvals and other regulatory obligations.
        </p>


    </div>


    <div class="form-content">


        <% if (errorMessage != null) { %>

            <div class="error-box">

                <strong>
                    !
                </strong>

                <span>
                    <%= errorMessage %>
                </span>

            </div>

        <% } %>


        <div class="location-highlight">

            <div class="location-icon">
                ◎
            </div>

            <div>

                <strong>
                    Location-based regulatory matching
                </strong>

                <span>
                    These details help CHAPERON connect your
                    business with relevant state and local rules.
                </span>

            </div>

        </div>


        <form
            method="post"
            action="<%= ctx %>/entrepreneur/business-onboarding/step3">


            <div class="form-grid">


                <!-- =========================================
                     STATE
                ========================================== -->

                <div class="form-group">

                    <label
                        class="form-label"
                        for="state">

                        State

                        <span class="required">
                            *
                        </span>

                    </label>


                    <select
                        id="state"
                        name="state"
                        required>

                        <option value="">
                            Select State
                        </option>


                        <option
                            value="Uttar Pradesh"
                            <%= "Uttar Pradesh".equals(state)
                                    ? "selected" : "" %>>

                            Uttar Pradesh

                        </option>


                        <option
                            value="Maharashtra"
                            <%= "Maharashtra".equals(state)
                                    ? "selected" : "" %>>

                            Maharashtra

                        </option>


                        <option
                            value="Delhi"
                            <%= "Delhi".equals(state)
                                    ? "selected" : "" %>>

                            Delhi

                        </option>


                        <option
                            value="Gujarat"
                            <%= "Gujarat".equals(state)
                                    ? "selected" : "" %>>

                            Gujarat

                        </option>


                        <option
                            value="Karnataka"
                            <%= "Karnataka".equals(state)
                                    ? "selected" : "" %>>

                            Karnataka

                        </option>


                        <option
                            value="Rajasthan"
                            <%= "Rajasthan".equals(state)
                                    ? "selected" : "" %>>

                            Rajasthan

                        </option>


                        <option
                            value="Madhya Pradesh"
                            <%= "Madhya Pradesh".equals(state)
                                    ? "selected" : "" %>>

                            Madhya Pradesh

                        </option>


                        <option
                            value="Other"
                            <%= "Other".equals(state)
                                    ? "selected" : "" %>>

                            Other

                        </option>

                    </select>

                </div>


                <!-- =========================================
                     DISTRICT
                ========================================== -->

                <div class="form-group">

                    <label
                        class="form-label"
                        for="district">

                        District

                        <span class="required">
                            *
                        </span>

                    </label>


                    <div class="input-wrap with-icon">

                        <input
                            type="text"
                            id="district"
                            name="district"
                            value="<%= district %>"
                            placeholder="Example: Gorakhpur"
                            maxlength="100"
                            required>

                        <span class="field-icon">
                            ◎
                        </span>

                    </div>

                </div>


                <!-- =========================================
                     TALUKA
                ========================================== -->

                <div class="form-group">

                    <label
                        class="form-label"
                        for="taluka">

                        Taluka / Tehsil

                        <span class="required">
                            *
                        </span>

                    </label>


                    <input
                        type="text"
                        id="taluka"
                        name="taluka"
                        value="<%= taluka %>"
                        placeholder="Enter Taluka / Tehsil"
                        maxlength="100"
                        required>

                </div>


                <!-- =========================================
                     PIN CODE
                ========================================== -->

                <div class="form-group">

                    <label
                        class="form-label"
                        for="pinCode">

                        PIN Code

                        <span class="required">
                            *
                        </span>

                    </label>


                    <input
                        type="text"
                        id="pinCode"
                        name="pinCode"
                        value="<%= pinCode %>"
                        placeholder="6-digit PIN code"
                        maxlength="6"
                        pattern="[0-9]{6}"
                        inputmode="numeric"
                        required>

                    <div class="help-text">
                        Enter a valid 6-digit postal PIN code.
                    </div>

                </div>


                <!-- =========================================
                     INDUSTRIAL AREA
                ========================================== -->

                <div class="form-group full-width">

                    <label
                        class="form-label"
                        for="industrialArea">

                        Industrial Area

                        <span class="help-text"
                              style="margin:0;">
                            — Optional
                        </span>

                    </label>


                    <input
                        type="text"
                        id="industrialArea"
                        name="industrialArea"
                        value="<%= industrialArea %>"
                        placeholder="Example: GIDA Industrial Area">


                    <div class="help-text">

                        Leave this blank if your business
                        is not located inside a designated
                        industrial area.

                    </div>

                </div>


            </div>


            <!-- INFO -->

            <div class="info-box">

                <div class="info-icon">
                    i
                </div>

                <div>

                    <strong>
                        How CHAPERON uses your location
                    </strong>

                    <br>

                    Your state, district and industrial
                    location help CHAPERON match relevant
                    state and local approval rules with your
                    business profile.

                </div>

            </div>


            <!-- ACTIONS -->

            <div class="actions">


                <a
                    class="back-btn"
                    href="<%= ctx %>/entrepreneur/business-onboarding/step2">

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

            Your location information will be saved
            securely with your business profile.

        </div>


    </div>


</section>


</div>

</main>


</body>

</html>