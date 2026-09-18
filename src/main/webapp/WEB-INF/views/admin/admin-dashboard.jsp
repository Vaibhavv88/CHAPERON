<%@ page language="java"

         contentType="text/html; charset=UTF-8"

         pageEncoding="UTF-8" %>

<%

    String ctx = request.getContextPath();

    String userName =

            (String) session.getAttribute("userName");

    if (userName == null ||

        userName.isBlank()) {

        userName = "Administrator";

    }

    String avatarLetter = "A";

    if (userName != null &&

        !userName.isBlank()) {

        avatarLetter =

                userName

                        .substring(0, 1)

                        .toUpperCase();

    }



    Integer totalEntrepreneurs =

            (Integer) request.getAttribute(

                    "totalEntrepreneurs"

            );

    Integer totalOfficers =

            (Integer) request.getAttribute(

                    "totalOfficers"

            );

    Integer totalDepartments =

            (Integer) request.getAttribute(

                    "totalDepartments"

            );

    Integer totalApprovals =

            (Integer) request.getAttribute(

                    "totalApprovals"

            );

    Integer totalApplications =

            (Integer) request.getAttribute(

                    "totalApplications"

            );

    Integer pendingApplications =

            (Integer) request.getAttribute(

                    "pendingApplications"

            );

    Integer approvedApplications =

            (Integer) request.getAttribute(

                    "approvedApplications"

            );

    Integer rejectedApplications =

            (Integer) request.getAttribute(

                    "rejectedApplications"

            );



    if (totalEntrepreneurs == null) {

        totalEntrepreneurs = 0;

    }

    if (totalOfficers == null) {

        totalOfficers = 0;

    }

    if (totalDepartments == null) {

        totalDepartments = 0;

    }

    if (totalApprovals == null) {

        totalApprovals = 0;

    }

    if (totalApplications == null) {

        totalApplications = 0;

    }

    if (pendingApplications == null) {

        pendingApplications = 0;

    }

    if (approvedApplications == null) {

        approvedApplications = 0;

    }

    if (rejectedApplications == null) {

        rejectedApplications = 0;

    }



    int pendingPercentage =

            totalApplications > 0

                    ? pendingApplications

                      * 100

                      / totalApplications

                    : 0;



    int approvedPercentage =

            totalApplications > 0

                    ? approvedApplications

                      * 100

                      / totalApplications

                    : 0;



    int rejectedPercentage =

            totalApplications > 0

                    ? rejectedApplications

                      * 100

                      / totalApplications

                    : 0;

%>



<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"

      content="width=device-width, initial-scale=1.0">

<title>

    Admin Dashboard | CHAPERON

</title>



<style>

/* =========================================================

   RESET

\========================================================= */

* {

    margin: 0;

    padding: 0;

    box-sizing: border-box;

}



:root {

    --primary: #6750d8;

    --primary-dark: #5038b7;

    --primary-soft: #f1edff;

    --navy: #111d3d;

    --navy-two: #182747;

    --blue: #1677e8;

    --green: #22a36a;

    --orange: #ef9a26;

    --red: #db4c4c;

    --text: #17233c;

    --muted: #748196;

    --border: #e3e8ef;

    --page-bg: #f5f7fb;

    --white: #ffffff;

}



html {

    scroll-behavior: smooth;

}



body {

    margin: 0;

    min-height: 100vh;

    font-family:

        "Segoe UI",

        Arial,

        Helvetica,

        sans-serif;

    background:

        linear-gradient(

            145deg,

            #f5f6fc,

            #fafbff

        );

    color: var(--text);

}



a {

    text-decoration: none;

    color: inherit;

}





/* =========================================================

   LAYOUT

\========================================================= */

.layout {

    min-height: 100vh;

    display: flex;

}





/* =========================================================

   SIDEBAR

\========================================================= */

.sidebar {

    position: fixed;

    left: 0;

    top: 0;

    bottom: 0;

    width: 260px;

    padding:

        20px

        16px;

    display: flex;

    flex-direction: column;

    color: #ffffff;

    background:

        radial-gradient(

            circle at 10% 0%,

            rgba(

                128,

                91,

                255,

                0.24

            ),

            transparent 27%

        ),

        linear-gradient(

            180deg,

            #171d43,

            #101a36

        );

    box-shadow:

        8px 0 30px

        rgba(

            18,

            28,

            60,

            0.09

        );

    overflow-y: auto;

    z-index: 1000;

}





