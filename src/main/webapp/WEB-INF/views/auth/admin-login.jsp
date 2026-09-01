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

    <title>Administrator Login | CHAPERON</title>


    <style>

        /* ==========================================================
           01. RESET
        ========================================================== */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }


        html,
        body {
            width: 100%;
            height: 100%;
        }


        body {
            font-family:
                Arial,
                Helvetica,
                sans-serif;

            color: #10133b;

            background: #f6f5ff;

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
                    circle at 82% 28%,
                    rgba(105, 83, 238, 0.11),
                    transparent 30%
                ),

                linear-gradient(
                    135deg,
                    #ffffff 0%,
                    #f1efff 100%
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
                1px solid #e8e5fa;

            box-shadow:
                0 5px 18px
                rgba(66, 45, 145, 0.05);

            position: relative;

            z-index: 100;
        }



        /* ==========================================================
           04. BRAND
        ========================================================== */

        .brand {

            height: 100%;

            display: flex;
            align-items: center;

            gap: 10px;

            color: inherit;
        }


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
           05. HEADER BACK
        ========================================================== */

        .header-back {

            display: inline-flex;
            align-items: center;

            gap: 8px;

            color: #5739d7;

            font-size: 14px;

            font-weight: 700;

            transition:
                color 0.2s ease,
                transform 0.2s ease;
        }


        .header-back:hover {

            color: #3d22aa;

            transform:
                translateX(-2px);
        }


        .header-back-arrow {

            font-size: 21px;

            line-height: 1;
        }



        /* ==========================================================
           06. MAIN
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
           07. LEFT ADMIN PANEL
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
                    circle at 78% 18%,
                    rgba(145, 104, 255, 0.27),
                    transparent 28%
                ),

                radial-gradient(
                    circle at 20% 85%,
                    rgba(70, 74, 224, 0.31),
                    transparent 35%
                ),

                linear-gradient(
                    145deg,
                    #30218f 0%,
                    #251775 43%,
                    #160d4e 100%
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

            background: #8f7cff;
        }


        .spark-two {

            width: 18px;
            height: 18px;

            top: 26px;
            left: 92px;

            background: #4ca8ff;
        }


        .spark-three {

            width: 10px;
            height: 10px;

            top: 69px;
            left: 104px;

            background: #c58cff;
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
                    #8d79ff 2px,
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
                    #b294ff,
                    #6ea7ff
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
                    #8266ff,
                    #55b8ff
                );
        }


        .marketing-description {

            max-width: 515px;

            color: #e6e2ff;

            font-size: 14px;

            line-height: 1.65;
        }



        /* ==========================================================
           10. ADMIN CAPABILITIES
        ========================================================== */

        .capability-row {

            position: relative;

            z-index: 5;

            display: flex;
            flex-wrap: wrap;

            gap: 9px;

            margin-top: 20px;
        }


        .capability-badge {

            display: inline-flex;
            align-items: center;

            gap: 6px;

            padding:
                7px
                11px;

            border-radius: 100px;

            border:
                1px solid
                rgba(255,255,255,0.14);

            background:
                rgba(255,255,255,0.08);

            color: #f2efff;

            font-size: 10px;

            font-weight: 600;

            backdrop-filter:
                blur(8px);
        }


        .capability-dot {

            width: 7px;
            height: 7px;

            border-radius: 50%;

            background: #a58cff;
        }



        /* ==========================================================
           11. ADMIN DASHBOARD ILLUSTRATION
        ========================================================== */

        .illustration-area {

            position: relative;

            flex: 1;

            min-height: 135px;

            max-height: 230px;

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
           12. SECURITY CARD
        ========================================================== */

        .security-card {

            position: relative;

            z-index: 6;

            width:
                min(
                    400px,
                    100%
                );

            display: flex;
            align-items: center;

            gap: 14px;

            min-height: 68px;

            margin-bottom: 7px;

            padding:
                11px
                17px;

            border:
                1px solid
                rgba(255,255,255,0.16);

            border-radius: 14px;

            background:
                linear-gradient(
                    135deg,
                    rgba(255,255,255,0.14),
                    rgba(255,255,255,0.06)
                );

            box-shadow:
                inset 0 1px 0
                rgba(255,255,255,0.10),

                0 12px 28px
                rgba(0,0,30,0.18);

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
                    #7658ef,
                    #5134cf
                );

            box-shadow:
                0 9px 22px
                rgba(81, 52, 207, 0.28);
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

            color: #e5e0ff;

            font-size: 11px;

            line-height: 1.45;
        }



        /* ==========================================================
           13. RIGHT PANEL
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
                    circle at 68% 38%,
                    rgba(108, 82, 232, 0.10),
                    transparent 39%
                ),

                linear-gradient(
                    135deg,
                    #fdfcff 0%,
                    #f3f0ff 100%
                );
        }



        /* ==========================================================
           14. LOGIN CARD
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
                rgba(89, 62, 205, 0.12);

            border-radius: 22px;

            background:
                rgba(255,255,255,0.98);

            box-shadow:
                0 20px 50px
                rgba(76, 55, 145, 0.13);
        }



        /* ==========================================================
           15. CARD BACK
        ========================================================== */

        .card-back {

            display: inline-flex;
            align-items: center;

            gap: 8px;

            margin-bottom: 15px;

            color: #6e6690;

            font-size: 13px;

            font-weight: 600;

            transition:
                color 0.2s ease;
        }


        .card-back:hover {

            color: #5739d7;
        }


        .card-back-arrow {

            font-size: 19px;

            line-height: 1;
        }



        /* ==========================================================
           16. ROLE PILL
        ========================================================== */

        .role-pill {

            display: inline-flex;
            align-items: center;

            gap: 7px;

            margin-bottom: 12px;

            padding:
                6px
                10px;

            border-radius: 100px;

            background: #f4f0ff;

            color: #593dd0;

            font-size: 10px;

            font-weight: 700;

            border:
                1px solid #e4dcff;
        }


        .role-pill-dot {

            width: 7px;
            height: 7px;

            border-radius: 50%;

            background: #6748e5;
        }



        /* ==========================================================
           17. TITLE
        ========================================================== */

        .login-title {

            margin-bottom: 6px;

            color: #12143a;

            font-size: 34px;

            line-height: 1.15;

            font-weight: 800;

            letter-spacing: -1px;
        }


        .login-title span {

            color: #593bd8;
        }


        .login-subtitle {

            margin-bottom: 20px;

            color: #706b91;

            font-size: 13px;

            line-height: 1.5;
        }



        /* ==========================================================
           18. ERROR
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
           19. FORM
        ========================================================== */

        .form-group {

            margin-bottom: 14px;
        }


        .form-label {

            display: block;

            margin-bottom: 7px;

            color: #252044;

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

            color: #6245da;

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
                1px solid #d4cfee;

            border-radius: 8px;

            outline: none;

            background: #ffffff;

            color: #292348;

            font-size: 13px;

            transition:
                border-color 0.2s ease,
                box-shadow 0.2s ease;
        }


        .form-input::placeholder {

            color: #9891ae;
        }


        .form-input:focus {

            border-color: #6548db;

            box-shadow:
                0 0 0 3px
                rgba(101, 72, 219, 0.09);
        }



        /* ==========================================================
           20. PASSWORD TOGGLE
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

            color: #6e668e;

            cursor: pointer;

            transition:
                color 0.2s ease,
                background 0.2s ease;
        }


        .password-toggle:hover {

            color: #583bd6;

            background: #f2efff;
        }


        .password-toggle svg {

            width: 20px;
            height: 20px;
        }



        /* ==========================================================
           21. FORGOT
        ========================================================== */

        .help-row {

            display: flex;
            justify-content: flex-end;

            margin:
                -3px
                0
                16px;
        }


        .help-row a {

            color: #593bd8;

            font-size: 12px;

            font-weight: 600;
        }


        .help-row a:hover {

            text-decoration: underline;
        }



        /* ==========================================================
           22. LOGIN BUTTON
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
                    #6548df,
                    #4930c5
                );

            color: #ffffff;

            font-size: 14px;

            font-weight: 700;

            cursor: pointer;

            box-shadow:
                0 10px 22px
                rgba(75, 48, 197, 0.22);

            transition:
                transform 0.2s ease,
                box-shadow 0.2s ease;
        }


        .login-button:hover {

            transform:
                translateY(-1px);

            box-shadow:
                0 13px 26px
                rgba(75, 48, 197, 0.30);
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

            color: #5134cf;

            font-size: 20px;

            font-weight: 700;
        }



        /* ==========================================================
           23. ADMIN NOTICE
        ========================================================== */

        .admin-info {

            margin-top: 18px;

            padding:
                13px
                15px;

            border-radius: 10px;

            background: #f7f4ff;

            border:
                1px solid #e7e0ff;

            color: #716a91;

            font-size: 11px;

            line-height: 1.5;

            text-align: center;
        }


        .admin-info strong {

            color: #583bd6;
        }



        /* ==========================================================
           24. SHORT LAPTOP
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


            .capability-row {

                margin-top: 13px;
            }


            .illustration-area {

                max-height: 160px;
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


            .role-pill {

                margin-bottom: 9px;
            }


            .card-back {

                margin-bottom: 10px;
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


            .help-row {

                margin-bottom: 11px;
            }


            .login-button {

                height: 44px;
            }


            .login-arrow {

                width: 31px;
                height: 31px;
            }


            .admin-info {

                margin-top: 12px;

                padding:
                    9px
                    12px;
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


            .auth-layout {

                display: block;

                overflow: visible;
            }


            .marketing-panel {

                min-height: 525px;
            }


            .illustration-area {

                height: 180px;

                min-height: 180px;

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
         MAIN
    =========================================================== -->

    <main class="auth-layout">


        <!-- ======================================================
             LEFT
        ======================================================= -->

        <section class="marketing-panel">


            <span class="spark spark-one"></span>

            <span class="spark spark-two"></span>

            <span class="spark spark-three"></span>


            <div class="dot-pattern"></div>



            <div class="marketing-content">


                <h1 class="marketing-heading">

                    CONTROL. CONFIGURE.
                    <br>

                    MONITOR. IMPROVE.

                    <span class="marketing-heading-highlight">

                        ONE PLATFORM. COMPLETE OVERSIGHT.

                    </span>

                </h1>



                <div class="accent-line"></div>



                <p class="marketing-description">

                    Manage CHAPERON users, government officers,
                    departments, approval rules, schemes and platform
                    performance from one secure administrative workspace.

                </p>


            </div>



            <!-- ==================================================
                 ADMIN CAPABILITIES
            =================================================== -->

            <div class="capability-row">


                <span class="capability-badge">

                    <span class="capability-dot"></span>

                    Departments

                </span>


                <span class="capability-badge">

                    <span class="capability-dot"></span>

                    Officers

                </span>


                <span class="capability-badge">

                    <span class="capability-dot"></span>

                    Approval Rules

                </span>


                <span class="capability-badge">

                    <span class="capability-dot"></span>

                    Analytics

                </span>


            </div>



            <!-- ==================================================
                 ADMIN DASHBOARD ILLUSTRATION
            =================================================== -->

            <div class="illustration-area">


                <svg
                    class="illustration-svg"
                    viewBox="0 0 760 250"
                    preserveAspectRatio="xMidYMax meet"
                    xmlns="http://www.w3.org/2000/svg">


                    <defs>


                        <linearGradient
                            id="adminPanelGradient"
                            x1="0"
                            y1="0"
                            x2="1"
                            y2="1">


                            <stop
                                offset="0%"
                                stop-color="#9f88ff"/>


                            <stop
                                offset="100%"
                                stop-color="#4c36c7"/>


                        </linearGradient>


                        <linearGradient
                            id="adminBarGradient"
                            x1="0"
                            y1="1"
                            x2="0"
                            y2="0">


                            <stop
                                offset="0%"
                                stop-color="#5840cc"/>


                            <stop
                                offset="100%"
                                stop-color="#a38cff"/>


                        </linearGradient>


                    </defs>



                    <!-- LEFT DASHBOARD WINDOW -->

                    <g>


                        <rect
                            x="55"
                            y="62"
                            width="270"
                            height="160"
                            rx="15"
                            fill="#3c2b9c"
                            opacity="0.90"/>


                        <rect
                            x="68"
                            y="76"
                            width="244"
                            height="132"
                            rx="10"
                            fill="#f6f2ff"
                            opacity="0.96"/>


                        <!-- HEADER -->

                        <rect
                            x="68"
                            y="76"
                            width="244"
                            height="23"
                            rx="10"
                            fill="#6951d7"/>


                        <circle
                            cx="84"
                            cy="87"
                            r="3"
                            fill="#ffffff"/>


                        <circle
                            cx="96"
                            cy="87"
                            r="3"
                            fill="#cfc5ff"/>


                        <circle
                            cx="108"
                            cy="87"
                            r="3"
                            fill="#a79aff"/>



                        <!-- PIE CHART -->

                        <circle
                            cx="129"
                            cy="147"
                            r="34"
                            fill="#7257dd"/>


                        <path
                            d="
                                M129 147
                                L129 113
                                A34 34 0 0 1 157 166
                                Z
                            "
                            fill="#a895ff"/>


                        <path
                            d="
                                M129 147
                                L157 166
                                A34 34 0 0 1 106 174
                                Z
                            "
                            fill="#4e37ba"/>



                        <!-- DATA LINES -->

                        <rect
                            x="184"
                            y="119"
                            width="93"
                            height="7"
                            rx="3"
                            fill="#7864d8"/>


                        <rect
                            x="184"
                            y="138"
                            width="70"
                            height="7"
                            rx="3"
                            fill="#a89bec"/>


                        <rect
                            x="184"
                            y="157"
                            width="100"
                            height="7"
                            rx="3"
                            fill="#d1c8f7"/>


                        <rect
                            x="184"
                            y="176"
                            width="80"
                            height="7"
                            rx="3"
                            fill="#8f7de1"/>


                    </g>



                    <!-- RIGHT ANALYTICS WINDOW -->

                    <g>


                        <rect
                            x="350"
                            y="39"
                            width="340"
                            height="183"
                            rx="15"
                            fill="#2c1b80"
                            opacity="0.94"/>


                        <rect
                            x="363"
                            y="53"
                            width="314"
                            height="155"
                            rx="10"
                            fill="#f8f6ff"/>


                        <!-- HEADER -->

                        <rect
                            x="363"
                            y="53"
                            width="314"
                            height="24"
                            rx="10"
                            fill="#5a41c6"/>


                        <circle
                            cx="379"
                            cy="65"
                            r="3"
                            fill="#ffffff"/>


                        <circle
                            cx="391"
                            cy="65"
                            r="3"
                            fill="#c8bcff"/>



                        <!-- LEFT SMALL CARD -->

                        <rect
                            x="380"
                            y="91"
                            width="80"
                            height="46"
                            rx="8"
                            fill="#ede8ff"/>


                        <rect
                            x="392"
                            y="102"
                            width="37"
                            height="7"
                            rx="3"
                            fill="#8068e3"/>


                        <rect
                            x="392"
                            y="116"
                            width="54"
                            height="7"
                            rx="3"
                            fill="#b7aaf0"/>



                        <!-- RIGHT SMALL CARD -->

                        <rect
                            x="475"
                            y="91"
                            width="80"
                            height="46"
                            rx="8"
                            fill="#ece7ff"/>


                        <rect
                            x="487"
                            y="102"
                            width="35"
                            height="7"
                            rx="3"
                            fill="#7255dd"/>


                        <rect
                            x="487"
                            y="116"
                            width="53"
                            height="7"
                            rx="3"
                            fill="#b7aaf0"/>



                        <!-- THIRD CARD -->

                        <rect
                            x="570"
                            y="91"
                            width="88"
                            height="46"
                            rx="8"
                            fill="#ece7ff"/>


                        <rect
                            x="582"
                            y="102"
                            width="41"
                            height="7"
                            rx="3"
                            fill="#674ace"/>


                        <rect
                            x="582"
                            y="116"
                            width="59"
                            height="7"
                            rx="3"
                            fill="#b7aaf0"/>



                        <!-- CHART BASE -->

                        <line
                            x1="392"
                            y1="187"
                            x2="649"
                            y2="187"
                            stroke="#d8d1ee"
                            stroke-width="2"/>


                        <!-- BARS -->

                        <rect
                            x="407"
                            y="159"
                            width="20"
                            height="28"
                            rx="3"
                            fill="url(#adminBarGradient)"/>


                        <rect
                            x="442"
                            y="142"
                            width="20"
                            height="45"
                            rx="3"
                            fill="url(#adminBarGradient)"/>


                        <rect
                            x="477"
                            y="151"
                            width="20"
                            height="36"
                            rx="3"
                            fill="url(#adminBarGradient)"/>


                        <rect
                            x="512"
                            y="125"
                            width="20"
                            height="62"
                            rx="3"
                            fill="url(#adminBarGradient)"/>


                        <rect
                            x="547"
                            y="136"
                            width="20"
                            height="51"
                            rx="3"
                            fill="url(#adminBarGradient)"/>


                        <rect
                            x="582"
                            y="112"
                            width="20"
                            height="75"
                            rx="3"
                            fill="url(#adminBarGradient)"/>


                        <rect
                            x="617"
                            y="130"
                            width="20"
                            height="57"
                            rx="3"
                            fill="url(#adminBarGradient)"/>


                    </g>



                    <!-- FLOATING SETTINGS -->

                    <g transform="translate(310 177)">


                        <circle
                            cx="0"
                            cy="0"
                            r="26"
                            fill="#7d63eb"/>


                        <circle
                            cx="0"
                            cy="0"
                            r="9"
                            fill="#eae4ff"/>


                        <g
                            stroke="#eae4ff"
                            stroke-width="6"
                            stroke-linecap="round">


                            <line
                                x1="0"
                                y1="-20"
                                x2="0"
                                y2="-15"/>


                            <line
                                x1="0"
                                y1="15"
                                x2="0"
                                y2="20"/>


                            <line
                                x1="-20"
                                y1="0"
                                x2="-15"
                                y2="0"/>


                            <line
                                x1="15"
                                y1="0"
                                x2="20"
                                y2="0"/>


                        </g>


                    </g>



                    <!-- GROUND -->

                    <rect
                        x="0"
                        y="225"
                        width="760"
                        height="25"
                        fill="#170d50"
                        opacity="0.82"/>


                </svg>


            </div>



            <!-- ==================================================
                 SECURITY
            =================================================== -->

            <div class="security-card">


                <div class="security-icon">


                    <svg
                        viewBox="0 0 24 24"
                        fill="none">


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
                        Restricted • Secure • Auditable
                    </strong>


                    <p>
                        Administrative access is protected and
                        intended only for authorized CHAPERON administrators.
                    </p>


                </div>


            </div>


        </section>



        <!-- ======================================================
             RIGHT LOGIN
        ======================================================= -->

        <section class="form-panel">


            <div class="login-card">



                <!-- BACK -->

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



                <!-- ROLE -->

                <div class="role-pill">


                    <span class="role-pill-dot"></span>


                    Administrator Portal


                </div>



                <!-- TITLE -->

                <h1 class="login-title">

                    Admin

                    <span>
                        Sign In
                    </span>

                </h1>



                <p class="login-subtitle">

                    Sign in to manage users, departments,
                    officers, approval rules and CHAPERON platform operations.

                </p>



                <!-- ==================================================
                     ERROR MESSAGE
                =================================================== -->

                <% if (request.getAttribute("errorMessage") != null) { %>


                    <div class="error-box">


                        <span class="error-icon">
                            !
                        </span>


                        <span>

                            <%= request.getAttribute("errorMessage") %>

                        </span>


                    </div>


                <% } %>



                <!-- ==================================================
                     FORM
                =================================================== -->

                <form
                    method="post"
                    action="<%= ctx %>/admin-login">



                    <!-- EMAIL -->

                    <div class="form-group">


                        <label
                            for="email"
                            class="form-label">

                            Administrator Email

                        </label>



                        <div class="input-wrapper">


                            <svg
                                class="input-icon"
                                viewBox="0 0 24 24"
                                fill="none">


                                <rect
                                    x="3"
                                    y="5"
                                    width="18"
                                    height="14"
                                    rx="2"
                                    stroke="currentColor"
                                    stroke-width="2"/>


                                <path
                                    d="M4 7L12 13L20 7"
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
                                placeholder="admin@chaperon.gov"
                                autocomplete="email"
                                required>


                        </div>


                    </div>



                    <!-- PASSWORD -->

                    <div class="form-group">


                        <label
                            for="password"
                            class="form-label">

                            Password

                        </label>



                        <div class="input-wrapper">


                            <svg
                                class="input-icon"
                                viewBox="0 0 24 24"
                                fill="none">


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
                                        M8 10V7
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
                                placeholder="Enter administrator password"
                                autocomplete="current-password"
                                required>



                            <button
                                type="button"
                                id="passwordToggle"
                                class="password-toggle"
                                onclick="togglePassword()"
                                aria-label="Show password">


                                <svg
                                    viewBox="0 0 24 24"
                                    fill="none">


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



                    <!-- FORGOT -->

                    <div class="help-row">


                        <a href="#">

                            Forgot Password?

                        </a>


                    </div>



                    <!-- LOGIN -->

                    <button
                        type="submit"
                        class="login-button">


                        <span>
                            Login as Administrator
                        </span>


                        <span class="login-arrow">
                            →
                        </span>


                    </button>


                </form>



                <!-- INFO -->

                <div class="admin-info">

                    <strong>Restricted administrative access.</strong>

                    Only authorized CHAPERON administrators
                    can access platform configuration and management.

                </div>


            </div>


        </section>


    </main>


</div>



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