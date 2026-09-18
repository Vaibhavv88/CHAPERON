<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.chaperon.model.Business" %>

<%
    String ctx =
            request.getContextPath();

    Business business =
            (Business)
            request.getAttribute(
                    "business"
            );

    List<Map<String, Object>> impacts =
            (List<Map<String, Object>>)
            request.getAttribute(
                    "impacts"
            );

    Integer highCount =
            (Integer)
            request.getAttribute(
                    "highCount"
            );

    Integer mediumCount =
            (Integer)
            request.getAttribute(
                    "mediumCount"
            );

    Integer infoCount =
            (Integer)
            request.getAttribute(
                    "infoCount"
            );

    Integer totalCount =
            (Integer)
            request.getAttribute(
                    "totalCount"
            );

    if (highCount == null) {
        highCount = 0;
    }

    if (mediumCount == null) {
        mediumCount = 0;
    }

    if (infoCount == null) {
        infoCount = 0;
    }

    if (totalCount == null) {
        totalCount = 0;
    }
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    Regulation Change Impact | CHAPERON
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
            #f4f8ff,
            #eef7ff
        );
}

.header {

    min-height: 72px;

    padding:
        12px
        30px;

    display: flex;

    justify-content: space-between;

    align-items: center;

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

    color: #778ba5;

    font-size: 8px;

    font-weight: 800;
}

