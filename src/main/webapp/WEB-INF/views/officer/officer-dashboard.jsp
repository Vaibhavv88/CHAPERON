<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.chaperon.dto.OfficerApplicationView" %>
<%@ page import="com.chaperon.model.Application" %>

<%
    String ctx = request.getContextPath();

    List<OfficerApplicationView> applicationViews =
            (List<OfficerApplicationView>)
            request.getAttribute("applicationViews");

    Integer submittedValue =
            (Integer) request.getAttribute("submittedCount");

    Integer reviewValue =
            (Integer) request.getAttribute("underReviewCount");

    Integer queryValue =
            (Integer) request.getAttribute("queryCount");

    Integer completedValue =
            (Integer) request.getAttribute("completedCount");

    int submittedCount =
            submittedValue != null
                    ? submittedValue
                    : 0;

    int underReviewCount =
            reviewValue != null
                    ? reviewValue
                    : 0;

    int queryCount =
            queryValue != null
                    ? queryValue
                    : 0;

    int completedCount =
            completedValue != null
                    ? completedValue
                    : 0;

    String officerName =
            (String) session.getAttribute("userName");

    String departmentName =
            (String) session.getAttribute("departmentName");

    String employeeCode =
            (String) session.getAttribute("employeeCode");

    String designation =
            (String) session.getAttribute("designation");

    if (officerName == null ||
        officerName.isBlank()) {

        officerName = "Government Officer";
    }

    if (departmentName == null ||
        departmentName.isBlank()) {

        departmentName = "Assigned Department";
    }

    if (employeeCode == null ||
        employeeCode.isBlank()) {

        employeeCode = "Not Available";
    }

    if (designation == null ||
        designation.isBlank()) {

        designation = "Officer";
    }

    String avatarLetter = "O";

    if (officerName != null &&
        !officerName.isBlank()) {

        avatarLetter =
                officerName
                        .substring(0, 1)
                        .toUpperCase();
    }

    int totalVisible =
            submittedCount
            + underReviewCount
            + queryCount
            + completedCount;
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Government Officer Dashboard | CHAPERON</title>

<style>

/* =========================================================
   RESET
========================================================= */

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}


:root {

    --green: #0b9c65;
    --green-dark: #08794f;
    --green-deep: #075c3e;

    --green-soft: #eaf8f1;
    --green-pale: #f4fbf7;

    --navy: #0d1d39;
    --navy-soft: #253957;

    --blue: #1768d5;

    --orange: #e98a25;
    --purple: #7356d8;
    --red: #db4b4b;

    --text: #172742;
    --muted: #71819a;

    --border: #dfe9e5;

    --white: #ffffff;

    --background: #f5f9f7;
}


html {
    scroll-behavior: smooth;
}


body {

    min-height: 100vh;

    font-family:
        "Segoe UI",
        Arial,
        Helvetica,
        sans-serif;

    color: var(--text);

    background:

        radial-gradient(
            circle at 90% 5%,
            rgba(23, 174, 111, 0.08),
            transparent 27%
        ),

        linear-gradient(
            145deg,
            #f5faf7,
            #fbfdfc
        );
}


a {
    color: inherit;
    text-decoration: none;
}



/* =========================================================
   HEADER
========================================================= */

.topbar {

    position: sticky;

    top: 0;

    z-index: 1000;

    min-height: 78px;

    padding:
        0
        4%;

    display: flex;
    align-items: center;
    justify-content: space-between;

    gap: 25px;

    background:
        rgba(
            255,
            255,
            255,
            0.95
        );

    border-bottom:
        1px solid #e1ebe6;

    backdrop-filter:
        blur(16px);

    box-shadow:
        0 5px 24px
        rgba(
            31,
            82,
            61,
            0.05
        );
}



/* =========================================================
   BRAND
========================================================= */

.brand {

    display: flex;
    align-items: center;

    gap: 10px;

    flex-shrink: 0;
}


.brand-logo {

    position: relative;

    width: 51px;
    height: 51px;

    min-width: 51px;

    overflow: hidden;

    border-radius: 50%;

    background: #ffffff;
}


.brand-logo img {

    position: absolute;

    width: 92px;
    height: 92px;

    max-width: none;

    left: -20px;
    top: -7px;

    object-fit: cover;
}


.brand-name {

    color: #1153c4;

    font-size: 23px;

    line-height: 1;

    font-weight: 900;

    letter-spacing: 0.2px;
}


