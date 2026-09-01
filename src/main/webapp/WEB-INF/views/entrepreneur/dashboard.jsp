<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%
    String ctx = request.getContextPath();

    String userName =
            (String) session.getAttribute("userName");

    if (userName == null ||
        userName.isBlank()) {

        userName = "Entrepreneur";
    }

    String avatarLetter = "E";

    if (userName != null &&
        !userName.isBlank()) {

        avatarLetter =
                userName
                    .substring(0, 1)
                    .toUpperCase();
    }
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    Entrepreneur Dashboard | CHAPERON
</title>


<style>

/* =========================================================
   RESET
========================================================= */

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}


:root {

    --primary: #095ee8;
    --primary-dark: #0645b5;

    --navy: #0d1c3d;
    --navy-light: #21375e;

    --cyan: #28b8ef;

    --green: #10a966;
    --green-soft: #e9f9f1;

    --orange: #ef922d;
    --orange-soft: #fff3e7;

    --purple: #7655dc;
    --purple-soft: #f1edff;

    --red: #dc4a4a;
    --red-dark: #b83737;
    --red-soft: #fff0f0;

    --blue-soft: #edf5ff;

    --text: #172846;
    --muted: #6d809d;

    --border: #e0e9f5;

    --background: #f5f8fd;
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
            circle at 80% 5%,
            rgba(41, 165, 255, 0.08),
            transparent 25%
        ),

        linear-gradient(
            145deg,
            #f4f8fe,
            #f9fbff
        );
}


a {
    text-decoration: none;
    color: inherit;
}



/* =========================================================
   TOP HEADER
========================================================= */

.topbar {

    position: sticky;

    top: 0;

    z-index: 1000;

    min-height: 78px;

    padding:
        0
        4%;

    display: flex;
    align-items: center;
    justify-content: space-between;

    gap: 25px;

    background:
        rgba(
            255,
            255,
            255,
            0.94
        );

    border-bottom:
        1px solid #e3ebf6;

    backdrop-filter:
        blur(16px);

    box-shadow:
        0 5px 24px
        rgba(
            35,
            70,
            124,
            0.05
        );
}



/* =========================================================
   BRAND
========================================================= */

.brand {

    display: flex;
    align-items: center;

    gap: 10px;

    flex-shrink: 0;
}


.brand-logo {

    position: relative;

    width: 51px;
    height: 51px;

    min-width: 51px;

    overflow: hidden;

    border-radius: 50%;

    background: #ffffff;
}


.brand-logo img {

    position: absolute;

    width: 92px;
    height: 92px;

    max-width: none;

    left: -20px;
    top: -7px;

    object-fit: cover;
}


.brand-name {

    color: #1153c4;

    font-size: 23px;

    line-height: 1;

    font-weight: 900;

    letter-spacing: 0.2px;
}


.brand-tagline {

    margin-top: 5px;

    color: #1454bd;

    font-size: 6px;

    font-weight: 900;

    letter-spacing: 0.25px;

    white-space: nowrap;
}



/* =========================================================
   HEADER ACTIONS
========================================================= */

.header-actions {

    display: flex;
    align-items: center;

    gap: 9px;
}



/* =========================================================
   NOTIFICATION BUTTON
========================================================= */

.notification-button {

    position: relative;

    width: 43px;
    height: 43px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 50%;

    color: #28436d;

    background: #f0f5fc;

    transition:
        transform 0.2s ease,
        background 0.2s ease;
}


.notification-button:hover {

    transform:
        translateY(-2px);

    color: var(--primary);

    background: #eaf3ff;
}


.notification-button svg {

    width: 20px;
    height: 20px;
}



/* =========================================================
   PROFILE
========================================================= */

.profile-button {

    min-width: 190px;

    padding:
        5px
        11px
        5px
        5px;

    display: flex;
    align-items: center;

    gap: 10px;

    border:
        1px solid transparent;

    border-radius: 13px;

    transition:
        background 0.2s ease,
        border 0.2s ease,
        transform 0.2s ease;
}


