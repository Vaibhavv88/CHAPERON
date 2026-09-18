<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    String ctx =
            request.getContextPath();

    Integer healthScore =
            (Integer)
            request.getAttribute(
                    "healthScore"
            );

    String healthStatus =
            (String)
            request.getAttribute(
                    "healthStatus"
            );

    String healthMessage =
            (String)
            request.getAttribute(
                    "healthMessage"
            );

    Integer approvedLicences =
            (Integer)
            request.getAttribute(
                    "approvedLicences"
            );

    Integer activeApplications =
            (Integer)
            request.getAttribute(
                    "activeApplications"
            );

    Integer openQueries =
            (Integer)
            request.getAttribute(
                    "openQueries"
            );

    Integer scheduledInspections =
            (Integer)
            request.getAttribute(
                    "scheduledInspections"
            );

    Integer documentIssues =
            (Integer)
            request.getAttribute(
                    "documentIssues"
            );

    Integer slaBreaches =
            (Integer)
            request.getAttribute(
                    "slaBreaches"
            );

    List<Map<String, Object>> passport =
            (List<Map<String, Object>>)
            request.getAttribute(
                    "passport"
            );

    if (healthScore == null) {
        healthScore = 0;
    }

    if (approvedLicences == null) {
        approvedLicences = 0;
    }

    if (activeApplications == null) {
        activeApplications = 0;
    }

    if (openQueries == null) {
        openQueries = 0;
    }

    if (scheduledInspections == null) {
        scheduledInspections = 0;
    }

    if (documentIssues == null) {
        documentIssues = 0;
    }

    if (slaBreaches == null) {
        slaBreaches = 0;
    }
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    Compliance Health | CHAPERON
</title>

<style>

* {
    box-sizing: border-box;
}

body {

    margin: 0;

    min-height: 100vh;

    font-family:
        "Segoe UI",
        Arial,
        sans-serif;

    color: #17375f;

    background:
        linear-gradient(
            135deg,
            #f3f8ff,
            #eef7ff
        );
}

.header {

    min-height: 72px;

    padding:
        12px
        30px;

    display: flex;

    align-items: center;

    justify-content: space-between;

    background: white;

    border-bottom:
        1px solid #dce7f4;
}

.brand {

    display: flex;

    align-items: center;

    gap: 11px;
}

.brand img {

    width: 46px;

    height: 46px;

    border-radius: 50%;

    object-fit: cover;
}

.brand h1 {

    margin: 0;

    color: #075fe7;

    font-size: 21px;
}

.brand small {

    display: block;

    color: #7488a2;

    margin-top: 3px;

    font-size: 8px;

    font-weight: 800;
}

.back {

    text-decoration: none;

    color: #1260c9;

    background: #f6faff;

    border:
        1px solid #d6e4f5;

    border-radius: 10px;

    padding:
        10px
        14px;

    font-size: 11px;

    font-weight: 800;
}

.container {

    width:
        min(
            1200px,
            calc(100% - 30px)
        );

    margin:
        25px auto 50px;
}

.hero {

    display: grid;

    grid-template-columns:
        1fr
        250px;

    gap: 25px;

    align-items: center;

    padding: 30px;

    color: white;

    border-radius: 22px;

    background:
        linear-gradient(
            125deg,
            #0759dc,
            #116edb,
            #1ba4d8
        );

    box-shadow:
        0 18px 40px
        rgba(
            15,
            85,
            180,
            .18
        );
}

.hero-tag {

    display: inline-block;

    padding:
        6px
        10px;

    border-radius: 40px;

    background:
        rgba(
            255,
            255,
            255,
            .16
        );

    font-size: 9px;

    font-weight: 900;
}

.hero h2 {

    margin:
        12px
        0
        8px;

    font-size: 30px;
}

.hero p {

    margin: 0;

    color: #e5f2ff;

    line-height: 1.7;

    font-size: 12px;
}

.score-box {

    min-height: 180px;

    display: flex;

    flex-direction: column;

    align-items: center;

    justify-content: center;

    border:
        1px solid
        rgba(
            255,
            255,
            255,
            .25
        );

    border-radius: 18px;

    background:
        rgba(
            255,
            255,
            255,
            .14
        );
}

.score-number {

    font-size: 55px;

    font-weight: 900;

    line-height: 1;
}

.score-number small {

    font-size: 18px;
}

.score-status {

    margin-top: 10px;

    padding:
        6px
        10px;

    border-radius: 30px;

    background:
        rgba(
            255,
            255,
            255,
            .17
        );

    font-size: 9px;

    font-weight: 900;
}

.health-message {

    margin-top: 18px;

    padding:
        15px
        17px;

    border-radius: 13px;

    background: #eaf5ff;

    border:
        1px solid #cfe6fb;

    color: #315f91;

    line-height: 1.6;

    font-size: 11px;
}