.brand-tagline {

    margin-top: 5px;

    color: #1454bd;

    font-size: 6px;

    font-weight: 900;

    letter-spacing: 0.25px;

    white-space: nowrap;
}



/* =========================================================
   HEADER RIGHT
========================================================= */

.header-right {

    display: flex;
    align-items: center;

    gap: 10px;
}



/* =========================================================
   DEPARTMENT PILL
========================================================= */

.department-pill {

    min-height: 38px;

    padding:
        0
        12px;

    display: flex;
    align-items: center;

    gap: 7px;

    border:
        1px solid #d7eee3;

    border-radius: 10px;

    color: #08764d;

    background: #f0faf5;

    font-size: 9px;

    font-weight: 800;
}


.department-pill svg {

    width: 16px;
    height: 16px;
}



/* =========================================================
   PROFILE
========================================================= */

.profile-button {

    min-width: 190px;

    padding:
        5px
        11px
        5px
        5px;

    display: flex;
    align-items: center;

    gap: 10px;

    border:
        1px solid transparent;

    border-radius: 13px;

    transition:
        background 0.2s ease,
        border 0.2s ease,
        transform 0.2s ease;
}


.profile-button:hover {

    transform:
        translateY(-1px);

    border-color: #d8e9e1;

    background: #f3faf6;
}


.avatar {

    width: 42px;
    height: 42px;

    min-width: 42px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 50%;

    color: #ffffff;

    background:
        linear-gradient(
            135deg,
            #0b9c65,
            #45c28c
        );

    box-shadow:
        0 7px 16px
        rgba(
            11,
            156,
            101,
            0.20
        );

    font-size: 14px;

    font-weight: 850;
}


.profile-info {

    min-width: 0;

    flex: 1;
}


.profile-name {

    overflow: hidden;

    color: #15304b;

    font-size: 11px;

    font-weight: 850;

    text-overflow: ellipsis;

    white-space: nowrap;
}


.profile-role {

    margin-top: 2px;

    color: #75859b;

    font-size: 8px;
}


.profile-arrow {

    color: #708096;

    font-size: 16px;
}



/* =========================================================
   LOGOUT
========================================================= */

.logout {

    min-height: 40px;

    padding:
        0
        12px;

    display: flex;
    align-items: center;
    justify-content: center;

    gap: 6px;

    border-radius: 9px;

    color: #b43b35;

    background: #fff1ef;

    font-size: 9px;

    font-weight: 800;

    transition: 0.2s ease;
}


.logout:hover {

    background: #ffe5e1;

    transform:
        translateY(-1px);
}



/* =========================================================
   PAGE
========================================================= */

.page {

    padding:
        31px
        20px
        60px;
}


.container {

    width: 100%;

    max-width: 1250px;

    margin: auto;
}



/* =========================================================
   HERO
========================================================= */

.hero {

    position: relative;

    overflow: hidden;

    min-height: 245px;

    margin-bottom: 22px;

    padding:
        35px
        38px;

    display: flex;
    align-items: center;
    justify-content: space-between;

    gap: 35px;

    border-radius: 23px;

    color: #ffffff;

    background:

        radial-gradient(
            circle at 91% 8%,
            rgba(64, 225, 162, 0.31),
            transparent 31%
        ),

        linear-gradient(
            130deg,
            #075b3d,
            #078158
        );

    box-shadow:
        0 18px 40px
        rgba(
            8,
            113,
            75,
            0.19
        );
}


.hero::before {

    content: "";

    position: absolute;

    width: 270px;
    height: 270px;

    right: -105px;
    bottom: -155px;

    border:
        40px solid
        rgba(
            255,
            255,
            255,
            0.06
        );

    border-radius: 50%;
}


.hero::after {

    content: "";

    position: absolute;

    width: 100px;
    height: 100px;

    top: -55px;
    right: 270px;

    border-radius: 50%;

    background:
        rgba(
            255,
            255,
            255,
            0.06
        );
}


.hero-content {

    position: relative;

    z-index: 2;

    max-width: 760px;
}


.hero-badge {

    width: max-content;

    margin-bottom: 12px;

    padding:
        6px
        10px;

    display: inline-flex;
    align-items: center;

    gap: 6px;

    border:
        1px solid
        rgba(
            255,
            255,
            255,
            0.21
        );

    border-radius: 50px;

    color: #ddfff0;

    background:
        rgba(
            255,
            255,
            255,
            0.10
        );

    font-size: 9px;

    font-weight: 850;

    letter-spacing: 0.7px;
}