.profile-button:hover {

    transform:
        translateY(-1px);

    border-color: #dce7f5;

    background: #f5f9ff;
}


.profile-avatar {

    width: 42px;
    height: 42px;

    min-width: 42px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 50%;

    color: #ffffff;

    background:
        linear-gradient(
            135deg,
            #0961ec,
            #6ca2ff
        );

    box-shadow:
        0 7px 16px
        rgba(
            9,
            94,
            232,
            0.18
        );

    font-size: 14px;

    font-weight: 800;
}


.profile-info {

    min-width: 0;

    flex: 1;
}


.profile-name {

    overflow: hidden;

    color: #172b50;

    font-size: 12px;

    font-weight: 800;

    text-overflow: ellipsis;

    white-space: nowrap;
}


.profile-role {

    margin-top: 2px;

    color: #7b8ca5;

    font-size: 9px;
}


.profile-arrow {

    color: #72829b;

    font-size: 17px;
}



/* =========================================================
   LOGOUT BUTTON
========================================================= */

.logout-button {

    min-height: 42px;

    padding:
        0
        13px;

    display: inline-flex;
    align-items: center;
    justify-content: center;

    gap: 7px;

    border:
        1px solid #f3d8d8;

    border-radius: 10px;

    color: #b63b3b;

    background: #fff2f2;

    font-size: 10px;

    font-weight: 800;

    transition:
        transform 0.2s ease,
        color 0.2s ease,
        background 0.2s ease,
        border 0.2s ease;
}


.logout-button svg {

    width: 17px;
    height: 17px;
}


.logout-button:hover {

    transform:
        translateY(-1px);

    color: #ffffff;

    border-color: var(--red);

    background:
        linear-gradient(
            135deg,
            #e05252,
            #bd3939
        );
}



/* =========================================================
   PAGE
========================================================= */

.page {

    padding:
        32px
        20px
        60px;
}


.container {

    width: 100%;

    max-width: 1250px;

    margin: auto;
}



/* =========================================================
   HERO
========================================================= */

.hero {

    position: relative;

    overflow: hidden;

    min-height: 225px;

    margin-bottom: 31px;

    padding:
        38px
        40px;

    display: flex;
    align-items: center;
    justify-content: space-between;

    gap: 40px;

    border-radius: 24px;

    color: #ffffff;

    background:

        radial-gradient(
            circle at 88% 5%,
            rgba(56, 214, 255, 0.30),
            transparent 31%
        ),

        linear-gradient(
            128deg,
            #075de8,
            #1644b7
        );

    box-shadow:
        0 18px 42px
        rgba(
            15,
            73,
            175,
            0.18
        );
}


.hero::before {

    content: "";

    position: absolute;

    width: 270px;
    height: 270px;

    right: -105px;
    bottom: -155px;

    border:
        40px solid
        rgba(
            255,
            255,
            255,
            0.06
        );

    border-radius: 50%;
}


.hero::after {

    content: "";

    position: absolute;

    width: 110px;
    height: 110px;

    right: 220px;
    top: -65px;

    border-radius: 50%;

    background:
        rgba(
            255,
            255,
            255,
            0.06
        );
}


.hero-content {

    position: relative;

    z-index: 2;

    max-width: 720px;
}


.welcome-badge {

    width: max-content;

    margin-bottom: 13px;

    padding:
        6px
        11px;

    display: flex;
    align-items: center;

    gap: 6px;

    border:
        1px solid
        rgba(
            255,
            255,
            255,
            0.22
        );

    border-radius: 50px;

    color: #e2f0ff;

    background:
        rgba(
            255,
            255,
            255,
            0.10
        );

    font-size: 9px;

    font-weight: 800;

    letter-spacing: 0.6px;
}


.hero h1 {

    margin-bottom: 11px;

    color: #ffffff;

    font-size: 34px;

    line-height: 1.18;
}


.hero h1 span {

    color: #9ee8ff;
}


.hero p {

    max-width: 760px;

    color: #dceaff;

    font-size: 13px;

    line-height: 1.7;
}



/* =========================================================
   HERO VISUAL
========================================================= */

