<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %><%@ page import="java.util.List" %><%@ page import="java.util.Map" %><%@ page import="com.chaperon.dto.ApplicationView" %><%@ page import="com.chaperon.model.Application" %><%@ page import="com.chaperon.model.NextAction" %><%
String ctx = request.getContextPath();
String userName =
(String) session.getAttribute("userName");
if (userName == null || userName.isBlank()) {
userName = "Entrepreneur";
}

// Dynamic Time Greeting Logic
java.time.LocalTime currentTime = java.time.LocalTime.now();
int hour = currentTime.getHour();
String timeGreeting = "Good Evening";
if (hour >= 5 && hour < 12) {
    timeGreeting = "Good Morning";
} else if (hour >= 12 && hour < 17) {
    timeGreeting = "Good Afternoon";
}

String avatarLetter =
userName.substring(0, 1).toUpperCase();
NextAction nextAction =
(NextAction)
request.getAttribute("nextAction");
String nextActionError =
(String)
request.getAttribute("nextActionError");
Integer recommendedApprovalsCount =
(Integer)
request.getAttribute(
"recommendedApprovalsCount"
);
Integer activeApplicationsCount =
(Integer)
request.getAttribute(
"activeApplicationsCount"
);
Integer pendingActionsCount =
(Integer)
request.getAttribute(
"pendingActionsCount"
);
Integer approvedLicencesCount =
(Integer)
request.getAttribute(
"approvedLicencesCount"
);
Integer draftApplicationsCount =
(Integer)
request.getAttribute(
"draftApplicationsCount"
);
Integer submittedApplicationsCount =
(Integer)
request.getAttribute(
"submittedApplicationsCount"
);
Integer underReviewApplicationsCount =
(Integer)
request.getAttribute(
"underReviewApplicationsCount"
);
Integer approvedApplicationsCount =
(Integer)
request.getAttribute(
"approvedApplicationsCount"
);
Integer rejectedApplicationsCount =
(Integer)
request.getAttribute(
"rejectedApplicationsCount"
);
Integer openQueriesCount =
(Integer)
request.getAttribute(
"openQueriesCount"
);
Integer scheduledInspectionsCount =
(Integer)
request.getAttribute(
"scheduledInspectionsCount"
);
Integer pendingRenewalsCount =
(Integer)
request.getAttribute(
"pendingRenewalsCount"
);
Integer documentIssuesCount =
(Integer)
request.getAttribute(
"documentIssuesCount"
);
recommendedApprovalsCount =
recommendedApprovalsCount == null
? 0
: recommendedApprovalsCount;
activeApplicationsCount =
activeApplicationsCount == null
? 0
: activeApplicationsCount;
pendingActionsCount =
pendingActionsCount == null
? 0
: pendingActionsCount;
approvedLicencesCount =
approvedLicencesCount == null
? 0
: approvedLicencesCount;
draftApplicationsCount =
draftApplicationsCount == null
? 0
: draftApplicationsCount;
submittedApplicationsCount =
submittedApplicationsCount == null
? 0
: submittedApplicationsCount;
underReviewApplicationsCount =
underReviewApplicationsCount == null
? 0
: underReviewApplicationsCount;
approvedApplicationsCount =
approvedApplicationsCount == null
? 0
: approvedApplicationsCount;
rejectedApplicationsCount =
rejectedApplicationsCount == null
? 0
: rejectedApplicationsCount;
openQueriesCount =
openQueriesCount == null
? 0
: openQueriesCount;
scheduledInspectionsCount =
scheduledInspectionsCount == null
? 0
: scheduledInspectionsCount;
pendingRenewalsCount =
pendingRenewalsCount == null
? 0
: pendingRenewalsCount;
documentIssuesCount =
documentIssuesCount == null
? 0
: documentIssuesCount;
String priorityClass = "priority-low";
if (nextAction != null) {
if ("HIGH".equalsIgnoreCase(
nextAction.getPriority())) {
priorityClass =
"priority-high";
} else if ("MEDIUM".equalsIgnoreCase(
nextAction.getPriority())) {
priorityClass =
"priority-medium";
}
}
/*
=========================================================
ACTIVE APPLICATION DATA
=========================================================
*/
@SuppressWarnings("unchecked")
List<ApplicationView> activeApplicationList =
(List<ApplicationView>)
request.getAttribute(
"activeApplicationList"
);
@SuppressWarnings("unchecked")
Map<Long, String> activeApplicationSlaStatus =
(Map<Long, String>)
request.getAttribute(
"activeApplicationSlaStatus"
);
@SuppressWarnings("unchecked")
Map<Long, String> activeApplicationSlaLabel =
(Map<Long, String>)
request.getAttribute(
"activeApplicationSlaLabel"
);
@SuppressWarnings("unchecked")
Map<Long, String> activeApplicationSlaMessage =
(Map<Long, String>)
request.getAttribute(
"activeApplicationSlaMessage"
);
@SuppressWarnings("unchecked")
Map<Long, Integer> activeApplicationSlaProgress =
(Map<Long, Integer>)
request.getAttribute(
"activeApplicationSlaProgress"
);
@SuppressWarnings("unchecked")
Map<Long, Long> activeApplicationSlaDaysRemaining =
(Map<Long, Long>)
request.getAttribute(
"activeApplicationSlaDaysRemaining"
);
%><!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport"
content="width=device-width, initial-scale=1.0"><title>
Entrepreneur Dashboard | CHAPERON
</title><link rel="stylesheet"
 href="<%= ctx %>/assets/css/entrepreneur-enhancements.css"><style> *{margin:0;padding:0;box-sizing:border-box;}:root{--blue:#0962e8;--blue-dark:#0646b5;--blue-soft:#edf5ff;--cyan:#27b5ed;--navy:#102446;--text:#263954;--muted:#7b8ca5;--green:#149a61;--green-soft:#e9f8f1;--orange:#e58b29;--orange-soft:#fff3e5;--purple:#7458d9;--purple-soft:#f0edff;--red:#d94c4c;--red-soft:#fff0f0;--border:#e4ebf5;--bg:#f2f6fc;--white:#ffffff;--shadow:0 10px 30px rgba(35,66,111,0.07);--shadow-hover:0 16px 38px rgba(35,66,111,0.12);}html{scroll-behavior:smooth;}body{min-height:100vh;font-family:"Segoe UI",Arial,Helvetica,sans-serif;color:var(--text);background:radial-gradient( circle at 90% 4%,rgba(39,181,237,0.08),transparent 22% ),var(--bg);}a{color:inherit;text-decoration:none;}.app-shell{min-height:100vh;display:grid;grid-template-columns:235px minmax(0,1fr);}.sidebar{position:sticky;top:0;height:100vh;padding:25px 18px 19px;display:flex;flex-direction:column;border-right:1px solid #e1e9f4;background:rgba( 255,255,255,0.96 );backdrop-filter:blur(16px);}.sidebar-brand{margin-bottom:27px;padding:0 8px;display:flex;align-items:center;gap:9px;}.logo-wrap{position:relative;width:43px;height:43px;min-width:43px;overflow:hidden;border-radius:50%;background:white;}.logo-wrap img{position:absolute;width:80px;height:80px;max-width:none;left:-18px;top:-6px;object-fit:cover;}.brand-title{color:#1053c4;font-size:18px;font-weight:900;line-height:1;}.brand-subtitle{margin-top:4px;color:#667c9c;font-size:6px;font-weight:800;letter-spacing:.2px;white-space:nowrap;}.nav-label{margin:0 10px 8px;color:#9aa8ba;font-size:7px;font-weight:900;letter-spacing:1px;}.nav-list{display:flex;flex-direction:column;gap:5px;}.nav-item{min-height:42px;padding:0 11px;display:flex;align-items:center;gap:10px;border-radius:11px;color:#526783;font-size:10px;font-weight:750;transition:.2s ease;}.nav-item svg{width:18px;height:18px;min-width:18px;}.nav-item:hover{color:var(--blue);background:#f0f6ff;transform:translateX(2px);}.nav-item.active{color:white;background:linear-gradient( 135deg,#0962e8,#268de9 );box-shadow:0 9px 19px rgba(9,98,232,0.18);}.sidebar-spacer{flex:1;}.sidebar-profile{margin-top:19px;padding:13px;border:1px solid #e1e9f4;border-radius:14px;background:linear-gradient( 145deg,#ffffff,#f6f9fd );}.sidebar-user{display:flex;align-items:center;gap:9px;}.sidebar-avatar{width:37px;height:37px;min-width:37px;display:flex;align-items:center;justify-content:center;border-radius:50%;color:white;background:linear-gradient( 135deg,#0962e9,#68a2ff );font-size:12px;font-weight:900;}.sidebar-user strong{display:block;max-width:120px;overflow:hidden;color:#1e3558;font-size:10px;white-space:nowrap;text-overflow:ellipsis;}.sidebar-user span{display:block;margin-top:2px;color:#8998ac;font-size:8px;}.sidebar-bottom-links{margin-top:11px;padding-top:10px;display:flex;justify-content:space-between;border-top:1px solid #e8eef6;}.sidebar-bottom-links a{color:#6b7e98;font-size:8px;font-weight:800;}.sidebar-bottom-links a:hover{color:var(--blue);}.sidebar-bottom-links .logout-link{color:#c24949;}.main{min-width:0;padding:25px 28px 40px;}.topbar{margin-bottom:22px;display:flex;align-items:center;justify-content:space-between;gap:20px;}.welcome h1{color:#152b4d;font-size:24px;font-weight:800;}.welcome h1 span{color:var(--blue);}.welcome p{margin-top:4px;color:#8796aa;font-size:9px;}.top-actions{display:flex;align-items:center;gap:8px;}.top-icon{width:39px;height:39px;display:flex;align-items:center;justify-content:center;border:1px solid #e1e8f3;border-radius:50%;color:#435a78;background:white;box-shadow:0 5px 15px rgba(36,67,110,0.05);transition:.2s ease;}.top-icon:hover{color:var(--blue);transform:translateY(-2px);}.top-icon svg{width:17px;height:17px;}.top-profile{min-height:39px;padding:0 12px;display:flex;align-items:center;gap:7px;border:1px solid #dce7f5;border-radius:50px;background:white;color:#425d7e;font-size:9px;font-weight:800;}.summary-grid{margin-bottom:17px;display:grid;grid-template-columns:repeat( 4,minmax(0,1fr) );gap:13px;}.summary-card{position:relative;overflow:hidden;min-height:118px;padding:18px;border:1px solid #e4ebf4;border-radius:17px;background:white;box-shadow:var(--shadow);transition:.22s ease;}.summary-card:hover{transform:translateY(-3px);box-shadow:var(--shadow-hover);}.summary-card::after{content:"";position:absolute;width:75px;height:75px;right:-35px;bottom:-40px;border-radius:50%;background:rgba(9,98,232,.04);}.summary-top{display:flex;align-items:center;justify-content:space-between;gap:10px;}.summary-label{color:#6e819b;font-size:9px;font-weight:750;}.summary-icon{width:31px;height:31px;display:flex;align-items:center;justify-content:center;border-radius:9px;}.summary-icon svg{width:16px;height:16px;}.summary-number{margin-top:12px;color:#132849;font-size:27px;font-weight:800;line-height:1;}.summary-note{margin-top:7px;color:#8a98aa;font-size:7px;}.blue-box{color:#0962e8;background:#edf5ff;}.purple-box{color:#7458d9;background:#f0edff;}.orange-box{color:#e58b29;background:#fff3e5;}.green-box{color:#15975f;background:#e9f8f1;}.dashboard-layout{display:grid;grid-template-columns:minmax(0,1.45fr) minmax(310px,.75fr);gap:16px;}.left-column,.right-column{min-width:0;display:flex;flex-direction:column;gap:16px;}.panel{border:1px solid #e3eaf4;border-radius:18px;background:white;box-shadow:var(--shadow);}.panel-header{padding:17px 19px 0;display:flex;align-items:center;justify-content:space-between;gap:15px;}.panel-title{color:#162d4f;font-size:13px;font-weight:850;}.panel-subtitle{margin-top:3px;color:#8a99ac;font-size:8px;}.panel-link{color:var(--blue);font-size:8px;font-weight:850;}.next-panel{position:relative;overflow:hidden;min-height:210px;padding:22px;display:flex;align-items:center;border:1px solid #cfe0f8;border-radius:19px;background:radial-gradient( circle at 93% 12%,rgba(39,181,237,.16),transparent 27% ),linear-gradient( 135deg,#ffffff,#f4f9ff );box-shadow:var(--shadow);}.next-panel::after{content:"";position:absolute;width:170px;height:170px;right:-75px;bottom:-105px;border-radius:50%;background:rgba(9,98,232,.055);}.next-content{position:relative;z-index:2;width:100%;}.next-eyebrow{width:max-content;margin-bottom:8px;padding:5px 9px;border-radius:50px;color:#0759d3;background:#e8f3ff;font-size:7px;font-weight:900;letter-spacing:.8px;}.next-title{max-width:650px;color:#102648;font-size:20px;font-weight:900;line-height:1.25;}.next-description{max-width:700px;margin-top:8px;color:#6c809e;font-size:10px;line-height:1.65;}.next-bottom{margin-top:17px;display:flex;align-items:center;justify-content:space-between;gap:15px;}.next-meta{display:flex;align-items:center;gap:6px;flex-wrap:wrap;}.badge{min-height:23px;padding:0 8px;display:inline-flex;align-items:center;border-radius:6px;font-size:7px;font-weight:900;}.priority-high{color:#b53a3a;background:#fff0f0;}.priority-medium{color:#ba711c;background:#fff3e4;}.priority-low{color:#11784c;background:#e9f8f1;}.action-badge{color:#4a678b;background:#edf3fa;}.next-button{min-height:41px;padding:0 15px;display:inline-flex;align-items:center;justify-content:center;border-radius:9px;color:white;background:linear-gradient( 135deg,#0962e8,#0750c5 );box-shadow:0 8px 18px rgba(9,98,232,.20);font-size:8px;font-weight:900;white-space:nowrap;}.next-error{color:#a84848;font-size:10px;}.active-tracker-count{display:inline-flex;align-items:center;justify-content:center;min-width:74px;padding:6px 10px;border-radius:999px;color:#0962e8;background:#edf5ff;font-size:8px;font-weight:900;}.active-app-body{padding:17px 19px 20px;}.active-app-list{display:grid;gap:10px;}.active-app-card{display:grid;grid-template-columns:minmax(0,1fr) auto;align-items:center;gap:14px;padding:14px;border:1px solid #e5ebf4;border-radius:13px;background:linear-gradient( 145deg,#ffffff,#f9fbff );transition:.2s ease;}.active-app-card:hover{transform:translateY(-2px);border-color:#c9dcf5;box-shadow:0 9px 20px rgba(35,66,111,.07);}.active-app-name{color:#223b5f;font-size:10px;font-weight:900;}.active-app-number{margin-top:3px;color:#8a98aa;font-size:7px;font-weight:700;word-break:break-word;}.active-app-meta{margin-top:9px;display:flex;align-items:center;gap:6px;flex-wrap:wrap;}.active-status-badge,.active-sla-badge{min-height:22px;padding:0 8px;display:inline-flex;align-items:center;border-radius:7px;font-size:7px;font-weight:900;text-transform:uppercase;}.active-status-badge{color:#4a678b;background:#edf3fa;}.active-sla-on-track{color:#11784c;background:#e9f8f1;}.active-sla-near{color:#ba711c;background:#fff3e4;}.active-sla-breached{color:#b53a3a;background:#fff0f0;}.active-sla-not-started{color:#667c9c;background:#eef2f7;}.active-sla-completed{color:#11784c;background:#e9f8f1;}.active-days{color:#8090a5;font-size:7px;font-weight:750;}.active-app-progress{margin-top:9px;max-width:420px;height:5px;overflow:hidden;border-radius:999px;background:#e8eef6;}.active-app-progress-fill{height:100%;border-radius:999px;background:linear-gradient( 90deg,#0962e8,#27b5ed );}.active-track-button{min-height:35px;padding:0 13px;display:inline-flex;align-items:center;justify-content:center;border-radius:9px;color:white;background:linear-gradient( 135deg,#0962e8,#0750c5 );box-shadow:0 7px 15px rgba(9,98,232,.18);font-size:8px;font-weight:900;white-space:nowrap;}.active-track-button:hover{transform:translateY(-1px);}.active-empty{padding:22px;border:1px dashed #d5dfeb;border-radius:12px;color:#7f8fa4;background:#fafcff;font-size:9px;line-height:1.6;text-align:center;}.status-body{padding:18px 19px 20px;}.status-list{display:grid;grid-template-columns:repeat( 5,minmax(0,1fr) );gap:8px;}.status-item{padding:12px 8px;border:1px solid #e6ecf4;border-radius:11px;background:#f8fafd;text-align:center;}.status-count{color:#182f50;font-size:18px;font-weight:850;}.status-name{margin-top:4px;color:#7c8da4;font-size:7px;font-weight:750;}.workspace-body{padding:16px 19px 20px;}.workspace-grid{display:grid;grid-template-columns:repeat( 4,minmax(0,1fr) );gap:9px;}.workspace-item{min-height:100px;padding:13px;display:flex;flex-direction:column;border:1px solid #e5ebf4;border-radius:12px;background:linear-gradient( 145deg,#ffffff,#fafcff );transition:.2s ease;}.workspace-item:hover{transform:translateY(-3px);border-color:#cdddf2;box-shadow:0 9px 20px rgba(35,66,111,.07);}.workspace-icon{width:31px;height:31px;margin-bottom:9px;display:flex;align-items:center;justify-content:center;border-radius:9px;color:#0962e8;background:#edf5ff;}.workspace-icon svg{width:16px;height:16px;}.workspace-item strong{color:#243c5d;font-size:9px;}.workspace-item span{margin-top:3px;color:#8a98aa;font-size:7px;}.pending-body{padding:17px 18px 19px;}.pending-row{min-height:51px;padding:9px 0;display:flex;align-items:center;justify-content:space-between;gap:10px;border-bottom:1px solid #edf1f6;}.pending-row:last-child{border-bottom:0;}.pending-left{display:flex;align-items:center;gap:10px;}.pending-icon{width:33px;height:33px;min-width:33px;display:flex;align-items:center;justify-content:center;border-radius:9px;}.pending-icon svg{width:16px;height:16px;}.pending-info strong{display:block;color:#293f5e;font-size:9px;}.pending-info span{display:block;margin-top:2px;color:#93a0b0;font-size:7px;}.pending-count{min-width:27px;height:27px;display:flex;align-items:center;justify-content:center;border-radius:8px;color:#324e72;background:#f0f4fa;font-size:9px;font-weight:900;}.journey-body{padding:17px 18px 20px;}.journey-list{position:relative;}.journey-row{position:relative;min-height:51px;padding-left:35px;display:flex;align-items:center;}.journey-row:not(:last-child)::after{content:"";position:absolute;left:12px;top:31px;width:1px;height:27px;background:#d9e4f2;}.journey-dot{position:absolute;left:2px;width:21px;height:21px;display:flex;align-items:center;justify-content:center;border-radius:50%;color:#0962e8;background:#edf5ff;border:1px solid #cfe0f6;font-size:7px;font-weight:900;}.journey-info strong{display:block;color:#293f5e;font-size:9px;}.journey-info span{display:block;margin-top:2px;color:#91a0b1;font-size:7px;}.security-strip{margin-top:16px;min-height:47px;padding:0 16px;display:flex;align-items:center;justify-content:center;gap:7px;border-radius:12px;color:#6f829c;background:#eaf0f7;font-size:7px;text-align:center;}.security-strip svg{width:14px;height:14px;color:#3f638f;}@media(max-width:1150px){.summary-grid{grid-template-columns:repeat( 2,minmax(0,1fr) );}.dashboard-layout{grid-template-columns:1fr;}.workspace-grid{grid-template-columns:repeat( 2,minmax(0,1fr) );}}@media(max-width:850px){.app-shell{grid-template-columns:75px minmax(0,1fr);}.sidebar{padding:20px 10px;}.sidebar-brand{padding:0;justify-content:center;}.sidebar-brand>div:last-child,.nav-label,.nav-item span,.sidebar-profile{display:none;}.nav-item{width:45px;margin:auto;padding:0;justify-content:center;}.main{padding:20px 18px 35px;}}@media(max-width:620px){.app-shell{display:block;}.sidebar{position:static;width:100%;height:auto;padding:10px 12px;flex-direction:row;align-items:center;overflow-x:auto;}.sidebar-brand{margin:0 15px 0 0;}.nav-list{flex-direction:row;gap:5px;}.sidebar-spacer{display:none;}.topbar{align-items:flex-start;flex-direction:column;}.top-actions{width:100%;justify-content:flex-end;}.summary-grid{grid-template-columns:1fr 1fr;}.workspace-grid{grid-template-columns:1fr;}.status-list{grid-template-columns:repeat( 2,minmax(0,1fr) );}.next-bottom{align-items:flex-start;flex-direction:column;}.next-button{width:100%;}.active-app-card{grid-template-columns:1fr;}.active-track-button{width:100%;}.main{padding:17px 12px 30px;}}html{font-size:16px;}body{background:radial-gradient(circle at 92% 8%,rgba(42,145,239,.10),transparent 28%),linear-gradient(135deg,#f7faff 0%,#edf4fd 100%);color:#102746;font-size:15px;}.app-shell{grid-template-columns:255px minmax(0,1fr);}.sidebar{width:255px;padding:25px 18px 20px;border-right:1px solid #dce7f4;box-shadow:8px 0 32px rgba(32,74,123,.055);}.sidebar-brand{gap:12px;margin-bottom:31px;}.logo-wrap{width:48px;height:48px;}.logo-wrap img{width:100%;height:100%;object-fit:contain;}.brand-title{font-size:21px;line-height:1.1;letter-spacing:-.35px;}.brand-subtitle{margin-top:4px;font-size:8px;line-height:1.35;letter-spacing:.15px;}.nav-label{margin:0 11px 11px;font-size:10px;letter-spacing:1.25px;}.nav-list{gap:7px;}.nav-item{min-height:47px;padding:0 14px;gap:12px;border-radius:12px;font-size:13px;font-weight:750;transition:transform .2s ease,background .2s ease,box-shadow .2s ease;}.nav-item svg{width:20px;height:20px;}.nav-item:hover{transform:translateX(3px);background:#edf5ff;}.nav-item.active{box-shadow:0 10px 22px rgba(20,120,238,.25);}.sidebar-profile{padding:14px;border-radius:15px;}.sidebar-avatar{width:42px;height:42px;font-size:15px;}.sidebar-user strong{font-size:13px;}.sidebar-user span,.sidebar-bottom-links a{font-size:11px;}.main{padding:29px 30px 42px;}.topbar{min-height:66px;margin-bottom:22px;}.welcome h1{font-size:28px;letter-spacing:-.55px;}.welcome p{margin-top:6px;font-size:13px;line-height:1.55;}.top-icon{width:44px;height:44px;}.top-profile{min-height:44px;padding:0 15px;font-size:13px;}.summary-grid{gap:17px;margin-bottom:20px;}.summary-card{min-height:145px;padding:22px;border:1px solid #dfe8f4;border-radius:18px;box-shadow:0 11px 30px rgba(24,65,112,.075);transition:transform .22s ease,box-shadow .22s ease,border-color .22s ease;}.summary-card:hover{transform:translateY(-5px);border-color:#bfd9f6;box-shadow:0 18px 38px rgba(16,77,143,.13);}.summary-label{font-size:12px;letter-spacing:.15px;}.summary-icon{width:39px;height:39px;border-radius:11px;}.summary-icon svg{width:20px;height:20px;}.summary-number{margin-top:14px;font-size:31px;line-height:1;}.summary-note{margin-top:10px;font-size:11px;line-height:1.45;}.dashboard-layout{gap:21px;}.left-column,.right-column{gap:20px;}.panel,.next-panel{border:1px solid #dce7f3;border-radius:19px;box-shadow:0 11px 31px rgba(27,65,107,.075);}.panel-header{padding:21px 23px;}.panel-title{font-size:19px;letter-spacing:-.2px;}.panel-subtitle{margin-top:5px;font-size:12px;line-height:1.45;}.panel-link{font-size:12px;}.next-panel{min-height:225px;padding:27px;background:radial-gradient(circle at 94% 100%,rgba(44,151,240,.16),transparent 34%),linear-gradient(135deg,#ffffff,#eff7ff);}.next-eyebrow{padding:7px 11px;font-size:10px;letter-spacing:.7px;}.next-title{margin-top:13px;font-size:25px;line-height:1.25;}.next-description{margin-top:10px;font-size:14px;line-height:1.65;}.badge{min-height:27px;padding:0 10px;font-size:10px;}.next-button{min-height:44px;padding:0 18px;border-radius:10px;font-size:13px;}.active-app-body,.status-body,.workspace-body,.pending-body,.journey-body{padding:20px;}.active-app-card{padding:17px;border-radius:13px;}.active-app-name{font-size:15px;}.active-app-number,.active-app-meta,.active-days{font-size:11px;}.active-status-badge,.active-sla-badge{font-size:10px;}.active-track-button{min-height:42px;padding:0 17px;font-size:12px;border-radius:10px;}.status-list{gap:12px;}.status-item{min-height:91px;padding:16px 12px;border-radius:13px;}.status-count{font-size:25px;}.status-name{margin-top:7px;font-size:11px;}.workspace-grid{gap:14px;}.workspace-item{min-height:125px;padding:18px;border:1px solid #dce7f4;border-radius:15px;background:linear-gradient(145deg,#ffffff,#f8fbff);box-shadow:0 7px 20px rgba(27,67,111,.055);transition:transform .22s ease,box-shadow .22s ease,border-color .22s ease;}.workspace-item:hover{transform:translateY(-4px);border-color:#acd0f6;box-shadow:0 14px 29px rgba(14,93,175,.13);}.workspace-icon{width:42px;height:42px;border-radius:11px;}.workspace-icon svg{width:22px;height:22px;}.workspace-item strong{margin-top:12px;font-size:14px;}.workspace-item>span:not(.smart-feature-arrow),.workspace-item .smart-feature-copy>span{font-size:11px;line-height:1.45;}.smart-feature-card{position:relative;overflow:hidden;min-height:148px;border-width:1px;}.smart-feature-card::after{content:"";position:absolute;width:105px;height:105px;right:-35px;bottom:-42px;border-radius:50%;background:currentColor;opacity:.055;}.incentive-card{color:#075fc9;background:linear-gradient(145deg,#fff,#eef6ff);}.ecosync-card{color:#0b8065;background:linear-gradient(145deg,#fff,#ebfaf5);}.smart-feature-copy{display:flex;flex-direction:column;align-items:flex-start;}.smart-feature-label{margin-top:10px;font-size:9px !important;font-weight:900;letter-spacing:.65px;}.smart-feature-copy strong{color:#102746;font-size:16px;}.smart-feature-arrow{margin-top:13px;font-size:11px;font-weight:900;}.pending-row{padding:15px 0;}.pending-title{font-size:13px;}.pending-subtitle,.pending-count{font-size:11px;}.journey-row{min-height:55px;}.journey-dot{width:28px;height:28px;font-size:11px;}.journey-info strong{font-size:12px;}.journey-info span{font-size:10px;line-height:1.4;}.security-strip{margin-top:21px;padding:16px 19px;border-radius:14px;font-size:12px;line-height:1.55;}@media (max-width:1180px){.app-shell{grid-template-columns:225px minmax(0,1fr);}.sidebar{width:225px;}.main{padding:24px 20px 36px;}.summary-grid{grid-template-columns:repeat(2,minmax(0,1fr));}}@media (max-width:850px){.app-shell{display:block;}.sidebar{position:relative;width:100%;height:auto;}.nav-list{grid-template-columns:repeat(2,minmax(0,1fr));}.dashboard-layout{grid-template-columns:1fr;}}body{background:radial-gradient(circle at 78% 3%,rgba(14,124,237,.11),transparent 28%),linear-gradient(145deg,#f5faff 0%,#eaf4ff 52%,#f8fbff 100%);}.app-shell{grid-template-columns:224px minmax(0,1fr);}.sidebar{width:224px;padding:22px 15px 18px;background:linear-gradient(180deg,#ffffff 0%,#f7fbff 66%,#e9f5ff 100%);border-right:1px solid #cfe1f5;box-shadow:8px 0 30px rgba(27,80,138,.075);}.sidebar::after{content:"";position:absolute;left:-90px;bottom:90px;width:260px;height:260px;border-radius:50%;background:rgba(31,143,239,.06);pointer-events:none;}.sidebar-brand{padding:2px 7px 0;}.logo-wrap{width:48px;height:48px;}.brand-title{color:#075dbd;font-size:20px;}.nav-item{min-height:42px;font-size:12px;}.nav-item.active{color:#fff;background:linear-gradient(135deg,#0969de,#1599f0);box-shadow:0 9px 20px rgba(11,112,222,.28);}.sidebar-profile{position:relative;z-index:1;background:rgba(255,255,255,.92);box-shadow:0 8px 23px rgba(30,80,130,.09);}.main{padding:20px 22px 32px;}.topbar{min-height:52px;margin-bottom:16px;padding:0;background:transparent;}.dashboard-search{width:min(590px,62%);height:44px;display:flex;overflow:hidden;border:1px solid #cfe1f4;border-radius:12px;background:rgba(255,255,255,.88);box-shadow:0 7px 20px rgba(27,74,126,.07);}.dashboard-search input{min-width:0;flex:1;border:0;outline:0;padding:0 16px;color:#18395f;background:transparent;font:500 13px/1 "Segoe UI",Arial,sans-serif;}.dashboard-search input::placeholder{color:#8295ad;}.dashboard-search button{width:50px;border:0;display:grid;place-items:center;color:#fff;cursor:pointer;background:linear-gradient(135deg,#0969de,#03468f);}.dashboard-search button svg{width:20px;height:20px;}.top-actions{margin-left:auto;}.top-icon,.top-profile{border:1px solid #d5e5f5;background:rgba(255,255,255,.9);box-shadow:0 6px 18px rgba(26,72,122,.06);}.dashboard-greeting{min-height:92px;margin-bottom:16px;padding:17px 20px;display:flex;align-items:center;justify-content:space-between;gap:24px;border:1px solid rgba(182,217,247,.9);border-radius:17px;background:radial-gradient(circle at 3% 50%,rgba(255,184,33,.16),transparent 12%),linear-gradient(105deg,rgba(255,255,255,.96),rgba(228,244,255,.92));box-shadow:0 9px 26px rgba(31,80,130,.065);}.greeting-kicker{color:#0b70dd;font-size:9px;font-weight:900;letter-spacing:1px;}.dashboard-greeting h1{margin:6px 0 4px;color:#102d52;font-size:25px;line-height:1.15;letter-spacing:-.5px;}.dashboard-greeting p{margin:0;color:#657f9f;font-size:12px;}.dashboard-greeting blockquote{margin:0;color:#14365f;font-size:14px;font-weight:800;font-style:italic;text-align:right;}.dashboard-greeting blockquote small{display:block;margin-top:6px;color:#5d7899;font-size:10px;font-style:normal;}.summary-grid{grid-template-columns:repeat(4,minmax(0,1fr));gap:12px;margin-bottom:15px;}.summary-card{min-height:116px;padding:15px;border-color:#d6e6f5;border-radius:14px;background:rgba(255,255,255,.9);box-shadow:0 8px 22px rgba(27,73,120,.065);}.summary-card:nth-child(1){background:linear-gradient(145deg,#fff,#eaf4ff);}.summary-card:nth-child(2){background:linear-gradient(145deg,#fff,#f4ecff);}.summary-card:nth-child(3){background:linear-gradient(145deg,#fff,#e8f9ee);}.summary-card:nth-child(4){background:linear-gradient(145deg,#fff,#fff1e4);}.summary-label{max-width:120px;color:#425d7d;font-size:10px;line-height:1.35;}.summary-icon{width:35px;height:35px;}.summary-number{margin-top:8px;color:#0a2548;font-size:26px;}.summary-note{margin-top:6px;font-size:9px;}.dashboard-layout{grid-template-columns:minmax(0,2.1fr) minmax(280px,.85fr);gap:15px;}.left-column,.right-column{gap:14px;}.panel,.next-panel{border-color:#d5e5f4;border-radius:15px;background:rgba(255,255,255,.93);box-shadow:0 8px 24px rgba(28,73,120,.065);}.panel-header{padding:15px 17px;}.panel-title{color:#122f54;font-size:15px;}.panel-subtitle{font-size:9px;}.next-panel{min-height:180px;padding:21px;background:radial-gradient(circle at 91% 50%,rgba(33,155,239,.18),transparent 24%),linear-gradient(125deg,#ffffff 0%,#e9f5ff 100%);}.next-panel::after{content:"✓";position:absolute;right:42px;bottom:27px;width:58px;height:58px;display:grid;place-items:center;border-radius:17px;color:#fff;background:linear-gradient(145deg,#16a9ef,#075ed6);box-shadow:0 12px 24px rgba(8,99,207,.24);font-size:27px;font-weight:900;transform:rotate(-7deg);}.next-title{max-width:70%;font-size:21px;}.next-description{max-width:70%;font-size:11px;}.next-bottom{max-width:70%;}.active-app-body,.status-body,.workspace-body,.pending-body,.journey-body{padding:14px;}.active-app-list{gap:9px;}.active-app-card{padding:13px;border-color:#d9e7f4;border-radius:12px;background:#fbfdff;}.active-app-name{font-size:12px;}.active-app-number,.active-app-meta,.active-days{font-size:9px;}.active-track-button{min-height:36px;border-radius:9px;background:linear-gradient(135deg,#0871e8,#079fec);box-shadow:0 7px 15px rgba(6,112,221,.2);}.pending-row{padding:11px 0;}.pending-icon{width:34px;height:34px;}.pending-title{font-size:10px;}.pending-subtitle,.pending-count{font-size:8px;}.journey-row{min-height:44px;}.journey-dot{width:23px;height:23px;}.journey-info strong{font-size:10px;}.journey-info span{font-size:8px;}.status-item{background:linear-gradient(145deg,#f9fcff,#eef6ff);}.workspace-grid{grid-template-columns:repeat(3,minmax(0,1fr));gap:10px;}.workspace-item{min-height:100px;padding:13px;}.workspace-item strong{font-size:11px;}.smart-feature-card{min-height:112px;}.security-strip{background:linear-gradient(90deg,#e9f5ff,#dcefff);border-color:#bfdcf7;}@media (max-width:1120px){.dashboard-layout{grid-template-columns:1fr;}.summary-grid{grid-template-columns:repeat(2,minmax(0,1fr));}}@media (max-width:850px){.dashboard-search{width:calc(100% - 120px);}.dashboard-greeting{align-items:flex-start;flex-direction:column;}.dashboard-greeting blockquote{text-align:left;}}@media (max-width:600px){.summary-grid,.workspace-grid{grid-template-columns:1fr;}.dashboard-search{width:100%;}.top-profile{display:none;}.dashboard-greeting h1{font-size:21px;}.next-panel::after{display:none;}.next-title,.next-description,.next-bottom{max-width:100%;}}html{font-size:14px;}body{font-size:12px;}.app-shell{grid-template-columns:205px minmax(0,1fr);}.sidebar{width:205px;padding:17px 12px 14px;}.sidebar-brand{margin-bottom:20px;padding:1px 5px 0;gap:8px;}.logo-wrap{width:40px;height:40px;}.brand-title{font-size:17px;}.brand-subtitle{margin-top:2px;font-size:6px;}.nav-label{margin:0 8px 7px;font-size:8px;}.nav-list{gap:4px;}.nav-item{min-height:37px;padding:0 10px;gap:8px;border-radius:9px;font-size:10px;}.nav-item svg{width:16px;height:16px;}.sidebar-profile{padding:10px;border-radius:12px;}.sidebar-avatar{width:33px;height:33px;font-size:11px;}.sidebar-user strong{font-size:10px;}.sidebar-user span,.sidebar-bottom-links a{font-size:8px;}.sidebar-bottom-links{margin-top:9px;padding-top:8px;}.main{padding:14px 16px 25px;}.topbar{min-height:44px;margin-bottom:11px;}.dashboard-search{width:min(520px,62%);height:38px;border-radius:10px;}.dashboard-search input{padding:0 13px;font-size:11px;}.dashboard-search button{width:44px;}.dashboard-search button svg{width:17px;height:17px;}.top-actions{gap:8px;}.top-icon{width:36px;height:36px;}.top-icon svg{width:17px;height:17px;}.top-profile{min-height:36px;padding:0 11px;font-size:10px;}.dashboard-greeting{min-height:76px;margin-bottom:11px;padding:12px 15px;border-radius:13px;}.greeting-kicker{font-size:7px;letter-spacing:.8px;}.dashboard-greeting h1{margin:4px 0 3px;font-size:20px;}.dashboard-greeting p{font-size:10px;}.dashboard-greeting blockquote{font-size:11px;}.dashboard-greeting blockquote small{margin-top:4px;font-size:8px;}.summary-grid{gap:9px;margin-bottom:11px;}.summary-card{min-height:96px;padding:11px;border-radius:11px;}.summary-label{max-width:105px;font-size:8px;}.summary-icon{width:29px;height:29px;border-radius:8px;}.summary-icon svg{width:15px;height:15px;}.summary-number{margin-top:6px;font-size:21px;}.summary-note{margin-top:4px;font-size:7px;}.dashboard-layout{grid-template-columns:minmax(0,2.15fr) minmax(245px,.82fr);gap:11px;}.left-column,.right-column{gap:10px;}.panel,.next-panel{border-radius:12px;}.panel-header{padding:12px 14px;}.panel-title{font-size:13px;}.panel-subtitle{margin-top:3px;font-size:8px;}.panel-link{font-size:8px;}.next-panel{min-height:145px;padding:16px;}.next-eyebrow{padding:4px 7px;font-size:7px;}.next-title{margin-top:8px;font-size:17px;}.next-description{margin-top:6px;font-size:9px;line-height:1.5;}.next-bottom{margin-top:11px;}.badge{min-height:20px;padding:0 7px;font-size:7px;}.next-button{min-height:33px;padding:0 11px;border-radius:8px;font-size:9px;}.next-panel::after{right:30px;bottom:21px;width:47px;height:47px;border-radius:14px;font-size:22px;}.active-app-body,.status-body,.workspace-body,.pending-body,.journey-body{padding:10px;}.active-app-list{gap:7px;}.active-app-card{padding:10px;border-radius:9px;}.active-app-name{font-size:10px;}.active-app-number,.active-app-meta,.active-days{font-size:7px;}.active-status-badge,.active-sla-badge{min-height:18px;padding:0 6px;font-size:7px;}.active-app-progress{height:4px;}.active-track-button{min-height:30px;padding:0 10px;border-radius:8px;font-size:8px;}.pending-row{padding:8px 0;}.pending-icon{width:29px;height:29px;border-radius:8px;}.pending-icon svg{width:15px;height:15px;}.pending-title{font-size:8px;}.pending-subtitle,.pending-count{font-size:7px;}.journey-row{min-height:37px;}.journey-dot{width:20px;height:20px;font-size:7px;}.journey-info strong{font-size:8px;}.journey-info span{font-size:7px;}.status-list{gap:7px;}.status-item{min-height:62px;padding:8px 6px;border-radius:9px;}.status-count{font-size:17px;}.status-name{margin-top:3px;font-size:7px;}.workspace-grid{gap:8px;}.workspace-item{min-height:82px;padding:10px;border-radius:10px;}.workspace-icon{width:30px;height:30px;border-radius:8px;}.workspace-icon svg{width:16px;height:16px;}.workspace-item strong{margin-top:7px;font-size:9px;}.workspace-item>span:not(.smart-feature-arrow),.workspace-item .smart-feature-copy>span{font-size:7px;}.smart-feature-card{min-height:92px;}.smart-feature-copy strong{font-size:10px;}.smart-feature-label{margin-top:6px;font-size:6px !important;}.smart-feature-arrow{margin-top:7px;font-size:7px;}.security-strip{margin-top:11px;padding:10px 12px;border-radius:10px;font-size:8px;}@media (max-width:1120px){.app-shell{grid-template-columns:190px minmax(0,1fr);}.sidebar{width:190px;}.dashboard-layout{grid-template-columns:1fr;}}@media (max-width:850px){.app-shell{display:block;}.sidebar{width:100%;}.dashboard-search{width:calc(100% - 105px);}}@media (max-width:600px){.dashboard-search{width:100%;}.summary-grid,.workspace-grid{grid-template-columns:1fr;}}@media (max-width:560px){.main{padding:18px 13px 30px;}.summary-grid,.workspace-grid,.nav-list{grid-template-columns:1fr;}.welcome h1{font-size:23px;}.next-title{font-size:21px;}}html{font-size:15px;}body{font-size:14px;}.app-shell{grid-template-columns:232px minmax(0,1fr);}.sidebar{width:232px;padding:22px 16px 18px;}.sidebar-brand{margin-bottom:26px;gap:10px;}.logo-wrap{width:44px;height:44px;}.brand-title{font-size:19px;}.brand-subtitle{font-size:7px;}.nav-label{font-size:9px;}.nav-list{gap:5px;}.nav-item{min-height:43px;padding:0 13px;gap:10px;font-size:12px;border-radius:10px;}.nav-item svg{width:18px;height:18px;}.sidebar-avatar{width:38px;height:38px;font-size:13px;}.sidebar-user strong{font-size:12px;}.sidebar-user span,.sidebar-bottom-links a{font-size:10px;}.main{padding:24px 25px 36px;}.topbar{min-height:58px;margin-bottom:18px;}.welcome h1{font-size:25px;}.welcome p{font-size:12px;}.top-icon{width:40px;height:40px;}.top-profile{min-height:40px;padding:0 13px;font-size:12px;}.summary-grid{gap:14px;margin-bottom:18px;}.summary-card{min-height:126px;padding:18px;border-radius:15px;}.summary-label{font-size:11px;}.summary-icon{width:35px;height:35px;}.summary-icon svg{width:18px;height:18px;}.summary-number{margin-top:11px;font-size:27px;}.summary-note{margin-top:8px;font-size:10px;}.dashboard-layout,.left-column,.right-column{gap:17px;}.panel,.next-panel{border-radius:16px;}.panel-header{padding:18px 20px;}.panel-title{font-size:17px;}.panel-subtitle{font-size:11px;}.panel-link{font-size:11px;}.next-panel{min-height:195px;padding:23px;}.next-eyebrow{padding:6px 10px;font-size:9px;}.next-title{margin-top:11px;font-size:22px;}.next-description{margin-top:8px;font-size:12px;}.badge{min-height:24px;padding:0 9px;font-size:9px;}.next-button{min-height:40px;padding:0 15px;font-size:12px;}.active-app-body,.status-body,.workspace-body,.pending-body,.journey-body{padding:17px;}.active-app-card{padding:15px;}.active-app-name{font-size:14px;}.active-app-number,.active-app-meta,.active-days{font-size:10px;}.active-track-button{min-height:38px;padding:0 14px;font-size:11px;}.status-list{gap:10px;}.status-item{min-height:80px;padding:13px 10px;}.status-count{font-size:22px;}.status-name{margin-top:5px;font-size:10px;}.workspace-grid{gap:12px;}.workspace-item{min-height:108px;padding:15px;border-radius:13px;}.workspace-icon{width:37px;height:37px;}.workspace-icon svg{width:19px;height:19px;}.workspace-item strong{margin-top:10px;font-size:13px;}.workspace-item>span:not(.smart-feature-arrow),.workspace-item .smart-feature-copy>span{font-size:10px;}.smart-feature-card{min-height:125px;}.smart-feature-copy strong{font-size:14px;}.smart-feature-label{font-size:8px !important;}.smart-feature-arrow{margin-top:10px;font-size:10px;}.pending-title{font-size:12px;}.pending-subtitle,.pending-count{font-size:10px;}.journey-row{min-height:50px;}.journey-dot{width:25px;height:25px;font-size:10px;}.journey-info strong{font-size:11px;}.journey-info span{font-size:9px;}.security-strip{padding:14px 17px;font-size:11px;}@media (max-width:1180px){.app-shell{grid-template-columns:215px minmax(0,1fr);}.sidebar{width:215px;}}@media (max-width:850px){.app-shell{display:block;}.sidebar{width:100%;}}/* Match Document Vault typography without changing CHAPERON colours or logo. */
body{font-family:Inter,"Segoe UI",Arial,sans-serif;font-size:15px}.app-shell{grid-template-columns:238px minmax(0,1fr)}.sidebar{width:238px;padding:26px 20px}.sidebar-brand{margin-bottom:34px;gap:11px}.logo-wrap{width:47px;height:47px;min-width:47px;border-radius:10px}.logo-wrap img{width:70px;height:70px;left:-12px;top:-5px}.brand-title{font-size:21px}.brand-subtitle{font-size:8px}.nav-label{margin:0 10px 10px;font-size:10px;letter-spacing:1.2px}.nav-list{gap:7px}.nav-item{min-height:45px;padding:0 14px;border-radius:11px;font-size:13px;font-weight:700}.nav-item svg{width:19px;height:19px}.sidebar-profile{padding:14px;border-radius:14px}.sidebar-avatar{width:40px;height:40px;min-width:40px;font-size:14px}.sidebar-user strong{font-size:14px}.sidebar-user span,.sidebar-bottom-links a{font-size:12px}.main{padding:32px}.topbar{min-height:48px;margin-bottom:25px}.dashboard-search{height:45px;max-width:590px;border-radius:11px}.dashboard-search input{font-size:13px}.welcome h1{font-size:29px}.welcome p{margin-top:6px;font-size:14px}.top-icon{width:43px;height:43px}.top-profile{min-height:43px;padding:0 15px;font-size:13px}.summary-grid{gap:15px;margin-bottom:22px}.summary-card{min-height:137px;padding:20px;border-radius:18px}.summary-label{font-size:12px}.summary-icon{width:39px;height:39px;border-radius:11px}.summary-icon svg{width:20px;height:20px}.summary-number{margin-top:13px;font-size:29px}.summary-note{margin-top:8px;font-size:11px}.dashboard-layout,.left-column,.right-column{gap:22px}.dashboard-layout{grid-template-columns:minmax(0,1.48fr) minmax(300px,.72fr)}.panel,.next-panel{border-radius:18px}.panel-header{padding:21px 23px}.panel-title{font-size:20px}.panel-subtitle{margin-top:5px;font-size:13px}.panel-link{font-size:12px}.next-panel{min-height:210px;padding:28px}.next-eyebrow{padding:7px 11px;font-size:10px}.next-title{margin-top:14px;font-size:25px}.next-description{margin-top:9px;font-size:14px;line-height:1.55}.badge{min-height:27px;padding:0 10px;font-size:10px}.next-button{min-height:45px;padding:0 18px;border-radius:10px;font-size:13px}.active-app-body,.status-body,.workspace-body,.pending-body,.journey-body{padding:20px}.active-app-list{gap:12px}.active-app-card{padding:16px;border-radius:13px}.active-app-name{font-size:15px}.active-app-number,.active-app-meta,.active-days{font-size:11px}.active-status-badge,.active-sla-badge{min-height:23px;padding:0 8px;font-size:9px}.active-track-button{min-height:39px;padding:0 15px;font-size:12px}.pending-row{padding:12px 0}.pending-icon{width:38px;height:38px;border-radius:10px}.pending-title{font-size:13px}.pending-subtitle,.pending-count{font-size:11px}.journey-row{min-height:54px}.journey-dot{width:28px;height:28px;font-size:11px}.journey-info strong{font-size:12px}.journey-info span{font-size:10px}.status-list{gap:11px}.status-item{min-height:84px;padding:14px 10px;border-radius:12px}.status-count{font-size:24px}.status-name{font-size:11px}.workspace-grid{gap:14px}.workspace-item{min-height:118px;padding:17px;border-radius:14px}.workspace-icon{width:41px;height:41px;border-radius:11px}.workspace-icon svg{width:21px;height:21px}.workspace-item strong{margin-top:10px;font-size:14px}.workspace-item>span:not(.smart-feature-arrow),.workspace-item .smart-feature-copy>span{font-size:11px;line-height:1.45}.smart-feature-card{min-height:132px}.smart-feature-copy strong{font-size:15px}.smart-feature-label{font-size:9px!important}.smart-feature-arrow{font-size:11px}.security-strip{padding:15px 18px;font-size:12px}@media(max-width:1180px){.app-shell{grid-template-columns:218px minmax(0,1fr)}.sidebar{width:218px}.dashboard-layout{grid-template-columns:1fr}}@media(max-width:850px){.app-shell{display:block}.sidebar{position:static;width:100%;height:auto}.main{padding:22px 15px}.dashboard-search{width:100%}}
/* Final dashboard alignment fixes. */
.sidebar-brand{width:100%;min-width:0;align-items:center}
.sidebar-brand>div:last-child{min-width:0;max-width:calc(100% - 58px);overflow:hidden}
.brand-title{max-width:100%;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.brand-subtitle{display:block;width:100%;max-width:145px;white-space:normal;overflow-wrap:anywhere;word-break:normal;line-height:1.25;font-size:7px;letter-spacing:0}
.next-panel::after{content:none!important;display:none!important}
.next-content{width:100%}
.next-title,.next-description,.next-bottom{max-width:none!important}
.next-bottom{width:100%;display:grid;grid-template-columns:minmax(0,1fr) auto;align-items:center;column-gap:20px}
.next-meta{min-width:0}
.next-button{justify-self:end;margin-left:auto}
@media(max-width:620px){.next-bottom{display:flex;align-items:stretch;flex-direction:column}.next-button{width:100%;margin-left:0}.brand-subtitle{max-width:130px}}
</style></head><body><div class="app-shell"><aside class="sidebar"><a
href="<%= ctx %>/entrepreneur/dashboard"
class="sidebar-brand"><div class="logo-wrap"><img
src="<%= ctx %>/images/chaperon-logo.jpeg"
alt="CHAPERON Logo"></div><div><div class="brand-title">
CHAPERON
</div><div class="brand-subtitle">
GUIDE. CONNECT. COMPLY. GET APPROVED.
</div></div></a><div class="nav-label">
WORKSPACE
</div><nav class="nav-list"><a
href="<%= ctx %>/entrepreneur/dashboard"
class="nav-item active"><svg
viewBox="0 0 24 24"
fill="none"><path
d="M3 11L12 4L21 11V21H15V15H9V21H3V11Z"
stroke="currentColor"
stroke-width="2"
stroke-linejoin="round"/></svg><span>
Dashboard
</span></a><a
href="<%= ctx %>/entrepreneur/business-onboarding"
class="nav-item"><svg
viewBox="0 0 24 24"
fill="none"><path
d="M4 21V8L12 3L20 8V21"
stroke="currentColor"
stroke-width="2"/><path
d="M9 21V14H15V21"
stroke="currentColor"
stroke-width="2"/></svg><span>
My Business
</span></a><a
href="<%= ctx %>/entrepreneur/generate-approvals"
class="nav-item"><svg
viewBox="0 0 24 24"
fill="none"><circle
cx="5"
cy="6"
r="2"
stroke="currentColor"
stroke-width="2"/><circle
cx="19"
cy="18"
r="2"
stroke="currentColor"
stroke-width="2"/><path
d="M7 6H16C18 6 19 8 19 10V11M17 18H8C6 18 5 16 5 14V13"
stroke="currentColor"
stroke-width="2"/></svg><span>
Approval Journey
</span></a><a
href="<%= ctx %>/entrepreneur/documents"
class="nav-item"><svg
viewBox="0 0 24 24"
fill="none"><path
d="M6 2H14L19 7V22H6Z"
stroke="currentColor"
stroke-width="2"/><path
d="M14 2V7H19"
stroke="currentColor"
stroke-width="2"/></svg><span>
Documents
</span></a><a
href="<%= ctx %>/entrepreneur/my-applications"
class="nav-item"><svg
viewBox="0 0 24 24"
fill="none"><rect
x="4"
y="3"
width="16"
height="18"
rx="2"
stroke="currentColor"
stroke-width="2"/><path
d="M8 8H16M8 12H16M8 16H13"
stroke="currentColor"
stroke-width="2"/></svg><span>
Applications
</span></a><a
href="<%= ctx %>/entrepreneur/inspections"
class="nav-item"><svg
viewBox="0 0 24 24"
fill="none"><rect
x="3"
y="5"
width="18"
height="16"
rx="2"
stroke="currentColor"
stroke-width="2"/><path
d="M8 3V7M16 3V7M3 10H21"
stroke="currentColor"
stroke-width="2"/></svg><span>
Inspections
</span></a><a
href="<%= ctx %>/entrepreneur/schemes"
class="nav-item"><svg
viewBox="0 0 24 24"
fill="none"><path
d="M12 3L20 7L12 11L4 7L12 3Z"
stroke="currentColor"
stroke-width="2"/><path
d="M5 10V16L12 20L19 16V10"
stroke="currentColor"
stroke-width="2"/></svg><span>
Schemes
</span></a><a
href="<%= ctx %>/entrepreneur/compliance"
class="nav-item"><svg
viewBox="0 0 24 24"
fill="none"><path
d="M12 3L20 6V11C20 16 17 20 12 22C7 20 4 16 4 11V6L12 3Z"
stroke="currentColor"
stroke-width="2"/><path
d="M8.5 12L11 14.5L16 9.5"
stroke="currentColor"
stroke-width="2"/></svg><span>
Compliance
</span></a><a
href="<%= ctx %>/entrepreneur/notifications"
class="nav-item"><svg
viewBox="0 0 24 24"
fill="none"><path
d="M18 8A6 6 0 0 0 6 8C6 15 3 16 3 16H21C21 16 18 15 18 8Z"
stroke="currentColor"
stroke-width="2"/><path
d="M10 20H14"
stroke="currentColor"
stroke-width="2"/></svg><span>
Notifications
</span></a></nav><div class="sidebar-spacer"></div><div class="sidebar-profile"><div class="sidebar-user"><div class="sidebar-avatar"><%= avatarLetter %></div><div><strong><%= userName %></strong><span>
Entrepreneur
</span></div></div><div class="sidebar-bottom-links"><a
href="<%= ctx %>/entrepreneur/profile">
Profile
</a><a
href="<%= ctx %>/logout"
class="logout-link">
Logout
</a></div></div></aside><main class="main"><section class="topbar"><form class="dashboard-search" action="<%= ctx %>/entrepreneur/generate-approvals" method="get"><input type="search" name="q" placeholder="Search approvals, documents, schemes..."><button type="submit" aria-label="Search"><svg viewBox="0 0 24 24" fill="none"><circle cx="11" cy="11" r="7" stroke="currentColor" stroke-width="2"/><path d="M16.5 16.5L21 21" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg></button></form><div class="top-actions"><a
href="<%= ctx %>/entrepreneur/notifications"
class="top-icon"
title="Notifications"><svg
viewBox="0 0 24 24"
fill="none"><path
d="M18 8A6 6 0 0 0 6 8C6 15 3 16 3 16H21C21 16 18 15 18 8Z"
stroke="currentColor"
stroke-width="2"/><path
d="M10 20H14"
stroke="currentColor"
stroke-width="2"/></svg></a><a
href="<%= ctx %>/entrepreneur/profile"
class="top-profile"><%= avatarLetter %>
&nbsp;
<%= userName %></a></div></section><section class="dashboard-greeting"><div><span class="greeting-kicker">CHAPERON ENTREPRENEUR WORKSPACE</span><h1>Good Morning, <%= userName %>!</h1><p>Your regulatory journey at a glance. Keep going—you are on the right track.</p></div><blockquote>“Compliant today. A bigger tomorrow.”<small>— CHAPERON</small></blockquote></section><section class="summary-grid"><div class="summary-card"><div class="summary-top"><div class="summary-label">
Recommended Approvals
</div><div class="summary-icon blue-box"><svg
viewBox="0 0 24 24"
fill="none"><path
d="M5 12L10 17L20 7"
stroke="currentColor"
stroke-width="2"/></svg></div></div><div class="summary-number"><%= recommendedApprovalsCount %></div><div class="summary-note">
Based on your business profile
</div></div><div class="summary-card"><div class="summary-top"><div class="summary-label">
Active Applications
</div><div class="summary-icon purple-box"><svg
viewBox="0 0 24 24"
fill="none"><rect
x="4"
y="3"
width="16"
height="18"
rx="2"
stroke="currentColor"
stroke-width="2"/></svg></div></div><div class="summary-number"><%= activeApplicationsCount %></div><div class="summary-note">
Currently moving through workflow
</div></div><div class="summary-card"><div class="summary-top"><div class="summary-label">
Pending Actions
</div><div class="summary-icon orange-box"><svg
viewBox="0 0 24 24"
fill="none"><circle
cx="12"
cy="12"
r="9"
stroke="currentColor"
stroke-width="2"/><path
d="M12 7V13L16 15"
stroke="currentColor"
stroke-width="2"/></svg></div></div><div class="summary-number"><%= pendingActionsCount %></div><div class="summary-note">
Queries, drafts, documents and renewals
</div></div><div class="summary-card"><div class="summary-top"><div class="summary-label">
Approved Licences
</div><div class="summary-icon green-box"><svg
viewBox="0 0 24 24"
fill="none"><path
d="M12 3L20 6V11C20 16 17 20 12 22C7 20 4 16 4 11V6L12 3Z"
stroke="currentColor"
stroke-width="2"/><path
d="M8.5 12L11 14.5L16 9.5"
stroke="currentColor"
stroke-width="2"/></svg></div></div><div class="summary-number"><%= approvedLicencesCount %></div><div class="summary-note">
Successfully approved applications
</div></div></section><section class="dashboard-layout"><div class="left-column"><section class="next-panel"><div class="next-content"><div class="next-eyebrow">
CHAPERON GUIDANCE ENGINE
</div><%
if (nextAction != null) {
%><div class="next-title"><%= nextAction.getTitle() %></div><div class="next-description"><%= nextAction.getDescription() %></div><div class="next-bottom"><div class="next-meta"><span class="badge <%= priorityClass %>"><%= nextAction.getPriority() %>
PRIORITY
</span><span class="badge action-badge"><%= nextAction
.getActionType()
.replace('_', ' ') %></span></div><a
href="<%= ctx %><%= nextAction.getActionUrl() %>"
class="next-button"><%= nextAction.getButtonText() %>
→
</a></div><%
} else if (nextActionError != null) {
%><div class="next-error"><%= nextActionError %></div><%
} else {
%><div class="next-title">
Your journey is being analysed
</div><div class="next-description">
CHAPERON is preparing your next
recommended action.
</div><%
}
%></div></section><section class="panel"><div class="panel-header"><div><div class="panel-title">
Active Applications
</div><div class="panel-subtitle">
Track every ongoing approval
and its SLA timeline
</div></div><span class="active-tracker-count"><%= activeApplicationList != null
? activeApplicationList.size()
: 0 %>
Active
</span></div><div class="active-app-body"><%
if (activeApplicationList != null
&& !activeApplicationList.isEmpty()) {
%><div class="active-app-list"><%
for (ApplicationView applicationView
: activeApplicationList) {
Application appRow =
applicationView.getApplication();
if (appRow == null) {
continue;
}
long applicationId =
appRow.getApplicationId();
String currentAppStatus =
appRow.getCurrentStatus();
String currentSlaStatus =
activeApplicationSlaStatus != null
? activeApplicationSlaStatus
.get(applicationId)
: null;
String currentSlaLabel =
activeApplicationSlaLabel != null
? activeApplicationSlaLabel
.get(applicationId)
: null;
String currentSlaMessage =
activeApplicationSlaMessage != null
? activeApplicationSlaMessage
.get(applicationId)
: null;
Integer currentSlaProgress =
activeApplicationSlaProgress != null
? activeApplicationSlaProgress
.get(applicationId)
: null;
Long currentDaysRemaining =
activeApplicationSlaDaysRemaining
!= null
? activeApplicationSlaDaysRemaining
.get(applicationId)
: null;
if (currentSlaStatus == null) {
currentSlaStatus = "NOT_STARTED";
}
if (currentSlaLabel == null) {
currentSlaLabel = "Not Started";
}
if (currentSlaProgress == null) {
currentSlaProgress = 0;
}
String currentSlaCss =
"active-sla-not-started";
if ("ON_TRACK"
.equalsIgnoreCase(
currentSlaStatus
)) {
currentSlaCss =
"active-sla-on-track";
} else if (
"NEAR_DEADLINE"
.equalsIgnoreCase(
currentSlaStatus
)
) {
currentSlaCss =
"active-sla-near";
} else if (
"BREACHED"
.equalsIgnoreCase(
currentSlaStatus
)
) {
currentSlaCss =
"active-sla-breached";
} else if (
"COMPLETED"
.equalsIgnoreCase(
currentSlaStatus
)
) {
currentSlaCss =
"active-sla-completed";
}
%><div class="active-app-card"><div><div class="active-app-name"><%= applicationView.getApprovalName()
!= null
? applicationView
.getApprovalName()
: "Approval" %></div><div class="active-app-number"><%= appRow.getApplicationNumber()
!= null
? appRow.getApplicationNumber()
: "Application" %><%
if (applicationView
.getDepartmentName()
!= null) {
%>
&nbsp;•&nbsp;
<%= applicationView
.getDepartmentName() %><%
}
%></div><div class="active-app-meta"><span class="active-status-badge"><%= currentAppStatus != null
? currentAppStatus
.replace(
"_",
" "
)
: "DRAFT" %></span><span class="active-sla-badge <%= currentSlaCss %>">
SLA:
<%= currentSlaLabel %></span><%
if ("BREACHED"
.equalsIgnoreCase(
currentSlaStatus
)
&&
currentDaysRemaining != null) {
%><span class="active-days"><%= Math.abs(
currentDaysRemaining
) %>
day<%=
Math.abs(
currentDaysRemaining
) == 1
? ""
: "s"
%>
overdue
</span><%
} else if (
"ON_TRACK"
.equalsIgnoreCase(
currentSlaStatus
)
||
"NEAR_DEADLINE"
.equalsIgnoreCase(
currentSlaStatus
)
) {
%><span class="active-days"><%= currentSlaMessage != null
? currentSlaMessage
: "" %></span><%
}
%></div><%
if (!"NOT_STARTED"
.equalsIgnoreCase(
currentSlaStatus
)
&&
!"COMPLETED"
.equalsIgnoreCase(
currentSlaStatus
)) {
%><div class="active-app-progress"><div
class="active-app-progress-fill"
style="width:<%= currentSlaProgress %>%;"></div></div><%
}
%></div><a
href="<%= ctx %>/entrepreneur/application-details?id=<%= applicationId %>"
class="active-track-button">
Track →
</a></div><%
}
%></div><%
} else {
%><div class="active-empty"><strong>
No active applications
</strong><br><br>
Start an approval application from
your Approval Journey to begin
tracking it here.
</div><%
}
%></div></section><section class="panel"><div class="panel-header"><div><div class="panel-title">
Application Overview
</div><div class="panel-subtitle">
Current distribution of your applications
</div></div><a
href="<%= ctx %>/entrepreneur/my-applications"
class="panel-link">
View all →
</a></div><div class="status-body"><div class="status-list"><div class="status-item"><div class="status-count"><%= draftApplicationsCount %></div><div class="status-name">
Draft
</div></div><div class="status-item"><div class="status-count"><%= submittedApplicationsCount %></div><div class="status-name">
Submitted
</div></div><div class="status-item"><div class="status-count"><%= underReviewApplicationsCount %></div><div class="status-name">
Under Review
</div></div><div class="status-item"><div class="status-count"><%= approvedApplicationsCount %></div><div class="status-name">
Approved
</div></div><div class="status-item"><div class="status-count"><%= rejectedApplicationsCount %></div><div class="status-name">
Rejected
</div></div></div></div></section><section class="panel"><div class="panel-header"><div><div class="panel-title">
Quick Workspace
</div><div class="panel-subtitle">
Jump directly to key regulatory tools
</div></div></div><div class="workspace-body"><div class="workspace-grid"><a
href="<%= ctx %>/entrepreneur/incentive-calculator"
class="workspace-item smart-feature-card incentive-card"><div class="workspace-icon"><svg viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2"/><path d="M8 9H16M8 13H16M11 6C14 7 14 16 11 18"
stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg></div><div class="smart-feature-copy"><span class="smart-feature-label">FINANCIAL PLANNING</span><strong>Incentive Calculator</strong><span>Estimate eligible subsidies and financial benefits</span></div><span class="smart-feature-arrow">Explore →</span></a><a
href="<%= ctx %>/entrepreneur/gis-recommendations"
class="workspace-item smart-feature-card ecosync-card"><div class="workspace-icon"><svg viewBox="0 0 24 24" fill="none"><path d="M3 6L9 3L15 6L21 3V18L15 21L9 18L3 21V6Z"
stroke="currentColor" stroke-width="2" stroke-linejoin="round"/><path d="M9 3V18M15 6V21" stroke="currentColor" stroke-width="2"/><circle cx="15" cy="10" r="2" stroke="currentColor" stroke-width="2"/></svg></div><div class="smart-feature-copy"><span class="smart-feature-label">SMART GIS SCREENING</span><strong>EcoSync</strong><span>View officer-confirmed GIS clearance recommendations</span></div><span class="smart-feature-arrow">Open →</span></a><a
href="<%= ctx %>/entrepreneur/approval-journey"
class="workspace-item"><div class="workspace-icon"><svg viewBox="0 0 24 24" fill="none"><circle cx="5" cy="12" r="2" stroke="currentColor" stroke-width="2"/><circle cx="19" cy="6" r="2" stroke="currentColor" stroke-width="2"/><circle cx="19" cy="18" r="2" stroke="currentColor" stroke-width="2"/><path d="M7 12H11C15 12 15 6 17 6" stroke="currentColor" stroke-width="2"/><path d="M11 12C15 12 15 18 17 18" stroke="currentColor" stroke-width="2"/></svg></div><strong>Journey Optimizer</strong><span>Parallel &amp; dependent approvals</span></a><a
href="<%= ctx %>/entrepreneur/what-if-simulator"
class="workspace-item"><div class="workspace-icon"><svg viewBox="0 0 24 24" fill="none"><path d="M4 19L9 14L13 17L20 8" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/><path d="M15 8H20V13" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg></div><strong>What-If Simulator</strong><span>Simulate business changes</span></a><a
href="<%= ctx %>/entrepreneur/explain-delay"
class="workspace-item"><div class="workspace-icon"><svg viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="2"/><path d="M12 7V12L15 14" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg></div><strong>Explain My Delay</strong><span>Understand processing delays</span></a><a
href="<%= ctx %>/entrepreneur/compliance-health"
class="workspace-item"><div class="workspace-icon"><svg viewBox="0 0 24 24" fill="none"><path d="M12 3L20 6V11C20 16 17 20 12 22C7 20 4 16 4 11V6L12 3Z" stroke="currentColor" stroke-width="2"/><path d="M8 13L10.5 15.5L16 10" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg></div><strong>Compliance Health</strong><span>Score &amp; Regulatory Passport</span></a><a
href="<%= ctx %>/entrepreneur/regulation-impact"
class="workspace-item"><div class="workspace-icon"><svg viewBox="0 0 24 24" fill="none"><path d="M12 3V21" stroke="currentColor" stroke-width="2"/><path d="M5 7H19" stroke="currentColor" stroke-width="2"/><path d="M7 7L4 13H10L7 7Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/><path d="M17 7L14 13H20L17 7Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/></svg></div><strong>Regulation Impact</strong><span>See changes affecting you</span></a><a
href="<%= ctx %>/entrepreneur/document-pre-validation"
class="workspace-item"><div class="workspace-icon"><svg viewBox="0 0 24 24" fill="none"><path d="M6 2H14L19 7V22H6Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/><path d="M14 2V7H19" stroke="currentColor" stroke-width="2"/><path d="M9 15L11 17L16 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg></div><strong>AI Document Check</strong><span>Pre-validate before submission</span></a></div></div></section></div><div class="right-column"><section class="panel"><div class="panel-header"><div><div class="panel-title">
Attention Required
</div><div class="panel-subtitle">
Items that may require action
</div></div></div><div class="pending-body"><a
href="<%= ctx %>/entrepreneur/my-applications"
class="pending-row"><div class="pending-left"><div class="pending-icon orange-box"><svg
viewBox="0 0 24 24"
fill="none"><path
d="M4 4H20V16H8L4 20V4Z"
stroke="currentColor"
stroke-width="2"/></svg></div><div class="pending-info"><strong>
Officer Queries
</strong><span>
Responses requested by officers
</span></div></div><div class="pending-count"><%= openQueriesCount %></div></a><a
href="<%= ctx %>/entrepreneur/inspections"
class="pending-row"><div class="pending-left"><div class="pending-icon blue-box"><svg
viewBox="0 0 24 24"
fill="none"><rect
x="3"
y="5"
width="18"
height="16"
rx="2"
stroke="currentColor"
stroke-width="2"/></svg></div><div class="pending-info"><strong>
Inspections
</strong><span>
Scheduled or rescheduled
</span></div></div><div class="pending-count"><%= scheduledInspectionsCount %></div></a><a
href="<%= ctx %>/entrepreneur/compliance"
class="pending-row"><div class="pending-left"><div class="pending-icon green-box"><svg
viewBox="0 0 24 24"
fill="none"><path
d="M12 3L20 6V11C20 16 17 20 12 22C7 20 4 16 4 11V6L12 3Z"
stroke="currentColor"
stroke-width="2"/></svg></div><div class="pending-info"><strong>
Renewals
</strong><span>
Upcoming licence renewals
</span></div></div><div class="pending-count"><%= pendingRenewalsCount %></div></a><a
href="<%= ctx %>/entrepreneur/documents"
class="pending-row"><div class="pending-left"><div class="pending-icon purple-box"><svg
viewBox="0 0 24 24"
fill="none"><path
d="M6 2H14L19 7V22H6Z"
stroke="currentColor"
stroke-width="2"/></svg></div><div class="pending-info"><strong>
Document Issues
</strong><span>
Rejected or expired documents
</span></div></div><div class="pending-count"><%= documentIssuesCount %></div></a></div></section><section class="panel"><div class="panel-header"><div><div class="panel-title">
Approval Journey
</div><div class="panel-subtitle">
End-to-end regulatory lifecycle
</div></div></div><div class="journey-body"><div class="journey-list"><div class="journey-row"><div class="journey-dot">
1
</div><div class="journey-info"><strong>
Business Profile
</strong><span>
Define your business context
</span></div></div><div class="journey-row"><div class="journey-dot">
2
</div><div class="journey-info"><strong>
Approval Discovery
</strong><span>
Identify applicable licences
</span></div></div><div class="journey-row"><div class="journey-dot">
3
</div><div class="journey-info"><strong>
Document Readiness
</strong><span>
Prepare reusable documents
</span></div></div><div class="journey-row"><div class="journey-dot">
4
</div><div class="journey-info"><strong>
Government Review
</strong><span>
Query and inspection workflow
</span></div></div><div class="journey-row"><div class="journey-dot">
5
</div><div class="journey-info"><strong>
Approval & Compliance
</strong><span>
Certificate, validity and renewals
</span></div></div></div></div></section></div></section><div class="security-strip"><svg
viewBox="0 0 24 24"
fill="none"><path
d="M12 3L20 6V11C20 16 17 20 12 22C7 20 4 16 4 11V6L12 3Z"
stroke="currentColor"
stroke-width="2"/><path
d="M8.5 12L11 14.5L16 9.5"
stroke="currentColor"
stroke-width="2"/></svg>
CHAPERON provides a secure, guided and transparent
approval and compliance workspace.
</div></main></div><jsp:include page="/WEB-INF/views/common/cera-widget.jsp" /></body></html>