.hero h1 {

    margin-bottom: 8px;

    color: #ffffff;

    font-size: 32px;

    line-height: 1.2;
}


.hero h1 span {

    color: #a5ffcf;
}


.hero-main-copy {

    max-width: 710px;

    color: #daf5e8;

    font-size: 12px;

    line-height: 1.7;
}



/* =========================================================
   OFFICER META
========================================================= */

.officer-meta {

    margin-top: 18px;

    display: flex;

    gap: 9px;

    flex-wrap: wrap;
}


.meta {

    min-height: 34px;

    padding:
        0
        11px;

    display: flex;
    align-items: center;

    gap: 5px;

    border:
        1px solid
        rgba(
            255,
            255,
            255,
            0.15
        );

    border-radius: 8px;

    color: #dff8eb;

    background:
        rgba(
            255,
            255,
            255,
            0.09
        );

    font-size: 8px;
}


.meta strong {

    color: #ffffff;
}



/* =========================================================
   HERO VISUAL
========================================================= */

.hero-visual {

    position: relative;

    z-index: 2;

    width: 245px;
    height: 165px;

    flex-shrink: 0;

    display: flex;
    align-items: center;
    justify-content: center;
}


.visual-circle {

    position: absolute;

    width: 150px;
    height: 150px;

    border-radius: 50%;

    border:
        1px solid
        rgba(
            255,
            255,
            255,
            0.16
        );

    background:
        rgba(
            255,
            255,
            255,
            0.08
        );
}


.visual-card {

    position: relative;

    z-index: 2;

    width: 170px;

    padding:
        15px;

    border:
        1px solid
        rgba(
            255,
            255,
            255,
            0.20
        );

    border-radius: 16px;

    background:
        rgba(
            255,
            255,
            255,
            0.14
        );

    backdrop-filter:
        blur(12px);

    box-shadow:
        0 15px 25px
        rgba(
            0,
            55,
            35,
            0.18
        );
}


.visual-icon {

    width: 44px;
    height: 44px;

    margin-bottom: 10px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 11px;

    color: var(--green);

    background: #ffffff;
}


.visual-icon svg {

    width: 24px;
    height: 24px;
}


.visual-card strong {

    display: block;

    color: #ffffff;

    font-size: 11px;
}


.visual-card span {

    display: block;

    margin-top: 4px;

    color: #d9f4e8;

    font-size: 8px;

    line-height: 1.4;
}



/* =========================================================
   SUMMARY
========================================================= */

.summary {

    display: grid;

    grid-template-columns:
        repeat(
            4,
            minmax(0, 1fr)
        );

    gap: 14px;

    margin-bottom: 26px;
}


.summary-card {

    position: relative;

    overflow: hidden;

    min-height: 124px;

    padding: 17px;

    border:
        1px solid var(--border);

    border-radius: 15px;

    background: #ffffff;

    box-shadow:
        0 7px 22px
        rgba(
            37,
            74,
            59,
            0.045
        );

    transition:
        transform 0.2s ease,
        box-shadow 0.2s ease;
}


.summary-card:hover {

    transform:
        translateY(-3px);

    box-shadow:
        0 13px 28px
        rgba(
            37,
            74,
            59,
            0.09
        );
}


.summary-top {

    display: flex;
    align-items: center;

    gap: 11px;
}


.summary-icon {

    width: 42px;
    height: 42px;

    min-width: 42px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 11px;
}


.summary-icon svg {

    width: 21px;
    height: 21px;
}


.submitted-icon {

    color: #1768d5;

    background: #ebf4ff;
}


.review-icon {

    color: #7655dc;

    background: #f0ecff;
}


.query-icon {

    color: #dd8120;

    background: #fff3e6;
}


.completed-icon {

    color: #0b9c65;

    background: #e9f9f1;
}


.summary-number {

    color: var(--navy);

    font-size: 24px;

    line-height: 1;

    font-weight: 900;
}


.summary-label {

    margin-top: 3px;

    color: #667893;

    font-size: 9px;

    font-weight: 700;
}


.summary-bottom {

    margin-top: 13px;

    padding-top: 9px;

    border-top:
        1px solid #edf2ef;

    color: #8996aa;

    font-size: 8px;
}



/* =========================================================
   WORKSPACE STRIP
========================================================= */

.workspace-strip {

    margin-bottom: 25px;

    padding:
        17px
        20px;

    display: flex;
    align-items: center;
    justify-content: space-between;

    gap: 20px;

    border:
        1px solid #dcebe4;

    border-radius: 14px;

    background:

        linear-gradient(
            120deg,
            #ffffff,
            #f2faf6
        );
}


