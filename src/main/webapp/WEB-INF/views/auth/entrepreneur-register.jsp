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

    <title>Entrepreneur Registration | CHAPERON</title>

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
            background: #f4f8ff;
            color: #09173f;
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
                46% 54%;

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
                clamp(20px, 2.8vh, 36px)
                6%
                16px;

            display: flex;
            flex-direction: column;

            color: #ffffff;

            background:

                radial-gradient(
                    circle at 77% 18%,
                    rgba(0, 190, 255, 0.20),
                    transparent 28%
                ),

                radial-gradient(
                    circle at 20% 85%,
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
           09. LEFT CONTENT
        ========================================================== */

        .marketing-content {

            position: relative;

            z-index: 5;

            max-width: 560px;
        }


        .marketing-heading {

            margin-top:
                clamp(23px, 4.2vh, 46px);

            color: #ffffff;

            font-size:
                clamp(
                    27px,
                    2.5vw,
                    41px
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
                19px
                0
                17px;

            border-radius: 20px;

            background:
                linear-gradient(
                    90deg,
                    #0788ff,
                    #20e9ed
                );
        }


        .marketing-description {

            max-width: 500px;

            color: #dce8ff;

            font-size: 13px;

            line-height: 1.6;
        }



        /* ==========================================================
           10. BENEFITS
        ========================================================== */

        .benefit-list {

            position: relative;

            z-index: 5;

            display: grid;

            gap: 10px;

            margin-top: 18px;

            max-width: 465px;
        }


        .benefit-item {

            display: flex;
            align-items: center;

            gap: 11px;

            color: #e9f1ff;

            font-size: 12px;

            line-height: 1.4;
        }


        .benefit-check {

            width: 25px;
            height: 25px;

            flex-shrink: 0;

            border-radius: 50%;

            display: flex;
            align-items: center;
            justify-content: center;

            color: #ffffff;

            background:
                linear-gradient(
                    135deg,
                    #18baff,
                    #075df0
                );

            box-shadow:
                0 7px 16px
                rgba(0, 120, 255, 0.22);

            font-size: 12px;

            font-weight: 800;
        }



        /* ==========================================================
           11. ILLUSTRATION AREA
        ========================================================== */

        .illustration-area {

            position: relative;

            flex: 1;

            min-height: 100px;

            max-height: 180px;

            margin-top: 2px;

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
                    390px,
                    100%
                );

            display: flex;
            align-items: center;

            gap: 14px;

            min-height: 62px;

            margin-bottom: 6px;

            padding:
                9px 15px;

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
                rgba(0,0,50,0.16);

            backdrop-filter:
                blur(14px);
        }


        .security-icon {

            width: 44px;
            height: 44px;

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
        }


        .security-icon svg {

            width: 25px;
            height: 25px;
        }


        .security-copy strong {

            display: block;

            margin-bottom: 3px;

            color: #ffffff;

            font-size: 12px;
        }


        .security-copy p {

            color: #dce8ff;

            font-size: 10px;

            line-height: 1.4;
        }



        /* ==========================================================
           13. RIGHT PANEL
        ========================================================== */

        .form-panel {

            position: relative;

            min-width: 0;
            min-height: 0;

            padding:
                14px
                5%;

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
           14. REGISTER CARD
        ========================================================== */

        .register-card {

            width: 100%;

            max-width: 650px;

            padding:
                22px
                38px
                23px;

            border:
                1px solid
                rgba(37,99,210,0.10);

            border-radius: 22px;

            background:
                rgba(255,255,255,0.98);

            box-shadow:
                0 20px 50px
                rgba(37,80,145,0.12);
        }



        /* ==========================================================
           15. CARD BACK
        ========================================================== */

        .card-back {

            display: inline-flex;
            align-items: center;

            gap: 8px;

            margin-bottom: 11px;

            color: #4c6793;

            font-size: 12px;

            font-weight: 600;

            transition:
                color 0.2s ease;
        }


        .card-back:hover {

            color: #075bea;
        }


        .card-back-arrow {

            font-size: 18px;
        }



        /* ==========================================================
           16. TITLE
        ========================================================== */

        .register-title {

            margin-bottom: 5px;

            color: #07133c;

            font-size: 30px;

            line-height: 1.15;

            font-weight: 800;

            letter-spacing: -0.8px;
        }


        .register-title span {

            color: #075df0;
        }


        .register-subtitle {

            margin-bottom: 15px;

            color: #536d98;

            font-size: 12px;

            line-height: 1.45;
        }



        /* ==========================================================
           17. ERROR / SUCCESS
        ========================================================== */

        .message-box {

            display: flex;
            align-items: flex-start;

            gap: 8px;

            margin-bottom: 12px;

            padding:
                9px
                11px;

            border-radius: 9px;

            font-size: 11px;

            line-height: 1.45;
        }


        .error-box {

            border:
                1px solid #ffd0d0;

            background: #fff3f3;

            color: #a32b2b;
        }


        .success-box {

            border:
                1px solid #c9efd7;

            background: #effcf4;

            color: #126b34;
        }


        .message-icon {

            width: 18px;
            height: 18px;

            flex-shrink: 0;

            border-radius: 50%;

            display: flex;
            align-items: center;
            justify-content: center;

            color: #ffffff;

            font-size: 10px;

            font-weight: 800;
        }


        .error-box .message-icon {

            background: #d83e3e;
        }


        .success-box .message-icon {

            background: #159447;
        }



        /* ==========================================================
           18. FORM GRID
        ========================================================== */

        .form-grid {

            display: grid;

            grid-template-columns:
                repeat(2, minmax(0, 1fr));

            column-gap: 15px;

            row-gap: 10px;
        }


        .form-group {

            min-width: 0;
        }


        .full-width {

            grid-column:
                1 / -1;
        }


        .form-label {

            display: block;

            margin-bottom: 6px;

            color: #0b173b;

            font-size: 11px;

            font-weight: 700;
        }



        /* ==========================================================
           19. INPUTS
        ========================================================== */

        .input-wrapper {

            position: relative;

            width: 100%;
        }


        .input-icon {

            position: absolute;

            left: 13px;
            top: 50%;

            width: 18px;
            height: 18px;

            transform:
                translateY(-50%);

            color: #1767ea;

            pointer-events: none;
        }


        .form-input {

            width: 100%;
            height: 43px;

            padding:
                0
                42px
                0
                41px;

            border:
                1px solid #cad8ec;

            border-radius: 8px;

            outline: none;

            background: #ffffff;

            color: #14264b;

            font-size: 12px;

            transition:
                border-color 0.2s ease,
                box-shadow 0.2s ease;
        }


        .form-input::placeholder {

            color: #8999b1;
        }


        .form-input:focus {

            border-color: #1768ed;

            box-shadow:
                0 0 0 3px
                rgba(23,104,237,0.09);
        }



        /* ==========================================================
           20. PASSWORD TOGGLE
        ========================================================== */

        .password-toggle {

            position: absolute;

            right: 8px;
            top: 50%;

            width: 31px;
            height: 31px;

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
                0.2s ease;
        }


        .password-toggle:hover {

            background: #edf4ff;

            color: #075ee8;
        }


        .password-toggle svg {

            width: 18px;
            height: 18px;
        }



        /* ==========================================================
           21. PASSWORD STRENGTH TEXT
        ========================================================== */

        .password-help {

            margin-top: 5px;

            color: #7184a3;

            font-size: 9px;

            line-height: 1.35;
        }



        /* ==========================================================
           22. TERMS
        ========================================================== */

        .terms-row {

            display: flex;
            align-items: flex-start;

            gap: 8px;

            margin-top: 11px;
        }


        .terms-row input {

            width: 14px;
            height: 14px;

            margin-top: 1px;

            accent-color: #075df0;
        }


        .terms-row label {

            color: #60779c;

            font-size: 10px;

            line-height: 1.4;
        }


        .terms-row a {

            color: #075df0;

            font-weight: 700;
        }



        /* ==========================================================
           23. REGISTER BUTTON
        ========================================================== */

        .register-button {

            position: relative;

            width: 100%;
            height: 45px;

            margin-top: 13px;

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

            font-size: 13px;

            font-weight: 700;

            cursor: pointer;

            box-shadow:
                0 10px 22px
                rgba(0,85,226,0.20);

            transition:
                transform 0.2s ease,
                box-shadow 0.2s ease;
        }


        .register-button:hover {

            transform:
                translateY(-1px);

            box-shadow:
                0 13px 26px
                rgba(0,85,226,0.27);
        }


        .register-arrow {

            position: absolute;

            right: 7px;

            width: 31px;
            height: 31px;

            border-radius: 50%;

            display: flex;
            align-items: center;
            justify-content: center;

            background: #ffffff;

            color: #075df0;

            font-size: 18px;

            font-weight: 700;
        }



        /* ==========================================================
           24. DIVIDER
        ========================================================== */

        .divider {

            display: flex;
            align-items: center;

            gap: 12px;

            margin:
                12px
                0
                10px;

            color: #667c9f;

            font-size: 10px;

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
           25. LOGIN LINK
        ========================================================== */

        .login-row {

            text-align: center;

            color: #60779c;

            font-size: 11px;
        }


        .login-row a {

            margin-left: 4px;

            color: #075df0;

            font-weight: 700;
        }



        /* ==========================================================
           26. SHORT LAPTOP HEIGHT
        ========================================================== */

        @media (
            max-height: 760px
        ) and (
            min-width: 851px
        ) {

            .top-header {

                height: 66px;
                min-height: 66px;
            }

            .logo-crop {

                width: 47px;
                height: 47px;
            }

            .logo-crop img {

                width: 86px;
                height: 86px;

                left: -20px;
                top: -6px;
            }

            .brand-name {

                font-size: 22px;
            }

            .brand-tagline {

                font-size: 6px;
            }

            .marketing-panel {

                padding-top: 14px;
            }

            .marketing-heading {

                margin-top: 22px;

                font-size: 30px;
            }

            .accent-line {

                margin:
                    13px
                    0;
            }

            .marketing-description {

                font-size: 12px;
            }

            .benefit-list {

                margin-top: 12px;

                gap: 7px;
            }

            .benefit-item {

                font-size: 11px;
            }

            .benefit-check {

                width: 22px;
                height: 22px;
            }

            .illustration-area {

                max-height: 125px;
            }

            .security-card {

                min-height: 55px;

                padding:
                    7px
                    12px;
            }

            .security-icon {

                width: 38px;
                height: 38px;
            }

            .register-card {

                padding:
                    17px
                    30px;
            }

            .register-title {

                font-size: 27px;
            }

            .register-subtitle {

                margin-bottom: 11px;
            }

            .form-grid {

                row-gap: 7px;
            }

            .form-input {

                height: 39px;
            }

            .register-button {

                height: 41px;

                margin-top: 10px;
            }

            .divider {

                margin:
                    9px
                    0
                    8px;
            }
        }



        /* ==========================================================
           27. TABLET
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

                min-height: 530px;
            }

            .illustration-area {

                height: 165px;

                flex: none;
            }

            .form-panel {

                padding:
                    35px
                    18px;

                overflow: visible;
            }

            .register-card {

                max-width: 650px;
            }
        }



        /* ==========================================================
           28. MOBILE
        ========================================================== */

        @media (
            max-width: 620px
        ) {

            .top-header {

                padding:
                    5px
                    14px;
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

            .brand-name {

                font-size: 20px;
            }

            .brand-tagline {

                font-size: 5px;

                max-width: 150px;

                overflow: hidden;
            }

            .header-back {

                font-size: 10px;
            }

            .marketing-panel {

                padding:
                    30px
                    22px
                    25px;
            }

            .marketing-heading {

                font-size: 27px;
            }

            .form-grid {

                grid-template-columns:
                    1fr;
            }

            .full-width {

                grid-column:
                    auto;
            }

            .register-card {

                padding:
                    25px
                    19px;
            }

            .register-title {

                font-size: 28px;
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

                    START YOUR BUSINESS
                    <br>

                    APPROVAL JOURNEY —

                    <span class="marketing-heading-highlight">

                        GUIDED FROM DAY ONE

                    </span>

                </h1>



                <div class="accent-line"></div>



                <p class="marketing-description">

                    Create your CHAPERON account and build one
                    connected approval journey for your business,
                    documents, applications, inspections and compliance.

                </p>


            </div>



            <!-- BENEFITS -->

            <div class="benefit-list">


                <div class="benefit-item">

                    <span class="benefit-check">
                        ✓
                    </span>

                    <span>
                        Discover approvals applicable to your business profile.
                    </span>

                </div>


                <div class="benefit-item">

                    <span class="benefit-check">
                        ✓
                    </span>

                    <span>
                        Maintain reusable documents in one secure place.
                    </span>

                </div>


                <div class="benefit-item">

                    <span class="benefit-check">
                        ✓
                    </span>

                    <span>
                        Track applications, inspections and next actions.
                    </span>

                </div>


            </div>



            <!-- ==================================================
                 ILLUSTRATION
            =================================================== -->

            <div class="illustration-area">


                <svg
                    class="illustration-svg"
                    viewBox="0 0 760 230"
                    preserveAspectRatio="xMidYMax meet"
                    xmlns="http://www.w3.org/2000/svg">


                    <defs>


                        <linearGradient
                            id="cityGradient"
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



                    <!-- CITY -->

                    <rect
                        x="70"
                        y="115"
                        width="55"
                        height="90"
                        rx="3"
                        fill="#2468d8"/>


                    <rect
                        x="138"
                        y="77"
                        width="68"
                        height="128"
                        rx="3"
                        fill="url(#cityGradient)"/>


                    <rect
                        x="220"
                        y="126"
                        width="55"
                        height="79"
                        rx="3"
                        fill="#3074de"/>


                    <rect
                        x="289"
                        y="100"
                        width="65"
                        height="105"
                        rx="3"
                        fill="#2866d1"/>



                    <!-- WINDOWS -->

                    <g fill="#9bc9ff">


                        <rect
                            x="84"
                            y="132"
                            width="10"
                            height="12"/>

                        <rect
                            x="103"
                            y="132"
                            width="10"
                            height="12"/>


                        <rect
                            x="153"
                            y="94"
                            width="11"
                            height="13"/>

                        <rect
                            x="176"
                            y="94"
                            width="11"
                            height="13"/>


                        <rect
                            x="153"
                            y="120"
                            width="11"
                            height="13"/>

                        <rect
                            x="176"
                            y="120"
                            width="11"
                            height="13"/>


                        <rect
                            x="303"
                            y="117"
                            width="11"
                            height="13"/>

                        <rect
                            x="326"
                            y="117"
                            width="11"
                            height="13"/>


                    </g>



                    <!-- GOVERNMENT BUILDING -->

                    <g transform="translate(405 8)">


                        <rect
                            x="165"
                            y="0"
                            width="4"
                            height="36"
                            fill="#76bdff"/>


                        <path
                            d="M169 4 L191 9 L169 15Z"
                            fill="#559af1"/>


                        <path
                            d="
                                M112 69
                                C112 34 137 15 167 15
                                C197 15 222 34 222 69
                                Z
                            "
                            fill="url(#governmentGradient)"/>


                        <rect
                            x="103"
                            y="67"
                            width="128"
                            height="12"
                            rx="2"
                            fill="#a2d0ff"/>


                        <path
                            d="
                                M76 98
                                L167 68
                                L258 98
                                Z
                            "
                            fill="#72adef"/>


                        <rect
                            x="84"
                            y="98"
                            width="166"
                            height="83"
                            fill="#508fdd"/>


                        <g fill="#c0e2ff">

                            <rect
                                x="100"
                                y="106"
                                width="16"
                                height="67"/>

                            <rect
                                x="128"
                                y="106"
                                width="16"
                                height="67"/>

                            <rect
                                x="156"
                                y="106"
                                width="16"
                                height="67"/>

                            <rect
                                x="184"
                                y="106"
                                width="16"
                                height="67"/>

                            <rect
                                x="212"
                                y="106"
                                width="16"
                                height="67"/>

                        </g>


                        <rect
                            x="67"
                            y="177"
                            width="200"
                            height="9"
                            fill="#73aaec"/>


                        <rect
                            x="56"
                            y="186"
                            width="222"
                            height="9"
                            fill="#508bdc"/>


                    </g>



                    <!-- GROUND -->

                    <rect
                        x="0"
                        y="202"
                        width="760"
                        height="28"
                        fill="#07388f"
                        opacity="0.80"/>


                </svg>


            </div>



            <!-- SECURITY -->

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
                        Secure • Guided • Transparent
                    </strong>


                    <p>
                        Your account begins one connected
                        industrial approval journey.
                    </p>


                </div>


            </div>


        </section>



        <!-- ======================================================
             RIGHT
        ======================================================= -->

        <section class="form-panel">


            <div class="register-card">


                <a
                    href="<%= ctx %>/"
                    class="card-back">


                    <span class="card-back-arrow">
                        ←
                    </span>


                    Back to CHAPERON


                </a>



                <h1 class="register-title">

                    Create Your
                    <span>Account</span>

                </h1>


                <p class="register-subtitle">

                    Register as an Entrepreneur / Investor
                    and begin your guided approval journey.

                </p>



                <!-- ==================================================
                     EXISTING ERROR MESSAGE SUPPORT
                =================================================== -->

                <% if (request.getAttribute("errorMessage") != null) { %>

                    <div class="message-box error-box">

                        <span class="message-icon">
                            !
                        </span>

                        <span>
                            <%= request.getAttribute("errorMessage") %>
                        </span>

                    </div>

                <% } %>



                <% if (request.getAttribute("successMessage") != null) { %>

                    <div class="message-box success-box">

                        <span class="message-icon">
                            ✓
                        </span>

                        <span>
                            <%= request.getAttribute("successMessage") %>
                        </span>

                    </div>

                <% } %>



                <!-- ==================================================
                     REGISTRATION FORM
                =================================================== -->

                <form
                    method="post"
                    action="<%= ctx %>/entrepreneur-register"
                    onsubmit="return validateRegistrationForm();">


                    <div class="form-grid">


                        <!-- FULL NAME -->

                        <div class="form-group">


                            <label
                                for="fullName"
                                class="form-label">

                                Full Name

                            </label>


                            <div class="input-wrapper">


                                <svg
                                    class="input-icon"
                                    viewBox="0 0 24 24"
                                    fill="none">


                                    <circle
                                        cx="12"
                                        cy="8"
                                        r="4"
                                        stroke="currentColor"
                                        stroke-width="2"/>


                                    <path
                                        d="
                                            M4.5 21
                                            C4.8 16.4 7.4 14 12 14
                                            C16.6 14 19.2 16.4 19.5 21
                                        "
                                        stroke="currentColor"
                                        stroke-width="2"
                                        stroke-linecap="round"/>


                                </svg>


                                <input
                                    type="text"
                                    id="fullName"
                                    name="fullName"
                                    class="form-input"
                                    placeholder="Enter your full name"
                                    autocomplete="name"
                                    required>


                            </div>


                        </div>



                        <!-- MOBILE -->

                        <div class="form-group">


                            <label
                                for="mobile"
                                class="form-label">

                                Mobile Number

                            </label>


                            <div class="input-wrapper">


                                <svg
                                    class="input-icon"
                                    viewBox="0 0 24 24"
                                    fill="none">


                                    <rect
                                        x="6"
                                        y="2.5"
                                        width="12"
                                        height="19"
                                        rx="2.5"
                                        stroke="currentColor"
                                        stroke-width="2"/>


                                    <path
                                        d="M10 18H14"
                                        stroke="currentColor"
                                        stroke-width="2"
                                        stroke-linecap="round"/>


                                </svg>


                                <input
                                    type="tel"
                                    id="mobile"
                                    name="mobile"
                                    class="form-input"
                                    placeholder="Enter mobile number"
                                    autocomplete="tel"
                                    maxlength="10"
                                    required>


                            </div>


                        </div>



                        <!-- EMAIL -->

                        <div class="form-group full-width">


                            <label
                                for="email"
                                class="form-label">

                                Email Address

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
                                    placeholder="you@example.com"
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
                                    placeholder="Create password"
                                    autocomplete="new-password"
                                    minlength="6"
                                    required>


                                <button
                                    type="button"
                                    class="password-toggle"
                                    onclick="togglePassword('password', this)"
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


                            <div class="password-help">
                                Use at least 6 characters.
                            </div>


                        </div>



                        <!-- CONFIRM PASSWORD -->

                        <div class="form-group">


                            <label
                                for="confirmPassword"
                                class="form-label">

                                Confirm Password

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
                                    id="confirmPassword"
                                    name="confirmPassword"
                                    class="form-input"
                                    placeholder="Confirm password"
                                    autocomplete="new-password"
                                    minlength="6"
                                    required>


                                <button
                                    type="button"
                                    class="password-toggle"
                                    onclick="togglePassword('confirmPassword', this)"
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


                            <div
                                id="passwordMatchMessage"
                                class="password-help">

                                Re-enter the same password.
                            </div>


                        </div>


                    </div>



                    <!-- TERMS -->

                    <div class="terms-row">


                        <input
                            type="checkbox"
                            id="terms"
                            required>


                        <label for="terms">

                            I agree to use CHAPERON for
                            legitimate business approval and compliance activities.

                        </label>


                    </div>



                    <!-- REGISTER -->

                    <button
                        type="submit"
                        class="register-button">


                        Create Account


                        <span class="register-arrow">
                            →
                        </span>


                    </button>


                </form>



                <!-- DIVIDER -->

                <div class="divider">
                    OR
                </div>



                <!-- LOGIN -->

                <div class="login-row">

                    Already have a CHAPERON account?

                    <a href="<%= ctx %>/entrepreneur-login">
                        Login Here
                    </a>

                </div>


            </div>


        </section>


    </main>


</div>



<script>

    function togglePassword(inputId, button) {

        const input =
            document.getElementById(inputId);


        if (input.type === "password") {

            input.type = "text";

            button.setAttribute(
                "aria-label",
                "Hide password"
            );

        } else {

            input.type = "password";

            button.setAttribute(
                "aria-label",
                "Show password"
            );

        }

    }



    function validateRegistrationForm() {

        const password =
            document.getElementById("password").value;

        const confirmPassword =
            document.getElementById("confirmPassword").value;

        const mobile =
            document.getElementById("mobile").value.trim();


        if (password !== confirmPassword) {

            alert(
                "Password and Confirm Password do not match."
            );

            return false;
        }


        const mobilePattern =
            /^[0-9]{10}$/;


        if (!mobilePattern.test(mobile)) {

            alert(
                "Please enter a valid 10-digit mobile number."
            );

            return false;
        }


        return true;
    }



    document
        .getElementById("confirmPassword")
        .addEventListener(
            "input",
            function () {

                const password =
                    document.getElementById("password").value;

                const confirmPassword =
                    this.value;

                const message =
                    document.getElementById("passwordMatchMessage");


                if (confirmPassword.length === 0) {

                    message.textContent =
                        "Re-enter the same password.";

                    message.style.color =
                        "#7184a3";

                    return;
                }


                if (password === confirmPassword) {

                    message.textContent =
                        "Passwords match.";

                    message.style.color =
                        "#138a42";

                } else {

                    message.textContent =
                        "Passwords do not match.";

                    message.style.color =
                        "#c73a3a";

                }

            }
        );

</script>


</body>

</html>