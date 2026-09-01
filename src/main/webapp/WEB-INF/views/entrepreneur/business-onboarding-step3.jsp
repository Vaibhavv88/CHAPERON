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
            industrialArea = business.getIndustrialArea();
        }

        if (business.getPinCode() != null) {
            pinCode = business.getPinCode();
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

<title>Business Location | CHAPERON</title>

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
        padding: 45px 20px;
    }

    .container {
        max-width: 850px;
        margin: auto;
    }

    .back-link {
        text-decoration: none;
        color: #617086;
        display: inline-block;
        margin-bottom: 25px;
    }

    .step-header {
        display: flex;
        justify-content: space-between;
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
        width: 60%;
        height: 100%;
        background: #1677e8;
    }

    .card {
        background: white;
        border-radius: 18px;
        border: 1px solid #e6ebf1;
        padding: 38px;
        box-shadow: 0 10px 30px rgba(21,45,80,0.07);
    }

    h1 {
        font-size: 30px;
        margin-bottom: 10px;
    }

    .intro {
        color: #6d7b8e;
        line-height: 1.6;
        margin-bottom: 30px;
    }

    .form-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
    }

    .form-group {
        margin-bottom: 5px;
    }

    .full-width {
        grid-column: 1 / -1;
    }

    label {
        display: block;
        font-weight: 700;
        font-size: 15px;
        margin-bottom: 8px;
        color: #263750;
    }

    .required {
        color: #d13c3c;
    }

    input,
    select {
        width: 100%;
        height: 50px;
        border: 1px solid #ccd6e2;
        border-radius: 10px;
        padding: 0 14px;
        font-size: 15px;
        outline: none;
        background: white;
    }

    input:focus,
    select:focus {
        border-color: #1677e8;
        box-shadow: 0 0 0 3px rgba(22,119,232,0.10);
    }

    .help-text {
        color: #7c8999;
        font-size: 12px;
        margin-top: 6px;
        line-height: 1.4;
    }

    .error-box {
        background: #fff1f1;
        border: 1px solid #f3caca;
        color: #a62c2c;
        padding: 13px 15px;
        border-radius: 9px;
        margin-bottom: 22px;
    }

    .info-box {
        margin-top: 25px;
        background: #eef6ff;
        border: 1px solid #d6e9ff;
        border-radius: 12px;
        padding: 16px;
        color: #46627e;
        line-height: 1.5;
        font-size: 14px;
    }

    .actions {
        display: flex;
        justify-content: space-between;
        margin-top: 35px;
    }

    .back-btn {
        text-decoration: none;
        color: #5f6e82;
        padding: 13px 18px;
        font-weight: 600;
    }

    .continue-btn {
        border: none;
        background: #1677e8;
        color: white;
        padding: 14px 25px;
        border-radius: 10px;
        font-size: 15px;
        font-weight: 700;
        cursor: pointer;
    }

    .continue-btn:hover {
        background: #0e67cb;
    }

    @media (max-width: 650px) {

        .form-grid {
            grid-template-columns: 1fr;
        }

        .full-width {
            grid-column: auto;
        }

        .card {
            padding: 25px 20px;
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
       href="<%= request.getContextPath() %>/entrepreneur/business-onboarding/step2">

        ← Back to Step 2

    </a>

    <div class="step-header">

        <div class="step-label">
            STEP 3 OF 5
        </div>

        <div class="percentage">
            60% Complete
        </div>

    </div>

    <div class="progress">
        <div class="progress-bar"></div>
    </div>

    <div class="card">

        <h1>
            Where is your business located?
        </h1>

        <p class="intro">
            Location can affect which departments,
            approvals and state-specific requirements apply.
        </p>

        <% if (errorMessage != null) { %>

            <div class="error-box">
                <%= errorMessage %>
            </div>

        <% } %>

        <form method="post"
              action="<%= request.getContextPath() %>/entrepreneur/business-onboarding/step3">

            <div class="form-grid">

                <div class="form-group">

                    <label for="state">
                        State
                        <span class="required">*</span>
                    </label>

                    <select id="state"
                            name="state"
                            required>

                        <option value="">
                            Select State
                        </option>

                        <option value="Uttar Pradesh"
                            <%= "Uttar Pradesh".equals(state)
                                    ? "selected" : "" %>>
                            Uttar Pradesh
                        </option>

                        <option value="Maharashtra"
                            <%= "Maharashtra".equals(state)
                                    ? "selected" : "" %>>
                            Maharashtra
                        </option>

                        <option value="Delhi"
                            <%= "Delhi".equals(state)
                                    ? "selected" : "" %>>
                            Delhi
                        </option>

                        <option value="Gujarat"
                            <%= "Gujarat".equals(state)
                                    ? "selected" : "" %>>
                            Gujarat
                        </option>

                        <option value="Karnataka"
                            <%= "Karnataka".equals(state)
                                    ? "selected" : "" %>>
                            Karnataka
                        </option>

                        <option value="Rajasthan"
                            <%= "Rajasthan".equals(state)
                                    ? "selected" : "" %>>
                            Rajasthan
                        </option>

                        <option value="Madhya Pradesh"
                            <%= "Madhya Pradesh".equals(state)
                                    ? "selected" : "" %>>
                            Madhya Pradesh
                        </option>

                        <option value="Other"
                            <%= "Other".equals(state)
                                    ? "selected" : "" %>>
                            Other
                        </option>

                    </select>

                </div>

                <div class="form-group">

                    <label for="district">
                        District
                        <span class="required">*</span>
                    </label>

                    <input type="text"
                           id="district"
                           name="district"
                           value="<%= district %>"
                           placeholder="Example: Gorakhpur"
                           maxlength="100"
                           required>

                </div>

                <div class="form-group">

                    <label for="taluka">
                        Taluka / Tehsil
                        <span class="required">*</span>
                    </label>

                    <input type="text"
                           id="taluka"
                           name="taluka"
                           value="<%= taluka %>"
                           placeholder="Enter Taluka / Tehsil"
                           maxlength="100"
                           required>

                </div>

                <div class="form-group">

                    <label for="pinCode">
                        PIN Code
                        <span class="required">*</span>
                    </label>

                    <input type="text"
                           id="pinCode"
                           name="pinCode"
                           value="<%= pinCode %>"
                           placeholder="6-digit PIN code"
                           maxlength="6"
                           pattern="[0-9]{6}"
                           required>

                </div>

                <div class="form-group full-width">

                    <label for="industrialArea">
                        Industrial Area
                    </label>

                    <input type="text"
                           id="industrialArea"
                           name="industrialArea"
                           value="<%= industrialArea %>"
                           placeholder="Example: GIDA Industrial Area">

                    <div class="help-text">
                        Optional — leave blank if your business
                        is not located inside a designated industrial area.
                    </div>

                </div>

            </div>

            <div class="info-box">

                CHAPERON will later use your location
                to match relevant state and local approval rules.

            </div>

            <div class="actions">

                <a class="back-btn"
                   href="<%= request.getContextPath() %>/entrepreneur/business-onboarding/step2">

                    ← Previous

                </a>

                <button type="submit"
                        class="continue-btn">

                    Save & Continue →

                </button>

            </div>

        </form>

    </div>

</div>

</div>

</body>

</html>