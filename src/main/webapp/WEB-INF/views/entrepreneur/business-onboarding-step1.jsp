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

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f5f8fc;
            color: #14213d;
        }

        .topbar {
            height: 70px;
            background: #ffffff;
            border-bottom: 1px solid #e5eaf0;

            display: flex;
            align-items: center;
            justify-content: space-between;

            padding: 0 6%;
        }

        .logo {
            font-size: 25px;
            font-weight: 800;
            color: #0b1f3a;
        }

        .top-text {
            color: #718096;
            font-size: 14px;
        }

        .page {
            min-height: calc(100vh - 70px);
            padding: 45px 20px;
        }

        .container {
            max-width: 850px;
            margin: auto;
        }

        .back-link {
            display: inline-block;
            text-decoration: none;
            color: #5e6d82;
            font-size: 14px;
            margin-bottom: 25px;
        }

        .back-link:hover {
            color: #1677e8;
        }

        .step-header {
            display: flex;
            justify-content: space-between;
            align-items: center;

            margin-bottom: 12px;
        }

        .step-label {
            color: #1677e8;
            font-size: 14px;
            font-weight: 700;
        }

        .percentage {
            color: #66758a;
            font-size: 14px;
        }

        .progress {
            height: 8px;
            background: #e3eaf3;
            border-radius: 20px;
            overflow: hidden;

            margin-bottom: 35px;
        }

        .progress-bar {
            width: 20%;
            height: 100%;
            background: #1677e8;
            border-radius: 20px;
        }

        .card {
            background: #ffffff;
            border: 1px solid #e6ebf1;
            border-radius: 18px;

            padding: 38px;

            box-shadow:
                0 10px 30px rgba(21, 45, 80, 0.07);
        }

        .card h1 {
            font-size: 30px;
            color: #10213b;
            margin-bottom: 10px;
        }

        .intro {
            color: #6d7b8e;
            line-height: 1.6;
            margin-bottom: 30px;
        }

        .error-box {
            background: #fff1f1;
            border: 1px solid #f3caca;
            color: #a62c2c;

            padding: 13px 15px;
            border-radius: 9px;

            margin-bottom: 22px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        label {
            display: block;

            font-weight: 700;
            font-size: 15px;

            margin-bottom: 9px;

            color: #263750;
        }

        .required {
            color: #d13c3c;
        }

        .help {
            font-weight: normal;
            color: #7b889a;
            font-size: 13px;
        }

        input[type="text"],
        select {

            width: 100%;
            height: 50px;

            border: 1px solid #ccd6e2;
            border-radius: 10px;

            padding: 0 14px;

            font-size: 15px;
            color: #263750;

            background: #ffffff;

            outline: none;

            transition: 0.2s;
        }

        input[type="text"]:focus,
        select:focus {

            border-color: #1677e8;

            box-shadow:
                0 0 0 3px rgba(22, 119, 232, 0.10);
        }

        .activity-options {

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 12px;
        }

        .activity-card {

            position: relative;

            border: 1px solid #d7e0ea;

            border-radius: 12px;

            padding: 18px;

            cursor: pointer;

            transition: 0.2s;

            background: #ffffff;
        }

        .activity-card:hover {
            border-color: #1677e8;
            background: #f7fbff;
        }

        .activity-card input {
            margin-right: 7px;
        }

        .activity-title {
            font-weight: 700;
            color: #263750;
        }

        .activity-description {

            display: block;

            color: #7c8999;

            font-size: 12px;

            margin-top: 7px;

            line-height: 1.4;
        }

        .info-box {

            background: #eef6ff;

            border: 1px solid #d6e9ff;

            border-radius: 12px;

            padding: 16px;

            margin-top: 10px;

            color: #46627e;

            line-height: 1.5;

            font-size: 14px;
        }

        .actions {

            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-top: 35px;
        }

        .cancel-btn {

            text-decoration: none;

            color: #627187;

            padding: 13px 18px;

            border-radius: 9px;

            font-weight: 600;
        }

        .continue-btn {

            border: none;

            background: #1677e8;

            color: #ffffff;

            padding: 14px 25px;

            border-radius: 10px;

            font-size: 15px;

            font-weight: 700;

            cursor: pointer;

            transition: 0.2s;
        }

        .continue-btn:hover {
            background: #0e67cb;
            transform: translateY(-1px);
        }

        .save-note {

            text-align: center;

            color: #8a96a5;

            font-size: 13px;

            margin-top: 20px;
        }

        @media (max-width: 700px) {

            .topbar {
                padding: 0 20px;
            }

            .top-text {
                display: none;
            }

            .page {
                padding: 25px 15px;
            }

            .card {
                padding: 25px 20px;
            }

            .card h1 {
                font-size: 25px;
            }

            .activity-options {
                grid-template-columns: 1fr;
            }

            .actions {
                flex-direction: column-reverse;
                gap: 12px;
            }

            .continue-btn,
            .cancel-btn {
                width: 100%;
                text-align: center;
            }
        }

    </style>

</head>

<body>

<div class="topbar">

    <div class="logo">
        CHAPERON
    </div>

    <div class="top-text">
        Your guided business approval journey
    </div>

</div>


<div class="page">

    <div class="container">

        <a class="back-link"
           href="<%= request.getContextPath() %>/entrepreneur/dashboard">

            ← Back to Dashboard

        </a>


        <div class="step-header">

            <div class="step-label">
                STEP 1 OF 5
            </div>

            <div class="percentage">
                20% Complete
            </div>

        </div>


        <div class="progress">

            <div class="progress-bar"></div>

        </div>


        <div class="card">

            <h1>
                Tell us about your business
            </h1>

            <p class="intro">

                Start with the basics. CHAPERON will use
                this information to understand your business
                and identify approvals that may apply to you.

            </p>


            <% if (errorMessage != null) { %>

                <div class="error-box">
                    <%= errorMessage %>
                </div>

            <% } %>


            <form method="post"
                  action="<%= request.getContextPath() %>/entrepreneur/business-onboarding">


                <!-- BUSINESS NAME -->

                <div class="form-group">

                    <label for="businessName">

                        Business Name
                        <span class="required">*</span>

                    </label>

                    <input type="text"
                           id="businessName"
                           name="businessName"
                           value="<%= businessName %>"
                           placeholder="Example: ABC Foods Pvt Ltd"
                           maxlength="150"
                           required>

                </div>


                <!-- BUSINESS CONSTITUTION -->

                <div class="form-group">

                    <label for="businessConstitution">

                        Business Constitution
                        <span class="required">*</span>

                        <span class="help">
                            — How is your business legally structured?
                        </span>

                    </label>

                    <select id="businessConstitution"
                            name="businessConstitution"
                            required>

                        <option value="">
                            Select business constitution
                        </option>

                        <option value="Proprietorship"
                            <%= "Proprietorship".equals(businessConstitution)
                                    ? "selected" : "" %>>
                            Proprietorship
                        </option>

                        <option value="Partnership"
                            <%= "Partnership".equals(businessConstitution)
                                    ? "selected" : "" %>>
                            Partnership
                        </option>

                        <option value="LLP"
                            <%= "LLP".equals(businessConstitution)
                                    ? "selected" : "" %>>
                            LLP
                        </option>

                        <option value="Private Limited"
                            <%= "Private Limited".equals(businessConstitution)
                                    ? "selected" : "" %>>
                            Private Limited
                        </option>

                        <option value="Public Limited"
                            <%= "Public Limited".equals(businessConstitution)
                                    ? "selected" : "" %>>
                            Public Limited
                        </option>

                        <option value="Startup"
                            <%= "Startup".equals(businessConstitution)
                                    ? "selected" : "" %>>
                            Startup
                        </option>

                        <option value="Cooperative"
                            <%= "Cooperative".equals(businessConstitution)
                                    ? "selected" : "" %>>
                            Cooperative
                        </option>

                    </select>

                </div>


                <!-- BUSINESS ACTIVITY -->

                <div class="form-group">

                    <label>

                        Main Business Activity
                        <span class="required">*</span>

                    </label>


                    <div class="activity-options">


                        <label class="activity-card">

                            <div>

                                <input type="radio"
                                       name="businessActivity"
                                       value="Manufacturing"

                                    <%= "Manufacturing".equals(businessActivity)
                                            ? "checked" : "" %>

                                       required>

                                <span class="activity-title">
                                    Manufacturing
                                </span>

                            </div>

                            <span class="activity-description">

                                You manufacture or process
                                physical products.

                            </span>

                        </label>


                        <label class="activity-card">

                            <div>

                                <input type="radio"
                                       name="businessActivity"
                                       value="Service"

                                    <%= "Service".equals(businessActivity)
                                            ? "checked" : "" %>>

                                <span class="activity-title">
                                    Service
                                </span>

                            </div>

                            <span class="activity-description">

                                You primarily provide
                                professional or commercial services.

                            </span>

                        </label>


                        <label class="activity-card">

                            <div>

                                <input type="radio"
                                       name="businessActivity"
                                       value="Trading"

                                    <%= "Trading".equals(businessActivity)
                                            ? "checked" : "" %>>

                                <span class="activity-title">
                                    Trading
                                </span>

                            </div>

                            <span class="activity-description">

                                You primarily buy and sell
                                products or goods.

                            </span>

                        </label>


                    </div>

                </div>


                <div class="info-box">

                    Why are we asking this?

                    Your business structure and activity can
                    affect which registrations, licences and
                    compliance requirements may apply.

                </div>


                <div class="actions">

                    <a class="cancel-btn"
                       href="<%= request.getContextPath() %>/entrepreneur/dashboard">

                        Save & Exit Later

                    </a>


                    <button type="submit"
                            class="continue-btn">

                        Save & Continue →

                    </button>

                </div>

            </form>

        </div>


        <div class="save-note">

            Your progress will be stored in CHAPERON
            as you complete each step.

        </div>

    </div>

</div>

</body>

</html>