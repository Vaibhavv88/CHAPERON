<%@ page language="java"

         contentType="text/html; charset=UTF-8"

         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>

<%@ page import="com.chaperon.model.BusinessApproval" %>

<%

    String ctx = request.getContextPath();

    List<BusinessApproval> recommendations =

            (List<BusinessApproval>)

            request.getAttribute("recommendations");

    int totalApprovals = 0;

    int requiredCount = 0;

    int highPriorityCount = 0;

    int notStartedCount = 0;

    if (recommendations != null) {

        totalApprovals =

                recommendations.size();

        for (BusinessApproval approvalRow

                : recommendations) {

            if ("REQUIRED".equalsIgnoreCase(

                    approvalRow.getRequirementStatus())) {

                requiredCount++;

            }

            if ("HIGH".equalsIgnoreCase(

                    approvalRow.getPriorityLevel())) {

                highPriorityCount++;

            }

            String approvalStatus =

                    approvalRow.getCurrentStatus();

            if (approvalStatus == null ||

                approvalStatus.isBlank() ||

                "NOT_STARTED".equalsIgnoreCase(

                        approvalStatus) ||

                "NOT STARTED".equalsIgnoreCase(

                        approvalStatus)) {

                notStartedCount++;

            }

        }

    }

%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"

      content="width=device-width, initial-scale=1.0">

<title>

    Approval Roadmap | CHAPERON

</title>

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

    --primary: #095ee8;

    --primary-dark: #0648b8;

    --primary-soft: #edf5ff;

    --cyan: #28b8ef;

    --cyan-soft: #eaf9ff;

    --navy: #102443;

    --text: #29405e;

    --muted: #74869f;

    --green: #12885a;

    --green-soft: #eaf8f1;

    --orange: #c9771d;

    --orange-soft: #fff3e4;

    --red: #bd3e3e;

    --red-soft: #fff0f0;

    --border: #dfe8f4;

    --page-bg: #f3f7fc;

    --white: #ffffff;

    --shadow:

        0 10px 30px

        rgba(32, 65, 112, 0.07);

    --shadow-hover:

        0 18px 40px

        rgba(32, 65, 112, 0.12);

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

            circle at 90% 2%,

            rgba(40, 184, 239, 0.08),

            transparent 25%

        ),

        var(--page-bg);

}

a {

    color: inherit;

    text-decoration: none;

}



/* =========================================================

   APP LAYOUT

========================================================= */

.app-shell {

    min-height: 100vh;

    display: grid;

    grid-template-columns:

        235px

        minmax(0, 1fr);

}



/* =========================================================

   SIDEBAR

========================================================= */

.sidebar {

    position: sticky;

    top: 0;

    height: 100vh;

    padding:

        25px

        18px

        20px;

    display: flex;

    flex-direction: column;

    border-right:

        1px solid #e1e9f4;

    background:

        rgba(255, 255, 255, 0.97);

    backdrop-filter:

        blur(15px);

}



/* =========================================================

   BRAND

========================================================= */

.sidebar-brand {

    margin-bottom: 28px;

    padding:

        0

        7px;

    display: flex;

    align-items: center;

    gap: 9px;

}

.logo-wrap {

    position: relative;

    width: 43px;

    height: 43px;

    min-width: 43px;

    overflow: hidden;

    border-radius: 50%;

    background: white;

}

.logo-wrap img {

    position: absolute;

    width: 80px;

    height: 80px;

    max-width: none;

    left: -18px;

    top: -6px;

    object-fit: cover;

}

.brand-name {

    color: #1053c4;

    font-size: 18px;

    font-weight: 900;

    line-height: 1;

}

.brand-tagline {

    margin-top: 4px;

    color: #67809f;

    font-size: 6px;

    font-weight: 850;

    white-space: nowrap;

}



/* =========================================================

   SIDEBAR NAV

========================================================= */

.nav-label {

    margin:

        0

        10px

        8px;

    color: #9aa8b9;

    font-size: 7px;

    font-weight: 900;

    letter-spacing: 1px;

}

.nav-list {

    display: flex;

    flex-direction: column;

    gap: 5px;

}

.nav-item {

    min-height: 42px;

    padding:

        0

        11px;

    display: flex;

    align-items: center;

    gap: 10px;

    border-radius: 11px;

    color: #536a87;

    font-size: 10px;

    font-weight: 750;

    transition:

        0.2s ease;

}

.nav-item svg {

    width: 18px;

    height: 18px;

    min-width: 18px;

}

.nav-item:hover {

    color: var(--primary);

    background: #f0f6ff;

    transform:

        translateX(2px);

}

.nav-item.active {

    color: white;

    background:

        linear-gradient(

            135deg,

            #0962e8,

            #2697e9

        );

    box-shadow:

        0 9px 20px

        rgba(9, 98, 232, 0.18);

}

.sidebar-spacer {

    flex: 1;

}