/* =========================================================

   BRAND

\========================================================= */

.brand {

    display: flex;

    align-items: center;

    gap: 10px;

    padding:

        4px

        8px

        19px;

    margin-bottom: 16px;

    border-bottom:

        1px solid

        rgba(

            255,

            255,

            255,

            0.12

        );

}



.brand-logo {

    position: relative;

    width: 49px;

    height: 49px;

    min-width: 49px;

    overflow: hidden;

    border-radius: 50%;

    background: #ffffff;

}



.brand-logo img {

    position: absolute;

    width: 88px;

    height: 88px;

    max-width: none;

    left: -19px;

    top: -6px;

    object-fit: cover;

}



.brand-name {

    font-size: 20px;

    font-weight: 900;

    letter-spacing: 0.3px;

}



.brand-subtitle {

    margin-top: 4px;

    color: #c2c8e7;

    font-size: 8px;

    font-weight: 700;

}





/* =========================================================

   MENU

\========================================================= */

.menu-title {

    padding:

        0

        12px;

    margin:

        17px

        0

        8px;

    color: #8995b9;

    font-size: 9px;

    font-weight: 850;

    letter-spacing: 1.1px;

}



.menu-item {

    min-height: 43px;

    display: flex;

    align-items: center;

    gap: 10px;

    padding:

        9px

        12px;

    margin-bottom: 4px;

    border-radius: 9px;

    color: #dbe1f5;

    font-size: 11px;

    font-weight: 700;

    transition:

        background 0.2s ease,

        transform 0.2s ease,

        color 0.2s ease;

}



.menu-item:hover {

    color: #ffffff;

    background:

        rgba(

            255,

            255,

            255,

            0.08

        );

    transform:

        translateX(2px);

}



.menu-item.active {

    color: #ffffff;

    background:

        linear-gradient(

            135deg,

            #7358e1,

            #5c43c4

        );

    box-shadow:

        0 8px 19px

        rgba(

            92,

            67,

            196,

            0.28

        );

}



.menu-icon {

    width: 25px;

    display: inline-flex;

    align-items: center;

    justify-content: center;

    font-size: 15px;

}





/* =========================================================

   SIDEBAR LOGOUT

\========================================================= */

.sidebar-logout {

    margin-top: auto;

    padding-top: 18px;

    border-top:

        1px solid

        rgba(

            255,

            255,

            255,

            0.12

        );

}



.sidebar-logout .menu-item {

    color: #ffc7c7;

    background:

        rgba(

            218,

            69,

            69,

            0.08

        );

}



.sidebar-logout .menu-item:hover {

    color: #ffffff;

    background: #c84343;

}





/* =========================================================

   MAIN

\========================================================= */

.main {

    width:

        calc(

            100%

            - 260px

        );

    min-height: 100vh;

    margin-left: 260px;

}





/* =========================================================

   TOPBAR

\========================================================= */

.topbar {

    position: sticky;

    top: 0;

    z-index: 500;

    min-height: 75px;

    padding:

        0

        30px;

    display: flex;

    align-items: center;

    justify-content: space-between;

    gap: 20px;

    background:

        rgba(

            255,

            255,

            255,

            0.94

        );

    border-bottom:

        1px solid #e3e8ef;

    backdrop-filter:

        blur(15px);

    box-shadow:

        0 5px 22px

        rgba(

            29,

            42,

            81,

            0.04

        );

}



.topbar-title {

    color: var(--navy);

    font-size: 17px;

    font-weight: 850;

}





/* =========================================================

   ADMIN TOP RIGHT

\========================================================= */

.topbar-right {

    display: flex;

    align-items: center;

    gap: 10px;

}



.admin-info {

    min-width: 185px;

    padding:

        5px

        10px

        5px

        5px;

    display: flex;

    align-items: center;

    gap: 10px;

    border:

        1px solid transparent;

    border-radius: 12px;

    transition:

        background 0.2s ease,

        border 0.2s ease;

}



.admin-info:hover {

    border-color: #e2def7;

    background: #f7f5ff;

}