.back {

    padding:
        10px
        14px;

    text-decoration: none;

    color: #1260ca;

    background: #f7faff;

    border:
        1px solid #d8e4f3;

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

    padding: 30px;

    border-radius: 22px;

    color: white;

    background:
        linear-gradient(
            125deg,
            #0758dc,
            #136ed9,
            #1ba6d8
        );

    box-shadow:
        0 18px 40px
        rgba(
            15,
            85,
            180,
            .17
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

    max-width: 850px;

    line-height: 1.7;

    color: #e6f2ff;

    font-size: 12px;
}

.business {

    margin-top: 17px;

    display: flex;

    gap: 9px;

    flex-wrap: wrap;
}

.chip {

    padding:
        7px
        10px;

    border-radius: 30px;

    background:
        rgba(
            255,
            255,
            255,
            .14
        );

    font-size: 9px;
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

    padding: 18px;

    border-radius: 14px;

    background: white;

    border:
        1px solid #dce7f3;
}

.stat span {

    display: block;

    color: #8090a5;

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

.impact-list {

    display: grid;

    gap: 14px;
}

.card {

    padding: 21px;

    border-radius: 16px;

    background: white;

    border:
        1px solid #dce7f3;

    box-shadow:
        0 10px 26px
        rgba(
            20,
            60,
            110,
            .05
        );
}

.card-top {

    display: flex;

    align-items: flex-start;

    justify-content: space-between;

    gap: 15px;
}

.card h3 {

    margin: 0;

    color: #183e6b;

    font-size: 16px;
}

.meta {

    margin-top: 5px;

    color: #8392a5;

    font-size: 9px;
}

.badge {

    padding:
        6px
        9px;

    border-radius: 30px;

    font-size: 8px;

    font-weight: 900;
}

.high {

    color: #a73737;

    background: #fff0f0;
}

.medium {

    color: #9c671c;

    background: #fff5e6;
}

.info {

    color: #176198;

    background: #edf7ff;
}

.description {

    margin-top: 14px;

    color: #5e728c;

    line-height: 1.65;

    font-size: 11px;
}

.action {

    margin-top: 13px;

    padding: 13px;

    border-radius: 11px;

    color: #225c98;

    background: #f1f8ff;

    border:
        1px solid #d8eafb;

    font-size: 10px;

    line-height: 1.55;
}

.action strong {

    display: block;

    margin-bottom: 4px;
}

.empty {

    padding:
        45px
        20px;

    text-align: center;

    border:
        1px dashed #bfd1e5;

    border-radius: 16px;

    background: white;

    color: #77899e;
}

.empty h3 {

    margin:
        0
        0
        7px;

    color: #244c77;
}

.note {

    margin-top: 20px;

    padding: 16px;

    border-radius: 13px;

    background: #f7fbff;

    border:
        1px solid #dce9f6;

    color: #71839a;

    font-size: 9px;

    line-height: 1.6;
}

@media(max-width:750px) {

    .stats {

        grid-template-columns:
            1fr
            1fr;
    }
}

@media(max-width:500px) {

    .stats {

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
        href="<%= ctx %>/entrepreneur/dashboard">

        ← Dashboard

    </a>

</header>

<main class="container">

    <section class="hero">

        <div class="hero-label">
            ✦ REGULATION CHANGE IMPACT ENGINE
        </div>

        <h2>
            What changed, and does it affect you?
        </h2>

        <p>

            CHAPERON connects regulatory updates
            with your existing business profile
            and approval journey, helping you
            identify changes that may require
            attention.

        </p>

        <%
        if (business != null) {
        %>

            <div class="business">

                <div class="chip">

                    Business:
                    <strong>
                        <%= business.getBusinessName() %>
                    </strong>

                </div>

                <div class="chip">

                    Industry:
                    <strong>
                        <%= business.getIndustry() %>
                    </strong>

                </div>

                <div class="chip">

                    State:
                    <strong>
                        <%= business.getState() %>
                    </strong>

                </div>

            </div>

        <%
        }
        %>

    </section>

    <section class="stats">

        <div class="stat">

            <span>
                Relevant Changes
            </span>

            <strong>
                <%= totalCount %>
            </strong>

        </div>

        <div class="stat">

            <span>
                High Impact
            </span>

            <strong>
                <%= highCount %>
            </strong>

        </div>

        <div class="stat">

            <span>
                Medium Impact
            </span>

            <strong>
                <%= mediumCount %>
            </strong>

        </div>

        <div class="stat">

            <span>
                Informational
            </span>

            <strong>
                <%= infoCount %>
            </strong>

        </div>

    </section>

    <section class="section">

        <h2>
            Regulatory Impact Feed
        </h2>

        <p>
            Changes currently relevant to your business and approval roadmap.
        </p>

        <%
        if (impacts != null
                && !impacts.isEmpty()) {
        %>

            <div class="impact-list">

                <%
                for (Map<String, Object> item
                        : impacts) {

                    String severity =
                            String.valueOf(
                                    item.get(
                                            "severity"
                                    )
                            );

                    String severityClass =
                            "info";

                    if ("HIGH".equalsIgnoreCase(
                            severity)) {

                        severityClass =
                                "high";

                    } else if ("MEDIUM"
                            .equalsIgnoreCase(
                                    severity)) {

                        severityClass =
                                "medium";
                    }
                %>

                    <article class="card">

                        <div class="card-top">

                            <div>

                                <h3>

                                    <%= item.get(
                                            "title"
                                    ) %>

                                </h3>

                                <div class="meta">

                                    Effective:
                                    <%= item.get(
                                            "effectiveDate"
                                    ) != null
                                            ? item.get(
                                                    "effectiveDate"
                                            )
                                            : "Not specified" %>

                                    <%
                                    if (item.get(
                                            "approvalName"
                                    ) != null) {
                                    %>

                                        &nbsp; • &nbsp;

                                        Related Approval:
                                        <%= item.get(
                                                "approvalName"
                                        ) %>

                                    <%
                                    }
                                    %>

                                </div>

                            </div>

                            <span
                                class="badge <%= severityClass %>">

                                <%= severity %>

                            </span>

                        </div>

                        <div class="description">

                            <%= item.get(
                                    "description"
                            ) %>

                        </div>

                        <%
                        if (item.get(
                                "actionRequired"
                        ) != null) {
                        %>

                            <div class="action">

                                <strong>
                                    Recommended Action
                                </strong>

                                <%= item.get(
                                        "actionRequired"
                                ) %>

                            </div>

                        <%
                        }
                        %>

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
                    No relevant change detected
                </h3>

                <p>

                    There are currently no active
                    configured regulatory changes
                    matching your approval journey.

                </p>

            </div>

        <%
        }
        %>

    </section>

    <div class="note">

        CHAPERON's Regulation Change Impact Engine
        is a guidance layer. Regulatory updates
        should ultimately be validated against
        official notifications and concerned
        government authorities.

    </div>

</main>

</body>

</html>