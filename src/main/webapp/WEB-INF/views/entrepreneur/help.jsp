<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%
    String userName =
            (String) session.getAttribute("userName");

    if (userName == null ||
        userName.isBlank()) {

        userName = "Entrepreneur";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Help & Support | CHAPERON</title>

<style>

* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, Helvetica, sans-serif;
    background: #f5f8fc;
    color: #17233c;
}

a {
    text-decoration: none;
}

.layout {
    min-height: 100vh;
    display: flex;
}


/* ==================================================
   SIDEBAR
   ================================================== */

.sidebar {
    width: 265px;
    background: #10233f;
    color: white;
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    padding: 24px 18px;
    overflow-y: auto;
}

.logo {
    font-size: 25px;
    font-weight: 900;
    margin-bottom: 6px;
}

.tagline {
    font-size: 11px;
    color: #b7c4d6;
    line-height: 1.5;
    margin-bottom: 28px;
}

.user-box {
    padding: 15px;
    background: rgba(255,255,255,0.08);
    border-radius: 12px;
    margin-bottom: 25px;
}

.user-label {
    font-size: 11px;
    color: #aebed2;
    margin-bottom: 4px;
}

.user-name {
    font-size: 14px;
    font-weight: 800;
}

.menu {
    display: flex;
    flex-direction: column;
    gap: 6px;
}

.menu-title {
    color: #8296b1;
    font-size: 10px;
    font-weight: 900;
    letter-spacing: 1px;
    margin: 15px 10px 7px;
}

.menu-item {
    color: #d6e0ec;
    text-decoration: none;
    padding: 12px 13px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 700;
    display: flex;
    align-items: center;
    gap: 10px;
}

.menu-item:hover {
    background: rgba(255,255,255,0.08);
    color: white;
}

.menu-item.active {
    background: #1677e8;
    color: white;
}

.menu-icon {
    width: 20px;
    text-align: center;
}

.menu-separator {
    height: 1px;
    background: rgba(255,255,255,0.12);
    margin: 12px 0;
}


/* ==================================================
   MAIN
   ================================================== */

.main {
    margin-left: 265px;
    width: calc(100% - 265px);
    min-height: 100vh;
}

.topbar {
    height: 70px;
    background: white;
    border-bottom: 1px solid #e4eaf1;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 35px;
    position: sticky;
    top: 0;
    z-index: 20;
}

.topbar-title {
    font-size: 18px;
    font-weight: 900;
}

.topbar-user {
    font-size: 13px;
    color: #64748b;
}

.content {
    padding: 35px;
    max-width: 1400px;
    margin: auto;
}


/* ==================================================
   HERO
   ================================================== */

.hero {
    background: linear-gradient(
        135deg,
        #ffffff,
        #eef6ff
    );
    border: 1px solid #dce9f8;
    border-radius: 20px;
    padding: 32px;
    margin-bottom: 25px;
    box-shadow:
        0 10px 30px
        rgba(24,50,84,0.05);
}

.hero-badge {
    display: inline-block;
    padding: 6px 10px;
    background: #e7f2ff;
    color: #1768c7;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 900;
    margin-bottom: 12px;
}

.hero h1 {
    margin: 0 0 10px;
    font-size: 31px;
}

.hero p {
    margin: 0;
    color: #627287;
    line-height: 1.7;
    max-width: 850px;
}


/* ==================================================
   SEARCH
   ================================================== */

.search-box {
    margin-top: 22px;
    position: relative;
    max-width: 700px;
}

.search-input {
    width: 100%;
    padding: 15px 18px;
    border-radius: 12px;
    border: 1px solid #cfdae7;
    font-size: 14px;
    outline: none;
    background: white;
}

.search-input:focus {
    border-color: #1677e8;
}


/* ==================================================
   QUICK HELP
   ================================================== */

.section-title {
    margin: 28px 0 15px;
}

.section-title h2 {
    margin: 0 0 6px;
    font-size: 22px;
}

.section-title p {
    margin: 0;
    color: #748196;
    font-size: 14px;
}

.quick-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 16px;
}

.quick-card {
    background: white;
    border: 1px solid #e4eaf1;
    border-radius: 15px;
    padding: 21px;
    color: #17233c;
    transition: 0.2s;
}

.quick-card:hover {
    transform: translateY(-3px);
    border-color: #bfd9f8;
    box-shadow:
        0 10px 25px
        rgba(25,65,110,0.07);
}