.avatar {

    width: 41px;

    height: 41px;

    min-width: 41px;

    display: flex;

    align-items: center;

    justify-content: center;

    border-radius: 50%;

    color: #ffffff;

    background:

        linear-gradient(

            135deg,

            #7358e1,

            #9d87f7

        );

    box-shadow:

        0 6px 14px

        rgba(

            103,

            80,

            216,

            0.22

        );

    font-size: 13px;

    font-weight: 900;

}



.admin-name {

    font-size: 11px;

    font-weight: 850;

}



.admin-role {

    margin-top: 2px;

    color: #7c8799;

    font-size: 8px;

}





/* =========================================================

   TOP LOGOUT

\========================================================= */

.top-logout {

    min-height: 41px;

    padding:

        0

        13px;

    display: inline-flex;

    align-items: center;

    justify-content: center;

    gap: 7px;

    border:

        1px solid #f1d7d7;

    border-radius: 9px;

    color: #ba3e3e;

    background: #fff2f2;

    font-size: 9px;

    font-weight: 850;

    transition:

        transform 0.2s ease,

        color 0.2s ease,

        background 0.2s ease;

}



.top-logout svg {

    width: 16px;

    height: 16px;

}



.top-logout:hover {

    transform:

        translateY(-1px);

    color: #ffffff;

    background:

        linear-gradient(

            135deg,

            #db4c4c,

            #b93636

        );

}





/* =========================================================

   CONTENT

\========================================================= */

.content {

    padding:

        29px

        31px

        45px;

}





/* =========================================================

   WELCOME HERO

\========================================================= */

.welcome {

    position: relative;

    overflow: hidden;

    margin-bottom: 27px;

    padding:

        27px

        30px;

    border-radius: 18px;

    color: #ffffff;

    background:

        radial-gradient(

            circle at 90% 0%,

            rgba(

                174,

                150,

                255,

                0.30

            ),

            transparent 32%

        ),

        linear-gradient(

            130deg,

            #5138b1,

            #7255db

        );

    box-shadow:

        0 13px 30px

        rgba(

            84,

            59,

            180,

            0.18

        );

}



.welcome::after {

    content: "";

    position: absolute;

    width: 170px;

    height: 170px;

    right: -65px;

    bottom: -105px;

    border:

        25px solid

        rgba(

            255,

            255,

            255,

            0.06

        );

    border-radius: 50%;

}



.welcome-badge {

    position: relative;

    z-index: 2;

    width: max-content;

    margin-bottom: 8px;

    padding:

        5px

        9px;

    border:

        1px solid

        rgba(

            255,

            255,

            255,

            0.18

        );

    border-radius: 50px;

    color: #efeaff;

    background:

        rgba(

            255,

            255,

            255,

            0.08

        );

    font-size: 8px;

    font-weight: 800;

    letter-spacing: 0.7px;

}



.welcome h1 {

    position: relative;

    z-index: 2;

    margin: 0;

    font-size: 27px;

}



.welcome h1 span {

    color: #ddd4ff;

}



.welcome p {

    position: relative;

    z-index: 2;

    max-width: 780px;

    margin:

        8px

        0

        0;

    color: #eeeaff;

    font-size: 11px;

    line-height: 1.65;

}





/* =========================================================

   SECTION

\========================================================= */

.section {

    margin-bottom: 30px;

}



.section-heading {

    margin-bottom: 14px;

    display: flex;

    align-items: center;

    justify-content: space-between;

    gap: 15px;

}



.section-heading h2 {

    margin: 0;

    color: var(--navy);

    font-size: 18px;

}



.section-heading span {

    color: #7d899b;

    font-size: 10px;

}





/* =========================================================

   STATS

\========================================================= */

.stats-grid {

    display: grid;

    grid-template-columns:

        repeat(

            4,

            minmax(0, 1fr)

        );

    gap: 16px;

}



.stat-card {

    min-height: 135px;

    padding: 20px;

    border:

        1px solid var(--border);

    border-radius: 14px;

    background: #ffffff;

    box-shadow:

        0 7px 20px

        rgba(

            31,

            57,

            91,

            0.04

        );

    transition:

        transform 0.2s ease,

        box-shadow 0.2s ease;

}



.stat-card:hover {

    transform:

        translateY(-3px);

    box-shadow:

        0 12px 27px

        rgba(

            31,

            57,

            91,

            0.08

        );

}



.stat-header {

    display: flex;

    align-items: flex-start;

    justify-content: space-between;

    gap: 10px;

}