.hero-visual {

    position: relative;

    z-index: 2;

    width: 240px;
    height: 155px;

    flex-shrink: 0;

    display: flex;
    align-items: center;
    justify-content: center;
}


.hero-circle {

    position: absolute;

    width: 145px;
    height: 145px;

    border-radius: 50%;

    background:
        rgba(
            255,
            255,
            255,
            0.10
        );

    border:
        1px solid
        rgba(
            255,
            255,
            255,
            0.15
        );
}


.hero-building {

    position: relative;

    z-index: 2;

    width: 160px;
    height: 110px;

    padding: 14px;

    border:
        1px solid
        rgba(
            255,
            255,
            255,
            0.24
        );

    border-radius: 17px;

    background:
        rgba(
            255,
            255,
            255,
            0.15
        );

    backdrop-filter:
        blur(10px);

    box-shadow:
        0 13px 25px
        rgba(
            0,
            34,
            98,
            0.16
        );
}


.building-icon {

    width: 45px;
    height: 45px;

    margin-bottom: 10px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 12px;

    color: var(--primary);

    background: #ffffff;
}


.building-icon svg {

    width: 24px;
    height: 24px;
}


.hero-building strong {

    display: block;

    color: white;

    font-size: 11px;
}


.hero-building span {

    display: block;

    margin-top: 3px;

    color: #d9e9ff;

    font-size: 8px;

    line-height: 1.4;
}



/* =========================================================
   WORKSPACE HEADER
========================================================= */

.section-title {

    margin-bottom: 19px;
}


.section-eyebrow {

    margin-bottom: 5px;

    color: var(--primary);

    font-size: 9px;

    font-weight: 850;

    letter-spacing: 1px;

    text-transform: uppercase;
}


.section-title h2 {

    color: var(--navy);

    font-size: 24px;

    line-height: 1.2;
}


.section-title p {

    margin-top: 6px;

    color: var(--muted);

    font-size: 12px;
}



/* =========================================================
   DASHBOARD GRID
========================================================= */

.dashboard-grid {

    display: grid;

    grid-template-columns:
        repeat(
            2,
            minmax(0, 1fr)
        );

    gap: 19px;
}



/* =========================================================
   DASHBOARD CARDS
========================================================= */

.dashboard-card {

    position: relative;

    overflow: hidden;

    min-height: 245px;

    padding: 24px;

    display: flex;
    flex-direction: column;

    border:
        1px solid var(--border);

    border-radius: 18px;

    background: #ffffff;

    box-shadow:
        0 8px 24px
        rgba(
            32,
            67,
            120,
            0.045
        );

    transition:
        transform 0.22s ease,
        box-shadow 0.22s ease,
        border 0.22s ease;
}


.dashboard-card::before {

    content: "";

    position: absolute;

    width: 105px;
    height: 105px;

    right: -55px;
    top: -55px;

    border-radius: 50%;

    background:
        rgba(
            13,
            97,
            233,
            0.035
        );
}


.dashboard-card:hover {

    transform:
        translateY(-4px);

    border-color: #cfdff6;

    box-shadow:
        0 16px 34px
        rgba(
            32,
            67,
            120,
            0.10
        );
}



/* =========================================================
   CARD TOP
========================================================= */

.card-top {

    position: relative;

    z-index: 2;

    margin-bottom: 15px;

    display: flex;
    align-items: center;
    justify-content: space-between;

    gap: 15px;
}


.icon-box {

    width: 49px;
    height: 49px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 13px;

    color: var(--primary);

    background: var(--blue-soft);
}


.icon-box svg {

    width: 23px;
    height: 23px;
}


.step-number {

    min-width: 30px;
    height: 30px;

    padding:
        0 8px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 8px;

    color: var(--primary);

    background: #eef5ff;

    font-size: 10px;

    font-weight: 900;
}



/* =========================================================
   CARD CONTENT
========================================================= */

.dashboard-card h3 {

    position: relative;

    z-index: 2;

    margin-bottom: 8px;

    color: var(--navy);

    font-size: 18px;
}