.quick-icon {
    width: 42px;
    height: 42px;
    background: #eef6ff;
    color: #1677e8;
    border-radius: 11px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    margin-bottom: 14px;
}

.quick-title {
    font-size: 15px;
    font-weight: 900;
    margin-bottom: 7px;
}

.quick-description {
    font-size: 12px;
    color: #748196;
    line-height: 1.6;
}


/* ==================================================
   STATUS GUIDE
   ================================================== */

.status-card {
    background: white;
    border: 1px solid #e4eaf1;
    border-radius: 18px;
    padding: 25px;
}

.status-flow {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 12px;
}

.status-item {
    padding: 15px;
    background: #f8fafc;
    border: 1px solid #edf1f5;
    border-radius: 12px;
}

.status-name {
    font-size: 12px;
    font-weight: 900;
    color: #1768c7;
    margin-bottom: 7px;
}

.status-description {
    font-size: 12px;
    color: #66758a;
    line-height: 1.5;
}


/* ==================================================
   FAQ
   ================================================== */

.faq-card {
    background: white;
    border: 1px solid #e4eaf1;
    border-radius: 18px;
    padding: 25px;
}

.faq-item {
    border-bottom: 1px solid #edf1f5;
}

.faq-item:last-child {
    border-bottom: none;
}

.faq-question {
    width: 100%;
    border: none;
    background: none;
    padding: 18px 5px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    text-align: left;
    cursor: pointer;
    font-size: 14px;
    font-weight: 900;
    color: #24364c;
}

.faq-answer {
    display: none;
    padding: 0 5px 18px;
    color: #68778b;
    font-size: 13px;
    line-height: 1.7;
}

.faq-item.open .faq-answer {
    display: block;
}

.faq-arrow {
    font-size: 18px;
    color: #1677e8;
}


/* ==================================================
   HELP GRID
   ================================================== */

.help-grid {
    display: grid;
    grid-template-columns: 1.5fr 1fr;
    gap: 20px;
}


/* ==================================================
   CONTACT
   ================================================== */

.contact-card {
    background: white;
    border: 1px solid #e4eaf1;
    border-radius: 18px;
    padding: 25px;
}

.contact-card h3 {
    margin: 0 0 8px;
}

.contact-card p {
    color: #748196;
    font-size: 13px;
    line-height: 1.7;
}

.contact-item {
    background: #f8fafc;
    border: 1px solid #edf1f5;
    padding: 14px;
    border-radius: 11px;
    margin-bottom: 12px;
}

.contact-label {
    font-size: 10px;
    color: #7b8798;
    font-weight: 900;
    text-transform: uppercase;
    margin-bottom: 5px;
}

.contact-value {
    font-size: 13px;
    font-weight: 800;
    color: #29415d;
}

.notice {
    margin-top: 17px;
    background: #fff8e8;
    border: 1px solid #f2dfad;
    color: #7d641e;
    border-radius: 11px;
    padding: 14px;
    line-height: 1.6;
    font-size: 12px;
}


/* ==================================================
   RESPONSIVE
   ================================================== */

@media(max-width: 1150px) {

    .quick-grid {
        grid-template-columns:
            repeat(2, 1fr);
    }

    .status-flow {
        grid-template-columns:
            repeat(2, 1fr);
    }
}

@media(max-width: 850px) {

    .layout {
        display: block;
    }

    .sidebar {
        position: static;
        width: 100%;
    }

    .main {
        margin-left: 0;
        width: 100%;
    }

    .help-grid {
        grid-template-columns: 1fr;
    }
}

@media(max-width: 600px) {

    .content {
        padding: 20px;
    }

    .topbar {
        padding: 0 20px;
    }

    .quick-grid,
    .status-flow {
        grid-template-columns: 1fr;
    }
}

</style>

</head>

<body>

<div class="layout">


<!-- ==================================================
     SIDEBAR
     ================================================== -->