.back-dashboard {

    min-height: 40px;

    padding:

        0

        11px;

    display: flex;

    align-items: center;

    gap: 8px;

    border:

        1px solid #dce6f3;

    border-radius: 10px;

    color: #466483;

    background: #f7faff;

    font-size: 9px;

    font-weight: 800;

}

.back-dashboard:hover {

    color: var(--primary);

    border-color: #cbdcf3;

    background: #edf5ff;

}



/* =========================================================

   MAIN CONTENT

========================================================= */

.main {

    min-width: 0;

    padding:

        27px

        30px

        45px;

}

.container {

    width: 100%;

    max-width: 1280px;

    margin: auto;

}



/* =========================================================

   TOPBAR

========================================================= */

.topbar {

    margin-bottom: 22px;

    display: flex;

    align-items: center;

    justify-content: space-between;

    gap: 20px;

}

.topbar-left {

    min-width: 0;

}

.page-eyebrow {

    margin-bottom: 5px;

    color: var(--primary);

    font-size: 8px;

    font-weight: 900;

    letter-spacing: 1px;

}

.topbar h1 {

    color: var(--navy);

    font-size: 25px;

    line-height: 1.2;

}

.topbar p {

    margin-top: 5px;

    color: var(--muted);

    font-size: 10px;

}

.dashboard-button {

    min-height: 40px;

    padding:

        0

        14px;

    display: inline-flex;

    align-items: center;

    justify-content: center;

    gap: 7px;

    border:

        1px solid #dce7f5;

    border-radius: 10px;

    color: #416383;

    background: white;

    font-size: 9px;

    font-weight: 850;

    box-shadow:

        0 5px 15px

        rgba(40, 70, 110, 0.04);

    transition:

        .2s ease;

}

.dashboard-button:hover {

    transform:

        translateY(-2px);

    color: var(--primary);

    border-color: #cbdcf3;

}



/* =========================================================

   HERO / ROADMAP HEADER

========================================================= */

.hero {

    position: relative;

    overflow: hidden;

    min-height: 215px;

    margin-bottom: 18px;

    padding:

        31px

        34px;

    display: flex;

    align-items: center;

    justify-content: space-between;

    gap: 30px;

    border-radius: 22px;

    color: white;

    background:

        radial-gradient(

            circle at 89% 8%,

            rgba(80, 212, 255, 0.30),

            transparent 29%

        ),

        linear-gradient(

            130deg,

            #075de7,

            #124bbb

        );

    box-shadow:

        0 18px 42px

        rgba(15, 75, 175, 0.18);

}

.hero::before {

    content: "";

    position: absolute;

    width: 260px;

    height: 260px;

    right: -105px;

    bottom: -170px;

    border:

        38px solid

        rgba(255, 255, 255, 0.055);

    border-radius: 50%;

}

.hero-content {

    position: relative;

    z-index: 2;

    max-width: 720px;

}

.hero-label {

    width: max-content;

    margin-bottom: 11px;

    padding:

        5px

        10px;

    border:

        1px solid

        rgba(255, 255, 255, 0.19);

    border-radius: 50px;

    color: #e3f1ff;

    background:

        rgba(255, 255, 255, 0.09);

    font-size: 7px;

    font-weight: 900;

    letter-spacing: .8px;

}

.hero h2 {

    margin-bottom: 9px;

    font-size: 30px;

    line-height: 1.18;

}

.hero p {

    max-width: 720px;

    color: #dceaff;

    font-size: 11px;

    line-height: 1.7;

}

.hero-mini {

    position: relative;

    z-index: 2;

    width: 210px;

    padding:

        17px;

    flex-shrink: 0;

    border:

        1px solid

        rgba(255, 255, 255, 0.20);

    border-radius: 16px;

    background:

        rgba(255, 255, 255, 0.12);

    backdrop-filter:

        blur(10px);

}

.hero-mini strong {

    display: block;

    font-size: 12px;

}

.hero-mini span {

    display: block;

    margin-top: 5px;

    color: #dceaff;

    font-size: 8px;

    line-height: 1.5;

}



/* =========================================================

   SUMMARY CARDS

========================================================= */

.stats-grid {

    margin-bottom: 27px;

    display: grid;

    grid-template-columns:

        repeat(

            4,

            minmax(0, 1fr)

        );

    gap: 12px;

}

.stat-card {

    min-height: 100px;

    padding:

        16px

        17px;

    border:

        1px solid var(--border);

    border-radius: 15px;

    background: white;

    box-shadow: var(--shadow);

}

.stat-top {

    display: flex;

    align-items: center;

    justify-content: space-between;

    gap: 10px;

}

.stat-label {

    color: #7789a1;

    font-size: 8px;

    font-weight: 800;

}

.stat-icon {

    width: 29px;

    height: 29px;

    display: flex;

    align-items: center;

    justify-content: center;

    border-radius: 8px;

    color: var(--primary);

    background: var(--primary-soft);

}

.stat-icon svg {

    width: 15px;

    height: 15px;

}

.stat-value {

    margin-top: 10px;

    color: #142a4a;

    font-size: 25px;

    font-weight: 900;

    line-height: 1;

}