.stat-label {

    color: #6f7c8e;

    font-size: 10px;

    font-weight: 750;

}



.stat-icon {

    width: 41px;

    height: 41px;

    display: flex;

    align-items: center;

    justify-content: center;

    border-radius: 11px;

    color: #654dd1;

    background: #f0edff;

    font-size: 18px;

}



.stat-number {

    margin-top: 16px;

    color: var(--navy);

    font-size: 27px;

    font-weight: 900;

}



.stat-note {

    margin-top: 4px;

    color: #8a95a5;

    font-size: 9px;

}





/* =========================================================

   APPLICATION STATUS

\========================================================= */

.application-grid {

    display: grid;

    grid-template-columns:

        repeat(

            4,

            minmax(0, 1fr)

        );

    gap: 16px;

}



.application-card {

    padding: 19px;

    border:

        1px solid var(--border);

    border-radius: 13px;

    background: #ffffff;

}



.application-label {

    color: #6d7989;

    font-size: 10px;

    font-weight: 750;

}



.application-number {

    margin-top: 10px;

    color: var(--navy);

    font-size: 25px;

    font-weight: 900;

}



.status-bar {

    width: 100%;

    height: 6px;

    margin-top: 14px;

    overflow: hidden;

    border-radius: 20px;

    background: #edf0f4;

}



.status-fill {

    height: 100%;

    border-radius: 20px;

    background: #6750d8;

}



.pending .status-fill {

    background: #f0a020;

}



.approved .status-fill {

    background: #24a36a;

}



.rejected .status-fill {

    background: #db4c4c;

}





/* =========================================================

   MANAGEMENT

\========================================================= */

.management-grid {

    display: grid;

    grid-template-columns:

        repeat(

            3,

            minmax(0, 1fr)

        );

    gap: 16px;

}



.management-card {

    min-height: 205px;

    padding: 21px;

    display: flex;

    flex-direction: column;

    border:

        1px solid var(--border);

    border-radius: 14px;

    color: var(--text);

    background: #ffffff;

    box-shadow:

        0 7px 21px

        rgba(

            31,

            57,

            91,

            0.035

        );

    transition:

        transform 0.2s ease,

        border 0.2s ease,

        box-shadow 0.2s ease;

}



.management-card:hover {

    transform:

        translateY(-3px);

    border-color: #cfc5f7;

    box-shadow:

        0 13px 27px

        rgba(

            80,

            59,

            161,

            0.09

        );

}



.management-icon {

    width: 45px;

    height: 45px;

    margin-bottom: 14px;

    display: flex;

    align-items: center;

    justify-content: center;

    border-radius: 11px;

    color: #654dd1;

    background: #f0edff;

    font-size: 20px;

}



.management-title {

    color: var(--navy);

    font-size: 14px;

    font-weight: 900;

}



.management-description {

    margin-top: 7px;

    flex: 1;

    color: #758195;

    font-size: 10px;

    line-height: 1.6;

}



.manage-link {

    display: inline-block;

    margin-top: 14px;

    color: #6750d8;

    font-size: 10px;

    font-weight: 850;

}





/* =========================================================

   SYSTEM BOX

\========================================================= */

.system-box {

    position: relative;

    overflow: hidden;

    padding:

        22px

        24px;

    display: flex;

    align-items: center;

    justify-content: space-between;

    gap: 20px;

    border-radius: 15px;

    color: #ffffff;

    background:

        linear-gradient(

            130deg,

            #171d43,

            #26215c

        );

}



.system-box h3 {

    margin:

        0

        0

        7px;

    font-size: 15px;

}



.system-box p {

    margin: 0;

    color: #c9cce2;

    font-size: 10px;

    line-height: 1.6;

}



.system-badge {

    padding:

        9px

        14px;

    border:

        1px solid

        rgba(

            255,

            255,

            255,

            0.12

        );

    border-radius: 30px;

    color: #dff9ea;

    background:

        rgba(

            35,

            180,

            104,

            0.14

        );

    font-size: 9px;

    font-weight: 850;

    white-space: nowrap;

}





/* =========================================================

   RESPONSIVE

\========================================================= */

@media(max-width: 1150px) {

    .stats-grid,

    .application-grid {

        grid-template-columns:

            repeat(

                2,

                minmax(0, 1fr)

            );

    }



    .management-grid {

        grid-template-columns:

            repeat(

                2,

                minmax(0, 1fr)

            );

    }

}



