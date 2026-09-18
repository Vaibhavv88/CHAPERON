<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.chaperon.model.Business" %>
<%@ page import="com.chaperon.model.BusinessApproval" %>

<%
    String ctx =
            request.getContextPath();

    Business business =
            (Business)
            request.getAttribute(
                    "business"
            );

    List<BusinessApproval> currentApprovals =
            (List<BusinessApproval>)
            request.getAttribute(
                    "currentApprovals"
            );

    List<BusinessApproval> simulatedApprovals =
            (List<BusinessApproval>)
            request.getAttribute(
                    "simulatedApprovals"
            );

    List<BusinessApproval> addedApprovals =
            (List<BusinessApproval>)
            request.getAttribute(
                    "addedApprovals"
            );

    List<BusinessApproval> removedApprovals =
            (List<BusinessApproval>)
            request.getAttribute(
                    "removedApprovals"
            );

    List<BusinessApproval> unchangedApprovals =
            (List<BusinessApproval>)
            request.getAttribute(
                    "unchangedApprovals"
            );

    Boolean simulationPerformed =
            (Boolean)
            request.getAttribute(
                    "simulationPerformed"
            );

    String simulationError =
            (String)
            request.getAttribute(
                    "simulationError"
            );

    int currentCount =
            currentApprovals == null
                    ? 0
                    : currentApprovals.size();

    int simulatedCount =
            simulatedApprovals == null
                    ? 0
                    : simulatedApprovals.size();

    int addedCount =
            addedApprovals == null
                    ? 0
                    : addedApprovals.size();

    int removedCount =
            removedApprovals == null
                    ? 0
                    : removedApprovals.size();
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    What-If Simulator | CHAPERON
</title>

<style>

* {
    box-sizing: border-box;
}

body {

    margin: 0;

    font-family:
        "Segoe UI",
        Arial,
        sans-serif;

    color: #173052;

    background:
        linear-gradient(
            135deg,
            #f4f8ff,
            #eef7ff
        );

    min-height: 100vh;
}

.topbar {

    min-height: 72px;

    padding:
        12px
        30px;

    background: white;

    border-bottom:
        1px solid #dfe8f5;

    display: flex;

    align-items: center;

    justify-content: space-between;

    position: sticky;

    top: 0;

    z-index: 100;
}

.brand {

    display: flex;

    align-items: center;

    gap: 10px;
}

.brand img {

    width: 45px;

    height: 45px;

    border-radius: 50%;

    object-fit: cover;
}

.brand h1 {

    margin: 0;

    color: #095ee8;

    font-size: 20px;
}

.brand small {

    display: block;

    margin-top: 3px;

    color: #7589a6;

    font-size: 8px;

    font-weight: 700;
}

.back-btn {

    text-decoration: none;

    padding:
        10px
        14px;

    border:
        1px solid #d7e4f5;

    border-radius: 10px;

    color: #1657b8;

    background: #f8fbff;

    font-size: 12px;

    font-weight: 800;
}

.container {

    width:
        min(
            1250px,
            calc(100% - 30px)
        );

    margin:
        25px auto 50px;
}

.hero {

    padding:
        30px;

    border-radius: 22px;

    color: white;

    background:
        linear-gradient(
            125deg,
            #0758dc,
            #1173df,
            #20acd9
        );

    box-shadow:
        0 18px 40px
        rgba(
            20,
            92,
            190,
            .18
        );
}

.hero-label {

    display: inline-block;

    padding:
        6px
        10px;

    border-radius: 50px;

    background:
        rgba(
            255,
            255,
            255,
            .15
        );

    font-size: 10px;

    font-weight: 800;
}

.hero h2 {

    margin:
        12px
        0
        8px;

    font-size: 30px;
}

.hero p {

    max-width: 820px;

    margin: 0;

    color: #e4f1ff;

    line-height: 1.7;

    font-size: 13px;
}

.warning {

    margin-top: 18px;

    padding: 12px 14px;

    border-radius: 11px;

    color: #0752a5;

    background: #eaf5ff;

    border:
        1px solid #cfe6ff;

    font-size: 11px;

    font-weight: 650;
}