.stat-note {

    margin-top: 6px;

    color: #98a4b4;

    font-size: 7px;

}



/* =========================================================

   SECTION HEADING

========================================================= */

.section-heading {

    margin-bottom: 17px;

    display: flex;

    align-items: flex-end;

    justify-content: space-between;

    gap: 15px;

}

.section-heading-left {

    min-width: 0;

}

.section-heading .eyebrow {

    margin-bottom: 5px;

    color: var(--primary);

    font-size: 8px;

    font-weight: 900;

    letter-spacing: 1px;

}

.section-heading h2 {

    color: var(--navy);

    font-size: 21px;

}

.section-heading p {

    margin-top: 5px;

    color: var(--muted);

    font-size: 9px;

}

.total-pill {

    padding:

        7px

        10px;

    border:

        1px solid #dce7f5;

    border-radius: 50px;

    color: #577393;

    background: white;

    font-size: 7px;

    font-weight: 900;

    white-space: nowrap;

}



/* =========================================================

   APPROVAL GRID

========================================================= */

.approval-grid {

    display: grid;

    grid-template-columns:

        repeat(

            2,

            minmax(0, 1fr)

        );

    gap: 16px;

}



/* =========================================================

   APPROVAL CARD

========================================================= */

.approval-card {

    position: relative;

    overflow: hidden;

    min-height: 345px;

    padding:

        21px;

    display: flex;

    flex-direction: column;

    border:

        1px solid #dfe8f4;

    border-radius: 17px;

    background:

        linear-gradient(

            145deg,

            #ffffff,

            #fbfdff

        );

    box-shadow: var(--shadow);

    transition:

        transform .22s ease,

        box-shadow .22s ease,

        border .22s ease;

}

.approval-card::after {

    content: "";

    position: absolute;

    width: 100px;

    height: 100px;

    right: -55px;

    top: -55px;

    border-radius: 50%;

    background:

        rgba(9, 94, 232, 0.035);

}

.approval-card:hover {

    transform:

        translateY(-4px);

    border-color: #c9dcf4;

    box-shadow:

        var(--shadow-hover);

}



/* =========================================================

   APPROVAL HEADER

========================================================= */

.card-header {

    position: relative;

    z-index: 2;

    display: flex;

    align-items: flex-start;

    gap: 13px;

}

.approval-number {

    width: 43px;

    height: 43px;

    min-width: 43px;

    display: flex;

    align-items: center;

    justify-content: center;

    border-radius: 12px;

    color: #0861df;

    background:

        linear-gradient(

            145deg,

            #edf5ff,

            #e5f2ff

        );

    font-size: 15px;

    font-weight: 900;

}

.approval-title {

    min-width: 0;

    flex: 1;

}

.approval-title h3 {

    color: #142948;

    font-size: 16px;

    line-height: 1.3;

}

.approval-code {

    margin-top: 4px;

    color: #8090a6;

    font-size: 8px;

    font-weight: 700;

}

.approval-state {

    padding:

        5px

        8px;

    flex-shrink: 0;

    border-radius: 6px;

    color: #55708f;

    background: #eef3f9;

    font-size: 7px;

    font-weight: 900;

}



/* =========================================================

   BADGES

========================================================= */

.badges {

    position: relative;

    z-index: 2;

    margin:

        16px

        0

        13px;

    display: flex;

    align-items: center;

    gap: 6px;

    flex-wrap: wrap;

}

.badge {

    min-height: 24px;

    padding:

        0

        8px;

    display: inline-flex;

    align-items: center;

    border-radius: 6px;

    font-size: 7px;

    font-weight: 900;

    letter-spacing: .2px;

}

.required {

    color: #b63838;

    background: #fff0f0;

}

.conditional {

    color: #a96617;

    background: #fff3e4;

}

.recommended {

    color: #075ecf;

    background: #eaf4ff;

}

.high {

    color: #b63838;

    background: #fff0f0;

}

.medium {

    color: #a86d20;

    background: #fff3e5;

}

.low {

    color: #14774d;

    background: #eaf8f1;

}

.status {

    color: #4e6b8c;

    background: #edf3f9;

}

.mandatory {

    color: #075dcc;

    background: #eaf4ff;

}



/* =========================================================

   RECOMMENDATION EXPLANATION

========================================================= */

.reason-box {

    position: relative;

    z-index: 2;

    min-height: 105px;

    margin-top: 2px;

    padding:

        15px;

    border:

        1px solid #dde7f3;

    border-radius: 12px;

    background:

        linear-gradient(

            145deg,

            #f9fbfe,

            #f5f9ff

        );

}

.reason-header {

    margin-bottom: 7px;

    display: flex;

    align-items: center;

    gap: 7px;

}

.reason-icon {

    width: 25px;

    height: 25px;

    display: flex;

    align-items: center;

    justify-content: center;

    border-radius: 7px;

    color: #0862e6;

    background: #e9f3ff;

}

.reason-icon svg {

    width: 13px;

    height: 13px;

}