<aside class="sidebar">

    <div class="logo">
        CHAPERON
    </div>

    <div class="tagline">
        FROM BUSINESS IDEA TO APPROVAL —
        ONE INTELLIGENT JOURNEY
    </div>


    <div class="user-box">

        <div class="user-label">
            Logged in as
        </div>

        <div class="user-name">
            <%= userName %>
        </div>

    </div>


    <nav class="menu">


        <div class="menu-title">
            YOUR JOURNEY
        </div>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/dashboard">

            <span class="menu-icon">⌂</span>
            Home

        </a>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/business-onboarding">

            <span class="menu-icon">▣</span>
            My Business

        </a>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/generate-approvals">

            <span class="menu-icon">✓</span>
            My Approval Journey

        </a>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/documents">

            <span class="menu-icon">▤</span>
            Documents

        </a>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/my-applications">

            <span class="menu-icon">▦</span>
            Applications

        </a>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/inspections">

            <span class="menu-icon">⌕</span>
            Inspections

        </a>



        <div class="menu-title">
            SUPPORT & COMPLIANCE
        </div>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/schemes">

            <span class="menu-icon">★</span>
            Government Schemes

        </a>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/compliance">

            <span class="menu-icon">⚙</span>
            Compliance

        </a>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/notifications">

            <span class="menu-icon">●</span>
            Notifications

        </a>


        <a class="menu-item active"
           href="<%= request.getContextPath() %>/entrepreneur/help">

            <span class="menu-icon">?</span>
            Help

        </a>



        <div class="menu-title">
            ACCOUNT
        </div>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/entrepreneur/profile">

            <span class="menu-icon">👤</span>
            Profile

        </a>


        <div class="menu-separator"></div>


        <a class="menu-item"
           href="<%= request.getContextPath() %>/logout">

            <span class="menu-icon">↪</span>
            Logout

        </a>


    </nav>

</aside>



<!-- ==================================================
     MAIN
     ================================================== -->