.panel {

    margin-top: 20px;

    padding: 23px;

    background: white;

    border:
        1px solid #dce7f4;

    border-radius: 18px;

    box-shadow:
        0 12px 30px
        rgba(
            20,
            60,
            100,
            .06
        );
}

.panel h3 {

    margin:
        0
        0
        5px;

    color: #17375f;
}

.panel-subtitle {

    margin-bottom: 20px;

    color: #75859a;

    font-size: 11px;
}

.form-grid {

    display: grid;

    grid-template-columns:
        repeat(
            3,
            1fr
        );

    gap: 15px;
}

.field label {

    display: block;

    margin-bottom: 6px;

    color: #536b88;

    font-size: 10px;

    font-weight: 800;

    text-transform: uppercase;
}

.field select,
.field input {

    width: 100%;

    min-height: 42px;

    padding:
        0
        12px;

    border:
        1px solid #d7e3f1;

    border-radius: 10px;

    outline: none;

    color: #263d59;

    background: #fbfdff;
}

.field select:focus,
.field input:focus {

    border-color: #6aa8f7;

    box-shadow:
        0 0 0 3px
        rgba(
            70,
            135,
            230,
            .09
        );
}

.toggle-grid {

    margin-top: 18px;

    display: grid;

    grid-template-columns:
        repeat(
            4,
            1fr
        );

    gap: 12px;
}

.toggle-card {

    padding: 14px;

    border:
        1px solid #dde7f3;

    border-radius: 12px;

    background: #f8fbff;
}

.toggle-card label {

    display: block;

    margin-bottom: 9px;

    font-size: 11px;

    font-weight: 800;
}

.toggle-card select {

    width: 100%;

    min-height: 36px;

    border:
        1px solid #d8e4f2;

    border-radius: 8px;
}

.simulate-btn {

    margin-top: 20px;

    border: 0;

    padding:
        12px
        21px;

    border-radius: 10px;

    cursor: pointer;

    color: white;

    background:
        linear-gradient(
            135deg,
            #095ee8,
            #1b9ae4
        );

    font-size: 12px;

    font-weight: 900;
}

.stats {

    margin-top: 20px;

    display: grid;

    grid-template-columns:
        repeat(
            4,
            1fr
        );

    gap: 12px;
}

.stat {

    padding: 17px;

    border:
        1px solid #dce7f3;

    border-radius: 14px;

    background: white;
}

.stat span {

    display: block;

    color: #8291a5;

    font-size: 9px;

    font-weight: 800;

    text-transform: uppercase;
}

.stat strong {

    display: block;

    margin-top: 8px;

    color: #183d6e;

    font-size: 25px;
}

.results-grid {

    margin-top: 20px;

    display: grid;

    grid-template-columns:
        repeat(
            3,
            1fr
        );

    gap: 15px;
}

.result-box {

    padding: 20px;

    border:
        1px solid #dce7f3;

    border-radius: 16px;

    background: white;
}

.result-box h3 {

    margin:
        0
        0
        14px;

    font-size: 15px;
}

.added {

    border-top:
        4px solid #16a36c;
}

.removed {

    border-top:
        4px solid #e35b5b;
}

.unchanged {

    border-top:
        4px solid #2f7fe5;
}

.approval-item {

    margin-top: 9px;

    padding: 12px;

    border-radius: 10px;

    background: #f7faff;

    border:
        1px solid #e1eaf5;
}

.approval-item strong {

    display: block;

    color: #223e61;

    font-size: 11px;
}

.approval-item span {

    display: block;

    margin-top: 4px;

    color: #7b8ca1;

    font-size: 9px;
}

.empty {

    padding: 15px;

    color: #8391a2;

    background: #f8fafc;

    border-radius: 10px;

    font-size: 10px;

    text-align: center;
}

.impact {

    margin-top: 20px;

    padding: 20px;

    border-radius: 15px;

    background:
        linear-gradient(
            135deg,
            #eef6ff,
            #f5fbff
        );

    border:
        1px solid #d5e7fa;
}

.impact strong {

    color: #145db9;
}

.error {

    margin-top: 15px;

    padding: 12px;

    border-radius: 10px;

    color: #9f2929;

    background: #fff1f1;

    border:
        1px solid #ffd0d0;
}