.dashboard-card p {

    position: relative;

    z-index: 2;

    margin-bottom: 20px;

    color: var(--muted);

    font-size: 12px;

    line-height: 1.65;

    flex: 1;
}



/* =========================================================
   BUTTON
========================================================= */

.primary-btn {

    position: relative;

    z-index: 2;

    width: max-content;

    min-height: 40px;

    padding:
        0 15px;

    display: inline-flex;
    align-items: center;
    justify-content: center;

    gap: 7px;

    border-radius: 8px;

    color: #ffffff;

    background:
        linear-gradient(
            135deg,
            #0962ec,
            #1057d4
        );

    box-shadow:
        0 7px 15px
        rgba(
            9,
            94,
            232,
            0.15
        );

    font-size: 10px;

    font-weight: 800;

    transition:
        transform 0.2s ease,
        box-shadow 0.2s ease;
}


.primary-btn:hover {

    transform:
        translateY(-1px);

    box-shadow:
        0 10px 20px
        rgba(
            9,
            94,
            232,
            0.21
        );
}



/* =========================================================
   BUSINESS PROFILE CARD
========================================================= */

.business-card {

    border-color: #cfe0fa;

    background:

        radial-gradient(
            circle at 90% 5%,
            rgba(
                33,
                160,
                255,
                0.08
            ),
            transparent 35%
        ),

        linear-gradient(
            145deg,
            #ffffff,
            #f7fbff
        );
}


.business-card .icon-box {

    color: #ffffff;

    background:
        linear-gradient(
            135deg,
            #0961eb,
            #4b8ef7
        );

    box-shadow:
        0 8px 19px
        rgba(
            9,
            94,
            232,
            0.19
        );
}



/* =========================================================
   OTHER ICON THEMES
========================================================= */

.approval-card .icon-box {

    color: #6a50dd;

    background: var(--purple-soft);
}


.document-card .icon-box {

    color: #11945a;

    background: var(--green-soft);
}


.application-card .icon-box {

    color: #e78625;

    background: var(--orange-soft);
}


.inspection-card .icon-box {

    color: #0d73d7;

    background: #eaf5ff;
}


.scheme-card .icon-box {

    color: #0c9b58;

    background: #e9f9f1;
}


.compliance-card .icon-box {

    color: #7854dc;

    background: #f1edff;
}


.notification-card .icon-box {

    color: #d84b4b;

    background: #fff0f0;
}



/* =========================================================
   HOW CHAPERON WORKS
========================================================= */

.quick-info {

    position: relative;

    overflow: hidden;

    margin-top: 28px;

    padding:
        24px
        26px;

    border:
        1px solid #d8e6fa;

    border-radius: 17px;

    background:

        radial-gradient(
            circle at 94% 5%,
            rgba(
                48,
                176,
                255,
                0.10
            ),
            transparent 32%
        ),

        linear-gradient(
            145deg,
            #ffffff,
            #f0f7ff
        );

    box-shadow:
        0 8px 24px
        rgba(
            34,
            72,
            130,
            0.05
        );
}


.quick-info-heading {

    margin-bottom: 5px;

    color: var(--navy);

    font-size: 15px;

    font-weight: 850;
}


.quick-info-copy {

    margin-bottom: 17px;

    color: var(--muted);

    font-size: 10px;
}



/* =========================================================
   FLOW
========================================================= */

.flow {

    display: flex;
    align-items: center;

    gap: 7px;

    flex-wrap: wrap;
}


/*
   IMPORTANT:
   Ab koi step highlighted nahi hai.
   Business Profile bhi normal rahega.
*/

.flow-step {

    min-height: 31px;

    padding:
        0 10px;

    display: flex;
    align-items: center;
    justify-content: center;

    border:
        1px solid #d9e6f7;

    border-radius: 7px;

    color: #2f5585;

    background: #ffffff;

    font-size: 8px;

    font-weight: 750;

    transition:
        background 0.2s ease,
        border 0.2s ease,
        transform 0.2s ease;
}


