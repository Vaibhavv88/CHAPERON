<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>GIS Project Screening | CHAPERON</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary: #0877e8;
            --primary-dark: #0757b5;
            --navy: #102a50;
            --text: #344f70;
            --muted: #71849d;
            --background: #f1f6fc;
            --border: #dce7f2;
            --success: #07833f;
            --warning: #bd6800;
            --danger: #c4322b;
            --purple: #6645c7;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            color: var(--navy);
            background: var(--background);
        }

        a {
            text-decoration: none;
        }

        .topbar {
            min-height: 76px;
            padding: 13px 5%;
            background: #ffffff;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 30;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .brand img {
            width: 51px;
            height: 51px;
            object-fit: contain;
            border-radius: 10px;
        }

        .brand-name {
            font-size: 22px;
            font-weight: 800;
            color: #092b59;
        }

        .brand-tagline {
            margin-top: 3px;
            color: #7588a0;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 0.7px;
        }

        .navigation {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .nav-link {
            color: #075ebf;
            background: #edf5ff;
            padding: 10px 14px;
            border-radius: 9px;
            font-size: 13px;
            font-weight: 700;
        }

        .page {
            width: min(1380px, 93%);
            margin: 27px auto 55px;
        }

        .back-link {
            display: inline-block;
            color: #075ebf;
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 17px;
        }

        .hero {
            background:
                radial-gradient(
                    circle at 90% 20%,
                    rgba(255,255,255,0.17),
                    transparent 25%
                ),
                linear-gradient(
                    130deg,
                    #064eae,
                    #087ced,
                    #24a0ed
                );
            color: #ffffff;
            border-radius: 20px;
            padding: 29px 31px;
            box-shadow: 0 14px 33px rgba(7, 91, 181, 0.2);
        }

        .hero-label {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 100px;
            background: rgba(255,255,255,0.15);
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.7px;
        }

        .hero h1 {
            margin-top: 13px;
            font-size: 29px;
        }

        .hero p {
            max-width: 900px;
            margin-top: 10px;
            color: #eaf5ff;
            font-size: 14px;
            line-height: 1.7;
        }

        .hero-actions {
            display: flex;
            gap: 11px;
            margin-top: 21px;
            flex-wrap: wrap;
        }

        .run-form {
            display: inline-block;
        }

        .button {
            border: 0;
            border-radius: 10px;
            padding: 12px 18px;
            font-size: 13px;
            font-weight: 800;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .button-white {
            background: #ffffff;
            color: #075fc2;
        }

        .button-outline {
            color: #ffffff;
            border: 1px solid rgba(255,255,255,0.55);
            background: rgba(255,255,255,0.08);
        }

        .message {
            margin-top: 20px;
            border-radius: 11px;
            padding: 14px 17px;
            font-size: 13px;
            font-weight: 700;
            line-height: 1.6;
        }

        .message-success {
            color: #087238;
            background: #e5f8ec;
            border: 1px solid #a9dfbb;
        }

        .message-warning {
            color: #8e5400;
            background: #fff7df;
            border: 1px solid #eed797;
        }

        .message-error {
            color: #ae2b25;
            background: #fff0ef;
            border: 1px solid #edb8b4;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 15px;
            margin-top: 21px;
        }

        .summary-card {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: 15px;
            padding: 19px;
            box-shadow: 0 8px 22px rgba(29, 68, 109, 0.05);
        }

        .summary-label {
            color: var(--muted);
            font-size: 11px;
            font-weight: 800;
        }

        .summary-value {
            display: block;
            margin-top: 11px;
            color: var(--navy);
            font-size: 24px;
            font-weight: 800;
            overflow-wrap: anywhere;
        }

        .summary-unit {
            margin-top: 5px;
            color: var(--muted);
            font-size: 11px;
        }

        .result-summary {
            margin-top: 20px;
            padding: 18px 20px;
            border-radius: 13px;
            background: #ffffff;
            border: 1px solid var(--border);
            color: var(--text);
            line-height: 1.7;
            font-size: 14px;
        }

        .section {
            margin-top: 23px;
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 9px 26px rgba(26, 65, 105, 0.05);
        }

        .section-header {
            padding: 21px 23px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
        }

        .section-header h2 {
            font-size: 20px;
        }

        .section-header p {
            margin-top: 6px;
            color: var(--muted);
            font-size: 12px;
            line-height: 1.6;
        }

        .count-badge {
            background: #eaf3ff;
            color: #075fbf;
            border-radius: 100px;
            padding: 7px 11px;
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
        }

        .section-body {
            padding: 21px 23px;
        }

        .finding-list,
        .recommendation-list {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .finding-card,
        .recommendation-card {
            border: 1px solid #dce7f2;
            border-radius: 13px;
            padding: 17px;
            background: #fbfdff;
        }

        .finding-top,
        .recommendation-top {
            display: flex;
            justify-content: space-between;
            gap: 13px;
            align-items: flex-start;
        }

        .finding-title,
        .recommendation-title {
            font-size: 16px;
            font-weight: 800;
            color: #102f5b;
        }

        .finding-layer {
            margin-top: 5px;
            color: #0870d1;
            font-size: 12px;
            font-weight: 700;
        }

        .finding-message,
        .recommendation-reason {
            margin-top: 12px;
            color: #526b85;
            font-size: 13px;
            line-height: 1.65;
        }

        .finding-data {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-top: 14px;
        }

        .data-box {
            padding: 11px;
            border-radius: 9px;
            background: #f0f6fc;
        }

        .data-box span {
            display: block;
            color: #7a8da3;
            font-size: 10px;
            font-weight: 800;
        }

        .data-box strong {
            display: block;
            margin-top: 6px;
            color: #22476f;
            font-size: 12px;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 100px;
            padding: 6px 10px;
            font-size: 10px;
            font-weight: 800;
            white-space: nowrap;
        }

        .badge-required {
            color: #b2221c;
            background: #ffe7e5;
        }

        .badge-review {
            color: #a05a00;
            background: #fff0d2;
        }

        .badge-maybe {
            color: #5940a6;
            background: #efeaff;
        }

        .badge-clear {
            color: #077439;
            background: #def5e7;
        }

        .badge-intersection {
            color: #ae2924;
            background: #ffe8e6;
        }

        .badge-nearby {
            color: #075ebc;
            background: #e4f1ff;
        }

        .badge-pending {
            color: #946000;
            background: #fff0cc;
        }

        .badge-confirmed {
            color: #08743b;
            background: #e0f6e8;
        }

        .badge-rejected {
            color: #ae2a26;
            background: #fee5e3;
        }

        .empty-state {
            padding: 43px 20px;
            border: 1px dashed #b9ccdf;
            border-radius: 12px;
            background: #f7fbff;
            text-align: center;
            color: #71859c;
            line-height: 1.7;
        }

        .empty-icon {
            display: block;
            font-size: 32px;
            margin-bottom: 11px;
        }

        .disclaimer {
            margin-top: 22px;
            padding: 17px 19px;
            border-left: 4px solid #805fd1;
            border-radius: 10px;
            background: #f4f0ff;
            color: #56477f;
            font-size: 12px;
            line-height: 1.7;
        }

        @media (max-width: 1100px) {
            .summary-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 720px) {
            .topbar {
                align-items: flex-start;
                flex-direction: column;
                gap: 12px;
            }

            .summary-grid {
                grid-template-columns: 1fr 1fr;
            }

            .finding-data {
                grid-template-columns: 1fr;
            }

            .finding-top,
            .recommendation-top {
                flex-direction: column;
            }
        }

        @media (max-width: 470px) {
            .summary-grid {
                grid-template-columns: 1fr;
            }

            .page {
                width: 94%;
            }

            .hero {
                padding: 23px 20px;
            }

            .hero h1 {
                font-size: 24px;
            }
        }
    </style>
</head>

<body>

<c:set var="ctx"
       value="${pageContext.request.contextPath}"/>

<header class="topbar">

    <a class="brand"
       href="${ctx}/entrepreneur/dashboard">

        <img src="${ctx}/images/chaperon-logo.jpeg"
             alt="CHAPERON Logo">

        <div>
            <div class="brand-name">
                CHAPERON
            </div>

            <div class="brand-tagline">
                GUIDE. CONNECT. COMPLY. GET APPROVED.
            </div>
        </div>
    </a>

    <nav class="navigation">
        <a class="nav-link"
           href="${ctx}/entrepreneur/dashboard">
            Dashboard
        </a>

        <a class="nav-link"
           href="${ctx}/entrepreneur/clearances">
            Unified Clearances
        </a>

        <a class="nav-link"
           href="${ctx}/entrepreneur/documents">
            Document Vault
        </a>
    </nav>

</header>

<main class="page">

    <a class="back-link"
       href="${ctx}/entrepreneur/clearances/new?id=${screeningResult.clearanceApplicationId}">
        ← Back to clearance application
    </a>

    <section class="hero">

        <span class="hero-label">
            GIS PROJECT SCREENING
        </span>

        <h1>Project Location Risk Screening</h1>

        <p>
            CHAPERON compares your saved project boundary with
            active official Forest, Protected Area,
            Eco-Sensitive Zone, CRZ, Settlement and other
            regulatory GIS layers.
        </p>

        <div class="hero-actions">

            <form class="run-form"
                  method="post"
                  action="${ctx}/entrepreneur/gis-screening"
                  id="screeningForm">

                <input type="hidden"
                       name="applicationId"
                       value="${screeningResult.clearanceApplicationId}">

                <button type="submit"
                        class="button button-white"
                        id="runButton">

                    <c:choose>
                        <c:when test="${screeningResult.analysisCompleted}">
                            Run Screening Again
                        </c:when>

                        <c:otherwise>
                            Run Spatial Screening
                        </c:otherwise>
                    </c:choose>

                </button>
            </form>

            <a class="button button-outline"
               href="${ctx}/entrepreneur/clearances/new?id=${screeningResult.clearanceApplicationId}">
                Edit Project Boundary
            </a>

        </div>

    </section>

    <c:if test="${not empty successMessage}">
        <div class="message message-success">
            ${successMessage}
        </div>
    </c:if>

    <c:if test="${not empty warningMessage}">
        <div class="message message-warning">
            ${warningMessage}
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="message message-error">
            ${errorMessage}
        </div>
    </c:if>

    <section class="summary-grid">

        <div class="summary-card">
            <div class="summary-label">
                PROJECT AREA
            </div>

            <strong class="summary-value">
                <c:choose>
                    <c:when test="${not empty screeningResult.projectAreaHectares}">
                        ${screeningResult.projectAreaHectares}
                    </c:when>

                    <c:otherwise>
                        —
                    </c:otherwise>
                </c:choose>
            </strong>

            <div class="summary-unit">
                Hectares
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-label">
                LAYERS CHECKED
            </div>

            <strong class="summary-value">
                ${screeningResult.checkedLayerCount}
            </strong>

            <div class="summary-unit">
                Active official layers
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-label">
                INTERSECTIONS
            </div>

            <strong class="summary-value">
                ${screeningResult.intersectingFeatureCount}
            </strong>

            <div class="summary-unit">
                Boundary overlaps
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-label">
                NEARBY FEATURES
            </div>

            <strong class="summary-value">
                ${screeningResult.nearbyFeatureCount}
            </strong>

            <div class="summary-unit">
                Within configured distance
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-label">
                RECOMMENDATIONS
            </div>

            <strong class="summary-value">
                ${screeningResult.recommendationCount}
            </strong>

            <div class="summary-unit">
                Clearance recommendations
            </div>
        </div>

    </section>

    <div class="result-summary">

        <strong>Screening status:</strong>

        <c:choose>
            <c:when test="${screeningResult.analysisStatus eq 'COMPLETED'}">
                <span class="badge badge-clear">
                    COMPLETED
                </span>
            </c:when>

            <c:when test="${screeningResult.analysisStatus eq 'BOUNDARY_REQUIRED'}">
                <span class="badge badge-review">
                    BOUNDARY REQUIRED
                </span>
            </c:when>

            <c:when test="${screeningResult.analysisStatus eq 'INVALID_BOUNDARY'}">
                <span class="badge badge-required">
                    INVALID BOUNDARY
                </span>
            </c:when>

            <c:when test="${screeningResult.analysisStatus eq 'NO_ACTIVE_LAYERS'}">
                <span class="badge badge-review">
                    OFFICIAL DATA REQUIRED
                </span>
            </c:when>

            <c:otherwise>
                <span class="badge badge-pending">
                    NOT RUN
                </span>
            </c:otherwise>
        </c:choose>

        <br><br>

        <c:out value="${screeningResult.summaryMessage}"/>
    </div>

    <!-- Spatial findings -->
    <section class="section">

        <div class="section-header">
            <div>
                <h2>Spatial Findings</h2>

                <p>
                    Intersections and nearby regulated features
                    found using your saved project boundary.
                </p>
            </div>

            <span class="count-badge">
                ${screeningResult.findings.size()} findings
            </span>
        </div>

        <div class="section-body">

            <c:choose>

                <c:when test="${empty screeningResult.findings}">
                    <div class="empty-state">
                        <span class="empty-icon">⌖</span>

                        No spatial finding is available yet.
                        Run spatial screening after saving the
                        project boundary.
                    </div>
                </c:when>

                <c:otherwise>

                    <div class="finding-list">

                        <c:forEach var="finding"
                                   items="${screeningResult.findings}">

                            <article class="finding-card">

                                <div class="finding-top">

                                    <div>
                                        <div class="finding-title">
                                            <c:out value="${finding.featureName}"/>
                                        </div>

                                        <div class="finding-layer">
                                            <c:out value="${finding.layerName}"/>
                                            •
                                            <c:out value="${finding.layerCategory}"/>
                                        </div>
                                    </div>

                                    <c:choose>
                                        <c:when test="${finding.spatialRelation eq 'INTERSECTS'}">
                                            <span class="badge badge-intersection">
                                                INTERSECTION
                                            </span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="badge badge-nearby">
                                                NEARBY FEATURE
                                            </span>
                                        </c:otherwise>
                                    </c:choose>

                                </div>

                                <div class="finding-message">
                                    <c:out value="${finding.findingMessage}"/>
                                </div>

                                <div class="finding-data">

                                    <div class="data-box">
                                        <span>DISTANCE</span>

                                        <strong>
                                            <c:choose>
                                                <c:when test="${not empty finding.distanceKilometres}">
                                                    ${finding.distanceKilometres} km
                                                </c:when>

                                                <c:otherwise>
                                                    —
                                                </c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </div>

                                    <div class="data-box">
                                        <span>OVERLAP AREA</span>

                                        <strong>
                                            <c:choose>
                                                <c:when test="${not empty finding.intersectionAreaHectares}">
                                                    ${finding.intersectionAreaHectares} ha
                                                </c:when>

                                                <c:otherwise>
                                                    —
                                                </c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </div>

                                    <div class="data-box">
                                        <span>OVERLAP PERCENTAGE</span>

                                        <strong>
                                            <c:choose>
                                                <c:when test="${not empty finding.intersectionPercentage}">
                                                    ${finding.intersectionPercentage}%
                                                </c:when>

                                                <c:otherwise>
                                                    —
                                                </c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </div>

                                </div>

                            </article>

                        </c:forEach>

                    </div>

                </c:otherwise>

            </c:choose>

        </div>

    </section>

    <!-- Recommendations -->
    <section class="section">

        <div class="section-header">
            <div>
                <h2>Recommended Clearances</h2>

                <p>
                    Clearance applicability generated from GIS
                    findings and active applicability rules.
                </p>
            </div>

            <span class="count-badge">
                ${screeningResult.recommendations.size()}
                recommendations
            </span>
        </div>

        <div class="section-body">

            <c:choose>

                <c:when test="${empty screeningResult.recommendations}">
                    <div class="empty-state">
                        <span class="empty-icon">✓</span>

                        No GIS-based clearance recommendation
                        has been generated yet.
                    </div>
                </c:when>

                <c:otherwise>

                    <div class="recommendation-list">

                        <c:forEach var="recommendation"
                                   items="${screeningResult.recommendations}">

                            <article class="recommendation-card">

                                <div class="recommendation-top">

                                    <div>
                                        <div class="recommendation-title">
                                            <c:out value="${recommendation.clearanceName}"/>
                                        </div>

                                        <c:if test="${not empty recommendation.clearanceCode}">
                                            <div class="finding-layer">
                                                <c:out value="${recommendation.clearanceCode}"/>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div>
                                        <c:choose>
                                            <c:when test="${recommendation.recommendationLevel eq 'REQUIRED'}">
                                                <span class="badge badge-required">
                                                    REQUIRED
                                                </span>
                                            </c:when>

                                            <c:when test="${recommendation.recommendationLevel eq 'REVIEW_REQUIRED'}">
                                                <span class="badge badge-review">
                                                    REVIEW REQUIRED
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="badge badge-maybe">
                                                    MAY BE REQUIRED
                                                </span>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:choose>
                                            <c:when test="${recommendation.status eq 'OFFICER_CONFIRMED'}">
                                                <span class="badge badge-confirmed">
                                                    OFFICER CONFIRMED
                                                </span>
                                            </c:when>

                                            <c:when test="${recommendation.status eq 'OFFICER_REJECTED'}">
                                                <span class="badge badge-rejected">
                                                    OFFICER REJECTED
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="badge badge-pending">
                                                    SYSTEM SCREENING
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                </div>

                                <div class="recommendation-reason">
                                    <c:out value="${recommendation.recommendationReason}"/>
                                </div>

                            </article>

                        </c:forEach>

                    </div>

                </c:otherwise>

            </c:choose>

        </div>

    </section>

    <div class="disclaimer">

        <strong>Important:</strong>

        This GIS output is a preliminary system screening result.
        It does not itself grant or reject any statutory clearance.
        Final applicability and approval decisions remain subject
        to verification by the concerned government department
        and authorised officer.

    </div>

</main>

<script>
    const screeningForm =
        document.getElementById('screeningForm');

    const runButton =
        document.getElementById('runButton');

    screeningForm.addEventListener(
        'submit',
        function () {
            runButton.disabled = true;
            runButton.textContent =
                'Running GIS Screening...';
        }
    );
</script>

</body>
</html>