.workspace-strip-left {

    display: flex;
    align-items: center;

    gap: 12px;
}


.workspace-strip-icon {

    width: 42px;
    height: 42px;

    min-width: 42px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 11px;

    color: #ffffff;

    background:
        linear-gradient(
            135deg,
            #0b9c65,
            #39b97f
        );
}


.workspace-strip-icon svg {

    width: 21px;
    height: 21px;
}


.workspace-strip h3 {

    color: var(--navy);

    font-size: 12px;
}


.workspace-strip p {

    margin-top: 3px;

    color: #74849b;

    font-size: 8px;
}


.workspace-total {

    min-width: 85px;

    padding:
        7px
        10px;

    text-align: center;

    border-radius: 9px;

    color: #08764d;

    background: #eaf8f1;

    font-size: 8px;

    font-weight: 800;
}



/* =========================================================
   SECTION TITLE
========================================================= */

.section-title {

    margin-bottom: 16px;
}


.section-eyebrow {

    margin-bottom: 5px;

    color: var(--green);

    font-size: 8px;

    font-weight: 850;

    letter-spacing: 1px;

    text-transform: uppercase;
}


.section-title h2 {

    color: var(--navy);

    font-size: 22px;
}


.section-title p {

    margin-top: 5px;

    color: var(--muted);

    font-size: 10px;
}



/* =========================================================
   APPLICATIONS
========================================================= */

.applications {

    display: grid;

    gap: 15px;
}


.application-card {

    position: relative;

    overflow: hidden;

    padding:
        21px
        22px;

    border:
        1px solid var(--border);

    border-radius: 17px;

    background: #ffffff;

    box-shadow:
        0 7px 21px
        rgba(
            33,
            71,
            54,
            0.045
        );

    transition:
        transform 0.2s ease,
        box-shadow 0.2s ease,
        border 0.2s ease;
}


.application-card::before {

    content: "";

    position: absolute;

    left: 0;
    top: 0;
    bottom: 0;

    width: 4px;

    background:
        linear-gradient(
            180deg,
            #0b9c65,
            #48c38d
        );
}


.application-card:hover {

    transform:
        translateY(-2px);

    border-color: #cfe4da;

    box-shadow:
        0 13px 29px
        rgba(
            33,
            71,
            54,
            0.09
        );
}



/* =========================================================
   APPLICATION HEADER
========================================================= */

.application-header {

    display: flex;
    align-items: flex-start;
    justify-content: space-between;

    gap: 20px;

    flex-wrap: wrap;
}


.application-number {

    margin-bottom: 5px;

    color: var(--green);

    font-size: 9px;

    font-weight: 900;

    letter-spacing: 0.4px;
}


.approval-name {

    margin-bottom: 4px;

    color: var(--navy);

    font-size: 18px;

    font-weight: 900;
}


.business-name {

    color: #63758d;

    font-size: 10px;
}



/* =========================================================
   STATUS
========================================================= */

.status {

    display: inline-flex;
    align-items: center;
    justify-content: center;

    min-height: 29px;

    padding:
        0
        10px;

    border-radius: 100px;

    font-size: 8px;

    font-weight: 900;

    letter-spacing: 0.2px;
}


.status-submitted {

    color: #1768c7;

    background: #e8f2ff;
}


.status-review {

    color: #6546ad;

    background: #eee8ff;
}


.status-query {

    color: #9a6200;

    background: #fff3de;
}


.status-approved {

    color: #167346;

    background: #e5f7ed;
}


.status-rejected {

    color: #b93b35;

    background: #ffe9e7;
}


.status-default {

    color: #586a80;

    background: #eef2f6;
}



/* =========================================================
   DETAILS
========================================================= */

.details-grid {

    display: grid;

    grid-template-columns:
        repeat(
            4,
            minmax(0, 1fr)
        );

    gap: 11px;

    margin-top: 17px;
}


.detail {

    min-width: 0;

    padding:
        12px;

    border:
        1px solid #edf2ef;

    border-radius: 10px;

    background: #f8faf9;
}


.detail-label {

    margin-bottom: 4px;

    color: #8795a7;

    font-size: 8px;
}


.detail-value {

    overflow-wrap: anywhere;

    color: #283b55;

    font-size: 10px;

    font-weight: 800;
}



/* =========================================================
   ACTIONS
========================================================= */