@media(max-width: 850px) {

    .sidebar {

        display: none;

    }



    .main {

        width: 100%;

        margin-left: 0;

    }



    .content {

        padding:

            22px

            16px

            40px;

    }



    .topbar {

        padding:

            10px

            16px;

    }



    .topbar-title {

        font-size: 14px;

    }



    .admin-info {

        min-width: 0;

    }



    .admin-info > div:last-child {

        display: none;

    }



    .top-logout span {

        display: none;

    }



    .top-logout {

        width: 41px;

        padding: 0;

    }

}



@media(max-width: 600px) {

    .stats-grid,

    .application-grid,

    .management-grid {

        grid-template-columns:

            1fr;

    }



    .welcome {

        padding:

            23px

            20px;

    }



    .welcome h1 {

        font-size: 23px;

    }



    .section-heading {

        align-items: flex-start;

        flex-direction: column;

    }



    .system-box {

        align-items: flex-start;

        flex-direction: column;

    }

}

</style>

</head>



<body>



<div class="layout">



<!-- =========================================================

     SIDEBAR

\========================================================= -->

<aside class="sidebar">



    <!-- BRAND -->

    <a

        href="<%= ctx %>/admin/dashboard"

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

            <div class="brand-subtitle">

                Administration Portal

            </div>

        </div>



    </a>





    <!-- OVERVIEW -->

    <div class="menu-title">

        OVERVIEW

    </div>



    <a

        class="menu-item active"

        href="<%= ctx %>/admin/dashboard">

        <span class="menu-icon">

            ▦

        </span>

        Dashboard

    </a>





    <!-- MANAGEMENT -->

    <div class="menu-title">

        MANAGEMENT

    </div>



    <a

        class="menu-item"

        href="<%= ctx %>/admin/departments">

        <span class="menu-icon">

            🏢

        </span>

        Departments

    </a>



    <a

        class="menu-item"

        href="<%= ctx %>/admin/officers">

        <span class="menu-icon">

            👤

        </span>

        Officers

    </a>



    <a

        class="menu-item"

        href="<%= ctx %>/admin/approvals">

        <span class="menu-icon">

            ✓

        </span>

        Approvals

    </a>



    <a

        class="menu-item"

        href="<%= ctx %>/admin/approval-rules">

        <span class="menu-icon">

            ⚙

        </span>

        Approval Rules

    </a>



    <!-- GIS SPATIAL DATA -->

    <a

        class="menu-item"

        href="<%= ctx %>/admin/gis-layers">

        <span class="menu-icon">

            ⌖

        </span>

        GIS Layers

    </a>



    <a

        class="menu-item"

        href="<%= ctx %>/admin/schemes">

        <span class="menu-icon">

            ★

        </span>

        Government Schemes

    </a>





    <!-- MONITORING -->

    <div class="menu-title">

        MONITORING

    </div>



    <a

        class="menu-item"

        href="<%= ctx %>/admin/users">

        <span class="menu-icon">

            ♟

        </span>

        Entrepreneurs

    </a>



    <a

        class="menu-item"

        href="<%= ctx %>/admin/applications">

        <span class="menu-icon">

            ▤

        </span>

        Applications

    </a>



    <a

        class="menu-item"

        href="<%= ctx %>/admin/analytics">

        <span class="menu-icon">

            ▥

        </span>

        Analytics

    </a>





    <!-- SIDEBAR LOGOUT -->

    <div class="sidebar-logout">



        <a

            class="menu-item"

            href="<%= ctx %>/logout">

            <span class="menu-icon">

                ↪

            </span>

            Logout

        </a>



    </div>



</aside>





<!-- =========================================================

     MAIN

\========================================================= -->

<main class="main">



<!-- =========================================================

     TOPBAR

\========================================================= -->

<header class="topbar">



    <div class="topbar-title">

        Admin Dashboard

    </div>





    <div class="topbar-right">



        <!-- ADMIN PROFILE -->

        <div class="admin-info">



            <div class="avatar">

                <%= avatarLetter %>

            </div>



            <div>



                <div class="admin-name">

                    <%= userName %>

                </div>



                <div class="admin-role">

                    System Administrator

                </div>



            </div>



        </div>





        <!-- TOP RIGHT LOGOUT -->

        <a

            href="<%= ctx %>/logout"

            class="top-logout"

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

     CONTENT

