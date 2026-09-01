<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%

    String ctx = request.getContextPath();

%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>CHAPERON - Business Approval Navigator</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">

    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"

          rel="stylesheet">

    <style>

        /* =========================================================

           CHAPERON GLOBAL RESET

        \========================================================= */

        * {

            margin: 0;

            padding: 0;

            box-sizing: border-box;

        }

        html {

            scroll-behavior: smooth;

        }

        body {

            min-height: 100vh;

            font-family: 'Inter', Arial, sans-serif;

            color: #06143b;

            overflow-x: hidden;

            background:

                radial-gradient(circle at 84% 20%,

                    rgba(80, 157, 255, 0.12),

                    transparent 25%),

                radial-gradient(circle at 10% 90%,

                    rgba(0, 198, 255, 0.13),

                    transparent 27%),

                linear-gradient(

                    135deg,

                    #ffffff 0%,

                    #f7fbff 40%,

                    #edf6ff 100%

                );

        }



        /* =========================================================

           PAGE WRAPPER

        \========================================================= */

        .page {

            position: relative;

            min-height: 100vh;

            overflow: hidden;

            isolation: isolate;

        }



        /* =========================================================

           BACKGROUND DECORATION

        \========================================================= */

        .page::before {

            content: "";

            position: absolute;

            width: 700px;

            height: 700px;

            border-radius: 50%;

            left: -420px;

            bottom: -280px;

            background:

                linear-gradient(

                    135deg,

                    rgba(0, 194, 255, 0.12),

                    rgba(0, 102, 255, 0.02)

                );

            z-index: -2;

        }

        .page::after {

            content: "";

            position: absolute;

            width: 650px;

            height: 650px;

            border-radius: 50%;

            right: -360px;

            bottom: -200px;

            border: 1px solid rgba(24, 108, 255, 0.10);

            z-index: -2;

        }



        .wave-left {

            position: absolute;

            width: 600px;

            height: 300px;

            left: -160px;

            bottom: -130px;

            border-radius: 50%;

            border:

                1px solid rgba(0, 160, 255, 0.13);

            transform: rotate(10deg);

            z-index: -1;

        }



        .wave-right {

            position: absolute;

            width: 550px;

            height: 300px;

            right: -160px;

            top: 250px;

            border-radius: 50%;

            border:

                1px solid rgba(22, 95, 255, 0.10);

            transform: rotate(-15deg);

            z-index: -1;

        }



        /* =========================================================

           DOT PATTERN

        \========================================================= */

        .dots {

            position: absolute;

            width: 90px;

            height: 90px;

            opacity: 0.4;

            background-image:

                radial-gradient(

                    #75b8ff 2px,

                    transparent 2px

                );

            background-size: 14px 14px;

            z-index: -1;

        }

        .dots.one {

            top: 105px;

            right: 8%;

        }

        .dots.two {

            top: 300px;

            left: 4%;

        }

        .dots.three {

            right: 2%;

            bottom: 185px;

        }



        /* =========================================================

           HEADER

        \========================================================= */

        .top-header {

            width: 100%;

            display: flex;

            align-items: center;

            padding: 28px 5% 5px;

        }



        .brand {

            display: flex;

            align-items: center;

            gap: 13px;

        }



        .brand-symbol {

            width: 66px;

            height: 66px;

            border-radius: 50%;

            display: flex;

            align-items: center;

            justify-content: center;

            background: #ffffff;

            box-shadow:

                0 10px 25px rgba(12, 91, 228, 0.20);

            position: relative;

            overflow: hidden;

        }



        .brand-symbol img {

            width: 100%;

            height: 100%;

            object-fit: cover;

            display: block;

        }



        .brand-text h1 {

            color: #0a4ddd;

            font-size: 31px;

            letter-spacing: 0.5px;

            line-height: 1;

            font-weight: 800;

        }



        .brand-text span {

            display: block;

            color: #1558e8;

            margin-top: 7px;

            font-size: 8px;

            font-weight: 800;

            letter-spacing: 0.6px;

        }



        /* =========================================================

           MAIN CONTENT

        \========================================================= */

        .container {

            width: min(1220px, 91%);

            margin: auto;

            padding-bottom: 35px;

        }



        /* =========================================================

           HERO

        \========================================================= */

        .hero {

            position: relative;

            text-align: center;

            margin-top: 4px;

        }



        .sparkles {

            position: absolute;

            left: 17%;

            top: 10px;

            width: 65px;

            height: 65px;

        }



        .sparkle {

            position: absolute;

            width: 12px;

            height: 12px;

            transform: rotate(45deg);

        }



        .sparkle.blue {

            background: #0e62ff;

            top: 10px;

            left: 25px;

        }

        .sparkle.green {

            background: #11a851;

            top: 40px;

            left: 40px;

            width: 10px;

            height: 10px;

        }

        .sparkle.small {

            background: #173ad8;

            top: 30px;

            left: 5px;

            width: 8px;

            height: 8px;

        }



        .hero h2 {

            font-size: clamp(34px, 4vw, 58px);

            line-height: 1.12;

            letter-spacing: -2px;

            color: #07143e;

            font-weight: 800;

        }



        .hero h2 span {

            color: #0d55e7;

        }



        .hero-subtitle {

            margin-top: 12px;

            color: #435681;

            font-size: 18px;

            font-weight: 500;

        }



        .hero-description {

            max-width: 820px;

            margin: 16px auto 0;

            color: #41527b;

            font-size: 15px;

            line-height: 1.75;

            font-weight: 500;

        }



        /* =========================================================

           WHO ARE YOU TITLE

        \========================================================= */

        .roles-heading {

            text-align: center;

            margin-top: 25px;

            margin-bottom: 23px;

        }



        .roles-heading h3 {

            font-size: 28px;

            color: #09153d;

            font-weight: 800;

        }



        .heading-line {

            width: 58px;

            height: 4px;

            background: #0b61ff;

            border-radius: 100px;

            margin: 8px auto 0;

        }



        /* =========================================================

           ROLE GRID

        \========================================================= */

        .roles-grid {

            display: grid;

            grid-template-columns:

                repeat(3, 1fr);

            gap: 38px;

        }



        .role-card {

            min-height: 430px;

            position: relative;

            overflow: hidden;

            display: flex;

            flex-direction: column;

            align-items: center;

            padding: 18px 18px 18px;

            border-radius: 27px;

            background:

                linear-gradient(

                    155deg,

                    rgba(255, 255, 255, 0.95),

                    rgba(248, 252, 255, 0.92)

                );

            border:

                1px solid rgba(60, 126, 255, 0.16);

            box-shadow:

                0 16px 40px rgba(30, 82, 145, 0.10);

            transition:

                transform .30s ease,

                box-shadow .30s ease,

                border-color .30s ease;

        }



        .role-card:hover {

            transform: translateY(-7px);

            box-shadow:

                0 22px 48px rgba(30, 82, 145, 0.16);

        }



        .entrepreneur:hover {

            border-color:

                rgba(0, 91, 255, 0.38);

        }

        .officer:hover {

            border-color:

                rgba(0, 161, 78, 0.36);

        }

        .administrator:hover {

            border-color:

                rgba(88, 54, 229, 0.35);

        }



        /* =========================================================

           CARD ICON

        \========================================================= */

        .icon-circle {

            width: 78px;

            height: 78px;

            border-radius: 50%;

            display: flex;

            align-items: center;

            justify-content: center;

            margin-bottom: 15px;

            background: #f2f7ff;

        }



        .icon-circle svg {

            width: 39px;

            height: 39px;

        }



        .entrepreneur .icon-circle {

            color: #075bed;

            border:

                1px solid rgba(0, 96, 255, 0.18);

            background:

                linear-gradient(

                    135deg,

                    #f6faff,

                    #eaf3ff

                );

        }



        .officer .icon-circle {

            color: #069b48;

            border:

                1px solid rgba(0, 160, 70, 0.17);

            background:

                linear-gradient(

                    135deg,

                    #f5fff9,

                    #e7f9ef

                );

        }



        .administrator .icon-circle {

            color: #5132dc;

            border:

                1px solid rgba(80, 50, 220, 0.18);

            background:

                linear-gradient(

                    135deg,

                    #faf8ff,

                    #f0edff

                );

        }



        /* =========================================================

           CARD TEXT

        \========================================================= */

        .role-card h4 {

            font-size: 20px;

            color: #071238;

            font-weight: 800;

            text-align: center;

        }



        .role-underline {

            width: 58px;

            height: 3px;

            border-radius: 50px;

            margin: 13px 0 17px;

        }



        .entrepreneur .role-underline {

            background: #0865ff;

        }

        .officer .role-underline {

            background: #0aa44e;

        }

        .administrator .role-underline {

            background: #5534df;

        }



        .role-description {

            width: 93%;

            min-height: 94px;

            text-align: center;

            color: #1b2a54;

            font-size: 13px;

            line-height: 1.72;

            font-weight: 500;

        }



        /* =========================================================

           ILLUSTRATIONS

        \========================================================= */

        .illustration {

            width: 100%;

            height: 128px;

            margin-top: auto;

            display: flex;

            align-items: flex-end;

            justify-content: center;

            overflow: hidden;

        }



        .illustration svg {

            width: 100%;

            height: 100%;

        }



        /* =========================================================

           CTA BUTTONS

        \========================================================= */

        .role-button {

            width: 100%;

            min-height: 54px;

            margin-top: 5px;

            border-radius: 18px;

            text-decoration: none;

            display: flex;

            align-items: center;

            justify-content: space-between;

            padding: 0 12px 0 20px;

            color: #ffffff;

            font-size: 13px;

            font-weight: 700;

            box-shadow:

                0 12px 22px rgba(30, 75, 150, 0.16);

            transition:

                transform .25s ease,

                box-shadow .25s ease;

        }



        .role-button:hover {

            transform: translateY(-2px);

            box-shadow:

                0 16px 28px rgba(30, 75, 150, 0.25);

        }



        .role-button.blue {

            background:

                linear-gradient(

                    90deg,

                    #075ff0,

                    #004be2

                );

        }



        .role-button.green {

            background:

                linear-gradient(

                    90deg,

                    #0bad52,

                    #008f3f

                );

        }



        .role-button.purple {

            background:

                linear-gradient(

                    90deg,

                    #5938ef,

                    #4326d5

                );

        }



        .arrow-circle {

            width: 35px;

            height: 35px;

            flex-shrink: 0;

            border-radius: 50%;

            background: #ffffff;

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 20px;

            font-weight: 800;

        }



        .blue .arrow-circle {

            color: #075ff0;

        }

        .green .arrow-circle {

            color: #079849;

        }

        .purple .arrow-circle {

            color: #4b2ddd;

        }



        /* =========================================================

           TRUST PANEL

        \========================================================= */

        .trust-panel {

            margin-top: 27px;

            min-height: 95px;

            padding: 18px 27px;

            display: grid;

            grid-template-columns:

                1fr 1fr 1fr 1.35fr;

            align-items: center;

            border-radius: 27px;

            background:

                rgba(255, 255, 255, 0.88);

            backdrop-filter:

                blur(14px);

            border:

                1px solid rgba(52, 117, 225, 0.12);

            box-shadow:

                0 18px 40px rgba(42, 94, 150, 0.09);

        }



        .trust-item {

            min-height: 54px;

            display: flex;

            align-items: center;

            gap: 13px;

            padding: 0 20px;

            border-right:

                1px solid #d8e3ef;

        }



        .trust-icon {

            width: 52px;

            height: 52px;

            flex-shrink: 0;

            border-radius: 50%;

            display: flex;

            align-items: center;

            justify-content: center;

        }



        .trust-icon svg {

            width: 26px;

            height: 26px;

        }



        .secure-icon {

            background: #075ef0;

            color: white;

        }



        .transparent-icon {

            background: #eafff1;

            color: #0ca44e;

            border:

                1px solid rgba(10, 164, 78, 0.16);

        }



        .efficient-icon {

            background:

                linear-gradient(

                    135deg,

                    #633cff,

                    #3421d6

                );

            color: white;

        }



        .trust-text strong {

            display: block;

            color: #07153c;

            font-size: 14px;

            margin-bottom: 4px;

        }



        .trust-text span {

            color: #42537a;

            font-size: 10px;

            line-height: 1.4;

        }



        .trust-brand {

            border-right: none;

            justify-content: space-between;

        }



        .trust-brand p {

            color: #273b68;

            font-size: 11px;

            line-height: 1.6;

            max-width: 255px;

        }



        .shield-light {

            width: 45px;

            height: 45px;

            opacity: .18;

        }



        /* =========================================================

           RESPONSIVE

        \========================================================= */

        @media (max-width: 1050px) {

            .roles-grid {

                gap: 20px;

            }

            .role-card {

                padding-left: 12px;

                padding-right: 12px;

            }

            .role-description {

                width: 100%;

            }

            .trust-panel {

                grid-template-columns:

                    repeat(2, 1fr);

                row-gap: 18px;

            }

            .trust-item:nth-child(2) {

                border-right: none;

            }

        }



        @media (max-width: 820px) {

            .top-header {

                padding-top: 20px;

            }

            .brand-symbol {

                width: 54px;

                height: 54px;

            }

            .brand-symbol svg {

                width: 34px;

                height: 34px;

            }

            .brand-text h1 {

                font-size: 25px;

            }

            .roles-grid {

                grid-template-columns: 1fr;

            }

            .role-card {

                max-width: 500px;

                width: 100%;

                margin: auto;

            }

            .sparkles {

                display: none;

            }

        }



        @media (max-width: 600px) {

            .container {

                width: 92%;

            }

            .hero h2 {

                font-size: 36px;

            }

            .hero-subtitle {

                font-size: 15px;

            }

            .hero-description {

                font-size: 13px;

            }

            .trust-panel {

                grid-template-columns: 1fr;

                padding: 10px 20px;

            }

            .trust-item {

                border-right: none;

                border-bottom:

                    1px solid #e1e9f2;

                padding: 14px 3px;

            }

            .trust-brand {

                border-bottom: none;

            }

        }

    </style>