<main class="main">


    <div class="topbar">

        <div class="topbar-title">
            Help & Support
        </div>

        <div class="topbar-user">
            <%= userName %>
        </div>

    </div>



    <div class="content">


        <!-- ==================================================
             HERO
             ================================================== -->

        <section class="hero">

            <div class="hero-badge">
                CHAPERON HELP CENTER
            </div>

            <h1>
                How can we help you?
            </h1>

            <p>
                Find answers about business onboarding,
                approval recommendations, document uploads,
                application processing, inspections,
                approvals, renewals and compliance.
            </p>


            <div class="search-box">

                <input
                    type="text"
                    id="helpSearch"
                    class="search-input"
                    placeholder="Search help topics..."
                    onkeyup="filterFAQs()">

            </div>

        </section>



        <!-- ==================================================
             QUICK ACCESS
             ================================================== -->

        <div class="section-title">

            <h2>
                Quick Help
            </h2>

            <p>
                Go directly to the section you need.
            </p>

        </div>


        <div class="quick-grid">


            <a class="quick-card"
               href="<%= request.getContextPath() %>/entrepreneur/business-onboarding">

                <div class="quick-icon">
                    ▣
                </div>

                <div class="quick-title">
                    Business Profile
                </div>

                <div class="quick-description">
                    Complete or update your business
                    information used for approval recommendations.
                </div>

            </a>



            <a class="quick-card"
               href="<%= request.getContextPath() %>/entrepreneur/generate-approvals">

                <div class="quick-icon">
                    ✓
                </div>

                <div class="quick-title">
                    Approval Roadmap
                </div>

                <div class="quick-description">
                    See which licences, registrations
                    and NOCs may be required.
                </div>

            </a>



            <a class="quick-card"
               href="<%= request.getContextPath() %>/entrepreneur/documents">

                <div class="quick-icon">
                    ▤
                </div>

                <div class="quick-title">
                    Document Vault
                </div>

                <div class="quick-description">
                    Upload and manage documents required
                    across your applications.
                </div>

            </a>



            <a class="quick-card"
               href="<%= request.getContextPath() %>/entrepreneur/my-applications">

                <div class="quick-icon">
                    ▦
                </div>

                <div class="quick-title">
                    Applications
                </div>

                <div class="quick-description">
                    Track submitted applications,
                    queries, approvals and rejections.
                </div>

            </a>


        </div>



        <!-- ==================================================
             APPLICATION STATUS GUIDE
             ================================================== -->

        <div class="section-title">

            <h2>
                Application Status Guide
            </h2>

            <p>
                Understand what each application
                stage means.
            </p>

        </div>


        <div class="status-card">


            <div class="status-flow">


                <div class="status-item">

                    <div class="status-name">
                        DRAFT
                    </div>

                    <div class="status-description">
                        Application has been created
                        but not submitted yet.
                    </div>

                </div>


                <div class="status-item">

                    <div class="status-name">
                        SUBMITTED
                    </div>

                    <div class="status-description">
                        Your application has been sent
                        to the responsible department.
                    </div>

                </div>


                <div class="status-item">

                    <div class="status-name">
                        UNDER REVIEW
                    </div>

                    <div class="status-description">
                        A government officer is
                        reviewing your application.
                    </div>

                </div>


                <div class="status-item">

                    <div class="status-name">
                        QUERY RAISED
                    </div>

                    <div class="status-description">
                        The officer needs additional
                        information or documents.
                    </div>

                </div>


                <div class="status-item">

                    <div class="status-name">
                        INSPECTION
                    </div>

                    <div class="status-description">
                        An inspection has been
                        scheduled or is being processed.
                    </div>

                </div>


                <div class="status-item">

                    <div class="status-name">
                        FINAL REVIEW
                    </div>

                    <div class="status-description">
                        The application is in the
                        final decision stage.
                    </div>

                </div>


                <div class="status-item">

                    <div class="status-name">
                        APPROVED
                    </div>

                    <div class="status-description">
                        Approval granted. Certificate
                        details may now be available.
                    </div>

                </div>


                <div class="status-item">

                    <div class="status-name">
                        REJECTED
                    </div>

                    <div class="status-description">
                        Application was rejected.
                        Review the stated rejection reason.
                    </div>

                </div>


            </div>


        </div>



        <!-- ==================================================
             FAQ + CONTACT
             ================================================== -->

        <div class="section-title">

            <h2>
                Frequently Asked Questions
            </h2>

            <p>
                Common questions about using CHAPERON.
            </p>

        </div>



        <div class="help-grid">


            <div class="faq-card"
                 id="faqContainer">


                <!-- FAQ 1 -->

                <div class="faq-item">

                    <button
                        class="faq-question"
                        type="button"
                        onclick="toggleFAQ(this)">

                        How does CHAPERON decide
                        which approvals I need?

                        <span class="faq-arrow">
                            +
                        </span>

                    </button>

                    <div class="faq-answer">

                        CHAPERON uses your business profile
                        information such as industry,
                        activity, project stage, employee
                        count, pollution category and other
                        compliance-related details to
                        generate an approval roadmap.

                    </div>

                </div>



                <!-- FAQ 2 -->

                <div class="faq-item">

                    <button
                        class="faq-question"
                        type="button"
                        onclick="toggleFAQ(this)">

                        Why should I complete
                        my business profile?

                        <span class="faq-arrow">
                            +
                        </span>

                    </button>

                    <div class="faq-answer">

                        Your business profile is used to
                        determine applicable approvals and
                        helps CHAPERON provide more relevant
                        guidance throughout your approval
                        journey.

                    </div>

                </div>



                <!-- FAQ 3 -->

                <div class="faq-item">

                    <button
                        class="faq-question"
                        type="button"
                        onclick="toggleFAQ(this)">

                        Can I reuse documents
                        for multiple approvals?

                        <span class="faq-arrow">
                            +
                        </span>

                    </button>

                    <div class="faq-answer">

                        Yes. Documents stored in the
                        CHAPERON Document Vault can be used
                        as part of your approval journey
                        instead of requiring you to upload
                        the same information repeatedly.

                    </div>

                </div>



                <!-- FAQ 4 -->

                <div class="faq-item">

                    <button
                        class="faq-question"
                        type="button"
                        onclick="toggleFAQ(this)">

                        What should I do when
                        an officer raises a query?

                        <span class="faq-arrow">
                            +
                        </span>

                    </button>

                    <div class="faq-answer">

                        Open the relevant application,
                        review the officer's query carefully
                        and submit the required response or
                        supporting information before the
                        stated deadline.

                    </div>

                </div>



                <!-- FAQ 5 -->

                <div class="faq-item">

                    <button
                        class="faq-question"
                        type="button"
                        onclick="toggleFAQ(this)">

                        How do I know if an inspection
                        has been scheduled?

                        <span class="faq-arrow">
                            +
                        </span>

                    </button>

                    <div class="faq-answer">

                        Open the Inspections section.
                        Scheduled inspection information,
                        including the date, time, department
                        and location, will appear there when
                        available.

                    </div>

                </div>



                <!-- FAQ 6 -->

                <div class="faq-item">

                    <button
                        class="faq-question"
                        type="button"
                        onclick="toggleFAQ(this)">

                        Where can I download
                        my approval certificate?

                        <span class="faq-arrow">
                            +
                        </span>

                    </button>

                    <div class="faq-answer">

                        Open My Applications and select an
                        approved application. If a
                        certificate has been issued, the
                        certificate information and print
                        option will appear in the
                        application details.

                    </div>

                </div>



                <!-- FAQ 7 -->

                <div class="faq-item">

                    <button
                        class="faq-question"
                        type="button"
                        onclick="toggleFAQ(this)">

                        What happens if my application
                        is rejected?

                        <span class="faq-arrow">
                            +
                        </span>

                    </button>

                    <div class="faq-answer">

                        Open the rejected application to
                        view the rejection reason and
                        officer remarks. If reapplication
                        is permitted, you can correct the
                        identified issue before applying
                        again.

                    </div>

                </div>



                <!-- FAQ 8 -->

                <div class="faq-item">

                    <button
                        class="faq-question"
                        type="button"
                        onclick="toggleFAQ(this)">

                        How does CHAPERON help with
                        licence expiry and renewal?

                        <span class="faq-arrow">
                            +
                        </span>

                    </button>

                    <div class="faq-answer">

                        The Compliance section displays
                        certificate validity, expiry dates,
                        renewal requirements and available
                        renewal reminder information.

                    </div>

                </div>



                <!-- FAQ 9 -->

                <div class="faq-item">

                    <button
                        class="faq-question"
                        type="button"
                        onclick="toggleFAQ(this)">

                        Are processing times guaranteed?

                        <span class="faq-arrow">
                            +
                        </span>

                    </button>

                    <div class="faq-answer">

                        Processing times shown in CHAPERON
                        are estimated or configured service
                        timelines. Actual processing can
                        depend on the department,
                        application completeness,
                        inspection requirements and
                        regulatory conditions.

                    </div>

                </div>



                <!-- FAQ 10 -->

                <div class="faq-item">

                    <button
                        class="faq-question"
                        type="button"
                        onclick="toggleFAQ(this)">

                        Where can I see government schemes?

                        <span class="faq-arrow">
                            +
                        </span>

                    </button>

                    <div class="faq-answer">

                        Open Government Schemes from the
                        sidebar. Active schemes added by
                        the administrator will appear there
                        along with eligibility, benefits,
                        deadlines and available official
                        information links.

                    </div>

                </div>


            </div>



            <!-- ==================================================
                 CONTACT / GUIDANCE
                 ================================================== -->

            <div class="contact-card">


                <h3>
                    Need More Help?
                </h3>

                <p>
                    Use the relevant CHAPERON section
                    first to review the latest application,
                    query or compliance information.
                </p>


                <div class="contact-item">

                    <div class="contact-label">
                        Application Problem
                    </div>

                    <div class="contact-value">
                        Open My Applications
                    </div>

                </div>


                <div class="contact-item">

                    <div class="contact-label">
                        Document Problem
                    </div>

                    <div class="contact-value">
                        Open Document Vault
                    </div>

                </div>


                <div class="contact-item">

                    <div class="contact-label">
                        Officer Query
                    </div>

                    <div class="contact-value">
                        Open Application Details
                    </div>

                </div>


                <div class="contact-item">

                    <div class="contact-label">
                        Inspection Information
                    </div>

                    <div class="contact-value">
                        Open Inspections
                    </div>

                </div>


                <div class="contact-item">

                    <div class="contact-label">
                        Renewal / Expiry
                    </div>

                    <div class="contact-value">
                        Open Compliance
                    </div>

                </div>


                <div class="notice">

                    <strong>
                        Important:
                    </strong>

                    <br><br>

                    CHAPERON helps users navigate
                    approvals and compliance.

                    Statutory requirements and government
                    rules may change, so official
                    departmental information should be
                    checked where required.

                </div>


            </div>


        </div>


    </div>

</main>

</div>



<script>

/*
 * ==================================================
 * FAQ OPEN / CLOSE
 * ==================================================
 */

function toggleFAQ(button) {

    const faqItem =
        button.parentElement;

    const arrow =
        button.querySelector(
            ".faq-arrow"
        );

    faqItem.classList.toggle(
        "open"
    );

    if (
        faqItem.classList.contains(
            "open"
        )
    ) {

        arrow.textContent = "−";

    } else {

        arrow.textContent = "+";
    }
}


/*
 * ==================================================
 * FAQ SEARCH
 * ==================================================
 */

function filterFAQs() {

    const input =
        document
        .getElementById(
            "helpSearch"
        )
        .value
        .toLowerCase();

    const items =
        document
        .querySelectorAll(
            ".faq-item"
        );

    items.forEach(
        function(item) {

            const text =
                item
                .innerText
                .toLowerCase();

            if (
                text.includes(input)
            ) {

                item.style.display =
                    "block";

            } else {

                item.style.display =
                    "none";
            }
        }
    );
}

</script>

</body>

</html>