<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.Locale"%>

<%@ page import="com.chaperon.model.IncentiveResult"%>
<%@ page import="com.chaperon.model.IncentiveCalculationRequest"%>

<%
    String ctx = request.getContextPath();

    Map<String, Object> business =
        (Map<String, Object>) request.getAttribute("business");

    IncentiveCalculationRequest input =
        (IncentiveCalculationRequest)
        request.getAttribute("input");

    List<IncentiveResult> results =
        (List<IncentiveResult>)
        request.getAttribute("results");

    BigDecimal estimatedTotal =
        (BigDecimal)
        request.getAttribute("estimatedTotal");

    String errorMessage =
        (String)
        request.getAttribute("errorMessage");

    boolean calculationCompleted =
        Boolean.TRUE.equals(
            request.getAttribute("calculationCompleted")
        );

    NumberFormat moneyFormat =
        NumberFormat.getCurrencyInstance(
            new Locale("en", "IN")
        );

    String businessName =
        business == null ||
        business.get("businessName") == null
        ? ""
        : business.get("businessName").toString();

    String industry =
        business == null ||
        business.get("industry") == null
        ? ""
        : business.get("industry").toString();

    String state =
        business == null ||
        business.get("state") == null
        ? ""
        : business.get("state").toString();

    String district =
        business == null ||
        business.get("district") == null
        ? ""
        : business.get("district").toString();

    String investment =
        input != null &&
        input.getTotalInvestment() != null
        ? input.getTotalInvestment().toPlainString()
        : business != null &&
          business.get("investmentAmount") != null
          ? business.get("investmentAmount").toString()
          : "";

    String employeeCount =
        input != null
        ? String.valueOf(input.getEmployeeCount())
        : business != null &&
          business.get("employeeCount") != null
          ? business.get("employeeCount").toString()
          : "0";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Incentive Calculator | CHAPERON</title>

<style>

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: Arial, sans-serif;
    background: #f2f7ff;
    color: #102c52;
}

.header {
    height: 76px;
    background: #ffffff;
    border-bottom: 1px solid #dce8f8;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 6%;
    position: sticky;
    top: 0;
    z-index: 100;
}

.brand {
    display: flex;
    align-items: center;
    gap: 14px;
}

.brand-logo {
    width: 48px;
    height: 48px;
    border-radius: 14px;
    background: linear-gradient(
        135deg,
        #075ed1,
        #2b96f0
    );
    color: white;
    font-size: 24px;
    font-weight: 800;
    display: flex;
    align-items: center;
    justify-content: center;
}

.brand h1 {
    font-size: 23px;
    color: #083a78;
}

.brand p {
    font-size: 11px;
    color: #7185a2;
    margin-top: 3px;
}

.header-actions {
    display: flex;
    gap: 10px;
}

.header-actions a {
    text-decoration: none;
    padding: 11px 17px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 700;
    color: #075fc9;
    background: #edf5ff;
}

.page {
    max-width: 1240px;
    margin: 30px auto;
    padding: 0 20px 50px;
}

.hero {
    background: linear-gradient(
        120deg,
        #0756c7,
        #168ef0
    );
    color: white;
    padding: 34px;
    border-radius: 22px;
    box-shadow: 0 18px 40px
        rgba(14, 93, 190, 0.18);
    margin-bottom: 24px;
}

.hero-label {
    display: inline-block;
    background: rgba(255,255,255,0.17);
    padding: 8px 13px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: bold;
    margin-bottom: 15px;
}

.hero h2 {
    font-size: 30px;
    margin-bottom: 10px;
}

.hero p {
    max-width: 760px;
    line-height: 1.6;
    color: #e9f4ff;
}

.business-summary {
    display: grid;
    grid-template-columns:
        repeat(4, minmax(0, 1fr));
    gap: 14px;
    margin-bottom: 24px;
}

.summary-card {
    background: white;
    border: 1px solid #dce8f8;
    padding: 18px;
    border-radius: 15px;
}

