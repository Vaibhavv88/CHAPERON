<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    String ctx =
            request.getContextPath();

    List<Map<String, Object>> documents =
            (List<Map<String, Object>>)
            request.getAttribute(
                    "documents"
            );

    Integer totalDocuments =
            (Integer)
            request.getAttribute(
                    "totalDocuments"
            );

    Integer readyDocuments =
            (Integer)
            request.getAttribute(
                    "readyDocuments"
            );

    Integer warningDocuments =
            (Integer)
            request.getAttribute(
                    "warningDocuments"
            );

    Integer riskDocuments =
            (Integer)
            request.getAttribute(
                    "riskDocuments"
            );

    Integer overallScore =
            (Integer)
            request.getAttribute(
                    "overallScore"
            );

    String overallStatus =
            (String)
            request.getAttribute(
                    "overallStatus"
            );

    String aiExplanation =
            (String)
            request.getAttribute(
                    "aiExplanation"
            );

    if (totalDocuments == null) {
        totalDocuments = 0;
    }

    if (readyDocuments == null) {
        readyDocuments = 0;
    }

    if (warningDocuments == null) {
        warningDocuments = 0;
    }

    if (riskDocuments == null) {
        riskDocuments = 0;
    }

    if (overallScore == null) {
        overallScore = 0;
    }
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    AI Document Pre-Validation | CHAPERON
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
            #edf7ff
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
        1px solid #dce7f3;
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

    margin-top: 3px;

    color: #7589a4;

    font-size: 8px;

    font-weight: 800;
}