.reason-title {

    color: #263e60;

    font-size: 9px;

    font-weight: 900;

}

.reason-text {

    color: #617692;

    font-size: 10px;

    line-height: 1.65;

}



/* =========================================================

   CARD FOOTER

========================================================= */

.card-footer {

    position: relative;

    z-index: 2;

    margin-top: auto;

    padding-top: 17px;

    display: flex;

    align-items: center;

    justify-content: space-between;

    gap: 10px;

}

.view-button {

    min-height: 39px;

    padding:

        0

        14px;

    display: inline-flex;

    align-items: center;

    justify-content: center;

    gap: 7px;

    border-radius: 8px;

    color: white;

    background:

        linear-gradient(

            135deg,

            #0962e8,

            #0751c6

        );

    box-shadow:

        0 7px 16px

        rgba(9, 94, 232, 0.18);

    font-size: 8px;

    font-weight: 900;

    transition:

        .2s ease;

}

.view-button:hover {

    transform:

        translateY(-2px);

    box-shadow:

        0 10px 21px

        rgba(9, 94, 232, 0.24);

}

.card-footer-note {

    color: #95a2b3;

    font-size: 7px;

    font-weight: 750;

}



/* =========================================================

   EMPTY STATE

========================================================= */

.empty-card {

    padding:

        55px

        30px;

    border:

        1px solid #dfe8f3;

    border-radius: 18px;

    background: white;

    box-shadow: var(--shadow);

    text-align: center;

}

.empty-icon {

    width: 55px;

    height: 55px;

    margin:

        0

        auto

        14px;

    display: flex;

    align-items: center;

    justify-content: center;

    border-radius: 15px;

    color: #0c7d51;

    background: #eaf8f1;

    font-size: 22px;

    font-weight: 900;

}

.empty-card h2 {

    color: #173150;

    font-size: 18px;

}

.empty-card p {

    max-width: 600px;

    margin:

        8px

        auto

        0;

    color: #74869c;

    font-size: 10px;

    line-height: 1.65;

}



/* =========================================================

   BOTTOM STRIP

========================================================= */

.bottom-strip {

    margin-top: 23px;

    min-height: 48px;

    padding:

        0

        16px;

    display: flex;

    align-items: center;

    justify-content: space-between;

    gap: 15px;

    border:

        1px solid #dfe8f3;

    border-radius: 12px;

    background: #edf3fa;

}

.bottom-copy {

    color: #647b98;

    font-size: 8px;

}

.bottom-button {

    color: #075dcc;

    font-size: 8px;

    font-weight: 900;

}



/* =========================================================

   RESPONSIVE

========================================================= */

@media(max-width: 1100px) {

    .approval-grid {

        grid-template-columns:

            1fr;

    }

    .stats-grid {

        grid-template-columns:

            repeat(

                2,

                minmax(0, 1fr)

            );

    }

}

@media(max-width: 850px) {

    .app-shell {

        grid-template-columns:

            75px

            minmax(0, 1fr);

    }

    .sidebar {

        padding:

            20px

            10px;

    }

    .sidebar-brand {

        padding: 0;

        justify-content: center;

    }

    .sidebar-brand > div:last-child,

    .nav-label,

    .nav-item span,

    .back-dashboard span {

        display: none;

    }

    .nav-item,

    .back-dashboard {

        width: 45px;

        margin: auto;

        padding: 0;

        justify-content: center;

    }

    .main {

        padding:

            21px

            18px

            35px;

    }

    .hero-mini {

        display: none;

    }

}

@media(max-width: 620px) {

    .app-shell {

        display: block;

    }

    .sidebar {

        position: static;

        width: 100%;

        height: auto;

        padding:

            10px

            12px;

        flex-direction: row;

        align-items: center;

        overflow-x: auto;

    }

    .sidebar-brand {

        margin:

            0

            14px

            0

            0;

    }

    .nav-list {

        flex-direction: row;

    }

    .sidebar-spacer,

    .back-dashboard {

        display: none;

    }

    .main {

        padding:

            17px

            12px

            30px;

    }

    .topbar {

        align-items: flex-start;

        flex-direction: column;

    }

    .hero {

        min-height: auto;

        padding:

            25px

            21px;

    }

    .hero h2 {

        font-size: 25px;

    }

    .stats-grid {

        grid-template-columns:

            1fr

            1fr;

    }

    .section-heading {

        align-items: flex-start;

        flex-direction: column;

    }

    .approval-card {

        min-height: auto;

    }

    .approval-state {

        display: none;

    }

    .bottom-strip {

        padding:

            12px

            14px;

        align-items: flex-start;

        flex-direction: column;

    }

}