.flow-step:hover {

    transform:
        translateY(-1px);

    border-color: #c3d8f4;

    background: #f7faff;
}


.flow-arrow {

    color: #94a5bb;

    font-size: 11px;

    font-weight: 700;
}



/* =========================================================
   TRUST FOOTER
========================================================= */

.trust-footer {

    min-height: 42px;

    margin-top: 20px;

    padding:
        9px
        15px;

    display: flex;
    align-items: center;
    justify-content: center;

    gap: 7px;

    border-radius: 10px;

    color: #72829a;

    background: #edf3f9;

    font-size: 8px;

    text-align: center;
}


.trust-footer svg {

    width: 14px;
    height: 14px;

    color: #43658f;
}



/* =========================================================
   RESPONSIVE 1050
========================================================= */

@media(max-width: 1050px) {

    .hero-visual {
        display: none;
    }


    .profile-button {
        min-width: 170px;
    }

}



/* =========================================================
   RESPONSIVE 850
========================================================= */

@media(max-width: 850px) {

    .topbar {

        padding:
            12px
            18px;
    }


    .brand-tagline {
        display: none;
    }


    .dashboard-grid {

        grid-template-columns:
            1fr;
    }


    .hero {

        min-height: auto;

        padding: 30px;
    }


    .hero h1 {
        font-size: 28px;
    }


    .logout-button span {
        display: none;
    }


    .logout-button {

        width: 43px;
        height: 43px;

        min-height: 43px;

        padding: 0;
    }

}



/* =========================================================
   RESPONSIVE 620
========================================================= */

@media(max-width: 620px) {

    .page {

        padding:
            20px
            13px
            40px;
    }


    .brand-name {

        font-size: 18px;
    }


    .brand-logo {

        width: 43px;
        height: 43px;

        min-width: 43px;
    }


    .profile-info,
    .profile-arrow {

        display: none;
    }


    .profile-button {

        min-width: 0;

        padding: 4px;
    }


    .notification-button {

        width: 40px;
        height: 40px;
    }


    .hero {

        border-radius: 18px;

        padding:
            25px
            21px;
    }


    .hero h1 {

        font-size: 24px;
    }


    .hero p {

        font-size: 11px;
    }


    .section-title h2 {

        font-size: 21px;
    }


    .dashboard-card {

        min-height: auto;

        padding: 20px;
    }


    .flow {

        align-items: stretch;

        flex-direction: column;
    }


    .flow-arrow {

        display: none;
    }


    .flow-step {

        justify-content: flex-start;

        min-height: 35px;
    }

}

</style>

</head>


<body>


<!-- =========================================================
     HEADER
========================================================= -->

<header class="topbar">


    <!-- LOGO -->

    <a
        href="<%= ctx %>/entrepreneur/dashboard"
        class="brand">


        <div class="brand-logo">

            <img
                src="<%= ctx %>/images/chaperon-logo.jpeg"
                alt="CHAPERON Logo">

        </div>


        <div>

            <div class="brand-name">
                CHAPERON
            </div>

            <div class="brand-tagline">
                GUIDE. CONNECT. COMPLY. GET APPROVED.
            </div>

        </div>


    </a>



    <!-- HEADER RIGHT -->

    <div class="header-actions">


        <!-- NOTIFICATION -->

        <a
            href="<%= ctx %>/entrepreneur/notifications"
            class="notification-button"
            title="Notifications">


            <svg
                viewBox="0 0 24 24"
                fill="none">

                <path
                    d="M18 8A6 6 0 0 0 6 8C6 15 3 16 3 16H21C21 16 18 15 18 8Z"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linejoin="round"/>

                <path
                    d="M10 20H14"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"/>

            </svg>


        </a>



        <!-- PROFILE -->

        <a
            href="<%= ctx %>/entrepreneur/profile"
            class="profile-button">


            <div class="profile-avatar">

                <%= avatarLetter %>

            </div>


            <div class="profile-info">

                <div class="profile-name">

                    <%= userName %>

                </div>


                <div class="profile-role">

                    Entrepreneur

                </div>

            </div>


            <div class="profile-arrow">

                ›

            </div>


        </a>



        <!-- LOGOUT -->

        <a
            href="<%= ctx %>/logout"
            class="logout-button"
            title="Logout">


            <svg
                viewBox="0 0 24 24"
                fill="none">

                <path
                    d="M10 4H5V20H10"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"/>

                <path
                    d="M14 8L18 12L14 16"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"/>

                <path
                    d="M18 12H9"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"/>

            </svg>


            <span>
                Logout
            </span>


        </a>


    </div>