@media(max-width:900px) {

    .form-grid {

        grid-template-columns:
            repeat(
                2,
                1fr
            );
    }

    .toggle-grid,
    .stats {

        grid-template-columns:
            repeat(
                2,
                1fr
            );
    }

    .results-grid {

        grid-template-columns:
            1fr;
    }
}

@media(max-width:600px) {

    .form-grid,
    .toggle-grid,
    .stats {

        grid-template-columns:
            1fr;
    }

    .hero h2 {

        font-size: 24px;
    }

    .topbar {

        padding:
            10px
            15px;
    }
}

</style>

</head>

<body>

<header class="topbar">

    <div class="brand">

        <img
            src="<%= ctx %>/images/chaperon-logo.jpeg"
            alt="CHAPERON">

        <div>

            <h1>
                CHAPERON
            </h1>

            <small>
                GUIDE. CONNECT. COMPLY. GET APPROVED.
            </small>

        </div>

    </div>

    <a
        class="back-btn"
        href="<%= ctx %>/entrepreneur/generate-approvals">

        ← Approval Roadmap

    </a>

</header>

<main class="container">

    <section class="hero">

        <div class="hero-label">
            ✦ REGULATORY IMPACT SIMULATOR
        </div>

        <h2>
            What if your business changes?
        </h2>

        <p>

            Test possible changes before updating
            your real business profile. CHAPERON
            estimates how a change in industry,
            project stage, employee strength,
            investment or compliance conditions
            may affect your approval roadmap.

        </p>

    </section>

    <div class="warning">

        Simulation only — your actual business profile
        and existing applications will not be modified.

    </div>

    <%
    if (simulationError != null) {
    %>

        <div class="error">
            <%= simulationError %>
        </div>

    <%
    }
    %>

    <section class="panel">

        <h3>
            Create a Business Scenario
        </h3>

        <div class="panel-subtitle">
            Change one or more values and analyse the regulatory impact.
        </div>

        <form
            method="post"
            action="<%= ctx %>/entrepreneur/what-if-simulator">

            <div class="form-grid">

                <div class="field">

                    <label>
                        Industry
                    </label>

                    <select name="industry">

                        <option value="<%= business != null && business.getIndustry() != null
                                ? business.getIndustry()
                                : "" %>">

                            Current:
                            <%= business != null && business.getIndustry() != null
                                    ? business.getIndustry()
                                    : "Not Set" %>

                        </option>

                        <option>Food Processing</option>
                        <option>Chemical</option>
                        <option>Pharmaceutical</option>
                        <option>Textile</option>
                        <option>Automobile</option>
                        <option>Electronics</option>
                        <option>Construction</option>
                        <option>IT / Software</option>
                        <option>Agriculture</option>
                        <option>Logistics</option>
                        <option>Renewable Energy</option>
                        <option>Hospitality</option>
                        <option>Manufacturing</option>
                        <option>Other</option>

                    </select>

                </div>

                <div class="field">

                    <label>
                        Project Stage
                    </label>

                    <input
                        type="text"
                        name="projectStage"
                        value="<%= business != null && business.getProjectStage() != null
                                ? business.getProjectStage()
                                : "" %>">

                </div>

                <div class="field">

                    <label>
                        Annual Turnover
                    </label>

                    <input
                        type="number"
                        min="0"
                        step="0.01"
                        name="annualTurnover"
                        value="<%= business != null && business.getAnnualTurnover() != null
                                ? business.getAnnualTurnover()
                                : "" %>">

                </div>

                <div class="field">

                    <label>
                        Pollution Category
                    </label>

                    <select name="pollutionCategory">

                        <option value="<%= business != null && business.getPollutionCategory() != null
                                ? business.getPollutionCategory()
                                : "" %>">

                            Current:
                            <%= business != null && business.getPollutionCategory() != null
                                    ? business.getPollutionCategory()
                                    : "Not Set" %>

                        </option>

                        <option value="Red">
                            Red
                        </option>

                        <option value="Orange">
                            Orange
                        </option>

                        <option value="Green">
                            Green
                        </option>

                        <option value="White">
                            White
                        </option>

                    </select>

                </div>

                <div class="field">

                    <label>
                        Employees
                    </label>

                    <input
                        type="number"
                        min="0"
                        name="employeeCount"
                        value="<%= business != null
                                ? business.getEmployeeCount()
                                : 0 %>">

                </div>

                <div class="field">

                    <label>
                        Investment Amount
                    </label>

                    <input
                        type="number"
                        min="0"
                        step="0.01"
                        name="investmentAmount"
                        value="<%= business != null && business.getInvestmentAmount() != null
                                ? business.getInvestmentAmount()
                                : "" %>">

                </div>

            </div>

            <div class="toggle-grid">

                <div class="toggle-card">

                    <label>
                        Hazardous Material
                    </label>

                    <select name="hazardousMaterial">

                        <option value="YES"
                            <%= business != null && business.isHazardousMaterial()
                                    ? "selected"
                                    : "" %>>
                            Yes
                        </option>

                        <option value="NO"
                            <%= business != null && !business.isHazardousMaterial()
                                    ? "selected"
                                    : "" %>>
                            No
                        </option>

                    </select>

                </div>

                <div class="toggle-card">
                    <label>Interstate Supply</label>
                    <select name="interstateSupply">
                        <option value="YES" <%= business != null && business.isInterstateSupply() ? "selected" : "" %>>Yes</option>
                        <option value="NO" <%= business != null && !business.isInterstateSupply() ? "selected" : "" %>>No</option>
                    </select>
                </div>

                <div class="toggle-card">
                    <label>Handles Personal Data</label>
                    <select name="handlesPersonalData">
                        <option value="YES" <%= business != null && business.isHandlesPersonalData() ? "selected" : "" %>>Yes</option>
                        <option value="NO" <%= business != null && !business.isHandlesPersonalData() ? "selected" : "" %>>No</option>
                    </select>
                </div>

                <div class="toggle-card">
                    <label>Seeking STPI Benefits</label>
                    <select name="seeksStpiBenefits">
                        <option value="YES" <%= business != null && business.isSeeksStpiBenefits() ? "selected" : "" %>>Yes</option>
                        <option value="NO" <%= business != null && !business.isSeeksStpiBenefits() ? "selected" : "" %>>No</option>
                    </select>
                </div>

                <div class="toggle-card">
                    <label>Located in SEZ</label>
                    <select name="locatedInSez">
                        <option value="YES" <%= business != null && business.isLocatedInSez() ? "selected" : "" %>>Yes</option>
                        <option value="NO" <%= business != null && !business.isLocatedInSez() ? "selected" : "" %>>No</option>
                    </select>
                </div>

                <div class="toggle-card">
                    <label>CERT-In Applicable</label>
                    <select name="certInApplicable">
                        <option value="YES" <%= business != null && business.isCertInApplicable() ? "selected" : "" %>>Yes</option>
                        <option value="NO" <%= business != null && !business.isCertInApplicable() ? "selected" : "" %>>No</option>
                    </select>
                </div>

                <div class="toggle-card">
                    <label>Trademark Protection</label>
                    <select name="seeksTrademarkProtection">
                        <option value="YES" <%= business != null && business.isSeeksTrademarkProtection() ? "selected" : "" %>>Yes</option>
                        <option value="NO" <%= business != null && !business.isSeeksTrademarkProtection() ? "selected" : "" %>>No</option>
                    </select>
                </div>

                <div class="toggle-card">
                    <label>Software Copyright</label>
                    <select name="seeksSoftwareCopyright">
                        <option value="YES" <%= business != null && business.isSeeksSoftwareCopyright() ? "selected" : "" %>>Yes</option>
                        <option value="NO" <%= business != null && !business.isSeeksSoftwareCopyright() ? "selected" : "" %>>No</option>
                    </select>
                </div>

                <div class="toggle-card">

                    <label>
                        Boiler Used
                    </label>

                    <select name="boilerUsed">

                        <option value="YES"
                            <%= business != null && business.isBoilerUsed()
                                    ? "selected"
                                    : "" %>>
                            Yes
                        </option>

                        <option value="NO"
                            <%= business != null && !business.isBoilerUsed()
                                    ? "selected"
                                    : "" %>>
                            No
                        </option>

                    </select>

                </div>

                <div class="toggle-card">

                    <label>
                        Industrial Waste
                    </label>

                    <select name="industrialWaste">

                        <option value="YES"
                            <%= business != null && business.isIndustrialWaste()
                                    ? "selected"
                                    : "" %>>
                            Yes
                        </option>

                        <option value="NO"
                            <%= business != null && !business.isIndustrialWaste()
                                    ? "selected"
                                    : "" %>>
                            No
                        </option>

                    </select>

                </div>

                <div class="toggle-card">

                    <label>
                        Groundwater Required
                    </label>

                    <select name="groundwaterRequired">

                        <option value="YES"
                            <%= business != null && business.isGroundwaterRequired()
                                    ? "selected"
                                    : "" %>>
                            Yes
                        </option>

                        <option value="NO"
                            <%= business != null && !business.isGroundwaterRequired()
                                    ? "selected"
                                    : "" %>>
                            No
                        </option>

                    </select>

                </div>

            </div>

            <button
                type="submit"
                class="simulate-btn">

                Analyse Regulatory Impact →

            </button>

        </form>

    </section>

    <%
    if (Boolean.TRUE.equals(
            simulationPerformed)) {
    %>

        <section class="stats">

            <div class="stat">

                <span>
                    Current Approvals
                </span>

                <strong>
                    <%= currentCount %>
                </strong>

            </div>

            <div class="stat">

                <span>
                    Simulated Approvals
                </span>

                <strong>
                    <%= simulatedCount %>
                </strong>

            </div>

            <div class="stat">

                <span>
                    Newly Added
                </span>

                <strong>
                    +<%= addedCount %>
                </strong>

            </div>

            <div class="stat">

                <span>
                    No Longer Applicable
                </span>

                <strong>
                    <%= removedCount %>
                </strong>

            </div>

        </section>

        <section class="results-grid">

            <div class="result-box added">

                <h3>
                    + Newly Applicable
                </h3>

                <%
                if (addedApprovals != null
                        && !addedApprovals.isEmpty()) {

                    for (BusinessApproval item
                            : addedApprovals) {
                %>

                    <div class="approval-item">

                        <strong>
                            <%= item.getApprovalName() %>
                        </strong>

                        <span>
                            <%= item.getApprovalCode() != null
                                    ? item.getApprovalCode()
                                    : "" %>
                        </span>

                    </div>

                <%
                    }
                } else {
                %>

                    <div class="empty">
                        No new approval detected.
                    </div>

                <%
                }
                %>

            </div>

            <div class="result-box removed">

                <h3>
                    − No Longer Applicable
                </h3>

                <%
                if (removedApprovals != null
                        && !removedApprovals.isEmpty()) {

                    for (BusinessApproval item
                            : removedApprovals) {
                %>

                    <div class="approval-item">

                        <strong>
                            <%= item.getApprovalName() %>
                        </strong>

                        <span>
                            <%= item.getApprovalCode() != null
                                    ? item.getApprovalCode()
                                    : "" %>
                        </span>

                    </div>

                <%
                    }
                } else {
                %>

                    <div class="empty">
                        No approval removed.
                    </div>

                <%
                }
                %>

            </div>

            <div class="result-box unchanged">

                <h3>
                    = Still Applicable
                </h3>

                <%
                if (unchangedApprovals != null
                        && !unchangedApprovals.isEmpty()) {

                    for (BusinessApproval item
                            : unchangedApprovals) {
                %>

                    <div class="approval-item">

                        <strong>
                            <%= item.getApprovalName() %>
                        </strong>

                        <span>
                            Remains applicable
                        </span>

                    </div>

                <%
                    }
                } else {
                %>

                    <div class="empty">
                        No unchanged approval detected.
                    </div>

                <%
                }
                %>

            </div>

        </section>

        <div class="impact">

            <strong>
                CHAPERON Impact Summary:
            </strong>

            Under this simulated scenario,
            <strong>
                <%= addedCount %>
            </strong>
            additional approval(s) may become applicable and
            <strong>
                <%= removedCount %>
            </strong>
            existing approval(s) may no longer match the
            configured rules.

        </div>

    <%
    }
    %>

</main>

</body>

</html>
