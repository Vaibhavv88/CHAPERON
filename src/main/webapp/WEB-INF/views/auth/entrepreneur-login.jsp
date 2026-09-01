<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Entrepreneur Login | CHAPERON</title>


    <style>

        /* ==========================================================
           CHAPERON ENTREPRENEUR LOGIN
           PREMIUM GOVERNMENT-TECH AUTHENTICATION UI
        ========================================================== */


        /* ==========================================================
           01. RESET
        ========================================================== */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }


        html {
            width: 100%;
            height: 100%;
        }


        body {
            width: 100%;
            height: 100%;

            font-family:
                Arial,
                Helvetica,
                sans-serif;

            color: #09173f;

            background: #f4f8ff;

            overflow: hidden;
        }


        a {
            text-decoration: none;
        }


        input,
        button {
            font-family: inherit;
        }


        button {
            outline: none;
        }



        /* ==========================================================
           02. PAGE
        ========================================================== */

        .page {

            width: 100%;
            height: 100vh;

            display: flex;
            flex-direction: column;

            overflow: hidden;

            background:

                radial-gradient(
                    circle at 83% 28%,
                    rgba(73, 151, 255, 0.11),
                    transparent 30%
                ),

                linear-gradient(
                    135deg,
                    #ffffff 0%,
                    #edf5ff 100%
                );
        }



        /* ==========================================================
           03. HEADER
        ========================================================== */

        .top-header {

            height: 78px;
            min-height: 78px;

            padding:
                5px
                4%;

            display: flex;
            align-items: center;
            justify-content: space-between;

            background:
                rgba(255, 255, 255, 0.98);

            border-bottom:
                1px solid #e4edf9;

            box-shadow:
                0 5px 18px
                rgba(22, 68, 135, 0.045);

            position: relative;

            z-index: 100;
        }



        /* ==========================================================
           04. HEADER BRAND
        ========================================================== */

        .brand {

            height: 100%;

            display: flex;
            align-items: center;

            gap: 10px;

            color: inherit;
        }



        /*
           Source logo image contains complete CHAPERON branding.

           We crop its upper illustration area inside the small
           circular viewport and then place textual CHAPERON beside it.
        */

        .logo-crop {

            position: relative;

            width: 58px;
            height: 58px;

            flex-shrink: 0;

            overflow: hidden;

            border-radius: 50%;

            background: #ffffff;
        }


        .logo-crop img {

            position: absolute;

            width: 104px;
            height: 104px;

            max-width: none;

            left: -23px;
            top: -7px;

            object-fit: cover;
        }



        .brand-copy {

            display: flex;
            flex-direction: column;

            justify-content: center;
        }



        .brand-name {

            color: #0c53dc;

            font-size: 27px;

            line-height: 1;

            font-weight: 800;

            letter-spacing: 0.5px;
        }



        .brand-tagline {

            margin-top: 5px;

            color: #0957df;

            font-size: 7px;

            line-height: 1;

            font-weight: 800;

            letter-spacing: 0.65px;

            white-space: nowrap;
        }



        /* ==========================================================
           05. HEADER BACK LINK
        ========================================================== */

        .header-back {

            display: inline-flex;
            align-items: center;

            gap: 8px;

            color: #075ce9;

            font-size: 14px;

            font-weight: 700;

            transition:
                color 0.2s ease,
                transform 0.2s ease;
        }


        .header-back:hover {

            color: #003da8;

            transform:
                translateX(-2px);
        }


        .header-back-arrow {

            font-size: 21px;

            line-height: 1;
        }



        /* ==========================================================
           06. MAIN SPLIT LAYOUT
        ========================================================== */

        .auth-layout {

            flex: 1;

            min-height: 0;

            width: 100%;

            display: grid;

            grid-template-columns:
                49% 51%;

            overflow: hidden;
        }



        /* ==========================================================
           07. LEFT MARKETING PANEL
        ========================================================== */

        .marketing-panel {

            position: relative;

            min-width: 0;
            min-height: 0;

            overflow: hidden;

            padding:
                clamp(22px, 3vh, 38px)
                6%
                17px;

            display: flex;
            flex-direction: column;

            color: #ffffff;

            background:

                radial-gradient(
                    circle at 76% 19%,
                    rgba(0, 190, 255, 0.19),
                    transparent 27%
                ),

                radial-gradient(
                    circle at 19% 84%,
                    rgba(39, 101, 255, 0.33),
                    transparent 34%
                ),

                linear-gradient(
                    145deg,
                    #073fc3 0%,
                    #052d9c 42%,
                    #031c6e 100%
                );
        }



        /* ==========================================================
           08. DECORATIONS
        ========================================================== */

        .spark {

            position: absolute;

            display: block;

            transform:
                rotate(45deg);

            border-radius: 2px;
        }


        .spark-one {

            width: 13px;
            height: 13px;

            top: 47px;
            left: 65px;

            background: #12bafe;
        }


        .spark-two {

            width: 18px;
            height: 18px;

            top: 26px;
            left: 92px;

            background: #7555f5;
        }


        .spark-three {

            width: 10px;
            height: 10px;

            top: 69px;
            left: 104px;

            background: #20edd0;
        }



        .dot-pattern {

            position: absolute;

            width: 78px;
            height: 78px;

            top: 34px;
            right: 55px;

            opacity: 0.48;

            background-image:

                radial-gradient(
                    #138cff 2px,
                    transparent 2px
                );

            background-size:
                13px 13px;
        }



        /* ==========================================================
           09. LEFT TEXT
        ========================================================== */

        .marketing-content {

            position: relative;

            z-index: 5;

            max-width: 610px;
        }



        /*
           IMPORTANT:
           No duplicate "CHAPERON" word here.
           Header already contains branding.
        */

        .marketing-heading {

            margin-top:
                clamp(26px, 5vh, 52px);

            color: #ffffff;

            font-size:
                clamp(
                    28px,
                    2.8vw,
                    45px
                );

            line-height: 1.16;

            font-weight: 800;

            letter-spacing: -1px;
        }



        .marketing-heading-highlight {

            display: block;

            margin-top: 5px;

            background:

                linear-gradient(
                    90deg,
                    #22d0ff,
                    #1694ff
                );

            -webkit-background-clip: text;

            -webkit-text-fill-color:
                transparent;

            background-clip: text;
        }



        .accent-line {

            width: 65px;
            height: 4px;

            margin:
                21px
                0
                19px;

            border-radius: 20px;

            background:

                linear-gradient(
                    90deg,
                    #0788ff,
                    #20e9ed
                );
        }



        .marketing-description {

            max-width: 510px;

            color: #dce8ff;

            font-size: 14px;

            line-height: 1.65;
        }



        /* ==========================================================
           10. ILLUSTRATION AREA
        ========================================================== */

        .illustration-area {

            position: relative;

            flex: 1;

            min-height: 135px;

            max-height: 245px;

            margin-top: 3px;

            z-index: 2;
        }


        .illustration-svg {

            position: absolute;

            left: 0;
            bottom: 0;

            width: 100%;
            height: 100%;
        }



        /* ==========================================================
           11. SECURITY GLASS PANEL
        ========================================================== */

        .security-card {

            position: relative;

            z-index: 6;

            width:
                min(
                    395px,
                    100%
                );

            display: flex;
            align-items: center;

            gap: 14px;

            min-height: 68px;

            margin-bottom: 7px;

            padding:
                11px 17px;

            border:

                1px solid
                rgba(
                    255,
                    255,
                    255,
                    0.16
                );

            border-radius: 14px;

            background:

                linear-gradient(
                    135deg,
                    rgba(255,255,255,0.14),
                    rgba(255,255,255,0.06)
                );

            box-shadow:

                inset
                0
                1px
                0
                rgba(255,255,255,0.10),

                0
                12px
                28px
                rgba(0,0,50,0.16);

            backdrop-filter:
                blur(14px);
        }



        .security-icon {

            width: 48px;
            height: 48px;

            flex-shrink: 0;

            border-radius: 50%;

            display: flex;
            align-items: center;
            justify-content: center;

            background:

                linear-gradient(
                    135deg,
                    #0992ff,
                    #0059ed
                );

            box-shadow:

                0
                9px
                22px
                rgba(0, 100, 255, 0.23);
        }


        .security-icon svg {

            width: 27px;
            height: 27px;
        }



        .security-copy strong {

            display: block;

            margin-bottom: 4px;

            color: #ffffff;

            font-size: 13px;
        }



        .security-copy p {

            color: #dce8ff;

            font-size: 11px;

            line-height: 1.45;
        }



        /* ==========================================================
           12. RIGHT FORM PANEL
        ========================================================== */

        .form-panel {

            position: relative;

            min-width: 0;
            min-height: 0;

            padding:
                18px
                7%;

            display: flex;
            align-items: center;
            justify-content: center;

            overflow: hidden;

            background:

                radial-gradient(
                    circle at 69% 37%,
                    rgba(74,149,255,0.10),
                    transparent 39%
                ),

                linear-gradient(
                    135deg,
                    #f9fbff 0%,
                    #edf5ff 100%
                );
        }



        /* ==========================================================
           13. LOGIN CARD
        ========================================================== */

        .login-card {

            width: 100%;

            max-width: 570px;

            padding:
                27px
                42px
                28px;

            border:

                1px solid
                rgba(
                    37,
                    99,
                    210,
                    0.10
                );

            border-radius: 22px;

            background:
                rgba(
                    255,
                    255,
                    255,
                    0.98
                );

            box-shadow:

                0
                20px
                50px
                rgba(
                    37,
                    80,
                    145,
                    0.12
                );
        }



        /* ==========================================================
           14. CARD BACK LINK
        ========================================================== */

        .card-back {

            display: inline-flex;
            align-items: center;

            gap: 8px;

            margin-bottom: 15px;

            color: #4c6793;

            font-size: 13px;

            font-weight: 600;

            transition:
                color 0.2s ease;
        }


        .card-back:hover {

            color: #075bea;
        }


        .card-back-arrow {

            font-size: 19px;

            line-height: 1;
        }



        /* ==========================================================
           15. LOGIN HEADING
        ========================================================== */

        .login-title {

            margin-bottom: 6px;

            color: #07133c;

            font-size: 34px;

            line-height: 1.15;

            font-weight: 800;

            letter-spacing: -1px;
        }


        .login-title span {

            color: #075df0;
        }



        .login-subtitle {

            margin-bottom: 20px;

            color: #536d98;

            font-size: 13px;

            line-height: 1.5;
        }



        /* ==========================================================
           16. ERROR MESSAGE
        ========================================================== */

        .error-box {

            display: flex;
            align-items: flex-start;

            gap: 9px;

            margin-bottom: 14px;

            padding:
                10px
                12px;

            border:
                1px solid #ffd0d0;

            border-radius: 9px;

            background: #fff3f3;

            color: #a32b2b;

            font-size: 12px;

            line-height: 1.45;
        }



        .error-icon {

            width: 19px;
            height: 19px;

            flex-shrink: 0;

            border-radius: 50%;

            display: flex;
            align-items: center;
            justify-content: center;

            background: #d83e3e;

            color: #ffffff;

            font-size: 11px;

            font-weight: 800;
        }



        /* ==========================================================
           17. FORM
        ========================================================== */

        .form-group {

            margin-bottom: 14px;
        }



        .form-label {

            display: block;

            margin-bottom: 7px;

            color: #0b173b;

            font-size: 12px;

            font-weight: 700;
        }



        .input-wrapper {

            position: relative;

            width: 100%;
        }



        .input-icon {

            position: absolute;

            left: 14px;
            top: 50%;

            width: 19px;
            height: 19px;

            transform:
                translateY(-50%);

            color: #1767ea;

            pointer-events: none;
        }



        .form-input {

            width: 100%;
            height: 49px;

            padding:
                0
                45px
                0
                44px;

            border:
                1px solid #cad8ec;

            border-radius: 8px;

            outline: none;

            background: #ffffff;

            color: #14264b;

            font-size: 13px;

            transition:

                border-color 0.2s ease,

                box-shadow 0.2s ease,

                background 0.2s ease;
        }



        .form-input::placeholder {

            color: #8494ad;
        }



        .form-input:focus {

            border-color: #1768ed;

            background: #ffffff;

            box-shadow:

                0
                0
                0
                3px
                rgba(
                    23,
                    104,
                    237,
                    0.09
                );
        }



        /* ==========================================================
           18. PASSWORD VISIBILITY
        ========================================================== */

        .password-toggle {

            position: absolute;

            right: 10px;
            top: 50%;

            width: 34px;
            height: 34px;

            transform:
                translateY(-50%);

            display: flex;
            align-items: center;
            justify-content: center;

            border: none;

            border-radius: 7px;

            background: transparent;

            color: #48658e;

            cursor: pointer;

            transition:

                color 0.2s ease,

                background 0.2s ease;
        }


        .password-toggle:hover {

            color: #075ee8;

            background: #edf4ff;
        }


        .password-toggle svg {

            width: 20px;
            height: 20px;
        }



        /* ==========================================================
           19. FORGOT PASSWORD
        ========================================================== */

        .forgot-row {

            display: flex;
            justify-content: flex-end;

            margin:
                -3px
                0
                16px;
        }



        .forgot-link {

            color: #075df0;

            font-size: 12px;

            font-weight: 600;
        }


        .forgot-link:hover {

            text-decoration:
                underline;
        }



        /* ==========================================================
           20. LOGIN BUTTON
        ========================================================== */

        .login-button {

            position: relative;

            width: 100%;
            height: 49px;

            display: flex;
            align-items: center;
            justify-content: center;

            border: none;

            border-radius: 8px;

            background:

                linear-gradient(
                    90deg,
                    #075df0,
                    #004be0
                );

            color: #ffffff;

            font-size: 14px;

            font-weight: 700;

            cursor: pointer;

            box-shadow:

                0
                10px
                22px
                rgba(
                    0,
                    85,
                    226,
                    0.20
                );

            transition:

                transform 0.2s ease,

                box-shadow 0.2s ease;
        }



        .login-button:hover {

            transform:
                translateY(-1px);

            box-shadow:

                0
                13px
                26px
                rgba(
                    0,
                    85,
                    226,
                    0.27
                );
        }



        .login-arrow {

            position: absolute;

            right: 8px;

            width: 34px;
            height: 34px;

            border-radius: 50%;

            display: flex;
            align-items: center;
            justify-content: center;

            background: #ffffff;

            color: #075df0;

            font-size: 20px;

            font-weight: 700;
        }



        /* ==========================================================
           21. DIVIDER
        ========================================================== */

        .divider {

            display: flex;
            align-items: center;

            gap: 14px;

            margin:
                17px
                0
                14px;

            color: #667c9f;

            font-size: 11px;

            font-weight: 600;
        }


        .divider::before,
        .divider::after {

            content: "";

            flex: 1;

            height: 1px;

            background: #d8e1ec;
        }



        /* ==========================================================
           22. REGISTER
        ========================================================== */

        .register-row {

            text-align: center;

            color: #60779c;

            font-size: 12px;
        }


        .register-row a {

            margin-left: 4px;

            color: #075df0;

            font-weight: 700;
        }


        .register-row a:hover {

            text-decoration: underline;
        }



        /* ==========================================================
           23. MEDIUM LAPTOP HEIGHT
        ========================================================== */

        @media (
            max-height: 790px
        ) and (
            min-width: 851px
        ) {

            .top-header {

                height: 68px;
                min-height: 68px;
            }


            .logo-crop {

                width: 49px;
                height: 49px;
            }


            .logo-crop img {

                width: 88px;
                height: 88px;

                left: -20px;
                top: -6px;
            }


            .brand-name {

                font-size: 23px;
            }


            .brand-tagline {

                font-size: 6px;
            }


            .marketing-panel {

                padding-top: 17px;
            }


            .marketing-heading {

                margin-top: 25px;

                font-size: 32px;
            }


            .accent-line {

                margin:
                    15px
                    0
                    14px;
            }


            .marketing-description {

                font-size: 13px;

                line-height: 1.55;
            }


            .illustration-area {

                max-height: 178px;
            }


            .security-card {

                min-height: 60px;

                padding:
                    8px
                    14px;
            }


            .security-icon {

                width: 42px;
                height: 42px;
            }


            .login-card {

                padding:
                    21px
                    35px
                    22px;
            }


            .card-back {

                margin-bottom: 11px;
            }


            .login-title {

                font-size: 30px;
            }


            .login-subtitle {

                margin-bottom: 14px;
            }


            .form-group {

                margin-bottom: 10px;
            }


            .form-input {

                height: 44px;
            }


            .forgot-row {

                margin-bottom: 11px;
            }


            .login-button {

                height: 44px;
            }


            .login-arrow {

                width: 31px;
                height: 31px;
            }


            .divider {

                margin:
                    12px
                    0
                    10px;
            }
        }



        /* ==========================================================
           24. VERY SHORT LAPTOP HEIGHT
        ========================================================== */

        @media (
            max-height: 680px
        ) and (
            min-width: 851px
        ) {

            .top-header {

                height: 60px;
                min-height: 60px;
            }


            .logo-crop {

                width: 43px;
                height: 43px;
            }


            .logo-crop img {

                width: 78px;
                height: 78px;

                left: -18px;
                top: -5px;
            }


            .brand-name {

                font-size: 21px;
            }


            .marketing-heading {

                margin-top: 18px;

                font-size: 29px;
            }


            .marketing-description {

                font-size: 12px;
            }


            .accent-line {

                margin:
                    12px
                    0;
            }


            .illustration-area {

                max-height: 145px;
            }


            .security-card {

                min-height: 54px;
            }


            .security-icon {

                width: 38px;
                height: 38px;
            }


            .login-card {

                padding:
                    17px
                    31px;
            }


            .login-title {

                font-size: 27px;
            }


            .form-input {

                height: 41px;
            }


            .login-button {

                height: 41px;
            }
        }



        /* ==========================================================
           25. TABLET
        ========================================================== */

        @media (
            max-width: 850px
        ) {

            body {

                height: auto;

                overflow-y: auto;
            }


            .page {

                height: auto;

                min-height: 100vh;

                overflow: visible;
            }


            .top-header {

                height: 72px;
                min-height: 72px;
            }


            .auth-layout {

                display: block;

                overflow: visible;
            }


            .marketing-panel {

                min-height: 525px;

                padding:
                    35px
                    7%
                    28px;
            }


            .marketing-heading {

                margin-top: 35px;
            }


            .illustration-area {

                height: 190px;

                min-height: 190px;

                flex: none;
            }


            .form-panel {

                padding:
                    40px
                    20px;

                overflow: visible;
            }


            .login-card {

                max-width: 600px;
            }
        }



        /* ==========================================================
           26. MOBILE
        ========================================================== */

        @media (
            max-width: 580px
        ) {

            .top-header {

                padding:
                    5px
                    15px;
            }


            .logo-crop {

                width: 42px;
                height: 42px;
            }


            .logo-crop img {

                width: 76px;
                height: 76px;

                left: -17px;
                top: -5px;
            }


            .brand {

                gap: 7px;
            }


            .brand-name {

                font-size: 20px;
            }


            .brand-tagline {

                max-width: 160px;

                overflow: hidden;

                font-size: 5px;
            }


            .header-back {

                font-size: 10px;
            }


            .header-back-arrow {

                font-size: 17px;
            }


            .marketing-panel {

                min-height: 500px;

                padding:
                    32px
                    24px
                    25px;
            }


            .marketing-heading {

                font-size: 28px;
            }


            .marketing-description {

                font-size: 13px;
            }


            .form-panel {

                padding:
                    32px
                    15px;
            }


            .login-card {

                padding:
                    27px
                    20px;

                border-radius: 18px;
            }


            .login-title {

                font-size: 29px;
            }
        }


    </style>