</header>



<!-- =========================================================
     PAGE
========================================================= -->

<div class="page">

<div class="container">



    <!-- =====================================================
         HERO
    ====================================================== -->

    <section class="hero">


        <div class="hero-content">


            <div class="welcome-badge">

                ✦ ENTREPRENEUR WORKSPACE

            </div>


            <h1>

                Welcome back,
                <span>
                    <%= userName %>
                </span>
                👋

            </h1>


            <p>

                From your business profile to regulatory approvals,
                reusable documents, government review, inspections
                and future compliance — CHAPERON keeps your complete
                approval journey organised in one intelligent workspace.

            </p>


        </div>



        <div class="hero-visual">


            <div class="hero-circle"></div>


            <div class="hero-building">


                <div class="building-icon">


                    <svg
                        viewBox="0 0 24 24"
                        fill="none">

                        <path
                            d="M3 21H21"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"/>

                        <path
                            d="M5 21V10H19V21"
                            stroke="currentColor"
                            stroke-width="2"/>

                        <path
                            d="M3 10L12 4L21 10H3Z"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linejoin="round"/>

                        <path
                            d="M8 13V18M12 13V18M16 13V18"
                            stroke="currentColor"
                            stroke-width="2"/>

                    </svg>


                </div>


                <strong>
                    One Intelligent Journey
                </strong>


                <span>
                    Business → Approval → Compliance
                </span>


            </div>


        </div>


    </section>



    <!-- =====================================================
         WORKSPACE TITLE
    ====================================================== -->

    <section class="section-title">


        <div class="section-eyebrow">

            YOUR BUSINESS JOURNEY

        </div>


        <h2>
            Your Workspace
        </h2>


        <p>

            Complete each stage of your industrial approval
            journey with guided CHAPERON assistance.

        </p>


    </section>



    <!-- =====================================================
         DASHBOARD CARDS
    ====================================================== -->

    <section class="dashboard-grid">



        <!-- =================================================
             1 BUSINESS PROFILE
        ================================================== -->

        <article class="dashboard-card business-card">


            <div class="card-top">


                <div class="icon-box">


                    <svg
                        viewBox="0 0 24 24"
                        fill="none">

                        <path
                            d="M4 21V8L12 3L20 8V21"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linejoin="round"/>

                        <path
                            d="M9 21V14H15V21"
                            stroke="currentColor"
                            stroke-width="2"/>

                        <path
                            d="M8 10H10M14 10H16"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"/>

                    </svg>


                </div>


                <div class="step-number">
                    01
                </div>


            </div>


            <h3>
                Business Profile
            </h3>


            <p>

                Review or update the business information
                CHAPERON uses to understand your industry,
                project stage, location and compliance needs
                before generating personalised approvals.

            </p>


            <a
                class="primary-btn"
                href="<%= ctx %>/entrepreneur/business-onboarding">

                View / Update Business →

            </a>


        </article>



        <!-- =================================================
             2 APPROVAL ROADMAP
        ================================================== -->

        <article class="dashboard-card approval-card">


            <div class="card-top">


                <div class="icon-box">


                    <svg
                        viewBox="0 0 24 24"
                        fill="none">

                        <circle
                            cx="5"
                            cy="6"
                            r="2"
                            stroke="currentColor"
                            stroke-width="2"/>

                        <circle
                            cx="19"
                            cy="18"
                            r="2"
                            stroke="currentColor"
                            stroke-width="2"/>

                        <path
                            d="M7 6H15C17.2 6 19 7.8 19 10V11"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"/>

                        <path
                            d="M17 18H9C6.8 18 5 16.2 5 14V13"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"/>

                    </svg>


                </div>


                <div class="step-number">
                    02
                </div>


            </div>


            <h3>
                Approval Roadmap
            </h3>


            <p>

                View approvals recommended for your business
                based on industry, project stage, location
                and applicable regulatory requirements.

            </p>


            <a
                class="primary-btn"
                href="<%= ctx %>/entrepreneur/generate-approvals">

                View Approval Roadmap →

            </a>


        </article>



        <!-- =================================================
             3 DOCUMENT VAULT
        ================================================== -->

        <article class="dashboard-card document-card">


            <div class="card-top">


                <div class="icon-box">


                    <svg
                        viewBox="0 0 24 24"
                        fill="none">

                        <path
                            d="M6 2H14L19 7V22H6Z"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linejoin="round"/>

                        <path
                            d="M14 2V7H19"
                            stroke="currentColor"
                            stroke-width="2"/>

                        <path
                            d="M9 12H16M9 16H14"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"/>

                    </svg>


                </div>


                <div class="step-number">
                    03
                </div>


            </div>


            <h3>
                Document Vault
            </h3>


            <p>

                Upload and manage PAN, business registration,
                premises proof, layouts and other reusable
                documents required across multiple approvals.

            </p>


            <a
                class="primary-btn"
                href="<%= ctx %>/entrepreneur/documents">

                Open Document Vault →

            </a>


        </article>



        <!-- =================================================
             4 MY APPLICATIONS
        ================================================== -->

        <article class="dashboard-card application-card">


            <div class="card-top">


                <div class="icon-box">


                    <svg
                        viewBox="0 0 24 24"
                        fill="none">

                        <rect
                            x="4"
                            y="3"
                            width="16"
                            height="18"
                            rx="2"
                            stroke="currentColor"
                            stroke-width="2"/>

                        <path
                            d="M8 8H16M8 12H16M8 16H13"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"/>

                    </svg>


                </div>


                <div class="step-number">
                    04
                </div>


            </div>


            <h3>
                My Applications
            </h3>


            <p>

                Track draft and submitted applications,
                current status, SLA timelines, officer queries
                and expected completion dates.

            </p>


            <a
                class="primary-btn"
                href="<%= ctx %>/entrepreneur/my-applications">

                Track Applications →

            </a>


        </article>



        <!-- =================================================
             5 INSPECTIONS
        ================================================== -->

        <article class="dashboard-card inspection-card">


            <div class="card-top">


                <div class="icon-box">


                    <svg
                        viewBox="0 0 24 24"
                        fill="none">

                        <rect
                            x="3"
                            y="5"
                            width="18"
                            height="16"
                            rx="2"
                            stroke="currentColor"
                            stroke-width="2"/>

                        <path
                            d="M8 3V7M16 3V7M3 10H21"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"/>

                        <path
                            d="M8 14H11M8 17H15"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"/>

                    </svg>


                </div>


                <div class="step-number">
                    05
                </div>


            </div>


            <h3>
                Inspections
            </h3>


            <p>

                View scheduled inspections, dates, locations,
                assigned officers, inspection notes,
                recommendations and final inspection results.

            </p>


            <a
                class="primary-btn"
                href="<%= ctx %>/entrepreneur/inspections">

                View Inspections →

            </a>


        </article>



        <!-- =================================================
             6 GOVERNMENT SCHEMES
        ================================================== -->

        <article class="dashboard-card scheme-card">


            <div class="card-top">


                <div class="icon-box">


                    <svg
                        viewBox="0 0 24 24"
                        fill="none">

                        <path
                            d="M12 3L20 7L12 11L4 7L12 3Z"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linejoin="round"/>

                        <path
                            d="M5 10V16L12 20L19 16V10"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linejoin="round"/>

                    </svg>


                </div>


                <div class="step-number">
                    06
                </div>


            </div>


            <h3>
                Government Schemes
            </h3>


            <p>

                Explore government schemes, incentives and
                support programmes with eligibility information,
                benefits, deadlines and official guidance.

            </p>


            <a
                class="primary-btn"
                href="<%= ctx %>/entrepreneur/schemes">

                Explore Schemes →

            </a>


        </article>



        <!-- =================================================
             7 COMPLIANCE
        ================================================== -->

        <article class="dashboard-card compliance-card">


            <div class="card-top">


                <div class="icon-box">


                    <svg
                        viewBox="0 0 24 24"
                        fill="none">

                        <path
                            d="M12 3L20 6V11C20 16 17.1 19.8 12 22C6.9 19.8 4 16 4 11V6L12 3Z"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linejoin="round"/>

                        <path
                            d="M8.5 12L11 14.5L16 9.5"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"/>

                    </svg>


                </div>


                <div class="step-number">
                    07
                </div>


            </div>


            <h3>
                Compliance & Renewals
            </h3>


            <p>

                Monitor approved licences, certificate validity,
                expiry dates, compliance requirements and
                upcoming renewal obligations.

            </p>


            <a
                class="primary-btn"
                href="<%= ctx %>/entrepreneur/compliance">

                View Compliance →

            </a>


        </article>



        <!-- =================================================
             8 NOTIFICATIONS
        ================================================== -->

        <article class="dashboard-card notification-card">


            <div class="card-top">


                <div class="icon-box">


                    <svg
                        viewBox="0 0 24 24"
                        fill="none">

                        <path
                            d="M18 8A6 6 0 0 0 6 8C6 15 3 16 3 16H21C21 16 18 15 18 8Z"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linejoin="round"/>

                        <path
                            d="M10 20H14"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"/>

                    </svg>


                </div>


                <div class="step-number">
                    08
                </div>


            </div>


            <h3>
                Notifications
            </h3>


            <p>

                View important updates about officer queries,
                inspections, application decisions,
                compliance requirements and renewal reminders.

            </p>


            <a
                class="primary-btn"
                href="<%= ctx %>/entrepreneur/notifications">

                Open Notifications →

            </a>


        </article>


    </section>



    <!-- =====================================================
         HOW CHAPERON WORKS
    ====================================================== -->

    <section class="quick-info">


        <div class="quick-info-heading">
            How CHAPERON Works
        </div>


        <div class="quick-info-copy">

            Your complete approval lifecycle is organised
            into one guided journey.

        </div>


        <div class="flow">


            <!-- NORMAL - NO HIGHLIGHT -->

            <span class="flow-step">
                1. Business Profile
            </span>

            <span class="flow-arrow">
                →
            </span>


            <span class="flow-step">
                2. Approval Roadmap
            </span>

            <span class="flow-arrow">
                →
            </span>


            <span class="flow-step">
                3. Document Readiness
            </span>

            <span class="flow-arrow">
                →
            </span>


            <span class="flow-step">
                4. Start Application
            </span>

            <span class="flow-arrow">
                →
            </span>


            <span class="flow-step">
                Submit
            </span>

            <span class="flow-arrow">
                →
            </span>


            <span class="flow-step">
                Officer Review
            </span>

            <span class="flow-arrow">
                →
            </span>


            <span class="flow-step">
                Inspection
            </span>

            <span class="flow-arrow">
                →
            </span>


            <span class="flow-step">
                Approval
            </span>

            <span class="flow-arrow">
                →
            </span>


            <span class="flow-step">
                Compliance & Renewal
            </span>


        </div>


    </section>



    <!-- =====================================================
         FOOTER
    ====================================================== -->

    <footer class="trust-footer">


        <svg
            viewBox="0 0 24 24"
            fill="none">

            <path
                d="M12 3L20 6V11C20 16 17.1 19.8 12 22C6.9 19.8 4 16 4 11V6L12 3Z"
                stroke="currentColor"
                stroke-width="2"/>

            <path
                d="M8.5 12L11 14.5L16 9.5"
                stroke="currentColor"
                stroke-width="2"/>

        </svg>


        Your business information is protected.
        CHAPERON provides a secure and transparent
        industrial approval journey.


    </footer>


</div>

</div>


</body>

</html>