.back {

    padding:
        10px
        14px;

    text-decoration: none;

    color: #1260c9;

    background: #f7faff;

    border:
        1px solid #d7e4f3;

    border-radius: 10px;

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
        220px;

    align-items: center;

    gap: 25px;

    padding: 30px;

    border-radius: 22px;

    color: white;

    background:
        linear-gradient(
            125deg,
            #0758dc,
            #126edb,
            #19a6da
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

.hero-label {

    display: inline-block;

    padding:
        6px
        10px;

    border-radius: 30px;

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
        7px;

    font-size: 30px;
}

.hero p {

    margin: 0;

    max-width: 800px;

    color: #e5f2ff;

    line-height: 1.7;

    font-size: 12px;
}

.score {

    min-height: 155px;

    display: flex;

    align-items: center;

    justify-content: center;

    flex-direction: column;

    border:
        1px solid
        rgba(
            255,
            255,
            255,
            .25
        );

    border-radius: 17px;

    background:
        rgba(
            255,
            255,
            255,
            .14
        );
}

.score strong {

    font-size: 46px;

    line-height: 1;
}

.score span {

    margin-top: 9px;

    padding:
        6px
        10px;

    border-radius: 30px;

    background:
        rgba(
            255,
            255,
            255,
            .16
        );

    font-size: 8px;

    font-weight: 900;
}

.ai-box {

    margin-top: 18px;

    padding: 18px;

    border-radius: 15px;

    color: #285b91;

    background:
        linear-gradient(
            135deg,
            #eaf5ff,
            #f4faff
        );

    border:
        1px solid #cee4fa;
}

.ai-box strong {

    display: block;

    color: #075cc8;

    margin-bottom: 6px;

    font-size: 12px;
}

.ai-box p {

    margin: 0;

    line-height: 1.65;

    font-size: 11px;
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

    border-radius: 14px;

    background: white;

    border:
        1px solid #dce7f3;
}

.stat span {

    display: block;

    color: #8191a5;

    font-size: 8px;

    font-weight: 900;

    text-transform: uppercase;
}

.stat strong {

    display: block;

    margin-top: 9px;

    color: #173f70;

    font-size: 25px;
}

.section {

    margin-top: 25px;
}

.section h2 {

    margin:
        0
        0
        5px;

    color: #153b68;

    font-size: 22px;
}

.section > p {

    margin:
        0
        0
        16px;

    color: #78899e;

    font-size: 11px;
}

.document-list {

    display: grid;

    gap: 13px;
}

.document-card {

    padding: 18px;

    border-radius: 15px;

    background: white;

    border:
        1px solid #dce7f3;

    display: grid;

    grid-template-columns:
        minmax(
            170px,
            1.2fr
        )
        minmax(
            110px,
            .7fr
        )
        minmax(
            90px,
            .5fr
        )
        minmax(
            250px,
            1.7fr
        );

    gap: 15px;

    align-items: center;
}

.doc-name {

    color: #193d68;

    font-size: 12px;

    font-weight: 900;
}

.doc-meta {

    margin-top: 4px;

    color: #8493a7;

    font-size: 8px;
}

.status {

    width: max-content;

    padding:
        6px
        9px;

    border-radius: 30px;

    font-size: 8px;

    font-weight: 900;
}

.ready {

    color: #14764e;

    background: #e9f8f1;
}

.warning {

    color: #9a681e;

    background: #fff5e6;
}

.risk {

    color: #a63a3a;

    background: #fff0f0;
}

.doc-score {

    color: #195da9;

    font-size: 15px;

    font-weight: 900;
}

.message {

    color: #60758e;

    font-size: 10px;

    line-height: 1.55;
}

.empty {

    padding:
        42px
        20px;

    text-align: center;

    border:
        1px dashed #bed1e5;

    border-radius: 16px;

    background: white;
}

.empty h3 {

    margin:
        0
        0
        6px;

    color: #234d79;
}

.empty p {

    margin: 0;

    color: #78899e;

    font-size: 11px;
}

.actions {

    margin-top: 22px;

    display: flex;

    gap: 10px;

    flex-wrap: wrap;
}

.primary {

    padding:
        11px
        15px;

    border-radius: 10px;

    text-decoration: none;

    color: white;

    background:
        linear-gradient(
            135deg,
            #095ee8,
            #1a9ae4
        );

    font-size: 10px;

    font-weight: 900;
}

.secondary {

    padding:
        11px
        15px;

    border-radius: 10px;

    text-decoration: none;

    color: #185cae;

    background: white;

    border:
        1px solid #d5e3f2;

    font-size: 10px;

    font-weight: 900;
}

.note {

    margin-top: 20px;

    padding: 15px;

    border-radius: 12px;

    color: #74869b;

    background: #f8fbff;

    border:
        1px solid #dce9f6;

    font-size: 9px;

    line-height: 1.6;
}

@media(max-width:900px) {

    .document-card {

        grid-template-columns:
            1fr
            1fr;
    }

    .stats {

        grid-template-columns:
            1fr
            1fr;
    }
}

@media(max-width:650px) {

    .hero {

        grid-template-columns:
            1fr;
    }

    .document-card {

        grid-template-columns:
            1fr;
    }

    .stats {

        grid-template-columns:
            1fr;
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
        href="<%= ctx %>/entrepreneur/documents">

        ← Document Vault

    </a>

</header>


<main class="container">


    <section class="hero">

        <div>

            <div class="hero-label">

                ✦ AI-ASSISTED PRE-SUBMISSION CHECK

            </div>

            <h2>
                Document Pre-Validation
            </h2>

            <p>

                Detect possible document issues before
                an application reaches the government
                officer. CHAPERON checks document
                validity signals, status, expiry and
                supported file format, then provides
                an AI-assisted readiness explanation.

            </p>

        </div>


        <div class="score">

            <strong>

                <%= overallScore %>/100

            </strong>

            <span>

                <%= overallStatus %>

            </span>

        </div>

    </section>


    <div class="ai-box">

        <strong>
            ✦ CHAPERON AI Guidance
        </strong>

        <p>
            <%= aiExplanation %>
        </p>

    </div>


    <section class="stats">


        <div class="stat">

            <span>
                Uploaded Documents
            </span>

            <strong>
                <%= totalDocuments %>
            </strong>

        </div>


        <div class="stat">

            <span>
                Ready
            </span>

            <strong>
                <%= readyDocuments %>
            </strong>

        </div>


        <div class="stat">

            <span>
                Need Attention
            </span>

            <strong>
                <%= warningDocuments %>
            </strong>

        </div>


        <div class="stat">

            <span>
                High Risk
            </span>

            <strong>
                <%= riskDocuments %>
            </strong>

        </div>


    </section>


    <section class="section">

        <h2>
            Document Validation Report
        </h2>

        <p>
            Review possible pre-submission issues before starting or submitting an approval application.
        </p>


        <%
        if (documents != null
                && !documents.isEmpty()) {
        %>


            <div class="document-list">


                <%
                for (Map<String, Object> documentRow
                        : documents) {

                    String status =
                            String.valueOf(
                                    documentRow.get(
                                            "validationStatus"
                                    )
                            );

                    String statusClass =
                            "ready";

                    if ("WARNING"
                            .equalsIgnoreCase(status)) {

                        statusClass =
                                "warning";

                    } else if ("RISK"
                            .equalsIgnoreCase(status)) {

                        statusClass =
                                "risk";
                    }
                %>


                    <article class="document-card">


                        <div>

                            <div class="doc-name">

                                <%= documentRow.get(
                                        "documentType"
                                ) %>

                            </div>

                            <div class="doc-meta">

                                Uploaded:
                                <%= documentRow.get(
                                        "uploadDate"
                                ) != null
                                        ? documentRow.get(
                                                "uploadDate"
                                        )
                                        : "N/A" %>

                                <br>

                                Expiry:
                                <%= documentRow.get(
                                        "expiryDate"
                                ) != null
                                        ? documentRow.get(
                                                "expiryDate"
                                        )
                                        : "Not Applicable" %>

                            </div>

                        </div>


                        <div>

                            <span
                                class="status <%= statusClass %>">

                                <%= status %>

                            </span>

                        </div>


                        <div class="doc-score">

                            <%= documentRow.get(
                                    "validationScore"
                            ) %>/100

                        </div>


                        <div class="message">

                            <%= documentRow.get(
                                    "validationMessage"
                            ) %>

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
                    No documents available
                </h3>

                <p>

                    Upload documents to your Document
                    Vault to run pre-submission validation.

                </p>

            </div>


        <%
        }
        %>


    </section>


    <div class="actions">

        <a
            class="primary"
            href="<%= ctx %>/entrepreneur/documents">

            Manage Documents →

        </a>

        <a
            class="secondary"
            href="<%= ctx %>/entrepreneur/generate-approvals">

            Approval Roadmap

        </a>

    </div>


    <div class="note">

        AI-assisted pre-validation is guidance only.
        A high readiness score does not guarantee
        statutory acceptance. Final document verification
        and approval remain with the concerned authority.
        CHAPERON does not send the uploaded document's
        personal contents to the AI explanation step in
        this implementation.

    </div>


</main>

</body>

</html>