.summary-card span {
    display: block;
    font-size: 11px;
    font-weight: 700;
    color: #7286a4;
    text-transform: uppercase;
    margin-bottom: 8px;
}

.summary-card strong {
    color: #0c3567;
    font-size: 15px;
}

.panel {
    background: #ffffff;
    border: 1px solid #dce8f8;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 12px 28px
        rgba(20, 61, 110, 0.08);
    margin-bottom: 24px;
}

.panel-header {
    padding: 22px 26px;
    border-bottom: 1px solid #e2ebf7;
}

.panel-header h3 {
    font-size: 21px;
    margin-bottom: 6px;
}

.panel-header p {
    color: #71829b;
    font-size: 14px;
}

.form-body {
    padding: 26px;
}

.form-grid {
    display: grid;
    grid-template-columns:
        repeat(2, minmax(0, 1fr));
    gap: 20px;
}

.field label {
    display: block;
    font-weight: 700;
    font-size: 14px;
    margin-bottom: 8px;
}

.field input,
.field select {
    width: 100%;
    height: 48px;
    padding: 0 13px;
    border: 1px solid #bdd1ec;
    border-radius: 10px;
    outline: none;
    font-size: 14px;
    color: #102c52;
    background: #fbfdff;
}

.field input:focus,
.field select:focus {
    border-color: #157ce0;
    box-shadow: 0 0 0 3px
        rgba(21,124,224,0.12);
}

.field small {
    display: block;
    margin-top: 6px;
    color: #7a8ca4;
    font-size: 12px;
}

.options {
    display: grid;
    grid-template-columns:
        repeat(3, minmax(0, 1fr));
    gap: 12px;
    margin-top: 22px;
}

.option-box {
    border: 1px solid #d6e4f5;
    background: #f6faff;
    border-radius: 12px;
    padding: 15px;
    font-size: 13px;
    font-weight: 700;
}

.option-box input {
    margin-right: 8px;
    accent-color: #0c70d8;
}

.calculate-button {
    margin-top: 24px;
    border: none;
    background: linear-gradient(
        120deg,
        #075bd1,
        #168ff0
    );
    color: white;
    padding: 14px 25px;
    border-radius: 11px;
    font-weight: 800;
    font-size: 15px;
    cursor: pointer;
}

.calculate-button:hover {
    transform: translateY(-1px);
    box-shadow: 0 8px 18px
        rgba(8, 103, 215, 0.25);
}

.error {
    background: #fff0f0;
    color: #bd2626;
    border: 1px solid #ffcaca;
    padding: 14px 18px;
    border-radius: 11px;
    margin-bottom: 20px;
}