\========================================================= -->

<div class="content">



<!-- =========================================================

     WELCOME

\========================================================= -->

<section class="welcome">



    <div class="welcome-badge">

        ✦ CHAPERON ADMINISTRATION

    </div>



    <h1>

        Welcome back,

        <span>

            <%= userName %>

        </span>

    </h1>



    <p>

        Monitor CHAPERON activity and manage departments,

        government officers, approvals, recommendation rules,

        entrepreneurs, applications, analytics and government

        support services from one central administration workspace.

    </p>



</section>





<!-- =========================================================

     PLATFORM OVERVIEW

\========================================================= -->

<section class="section">



    <div class="section-heading">



        <h2>

            Platform Overview

        </h2>



        <span>

            Current system data

        </span>



    </div>





    <div class="stats-grid">



        <!-- ENTREPRENEURS -->

        <div class="stat-card">



            <div class="stat-header">



                <div class="stat-label">

                    Entrepreneurs

                </div>



                <div class="stat-icon">

                    👥

                </div>



            </div>



            <div class="stat-number">

                <%= totalEntrepreneurs %>

            </div>



            <div class="stat-note">

                Registered entrepreneur accounts

            </div>



        </div>





        <!-- OFFICERS -->

        <div class="stat-card">



            <div class="stat-header">



                <div class="stat-label">

                    Government Officers

                </div>



                <div class="stat-icon">

                    👤

                </div>



            </div>



            <div class="stat-number">

                <%= totalOfficers %>

            </div>



            <div class="stat-note">

                Officer accounts in the system

            </div>



        </div>





        <!-- DEPARTMENTS -->

        <div class="stat-card">



            <div class="stat-header">



                <div class="stat-label">

                    Departments

                </div>



                <div class="stat-icon">

                    🏢

                </div>



            </div>



            <div class="stat-number">

                <%= totalDepartments %>

            </div>



            <div class="stat-note">

                Government departments configured

            </div>



        </div>





        <!-- APPROVALS -->

        <div class="stat-card">



            <div class="stat-header">



                <div class="stat-label">

                    Active Approvals

                </div>



                <div class="stat-icon">

                    ✓

                </div>



            </div>



            <div class="stat-number">

                <%= totalApprovals %>

            </div>



            <div class="stat-note">

                Approval types currently active

            </div>



        </div>



    </div>



</section>





<!-- =========================================================

     APPLICATION MONITORING

\========================================================= -->

<section class="section">



    <div class="section-heading">



        <h2>

            Application Monitoring

        </h2>



        <span>

            Overall application status

        </span>



    </div>





    <div class="application-grid">



        <!-- TOTAL -->

        <div class="application-card">



            <div class="application-label">

                Total Applications

            </div>



            <div class="application-number">

                <%= totalApplications %>

            </div>



            <div class="status-bar">

                <div

                    class="status-fill"

                    style="width:100%">

                </div>

            </div>



        </div>





        <!-- PENDING -->

        <div class="application-card pending">



            <div class="application-label">

                Pending / In Review

            </div>



            <div class="application-number">

                <%= pendingApplications %>

            </div>



            <div class="status-bar">

                <div

                    class="status-fill"

                    style="width:<%= pendingPercentage %>%">

                </div>

            </div>



        </div>





        <!-- APPROVED -->

        <div class="application-card approved">



            <div class="application-label">

                Approved

            </div>



            <div class="application-number">

                <%= approvedApplications %>

            </div>



            <div class="status-bar">

                <div

                    class="status-fill"

                    style="width:<%= approvedPercentage %>%">

                </div>

            </div>



        </div>





        <!-- REJECTED -->

        <div class="application-card rejected">



            <div class="application-label">

                Rejected

            </div>



            <div class="application-number">

                <%= rejectedApplications %>

            </div>



            <div class="status-bar">

                <div

                    class="status-fill"

                    style="width:<%= rejectedPercentage %>%">

                </div>

            </div>



        </div>



    </div>



</section>





<!-- =========================================================

     SYSTEM MANAGEMENT

\========================================================= -->