.actions {

    margin-top: 16px;
}


.review-btn {

    min-height: 39px;

    padding:
        0
        15px;

    display: inline-flex;
    align-items: center;
    justify-content: center;

    gap: 7px;

    border-radius: 8px;

    color: #ffffff;

    background:
        linear-gradient(
            135deg,
            #0b9c65,
            #078151
        );

    box-shadow:
        0 7px 16px
        rgba(
            11,
            156,
            101,
            0.17
        );

    font-size: 9px;

    font-weight: 850;

    transition:
        transform 0.2s ease,
        box-shadow 0.2s ease;
}


.review-btn:hover {

    transform:
        translateY(-1px);

    box-shadow:
        0 10px 21px
        rgba(
            11,
            156,
            101,
            0.24
        );
}



/* =========================================================
   EMPTY
========================================================= */

.empty {

    padding:
        50px
        20px;

    border:
        1px dashed #c9ddd4;

    border-radius: 17px;

    text-align: center;

    background: #ffffff;
}


.empty-icon {

    width: 55px;
    height: 55px;

    margin:
        0 auto
        12px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 50%;

    color: var(--green);

    background: var(--green-soft);
}


.empty-icon svg {

    width: 27px;
    height: 27px;
}


.empty h3 {

    color: var(--navy);

    font-size: 15px;
}


.empty p {

    margin-top: 5px;

    color: #718197;

    font-size: 10px;
}



/* =========================================================
   PROCESS GUIDE
========================================================= */

.process-guide {

    margin-top: 26px;

    padding:
        22px
        24px;

    border:
        1px solid #dcebe4;

    border-radius: 16px;

    background:

        radial-gradient(
            circle at 95% 0%,
            rgba(
                12,
                171,
                106,
                0.08
            ),
            transparent 30%
        ),

        linear-gradient(
            145deg,
            #ffffff,
            #f2faf6
        );
}


.process-guide h3 {

    color: var(--navy);

    font-size: 13px;
}


.process-guide p {

    margin-top: 4px;

    color: var(--muted);

    font-size: 9px;
}


.process-flow {

    margin-top: 15px;

    display: flex;
    align-items: center;

    gap: 6px;

    flex-wrap: wrap;
}


.process-step {

    min-height: 31px;

    padding:
        0
        10px;

    display: flex;
    align-items: center;
    justify-content: center;

    border:
        1px solid #d6e7de;

    border-radius: 7px;

    color: #416852;

    background: #ffffff;

    font-size: 8px;

    font-weight: 750;
}


.process-step.current {

    color: #ffffff;

    border-color: var(--green);

    background: var(--green);
}


.process-arrow {

    color: #94a69d;

    font-size: 10px;
}



/* =========================================================
   FOOTER
========================================================= */

.trust-footer {

    min-height: 40px;

    margin-top: 20px;

    padding:
        9px
        15px;

    display: flex;
    align-items: center;
    justify-content: center;

    gap: 7px;

    border-radius: 9px;

    color: #708099;

    background: #edf4f1;

    font-size: 8px;

    text-align: center;
}


.trust-footer svg {

    width: 14px;
    height: 14px;

    color: #4c7560;
}



/* =========================================================
   RESPONSIVE 1000
========================================================= */

@media(max-width: 1000px) {

    .hero-visual {
        display: none;
    }


    .summary {

        grid-template-columns:
            repeat(
                2,
                minmax(0, 1fr)
            );
    }


    .details-grid {

        grid-template-columns:
            repeat(
                2,
                minmax(0, 1fr)
            );
    }

}



/* =========================================================
   RESPONSIVE 760
========================================================= */

@media(max-width: 760px) {

    .topbar {

        padding:
            10px
            15px;
    }


    .department-pill {

        display: none;
    }


    .profile-button {

        min-width: 0;

        padding: 4px;
    }


    .profile-info,
    .profile-arrow {

        display: none;
    }


    .brand-tagline {

        display: none;
    }


    .page {

        padding:
            20px
            14px
            45px;
    }


    .hero {

        min-height: auto;

        padding:
            27px
            22px;
    }


    .hero h1 {

        font-size: 25px;
    }


    .workspace-strip {

        align-items: flex-start;

        flex-direction: column;
    }


    .workspace-total {

        width: 100%;
    }

}



/* =========================================================
   RESPONSIVE 540
========================================================= */

