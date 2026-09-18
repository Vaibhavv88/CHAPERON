<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.chaperon.model.Business" %>
<%@ page import="com.chaperon.model.ApprovalDependency" %>

<%
    Business business =
            (Business) request.getAttribute("business");

    List<ApprovalDependency> journey =
            (List<ApprovalDependency>) request.getAttribute("journey");

    List<ApprovalDependency> parallelApprovals =
            (List<ApprovalDependency>) request.getAttribute("parallelApprovals");

    List<ApprovalDependency> conditionalApprovals =
            (List<ApprovalDependency>) request.getAttribute("conditionalApprovals");

    List<ApprovalDependency> dependentApprovals =
            (List<ApprovalDependency>) request.getAttribute("dependentApprovals");

    Integer totalRelationships =
            (Integer) request.getAttribute("totalRelationships");

    Integer parallelCount =
            (Integer) request.getAttribute("parallelCount");

    Integer conditionalCount =
            (Integer) request.getAttribute("conditionalCount");

    Integer dependentCount =
            (Integer) request.getAttribute("dependentCount");

    String journeyError =
            (String) request.getAttribute("journeyError");

    if (totalRelationships == null) {
        totalRelationships = 0;
    }

    if (parallelCount == null) {
        parallelCount = 0;
    }

    if (conditionalCount == null) {
        conditionalCount = 0;
    }

    if (dependentCount == null) {
        dependentCount = 0;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>
    Approval Journey Optimizer | CHAPERON
</title>


<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {

    font-family:
        Inter,
        "Segoe UI",
        Arial,
        sans-serif;

    background:
        linear-gradient(
            135deg,
            #f8fbff 0%,
            #eef7ff 45%,
            #f7fbff 100%
        );

    color: #14213d;

    min-height: 100vh;
}


/* ============================================================
   HEADER
   ============================================================ */

.topbar {

    min-height: 76px;

    background:
        rgba(
            255,
            255,
            255,
            0.96
        );

    border-bottom:
        1px solid #dbe8f5;

    display: flex;

    align-items: center;

    justify-content: space-between;

    padding:
        12px
        34px;

    position: sticky;

    top: 0;

    z-index: 1000;

    backdrop-filter:
        blur(16px);

    box-shadow:
        0 8px 26px
        rgba(
            31,
            71,
            136,
            0.06
        );
}


.brand {

    display: flex;

    align-items: center;

    gap: 12px;
}


.brand img {

    width: 48px;

    height: 48px;

    border-radius: 13px;

    object-fit: cover;

    border:
        1px solid #dbeafe;

    box-shadow:
        0 8px 20px
        rgba(
            37,
            99,
            235,
            0.15
        );
}


.brand-text h1 {

    font-size: 21px;

    letter-spacing: 0.8px;

    color: #082f49;
}


.brand-text p {

    margin-top: 2px;

    font-size: 10px;

    color: #64748b;

    font-weight: 700;

    letter-spacing: 1px;
}


.header-actions {

    display: flex;

    gap: 10px;

    align-items: center;
}


.header-btn {

    text-decoration: none;

    border:
        1px solid #cfe0f5;

    background: #ffffff;

    color: #1d4ed8;

    font-size: 13px;

    font-weight: 700;

    padding:
        10px
        15px;

    border-radius: 10px;

    transition:
        0.2s ease;
}


.header-btn:hover {

    background: #eff6ff;

    transform:
        translateY(-1px);
}


/* ============================================================
   LAYOUT
   ============================================================ */

.wrapper {

    width:
        min(
            1420px,
            calc(
                100% - 40px
            )
        );

    margin:
        28px
        auto
        50px;
}


/* ============================================================
   HERO
   ============================================================ */

.hero {

    background:
        linear-gradient(
            125deg,
            #0f3f8f,
            #155ec4 45%,
            #06a6d8
        );

    color: white;

    border-radius: 24px;

    padding:
        34px
        36px;

    position: relative;

    overflow: hidden;

    box-shadow:
        0 22px 46px
        rgba(
            20,
            74,
            150,
            0.18
        );
}


.hero::before {

    content: "";

    position: absolute;

    width: 360px;

    height: 360px;

    border-radius: 50%;

    background:
        rgba(
            255,
            255,
            255,
            0.08
        );

    right: -120px;

    top: -160px;
}


.hero::after {

    content: "";

    position: absolute;

    width: 200px;

    height: 200px;

    border-radius: 50%;

    background:
        rgba(
            255,
            255,
            255,
            0.07
        );

    right: 180px;

    bottom: -120px;
}


.hero-content {

    position: relative;

    z-index: 2;
}


.hero-label {

    display: inline-flex;

    align-items: center;

    gap: 8px;

    padding:
        7px
        11px;

    border-radius: 999px;

    background:
        rgba(
            255,
            255,
            255,
            0.14
        );

    border:
        1px solid
        rgba(
            255,
            255,
            255,
            0.22
        );

    font-size: 12px;

    font-weight: 700;

    margin-bottom: 14px;
}


.hero h2 {

    font-size: 32px;

    line-height: 1.25;

    max-width: 850px;
}


.hero p {

    max-width: 900px;

    margin-top: 12px;

    line-height: 1.65;

    color: #dbeafe;

    font-size: 15px;
}


.business-strip {

    margin-top: 22px;

    display: flex;

    gap: 12px;

    flex-wrap: wrap;
}


.business-chip {

    padding:
        10px
        14px;

    border-radius: 11px;

    background:
        rgba(
            255,
            255,
            255,
            0.13
        );

    border:
        1px solid
        rgba(
            255,
            255,
            255,
            0.16
        );

    font-size: 13px;
}


.business-chip strong {

    color: #ffffff;
}


/* ============================================================
   STATS
   ============================================================ */

.stats-grid {

    display: grid;

    grid-template-columns:
        repeat(
            4,
            minmax(
                0,
                1fr
            )
        );

    gap: 16px;

    margin-top: 22px;
}


.stat-card {

    background: #ffffff;

    border:
        1px solid #dce9f6;

    border-radius: 18px;

    padding: 20px;

    box-shadow:
        0 14px 30px
        rgba(
            15,
            65,
            130,
            0.07
        );
}


.stat-top {

    display: flex;

    justify-content: space-between;

    align-items: center;

    gap: 10px;
}


.stat-icon {

    width: 42px;

    height: 42px;

    display: flex;

    align-items: center;

    justify-content: center;

    border-radius: 12px;

    font-size: 19px;

    background: #eff6ff;
}


.stat-number {

    font-size: 29px;

    font-weight: 800;

    color: #0f3e7d;

    margin-top: 14px;
}


.stat-label {

    margin-top: 4px;

    color: #64748b;

    font-size: 13px;

    font-weight: 600;
}


/* ============================================================
   SECTION
   ============================================================ */

.section {

    margin-top: 26px;
}


.section-heading {

    display: flex;

    justify-content: space-between;

    align-items: flex-end;

    gap: 16px;

    margin-bottom: 14px;
}


.section-heading h3 {

    color: #0f305f;

    font-size: 21px;
}


.section-heading p {

    color: #6b7b93;

    font-size: 13px;

    margin-top: 5px;
}


.section-badge {

    white-space: nowrap;

    border-radius: 999px;

    padding:
        7px
        12px;

    background: #eff6ff;

    color: #1d4ed8;

    font-size: 12px;

    font-weight: 800;
}


/* ============================================================
   SMART INFO
   ============================================================ */

.optimizer-info {

    display: grid;

    grid-template-columns:
        1.25fr
        0.75fr;

    gap: 18px;

    margin-top: 22px;
}


.info-panel {

    background: #ffffff;

    border:
        1px solid #dce9f6;

    border-radius: 20px;

    padding: 24px;

    box-shadow:
        0 14px 32px
        rgba(
            22,
            70,
            130,
            0.06
        );
}


.info-panel h3 {

    color: #103b73;

    font-size: 18px;
}


.info-panel p {

    color: #607087;

    margin-top: 9px;

    line-height: 1.65;

    font-size: 14px;
}


.legend {

    display: flex;

    flex-direction: column;

    gap: 12px;

    margin-top: 16px;
}


.legend-item {

    display: flex;

    align-items: flex-start;

    gap: 11px;

    padding: 12px;

    border-radius: 12px;

    background: #f8fbff;

    border:
        1px solid #e4edf7;
}


.legend-dot {

    min-width: 11px;

    width: 11px;

    height: 11px;

    border-radius: 50%;

    margin-top: 5px;
}


.dot-parallel {

    background: #0ea5e9;
}


.dot-conditional {

    background: #f59e0b;
}


.dot-dependent {

    background: #8b5cf6;
}


.legend-item strong {

    font-size: 13px;

    color: #183b63;
}


.legend-item span {

    display: block;

    font-size: 12px;

    color: #718096;

    margin-top: 2px;

    line-height: 1.5;
}


/* ============================================================
   JOURNEY CARD
   ============================================================ */

.journey-grid {

    display: grid;

    grid-template-columns:
        repeat(
            2,
            minmax(
                0,
                1fr
            )
        );

    gap: 16px;
}


.journey-card {

    background: #ffffff;

    border:
        1px solid #dce8f5;

    border-radius: 18px;

    padding: 20px;

    box-shadow:
        0 13px 28px
        rgba(
            24,
            71,
            130,
            0.06
        );

    position: relative;

    overflow: hidden;

    transition:
        0.2s ease;
}


.journey-card:hover {

    transform:
        translateY(-2px);

    box-shadow:
        0 18px 34px
        rgba(
            24,
            71,
            130,
            0.1
        );
}


.journey-card::before {

    content: "";

    position: absolute;

    left: 0;

    top: 0;

    bottom: 0;

    width: 5px;

    background: #0ea5e9;
}


.journey-card.conditional::before {

    background: #f59e0b;
}


.journey-card.dependent::before {

    background: #8b5cf6;
}


.card-header {

    display: flex;

    justify-content: space-between;

    gap: 14px;

    align-items: flex-start;
}


.approval-title {

    color: #103a6c;

    font-weight: 800;

    font-size: 16px;

    line-height: 1.4;
}


.approval-code {

    margin-top: 4px;

    color: #74839a;

    font-size: 11px;

    font-weight: 700;

    letter-spacing: 0.6px;
}


.type-badge {

    padding:
        7px
        10px;

    border-radius: 999px;

    font-size: 10px;

    font-weight: 900;

    letter-spacing: 0.5px;

    background: #e0f2fe;

    color: #0369a1;

    white-space: nowrap;
}


.type-badge.conditional {

    background: #fff7df;

    color: #b45309;
}


.type-badge.dependent {

    background: #f2eafe;

    color: #6d28d9;
}


.relationship {

    margin-top: 18px;

    display: grid;

    grid-template-columns:
        1fr
        auto
        1fr;

    align-items: center;

    gap: 10px;
}


.relation-node {

    border:
        1px solid #dbe8f6;

    border-radius: 14px;

    padding: 13px;

    background:
        linear-gradient(
            180deg,
            #fbfdff,
            #f6faff
        );
}


.node-label {

    color: #7a8ca5;

    font-size: 10px;

    font-weight: 800;

    text-transform: uppercase;

    letter-spacing: 0.7px;
}


.node-name {

    color: #153d68;

    font-size: 13px;

    font-weight: 800;

    margin-top: 5px;

    line-height: 1.4;
}


.arrow {

    font-size: 20px;

    color: #3b82f6;

    font-weight: 900;
}


.relationship-message {

    margin-top: 14px;

    padding: 12px;

    border-radius: 11px;

    background: #f8fbff;

    color: #5d6d83;

    font-size: 13px;

    line-height: 1.6;

    border:
        1px solid #e5eef8;
}


.condition-box {

    margin-top: 12px;

    border-radius: 11px;

    padding: 11px 12px;

    background: #fffaf0;

    border:
        1px solid #fde7b0;

    font-size: 12px;

    color: #895b07;

    line-height: 1.55;
}


/* ============================================================
   EMPTY STATE
   ============================================================ */

.empty-state {

    background: #ffffff;

    border:
        1px dashed #b8cce3;

    border-radius: 18px;

    padding:
        38px
        25px;

    text-align: center;

    color: #6a7b90;
}


.empty-icon {

    font-size: 36px;

    margin-bottom: 10px;
}


.empty-state h4 {

    color: #173f6d;

    font-size: 17px;
}


.empty-state p {

    margin-top: 7px;

    font-size: 13px;

    line-height: 1.6;
}


/* ============================================================
   ERROR
   ============================================================ */

.error-box {

    background: #fff4f4;

    border:
        1px solid #fecaca;

    color: #991b1b;

    border-radius: 16px;

    padding: 20px;

    margin-top: 20px;
}


.error-box strong {

    display: block;

    margin-bottom: 5px;
}


/* ============================================================
   CTA
   ============================================================ */

.bottom-actions {

    margin-top: 30px;

    background: #ffffff;

    border:
        1px solid #dce9f5;

    border-radius: 18px;

    padding: 20px;

    display: flex;

    justify-content: space-between;

    align-items: center;

    gap: 16px;

    box-shadow:
        0 12px 28px
        rgba(
            20,
            65,
            120,
            0.05
        );
}


.bottom-actions h4 {

    color: #123d6c;

    font-size: 16px;
}


.bottom-actions p {

    margin-top: 4px;

    color: #708198;

    font-size: 12px;
}


.primary-btn {

    display: inline-flex;

    align-items: center;

    justify-content: center;

    text-decoration: none;

    padding:
        11px
        16px;

    border-radius: 11px;

    background:
        linear-gradient(
            135deg,
            #1d4ed8,
            #0ea5e9
        );

    color: white;

    font-weight: 800;

    font-size: 13px;

    box-shadow:
        0 8px 18px
        rgba(
            37,
            99,
            235,
            0.18
        );
}


.primary-btn:hover {

    filter:
        brightness(1.04);
}


/* ============================================================
   FOOTER NOTE
   ============================================================ */

.disclaimer {

    margin-top: 20px;

    text-align: center;

    color: #8290a3;

    font-size: 11px;

    line-height: 1.6;
}


/* ============================================================
   RESPONSIVE
   ============================================================ */

@media (max-width: 1050px) {

    .stats-grid {

        grid-template-columns:
            repeat(
                2,
                1fr
            );
    }


    .optimizer-info {

        grid-template-columns:
            1fr;
    }


    .journey-grid {

        grid-template-columns:
            1fr;
    }
}


@media (max-width: 720px) {

    .topbar {

        padding:
            12px
            16px;

        align-items:
            flex-start;

        gap: 10px;
    }


    .brand-text p {

        display: none;
    }


    .header-actions {

        flex-direction:
            column;

        align-items:
            flex-end;
    }


    .header-btn {

        font-size: 11px;

        padding:
            8px
            10px;
    }


    .wrapper {

        width:
            min(
                100% - 22px,
                1420px
            );

        margin-top:
            16px;
    }


    .hero {

        padding:
            26px
            22px;

        border-radius:
            19px;
    }


    .hero h2 {

        font-size:
            25px;
    }


    .stats-grid {

        grid-template-columns:
            1fr;
    }


    .relationship {

        grid-template-columns:
            1fr;
    }


    .arrow {

        transform:
            rotate(90deg);

        text-align:
            center;
    }


    .bottom-actions {

        flex-direction:
            column;

        align-items:
            flex-start;
    }
}

</style>

</head>


<body>


<!-- ============================================================
     TOP BAR
     ============================================================ -->

<header class="topbar">

    <div class="brand">

        <img
            src="<%= request.getContextPath() %>/images/chaperon-logo.jpeg"
            alt="CHAPERON Logo">

        <div class="brand-text">

            <h1>
                CHAPERON
            </h1>

            <p>
                GUIDE. CONNECT. COMPLY. GET APPROVED.
            </p>

        </div>

    </div>


    <div class="header-actions">

        <a
            href="<%= request.getContextPath() %>/entrepreneur/generate-approvals"
            class="header-btn">

            ← Approval Roadmap

        </a>

        <a
            href="<%= request.getContextPath() %>/entrepreneur/dashboard"
            class="header-btn">

            Dashboard

        </a>

    </div>

</header>


<main class="wrapper">


    <!-- ========================================================
         HERO
         ======================================================== -->

    <section class="hero">

        <div class="hero-content">

            <div class="hero-label">

                ✦ Intelligent Journey Optimizer

            </div>

            <h2>

                Understand how your approvals
                connect before you start applying.

            </h2>

            <p>

                CHAPERON analyzes relationships
                between the approvals recommended
                for your business and highlights
                which approvals may move in parallel,
                which depend on business conditions,
                and which may need a specific sequence.

            </p>


            <%
            if (business != null) {
            %>

                <div class="business-strip">

                    <div class="business-chip">

                        Business:
                        <strong>
                            <%= business.getBusinessName() != null
                                    ? business.getBusinessName()
                                    : "Your Business" %>
                        </strong>

                    </div>


                    <div class="business-chip">

                        Industry:
                        <strong>
                            <%= business.getIndustry() != null
                                    ? business.getIndustry()
                                    : "Not specified" %>
                        </strong>

                    </div>


                    <div class="business-chip">

                        Project Stage:
                        <strong>
                            <%= business.getProjectStage() != null
                                    ? business.getProjectStage()
                                    : "Not specified" %>
                        </strong>

                    </div>

                </div>

            <%
            }
            %>

        </div>

    </section>


    <!-- ========================================================
         ERROR STATE
         ======================================================== -->

    <%
    if (journeyError != null) {
    %>

        <div class="error-box">

            <strong>
                Approval Journey Unavailable
            </strong>

            <%= journeyError %>

        </div>

    <%
    } else {
    %>


        <!-- ====================================================
             STATISTICS
             ==================================================== -->

        <section class="stats-grid">


            <div class="stat-card">

                <div class="stat-top">

                    <div>

                        <div class="stat-number">
                            <%= totalRelationships %>
                        </div>

                        <div class="stat-label">
                            Approval Relationships
                        </div>

                    </div>

                    <div class="stat-icon">
                        🔗
                    </div>

                </div>

            </div>


            <div class="stat-card">

                <div class="stat-top">

                    <div>

                        <div class="stat-number">
                            <%= parallelCount %>
                        </div>

                        <div class="stat-label">
                            Parallel Opportunities
                        </div>

                    </div>

                    <div class="stat-icon">
                        ⇄
                    </div>

                </div>

            </div>


            <div class="stat-card">

                <div class="stat-top">

                    <div>

                        <div class="stat-number">
                            <%= conditionalCount %>
                        </div>

                        <div class="stat-label">
                            Conditional Relations
                        </div>

                    </div>

                    <div class="stat-icon">
                        ◇
                    </div>

                </div>

            </div>


            <div class="stat-card">

                <div class="stat-top">

                    <div>

                        <div class="stat-number">
                            <%= dependentCount %>
                        </div>

                        <div class="stat-label">
                            Sequential / Dependent
                        </div>

                    </div>

                    <div class="stat-icon">
                        →
                    </div>

                </div>

            </div>

        </section>


        <!-- ====================================================
             EXPLANATION
             ==================================================== -->

        <section class="optimizer-info">


            <div class="info-panel">

                <h3>
                    How the Journey Optimizer helps
                </h3>

                <p>

                    Instead of showing approvals as an
                    isolated checklist, CHAPERON creates
                    a connected regulatory journey.
                    This helps entrepreneurs understand
                    what can potentially be handled
                    together and what may change based
                    on business conditions.

                </p>

                <p>

                    Relationship information is guidance
                    generated from CHAPERON's configured
                    approval rules. Final statutory
                    requirements remain subject to the
                    concerned authority.

                </p>

            </div>


            <div class="info-panel">

                <h3>
                    Relationship Guide
                </h3>


                <div class="legend">


                    <div class="legend-item">

                        <div class="legend-dot dot-parallel">
                        </div>

                        <div>

                            <strong>
                                Parallel
                            </strong>

                            <span>
                                Approvals that may progress
                                alongside each other.
                            </span>

                        </div>

                    </div>


                    <div class="legend-item">

                        <div class="legend-dot dot-conditional">
                        </div>

                        <div>

                            <strong>
                                Conditional
                            </strong>

                            <span>
                                Relationship becomes relevant
                                when a specified business
                                condition applies.
                            </span>

                        </div>

                    </div>


                    <div class="legend-item">

                        <div class="legend-dot dot-dependent">
                        </div>

                        <div>

                            <strong>
                                Sequential / Dependent
                            </strong>

                            <span>
                                Approvals that may be connected
                                in a particular processing order.
                            </span>

                        </div>

                    </div>


                </div>

            </div>

        </section>


        <!-- ====================================================
             PARALLEL APPROVALS
             ==================================================== -->

        <section class="section">


            <div class="section-heading">

                <div>

                    <h3>
                        Parallel Approval Opportunities
                    </h3>

                    <p>
                        Approvals that may potentially
                        move together and reduce waiting.
                    </p>

                </div>

                <div class="section-badge">
                    <%= parallelCount %> Found
                </div>

            </div>


            <%
            if (parallelApprovals != null
                    && !parallelApprovals.isEmpty()) {
            %>

                <div class="journey-grid">

                    <%
                    for (ApprovalDependency dependency
                            : parallelApprovals) {
                    %>

                        <div class="journey-card">


                            <div class="card-header">

                                <div>

                                    <div class="approval-title">

                                        <%= dependency.getApprovalName() %>

                                    </div>

                                    <div class="approval-code">

                                        <%= dependency.getApprovalCode() != null
                                                ? dependency.getApprovalCode()
                                                : "" %>

                                    </div>

                                </div>


                                <div class="type-badge">

                                    PARALLEL

                                </div>

                            </div>


                            <div class="relationship">


                                <div class="relation-node">

                                    <div class="node-label">
                                        Approval
                                    </div>

                                    <div class="node-name">

                                        <%= dependency.getApprovalName() %>

                                    </div>

                                </div>


                                <div class="arrow">
                                    ⇄
                                </div>


                                <div class="relation-node">

                                    <div class="node-label">
                                        Related Approval
                                    </div>

                                    <div class="node-name">

                                        <%= dependency.getDependsOnApprovalName() %>

                                    </div>

                                </div>


                            </div>


                            <div class="relationship-message">

                                These approvals may be
                                processed in parallel,
                                helping reduce unnecessary
                                sequential waiting.

                            </div>


                        </div>

                    <%
                    }
                    %>

                </div>

            <%
            } else {
            %>

                <div class="empty-state">

                    <div class="empty-icon">
                        ⇄
                    </div>

                    <h4>
                        No parallel relationship found
                    </h4>

                    <p>

                        Your current recommended approvals
                        do not have a configured parallel
                        relationship.

                    </p>

                </div>

            <%
            }
            %>


        </section>


        <!-- ====================================================
             CONDITIONAL APPROVALS
             ==================================================== -->

        <section class="section">


            <div class="section-heading">

                <div>

                    <h3>
                        Conditional Approval Relationships
                    </h3>

                    <p>

                        These relationships depend on
                        characteristics of your business.

                    </p>

                </div>


                <div class="section-badge">

                    <%= conditionalCount %> Found

                </div>

            </div>


            <%
            if (conditionalApprovals != null
                    && !conditionalApprovals.isEmpty()) {
            %>

                <div class="journey-grid">

                    <%
                    for (ApprovalDependency dependency
                            : conditionalApprovals) {
                    %>

                        <div class="journey-card conditional">


                            <div class="card-header">


                                <div>

                                    <div class="approval-title">

                                        <%= dependency.getApprovalName() %>

                                    </div>

                                    <div class="approval-code">

                                        <%= dependency.getApprovalCode() != null
                                                ? dependency.getApprovalCode()
                                                : "" %>

                                    </div>

                                </div>


                                <div class="type-badge conditional">

                                    CONDITIONAL

                                </div>


                            </div>


                            <div class="relationship">


                                <div class="relation-node">

                                    <div class="node-label">
                                        Approval
                                    </div>

                                    <div class="node-name">

                                        <%= dependency.getApprovalName() %>

                                    </div>

                                </div>


                                <div class="arrow">
                                    →
                                </div>


                                <div class="relation-node">

                                    <div class="node-label">
                                        Related Approval
                                    </div>

                                    <div class="node-name">

                                        <%= dependency.getDependsOnApprovalName() %>

                                    </div>

                                </div>


                            </div>


                            <%
                            if (dependency.getConditionDescription() != null
                                    &&
                                    !dependency.getConditionDescription().isBlank()) {
                            %>

                                <div class="condition-box">

                                    <strong>
                                        Applies when:
                                    </strong>

                                    <br>

                                    <%= dependency.getConditionDescription() %>

                                </div>

                            <%
                            } else {
                            %>

                                <div class="condition-box">

                                    Applicability depends
                                    on your business profile
                                    and regulatory conditions.

                                </div>

                            <%
                            }
                            %>


                        </div>

                    <%
                    }
                    %>

                </div>

            <%
            } else {
            %>

                <div class="empty-state">

                    <div class="empty-icon">
                        ◇
                    </div>

                    <h4>
                        No conditional relationship found
                    </h4>

                    <p>

                        No additional conditional links
                        are currently configured for
                        your recommended approval set.

                    </p>

                </div>

            <%
            }
            %>


        </section>


        <!-- ====================================================
             DEPENDENT / SEQUENTIAL
             ==================================================== -->

        <section class="section">


            <div class="section-heading">

                <div>

                    <h3>
                        Sequential & Dependent Approvals
                    </h3>

                    <p>

                        Relationships where one approval
                        may be linked with another in
                        the regulatory journey.

                    </p>

                </div>


                <div class="section-badge">

                    <%= dependentCount %> Found

                </div>

            </div>


            <%
            if (dependentApprovals != null
                    && !dependentApprovals.isEmpty()) {
            %>

                <div class="journey-grid">

                    <%
                    for (ApprovalDependency dependency
                            : dependentApprovals) {
                    %>

                        <div class="journey-card dependent">


                            <div class="card-header">


                                <div>

                                    <div class="approval-title">

                                        <%= dependency.getApprovalName() %>

                                    </div>

                                    <div class="approval-code">

                                        <%= dependency.getApprovalCode() != null
                                                ? dependency.getApprovalCode()
                                                : "" %>

                                    </div>

                                </div>


                                <div class="type-badge dependent">

                                    <%= dependency.getDependencyType() != null
                                            ? dependency.getDependencyType()
                                            : "DEPENDENT" %>

                                </div>


                            </div>


                            <div class="relationship">


                                <div class="relation-node">

                                    <div class="node-label">
                                        Current Approval
                                    </div>

                                    <div class="node-name">

                                        <%= dependency.getApprovalName() %>

                                    </div>

                                </div>


                                <div class="arrow">
                                    →
                                </div>


                                <div class="relation-node">

                                    <div class="node-label">
                                        Related Approval
                                    </div>

                                    <div class="node-name">

                                        <%= dependency.getDependsOnApprovalName() %>

                                    </div>

                                </div>


                            </div>


                            <%
                            if (dependency.getConditionDescription() != null
                                    &&
                                    !dependency.getConditionDescription().isBlank()) {
                            %>

                                <div class="relationship-message">

                                    <%= dependency.getConditionDescription() %>

                                </div>

                            <%
                            } else {
                            %>

                                <div class="relationship-message">

                                    These approvals are
                                    connected in your
                                    regulatory journey.
                                    Follow the configured
                                    sequence where applicable.

                                </div>

                            <%
                            }
                            %>


                        </div>

                    <%
                    }
                    %>

                </div>

            <%
            } else {
            %>

                <div class="empty-state">

                    <div class="empty-icon">
                        →
                    </div>

                    <h4>
                        No sequential dependency configured
                    </h4>

                    <p>

                        Your current journey does not
                        contain any explicitly configured
                        prerequisite or sequential approval.

                    </p>

                </div>

            <%
            }
            %>


        </section>


        <!-- ====================================================
             COMPLETE RELATIONSHIP MAP
             ==================================================== -->

        <section class="section">


            <div class="section-heading">

                <div>

                    <h3>
                        Complete Approval Relationship Map
                    </h3>

                    <p>

                        All configured connections detected
                        within your recommended approvals.

                    </p>

                </div>


                <div class="section-badge">

                    <%= totalRelationships %>
                    Relationships

                </div>

            </div>


            <%
            if (journey != null
                    && !journey.isEmpty()) {
            %>

                <div class="journey-grid">

                    <%
                    for (ApprovalDependency dependency
                            : journey) {

                        String type =
                                dependency.getDependencyType();

                        String cardClass = "";

                        String badgeClass = "";

                        if ("CONDITIONAL".equalsIgnoreCase(type)) {

                            cardClass = "conditional";
                            badgeClass = "conditional";

                        } else if (
                                "PREREQUISITE".equalsIgnoreCase(type)
                                ||
                                "DEPENDENT".equalsIgnoreCase(type)
                                ||
                                "SEQUENTIAL".equalsIgnoreCase(type)
                        ) {

                            cardClass = "dependent";
                            badgeClass = "dependent";
                        }
                    %>

                        <div class="journey-card <%= cardClass %>">


                            <div class="card-header">


                                <div>

                                    <div class="approval-title">

                                        <%= dependency.getApprovalName() %>

                                    </div>


                                    <div class="approval-code">

                                        <%= dependency.getApprovalCode() != null
                                                ? dependency.getApprovalCode()
                                                : "" %>

                                    </div>

                                </div>


                                <div class="type-badge <%= badgeClass %>">

                                    <%= type != null
                                            ? type
                                            : "RELATED" %>

                                </div>


                            </div>


                            <div class="relationship">


                                <div class="relation-node">

                                    <div class="node-label">
                                        Approval
                                    </div>

                                    <div class="node-name">

                                        <%= dependency.getApprovalName() %>

                                    </div>

                                </div>


                                <div class="arrow">

                                    <%= "PARALLEL".equalsIgnoreCase(type)
                                            ? "⇄"
                                            : "→" %>

                                </div>


                                <div class="relation-node">

                                    <div class="node-label">
                                        Related Approval
                                    </div>

                                    <div class="node-name">

                                        <%= dependency.getDependsOnApprovalName() %>

                                    </div>

                                </div>


                            </div>


                            <%
                            if (dependency.getConditionDescription() != null
                                    &&
                                    !dependency.getConditionDescription().isBlank()) {
                            %>

                                <div class="relationship-message">

                                    <%= dependency.getConditionDescription() %>

                                </div>

                            <%
                            }
                            %>


                        </div>

                    <%
                    }
                    %>

                </div>

            <%
            } else {
            %>

                <div class="empty-state">

                    <div class="empty-icon">
                        🧭
                    </div>

                    <h4>
                        No approval relationships found
                    </h4>

                    <p>

                        Your approvals are available,
                        but no dependency relationships
                        are currently configured between
                        them.

                    </p>

                </div>

            <%
            }
            %>


        </section>


        <!-- ====================================================
             BOTTOM ACTION
             ==================================================== -->

        <div class="bottom-actions">


            <div>

                <h4>
                    Continue your approval journey
                </h4>

                <p>

                    Review your recommended approvals,
                    required documents and readiness
                    before starting an application.

                </p>

            </div>


            <a
                href="<%= request.getContextPath() %>/entrepreneur/generate-approvals"
                class="primary-btn">

                Open Approval Roadmap →

            </a>


        </div>


        <div class="disclaimer">

            CHAPERON provides regulatory guidance
            based on configured approval rules and
            business information. Final applicability,
            processing sequence and statutory decisions
            remain with the concerned government authority.

        </div>


    <%
    }
    %>


</main>


</body>

</html>