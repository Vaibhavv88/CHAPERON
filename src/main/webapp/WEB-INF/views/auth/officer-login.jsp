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

    <title>Government Officer Login | CHAPERON</title>


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
            font-family: Arial, Helvetica, sans-serif;

            color: #081a34;

            background: #f4faf7;

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
                    rgba(41, 173, 111, 0.09),
                    transparent 30%
                ),

                linear-gradient(
                    135deg,
                    #ffffff 0%,
                    #f1faf6 100%
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
                1px solid #e5efe9;

            box-shadow:
                0 5px 18px
                rgba(22, 68, 60, 0.045);

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

            color: #098647;

            font-size: 14px;

            font-weight: 700;

            transition:
                color 0.2s ease,
                transform 0.2s ease;
        }


        .header-back:hover {

            color: #05602f;

            transform:
                translateX(-2px);
        }


        .header-back-arrow {

            font-size: 21px;

            line-height: 1;
        }



        /* ==========================================================
           06. MAIN SPLIT
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
           07. LEFT PANEL
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
                    circle at 76% 20%,
                    rgba(34, 232, 151, 0.17),
                    transparent 27%
                ),

                radial-gradient(
                    circle at 20% 85%,
                    rgba(19, 137, 92, 0.32),
                    transparent 35%
                ),

                linear-gradient(
                    145deg,
                    #075f45 0%,
                    #064b3c 42%,
                    #033228 100%
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

            background: #27e69b;
        }


        .spark-two {

            width: 18px;
            height: 18px;

            top: 26px;
            left: 92px;

            background: #2ea0ff;
        }


        .spark-three {

            width: 10px;
            height: 10px;

            top: 69px;
            left: 104px;

            background: #8af6cb;
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
                    #2de3a0 2px,
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
                    #42f2bc,
                    #16c98c
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
                    #21e69e,
                    #2f9cff
                );
        }


        .marketing-description {

            max-width: 510px;

            color: #d9f4e9;

            font-size: 14px;

            line-height: 1.65;
        }



        /* ==========================================================
           10. WORKFLOW BADGES
        ========================================================== */

        .workflow-row {

            position: relative;

            z-index: 5;

            display: flex;
            flex-wrap: wrap;

            gap: 9px;

            margin-top: 20px;
        }


        .workflow-badge {

            display: inline-flex;
            align-items: center;

            gap: 6px;

            padding:
                7px
                11px;

            border-radius: 100px;

            border:
                1px solid
                rgba(255,255,255,0.15);

            background:
                rgba(255,255,255,0.08);

            color: #e6fff4;

            font-size: 10px;

            font-weight: 600;

            backdrop-filter:
                blur(8px);
        }


        .workflow-dot {

            width: 7px;
            height: 7px;

            border-radius: 50%;

            background: #35eba8;
        }



        /* ==========================================================
           11. ILLUSTRATION
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
           12. SECURITY PANEL
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
                rgba(0,0,30,0.16);

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
                    #15bd78,
                    #078f56
                );

            box-shadow:
                0 9px 22px
                rgba(7, 151, 88, 0.26);
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

            color: #d9f4e9;

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
                    rgba(43, 185, 111, 0.09),
                    transparent 39%
                ),

                linear-gradient(
                    135deg,
                    #fbfefd 0%,
                    #eef8f3 100%
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
                rgba(30, 140, 83, 0.11);

            border-radius: 22px;

            background:
                rgba(255,255,255,0.98);

            box-shadow:
                0 20px 50px
                rgba(37, 105, 76, 0.12);
        }



        /* ==========================================================
           15. CARD BACK
        ========================================================== */

        .card-back {

            display: inline-flex;
            align-items: center;

            gap: 8px;

            margin-bottom: 15px;

            color: #587267;

            font-size: 13px;

            font-weight: 600;

            transition:
                color 0.2s ease;
        }


        .card-back:hover {

            color: #078947;
        }


        .card-back-arrow {

            font-size: 19px;

            line-height: 1;
        }



        /* ==========================================================
           16. TITLE
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

            background: #edf9f2;

            color: #098b4a;

            font-size: 10px;

            font-weight: 700;

            border:
                1px solid #d5f0e1;
        }


        .role-pill-dot {

            width: 7px;
            height: 7px;

            border-radius: 50%;

            background: #0ca759;
        }


        .login-title {

            margin-bottom: 6px;

            color: #071b34;

            font-size: 34px;

            line-height: 1.15;

            font-weight: 800;

            letter-spacing: -1px;
        }


        .login-title span {

            color: #07904d;
        }


        .login-subtitle {

            margin-bottom: 20px;

            color: #587568;

            font-size: 13px;

            line-height: 1.5;
        }



        /* ==========================================================
           17. ERROR
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
           18. FORM
        ========================================================== */

        .form-group {

            margin-bottom: 14px;
        }


        .form-label {

            display: block;

            margin-bottom: 7px;

            color: #0b2730;

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

            color: #07904d;

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
                1px solid #c9ddd3;

            border-radius: 8px;

            outline: none;

            background: #ffffff;

            color: #163428;

            font-size: 13px;

            transition:
                border-color 0.2s ease,
                box-shadow 0.2s ease;
        }


        .form-input::placeholder {

            color: #879d93;
        }


        .form-input:focus {

            border-color: #12985a;

            box-shadow:
                0 0 0 3px
                rgba(18, 152, 90, 0.09);
        }



        /* ==========================================================
           19. PASSWORD TOGGLE
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

            color: #4d7060;

            cursor: pointer;

            transition:
                color 0.2s ease,
                background 0.2s ease;
        }


        .password-toggle:hover {

            color: #078947;

            background: #edf8f2;
        }


        .password-toggle svg {

            width: 20px;
            height: 20px;
        }



        /* ==========================================================
           20. HELP
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

            color: #078947;

            font-size: 12px;

            font-weight: 600;
        }


        .help-row a:hover {

            text-decoration: underline;
        }



        /* ==========================================================
           21. LOGIN BUTTON
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
                    #0aa759,
                    #078b49
                );

            color: #ffffff;

            font-size: 14px;

            font-weight: 700;

            cursor: pointer;

            box-shadow:
                0 10px 22px
                rgba(7, 139, 73, 0.20);

            transition:
                transform 0.2s ease,
                box-shadow 0.2s ease;
        }


        .login-button:hover {

            transform:
                translateY(-1px);

            box-shadow:
                0 13px 26px
                rgba(7, 139, 73, 0.28);
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

            color: #078b49;

            font-size: 20px;

            font-weight: 700;
        }



        /* ==========================================================
           22. INFO
        ========================================================== */

        .officer-info {

            margin-top: 18px;

            padding:
                13px
                15px;

            border-radius: 10px;

            background: #f3faf6;

            border:
                1px solid #deefe5;

            color: #5a7367;

            font-size: 11px;

            line-height: 1.5;

            text-align: center;
        }


        .officer-info strong {

            color: #087e44;
        }



        /* ==========================================================
           23. SHORT LAPTOP
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


            .workflow-row {

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


            .officer-info {

                margin-top: 12px;

                padding:
                    9px
                    12px;
            }
        }



        /* ==========================================================
           24. TABLET
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
           25. MOBILE
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
             LEFT PANEL
        ======================================================= -->

        <section class="marketing-panel">


            <span class="spark spark-one"></span>

            <span class="spark spark-two"></span>

            <span class="spark spark-three"></span>


            <div class="dot-pattern"></div>



            <div class="marketing-content">


                <h1 class="marketing-heading">

                    REVIEW. VERIFY.
                    <br>

                    INSPECT. APPROVE.

                    <span class="marketing-heading-highlight">

                        GOVERN WITH CONFIDENCE

                    </span>

                </h1>



                <div class="accent-line"></div>



                <p class="marketing-description">

                    Access your assigned applications, verify documents,
                    respond to applicant submissions, manage inspections
                    and deliver transparent approval decisions.

                </p>


            </div>



            <!-- ==================================================
                 OFFICER WORKFLOW
            =================================================== -->

            <div class="workflow-row">


                <span class="workflow-badge">

                    <span class="workflow-dot"></span>

                    Application Review

                </span>


                <span class="workflow-badge">

                    <span class="workflow-dot"></span>

                    Document Verification

                </span>


                <span class="workflow-badge">

                    <span class="workflow-dot"></span>

                    Inspections

                </span>


                <span class="workflow-badge">

                    <span class="workflow-dot"></span>

                    Approval Decisions

                </span>


            </div>



            <!-- ==================================================
                 GOVERNMENT BUILDING ILLUSTRATION
            =================================================== -->

            <div class="illustration-area">


                <svg
                    class="illustration-svg"
                    viewBox="0 0 760 250"
                    preserveAspectRatio="xMidYMax meet"
                    xmlns="http://www.w3.org/2000/svg">


                    <defs>


                        <linearGradient
                            id="officerGovernmentGradient"
                            x1="0"
                            y1="0"
                            x2="0"
                            y2="1">


                            <stop
                                offset="0%"
                                stop-color="#9ae4c2"/>


                            <stop
                                offset="100%"
                                stop-color="#279a69"/>


                        </linearGradient>


                        <linearGradient
                            id="officerCityGradient"
                            x1="0"
                            y1="0"
                            x2="0"
                            y2="1">


                            <stop
                                offset="0%"
                                stop-color="#32b57d"/>


                            <stop
                                offset="100%"
                                stop-color="#08714c"/>


                        </linearGradient>


                    </defs>



                    <!-- CLOUDS -->

                    <g
                        fill="#2bab78"
                        opacity="0.44">


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
                                M609 96
                                C616 82 632 82 640 93
                                C648 86 662 88 667 101
                                H603
                                C603 99 606 97 609 96
                                Z
                            "/>


                    </g>



                    <!-- SMALL CITY -->

                    <g>


                        <rect
                            x="68"
                            y="145"
                            width="52"
                            height="80"
                            rx="3"
                            fill="#167954"/>


                        <rect
                            x="133"
                            y="110"
                            width="64"
                            height="115"
                            rx="3"
                            fill="url(#officerCityGradient)"/>


                        <rect
                            x="210"
                            y="155"
                            width="52"
                            height="70"
                            rx="3"
                            fill="#178b5e"/>


                        <g
                            fill="#9fe4c5">


                            <rect
                                x="81"
                                y="159"
                                width="9"
                                height="11"/>


                            <rect
                                x="99"
                                y="159"
                                width="9"
                                height="11"/>


                            <rect
                                x="147"
                                y="126"
                                width="10"
                                height="12"/>


                            <rect
                                x="168"
                                y="126"
                                width="10"
                                height="12"/>


                            <rect
                                x="147"
                                y="151"
                                width="10"
                                height="12"/>


                            <rect
                                x="168"
                                y="151"
                                width="10"
                                height="12"/>


                        </g>


                    </g>



                    <!-- GOVERNMENT BUILDING -->

                    <g transform="translate(330 12)">


                        <!-- FLAG -->

                        <rect
                            x="190"
                            y="0"
                            width="4"
                            height="43"
                            fill="#9ce7c4"/>


                        <path
                            d="
                                M194 4
                                L221 10
                                L194 17
                                Z
                            "
                            fill="#36bf83"/>



                        <!-- DOME -->

                        <path
                            d="
                                M127 81
                                C127 40 155 19 192 19
                                C229 19 257 40 257 81
                                Z
                            "
                            fill="url(#officerGovernmentGradient)"/>


                        <path
                            d="
                                M145 81
                                C145 52 166 35 192 35
                                C218 35 239 52 239 81
                                Z
                            "
                            fill="#68cc9c"/>



                        <!-- BASE -->

                        <rect
                            x="115"
                            y="78"
                            width="154"
                            height="14"
                            rx="2"
                            fill="#a2e8c9"/>



                        <!-- ROOF -->

                        <path
                            d="
                                M73 116
                                L192 81
                                L311 116
                                Z
                            "
                            fill="#60bf8e"/>



                        <!-- BODY -->

                        <rect
                            x="83"
                            y="116"
                            width="218"
                            height="94"
                            fill="#29966b"/>



                        <!-- COLUMNS -->

                        <g
                            fill="#bbefd6">


                            <rect
                                x="103"
                                y="124"
                                width="19"
                                height="77"/>


                            <rect
                                x="141"
                                y="124"
                                width="19"
                                height="77"/>


                            <rect
                                x="179"
                                y="124"
                                width="19"
                                height="77"/>


                            <rect
                                x="217"
                                y="124"
                                width="19"
                                height="77"/>


                            <rect
                                x="255"
                                y="124"
                                width="19"
                                height="77"/>


                        </g>



                        <!-- STEPS -->

                        <rect
                            x="66"
                            y="207"
                            width="252"
                            height="9"
                            fill="#52b381"/>


                        <rect
                            x="52"
                            y="216"
                            width="280"
                            height="9"
                            fill="#308d66"/>


                    </g>



                    <!-- TREES -->

                    <g>


                        <rect
                            x="27"
                            y="198"
                            width="5"
                            height="29"
                            fill="#09593d"/>


                        <circle
                            cx="29"
                            cy="188"
                            r="19"
                            fill="#19ac6e"/>



                        <rect
                            x="295"
                            y="198"
                            width="5"
                            height="29"
                            fill="#09593d"/>


                        <circle
                            cx="297"
                            cy="188"
                            r="19"
                            fill="#29c585"/>



                        <rect
                            x="718"
                            y="198"
                            width="5"
                            height="29"
                            fill="#09593d"/>


                        <circle
                            cx="720"
                            cy="188"
                            r="19"
                            fill="#22a96d"/>


                    </g>



                    <!-- GROUND -->

                    <rect
                        x="0"
                        y="223"
                        width="760"
                        height="27"
                        fill="#063e31"
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
                        Authorized • Secure • Accountable
                    </strong>


                    <p>
                        Officer access is protected and
                        all workflow actions remain traceable.
                    </p>


                </div>


            </div>


        </section>



        <!-- ======================================================
             RIGHT
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



                <!-- ROLE BADGE -->

                <div class="role-pill">


                    <span class="role-pill-dot"></span>


                    Government Officer Portal


                </div>



                <!-- TITLE -->

                <h1 class="login-title">

                    Officer

                    <span>
                        Sign In
                    </span>

                </h1>



                <p class="login-subtitle">

                    Sign in using your authorized officer credentials
                    to review and manage assigned applications.

                </p>



                <!-- ==================================================
                     ERROR
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
                     LOGIN FORM
                =================================================== -->

                <form
                    method="post"
                    action="<%= ctx %>/officer-login">



                    <!-- EMAIL -->

                    <div class="form-group">


                        <label
                            for="email"
                            class="form-label">

                            Official Email Address

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
                                placeholder="officer@department.gov"
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
                                placeholder="Enter your password"
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



                    <!-- HELP -->

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
                            Login as Government Officer
                        </span>


                        <span class="login-arrow">
                            →
                        </span>


                    </button>


                </form>



                <!-- OFFICER INFO -->

                <div class="officer-info">

                    <strong>Authorized access only.</strong>

                    Officer accounts are created and managed by
                    CHAPERON administrators.

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