.stats {

    margin-top: 20px;

    display: grid;

    grid-template-columns:
        repeat(
            6,
            1fr
        );

    gap: 11px;
}

.stat {

    min-height: 100px;

    padding: 15px;

    background: white;

    border:
        1px solid #dce7f3;

    border-radius: 14px;
}

.stat span {

    display: block;

    color: #8291a5;

    font-size: 8px;

    text-transform: uppercase;

    font-weight: 900;

    line-height: 1.4;
}

.stat strong {

    display: block;

    margin-top: 10px;

    color: #173f71;

    font-size: 25px;
}

.section {

    margin-top: 25px;
}

.section-header {

    margin-bottom: 14px;
}

.section-header span {

    color: #0960e7;

    font-size: 9px;

    font-weight: 900;

    letter-spacing: 1px;
}

.section-header h2 {

    margin:
        6px
        0
        5px;

    color: #14375f;

    font-size: 23px;
}

.section-header p {

    margin: 0;

    color: #75869b;

    font-size: 11px;
}

.passport-grid {

    display: grid;

    grid-template-columns:
        repeat(
            2,
            1fr
        );

    gap: 15px;
}

.passport-card {

    position: relative;

    overflow: hidden;

    padding: 21px;

    border-radius: 17px;

    background: white;

    border:
        1px solid #dbe7f4;

    box-shadow:
        0 12px 28px
        rgba(
            20,
            70,
            120,
            .06
        );
}

.passport-card::before {

    content: "";

    position: absolute;

    left: 0;

    top: 0;

    bottom: 0;

    width: 5px;

    background:
        linear-gradient(
            #0a65e7,
            #1ea7df
        );
}

.card-top {

    display: flex;

    justify-content: space-between;

    gap: 15px;
}

.approval-name {

    color: #183b67;

    font-size: 16px;

    font-weight: 900;
}

.approval-code {

    margin-top: 4px;

    color: #8190a3;

    font-size: 9px;

    font-weight: 800;
}

.verified {

    height: max-content;

    padding:
        6px
        9px;

    border-radius: 30px;

    color: #14764d;

    background: #e9f8f1;

    font-size: 8px;

    font-weight: 900;
}

.passport-number {

    margin-top: 16px;

    padding: 12px;

    border-radius: 10px;

    background: #f6faff;

    border:
        1px solid #e0eaf6;
}

.passport-number span {

    display: block;

    color: #8190a4;

    font-size: 8px;

    font-weight: 900;

    text-transform: uppercase;
}

.passport-number strong {

    display: block;

    margin-top: 4px;

    color: #195aab;

    font-size: 12px;
}

.details {

    margin-top: 13px;

    display: grid;

    grid-template-columns:
        repeat(
            3,
            1fr
        );

    gap: 9px;
}

.detail {

    padding: 10px;

    border-radius: 9px;

    background: #fafcff;

    border:
        1px solid #e5edf7;
}

.detail span {

    display: block;

    color: #8b98aa;

    font-size: 7px;

    font-weight: 900;

    text-transform: uppercase;
}

.detail strong {

    display: block;

    margin-top: 5px;

    color: #435f7d;

    font-size: 9px;
}

.department {

    margin-top: 12px;

    color: #70839a;

    font-size: 9px;
}

.empty {

    padding:
        40px
        20px;

    text-align: center;

    border:
        1px dashed #bdd0e5;

    border-radius: 16px;

    background: white;

    color: #778a9f;
}

.empty h3 {

    margin:
        0
        0
        7px;

    color: #214a76;
}

.empty p {

    margin: 0;

    font-size: 11px;
}

.info {

    margin-top: 22px;

    padding: 18px;

    background: white;

    border:
        1px solid #dce7f3;

    border-radius: 14px;
}

.info strong {

    color: #1263c9;
}

.info p {

    margin:
        6px
        0
        0;

    color: #708198;

    font-size: 10px;

    line-height: 1.6;
}

@media(max-width:1000px) {

    .stats {

        grid-template-columns:
            repeat(
                3,
                1fr
            );
    }
}

@media(max-width:750px) {

    .hero {

        grid-template-columns:
            1fr;
    }

    .passport-grid {

        grid-template-columns:
            1fr;
    }

    .stats {

        grid-template-columns:
            repeat(
                2,
                1fr
            );
    }
}

