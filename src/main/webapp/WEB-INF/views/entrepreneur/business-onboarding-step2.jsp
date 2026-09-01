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
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Industry | CHAPERON</title>

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
        background: white;
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
        max-width: 900px;
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
        width: 40%;
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

    .industry-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 14px;
    }

    .industry-card {
        border: 1px solid #d6dfeb;
        border-radius: 13px;
        padding: 18px;
        cursor: pointer;
        transition: 0.2s;
        background: white;
        min-height: 85px;
        display: flex;
        align-items: center;
    }

    .industry-card:hover {
        border-color: #1677e8;
        background: #f7fbff;
        transform: translateY(-2px);
    }

    .industry-card input {
        margin-right: 10px;
    }

    .industry-name {
        font-weight: 700;
        color: #263750;
    }

    .error-box {
        background: #fff1f1;
        border: 1px solid #f3caca;
        color: #a62c2c;
        padding: 13px 15px;
        border-radius: 9px;
        margin-bottom: 22px;
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

    @media (max-width: 800px) {

        .industry-grid {
            grid-template-columns: 1fr 1fr;
        }
    }

    @media (max-width: 550px) {

        .industry-grid {
            grid-template-columns: 1fr;
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
       href="<%= request.getContextPath() %>/entrepreneur/business-onboarding">

        ← Back to Step 1

    </a>

    <div class="step-header">

        <div class="step-label">
            STEP 2 OF 5
        </div>

        <div class="percentage">
            40% Complete
        </div>

    </div>

    <div class="progress">
        <div class="progress-bar"></div>
    </div>

    <div class="card">

        <h1>
            What industry are you in?
        </h1>

        <p class="intro">
            Select the industry that best describes your
            main business activity. This helps CHAPERON
            identify relevant approvals and compliance requirements.
        </p>

        <% if (errorMessage != null) { %>

            <div class="error-box">
                <%= errorMessage %>
            </div>

        <% } %>

        <form method="post"
              action="<%= request.getContextPath() %>/entrepreneur/business-onboarding/step2">

            <div class="industry-grid">

                <label class="industry-card">
                    <input type="radio"
                           name="industry"
                           value="Food Processing"
                           <%= "Food Processing".equals(selectedIndustry)
                                   ? "checked" : "" %>
                           required>
                    <span class="industry-name">
                        Food Processing
                    </span>
                </label>

                <label class="industry-card">
                    <input type="radio"
                           name="industry"
                           value="Chemical"
                           <%= "Chemical".equals(selectedIndustry)
                                   ? "checked" : "" %>>
                    <span class="industry-name">
                        Chemical
                    </span>
                </label>

                <label class="industry-card">
                    <input type="radio"
                           name="industry"
                           value="Pharmaceutical"
                           <%= "Pharmaceutical".equals(selectedIndustry)
                                   ? "checked" : "" %>>
                    <span class="industry-name">
                        Pharmaceutical
                    </span>
                </label>

                <label class="industry-card">
                    <input type="radio"
                           name="industry"
                           value="Textile"
                           <%= "Textile".equals(selectedIndustry)
                                   ? "checked" : "" %>>
                    <span class="industry-name">
                        Textile
                    </span>
                </label>

                <label class="industry-card">
                    <input type="radio"
                           name="industry"
                           value="Automobile"
                           <%= "Automobile".equals(selectedIndustry)
                                   ? "checked" : "" %>>
                    <span class="industry-name">
                        Automobile
                    </span>
                </label>

                <label class="industry-card">
                    <input type="radio"
                           name="industry"
                           value="Electronics"
                           <%= "Electronics".equals(selectedIndustry)
                                   ? "checked" : "" %>>
                    <span class="industry-name">
                        Electronics
                    </span>
                </label>

                <label class="industry-card">
                    <input type="radio"
                           name="industry"
                           value="Construction"
                           <%= "Construction".equals(selectedIndustry)
                                   ? "checked" : "" %>>
                    <span class="industry-name">
                        Construction
                    </span>
                </label>

                <label class="industry-card">
                    <input type="radio"
                           name="industry"
                           value="IT / Software"
                           <%= "IT / Software".equals(selectedIndustry)
                                   ? "checked" : "" %>>
                    <span class="industry-name">
                        IT / Software
                    </span>
                </label>

                <label class="industry-card">
                    <input type="radio"
                           name="industry"
                           value="Agriculture"
                           <%= "Agriculture".equals(selectedIndustry)
                                   ? "checked" : "" %>>
                    <span class="industry-name">
                        Agriculture
                    </span>
                </label>

                <label class="industry-card">
                    <input type="radio"
                           name="industry"
                           value="Logistics"
                           <%= "Logistics".equals(selectedIndustry)
                                   ? "checked" : "" %>>
                    <span class="industry-name">
                        Logistics
                    </span>
                </label>

                <label class="industry-card">
                    <input type="radio"
                           name="industry"
                           value="Renewable Energy"
                           <%= "Renewable Energy".equals(selectedIndustry)
                                   ? "checked" : "" %>>
                    <span class="industry-name">
                        Renewable Energy
                    </span>
                </label>

                <label class="industry-card">
                    <input type="radio"
                           name="industry"
                           value="Hospitality"
                           <%= "Hospitality".equals(selectedIndustry)
                                   ? "checked" : "" %>>
                    <span class="industry-name">
                        Hospitality
                    </span>
                </label>

                <label class="industry-card">
                    <input type="radio"
                           name="industry"
                           value="Manufacturing"
                           <%= "Manufacturing".equals(selectedIndustry)
                                   ? "checked" : "" %>>
                    <span class="industry-name">
                        Manufacturing
                    </span>
                </label>

                <label class="industry-card">
                    <input type="radio"
                           name="industry"
                           value="Other"
                           <%= "Other".equals(selectedIndustry)
                                   ? "checked" : "" %>>
                    <span class="industry-name">
                        Other
                    </span>
                </label>

            </div>

            <div class="actions">

                <a class="back-btn"
                   href="<%= request.getContextPath() %>/entrepreneur/business-onboarding">

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