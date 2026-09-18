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

    private String value(
            Object value,
            String defaultValue
    ) {

        if (value == null) {
            return defaultValue;
        }

        String result =
                value.toString().trim();

        if (result.isEmpty()
                || "null".equalsIgnoreCase(result)) {

            return defaultValue;
        }

        return result;
    }
%>

<%
    String contextPath =
            request.getContextPath();

    String userName =
            (String) session.getAttribute("userName");

    if (userName == null
            || userName.isBlank()) {

        userName = "Entrepreneur";
    }

    List<Map<String, Object>> gisRecommendations =
            (List<Map<String, Object>>)
            request.getAttribute("gisRecommendations");

    if (gisRecommendations == null) {
        gisRecommendations = Collections.emptyList();
    }

    Integer confirmedRecommendationCount =
            (Integer) request.getAttribute(
                    "confirmedRecommendationCount"
            );

    if (confirmedRecommendationCount == null) {
        confirmedRecommendationCount =
                gisRecommendations.size();
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Verified GIS Recommendations | CHAPERON
    </title>

    <style>

        * {
            box-sizing: border-box;
        }

        :root {
            --green-dark: #064e3b;
            --green-main: #059669;
            --green-bright: #10b981;
            --green-soft: #ecfdf5;
            --green-light: #d1fae5;
            --green-border: #b7e4cf;
            --white: #ffffff;
            --text-dark: #022c22;
            --text-muted: #5b746c;
            --red: #dc2626;
            --red-soft: #fee2e2;
            --blue-soft: #e0f2fe;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: Arial, Helvetica, sans-serif;
            color: var(--text-dark);
            background:
                linear-gradient(
                    135deg,
                    #effcf6 0%,
                    #f8fffc 50%,
                    #e7f7ef 100%
                );
        }

        a {
            text-decoration: none;
        }

        .topbar {
            position: sticky;
            top: 0;
            z-index: 20;
            background: white;
            border-bottom: 1px solid var(--green-border);
            box-shadow: 0 5px 20px rgba(6, 78, 59, 0.06);
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
            gap: 13px;
        }

        .brand-icon {
            width: 46px;
            height: 46px;
            display: flex;
            justify-content: center;
            align-items: center;
            border-radius: 13px;
            color: white;
            background:
                linear-gradient(
                    135deg,
                    var(--green-main),
                    var(--green-bright)
                );
            font-size: 23px;
            font-weight: 900;
        }

        .brand-name {
            color: var(--green-dark);
            font-size: 23px;
            font-weight: 900;
        }

        .brand-tagline {
            margin-top: 3px;
            color: var(--text-muted);
            font-size: 11px;
        }

        .nav-actions {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }

        .nav-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 11px 17px;
            border: 1px solid var(--green-border);
            border-radius: 10px;
            color: var(--green-dark);
            background: var(--green-soft);
            font-size: 14px;
            font-weight: 800;
        }

        .nav-button:hover {
            background: var(--green-light);
        }

        .page {
            width: min(1400px, calc(100% - 32px));
            margin: 30px auto 60px;
        }

        .hero {
            padding: 33px;
            border-radius: 22px;
            color: white;
            background:
                linear-gradient(
                    135deg,
                    #065f46 0%,
                    #059669 55%,
                    #10b981 100%
                );
            box-shadow: 0 18px 38px rgba(5, 150, 105, 0.18);
        }

        .hero-content {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 24px;
        }

        .hero-badge {
            display: inline-flex;
            padding: 7px 12px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.16);
            font-size: 12px;
            font-weight: 900;
            letter-spacing: 0.4px;
            text-transform: uppercase;
        }

        .hero h1 {
            margin: 17px 0 10px;
            font-size: 34px;
        }

        .hero p {
            max-width: 760px;
            margin: 0;
            color: rgba(255, 255, 255, 0.88);
            line-height: 1.7;
        }

        .count-box {
            min-width: 185px;
            padding: 20px;
            border-radius: 16px;
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .count-label {
            color: rgba(255, 255, 255, 0.8);
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .count-value {
            margin-top: 8px;
            font-size: 34px;
            font-weight: 900;
        }

        .section {
            margin-top: 28px;
            padding: 28px;
            border: 1px solid var(--green-border);
            border-radius: 20px;
            background: white;
            box-shadow: 0 13px 32px rgba(6, 78, 59, 0.07);
        }

        .section-heading {
            margin-bottom: 23px;
        }

        .section-heading h2 {
            margin: 0 0 7px;
            color: var(--green-dark);
            font-size: 25px;
        }

        .section-heading p {
            margin: 0;
            color: var(--text-muted);
            line-height: 1.5;
        }

        .recommendation-card {
            padding: 25px;
            border: 1px solid var(--green-border);
            border-left: 5px solid var(--green-main);
            border-radius: 16px;
            background: #fcfffd;
        }

        .recommendation-card
        + .recommendation-card {
            margin-top: 20px;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
        }

        .clearance-code {
            color: var(--green-main);
            font-size: 12px;
            font-weight: 900;
            text-transform: uppercase;
        }

        .recommendation-card h3 {
            margin: 7px 0;
            color: var(--green-dark);
            font-size: 23px;
        }

        .project-name {
            color: var(--text-muted);
            font-size: 14px;
        }

        .badges {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            flex-wrap: wrap;
        }

        .badge {
            display: inline-flex;
            padding: 8px 13px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 900;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .badge-required {
            color: #b91c1c;
            background: var(--red-soft);
        }

        .badge-confirmed {
            color: #047857;
            background: var(--green-light);
        }

        .reason {
            margin: 20px 0 0;
            padding: 17px;
            border-radius: 12px;
            color: #315e4e;
            background: var(--green-soft);
            line-height: 1.65;
        }

        .evidence-grid {
            display: grid;
            grid-template-columns:
                repeat(4, minmax(0, 1fr));
            gap: 13px;
            margin-top: 20px;
        }

        .evidence-box {
            padding: 16px;
            border-radius: 12px;
            background: #f2faf6;
            border: 1px solid #d3eadf;
        }

        .evidence-label {
            margin-bottom: 7px;
            color: var(--text-muted);
            font-size: 11px;
            font-weight: 900;
            text-transform: uppercase;
        }

        .evidence-value {
            color: var(--text-dark);
            font-size: 14px;
            font-weight: 800;
            overflow-wrap: anywhere;
        }

        .officer-box {
            margin-top: 18px;
            padding: 17px;
            border-left: 4px solid var(--green-main);
            border-radius: 10px;
            background: #f0fdf7;
            color: #285d4a;
            line-height: 1.6;
        }

        .officer-box strong {
            color: var(--green-dark);
        }

        .card-footer {
            margin-top: 22px;
            padding-top: 20px;
            border-top: 1px solid #d7ece1;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 17px;
        }

        .confirmation-text {
            color: var(--text-muted);
            font-size: 13px;
            line-height: 1.5;
        }

        .apply-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 14px 21px;
            border-radius: 11px;
            color: white;
            background: var(--green-main);
            font-size: 14px;
            font-weight: 900;
            white-space: nowrap;
        }

        .apply-button:hover {
            background: #047857;
        }

        .empty-state {
            padding: 50px 25px;
            border-radius: 15px;
            text-align: center;
            color: var(--text-muted);
            background: var(--green-soft);
            border: 1px dashed var(--green-border);
        }

        .empty-icon {
            width: 65px;
            height: 65px;
            margin: 0 auto 17px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            color: var(--green-main);
            background: var(--green-light);
            font-size: 28px;
            font-weight: 900;
        }

        .empty-state h3 {
            margin: 0 0 8px;
            color: var(--green-dark);
        }

        .notice {
            margin-top: 27px;
            padding: 21px 24px;
            border-left: 5px solid var(--green-main);
            border-radius: 13px;
            color: #065f46;
            background: #e7f8f0;
            line-height: 1.65;
        }

        @media (max-width: 950px) {

            .evidence-grid {
                grid-template-columns:
                    repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 650px) {

            .topbar-inner,
            .hero-content,
            .card-header,
            .card-footer {
                flex-direction: column;
            }

            .page {
                width: min(100% - 20px, 1400px);
                margin-top: 18px;
            }

            .hero,
            .section {
                padding: 21px;
            }

            .hero h1 {
                font-size: 27px;
            }

            .count-box {
                width: 100%;
            }

            .evidence-grid {
                grid-template-columns: 1fr;
            }

            .badges {
                justify-content: flex-start;
            }

            .apply-button {
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

        <div class="nav-actions">

            <a class="nav-button"
               href="<%= contextPath %>/entrepreneur/dashboard">
                Dashboard
            </a>

            <a class="nav-button"
               href="<%= contextPath %>/entrepreneur/clearances">
                Unified Clearances
            </a>

            <a class="nav-button"
               href="<%= contextPath %>/entrepreneur/logout">
                Logout
            </a>

        </div>

    </div>

</header>

<main class="page">

    <section class="hero">

        <div class="hero-content">

            <div>

                <span class="hero-badge">
                    Verified GIS Recommendations
                </span>

                <h1>
                    Hello, <%= html(userName) %>
                </h1>

                <p>
                    These clearance recommendations were generated
                    from your project boundary and confirmed by an
                    authorised government officer.
                </p>

            </div>

            <div class="count-box">

                <div class="count-label">
                    Confirmed Recommendations
                </div>

                <div class="count-value">
                    <%= confirmedRecommendationCount %>
                </div>

            </div>

        </div>

    </section>

    <section class="section">

        <div class="section-heading">

            <h2>Required Clearances</h2>

            <p>
                Start the applicable statutory clearance application
                without leaving the CHAPERON portal.
            </p>

        </div>

        <%
        if (gisRecommendations.isEmpty()) {
        %>

            <div class="empty-state">

                <div class="empty-icon">✓</div>

                <h3>
                    No confirmed GIS recommendation
                </h3>

                <p>
                    Confirmed GIS recommendations will appear
                    here after government officer verification.
                </p>

            </div>

        <%
        } else {

            for (Map<String, Object> recommendation
                    : gisRecommendations) {

                String clearanceName =
                        value(
                            recommendation.get("clearanceName"),
                            "Required Clearance"
                        );

                String clearanceCode =
                        value(
                            recommendation.get("clearanceCode"),
                            "CLEARANCE"
                        );

                String projectTitle =
                        value(
                            recommendation.get("projectTitle"),
                            "Industrial Project"
                        );

                String applicationNumber =
                        value(
                            recommendation.get("applicationNumber"),
                            "Not generated"
                        );

                String recommendationReason =
                        value(
                            recommendation.get(
                                "recommendationReason"
                            ),
                            "GIS screening found an applicable "
                            + "regulated feature."
                        );

                String recommendationLevel =
                        value(
                            recommendation.get(
                                "recommendationLevel"
                            ),
                            "REQUIRED"
                        );

                String officerRemarks =
                        value(
                            recommendation.get("officerRemarks"),
                            ""
                        );

                String featureName =
                        value(
                            recommendation.get("featureName"),
                            ""
                        );

                String clearanceTypeId =
                        value(
                            recommendation.get(
                                "recommendedClearanceTypeId"
                            ),
                            ""
                        );
        %>

            <article class="recommendation-card">

                <div class="card-header">

                    <div>

                        <div class="clearance-code">
                            <%= html(clearanceCode) %>
                        </div>

                        <h3>
                            <%= html(clearanceName) %>
                        </h3>

                        <div class="project-name">

                            Project:
                            <strong>
                                <%= html(projectTitle) %>
                            </strong>

                            · Application:
                            <strong>
                                <%= html(applicationNumber) %>
                            </strong>

                        </div>

                    </div>

                    <div class="badges">

                        <span class="badge badge-required">
                            <%= html(recommendationLevel) %>
                        </span>

                        <span class="badge badge-confirmed">
                            Officer Confirmed
                        </span>

                    </div>

                </div>

                <div class="reason">

                    <strong>
                        Why is this clearance required?
                    </strong>

                    <br><br>

                    <%= html(recommendationReason) %>

                </div>

                <div class="evidence-grid">

                    <div class="evidence-box">

                        <div class="evidence-label">
                            GIS Relation
                        </div>

                        <div class="evidence-value">

                            <%= html(
                                value(
                                    recommendation.get(
                                        "spatialRelation"
                                    ),
                                    "Not available"
                                )
                            ) %>

                        </div>

                    </div>

                    <div class="evidence-box">

                        <div class="evidence-label">
                            Intersection Area
                        </div>

                        <div class="evidence-value">

                            <%= html(
                                value(
                                    recommendation.get(
                                        "intersectionAreaHectares"
                                    ),
                                    "0.0000"
                                )
                            ) %> ha

                        </div>

                    </div>

                    <div class="evidence-box">

                        <div class="evidence-label">
                            Intersection Percentage
                        </div>

                        <div class="evidence-value">

                            <%= html(
                                value(
                                    recommendation.get(
                                        "intersectionPercentage"
                                    ),
                                    "0.0000"
                                )
                            ) %>%

                        </div>

                    </div>

                    <div class="evidence-box">

                        <div class="evidence-label">
                            Confirmed On
                        </div>

                        <div class="evidence-value">

                            <%= html(
                                value(
                                    recommendation.get(
                                        "confirmedAt"
                                    ),
                                    "Not available"
                                )
                            ) %>

                        </div>

                    </div>

                </div>

                <%
                if (!featureName.isBlank()) {
                %>

                    <div class="officer-box">

                        <strong>Protected feature:</strong>
                        <%= html(featureName) %>

                    </div>

                <%
                }
                %>

                <%
                if (!officerRemarks.isBlank()) {
                %>

                    <div class="officer-box">

                        <strong>Officer remarks:</strong>
                        <br>
                        <%= html(officerRemarks) %>

                    </div>

                <%
                }
                %>

                <div class="card-footer">

                    <div class="confirmation-text">

                        GIS verification is complete. You can now
                        start the statutory clearance application.

                    </div>

                    <a class="apply-button"
                       href="<%= contextPath %>/entrepreneur/clearances/new?typeId=<%= html(clearanceTypeId) %>">

                        Start Clearance Application →

                    </a>

                </div>

            </article>

        <%
            }
        }
        %>

    </section>

    <div class="notice">

        <strong>Important:</strong>

        Officer confirmation establishes clearance applicability.
        It does not itself grant final statutory approval.
        Complete and submit the clearance application for
        departmental processing.

    </div>

</main>

</body>
</html>