@media(max-width: 540px) {

    .brand-name {

        font-size: 18px;
    }


    .brand-logo {

        width: 43px;
        height: 43px;

        min-width: 43px;
    }


    .logout {

        width: 40px;

        padding: 0;

        font-size: 0;
    }


    .logout::after {

        content: "↗";

        font-size: 15px;
    }


    .summary {

        grid-template-columns:
            1fr;
    }


    .details-grid {

        grid-template-columns:
            1fr;
    }


    .application-header {

        flex-direction: column;
    }


    .process-flow {

        align-items: stretch;

        flex-direction: column;
    }


    .process-arrow {

        display: none;
    }


    .process-step {

        justify-content: flex-start;
    }

}

</style>

</head>


<body>


<!-- =========================================================
     HEADER
========================================================= -->

<header class="topbar">


    <!-- BRAND -->

    <a
        href="<%= ctx %>/officer/dashboard"
        class="brand">


        <div class="brand-logo">

            <img
                src="<%= ctx %>/images/chaperon-logo.jpeg"
                alt="CHAPERON Logo">

        </div>


        <div>

            <div class="brand-name">
                CHAPERON
            </div>

            <div class="brand-tagline">
                GUIDE. CONNECT. COMPLY. GET APPROVED.
            </div>

        </div>


    </a>



    <!-- RIGHT -->

    <div class="header-right">


        <div class="department-pill">


            <svg
                viewBox="0 0 24 24"
                fill="none">

                <path
                    d="M3 21H21"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"/>

                <path
                    d="M5 21V10H19V21"
                    stroke="currentColor"
                    stroke-width="2"/>

                <path
                    d="M3 10L12 4L21 10H3Z"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linejoin="round"/>

            </svg>


            <%= departmentName %>

        </div>



        <a
            href="#officer-profile"
            class="profile-button">


            <div class="avatar">

                <%= avatarLetter %>

            </div>


            <div class="profile-info">

                <div class="profile-name">

                    <%= officerName %>

                </div>

                <div class="profile-role">

                    Government Officer

                </div>

            </div>


            <div class="profile-arrow">

                ›

            </div>


        </a>



        <a
            class="logout"
            href="<%= ctx %>/logout">

            Logout

        </a>


    </div>


</header>



<!-- =========================================================
     PAGE
========================================================= -->

<div class="page">