@media(max-width:500px) {

    .stats {

        grid-template-columns:
            1fr;
    }

    .details {

        grid-template-columns:
            1fr;
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
        class="back"
        href="<%= ctx %>/entrepreneur/compliance">

        ← Compliance

    </a>

</header>


<main class="container">


    <section class="hero">

        <div>

            <div class="hero-tag">

                ✦ REGULATORY HEALTH INTELLIGENCE

            </div>

            <h2>

                Compliance Health Score

            </h2>

            <p>

                A single view of your current regulatory
                position. CHAPERON combines application
                progress, officer queries, inspections,
                document issues and timeline signals to
                highlight areas that may require attention.

            </p>

        </div>


        <div class="score-box">

            <div class="score-number">

                <%= healthScore %>

                <small>
                    /100
                </small>

            </div>

            <div class="score-status">

                <%= healthStatus %>

            </div>

        </div>

    </section>


    <div class="health-message">

        <strong>
            Health Summary:
        </strong>

        <%= healthMessage %>

    </div>


    <section class="stats">


        <div class="stat">

            <span>
                Approved Licences
            </span>

            <strong>
                <%= approvedLicences %>
            </strong>

        </div>


        <div class="stat">

            <span>
                Active Applications
            </span>

            <strong>
                <%= activeApplications %>
            </strong>

        </div>


        <div class="stat">

            <span>
                Open Queries
            </span>

            <strong>
                <%= openQueries %>
            </strong>

        </div>


        <div class="stat">

            <span>
                Scheduled Inspections
            </span>

            <strong>
                <%= scheduledInspections %>
            </strong>

        </div>


        <div class="stat">

            <span>
                Document Issues
            </span>

            <strong>
                <%= documentIssues %>
            </strong>

        </div>


        <div class="stat">

            <span>
                SLA Breaches
            </span>

            <strong>
                <%= slaBreaches %>
            </strong>

        </div>


    </section>


    <section class="section">


        <div class="section-header">

            <span>
                YOUR REGULATORY IDENTITY
            </span>

            <h2>
                Regulatory Passport
            </h2>

            <p>

                A consolidated record of approvals
                successfully obtained through your
                regulatory journey.

            </p>

        </div>


        <%
        if (passport != null
                && !passport.isEmpty()) {
        %>


            <div class="passport-grid">


                <%
                for (Map<String, Object> passportRow
                        : passport) {
                %>


                    <article class="passport-card">


                        <div class="card-top">

                            <div>

                                <div class="approval-name">

                                    <%= passportRow.get(
                                            "approvalName"
                                    ) %>

                                </div>

                                <div class="approval-code">

                                    <%= passportRow.get(
                                            "approvalCode"
                                    ) != null
                                            ? passportRow.get(
                                                    "approvalCode"
                                            )
                                            : "" %>

                                </div>

                            </div>


                            <div class="verified">

                                ✓ VERIFIED APPROVAL

                            </div>

                        </div>


                        <div class="passport-number">

                            <span>
                                Approval Number
                            </span>

                            <strong>

                                <%= passportRow.get(
                                        "approvalNumber"
                                ) != null
                                        ? passportRow.get(
                                                "approvalNumber"
                                        )
                                        : "Not Available" %>

                            </strong>

                        </div>


                        <div class="details">


                            <div class="detail">

                                <span>
                                    Approved On
                                </span>

                                <strong>

                                    <%= passportRow.get(
                                            "approvalDate"
                                    ) != null
                                            ? passportRow.get(
                                                    "approvalDate"
                                            )
                                            : "N/A" %>

                                </strong>

                            </div>


                            <div class="detail">

                                <span>
                                    Valid From
                                </span>

                                <strong>

                                    <%= passportRow.get(
                                            "validFrom"
                                    ) != null
                                            ? passportRow.get(
                                                    "validFrom"
                                            )
                                            : "N/A" %>

                                </strong>

                            </div>


                            <div class="detail">

                                <span>
                                    Valid Until
                                </span>

                                <strong>

                                    <%= passportRow.get(
                                            "validUntil"
                                    ) != null
                                            ? passportRow.get(
                                                    "validUntil"
                                            )
                                            : "Permanent / N/A" %>

                                </strong>

                            </div>


                        </div>


                        <div class="department">

                            Issuing Department:
                            <strong>

                                <%= passportRow.get(
                                        "departmentName"
                                ) %>

                            </strong>

                        </div>


                    </article>


                <%
                }
                %>


            </div>


        <%
        } else {
        %>


            <div class="empty">

                <h3>
                    Your Regulatory Passport is building
                </h3>

                <p>

                    Approved licences and certificates
                    will automatically appear here once
                    your applications are approved.

                </p>

            </div>


        <%
        }
        %>


    </section>


    <div class="info">

        <strong>
            How is the score calculated?
        </strong>

        <p>

            CHAPERON starts from a healthy regulatory
            baseline and applies risk signals for unresolved
            officer queries, upcoming inspections, document
            problems and applications that have crossed
            their estimated processing date. This is an
            operational guidance score, not an official
            government compliance rating.

        </p>

    </div>


</main>

</body>

</html>