/* =========================================================
   DASHBOARD-MATCHED VISUAL SCALE
========================================================= */
html { font-size: 15px; }
body {
    font-family: Inter, "Segoe UI", Arial, sans-serif;
    font-size: 15px;
    background:
        radial-gradient(circle at 78% 3%, rgba(14,124,237,.11), transparent 28%),
        linear-gradient(145deg, #f5faff 0%, #eaf4ff 52%, #f8fbff 100%);
}
.app-shell { grid-template-columns: 238px minmax(0, 1fr); }
.sidebar {
    width: 238px;
    padding: 26px 20px;
    background: linear-gradient(180deg, #fff 0%, #f7fbff 67%, #edf6ff 100%);
    border-right: 1px solid #cfe1f5;
    box-shadow: 8px 0 30px rgba(27,80,138,.07);
}
.sidebar-brand { width: 100%; min-width: 0; gap: 11px; margin-bottom: 34px; }
.sidebar-brand > div:last-child { min-width: 0; max-width: calc(100% - 58px); overflow: hidden; }
.logo-wrap { width: 47px; height: 47px; min-width: 47px; border-radius: 10px; }
.logo-wrap img { width: 100%; height: 100%; left: 0; top: 0; object-fit: contain; }
.brand-name { font-size: 21px; }
.brand-tagline {
    width: 100%; max-width: 145px; margin-top: 3px;
    font-size: 7px; line-height: 1.25; letter-spacing: 0;
    white-space: normal; overflow-wrap: anywhere;
}
.nav-label { margin: 0 10px 10px; font-size: 10px; letter-spacing: 1.2px; }
.nav-list { gap: 7px; }
.nav-item { min-height: 45px; padding: 0 14px; gap: 10px; border-radius: 11px; font-size: 13px; }
.nav-item svg { width: 19px; height: 19px; }
.back-dashboard { min-height: 47px; padding: 0 14px; border-radius: 11px; font-size: 12px; }
.main { padding: 32px; }
.container { max-width: none; }
.topbar { margin-bottom: 25px; }
.page-eyebrow { font-size: 10px; letter-spacing: 1.1px; }
.topbar h1 { margin-top: 8px; font-size: 29px; }
.topbar p { margin-top: 6px; font-size: 14px; }
.dashboard-button { min-height: 45px; padding: 0 17px; border-radius: 11px; font-size: 12px; }
.hero {
    min-height: 245px; padding: 38px 42px; border-radius: 22px;
    background: linear-gradient(125deg, #075ecb, #1688ef 65%, #35a9ef);
    box-shadow: 0 18px 40px rgba(18,111,211,.18);
}
.hero-label { padding: 7px 11px; font-size: 10px; }
.hero h2 { margin-top: 18px; font-size: 34px; }
.hero p { margin-top: 12px; max-width: 880px; font-size: 14px; line-height: 1.65; }
.hero-mini { min-width: 260px; padding: 23px; border-radius: 16px; }
.hero-mini strong { font-size: 15px; }
.hero-mini span { margin-top: 8px; font-size: 11px; line-height: 1.5; }
.stats-grid { gap: 15px; margin: 22px 0 27px; }
.stat-card {
    min-height: 137px; padding: 20px; border-radius: 18px;
    box-shadow: 0 11px 30px rgba(24,65,112,.075);
}
.stat-label { font-size: 12px; }
.stat-icon { width: 39px; height: 39px; border-radius: 11px; }
.stat-icon svg { width: 20px; height: 20px; }
.stat-value { margin-top: 13px; font-size: 29px; }
.stat-note { margin-top: 8px; font-size: 11px; }
.section-heading { margin-bottom: 17px; }
.section-heading .eyebrow { font-size: 10px; letter-spacing: 1.1px; }
.section-heading h2 { margin-top: 7px; font-size: 27px; }
.section-heading p { margin-top: 7px; font-size: 13px; }
.total-pill { min-height: 30px; padding: 0 13px; font-size: 10px; }
.approval-grid { gap: 20px; }
.approval-card {
    min-height: 390px; padding: 24px; border-radius: 18px;
    box-shadow: 0 11px 31px rgba(27,65,107,.075);
}
.card-header { gap: 15px; }
.approval-number { width: 55px; height: 55px; border-radius: 14px; font-size: 18px; }
.approval-title h3 { font-size: 20px; }
.approval-code { margin-top: 6px; font-size: 10px; }
.approval-state { padding: 7px 11px; font-size: 9px; }
.badges { gap: 8px; margin-top: 18px; }
.badge { min-height: 27px; padding: 0 10px; font-size: 9px; }
.reason-box { margin-top: 18px; padding: 17px; border-radius: 13px; }
.reason-header { gap: 10px; }
.reason-icon { width: 34px; height: 34px; }
.reason-title { font-size: 12px; }
.reason-text { margin-top: 11px; font-size: 13px; line-height: 1.6; }
.card-footer { margin-top: 20px; padding-top: 18px; }
.view-button { min-height: 42px; padding: 0 16px; border-radius: 10px; font-size: 12px; }
.card-footer-note { font-size: 10px; }
.bottom-strip { margin-top: 22px; padding: 16px 19px; border-radius: 14px; }
.bottom-copy, .bottom-button { font-size: 12px; }
@media(max-width: 1180px) {
    .app-shell { grid-template-columns: 218px minmax(0,1fr); }
    .sidebar { width: 218px; }
    .approval-grid { grid-template-columns: 1fr; }
}
@media(max-width: 850px) {
    .app-shell { display: block; }
    .sidebar { position: static; width: 100%; height: auto; }
    .sidebar-brand > div:last-child, .nav-label, .nav-item span, .back-dashboard span { display: block; }
    .nav-list { display: grid; grid-template-columns: repeat(2,minmax(0,1fr)); }
    .nav-item, .back-dashboard { width: auto; margin: 0; justify-content: flex-start; }
    .main { padding: 22px 15px; }
}
@media(max-width: 620px) {
    .hero { padding: 25px 21px; }
    .hero h2 { font-size: 26px; }
    .stats-grid { grid-template-columns: 1fr; }
    .nav-list { grid-template-columns: 1fr; }
}
</style>

</head>

<body>



<div class="app-shell">



<!-- =========================================================

     SIDEBAR

========================================================= -->

<aside class="sidebar">



    <a

        href="<%= ctx %>/entrepreneur/dashboard"

        class="sidebar-brand">

        <div class="logo-wrap">

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



    <div class="nav-label">

        WORKSPACE

    </div>



    <nav class="nav-list">



        <a

            href="<%= ctx %>/entrepreneur/dashboard"

            class="nav-item">

            <svg viewBox="0 0 24 24"

                 fill="none">

                <path

                    d="M3 11L12 4L21 11V21H15V15H9V21H3V11Z"

                    stroke="currentColor"

                    stroke-width="2"

                    stroke-linejoin="round"/>

            </svg>

            <span>

                Dashboard

            </span>

        </a>



        <a

            href="<%= ctx %>/entrepreneur/business-onboarding"

            class="nav-item">

            <svg viewBox="0 0 24 24"

                 fill="none">

                <path

                    d="M4 21V8L12 3L20 8V21"

                    stroke="currentColor"

                    stroke-width="2"/>

                <path

                    d="M9 21V14H15V21"

                    stroke="currentColor"

                    stroke-width="2"/>

            </svg>

            <span>

                My Business

            </span>

        </a>



        <a

            href="<%= ctx %>/entrepreneur/generate-approvals"

            class="nav-item active">

            <svg viewBox="0 0 24 24"

                 fill="none">

                <circle

                    cx="5"

                    cy="6"

                    r="2"

                    stroke="currentColor"

                    stroke-width="2"/>

                <circle

                    cx="19"

                    cy="18"

                    r="2"

                    stroke="currentColor"

                    stroke-width="2"/>

                <path

                    d="M7 6H16C18 6 19 8 19 10V11M17 18H8C6 18 5 16 5 14V13"

                    stroke="currentColor"

                    stroke-width="2"/>

            </svg>

            <span>

                Approval Journey

            </span>

        </a>



        <a

            href="<%= ctx %>/entrepreneur/documents"

            class="nav-item">

            <svg viewBox="0 0 24 24"

                 fill="none">

                <path

                    d="M6 2H14L19 7V22H6Z"

                    stroke="currentColor"

                    stroke-width="2"/>

                <path

                    d="M14 2V7H19"

                    stroke="currentColor"

                    stroke-width="2"/>

            </svg>

            <span>

                Documents

            </span>

        </a>



        <a

            href="<%= ctx %>/entrepreneur/my-applications"

            class="nav-item">

            <svg viewBox="0 0 24 24"

                 fill="none">

                <rect

                    x="4"

                    y="3"

                    width="16"

                    height="18"

                    rx="2"

                    stroke="currentColor"

                    stroke-width="2"/>

                <path

                    d="M8 8H16M8 12H16M8 16H13"

                    stroke="currentColor"

                    stroke-width="2"/>

            </svg>

            <span>

                Applications

            </span>

        </a>



        <a

            href="<%= ctx %>/entrepreneur/inspections"

            class="nav-item">

            <svg viewBox="0 0 24 24"

                 fill="none">

                <rect

                    x="3"

                    y="5"

                    width="18"

                    height="16"

                    rx="2"

                    stroke="currentColor"

                    stroke-width="2"/>

                <path

                    d="M8 3V7M16 3V7M3 10H21"

                    stroke="currentColor"

                    stroke-width="2"/>

            </svg>

            <span>

                Inspections

            </span>

        </a>



        <a

            href="<%= ctx %>/entrepreneur/schemes"

            class="nav-item">

            <svg viewBox="0 0 24 24"

                 fill="none">

                <path

                    d="M12 3L20 7L12 11L4 7L12 3Z"

                    stroke="currentColor"

                    stroke-width="2"/>

            </svg>

            <span>

                Schemes

            </span>

        </a>



        <a

            href="<%= ctx %>/entrepreneur/compliance"

            class="nav-item">

            <svg viewBox="0 0 24 24"

                 fill="none">

                <path

                    d="M12 3L20 6V11C20 16 17 20 12 22C7 20 4 16 4 11V6L12 3Z"

                    stroke="currentColor"

                    stroke-width="2"/>

                <path

                    d="M8.5 12L11 14.5L16 9.5"

                    stroke="currentColor"

                    stroke-width="2"/>

            </svg>

            <span>

                Compliance

            </span>

        </a>



    </nav>



    <div class="sidebar-spacer"></div>



    <a

        href="<%= ctx %>/entrepreneur/dashboard"

        class="back-dashboard">

        <svg viewBox="0 0 24 24"

             fill="none"

             width="16"

             height="16">

            <path

                d="M19 12H5M10 7L5 12L10 17"

                stroke="currentColor"

                stroke-width="2"

                stroke-linecap="round"

                stroke-linejoin="round"/>

        </svg>

        <span>

            Back to Dashboard

        </span>

    </a>



</aside>



<!-- =========================================================

     MAIN CONTENT

========================================================= -->

<main class="main">

<div class="container">



<!-- =========================================================

     TOPBAR

========================================================= -->

<section class="topbar">



    <div class="topbar-left">

        <div class="page-eyebrow">

            ENTREPRENEUR / APPROVAL JOURNEY

        </div>

        <h1>

            Approval Roadmap

        </h1>

        <p>

            Your personalised regulatory journey based on

            your business profile.

        </p>

    </div>



    <a

        href="<%= ctx %>/entrepreneur/dashboard"

        class="dashboard-button">

        ← Dashboard

    </a>



</section>



<!-- =========================================================

     HERO

========================================================= -->

<section class="hero">



    <div class="hero-content">

        <div class="hero-label">

            ✦ PERSONALISED REGULATORY ROADMAP

        </div>

        <h2>

            Know exactly what your business needs.

        </h2>

        <p>

            CHAPERON analyses your business profile and

            organises applicable registrations, licences,

            NOCs and compliance requirements into one

            guided approval journey.

        </p>

    </div>



    <div class="hero-mini">

        <strong>

            Regulatory Guidance

        </strong>

        <span>

            Understand what is required, why it is

            applicable and what to do next.

        </span>

    </div>



</section>



<!-- =========================================================

     STATS

========================================================= -->

<section class="stats-grid">



    <div class="stat-card">

        <div class="stat-top">

            <div class="stat-label">

                Total Approvals

            </div>

            <div class="stat-icon">

                <svg viewBox="0 0 24 24"

                     fill="none">

                    <path

                        d="M5 12L10 17L20 7"

                        stroke="currentColor"

                        stroke-width="2"/>

                </svg>

            </div>

        </div>

        <div class="stat-value">

            <%= totalApprovals %>

        </div>

        <div class="stat-note">

            Identified for your business

        </div>

    </div>



    <div class="stat-card">

        <div class="stat-top">

            <div class="stat-label">

                Required

            </div>

            <div class="stat-icon">

                <svg viewBox="0 0 24 24"

                     fill="none">

                    <circle

                        cx="12"

                        cy="12"

                        r="9"

                        stroke="currentColor"

                        stroke-width="2"/>

                    <path

                        d="M12 7V13M12 17H12.01"

                        stroke="currentColor"

                        stroke-width="2"

                        stroke-linecap="round"/>

                </svg>

            </div>

        </div>

        <div class="stat-value">

            <%= requiredCount %>

        </div>

        <div class="stat-note">

            Mandatory regulatory needs

        </div>

    </div>



    <div class="stat-card">

        <div class="stat-top">

            <div class="stat-label">

                High Priority

            </div>

            <div class="stat-icon">

                <svg viewBox="0 0 24 24"

                     fill="none">

                    <path

                        d="M12 3L20 19H4L12 3Z"

                        stroke="currentColor"

                        stroke-width="2"/>

                    <path

                        d="M12 9V13M12 16H12.01"

                        stroke="currentColor"

                        stroke-width="2"/>

                </svg>

            </div>

        </div>

        <div class="stat-value">

            <%= highPriorityCount %>

        </div>

        <div class="stat-note">

            Should receive early attention

        </div>

    </div>



    <div class="stat-card">

        <div class="stat-top">

            <div class="stat-label">

                Not Started

            </div>

            <div class="stat-icon">

                <svg viewBox="0 0 24 24"

                     fill="none">

                    <circle

                        cx="12"

                        cy="12"

                        r="9"

                        stroke="currentColor"

                        stroke-width="2"/>

                    <path

                        d="M12 7V12L16 14"

                        stroke="currentColor"

                        stroke-width="2"

                        stroke-linecap="round"/>

                </svg>

            </div>

        </div>

        <div class="stat-value">

            <%= notStartedCount %>

        </div>

        <div class="stat-note">

            Approvals waiting to begin

        </div>

    </div>



</section>



<!-- =========================================================

     SECTION HEADING

========================================================= -->

<section class="section-heading">



    <div class="section-heading-left">

        <div class="eyebrow">

            RECOMMENDED FOR YOUR BUSINESS

        </div>

        <h2>

            Recommended Approvals

        </h2>

        <p>

            Review why each approval applies before

            starting your application.

        </p>

    </div>



    <div class="total-pill">

        <%= totalApprovals %>

        APPROVALS IDENTIFIED

    </div>



</section>



<!-- =========================================================

     APPROVALS

========================================================= -->

<%

    if (recommendations != null &&

        !recommendations.isEmpty()) {

%>

<section class="approval-grid">

<%

        int count = 1;

        for (BusinessApproval approvalRow

                : recommendations) {

            String requirementStatus =

                    approvalRow.getRequirementStatus();

            String priority =

                    approvalRow.getPriorityLevel();

            String currentStatus =

                    approvalRow.getCurrentStatus();

            String requirementClass =

                    "recommended";

            if ("REQUIRED".equalsIgnoreCase(

                    requirementStatus)) {

                requirementClass =

                        "required";

            } else if ("CONDITIONAL"

                    .equalsIgnoreCase(

                            requirementStatus)) {

                requirementClass =

                        "conditional";

            }

            String priorityClass =

                    "medium";

            if ("HIGH".equalsIgnoreCase(

                    priority)) {

                priorityClass =

                        "high";

            } else if ("LOW".equalsIgnoreCase(

                    priority)) {

                priorityClass =

                        "low";

            }

            String displayStatus =

                    "NOT STARTED";

            if (currentStatus != null &&

                !currentStatus.isBlank()) {

                displayStatus =

                        currentStatus.replace(

                                "_",

                                " "

                        );

            }

%>



<article class="approval-card">



    <!-- CARD HEADER -->

    <div class="card-header">



        <div class="approval-number">

            <%= count %>

        </div>



        <div class="approval-title">

            <h3>

                <%= approvalRow.getApprovalName() != null

                        ? approvalRow.getApprovalName()

                        : "Approval #"

                          + approvalRow.getApprovalId() %>

            </h3>



            <div class="approval-code">

                <%= approvalRow.getApprovalCode() != null

                        ? approvalRow.getApprovalCode()

                        : "Approval ID: "

                          + approvalRow.getApprovalId() %>

            </div>

        </div>



        <div class="approval-state">

            <%= displayStatus %>

        </div>



    </div>



    <!-- BADGES -->

    <div class="badges">



        <span class="badge <%= requirementClass %>">

            <%= requirementStatus != null

                    ? requirementStatus

                    : "RECOMMENDED" %>

        </span>



        <span class="badge <%= priorityClass %>">

            <%= priority != null

                    ? priority + " PRIORITY"

                    : "MEDIUM PRIORITY" %>

        </span>



        <span class="badge status">

            <%= displayStatus %>

        </span>



        <%

            if (approvalRow.isMandatory()) {

        %>

            <span class="badge mandatory">

                MANDATORY

            </span>

        <%

            }

        %>



    </div>



    <!-- REASON -->

    <div class="reason-box">



        <div class="reason-header">



            <div class="reason-icon">

                <svg viewBox="0 0 24 24"

                     fill="none">

                    <circle

                        cx="12"

                        cy="12"

                        r="9"

                        stroke="currentColor"

                        stroke-width="2"/>

                    <path

                        d="M12 11V16M12 8H12.01"

                        stroke="currentColor"

                        stroke-width="2"

                        stroke-linecap="round"/>

                </svg>

            </div>



            <div class="reason-title">

                Why is this recommended?

            </div>



        </div>



        <div class="reason-text">

            <%= approvalRow.getReasonText() != null

                    && !approvalRow.getReasonText().isBlank()

                    ? approvalRow.getReasonText()

                    : "This approval matches your business profile and configured regulatory rules." %>

        </div>



    </div>



    <!-- CARD FOOTER -->

    <div class="card-footer">



        <a

            href="<%= ctx %>/entrepreneur/approval-details?id=<%= approvalRow.getApprovalId() %>"

            class="view-button">

            View Details →

        </a>



        <div class="card-footer-note">

            REVIEW REQUIREMENTS

        </div>



    </div>



</article>



<%

            count++;

        }

%>

</section>

<%

    } else {

%>



<!-- =========================================================

     EMPTY STATE

========================================================= -->

<section class="empty-card">



    <div class="empty-icon">

        ✓

    </div>



    <h2>

        No matching approvals found

    </h2>



    <p>

        We could not find any active approval rules matching

        your current business profile. When applicable rules

        are configured or your business information changes,

        CHAPERON will automatically update this roadmap.

    </p>



</section>



<%

    }

%>



<!-- =========================================================

     BOTTOM STRIP

========================================================= -->

<section class="bottom-strip">



    <div class="bottom-copy">

        CHAPERON keeps your approval roadmap connected with

        document readiness, applications, inspections and

        future compliance.

    </div>



    <div style="display:flex; align-items:center; gap:14px; flex-wrap:wrap;">

        <a
            href="<%= ctx %>/entrepreneur/approval-journey"
            class="view-button">

            Journey Optimizer →

        </a>

        <a
            href="<%= ctx %>/entrepreneur/dashboard"
            class="bottom-button">

            Back to Dashboard →

        </a>

    </div>



</section>



</div>

</main>



</div>



</body>

</html>