</head>



<body>

<div class="page">

    <div class="dots one"></div>

    <div class="dots two"></div>

    <div class="dots three"></div>

    <div class="wave-left"></div>

    <div class="wave-right"></div>



    <!-- =====================================================

         CHAPERON HEADER

    \====================================================== -->

    <header class="top-header">

        <div class="brand">

            <div class="brand-symbol">

                <img src="<%=ctx%>/images/chaperon-logo.jpeg"
                     alt="CHAPERON Logo">

            </div>



            <div class="brand-text">

                <h1>CHAPERON</h1>

                <span>

                    GUIDE. CONNECT. COMPLY. GET APPROVED.

                </span>

            </div>

        </div>

    </header>





    <main class="container">



        <!-- =================================================

             HERO

        \================================================== -->

        <section class="hero">



            <div class="sparkles">

                <span class="sparkle blue"></span>

                <span class="sparkle small"></span>

                <span class="sparkle green"></span>

            </div>



            <h2>

                Welcome to

                <span>CHAPERON</span>

            </h2>



            <p class="hero-subtitle">

                From Business Idea to Approval —

                One Intelligent Journey

            </p>



            <p class="hero-description">

                A guided platform for entrepreneurs,

                government officers and administrators<br>

                to manage approvals, documents,

                applications, inspections and compliance

                in one place.

            </p>

        </section>





        <!-- =================================================

             ROLES TITLE

        \================================================== -->

        <section class="roles-heading">

            <h3>Who are you?</h3>

            <div class="heading-line"></div>

        </section>





        <!-- =================================================

             ROLE CARDS

        \================================================== -->

        <section class="roles-grid">



            <!-- =============================================

                 ENTREPRENEUR

            \============================================== -->

            <article class="role-card entrepreneur">



                <div class="icon-circle">

                    <svg viewBox="0 0 24 24"

                         fill="currentColor">

                        <circle cx="12"

                                cy="7.5"

                                r="4"/>

                        <path d="M4.5 21C4.7 15.9 7.4 13 12 13C16.6 13 19.3 15.9 19.5 21H4.5Z"/>

                    </svg>

                </div>



                <h4>

                    Entrepreneur / Investor

                </h4>



                <div class="role-underline"></div>



                <p class="role-description">

                    Start or manage a business,

                    discover required approvals,

                    upload documents, submit applications

                    and track your complete approval journey.

                </p>



                <div class="illustration">

                    <svg viewBox="0 0 420 160"

                         xmlns="http://www.w3.org/2000/svg">

                        <defs>

                            <linearGradient id="cityBlue"

                                            x1="0"

                                            x2="0"

                                            y1="0"

                                            y2="1">

                                <stop offset="0%"

                                      stop-color="#77AEFF"/>

                                <stop offset="100%"

                                      stop-color="#CDE3FF"/>

                            </linearGradient>

                        </defs>



                        <rect x="0"

                              y="145"

                              width="420"

                              height="15"

                              fill="#E6F2FF"/>



                        <ellipse cx="55"

                                 cy="55"

                                 rx="32"

                                 ry="12"

                                 fill="#DCEBFF"/>



                        <ellipse cx="320"

                                 cy="45"

                                 rx="36"

                                 ry="13"

                                 fill="#E5F0FF"/>



                        <rect x="40"

                              y="90"

                              width="65"

                              height="55"

                              rx="4"

                              fill="url(#cityBlue)"/>



                        <rect x="115"

                              y="62"

                              width="70"

                              height="83"

                              rx="4"

                              fill="#AACBFF"/>



                        <rect x="195"

                              y="82"

                              width="55"

                              height="63"

                              rx="4"

                              fill="#6FA8FA"/>



                        <rect x="260"

                              y="45"

                              width="70"

                              height="100"

                              rx="4"

                              fill="#8CB9FF"/>



                        <rect x="340"

                              y="74"

                              width="45"

                              height="71"

                              rx="4"

                              fill="#BBD6FF"/>



                        <g fill="#EEF6FF">

                            <rect x="51"

                                  y="101"

                                  width="9"

                                  height="9"/>

                            <rect x="69"

                                  y="101"

                                  width="9"

                                  height="9"/>

                            <rect x="87"

                                  y="101"

                                  width="9"

                                  height="9"/>

                            <rect x="130"

                                  y="78"

                                  width="10"

                                  height="10"/>

                            <rect x="150"

                                  y="78"

                                  width="10"

                                  height="10"/>

                            <rect x="130"

                                  y="98"

                                  width="10"

                                  height="10"/>

                            <rect x="150"

                                  y="98"

                                  width="10"

                                  height="10"/>

                            <rect x="276"

                                  y="60"

                                  width="11"

                                  height="11"/>

                            <rect x="299"

                                  y="60"

                                  width="11"

                                  height="11"/>

                            <rect x="276"

                                  y="84"

                                  width="11"

                                  height="11"/>

                            <rect x="299"

                                  y="84"

                                  width="11"

                                  height="11"/>

                        </g>



                        <g>

                            <rect x="15"

                                  y="120"

                                  width="5"

                                  height="25"

                                  fill="#248754"/>

                            <circle cx="17"

                                    cy="115"

                                    r="13"

                                    fill="#48C875"/>

                            <rect x="395"

                                  y="121"

                                  width="5"

                                  height="24"

                                  fill="#248754"/>

                            <circle cx="397"

                                    cy="115"

                                    r="13"

                                    fill="#48C875"/>

                        </g>

                    </svg>

                </div>



                <a class="role-button blue"

                   href="<%=ctx%>/entrepreneur-login">

                    <span>

                        Continue as Entrepreneur / Investor

                    </span>

                    <span class="arrow-circle">

                        →

                    </span>

                </a>

            </article>





            <!-- =============================================

                 GOVERNMENT OFFICER

            \============================================== -->

            <article class="role-card officer">



                <div class="icon-circle">

                    <svg viewBox="0 0 24 24"

                         fill="currentColor">

                        <path d="M12 2L3 7V9H21V7L12 2Z"/>

                        <rect x="5"

                              y="10"

                              width="2.5"

                              height="8"/>

                        <rect x="9.5"

                              y="10"

                              width="2.5"

                              height="8"/>

                        <rect x="14"

                              y="10"

                              width="2.5"

                              height="8"/>

                        <rect x="18.5"

                              y="10"

                              width="2"

                              height="8"/>

                        <rect x="3"

                              y="19"

                              width="18"

                              height="3"/>

                    </svg>

                </div>



                <h4>

                    Government Officer

                </h4>



                <div class="role-underline"></div>



                <p class="role-description">

                    Review assigned applications,

                    verify documents, raise queries,

                    schedule inspections and take final

                    approval or rejection decisions.

                </p>



                <div class="illustration">

                    <svg viewBox="0 0 420 160"

                         xmlns="http://www.w3.org/2000/svg">

                        <rect x="0"

                              y="145"

                              width="420"

                              height="15"

                              fill="#E4F7ED"/>



                        <path d="M125 83H295V145H125Z"

                              fill="#7CC2F5"/>



                        <path d="M112 83L210 35L308 83Z"

                              fill="#56A9EB"/>



                        <path d="M150 73C150 39 177 17 210 17C243 17 270 39 270 73Z"

                              fill="#7DBDF0"/>



                        <path d="M160 73C160 46 182 28 210 28C238 28 260 46 260 73Z"

                              fill="#A4D4F7"/>



                        <rect x="202"

                              y="5"

                              width="16"

                              height="20"

                              fill="#438DCF"/>



                        <g fill="#E9F7FF">

                            <rect x="143"

                                  y="92"

                                  width="18"

                                  height="53"/>

                            <rect x="177"

                                  y="92"

                                  width="18"

                                  height="53"/>

                            <rect x="211"

                                  y="92"

                                  width="18"

                                  height="53"/>

                            <rect x="245"

                                  y="92"

                                  width="18"

                                  height="53"/>

                            <rect x="279"

                                  y="92"

                                  width="18"

                                  height="53"/>

                        </g>



                        <rect x="103"

                              y="82"

                              width="214"

                              height="11"

                              rx="3"

                              fill="#D1EFFF"/>



                        <rect x="104"

                              y="138"

                              width="212"

                              height="7"

                              fill="#429EE1"/>



                        <g>

                            <rect x="50"

                                  y="116"

                                  width="5"

                                  height="29"

                                  fill="#317747"/>

                            <circle cx="52"

                                    cy="108"

                                    r="16"

                                    fill="#54C86A"/>



                            <rect x="365"

                                  y="115"

                                  width="5"

                                  height="30"

                                  fill="#317747"/>

                            <circle cx="367"

                                    cy="108"

                                    r="16"

                                    fill="#54C86A"/>

                        </g>



                        <ellipse cx="83"

                                 cy="50"

                                 rx="29"

                                 ry="11"

                                 fill="#E1EFFF"/>



                        <ellipse cx="336"

                                 cy="55"

                                 rx="34"

                                 ry="11"

                                 fill="#E1EFFF"/>

                    </svg>

                </div>



                <a class="role-button green"

                   href="<%=ctx%>/officer-login">

                    <span>

                        Continue as Government Officer

                    </span>

                    <span class="arrow-circle">

                        →

                    </span>

                </a>

            </article>





            <!-- =============================================

                 ADMIN

            \============================================== -->

            <article class="role-card administrator">



                <div class="icon-circle">

                    <svg viewBox="0 0 24 24"

                         fill="currentColor">

                        <path d="M10.3 2H13.7L14.2 4.2C14.8 4.4 15.4 4.6 15.9 4.9L17.8 3.7L20.3 6.2L19.1 8.1C19.4 8.6 19.6 9.2 19.8 9.8L22 10.3V13.7L19.8 14.2C19.6 14.8 19.4 15.4 19.1 15.9L20.3 17.8L17.8 20.3L15.9 19.1C15.4 19.4 14.8 19.6 14.2 19.8L13.7 22H10.3L9.8 19.8C9.2 19.6 8.6 19.4 8.1 19.1L6.2 20.3L3.7 17.8L4.9 15.9C4.6 15.4 4.4 14.8 4.2 14.2L2 13.7V10.3L4.2 9.8C4.4 9.2 4.6 8.6 4.9 8.1L3.7 6.2L6.2 3.7L8.1 4.9C8.6 4.6 9.2 4.4 9.8 4.2L10.3 2Z"/>

                        <circle cx="12"

                                cy="12"

                                r="3.6"

                                fill="white"/>

                    </svg>

                </div>



                <h4>

                    Administrator

                </h4>



                <div class="role-underline"></div>



                <p class="role-description">

                    Manage users, departments,

                    approval rules, officers, timelines,

                    validity, schemes and platform analytics.

                </p>



                <div class="illustration">

                    <svg viewBox="0 0 420 160"

                         xmlns="http://www.w3.org/2000/svg">



                        <rect x="35"

                              y="50"

                              width="155"

                              height="89"

                              rx="12"

                              fill="#EFEAFF"/>



                        <rect x="45"

                              y="60"

                              width="135"

                              height="69"

                              rx="8"

                              fill="#FFFFFF"/>



                        <circle cx="88"

                                cy="93"

                                r="27"

                                fill="#6747ED"/>



                        <path d="M88 93L88 66A27 27 0 0 1 112 106Z"

                              fill="#A794FF"/>



                        <rect x="125"

                              y="74"

                              width="38"

                              height="7"

                              rx="3"

                              fill="#6953E9"/>



                        <rect x="125"

                              y="90"

                              width="27"

                              height="7"

                              rx="3"

                              fill="#8D7BF2"/>



                        <rect x="125"

                              y="106"

                              width="43"

                              height="7"

                              rx="3"

                              fill="#C0B7F8"/>





                        <rect x="210"

                              y="40"

                              width="175"

                              height="99"

                              rx="12"

                              fill="#E5DFFF"/>



                        <rect x="220"

                              y="51"

                              width="155"

                              height="78"

                              rx="7"

                              fill="#FFFFFF"/>



                        <rect x="220"

                              y="51"

                              width="155"

                              height="15"

                              rx="7"

                              fill="#5736E1"/>



                        <circle cx="231"

                                cy="58"

                                r="2.5"

                                fill="#FFFFFF"/>



                        <circle cx="240"

                                cy="58"

                                r="2.5"

                                fill="#FFFFFF"/>



                        <rect x="241"

                              y="103"

                              width="15"

                              height="18"

                              rx="2"

                              fill="#B4A8FF"/>



                        <rect x="263"

                              y="90"

                              width="15"

                              height="31"

                              rx="2"

                              fill="#907AF7"/>



                        <rect x="285"

                              y="74"

                              width="15"

                              height="47"

                              rx="2"

                              fill="#5D3BE7"/>



                        <rect x="307"

                              y="96"

                              width="15"

                              height="25"

                              rx="2"

                              fill="#8165F1"/>



                        <rect x="329"

                              y="83"

                              width="15"

                              height="38"

                              rx="2"

                              fill="#6747EC"/>



                        <rect x="238"

                              y="75"

                              width="102"

                              height="5"

                              rx="2"

                              fill="#E6E1F7"/>

                    </svg>

                </div>



                <a class="role-button purple"

                   href="<%=ctx%>/admin-login">

                    <span>

                        Continue as Administrator

                    </span>

                    <span class="arrow-circle">

                        →

                    </span>

                </a>

            </article>

        </section>





        <!-- =================================================

             TRUST PANEL

        \================================================== -->

        <section class="trust-panel">



            <!-- SECURE -->

            <div class="trust-item">

                <div class="trust-icon secure-icon">

                    <svg viewBox="0 0 24 24"

                         fill="currentColor">

                        <path d="M12 2L20 5V11C20 16.2 16.7 20.4 12 22C7.3 20.4 4 16.2 4 11V5L12 2Z"/>

                        <path d="M8.5 12L11 14.5L16 9.5"

                              fill="none"

                              stroke="white"

                              stroke-width="2"

                              stroke-linecap="round"

                              stroke-linejoin="round"/>

                    </svg>

                </div>



                <div class="trust-text">

                    <strong>Secure</strong>

                    <span>

                        Your data is protected

                    </span>

                </div>

            </div>





            <!-- TRANSPARENT -->

            <div class="trust-item">

                <div class="trust-icon transparent-icon">

                    <svg viewBox="0 0 24 24"

                         fill="currentColor">

                        <rect x="5"

                              y="10"

                              width="14"

                              height="11"

                              rx="2"/>

                        <path d="M8 10V7C8 4.8 9.8 3 12 3C14.2 3 16 4.8 16 7V10"

                              fill="none"

                              stroke="currentColor"

                              stroke-width="2"/>

                    </svg>

                </div>



                <div class="trust-text">

                    <strong>Transparent</strong>

                    <span>

                        Processes you can trust

                    </span>

                </div>

            </div>





            <!-- EFFICIENT -->

            <div class="trust-item">

                <div class="trust-icon efficient-icon">

                    <svg viewBox="0 0 24 24"

                         fill="currentColor">

                        <path d="M13.5 2L5 14H11L10.5 22L19 10H13L13.5 2Z"/>

                    </svg>

                </div>



                <div class="trust-text">

                    <strong>Efficient</strong>

                    <span>

                        Faster approvals, always

                    </span>

                </div>

            </div>





            <!-- CHAPERON MESSAGE -->

            <div class="trust-item trust-brand">

                <p>

                    CHAPERON — Making industrial approvals

                    simpler, guided and transparent.

                </p>



                <svg class="shield-light"

                     viewBox="0 0 24 24"

                     fill="#0C65F3">

                    <path d="M12 2L20 5V11C20 16.2 16.7 20.4 12 22C7.3 20.4 4 16.2 4 11V5L12 2Z"/>

                    <path d="M8.5 12L11 14.5L16 9.5"

                          fill="none"

                          stroke="white"

                          stroke-width="2"/>

                </svg>

            </div>

        </section>

    </main>

</div>

</body>

</html>