.total-box {
    margin: 25px;
    background: linear-gradient(
        120deg,
        #e9f4ff,
        #edf9ff
    );
    border: 1px solid #bcdaf8;
    border-radius: 16px;
    padding: 23px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.total-box span {
    color: #55708e;
    font-weight: 700;
}

.total-box strong {
    font-size: 29px;
    color: #075fc9;
}

.results {
    padding: 0 25px 25px;
    display: grid;
    gap: 15px;
}

.result-card {
    border: 1px solid #d4e4f5;
    border-left: 5px solid #0874db;
    border-radius: 13px;
    padding: 19px;
}

.result-top {
    display: flex;
    justify-content: space-between;
    gap: 15px;
    margin-bottom: 11px;
}

.result-card h4 {
    font-size: 17px;
    color: #0b3c73;
}

.result-type {
    display: inline-block;
    margin-top: 6px;
    padding: 5px 9px;
    border-radius: 15px;
    background: #e8f3ff;
    color: #075fc9;
    font-size: 11px;
    font-weight: 800;
}

.result-amount {
    color: #078155;
    font-size: 20px;
    font-weight: 800;
    white-space: nowrap;
}

.result-card p {
    color: #61758e;
    line-height: 1.5;
    font-size: 13px;
}

.empty-result {
    padding: 25px;
    color: #6f8198;
    text-align: center;
}

.disclaimer {
    background: #fff8e7;
    border-left: 5px solid #e0a21a;
    padding: 17px 20px;
    border-radius: 10px;
    color: #705b27;
    font-size: 13px;
    line-height: 1.6;
}

@media (max-width: 850px) {

    .business-summary,
    .form-grid,
    .options {
        grid-template-columns: 1fr;
    }

    .header {
        padding: 0 18px;
    }

    .brand p {
        display: none;
    }

    .header-actions a:last-child {
        display: none;
    }

    .result-top,
    .total-box {
        align-items: flex-start;
        flex-direction: column;
    }
}

</style>
</head>

<body>

<header class="header">

    <div class="brand">

        <div class="brand-logo">C</div>

        <div>
            <h1>CHAPERON</h1>
            <p>GUIDE. CONNECT. COMPLY. GET APPROVED.</p>
        </div>

    </div>

    <div class="header-actions">

        <a href="<%= ctx %>/entrepreneur/dashboard">
            Dashboard
        </a>

        <a href="<%= ctx %>/entrepreneur/schemes">
            Government Schemes
        </a>

    </div>

</header>

<main class="page">

    <section class="hero">

        <span class="hero-label">
            SMART BUSINESS BENEFIT ESTIMATOR
        </span>

        <h2>Incentive Calculator</h2>

        <p>
            Estimate the government incentives that may
            apply to your project based on investment,
            enterprise category, employment and location.
        </p>

    </section>

    <% if (errorMessage != null) { %>

        <div class="error">
            <%= errorMessage %>
        </div>

    <% } %>

    <% if (business != null) { %>

        <section class="business-summary">

            <div class="summary-card">
                <span>Business</span>
                <strong><%= businessName %></strong>
            </div>

            <div class="summary-card">
                <span>Industry</span>
                <strong><%= industry %></strong>
            </div>

            <div class="summary-card">
                <span>State</span>
                <strong><%= state %></strong>
            </div>

            <div class="summary-card">
                <span>District</span>
                <strong><%= district %></strong>
            </div>

        </section>

        <section class="panel">

            <div class="panel-header">
                <h3>Project and investment details</h3>
                <p>
                    Business information has been filled
                    from your CHAPERON profile.
                </p>
            </div>

            <form method="post"
                  action="<%= ctx %>/entrepreneur/incentive-calculator"
                  class="form-body">

                <div class="form-grid">

                    <div class="field">

                        <label>Enterprise Category</label>

                        <select name="enterpriseCategory"
                                required>

                            <option value="">
                                Select category
                            </option>

                            <option value="MICRO"
                                <%= input != null &&
                                "MICRO".equals(
                                input.getEnterpriseCategory())
                                ? "selected" : "" %>>
                                Micro Enterprise
                            </option>

                            <option value="SMALL"
                                <%= input != null &&
                                "SMALL".equals(
                                input.getEnterpriseCategory())
                                ? "selected" : "" %>>
                                Small Enterprise
                            </option>

                            <option value="MEDIUM"
                                <%= input != null &&
                                "MEDIUM".equals(
                                input.getEnterpriseCategory())
                                ? "selected" : "" %>>
                                Medium Enterprise
                            </option>

                            <option value="LARGE"
                                <%= input != null &&
                                "LARGE".equals(
                                input.getEnterpriseCategory())
                                ? "selected" : "" %>>
                                Large Enterprise
                            </option>

                        </select>

                    </div>

                    <div class="field">

                        <label>Project Type</label>

                        <select name="projectType" required>

                            <option value="NEW"
                                <%= input == null ||
                                "NEW".equals(
                                input.getProjectType())
                                ? "selected" : "" %>>
                                New Project
                            </option>

                            <option value="EXPANSION"
                                <%= input != null &&
                                "EXPANSION".equals(
                                input.getProjectType())
                                ? "selected" : "" %>>
                                Existing Project Expansion
                            </option>

                        </select>

                    </div>

                    <div class="field">

                        <label>
                            Total Project Investment (₹)
                        </label>

                        <input type="number"
                               name="totalInvestment"
                               min="1"
                               step="0.01"
                               value="<%= investment %>"
                               required>

                        <small>
                            Enter the amount in rupees.
                        </small>

                    </div>

                    <div class="field">

                        <label>Number of Employees</label>

                        <input type="number"
                               name="employeeCount"
                               min="0"
                               value="<%= employeeCount %>"
                               required>

                    </div>

                    <div class="field">

                        <label>
                            Environmental Investment (₹)
                        </label>

                        <input type="number"
                               name="environmentalInvestment"
                               min="0"
                               step="0.01"
                               value="<%= input != null
                               ? input
                               .getEnvironmentalInvestment()
                               .toPlainString()
                               : "0" %>">

                        <small>
                            Pollution-control and environmental
                            equipment investment.
                        </small>

                    </div>

                    <div class="field">

                        <label>
                            Renewable Energy Investment (₹)
                        </label>

                        <input type="number"
                               name="renewableEnergyInvestment"
                               min="0"
                               step="0.01"
                               value="<%= input != null
                               ? input
                               .getRenewableEnergyInvestment()
                               .toPlainString()
                               : "0" %>">

                    </div>

                </div>

                <div class="options">

                    <label class="option-box">

                        <input type="checkbox"
                               name="locatedInIndustrialArea"
                               <%= input != null &&
                               input.isLocatedInIndustrialArea()
                               ? "checked" : "" %>>

                        Located in an industrial area

                    </label>

                    <label class="option-box">

                        <input type="checkbox"
                               name="womenEntrepreneur"
                               <%= input != null &&
                               input.isWomenEntrepreneur()
                               ? "checked" : "" %>>

                        Women entrepreneur

                    </label>

                    <label class="option-box">

                        <input type="checkbox"
                               name="scStEntrepreneur"
                               <%= input != null &&
                               input.isScStEntrepreneur()
                               ? "checked" : "" %>>

                        SC/ST entrepreneur

                    </label>

                </div>

                <button type="submit"
                        class="calculate-button">

                    Calculate Estimated Incentives →

                </button>

            </form>

        </section>

    <% } %>

    <% if (calculationCompleted) { %>

        <section class="panel">

            <div class="panel-header">

                <h3>Estimated Incentive Benefits</h3>

                <p>
                    Rule-based preliminary calculation
                    generated by CHAPERON.
                </p>

            </div>

            <div class="total-box">

                <span>
                    Total Estimated Incentive
                </span>

                <strong>
                    <%= moneyFormat.format(
                        estimatedTotal == null
                        ? BigDecimal.ZERO
                        : estimatedTotal
                    ) %>
                </strong>

            </div>

            <% if (results != null &&
                   !results.isEmpty()) { %>

                <div class="results">

                    <% for (IncentiveResult result
                            : results) { %>

                        <article class="result-card">

                            <div class="result-top">

                                <div>

                                    <h4>
                                        <%= result
                                        .getIncentiveName() %>
                                    </h4>

                                    <span class="result-type">
                                        <%= result
                                        .getIncentiveType()
                                        .replace('_', ' ') %>
                                    </span>

                                </div>

                                <div class="result-amount">

                                    <%= moneyFormat.format(
                                        result
                                        .getEstimatedBenefit()
                                    ) %>

                                </div>

                            </div>

                            <p>
                                <%= result
                                .getExplanation() %>
                            </p>

                        </article>

                    <% } %>

                </div>

            <% } else { %>

                <div class="empty-result">
                    No matching incentive rule was found
                    for the entered details.
                </div>

            <% } %>

        </section>

    <% } %>

    <div class="disclaimer">

        <strong>Important:</strong>

        Incentive amounts are preliminary estimates based
        on configured policy rules. Final eligibility and
        sanctioned benefits are subject to verification by
        the concerned government department.

    </div>

</main>

</body>
</html>