<div class="container">



    <!-- =====================================================
         HERO
    ====================================================== -->

    <section class="hero">


        <div class="hero-content">


            <div class="hero-badge">

                ✦ GOVERNMENT OFFICER WORKSPACE

            </div>


            <h1>

                Welcome back,
                <span>
                    <%= officerName %>
                </span>
                👋

            </h1>


            <p class="hero-main-copy">

                Review, verify, inspect and process industrial
                approval applications assigned to your department
                with clear workflow visibility and accountable
                decision-making.

            </p>



            <div
                class="officer-meta"
                id="officer-profile">


                <div class="meta">

                    Department:

                    <strong>
                        <%= departmentName %>
                    </strong>

                </div>


                <div class="meta">

                    Employee Code:

                    <strong>
                        <%= employeeCode %>
                    </strong>

                </div>


                <div class="meta">

                    Designation:

                    <strong>
                        <%= designation %>
                    </strong>

                </div>


            </div>


        </div>



        <div class="hero-visual">


            <div class="visual-circle"></div>


            <div class="visual-card">


                <div class="visual-icon">


                    <svg
                        viewBox="0 0 24 24"
                        fill="none">

                        <path
                            d="M6 2H14L19 7V22H6Z"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linejoin="round"/>

                        <path
                            d="M14 2V7H19"
                            stroke="currentColor"
                            stroke-width="2"/>

                        <path
                            d="M9 13L11 15L16 10"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"/>

                    </svg>


                </div>


                <strong>

                    Review. Verify. Decide.

                </strong>


                <span>

                    Transparent departmental workflow

                </span>


            </div>


        </div>


    </section>



    <!-- =====================================================
         SUMMARY
    ====================================================== -->

    <section class="summary">


        <!-- AWAITING -->

        <article class="summary-card">


            <div class="summary-top">


                <div class="summary-icon submitted-icon">


                    <svg
                        viewBox="0 0 24 24"
                        fill="none">

                        <path
                            d="M6 2H14L19 7V22H6Z"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linejoin="round"/>

                        <path
                            d="M14 2V7H19"
                            stroke="currentColor"
                            stroke-width="2"/>

                    </svg>


                </div>


                <div>

                    <div class="summary-number">
                        <%= submittedCount %>
                    </div>

                    <div class="summary-label">
                        Awaiting Review
                    </div>

                </div>


            </div>


            <div class="summary-bottom">
                Newly submitted applications
            </div>


        </article>



        <!-- UNDER REVIEW -->

        <article class="summary-card">


            <div class="summary-top">


                <div class="summary-icon review-icon">


                    <svg
                        viewBox="0 0 24 24"
                        fill="none">

                        <circle
                            cx="11"
                            cy="11"
                            r="7"
                            stroke="currentColor"
                            stroke-width="2"/>

                        <path
                            d="M16.5 16.5L21 21"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"/>

                    </svg>


                </div>


                <div>

                    <div class="summary-number">
                        <%= underReviewCount %>
                    </div>

                    <div class="summary-label">
                        Under Review
                    </div>

                </div>


            </div>


            <div class="summary-bottom">
                Applications currently being assessed
            </div>


        </article>



        <!-- QUERY -->

        <article class="summary-card">


            <div class="summary-top">


                <div class="summary-icon query-icon">


                    <svg
                        viewBox="0 0 24 24"
                        fill="none">

                        <path
                            d="M4 4H20V16H8L4 20V4Z"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linejoin="round"/>

                        <path
                            d="M8 8H16M8 12H13"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"/>

                    </svg>


                </div>


                <div>

                    <div class="summary-number">
                        <%= queryCount %>
                    </div>

                    <div class="summary-label">
                        Query Raised
                    </div>

                </div>


            </div>


            <div class="summary-bottom">
                Waiting for applicant response
            </div>


        </article>



        <!-- COMPLETED -->

        <article class="summary-card">


            <div class="summary-top">


                <div class="summary-icon completed-icon">


                    <svg
                        viewBox="0 0 24 24"
                        fill="none">

                        <circle
                            cx="12"
                            cy="12"
                            r="9"
                            stroke="currentColor"
                            stroke-width="2"/>

                        <path
                            d="M8 12L11 15L16 9"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"/>

                    </svg>


                </div>


                <div>

                    <div class="summary-number">
                        <%= completedCount %>
                    </div>

                    <div class="summary-label">
                        Completed
                    </div>

                </div>


            </div>


            <div class="summary-bottom">
                Approved or rejected decisions
            </div>


        </article>


    </section>



    <!-- =====================================================
         WORKSPACE INFORMATION
    ====================================================== -->

    <section class="workspace-strip">


        <div class="workspace-strip-left">


            <div class="workspace-strip-icon">


                <svg
                    viewBox="0 0 24 24"
                    fill="none">

                    <path
                        d="M3 21H21"
                        stroke="currentColor"
                        stroke-width="2"/>

                    <path
                        d="M5 21V10H19V21"
                        stroke="currentColor"
                        stroke-width="2"/>

                    <path
                        d="M3 10L12 4L21 10H3Z"
                        stroke="currentColor"
                        stroke-width="2"
                        stroke-linejoin="round"/>

                </svg>


            </div>


            <div>

                <h3>

                    <%= departmentName %>

                </h3>


                <p>

                    Only applications belonging to your assigned
                    department are shown in this workspace.

                </p>

            </div>


        </div>


        <div class="workspace-total">

            <%= totalVisible %>
            Workflow Items

        </div>


    </section>



    <!-- =====================================================
         APPLICATION TITLE
    ====================================================== -->

    <section class="section-title">


        <div class="section-eyebrow">

            DEPARTMENT WORK QUEUE

        </div>


        <h2>

            Department Applications

        </h2>


        <p>

            Review applications submitted to
            <strong>
                <%= departmentName %>
            </strong>
            and take the appropriate departmental action.

        </p>


    </section>



    <!-- =====================================================
         APPLICATION LIST
    ====================================================== -->

<%