</head>


<body>


<div class="page">


    <!-- ==========================================================
         HEADER
    =========================================================== -->

    <header class="top-header">


        <a href="<%= ctx %>/"
           class="brand">


            <!--
                This loads your real JPEG logo.

                Required source location:

                src/main/webapp/images/chaperon-logo.jpeg
            -->

            <div class="logo-crop">

                <img
                    src="<%= ctx %>/images/chaperon-logo.jpeg"
                    alt="CHAPERON Logo">

            </div>


            <div class="brand-copy">


                <div class="brand-name">
                    CHAPERON
                </div>


                <div class="brand-tagline">
                    GUIDE. CONNECT. COMPLY. GET APPROVED.
                </div>


            </div>


        </a>



        <a href="<%= ctx %>/"
           class="header-back">


            <span class="header-back-arrow">
                ←
            </span>


            <span>
                Back to CHAPERON
            </span>


        </a>


    </header>



    <!-- ==========================================================
         SPLIT SCREEN
    =========================================================== -->

    <main class="auth-layout">


        <!-- ======================================================
             LEFT SIDE
        ======================================================= -->

        <section class="marketing-panel">


            <!-- DECORATIONS -->

            <span class="spark spark-one"></span>

            <span class="spark spark-two"></span>

            <span class="spark spark-three"></span>


            <div class="dot-pattern"></div>



            <!-- TEXT -->

            <div class="marketing-content">


                <h1 class="marketing-heading">

                    FROM BUSINESS IDEA
                    <br>

                    TO APPROVAL —

                    <span class="marketing-heading-highlight">

                        ONE INTELLIGENT JOURNEY

                    </span>

                </h1>



                <div class="accent-line"></div>



                <p class="marketing-description">

                    Welcome back. Continue your approval journey,
                    track applications and complete your next action
                    through one guided and transparent platform.

                </p>


            </div>



            <!-- ==================================================
                 CITY + GOVERNMENT ILLUSTRATION
            =================================================== -->

            <div class="illustration-area">


                <svg
                    class="illustration-svg"
                    viewBox="0 0 760 260"
                    preserveAspectRatio="xMidYMax meet"
                    xmlns="http://www.w3.org/2000/svg">


                    <defs>


                        <linearGradient
                            id="cityBuildingGradient"
                            x1="0"
                            y1="0"
                            x2="0"
                            y2="1">


                            <stop
                                offset="0%"
                                stop-color="#4d91ff"/>


                            <stop
                                offset="100%"
                                stop-color="#1552c7"/>


                        </linearGradient>



                        <linearGradient
                            id="governmentGradient"
                            x1="0"
                            y1="0"
                            x2="0"
                            y2="1">


                            <stop
                                offset="0%"
                                stop-color="#a9dcff"/>


                            <stop
                                offset="100%"
                                stop-color="#4d8ede"/>


                        </linearGradient>


                    </defs>



                    <!-- CLOUDS -->

                    <g
                        fill="#1683ed"
                        opacity="0.54">


                        <path
                            d="
                                M32 106
                                C38 93 53 92 61 102
                                C68 95 81 97 85 109
                                H28
                                C28 109 30 107 32 106
                                Z
                            "/>


                        <path
                            d="
                                M323 84
                                C330 70 347 70 355 82
                                C363 75 379 77 383 90
                                H316
                                C316 88 319 86 323 84
                                Z
                            "/>


                        <path
                            d="
                                M600 104
                                C608 91 624 91 632 101
                                C640 94 654 96 659 109
                                H594
                                C594 107 597 105 600 104
                                Z
                            "/>


                    </g>



                    <!-- CITY BUILDINGS -->

                    <g>


                        <rect
                            x="55"
                            y="142"
                            width="55"
                            height="88"
                            rx="3"
                            fill="#2468d8"/>


                        <rect
                            x="122"
                            y="102"
                            width="69"
                            height="128"
                            rx="3"
                            fill="url(#cityBuildingGradient)"/>


                        <rect
                            x="204"
                            y="151"
                            width="56"
                            height="79"
                            rx="3"
                            fill="#3074de"/>


                        <rect
                            x="273"
                            y="124"
                            width="65"
                            height="106"
                            rx="3"
                            fill="#2866d1"/>



                        <!-- WINDOWS -->

                        <g
                            fill="#9bc9ff">


                            <rect
                                x="69"
                                y="157"
                                width="10"
                                height="12"/>


                            <rect
                                x="88"
                                y="157"
                                width="10"
                                height="12"/>


                            <rect
                                x="69"
                                y="179"
                                width="10"
                                height="12"/>


                            <rect
                                x="88"
                                y="179"
                                width="10"
                                height="12"/>



                            <rect
                                x="137"
                                y="118"
                                width="11"
                                height="13"/>


                            <rect
                                x="160"
                                y="118"
                                width="11"
                                height="13"/>


                            <rect
                                x="137"
                                y="144"
                                width="11"
                                height="13"/>


                            <rect
                                x="160"
                                y="144"
                                width="11"
                                height="13"/>


                            <rect
                                x="137"
                                y="170"
                                width="11"
                                height="13"/>


                            <rect
                                x="160"
                                y="170"
                                width="11"
                                height="13"/>



                            <rect
                                x="218"
                                y="166"
                                width="10"
                                height="12"/>


                            <rect
                                x="240"
                                y="166"
                                width="10"
                                height="12"/>



                            <rect
                                x="287"
                                y="141"
                                width="11"
                                height="13"/>


                            <rect
                                x="310"
                                y="141"
                                width="11"
                                height="13"/>


                            <rect
                                x="287"
                                y="168"
                                width="11"
                                height="13"/>


                            <rect
                                x="310"
                                y="168"
                                width="11"
                                height="13"/>


                        </g>


                    </g>



                    <!-- ==================================================
                         GOVERNMENT BUILDING
                    =================================================== -->

                    <g transform="translate(390 27)">


                        <!-- FLAG -->

                        <rect
                            x="170"
                            y="0"
                            width="4"
                            height="42"
                            fill="#76bdff"/>


                        <path
                            d="
                                M174 4
                                L199 10
                                L174 17
                                Z
                            "
                            fill="#559af1"/>



                        <!-- DOME -->

                        <path
                            d="
                                M116 78
                                C116 38 143 18 172 18
                                C201 18 228 38 228 78
                                Z
                            "
                            fill="url(#governmentGradient)"/>


                        <path
                            d="
                                M130 78
                                C130 50 149 35 172 35
                                C195 35 214 50 214 78
                                Z
                            "
                            fill="#78b4f3"/>



                        <!-- DOME BASE -->

                        <rect
                            x="105"
                            y="75"
                            width="134"
                            height="14"
                            rx="2"
                            fill="#a2d0ff"/>



                        <!-- TRIANGLE ROOF -->

                        <path
                            d="
                                M72 111
                                L172 78
                                L272 111
                                Z
                            "
                            fill="#72adef"/>



                        <!-- MAIN BODY -->

                        <rect
                            x="80"
                            y="111"
                            width="184"
                            height="93"
                            fill="#508fdd"/>



                        <!-- COLUMNS -->

                        <g
                            fill="#c0e2ff">


                            <rect
                                x="97"
                                y="119"
                                width="18"
                                height="76"/>


                            <rect
                                x="128"
                                y="119"
                                width="18"
                                height="76"/>


                            <rect
                                x="159"
                                y="119"
                                width="18"
                                height="76"/>


                            <rect
                                x="190"
                                y="119"
                                width="18"
                                height="76"/>


                            <rect
                                x="221"
                                y="119"
                                width="18"
                                height="76"/>


                        </g>



                        <!-- STEPS -->

                        <rect
                            x="64"
                            y="201"
                            width="216"
                            height="10"
                            fill="#73aaec"/>


                        <rect
                            x="52"
                            y="211"
                            width="240"
                            height="10"
                            fill="#508bdc"/>


                    </g>



                    <!-- ==================================================
                         TREES
                    =================================================== -->

                    <g>


                        <rect
                            x="20"
                            y="199"
                            width="5"
                            height="32"
                            fill="#07579c"/>


                        <circle
                            cx="22"
                            cy="189"
                            r="19"
                            fill="#199b9e"/>



                        <rect
                            x="365"
                            y="199"
                            width="5"
                            height="32"
                            fill="#07579c"/>


                        <circle
                            cx="367"
                            cy="188"
                            r="20"
                            fill="#25b276"/>



                        <rect
                            x="720"
                            y="199"
                            width="5"
                            height="32"
                            fill="#07579c"/>


                        <circle
                            cx="722"
                            cy="189"
                            r="19"
                            fill="#168eaa"/>


                    </g>



                    <!-- GROUND -->

                    <rect
                        x="0"
                        y="228"
                        width="760"
                        height="32"
                        fill="#07388f"
                        opacity="0.78"/>


                </svg>


            </div>



            <!-- ==================================================
                 SECURITY CARD
            =================================================== -->

            <div class="security-card">


                <div class="security-icon">


                    <svg
                        viewBox="0 0 24 24"
                        fill="none"
                        xmlns="http://www.w3.org/2000/svg">


                        <path
                            d="
                                M12 2.5
                                L19 5.3
                                V10.6
                                C19 15.2 16.3 19.1 12 21
                                C7.7 19.1 5 15.2 5 10.6
                                V5.3
                                L12 2.5
                                Z
                            "
                            stroke="white"
                            stroke-width="2"/>


                        <path
                            d="
                                M8.5 11.7
                                L10.8 14
                                L15.8 9
                            "
                            stroke="white"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"/>


                    </svg>


                </div>



                <div class="security-copy">


                    <strong>
                        Secure • Transparent • Efficient
                    </strong>


                    <p>
                        Your data is protected and your
                        approval journey is our priority.
                    </p>


                </div>


            </div>


        </section>



        <!-- ======================================================
             RIGHT SIDE
        ======================================================= -->

        <section class="form-panel">


            <div class="login-card">



                <!-- CARD BACK -->

                <a
                    href="<%= ctx %>/"
                    class="card-back">


                    <span class="card-back-arrow">
                        ←
                    </span>


                    <span>
                        Back to CHAPERON
                    </span>


                </a>



                <!-- HEADING -->

                <h1 class="login-title">

                    Welcome

                    <span>
                        Back
                    </span>

                </h1>



                <p class="login-subtitle">

                    Sign in to continue your business
                    approval journey.

                </p>



                <!-- ==================================================
                     EXISTING JSP ERROR LOGIC
                =================================================== -->

                <%
                    if (request.getAttribute("errorMessage") != null) {
                %>


                    <div class="error-box">


                        <span class="error-icon">
                            !
                        </span>


                        <span>

                            <%= request.getAttribute("errorMessage") %>

                        </span>


                    </div>


                <%
                    }
                %>



                <!-- ==================================================
                     LOGIN FORM
                =================================================== -->

                <form
                    method="post"
                    action="<%= ctx %>/entrepreneur-login">



                    <!-- ==============================================
                         EMAIL
                    =============================================== -->

                    <div class="form-group">


                        <label
                            for="email"
                            class="form-label">

                            Email Address

                        </label>



                        <div class="input-wrapper">


                            <!-- EMAIL ICON -->

                            <svg
                                class="input-icon"
                                viewBox="0 0 24 24"
                                fill="none"
                                xmlns="http://www.w3.org/2000/svg">


                                <rect
                                    x="3"
                                    y="5"
                                    width="18"
                                    height="14"
                                    rx="2"
                                    stroke="currentColor"
                                    stroke-width="2"/>


                                <path
                                    d="
                                        M4 7
                                        L12 13
                                        L20 7
                                    "
                                    stroke="currentColor"
                                    stroke-width="2"
                                    stroke-linecap="round"
                                    stroke-linejoin="round"/>


                            </svg>



                            <input
                                type="email"
                                id="email"
                                name="email"
                                class="form-input"
                                placeholder="you@example.com"
                                autocomplete="email"
                                required>


                        </div>


                    </div>



                    <!-- ==============================================
                         PASSWORD
                    =============================================== -->

                    <div class="form-group">


                        <label
                            for="password"
                            class="form-label">

                            Password

                        </label>



                        <div class="input-wrapper">


                            <!-- LOCK ICON -->

                            <svg
                                class="input-icon"
                                viewBox="0 0 24 24"
                                fill="none"
                                xmlns="http://www.w3.org/2000/svg">


                                <rect
                                    x="5"
                                    y="10"
                                    width="14"
                                    height="11"
                                    rx="2"
                                    stroke="currentColor"
                                    stroke-width="2"/>


                                <path
                                    d="
                                        M8 10
                                        V7
                                        C8 4.8 9.8 3 12 3
                                        C14.2 3 16 4.8 16 7
                                        V10
                                    "
                                    stroke="currentColor"
                                    stroke-width="2"
                                    stroke-linecap="round"/>


                            </svg>



                            <input
                                type="password"
                                id="password"
                                name="password"
                                class="form-input"
                                placeholder="Enter your password"
                                autocomplete="current-password"
                                required>



                            <!-- EYE -->

                            <button
                                type="button"
                                id="passwordToggle"
                                class="password-toggle"
                                aria-label="Show password"
                                onclick="togglePassword()">



                                <svg
                                    viewBox="0 0 24 24"
                                    fill="none"
                                    xmlns="http://www.w3.org/2000/svg">


                                    <path
                                        d="
                                            M2.5 12
                                            C4.6 8.5 7.7 6.5 12 6.5
                                            C16.3 6.5 19.4 8.5 21.5 12
                                            C19.4 15.5 16.3 17.5 12 17.5
                                            C7.7 17.5 4.6 15.5 2.5 12
                                            Z
                                        "
                                        stroke="currentColor"
                                        stroke-width="1.8"/>


                                    <circle
                                        cx="12"
                                        cy="12"
                                        r="2.7"
                                        stroke="currentColor"
                                        stroke-width="1.8"/>


                                </svg>


                            </button>


                        </div>


                    </div>



                    <!-- ==============================================
                         FORGOT PASSWORD
                    =============================================== -->

                    <div class="forgot-row">


                        <a
                            href="#"
                            class="forgot-link">

                            Forgot Password?

                        </a>


                    </div>



                    <!-- ==============================================
                         LOGIN
                    =============================================== -->

                    <button
                        type="submit"
                        class="login-button">


                        <span>
                            Login
                        </span>


                        <span class="login-arrow">
                            →
                        </span>


                    </button>


                </form>



                <!-- ==================================================
                     DIVIDER
                =================================================== -->

                <div class="divider">

                    OR

                </div>



                <!-- ==================================================
                     REGISTER
                =================================================== -->

                <div class="register-row">


                    New to CHAPERON?


                    <a href="<%= ctx %>/entrepreneur-register">

                        Create Your Account

                    </a>


                </div>


            </div>


        </section>


    </main>


</div>



<!-- ==============================================================
     JAVASCRIPT
=============================================================== -->

<script>

    function togglePassword() {

        const passwordInput =
            document.getElementById("password");

        const toggleButton =
            document.getElementById("passwordToggle");


        if (passwordInput.type === "password") {

            passwordInput.type = "text";

            toggleButton.setAttribute(
                "aria-label",
                "Hide password"
            );

        } else {

            passwordInput.type = "password";

            toggleButton.setAttribute(
                "aria-label",
                "Show password"
            );

        }

    }

</script>


</body>

</html>