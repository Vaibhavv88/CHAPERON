<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    String ctx = request.getContextPath();

    List<Map<String, Object>> applications =
            (List<Map<String, Object>>)
            request.getAttribute("applications");

    Boolean analysisPerformed =
            (Boolean)
            request.getAttribute("analysisPerformed");

    String analysisError =
            (String)
            request.getAttribute("analysisError");

    Long selectedApplicationId =
            (Long)
            request.getAttribute("selectedApplicationId");

    String applicationNumber =
            (String)
            request.getAttribute("applicationNumber");

    String approvalName =
            (String)
            request.getAttribute("approvalName");

    String departmentName =
            (String)
            request.getAttribute("departmentName");

    String currentStatus =
            (String)
            request.getAttribute("currentStatus");

    String delayTitle =
            (String)
            request.getAttribute("delayTitle");

    String delayExplanation =
            (String)
            request.getAttribute("delayExplanation");

    String nextAction =
            (String)
            request.getAttribute("nextAction");

    String delayLevel =
            (String)
            request.getAttribute("delayLevel");

    String daysInfo =
            (String)
            request.getAttribute("daysInfo");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Explain My Delay | CHAPERON</title>

<style>

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    min-height: 100vh;
    font-family: "Segoe UI", Arial, sans-serif;
    color: #17375f;
    background:
        linear-gradient(
            135deg,
            #f4f8ff,
            #eef7ff
        );
}

.topbar {
    min-height: 72px;
    padding: 12px 30px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: white;
    border-bottom: 1px solid #dfe8f5;
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
    color: #0960e9;
    font-size: 21px;
}

.brand small {
    display: block;
    margin-top: 3px;
    color: #7489a5;
    font-size: 8px;
    font-weight: 800;
}

.back {
    padding: 10px 14px;
    border-radius: 10px;
    text-decoration: none;
    color: #1260cb;
    background: #f6faff;
    border: 1px solid #d7e4f4;
    font-size: 11px;
    font-weight: 800;
}

.container {
    width: min(1180px, calc(100% - 30px));
    margin: 25px auto 50px;
}

.hero {
    padding: 30px;
    border-radius: 22px;
    color: white;
    background:
        linear-gradient(
            125deg,
            #0758dc,
            #126fdc,
            #20a8d8
        );
    box-shadow:
        0 18px 40px
        rgba(18, 85, 180, .18);
}

.hero-tag {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 30px;
    background: rgba(255,255,255,.16);
    font-size: 9px;
    font-weight: 900;
}

.hero h2 {
    margin: 12px 0 7px;
    font-size: 30px;
}

.hero p {
    margin: 0;
    max-width: 800px;
    line-height: 1.65;
    color: #e7f3ff;
    font-size: 12px;
}

.selector {
    margin-top: 20px;
    padding: 22px;
    border-radius: 17px;
    background: white;
    border: 1px solid #dce7f3;
}

.selector h3 {
    margin: 0 0 5px;
}

.selector p {
    margin: 0 0 16px;
    color: #788ba3;
    font-size: 11px;
}

.select-row {
    display: flex;
    gap: 10px;
}

select {
    flex: 1;
    min-height: 44px;
    padding: 0 12px;
    border-radius: 10px;
    border: 1px solid #d5e2f1;
    color: #274461;
    background: #fbfdff;
}

button {
    min-width: 170px;
    border: 0;
    border-radius: 10px;
    color: white;
    cursor: pointer;
    font-weight: 900;
    background:
        linear-gradient(
            135deg,
            #0961e8,
            #1b9be4
        );
}

.error {
    margin-top: 20px;
    padding: 14px;
    border-radius: 12px;
    color: #a42c2c;
    background: #fff1f1;
    border: 1px solid #ffd2d2;
}

.summary-grid {
    margin-top: 20px;
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 12px;
}

.summary-card {
    padding: 17px;
    border-radius: 14px;
    background: white;
    border: 1px solid #dce7f3;
}

.summary-card span {
    display: block;
    color: #8493a7;
    font-size: 9px;
    font-weight: 900;
    text-transform: uppercase;
}

.summary-card strong {
    display: block;
    margin-top: 7px;
    color: #183f70;
    font-size: 13px;
}

.analysis {
    margin-top: 20px;
    padding: 25px;
    border-radius: 18px;
    background: white;
    border: 1px solid #dce7f3;
    box-shadow:
        0 12px 30px
        rgba(20,60,100,.05);
}

.status-line {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 15px;
}

.status-badge {
    padding: 7px 11px;
    border-radius: 50px;
    background: #edf5ff;
    color: #1261c9;
    font-size: 9px;
    font-weight: 900;
}

.analysis h2 {
    margin: 15px 0 7px;
    color: #173b69;
    font-size: 23px;
}

.analysis > p {
    color: #687f9a;
    line-height: 1.7;
    font-size: 12px;
}

.explanation-grid {
    margin-top: 20px;
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 14px;
}

.info-box {
    padding: 18px;
    border-radius: 14px;
    background: #f7faff;
    border: 1px solid #dce8f6;
}

.info-box label {
    display: block;
    margin-bottom: 8px;
    color: #1263cc;
    font-size: 9px;
    font-weight: 900;
    text-transform: uppercase;
}