if (applicationViews != null &&
    !applicationViews.isEmpty()) {

%>


    <section class="applications">


<%

    for (OfficerApplicationView view
            : applicationViews) {

        Application officerApplication =
                view.getApplication();

        String status =
                officerApplication
                        .getCurrentStatus();

        String statusClass =
                "status-default";

        if ("SUBMITTED".equalsIgnoreCase(status)) {

            statusClass =
                    "status-submitted";

        } else if (
                "UNDER_REVIEW"
                .equalsIgnoreCase(status)
        ) {

            statusClass =
                    "status-review";

        } else if (
                "QUERY_RAISED"
                .equalsIgnoreCase(status)
        ) {

            statusClass =
                    "status-query";

        } else if (
                "APPROVED"
                .equalsIgnoreCase(status)
        ) {

            statusClass =
                    "status-approved";

        } else if (
                "REJECTED"
                .equalsIgnoreCase(status)
        ) {

            statusClass =
                    "status-rejected";
        }

%>


        <article class="application-card">


            <!-- HEADER -->

            <div class="application-header">


                <div>


                    <div class="application-number">

                        <%= officerApplication
                                .getApplicationNumber() %>

                    </div>


                    <div class="approval-name">

                        <%= view.getApprovalName() %>

                    </div>


                    <div class="business-name">

                        Business:
                        <strong>
                            <%= view.getBusinessName() %>
                        </strong>

                    </div>


                </div>



                <span class="status <%= statusClass %>">

                    <%= status != null
                            ? status.replace("_", " ")
                            : "UNKNOWN" %>

                </span>


            </div>



            <!-- DETAILS -->

            <div class="details-grid">


                <div class="detail">

                    <div class="detail-label">
                        Applicant
                    </div>

                    <div class="detail-value">

                        <%= view.getApplicantName() %>

                    </div>

                </div>



                <div class="detail">

                    <div class="detail-label">
                        Submitted On
                    </div>

                    <div class="detail-value">

                        <%= officerApplication
                                .getSubmissionDate() != null
                                ? officerApplication
                                    .getSubmissionDate()
                                : "Not Available" %>

                    </div>

                </div>



                <div class="detail">

                    <div class="detail-label">
                        Expected Completion
                    </div>

                    <div class="detail-value">

                        <%= officerApplication
                                .getExpectedCompletionDate() != null
                                ? officerApplication
                                    .getExpectedCompletionDate()
                                : "Not Available" %>

                    </div>

                </div>



                <div class="detail">

                    <div class="detail-label">
                        SLA
                    </div>

                    <div class="detail-value">

                        <%= officerApplication
                                .getSlaDays() != null
                                ? officerApplication
                                    .getSlaDays()
                                    + " Days"
                                : "Not Available" %>

                    </div>

                </div>


            </div>



            <!-- ACTION -->

            <div class="actions">


                <a
                    class="review-btn"
                    href="<%= ctx %>/officer/application-review?id=<%= officerApplication.getApplicationId() %>">

                    Review Application →

                </a>


            </div>


        </article>


<%

    }

%>


    </section>


<%

} else {

%>


    <!-- =====================================================
         EMPTY
    ====================================================== -->

    <section class="empty">


        <div class="empty-icon">


            <svg
                viewBox="0 0 24 24"
                fill="none">

                <circle
                    cx="12"
                    cy="12"
                    r="9"
                    stroke="currentColor"
                    stroke-width="2"/>

                <path
                    d="M8 12L11 15L16 9"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"/>

            </svg>


        </div>


        <h3>
            No Applications Pending
        </h3>


        <p>

            There are currently no submitted
            applications for your department.

        </p>


    </section>


<%

}

%>



    <!-- =====================================================
         OFFICER PROCESS
    ====================================================== -->

    <section class="process-guide">


        <h3>
            Officer Review Workflow
        </h3>


        <p>
            Every application moves through a transparent
            departmental review lifecycle.
        </p>


        <div class="process-flow">


            <span class="process-step current">
                Application Received
            </span>

            <span class="process-arrow">→</span>


            <span class="process-step">
                Start Review
            </span>

            <span class="process-arrow">→</span>


            <span class="process-step">
                Document Verification
            </span>

            <span class="process-arrow">→</span>


            <span class="process-step">
                Query / Inspection
            </span>

            <span class="process-arrow">→</span>


            <span class="process-step">
                Final Review
            </span>

            <span class="process-arrow">→</span>


            <span class="process-step">
                Approve / Reject
            </span>


        </div>


    </section>



    <!-- =====================================================
         FOOTER
    ====================================================== -->

    <footer class="trust-footer">


        <svg
            viewBox="0 0 24 24"
            fill="none">

            <path
                d="M12 3L20 6V11C20 16 17.1 19.8 12 22C6.9 19.8 4 16 4 11V6L12 3Z"
                stroke="currentColor"
                stroke-width="2"/>

            <path
                d="M8.5 12L11 14.5L16 9.5"
                stroke="currentColor"
                stroke-width="2"/>

        </svg>


        CHAPERON Government Officer Workspace —
        secure, accountable and transparent departmental processing.


    </footer>


</div>

</div>


</body>

</html>