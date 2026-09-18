<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="com.chaperon.model.Business" %>

<%
    Business business =
            (Business) request.getAttribute("business");

    String selectedIndustry = "";

    if (business != null &&
        business.getIndustry() != null) {

        selectedIndustry =
                business.getIndustry();
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
    Industry | CHAPERON
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

    width: 20%;

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
   INDUSTRY GRID
========================================================= */

.industry-intro {

    margin-bottom: 14px;

    display: flex;
    align-items: center;
    justify-content: space-between;

    gap: 15px;
}

.industry-intro strong {

    color: #203754;

    font-size: 14px;
}

.selection-note {

    color: #8a99ab;

    font-size: 11px;
}

.industry-grid {

    display: grid;

    grid-template-columns:
        repeat(3,1fr);

    gap: 14px;
}

.industry-card {

    position: relative;

    min-height: 115px;

    padding:
        18px;

    display: flex;
    align-items: center;

    gap: 12px;

    border:
        1.5px solid #d9e3ef;

    border-radius: 14px;

    background: white;

    cursor: pointer;

    transition:
        .2s ease;
}

.industry-card:hover {

    transform:
        translateY(-3px);

    border-color: #91bdff;

    box-shadow:
        0 9px 22px
        rgba(21,92,185,.08);
}

.industry-card input {

    position: absolute;

    opacity: 0;

    pointer-events: none;
}

.industry-radio {

    width: 19px;
    height: 19px;

    min-width: 19px;

    border:
        2px solid #c4d1e0;

    border-radius: 50%;

    background: white;

    transition: .2s;
}

.industry-icon {

    width: 37px;
    height: 37px;

    min-width: 37px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 10px;

    color: var(--primary);

    background: var(--primary-soft);

    font-size: 16px;

    transition: .2s;
}

.industry-name {

    color: #233a58;

    font-size: 13px;
    font-weight: 800;

    line-height: 1.35;
}

.industry-card:has(input:checked) {

    border-color: var(--primary);

    background:
        linear-gradient(
            145deg,
            #ffffff,
            #f1f7ff
        );

    box-shadow:
        0 8px 22px
        rgba(18,103,232,.12);
}

.industry-card:has(input:checked)
.industry-radio {

    border:
        5px solid var(--primary);
}

.industry-card:has(input:checked)
.industry-icon {

    color: white;

    background:
        linear-gradient(
            135deg,
            var(--primary),
            var(--cyan)
        );
}


/* =========================================================
   INFO BOX
========================================================= */

.info-box {

    margin-top: 24px;

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

@media(max-width: 850px) {

    .industry-grid {

        grid-template-columns:
            repeat(2,1fr);
    }

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

        width: 40%;
        height: 100%;

        background:
            linear-gradient(
                90deg,
                var(--primary),
                var(--cyan)
            );
    }
}

@media(max-width: 620px) {

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

    .industry-grid {

        grid-template-columns: 1fr;
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
    href="<%= ctx %>/entrepreneur/business-onboarding">

    <span class="back-circle">
        ←
    </span>

    Back to Step 1

</a>


<!-- PAGE HEADING -->

<section class="page-heading">


    <div class="page-badge">
        ◆ Industry Classification
    </div>


    <h1>
        Build Your Business Profile
    </h1>


    <p>
        Select the industry that best represents your
        business so CHAPERON can identify relevant
        regulatory requirements.
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

            40% Complete

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


        <div class="step active">

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


<!-- =========================================================
     FORM CARD
========================================================= -->

<section class="form-card">


    <div class="form-card-header">


        <div class="section-label">
            Step 02 · Industry
        </div>


        <h2>
            What industry are you in?
        </h2>


        <p>
            Choose the industry that best describes your
            primary business activity. CHAPERON uses this
            selection to narrow down applicable approvals,
            licences and compliance requirements.
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


        <form
            method="post"
            action="<%= ctx %>/entrepreneur/business-onboarding/step2">


            <div class="industry-intro">

                <strong>
                    Select Your Industry
                    <span style="color:#dc3545;">
                        *
                    </span>
                </strong>

                <span class="selection-note">
                    Select one
                </span>

            </div>


            <div class="industry-grid">


                <!-- FOOD PROCESSING -->

                <label class="industry-card">

                    <input
                        type="radio"
                        name="industry"
                        value="Food Processing"
                        <%= "Food Processing".equals(selectedIndustry)
                                ? "checked" : "" %>
                        required>

                    <span class="industry-radio"></span>

                    <span class="industry-icon">
                        ◉
                    </span>

                    <span class="industry-name">
                        Food Processing
                    </span>

                </label>


                <!-- CHEMICAL -->

                <label class="industry-card">

                    <input
                        type="radio"
                        name="industry"
                        value="Chemical"
                        <%= "Chemical".equals(selectedIndustry)
                                ? "checked" : "" %>>

                    <span class="industry-radio"></span>

                    <span class="industry-icon">
                        ⚗
                    </span>

                    <span class="industry-name">
                        Chemical
                    </span>

                </label>


                <!-- PHARMACEUTICAL -->

                <label class="industry-card">

                    <input
                        type="radio"
                        name="industry"
                        value="Pharmaceutical"
                        <%= "Pharmaceutical".equals(selectedIndustry)
                                ? "checked" : "" %>>

                    <span class="industry-radio"></span>

                    <span class="industry-icon">
                        ✚
                    </span>

                    <span class="industry-name">
                        Pharmaceutical
                    </span>

                </label>


                <!-- TEXTILE -->

                <label class="industry-card">

                    <input
                        type="radio"
                        name="industry"
                        value="Textile"
                        <%= "Textile".equals(selectedIndustry)
                                ? "checked" : "" %>>

                    <span class="industry-radio"></span>

                    <span class="industry-icon">
                        ◇
                    </span>

                    <span class="industry-name">
                        Textile
                    </span>

                </label>


                <!-- AUTOMOBILE -->

                <label class="industry-card">

                    <input
                        type="radio"
                        name="industry"
                        value="Automobile"
                        <%= "Automobile".equals(selectedIndustry)
                                ? "checked" : "" %>>

                    <span class="industry-radio"></span>

                    <span class="industry-icon">
                        ◉
                    </span>

                    <span class="industry-name">
                        Automobile
                    </span>

                </label>


                <!-- ELECTRONICS -->

                <label class="industry-card">

                    <input
                        type="radio"
                        name="industry"
                        value="Electronics"
                        <%= "Electronics".equals(selectedIndustry)
                                ? "checked" : "" %>>

                    <span class="industry-radio"></span>

                    <span class="industry-icon">
                        ⚡
                    </span>

                    <span class="industry-name">
                        Electronics
                    </span>

                </label>


                <!-- CONSTRUCTION -->

                <label class="industry-card">

                    <input
                        type="radio"
                        name="industry"
                        value="Construction"
                        <%= "Construction".equals(selectedIndustry)
                                ? "checked" : "" %>>

                    <span class="industry-radio"></span>

                    <span class="industry-icon">
                        △
                    </span>

                    <span class="industry-name">
                        Construction
                    </span>

                </label>


                <!-- IT SOFTWARE -->

                <label class="industry-card">

                    <input
                        type="radio"
                        name="industry"
                        value="IT / Software"
                        <%= "IT / Software".equals(selectedIndustry)
                                ? "checked" : "" %>>

                    <span class="industry-radio"></span>

                    <span class="industry-icon">
                        &lt;/&gt;
                    </span>

                    <span class="industry-name">
                        IT / Software
                    </span>

                </label>


                <!-- AGRICULTURE -->

                <label class="industry-card">

                    <input
                        type="radio"
                        name="industry"
                        value="Agriculture"
                        <%= "Agriculture".equals(selectedIndustry)
                                ? "checked" : "" %>>

                    <span class="industry-radio"></span>

                    <span class="industry-icon">
                        ♢
                    </span>

                    <span class="industry-name">
                        Agriculture
                    </span>

                </label>


                <!-- LOGISTICS -->

                <label class="industry-card">

                    <input
                        type="radio"
                        name="industry"
                        value="Logistics"
                        <%= "Logistics".equals(selectedIndustry)
                                ? "checked" : "" %>>

                    <span class="industry-radio"></span>

                    <span class="industry-icon">
                        ⇄
                    </span>

                    <span class="industry-name">
                        Logistics
                    </span>

                </label>


                <!-- RENEWABLE ENERGY -->

                <label class="industry-card">

                    <input
                        type="radio"
                        name="industry"
                        value="Renewable Energy"
                        <%= "Renewable Energy".equals(selectedIndustry)
                                ? "checked" : "" %>>

                    <span class="industry-radio"></span>

                    <span class="industry-icon">
                        ☼
                    </span>

                    <span class="industry-name">
                        Renewable Energy
                    </span>

                </label>


                <!-- HOSPITALITY -->

                <label class="industry-card">

                    <input
                        type="radio"
                        name="industry"
                        value="Hospitality"
                        <%= "Hospitality".equals(selectedIndustry)
                                ? "checked" : "" %>>

                    <span class="industry-radio"></span>

                    <span class="industry-icon">
                        ☆
                    </span>

                    <span class="industry-name">
                        Hospitality
                    </span>

                </label>


                <!-- MANUFACTURING -->

                <label class="industry-card">

                    <input
                        type="radio"
                        name="industry"
                        value="Manufacturing"
                        <%= "Manufacturing".equals(selectedIndustry)
                                ? "checked" : "" %>>

                    <span class="industry-radio"></span>

                    <span class="industry-icon">
                        ⚙
                    </span>

                    <span class="industry-name">
                        Manufacturing
                    </span>

                </label>


                <!-- OTHER -->

                <label class="industry-card">

                    <input
                        type="radio"
                        name="industry"
                        value="Other"
                        <%= "Other".equals(selectedIndustry)
                                ? "checked" : "" %>>

                    <span class="industry-radio"></span>

                    <span class="industry-icon">
                        +
                    </span>

                    <span class="industry-name">
                        Other
                    </span>

                </label>


            </div>


            <!-- INFO -->

            <div class="info-box">

                <div class="info-icon">
                    i
                </div>

                <div>

                    <strong>
                        Why does industry matter?
                    </strong>

                    <br>

                    Different industries can require different
                    registrations, NOCs, licences, inspections
                    and environmental or safety compliances.
                    CHAPERON uses this choice to personalise
                    your regulatory roadmap.

                </div>

            </div>


            <!-- ACTIONS -->

            <div class="actions">


                <a
                    class="back-btn"
                    href="<%= ctx %>/entrepreneur/business-onboarding">

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

            Your selected industry will be saved
            with your business profile.

        </div>


    </div>


</section>


</div>

</main>


</body>

</html>