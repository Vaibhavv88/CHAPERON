<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    List<Map<String, Object>> gisApplications =
        (List<Map<String, Object>>)
        request.getAttribute("gisApplications");

    Integer pendingCount =
        (Integer) request.getAttribute("pendingCount");

    Integer verifiedCount =
        (Integer) request.getAttribute("verifiedCount");

    Integer rejectedCount =
        (Integer) request.getAttribute("rejectedCount");

    if (pendingCount == null) {
        pendingCount = 0;
    }

    if (verifiedCount == null) {
        verifiedCount = 0;
    }

    if (rejectedCount == null) {
        rejectedCount = 0;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>GIS Verification Queue | CHAPERON</title>

    <style>

        :root {
            --green-dark: #086844;
            --green-primary: #078c5a;
            --green-light: #20b77a;
            --green-soft: #eaf8f1;
            --green-border: #cfe9dc;
            --text-dark: #103d2f;
            --text-muted: #668276;
            --page-bg: #f3faf7;
            --white: #ffffff;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: var(--page-bg);
            color: var(--text-dark);
        }

        .header {
            background: var(--white);
            border-bottom: 1px solid var(--green-border);
            padding: 17px 6%;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .brand h1 {
            color: var(--green-dark);
            font-size: 25px;
        }

        .brand p {
            color: var(--text-muted);
            font-size: 12px;
            margin-top: 3px;
        }

        .header-links {
            display: flex;
            gap: 10px;
        }

        .header-links a {
            text-decoration: none;
            color: var(--green-dark);
            background: var(--green-soft);
            border: 1px solid var(--green-border);
            padding: 11px 17px;
            border-radius: 10px;
            font-weight: bold;
            font-size: 14px;
        }

        .header-links a:hover {
            color: white;
            background: var(--green-primary);
        }

        .container {
            width: 90%;
            max-width: 1350px;
            margin: 30px auto;
        }

        .hero {
            position: relative;
            overflow: hidden;
            background: linear-gradient(
                120deg,
                #076d48,
                #18b979
            );
            color: white;
            padding: 34px;
            border-radius: 18px;
            margin-bottom: 25px;
            box-shadow: 0 12px 30px
                rgba(8, 122, 80, 0.18);
        }

        .hero::after {
            content: "";
            position: absolute;
            width: 230px;
            height: 230px;
            border-radius: 50%;
            right: -50px;
            top: -110px;
            background: rgba(255, 255, 255, 0.08);
        }

        .hero-label {
            display: inline-block;
            background: rgba(255, 255, 255, 0.18);
            padding: 7px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            margin-bottom: 14px;
        }

        .hero h2 {
            font-size: 30px;
            margin-bottom: 9px;
        }

        .hero p {
            max-width: 800px;
            line-height: 1.6;
            color: #e8fff4;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 25px;
        }

        .stat-card {
            background: var(--white);
            padding: 23px;
            border-radius: 15px;
            border: 1px solid var(--green-border);
            box-shadow: 0 8px 25px
                rgba(16, 75, 54, 0.07);
        }

        .stat-card span {
            color: var(--text-muted);
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .stat-card h3 {
            color: var(--text-dark);
            font-size: 30px;
            margin-top: 10px;
        }

        .stat-card.pending {
            border-top: 4px solid #e8a317;
        }

        .stat-card.verified {
            border-top: 4px solid var(--green-primary);
        }

        .stat-card.rejected {
            border-top: 4px solid #c7352d;
        }

        .queue-section {
            background: var(--white);
            border: 1px solid var(--green-border);
            border-radius: 17px;
            overflow: hidden;
            box-shadow: 0 8px 25px
                rgba(16, 75, 54, 0.07);
        }

        .queue-heading {
            padding: 24px;
            border-bottom: 1px solid var(--green-border);
        }

        .queue-heading h2 {
            color: var(--text-dark);
            font-size: 22px;
            margin-bottom: 6px;
        }

        .queue-heading p {
            color: var(--text-muted);
            font-size: 14px;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 1050px;
            border-collapse: collapse;
        }

        th {
            background: #f0f8f4;
            color: #58786a;
            text-align: left;
            padding: 15px;
            font-size: 12px;
            text-transform: uppercase;
            border-bottom: 1px solid var(--green-border);
        }

        td {
            padding: 17px 15px;
            border-bottom: 1px solid #e7f0ec;
            vertical-align: middle;
            font-size: 14px;
        }

        tbody tr:hover {
            background: #f5fbf8;
        }

        .application-number {
            color: var(--green-primary);
            font-weight: bold;
        }

        .project-title {
            color: var(--text-dark);
            font-weight: bold;
            margin-bottom: 4px;
        }

        .small-text {
            color: var(--text-muted);
            font-size: 12px;
        }

        .badge {
            display: inline-block;
            padding: 7px 11px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
            white-space: nowrap;
        }

        .badge-pending {
            color: #8a5b00;
            background: #fff0c7;
        }

        .badge-verified {
            color: #087245;
            background: #dff7e9;
        }

        .badge-rejected {
            color: #b52c25;
            background: #ffe4e1;
        }

        .badge-required {
            color: #b52c25;
            background: #ffe2df;
        }

        .badge-review {
            color: #7a5800;
            background: #fff1c8;
        }

        .review-button {
            display: inline-block;
            text-decoration: none;
            color: white;
            background: var(--green-primary);
            border-radius: 9px;
            padding: 10px 15px;
            font-size: 13px;
            font-weight: bold;
            white-space: nowrap;
            transition: 0.2s ease;
        }

        .review-button:hover {
            background: var(--green-dark);
            transform: translateY(-1px);
        }

        .empty-state {
            text-align: center;
            padding: 55px 20px;
        }

        .empty-state h3 {
            color: var(--text-dark);
            margin-bottom: 9px;
        }

        .empty-state p {
            color: var(--text-muted);
        }

        .note {
            background: #eaf8f1;
            border-left: 4px solid var(--green-primary);
            color: #27634c;
            padding: 18px;
            border-radius: 10px;
            margin-top: 22px;
            line-height: 1.6;
            font-size: 13px;
        }

        @media (max-width: 900px) {

            .header {
                align-items: flex-start;
                gap: 15px;
                flex-direction: column;
            }

            .stats {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 600px) {

            .container {
                width: 94%;
            }

            .stats {
                grid-template-columns: 1fr;
            }

            .hero {
                padding: 23px;
            }

            .hero h2 {
                font-size: 24px;
            }
        }

    </style>

</head>

<body>

<header class="header">

    <div class="brand">

        <h1>CHAPERON</h1>

        <p>
            GUIDE. CONNECT. COMPLY. GET APPROVED.
        </p>

    </div>

    <div class="header-links">

        <a href="<%= request.getContextPath() %>/officer/dashboard">
            Dashboard
        </a>

        <a href="<%= request.getContextPath() %>/logout">
            Logout
        </a>

    </div>

</header>

<main class="container">

    <section class="hero">

        <div class="hero-label">
            GOVERNMENT OFFICER GIS WORKSPACE
        </div>

        <h2>GIS Verification Queue</h2>

        <p>
            Review spatial findings generated from active
            official GIS layers and verify or reject the
            system-generated clearance recommendations.
        </p>

    </section>

    <section class="stats">

        <div class="stat-card">

            <span>Total GIS Cases</span>

            <h3>
                <%= gisApplications == null
                    ? 0
                    : gisApplications.size() %>
            </h3>

        </div>

        <div class="stat-card pending">

            <span>Pending Verification</span>

            <h3><%= pendingCount %></h3>

        </div>

        <div class="stat-card verified">

            <span>Verified</span>

            <h3><%= verifiedCount %></h3>

        </div>

        <div class="stat-card rejected">

            <span>Rejected</span>

            <h3><%= rejectedCount %></h3>

        </div>

    </section>

    <section class="queue-section">

        <div class="queue-heading">

            <h2>Spatial Screening Applications</h2>

            <p>
                Applications containing GIS findings that
                require authorised officer verification.
            </p>

        </div>

        <%
            if (gisApplications == null
                    || gisApplications.isEmpty()) {
        %>

            <div class="empty-state">

                <h3>No GIS applications found</h3>

                <p>
                    Applications will appear after an
                    entrepreneur completes spatial screening.
                </p>

            </div>

        <%
            } else {
        %>

            <div class="table-wrapper">

                <table>

                    <thead>

                        <tr>
                            <th>Application</th>
                            <th>Project</th>
                            <th>Clearance</th>
                            <th>Area</th>
                            <th>Recommendation</th>
                            <th>Verification</th>
                            <th>Action</th>
                        </tr>

                    </thead>

                    <tbody>

                    <%
                        for (Map<String, Object> gisApplication
                                : gisApplications) {

                            String verificationStatus =
                                String.valueOf(
                                    gisApplication.get(
                                        "verificationStatus"
                                    )
                                );

                            String recommendationLevel =
                                String.valueOf(
                                    gisApplication.get(
                                        "recommendationLevel"
                                    )
                                );

                            String verificationClass =
                                "badge-pending";

                            if ("VERIFIED".equalsIgnoreCase(
                                    verificationStatus)) {

                                verificationClass =
                                    "badge-verified";

                            } else if (
                                "REJECTED".equalsIgnoreCase(
                                    verificationStatus)) {

                                verificationClass =
                                    "badge-rejected";
                            }

                            String recommendationClass =
                                "badge-review";

                            if ("REQUIRED".equalsIgnoreCase(
                                    recommendationLevel)) {

                                recommendationClass =
                                    "badge-required";
                            }
                    %>

                        <tr>

                            <td>

                                <div class="application-number">

                                    <%= gisApplication.get(
                                        "applicationNumber"
                                    ) %>

                                </div>

                                <div class="small-text">

                                    ID:
                                    <%= gisApplication.get(
                                        "applicationId"
                                    ) %>

                                </div>

                            </td>

                            <td>

                                <div class="project-title">

                                    <%= gisApplication.get(
                                        "projectTitle"
                                    ) %>

                                </div>

                                <div class="small-text">

                                    <%= gisApplication.get(
                                        "district"
                                    ) %>,

                                    <%= gisApplication.get(
                                        "state"
                                    ) %>

                                </div>

                            </td>

                            <td>

                                <div class="project-title">

                                    <%= gisApplication.get(
                                        "clearanceName"
                                    ) %>

                                </div>

                                <div class="small-text">

                                    <%= gisApplication.get(
                                        "clearanceCode"
                                    ) %>

                                </div>

                            </td>

                            <td>

                                <%= gisApplication.get(
                                    "projectAreaHectares"
                                ) %>
                                ha

                            </td>

                            <td>

                                <span class="badge
                                    <%= recommendationClass %>">

                                    <%= recommendationLevel %>

                                </span>

                            </td>

                            <td>

                                <span class="badge
                                    <%= verificationClass %>">

                                    <%= verificationStatus %>

                                </span>

                            </td>

                            <td>

                                <a class="review-button"
                                   href="<%= request.getContextPath() %>/officer/gis-review?id=<%= gisApplication.get("applicationId") %>">

                                    Review GIS

                                </a>

                            </td>

                        </tr>

                    <%
                        }
                    %>

                    </tbody>

                </table>

            </div>

        <%
            }
        %>

    </section>

    <div class="note">

        <strong>Important:</strong>

        GIS screening is a preliminary system-generated
        result. Final verification must be completed by an
        authorised government officer.

    </div>

</main>

</body>

</html>