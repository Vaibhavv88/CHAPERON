<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Collections" %>

<%!
    private String html(Object value) {

        if (value == null) {
            return "";
        }

        return value.toString()
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String text(Object value, String defaultValue) {

        if (value == null) {
            return defaultValue;
        }

        String result = value.toString().trim();

        if (result.isEmpty()
                || "null".equalsIgnoreCase(result)) {

            return defaultValue;
        }

        return result;
    }

    private String cssStatus(Object value) {

        if (value == null) {
            return "pending";
        }

        return value.toString()
                .toLowerCase()
                .replace("_", "-")
                .replace(" ", "-");
    }
%>

<%
    String contextPath = request.getContextPath();

    Map<String, Object> gisApplication =
            (Map<String, Object>)
            request.getAttribute("application");

    List<Map<String, Object>> spatialFindings =
            (List<Map<String, Object>>)
            request.getAttribute("spatialFindings");

    List<Map<String, Object>> gisRecommendations =
            (List<Map<String, Object>>)
            request.getAttribute("gisRecommendations");

    if (gisApplication == null) {
        gisApplication = Collections.emptyMap();
    }

    if (spatialFindings == null) {
        spatialFindings = Collections.emptyList();
    }

    if (gisRecommendations == null) {
        gisRecommendations = Collections.emptyList();
    }

    Object applicationIdObject =
            gisApplication.get("applicationId");

    String applicationId =
            text(applicationIdObject, "");

    /*
     * Determine final GIS verification status.
     */

    String finalVerificationStatus = "PENDING";
    String savedOfficerRemarks = "";

    for (Map<String, Object> finding : spatialFindings) {

        String findingStatus = text(
                finding.get("verificationStatus"),
                "PENDING"
        );

        if (!"PENDING".equalsIgnoreCase(
                findingStatus)) {

            finalVerificationStatus = findingStatus;
        }

        String findingRemarks = text(
                finding.get("officerRemarks"),
                ""
        );

        if (!findingRemarks.isBlank()) {
            savedOfficerRemarks = findingRemarks;
        }
    }

    /*
     * Fallback application ID from URL.
     */

    if (applicationId.isBlank()) {

        applicationId =
                text(
                    request.getParameter("id"),
                    ""
                );
    }

    boolean decisionPending =
            "PENDING".equalsIgnoreCase(
                    finalVerificationStatus
            );

    boolean verified =
            "VERIFIED".equalsIgnoreCase(
                    finalVerificationStatus
            );

    boolean rejected =
            "REJECTED".equalsIgnoreCase(
                    finalVerificationStatus
            );

    String urlStatus =
            request.getParameter("status");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>GIS Application Review | CHAPERON</title>

    <style>

        * {
            box-sizing: border-box;
        }

        :root {
            --green-dark: #064e3b;
            --green-main: #059669;
            --green-bright: #10b981;
            --green-light: #d1fae5;
            --green-soft: #ecfdf5;
            --green-border: #b7e4cf;
            --text-dark: #022c22;
            --text-muted: #527066;
            --white: #ffffff;
            --red: #dc2626;
            --red-light: #fee2e2;
            --amber: #d97706;
            --amber-light: #fef3c7;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background:
                linear-gradient(
                    135deg,
                    #f0fdf9 0%,
                    #f8fffc 45%,
                    #e8f8f0 100%
                );
            color: var(--text-dark);
            min-height: 100vh;
        }

        a {
            text-decoration: none;
        }

        .topbar {
            background: var(--white);
            border-bottom: 1px solid var(--green-border);
            box-shadow: 0 4px 18px rgba(6, 78, 59, 0.06);
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .topbar-inner {
            max-width: 1400px;
            margin: auto;
            padding: 17px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .brand-icon {
            width: 44px;
            height: 44px;
            border-radius: 13px;
            background:
                linear-gradient(
                    135deg,
                    var(--green-main),
                    var(--green-bright)
                );
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            font-weight: 800;
        }

        .brand-name {
            color: var(--green-dark);
            font-size: 22px;
            font-weight: 800;
        }

        .brand-tagline {
            color: var(--text-muted);
            font-size: 11px;
            margin-top: 3px;
        }

        .top-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .nav-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 11px 17px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            border: 1px solid var(--green-border);
            color: var(--green-dark);
            background: var(--green-soft);
        }

        .nav-button:hover {
            background: var(--green-light);
        }

        .page {
            width: min(1400px, calc(100% - 32px));
            margin: 30px auto 60px;
        }

        .hero {
            padding: 32px;
            border-radius: 22px;
            color: white;
            background:
                linear-gradient(
                    135deg,
                    #065f46,
                    #059669
                );
            box-shadow: 0 16px 35px rgba(5, 150, 105, 0.18);
        }

        .hero-top {
            display: flex;
            justify-content: space-between;
            gap: 25px;
            align-items: flex-start;
        }

        .eyebrow {
            display: inline-block;
            padding: 7px 11px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.15);
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        .hero h1 {
            font-size: 33px;
            margin: 16px 0 9px;
        }

        .hero p {
            margin: 0;
            line-height: 1.6;
            color: rgba(255, 255, 255, 0.88);
        }

        .status-large {
            display: inline-flex;
            padding: 10px 17px;
            border-radius: 999px;
            background: white;
            color: var(--green-dark);
            font-weight: 800;
            white-space: nowrap;
        }

        .details-grid {
            display: grid;
            grid-template-columns:
                repeat(4, minmax(0, 1fr));
            gap: 15px;
            margin-top: 27px;
        }

        .detail-box {
            padding: 16px;
            border-radius: 13px;
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.18);
        }

        .detail-label {
            color: rgba(255, 255, 255, 0.75);
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .detail-value {
            font-size: 15px;
            font-weight: 800;
            overflow-wrap: anywhere;
        }

        .message {
            margin-top: 22px;
            padding: 15px 18px;
            border-radius: 12px;
            font-weight: 700;
        }

        .message-success {
            color: #065f46;
            background: #d1fae5;
            border: 1px solid #a7f3d0;
        }

        .message-error {
            color: #991b1b;
            background: #fee2e2;
            border: 1px solid #fecaca;
        }

        .section {
            margin-top: 27px;
            background: var(--white);
            border: 1px solid var(--green-border);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 13px 30px rgba(6, 78, 59, 0.07);
        }

        .section-heading {
            padding: 24px 29px;
            border-bottom: 1px solid var(--green-border);
        }

        .section-heading h2 {
            margin: 0 0 6px;
            font-size: 24px;
            color: var(--green-dark);
        }

        .section-heading p {
            margin: 0;
            color: var(--text-muted);
        }

        .section-content {
            padding: 28px;
        }

        .empty-state {
            padding: 26px;
            border-radius: 13px;
            text-align: center;
            color: var(--text-muted);
            background: var(--green-soft);
            border: 1px dashed var(--green-border);
        }

        .result-card {
            padding: 24px;
            border: 1px solid var(--green-border);
            border-left: 5px solid var(--green-main);
            border-radius: 16px;
            background: #fcfffd;
        }

        .result-card + .result-card {
            margin-top: 18px;
        }

        .card-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 18px;
        }

        .result-card h3 {
            margin: 0;
            color: var(--green-main);
            font-size: 19px;
        }

        .card-subtitle {
            margin-top: 5px;
            color: #047857;
            font-size: 13px;
            font-weight: 800;
        }

        .badges {
            display: flex;
            gap: 7px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .badge {
            display: inline-flex;
            padding: 7px 13px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .badge-intersects,
        .badge-required,
        .badge-rejected,
        .badge-officer-rejected {
            color: #b91c1c;
            background: var(--red-light);
        }

        .badge-pending,
        .badge-review-required {
            color: #92400e;
            background: var(--amber-light);
        }

        .badge-verified,
        .badge-officer-confirmed {
            color: #047857;
            background: var(--green-light);
        }

        .badge-system-recommended {
            color: #075985;
            background: #e0f2fe;
        }

        .description {
            margin: 19px 0 0;
            color: #365f52;
            line-height: 1.65;
        }

        .feature {
            margin: 17px 0 0;
            color: #365f52;
        }

        .metrics {
            display: grid;
            grid-template-columns:
                repeat(3, minmax(0, 1fr));
            gap: 14px;
            margin-top: 21px;
        }

        .metric {
            padding: 17px;
            border-radius: 12px;
            background: #eef8f3;
            border: 1px solid #d0e9dc;
        }

        .metric-label {
            color: var(--text-muted);
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
            margin-bottom: 7px;
        }

        .metric-value {
            color: var(--text-dark);
            font-size: 15px;
            font-weight: 800;
        }

        .verification-box {
            padding: 24px;
            border: 1px solid var(--green-border);
            border-radius: 16px;
            background: var(--green-soft);
        }

        label {
            display: block;
            margin-bottom: 10px;
            color: var(--green-dark);
            font-size: 17px;
            font-weight: 800;
        }

        textarea {
            width: 100%;
            min-height: 145px;
            padding: 16px;
            resize: vertical;
            border: 1px solid #a7d8c2;
            border-radius: 12px;
            font: inherit;
            color: var(--text-dark);
            background: white;
            outline: none;
        }

        textarea:focus {
            border-color: var(--green-main);
            box-shadow: 0 0 0 3px rgba(5, 150, 105, 0.12);
        }

        .button-row {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 18px;
        }

        button {
            border: none;
            cursor: pointer;
            padding: 14px 23px;
            border-radius: 11px;
            color: white;
            font-size: 15px;
            font-weight: 800;
        }

        .verify-button {
            background: var(--green-main);
        }

        .verify-button:hover {
            background: #047857;
        }

        .reject-button {
            background: #d7352d;
        }

        .reject-button:hover {
            background: #b91c1c;
        }

        .decision-completed {
            padding: 25px;
            border: 1px solid var(--green-border);
            border-left: 5px solid var(--green-main);
            border-radius: 15px;
            background: var(--green-soft);
        }

        .decision-completed.rejected {
            border-color: #fecaca;
            border-left-color: var(--red);
            background: #fff7f7;
        }

        .decision-completed h3 {
            margin: 0 0 15px;
            color: var(--green-main);
        }

        .decision-completed.rejected h3 {
            color: var(--red);
        }

        .decision-status {
            display: inline-flex;
            padding: 8px 13px;
            margin-bottom: 15px;
            border-radius: 999px;
            color: #047857;
            background: var(--green-light);
            font-weight: 800;
        }

        .rejected .decision-status {
            color: #b91c1c;
            background: var(--red-light);
        }

        .saved-remarks {
            margin-top: 12px;
            padding: 16px;
            border-radius: 11px;
            background: white;
            border: 1px solid var(--green-border);
            line-height: 1.6;
            white-space: pre-wrap;
        }

        .notice {
            margin-top: 28px;
            padding: 21px 24px;
            border-left: 5px solid var(--green-main);
            border-radius: 13px;
            color: #065f46;
            background: #e7f8f0;
            line-height: 1.6;
        }

        @media (max-width: 900px) {

            .details-grid {
                grid-template-columns:
                    repeat(2, minmax(0, 1fr));
            }

            .metrics {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 620px) {

            .topbar-inner,
            .hero-top,
            .card-top {
                flex-direction: column;
            }

            .details-grid {
                grid-template-columns: 1fr;
            }

            .page {
                width: min(100% - 20px, 1400px);
                margin-top: 18px;
            }

            .hero,
            .section-content,
            .section-heading {
                padding: 21px;
            }

            .hero h1 {
                font-size: 26px;
            }

            .badges {
                justify-content: flex-start;
            }

            button {
                width: 100%;
            }
        }

    </style>

</head>

<body>

<header class="topbar">

    <div class="topbar-inner">

        <div class="brand">

            <div class="brand-icon">C</div>

            <div>

                <div class="brand-name">
                    CHAPERON
                </div>

                <div class="brand-tagline">
                    GUIDE. CONNECT. COMPLY. GET APPROVED.
                </div>

            </div>

        </div>

        <div class="top-actions">

            <a class="nav-button"
               href="<%= contextPath %>/officer/gis-verification">
                ← GIS Queue
            </a>

            <a class="nav-button"
               href="<%= contextPath %>/officer/dashboard">
                Officer Dashboard
            </a>

        </div>

    </div>

</header>

<main class="page">

    <section class="hero">

        <div class="hero-top">

            <div>

                <span class="eyebrow">
                    Government Officer GIS Review
                </span>

                <h1>
                    <%= html(
                        text(
                            gisApplication.get("projectTitle"),
                            "GIS Application Review"
                        )
                    ) %>
                </h1>

                <p>
                    Review spatial findings and verify the
                    system-generated clearance recommendation.
                </p>

            </div>

            <div class="status-large">
                <%= html(finalVerificationStatus) %>
            </div>

        </div>

        <div class="details-grid">

            <div class="detail-box">

                <div class="detail-label">
                    Application Number
                </div>

                <div class="detail-value">
                    <%= html(
                        text(
                            gisApplication.get("applicationNumber"),
                            "Not available"
                        )
                    ) %>
                </div>

            </div>

            <div class="detail-box">

                <div class="detail-label">
                    Applicant
                </div>

                <div class="detail-value">
                    <%= html(
                        text(
                            gisApplication.get("applicantName"),
                            "Not available"
                        )
                    ) %>
                </div>

            </div>

            <div class="detail-box">

                <div class="detail-label">
                    Location
                </div>

                <div class="detail-value">

                    <%= html(
                        text(
                            gisApplication.get("district"),
                            "Not available"
                        )
                    ) %>,

                    <%= html(
                        text(
                            gisApplication.get("state"),
                            ""
                        )
                    ) %>

                </div>

            </div>

            <div class="detail-box">

                <div class="detail-label">
                    Project Area
                </div>

                <div class="detail-value">

                    <%= html(
                        text(
                            gisApplication.get("projectAreaHectares"),
                            "0"
                        )
                    ) %> ha

                </div>

            </div>

        </div>

    </section>

    <%
    if ("verified".equalsIgnoreCase(urlStatus)) {
    %>

        <div class="message message-success">
            GIS recommendation verified successfully.
        </div>

    <%
    } else if ("rejected".equalsIgnoreCase(urlStatus)) {
    %>

        <div class="message message-error">
            GIS recommendation rejected successfully.
        </div>

    <%
    }
    %>

    <section class="section">

        <div class="section-heading">

            <h2>Spatial Findings</h2>

            <p>
                Intersections and proximity conditions found
                using the saved project boundary.
            </p>

        </div>

        <div class="section-content">

            <%
            if (spatialFindings.isEmpty()) {
            %>

                <div class="empty-state">
                    No GIS spatial findings are available.
                </div>

            <%
            } else {

                for (Map<String, Object> finding
                        : spatialFindings) {

                    String layerName =
                            text(
                                finding.get("layerName"),
                                "GIS Layer"
                            );

                    String layerCategory =
                            text(
                                finding.get("layerCategory"),
                                "Not available"
                            );

                    String spatialRelation =
                            text(
                                finding.get("spatialRelation"),
                                "Not available"
                            );

                    String featureName =
                            text(
                                finding.get("featureName"),
                                ""
                            );

                    String analysisMessage =
                            text(
                                finding.get("analysisMessage"),
                                "No analysis message available."
                            );

                    String verificationStatus =
                            text(
                                finding.get("verificationStatus"),
                                "PENDING"
                            );
            %>

                <article class="result-card">

                    <div class="card-top">

                        <div>

                            <h3>
                                <%= html(layerName) %>
                            </h3>

                            <div class="card-subtitle">

                                <%= html(layerCategory) %>
                                ·
                                <%= html(spatialRelation) %>

                            </div>

                        </div>

                        <div class="badges">

                            <span class="badge badge-<%=
                                    cssStatus(spatialRelation)
                            %>">
                                <%= html(spatialRelation) %>
                            </span>

                            <span class="badge badge-<%=
                                    cssStatus(verificationStatus)
                            %>">
                                <%= html(verificationStatus) %>
                            </span>

                        </div>

                    </div>

                    <%
                    if (!featureName.isBlank()) {
                    %>

                        <p class="feature">

                            <strong>Feature:</strong>
                            <%= html(featureName) %>

                        </p>

                    <%
                    }
                    %>

                    <p class="description">
                        <%= html(analysisMessage) %>
                    </p>

                    <div class="metrics">

                        <div class="metric">

                            <div class="metric-label">
                                Distance
                            </div>

                            <div class="metric-value">

                                <%= html(
                                    text(
                                        finding.get("distanceKm"),
                                        "0.0000"
                                    )
                                ) %> km

                            </div>

                        </div>

                        <div class="metric">

                            <div class="metric-label">
                                Intersection Area
                            </div>

                            <div class="metric-value">

                                <%= html(
                                    text(
                                        finding.get(
                                            "intersectionAreaHectares"
                                        ),
                                        "0.0000"
                                    )
                                ) %> ha

                            </div>

                        </div>

                        <div class="metric">

                            <div class="metric-label">
                                Intersection Percentage
                            </div>

                            <div class="metric-value">

                                <%= html(
                                    text(
                                        finding.get(
                                            "intersectionPercentage"
                                        ),
                                        "0.0000"
                                    )
                                ) %>%

                            </div>

                        </div>

                    </div>

                </article>

            <%
                }
            }
            %>

        </div>

    </section>

    <section class="section">

        <div class="section-heading">

            <h2>Recommended Clearances</h2>

            <p>
                Clearance applicability generated from the
                spatial screening result.
            </p>

        </div>

        <div class="section-content">

            <%
            if (gisRecommendations.isEmpty()) {
            %>

                <div class="empty-state">
                    No GIS clearance recommendation is available.
                </div>

            <%
            } else {

                for (Map<String, Object> recommendation
                        : gisRecommendations) {

                    String clearanceName =
                            text(
                                recommendation.get("clearanceName"),
                                "Recommended Clearance"
                            );

                    String clearanceCode =
                            text(
                                recommendation.get("clearanceCode"),
                                "Not available"
                            );

                    String recommendationLevel =
                            text(
                                recommendation.get(
                                    "recommendationLevel"
                                ),
                                "REVIEW_REQUIRED"
                            );

                    String recommendationReason =
                            text(
                                recommendation.get(
                                    "recommendationReason"
                                ),
                                "No recommendation reason available."
                            );

                    String generatedFrom =
                            text(
                                recommendation.get("generatedFrom"),
                                "GIS"
                            );

                    String recommendationStatus =
                            text(
                                recommendation.get("status"),
                                "SYSTEM_RECOMMENDED"
                            );
            %>

                <article class="result-card">

                    <div class="card-top">

                        <div>

                            <h3>
                                <%= html(clearanceName) %>
                            </h3>

                            <div class="card-subtitle">

                                <%= html(clearanceCode) %>
                                ·
                                <%= html(generatedFrom) %>

                            </div>

                        </div>

                        <div class="badges">

                            <span class="badge badge-<%=
                                    cssStatus(recommendationLevel)
                            %>">
                                <%= html(recommendationLevel) %>
                            </span>

                            <span class="badge badge-<%=
                                    cssStatus(recommendationStatus)
                            %>">
                                <%= html(recommendationStatus) %>
                            </span>

                        </div>

                    </div>

                    <p class="description">
                        <%= html(recommendationReason) %>
                    </p>

                </article>

            <%
                }
            }
            %>

        </div>

    </section>

    <section class="section">

        <div class="section-heading">

            <h2>Officer Verification</h2>

            <p>
                Record the final officer decision for this
                GIS screening result.
            </p>

        </div>

        <div class="section-content">

            <%
            if (decisionPending) {
            %>

                <div class="verification-box">

                    <form method="post"
                          action="<%= contextPath %>/officer/gis-decision"
                          onsubmit="return confirmDecision(event);">

                        <input type="hidden"
                               name="applicationId"
                               value="<%= html(applicationId) %>">

                        <label for="officerRemarks">
                            Officer Remarks
                        </label>

                        <textarea id="officerRemarks"
                                  name="officerRemarks"
                                  maxlength="2000"
                                  required
                                  placeholder="Enter verification observations and decision remarks..."></textarea>

                        <div class="button-row">

                            <button type="submit"
                                    name="decision"
                                    value="VERIFY"
                                    class="verify-button">

                                Verify GIS Recommendation

                            </button>

                            <button type="submit"
                                    name="decision"
                                    value="REJECT"
                                    class="reject-button">

                                Reject GIS Recommendation

                            </button>

                        </div>

                    </form>

                </div>

            <%
            } else {
            %>

                <div class="decision-completed
                     <%= rejected ? "rejected" : "" %>">

                    <h3>
                        GIS Verification Completed
                    </h3>

                    <div class="decision-status">
                        <%= html(finalVerificationStatus) %>
                    </div>

                    <p>
                        This GIS recommendation has already
                        been reviewed. A second decision cannot
                        be submitted.
                    </p>

                    <%
                    if (!savedOfficerRemarks.isBlank()) {
                    %>

                        <div class="saved-remarks">

                            <strong>Officer Remarks</strong>
                            <br><br>

                            <%= html(savedOfficerRemarks) %>

                        </div>

                    <%
                    }
                    %>

                    <div class="button-row">

                        <a class="nav-button"
                           href="<%= contextPath %>/officer/gis-verification">

                            Return to GIS Queue

                        </a>

                    </div>

                </div>

            <%
            }
            %>

        </div>

    </section>

    <div class="notice">

        <strong>Important:</strong>

        GIS screening is a preliminary system-generated result.
        Officer verification confirms or rejects the recommendation,
        but final statutory clearance is processed through its
        applicable departmental workflow.

    </div>

</main>

<script>

    function confirmDecision(event) {

        const clickedButton =
                event.submitter;

        if (!clickedButton) {
            return true;
        }

        const decision =
                clickedButton.value;

        if (decision === "VERIFY") {

            return confirm(
                "Verify this GIS recommendation?"
            );
        }

        if (decision === "REJECT") {

            return confirm(
                "Reject this GIS recommendation?"
            );
        }

        return true;
    }

</script>

</body>
</html>