<section class="section">



    <div class="section-heading">



        <h2>

            System Management

        </h2>



        <span>

            Configure CHAPERON

        </span>



    </div>





    <div class="management-grid">



        <!-- DEPARTMENTS -->

        <a

            class="management-card"

            href="<%= ctx %>/admin/departments">



            <div class="management-icon">

                🏢

            </div>



            <div class="management-title">

                Departments

            </div>



            <div class="management-description">

                Manage government departments responsible

                for industrial approvals and compliance.

            </div>



            <span class="manage-link">

                Manage Departments →

            </span>



        </a>





        <!-- OFFICERS -->

        <a

            class="management-card"

            href="<%= ctx %>/admin/officers">



            <div class="management-icon">

                👤

            </div>



            <div class="management-title">

                Government Officers

            </div>



            <div class="management-description">

                Create officer accounts, assign departments

                and control officer access.

            </div>



            <span class="manage-link">

                Manage Officers →

            </span>



        </a>





        <!-- APPROVAL MASTER -->

        <a

            class="management-card"

            href="<%= ctx %>/admin/approvals">



            <div class="management-icon">

                ✓

            </div>



            <div class="management-title">

                Approval Master

            </div>



            <div class="management-description">

                Configure approvals, processing timelines,

                validity, renewals and inspections.

            </div>



            <span class="manage-link">

                Manage Approvals →

            </span>



        </a>





        <!-- RULES -->

        <a

            class="management-card"

            href="<%= ctx %>/admin/approval-rules">



            <div class="management-icon">

                ⚙

            </div>



            <div class="management-title">

                Recommendation Rules

            </div>



            <div class="management-description">

                Control database-driven rules used to

                recommend approvals for each business.

            </div>



            <span class="manage-link">

                Manage Rules →

            </span>



        </a>





        <!-- GIS LAYERS -->

        <a

            class="management-card"

            href="<%= ctx %>/admin/gis-layers">



            <div class="management-icon">

                ⌖

            </div>



            <div class="management-title">

                Official GIS Layers

            </div>



            <div class="management-description">

                Upload and manage official Forest, Protected Area,

                Eco-Sensitive Zone, CRZ and Settlement GeoJSON

                boundaries used for spatial screening.

            </div>



            <span class="manage-link">

                Manage GIS Layers →

            </span>



        </a>





        <!-- SCHEMES -->

        <a

            class="management-card"

            href="<%= ctx %>/admin/schemes">



            <div class="management-icon">

                ★

            </div>



            <div class="management-title">

                Government Schemes

            </div>



            <div class="management-description">

                Maintain government incentives, schemes

                and business support opportunities.

            </div>



            <span class="manage-link">

                Manage Schemes →

            </span>



        </a>





        <!-- APPLICATIONS -->

        <a

            class="management-card"

            href="<%= ctx %>/admin/applications">



            <div class="management-icon">

                ▤

            </div>



            <div class="management-title">

                Application Monitoring

            </div>



            <div class="management-description">

                Monitor application movement, status,

                departments and approval outcomes.

            </div>



            <span class="manage-link">

                View Applications →

            </span>



        </a>





        <!-- ENTREPRENEURS -->

        <a

            class="management-card"

            href="<%= ctx %>/admin/users">



            <div class="management-icon">

                👥

            </div>



            <div class="management-title">

                Entrepreneurs

            </div>



            <div class="management-description">

                View registered entrepreneur accounts

                and monitor platform participation.

            </div>



            <span class="manage-link">

                View Entrepreneurs →

            </span>



        </a>





        <!-- ANALYTICS -->

        <a

            class="management-card"

            href="<%= ctx %>/admin/analytics">



            <div class="management-icon">

                ▥

            </div>



            <div class="management-title">

                Analytics

            </div>



            <div class="management-description">

                Monitor platform activity, approval outcomes

                and operational performance.

            </div>



            <span class="manage-link">

                View Analytics →

            </span>



        </a>



    </div>



</section>





<!-- =========================================================

     SYSTEM STATUS

\========================================================= -->

<section class="section">



    <div class="system-box">



        <div>



            <h3>

                CHAPERON Administration

            </h3>



            <p>

                Business Approval Navigator<br>

                Centralized approval and compliance

                management platform.

            </p>



        </div>





        <div class="system-badge">

            ● SYSTEM ACTIVE

        </div>



    </div>



</section>



</div>



</main>



</div>



</body>

</html>