.info-box p {
    margin: 0;
    color: #526b87;
    line-height: 1.65;
    font-size: 11px;
}

.next-action {
    margin-top: 14px;
    padding: 19px;
    border-radius: 14px;
    background:
        linear-gradient(
            135deg,
            #edf7ff,
            #f5fbff
        );
    border: 1px solid #cfe5fa;
}

.next-action strong {
    display: block;
    margin-bottom: 7px;
    color: #075dc9;
    font-size: 12px;
}

.next-action p {
    margin: 0;
    color: #526d8a;
    font-size: 11px;
    line-height: 1.65;
}

.disclaimer {
    margin-top: 15px;
    color: #8291a5;
    font-size: 9px;
    line-height: 1.6;
}

@media(max-width:850px) {

    .summary-grid {
        grid-template-columns: 1fr 1fr;
    }

    .explanation-grid {
        grid-template-columns: 1fr;
    }
}

@media(max-width:600px) {

    .summary-grid {
        grid-template-columns: 1fr;
    }

    .select-row {
        flex-direction: column;
    }

    button {
        min-height: 44px;
    }

    .hero h2 {
        font-size: 24px;
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

            <h1>CHAPERON</h1>

            <small>
                GUIDE. CONNECT. COMPLY. GET APPROVED.
            </small>

        </div>

    </div>

    <a
        class="back"
        href="<%= ctx %>/entrepreneur/my-applications">

        ← My Applications

    </a>

</header>

<main class="container">

    <section class="hero">

        <div class="hero-tag">
            ✦ APPLICATION DELAY INTELLIGENCE
        </div>

        <h2>
            Explain My Delay
        </h2>

        <p>
            CHAPERON analyses your current application stage,
            officer queries, inspection status and estimated
            processing timeline to explain what may currently
            be holding the application and what you should do next.
        </p>

    </section>

    <section class="selector">

        <h3>
            Select an Application
        </h3>

        <p>
            Choose one of your applications to analyse its current processing situation.
        </p>

        <form
            method="get"
            action="<%= ctx %>/entrepreneur/explain-delay">

            <div class="select-row">

                <select
                    name="applicationId"
                    required>

                    <option value="">
                        Select Application
                    </option>

                    <%
                    if (applications != null) {

                        for (Map<String, Object> appRow
                                : applications) {

                            Object id =
                                    appRow.get(
                                            "applicationId"
                                    );

                            boolean selected =
                                    selectedApplicationId != null
                                    &&
                                    String.valueOf(
                                            selectedApplicationId
                                    ).equals(
                                            String.valueOf(id)
                                    );
                    %>

                        <option
                            value="<%= id %>"
                            <%= selected
                                    ? "selected"
                                    : "" %>>

                            <%= appRow.get("applicationNumber") %>
                            —
                            <%= appRow.get("approvalName") %>
                            [
                            <%= appRow.get("currentStatus") %>
                            ]

                        </option>

                    <%
                        }
                    }
                    %>

                </select>

                <button type="submit">
                    Explain My Delay →
                </button>

            </div>

        </form>

    </section>

    <%
    if (analysisError != null) {
    %>

        <div class="error">
            <%= analysisError %>
        </div>

    <%
    }
    %>

    <%
    if (Boolean.TRUE.equals(
            analysisPerformed)) {
    %>

        <section class="summary-grid">

            <div class="summary-card">

                <span>
                    Application
                </span>

                <strong>
                    <%= applicationNumber %>
                </strong>

            </div>

            <div class="summary-card">

                <span>
                    Approval
                </span>

                <strong>
                    <%= approvalName %>
                </strong>

            </div>

            <div class="summary-card">

                <span>
                    Department
                </span>

                <strong>
                    <%= departmentName %>
                </strong>

            </div>

            <div class="summary-card">

                <span>
                    Current Status
                </span>

                <strong>
                    <%= currentStatus %>
                </strong>

            </div>

        </section>

        <section class="analysis">

            <div class="status-line">

                <div class="status-badge">
                    <%= delayLevel %>
                </div>

                <div class="status-badge">
                    <%= daysInfo %>
                </div>

            </div>

            <h2>
                <%= delayTitle %>
            </h2>

            <p>
                CHAPERON analysed the latest workflow
                information available for this application.
            </p>

            <div class="explanation-grid">

                <div class="info-box">

                    <label>
                        Why is this happening?
                    </label>

                    <p>
                        <%= delayExplanation %>
                    </p>

                </div>

                <div class="info-box">

                    <label>
                        Current Processing Signal
                    </label>

                    <p>
                        Application status:
                        <strong>
                            <%= currentStatus %>
                        </strong>
                        <br><br>
                        Timeline signal:
                        <strong>
                            <%= daysInfo %>
                        </strong>
                    </p>

                </div>

            </div>

            <div class="next-action">

                <strong>
                    Your Next Best Action
                </strong>

                <p>
                    <%= nextAction %>
                </p>

            </div>

            <div class="disclaimer">
                This explanation is generated from the
                workflow data available inside CHAPERON.
                Estimated processing timelines do not replace
                statutory timelines or official departmental communication.
            </div>

        </section>

    <%
    }
    %>

</main>

</body>
</html>