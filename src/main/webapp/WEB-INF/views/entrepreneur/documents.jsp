<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="com.chaperon.model.Business" %>
<%@ page import="com.chaperon.model.Document" %>

<%!
    private String readProperty(Object object, String... getters) {
        if (object == null) return "";
        for (String getter : getters) {
            try {
                Method method = object.getClass().getMethod(getter);
                Object value = method.invoke(object);
                return value == null ? "" : String.valueOf(value);
            } catch (Exception ignored) { }
        }
        return "";
    }

    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String statusClass(String status) {
        if (status == null) return "status-uploaded";
        String value = status.trim().toUpperCase();
        if ("VERIFIED".equals(value)) return "status-verified";
        if ("REJECTED".equals(value)) return "status-rejected";
        if ("EXPIRED".equals(value)) return "status-expired";
        return "status-uploaded";
    }
%>

<%
    String ctx = request.getContextPath();
    String userName = (String) session.getAttribute("userName");
    if (userName == null || userName.isBlank()) userName = "Entrepreneur";

    Business business = (Business) request.getAttribute("business");

    @SuppressWarnings("unchecked")
    List<Document> documents = (List<Document>) request.getAttribute("documents");

    @SuppressWarnings("unchecked")
    Map<String, Map<String, String>> documentTypeGroups =
            (Map<String, Map<String, String>>) request.getAttribute("documentTypeGroups");

    Integer documentTypeCount = (Integer) request.getAttribute("documentTypeCount");
    if (documentTypeCount == null) documentTypeCount = 0;
    int uploadedCount = documents == null ? 0 : documents.size();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document Vault | CHAPERON</title>
    <link rel="stylesheet" href="<%= ctx %>/assets/css/entrepreneur-enhancements.css">
    <style>
        * { box-sizing: border-box; }
        :root {
            --blue: #1478ee;
            --blue-dark: #075cc5;
            --navy: #102746;
            --muted: #657895;
            --border: #dfe8f4;
            --background: #f3f7fd;
            --white: #ffffff;
            --green: #149b63;
            --red: #d64545;
        }
        body {
            margin: 0;
            color: var(--navy);
            background: var(--background);
            font-family: Inter, "Segoe UI", Arial, sans-serif;
            font-size: 15px;
        }
        a { color: inherit; text-decoration: none; }
        .page-shell { min-height: 100vh; display: grid; grid-template-columns: 238px 1fr; }
        .sidebar {
            position: sticky; top: 0; height: 100vh; padding: 26px 20px;
            background: #fff; border-right: 1px solid var(--border);
            display: flex; flex-direction: column;
        }
        .brand { display: flex; align-items: center; gap: 11px; margin-bottom: 34px; }
        .brand img { width: 47px; height: 47px; object-fit: contain; border-radius: 10px; }
        .brand strong { display: block; color: #0864d8; font-size: 21px; font-weight: 900; }
        .brand small { display: block; margin-top: 2px; color: #687b94; font-size: 8px; font-weight: 700; }
        .nav-label { margin: 0 10px 10px; color: #93a1b5; font-size: 10px; font-weight: 800; letter-spacing: 1.2px; }
        .nav { display: grid; gap: 7px; }
        .nav a { padding: 13px 14px; border-radius: 11px; color: #536985; font-weight: 700; }
        .nav a:hover { color: var(--blue); background: #edf5ff; transform: translateX(2px); }
        .nav a.active { color: #fff; background: linear-gradient(135deg, #0769e8, #2995ee); box-shadow: 0 9px 22px #1478ee35; }
        .profile { margin-top: auto; padding: 14px; border: 1px solid var(--border); border-radius: 14px; }
        .profile strong { display: block; font-size: 14px; }
        .profile span { color: var(--muted); font-size: 12px; }
        .profile-links { display: flex; justify-content: space-between; margin-top: 12px; padding-top: 11px; border-top: 1px solid var(--border); font-size: 12px; font-weight: 800; }
        .profile-links .logout { color: var(--red); }
        .main { min-width: 0; padding: 32px; }
        .topbar { display: flex; justify-content: space-between; align-items: center; gap: 20px; margin-bottom: 25px; }
        .topbar h1 { margin: 0 0 6px; font-size: 29px; }
        .topbar p { margin: 0; color: var(--muted); }
        .back-button { padding: 11px 16px; border: 1px solid #bdd9fa; border-radius: 10px; color: #075fc9; background: #fff; font-weight: 800; }
        .hero {
            padding: 28px; border-radius: 22px; color: #fff;
            background: linear-gradient(125deg, #075ecb, #1688ef 65%, #35b6ef);
            box-shadow: 0 18px 40px #126fd32a;
        }
        .hero-grid { display: grid; grid-template-columns: 1fr auto; align-items: center; gap: 24px; }
        .hero-label { display: inline-flex; padding: 7px 11px; border: 1px solid #ffffff45; border-radius: 50px; background: #ffffff1b; font-size: 11px; font-weight: 900; letter-spacing: .7px; }
        .hero h2 { margin: 14px 0 8px; font-size: 30px; }
        .hero p { max-width: 690px; margin: 0; line-height: 1.65; color: #eaf5ff; }
        .hero-stats { display: flex; gap: 12px; }
        .hero-stat { min-width: 125px; padding: 17px; border: 1px solid #ffffff35; border-radius: 15px; background: #ffffff18; }
        .hero-stat strong { display: block; font-size: 25px; }
        .hero-stat span { font-size: 11px; font-weight: 700; color: #e8f4ff; }
        .content-grid { display: grid; grid-template-columns: minmax(0, 1fr) 330px; gap: 22px; margin-top: 22px; align-items: start; }
        .panel { background: #fff; border: 1px solid var(--border); border-radius: 18px; box-shadow: 0 10px 28px #173d6c0b; overflow: hidden; }
        .panel-header { padding: 21px 23px; border-bottom: 1px solid var(--border); }
        .panel-header h3 { margin: 0 0 5px; font-size: 20px; }
        .panel-header p { margin: 0; color: var(--muted); font-size: 13px; }
        .panel-body { padding: 22px; }
        .notice { margin-bottom: 18px; padding: 13px 15px; color: #095bb9; background: #edf6ff; border: 1px solid #d2e8ff; border-radius: 10px; }
        .form-grid { display: grid; grid-template-columns: 1.2fr 1fr; gap: 14px; }
        label { display: block; margin-bottom: 7px; font-weight: 800; }
        select, input[type="file"] { width: 100%; min-height: 47px; padding: 11px 12px; border: 1px solid #cfdced; border-radius: 10px; background: #fff; font: inherit; }
        .full { grid-column: 1 / -1; }
        .upload-button { width: 100%; min-height: 48px; border: 0; border-radius: 10px; color: #fff; background: linear-gradient(135deg, #096be5, #2494ef); font-size: 15px; font-weight: 900; cursor: pointer; }
        .upload-button:hover { box-shadow: 0 10px 22px #1179e63a; transform: translateY(-1px); }
        .tip-list { margin: 0; padding-left: 19px; color: var(--muted); line-height: 1.85; }
        .documents-panel { margin-top: 22px; }
        .documents-list { display: grid; gap: 13px; padding: 20px; }
        .document-card { display: grid; grid-template-columns: 48px minmax(0, 1fr) auto; align-items: center; gap: 15px; padding: 16px; border: 1px solid var(--border); border-radius: 13px; background: #fbfdff; }
        .file-icon { width: 48px; height: 48px; display: grid; place-items: center; border-radius: 12px; color: var(--blue); background: #eaf4ff; font-size: 22px; font-weight: 900; }
        .document-card h4 { margin: 0 0 5px; font-size: 15px; }
        .document-meta { display: flex; flex-wrap: wrap; gap: 9px 16px; color: var(--muted); font-size: 12px; }
        .status { display: inline-flex; padding: 7px 10px; border-radius: 50px; font-size: 10px; font-weight: 900; }
        .status-uploaded { color: #075fc9; background: #e7f2ff; }
        .status-verified { color: #08794d; background: #e2f7ed; }
        .status-rejected, .status-expired { color: #bd3030; background: #ffe7e7; }
        .empty { padding: 45px 20px; text-align: center; color: var(--muted); }
        .empty strong { display: block; margin-bottom: 7px; color: var(--navy); font-size: 18px; }
        @media (max-width: 1050px) {
            .content-grid { grid-template-columns: 1fr; }
            .hero-grid { grid-template-columns: 1fr; }
        }
        @media (max-width: 760px) {
            .page-shell { display: block; }
            .sidebar { position: static; width: 100%; height: auto; }
            .nav { grid-template-columns: repeat(2, 1fr); }
            .profile { margin-top: 20px; }
            .main { padding: 20px 14px; }
            .form-grid { grid-template-columns: 1fr; }
            .hero-stats { flex-wrap: wrap; }
            .document-card { grid-template-columns: 45px 1fr; }
            .document-card .status { grid-column: 2; width: max-content; }
        }
        /* Dashboard-matched visual language */
        body {
            background:
                radial-gradient(circle at 78% 3%, rgba(14,124,237,.11), transparent 28%),
                linear-gradient(145deg, #f5faff 0%, #eaf4ff 52%, #f8fbff 100%);
        }
        .sidebar {
            background: linear-gradient(180deg, #fff 0%, #f7fbff 67%, #edf6ff 100%);
            border-right: 1px solid #cfe1f5;
            box-shadow: 8px 0 30px rgba(27,80,138,.07);
        }
        .brand { width: 100%; min-width: 0; }
        .brand > div { min-width: 0; max-width: calc(100% - 58px); overflow: hidden; }
        .brand small {
            width: 100%; max-width: 145px; font-size: 7px; line-height: 1.25;
            white-space: normal; overflow-wrap: anywhere; letter-spacing: 0;
        }
        .nav a {
            min-height: 45px; display: flex; align-items: center;
            transition: transform .2s ease, background .2s ease, box-shadow .2s ease;
        }
        .nav a.active { box-shadow: 0 10px 22px rgba(20,120,238,.25); }
        .profile { background: rgba(255,255,255,.9); box-shadow: 0 8px 24px rgba(28,73,120,.06); }
        .topbar h1 { color: #102746; letter-spacing: -.45px; }
        .back-button { min-height: 45px; display: inline-flex; align-items: center; }
        .hero {
            padding: 34px; border: 1px solid rgba(255,255,255,.22);
            background: linear-gradient(125deg, #075ecb, #1688ef 65%, #35a9ef);
            box-shadow: 0 18px 40px rgba(18,111,211,.18);
        }
        .hero h2 { font-size: 32px; letter-spacing: -.55px; }
        .hero p { max-width: 820px; font-size: 15px; }
        .hero-stat { min-width: 135px; padding: 19px; }
        .hero-stat strong { font-size: 28px; }
        .panel { box-shadow: 0 11px 31px rgba(27,65,107,.075); }
        .panel-header h3 { color: #102746; }
        .notice { line-height: 1.55; }
        select, input[type="file"] { outline: none; transition: border-color .2s ease, box-shadow .2s ease; }
        select:focus, input[type="file"]:focus {
            border-color: #65aaf3; box-shadow: 0 0 0 4px rgba(20,120,238,.10);
        }
        .upload-button { box-shadow: 0 9px 20px rgba(17,121,230,.18); }
        .document-card { transition: transform .2s ease, border-color .2s ease, box-shadow .2s ease; }
        .document-card:hover {
            transform: translateY(-2px); border-color: #b9d7f6;
            box-shadow: 0 10px 24px rgba(28,73,120,.08);
        }
        @media (max-width: 850px) {
            .page-shell { display: block; }
            .sidebar { position: static; width: 100%; height: auto; }
            .nav { grid-template-columns: repeat(2,minmax(0,1fr)); }
            .main { padding: 22px 15px; }
        }
        @media (max-width: 620px) {
            .nav { grid-template-columns: 1fr; }
            .hero { padding: 25px 21px; }
            .hero h2 { font-size: 26px; }
            .hero-stats { width: 100%; }
            .hero-stat { flex: 1; }
        }
    </style>
</head>
<body>
<div class="page-shell">
    <aside class="sidebar">
        <a class="brand" href="<%= ctx %>/entrepreneur/dashboard">
            <img src="<%= ctx %>/images/chaperon-logo.jpeg" alt="CHAPERON Logo">
            <div><strong>CHAPERON</strong><small>GUIDE. CONNECT. COMPLY. GET APPROVED.</small></div>
        </a>
        <div class="nav-label">WORKSPACE</div>
        <nav class="nav">
            <a href="<%= ctx %>/entrepreneur/dashboard">⌂ &nbsp; Dashboard</a>
            <a href="<%= ctx %>/entrepreneur/business-onboarding">▣ &nbsp; My Business</a>
            <a href="<%= ctx %>/entrepreneur/generate-approvals">⌘ &nbsp; Approval Journey</a>
            <a class="active" href="<%= ctx %>/entrepreneur/documents">▤ &nbsp; Documents</a>
            <a href="<%= ctx %>/entrepreneur/my-applications">▧ &nbsp; Applications</a>
            <a href="<%= ctx %>/entrepreneur/inspections">▦ &nbsp; Inspections</a>
            <a href="<%= ctx %>/entrepreneur/schemes">◇ &nbsp; Schemes</a>
            <a href="<%= ctx %>/entrepreneur/compliance">◉ &nbsp; Compliance</a>
        </nav>
        <div class="profile">
            <strong><%= escapeHtml(userName) %></strong><span>Entrepreneur</span>
            <div class="profile-links"><a href="<%= ctx %>/entrepreneur/profile">Profile</a><a class="logout" href="<%= ctx %>/logout">Logout</a></div>
        </div>
    </aside>

    <main class="main">
        <header class="topbar">
            <div><h1>Document Vault</h1><p>Upload once and securely reuse documents across approval applications.</p></div>
            <a class="back-button" href="<%= ctx %>/entrepreneur/dashboard">← Dashboard</a>
        </header>

        <section class="hero">
            <div class="hero-grid">
                <div>
                    <span class="hero-label">CHAPERON SECURE WORKSPACE</span>
                    <h2>Your reusable document repository</h2>
                    <p>Keep business documents organised, monitor verification status and avoid uploading the same document for every application.</p>
                </div>
                <div class="hero-stats">
                    <div class="hero-stat"><strong><%= uploadedCount %></strong><span>UPLOADED</span></div>
                    <div class="hero-stat"><strong><%= documentTypeCount %></strong><span>SUPPORTED TYPES</span></div>
                </div>
            </div>
        </section>

        <% if (request.getParameter("uploaded") != null) { %>
            <div class="notice" style="margin-top:18px;color:#08794d;background:#e8f8f0;border-color:#c9eedc;">Document uploaded successfully.</div>
        <% } %>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="notice" style="margin-top:18px;color:#b72f2f;background:#fff0f0;border-color:#ffd1d1;"><%= escapeHtml(String.valueOf(request.getAttribute("errorMessage"))) %></div>
        <% } %>

        <div class="content-grid">
            <section class="panel">
                <div class="panel-header"><h3>Upload a Document</h3><p>Select a supported document type and choose the file.</p></div>
                <div class="panel-body">
                    <div class="notice">Files stored here can be attached to multiple approval requirements.</div>
                    <form action="<%= ctx %>/entrepreneur/document-upload" method="post" enctype="multipart/form-data">
                        <div class="form-grid">
                            <div>
                                <label for="documentType">Document type</label>
                                <select id="documentType" name="documentType" required>
                                    <option value="">-- Select document type --</option>
                                    <% if (documentTypeGroups != null) {
                                        for (Map.Entry<String, Map<String, String>> groupEntry : documentTypeGroups.entrySet()) { %>
                                            <optgroup label="<%= escapeHtml(groupEntry.getKey()) %>">
                                                <% if (groupEntry.getValue() != null) {
                                                    for (Map.Entry<String, String> typeEntry : groupEntry.getValue().entrySet()) { %>
                                                        <option value="<%= escapeHtml(typeEntry.getKey()) %>"><%= escapeHtml(typeEntry.getValue()) %></option>
                                                <%  }
                                                   } %>
                                            </optgroup>
                                    <%  }
                                       } %>
                                </select>
                            </div>
                            <div>
                                <label for="documentFile">Choose file</label>
                                <input id="documentFile" name="documentFile" type="file" accept=".pdf,.jpg,.jpeg,.png" required>
                            </div>
                            <div class="full"><button class="upload-button" type="submit">Upload to Document Vault</button></div>
                        </div>
                    </form>
                </div>
            </section>

            <aside class="panel">
                <div class="panel-header"><h3>Upload Guidelines</h3><p>For faster officer verification</p></div>
                <div class="panel-body">
                    <ul class="tip-list">
                        <li>Upload clear PDF, JPG or PNG files.</li>
                        <li>Select the correct document category.</li>
                        <li>Do not upload password-protected files.</li>
                        <li>Keep names and registration numbers readable.</li>
                        <li>Replace expired or rejected documents.</li>
                    </ul>
                </div>
            </aside>
        </div>

        <section class="panel documents-panel">
            <div class="panel-header"><h3>Uploaded Documents</h3><p><%= uploadedCount %> document(s) available in your vault</p></div>
            <% if (documents == null || documents.isEmpty()) { %>
                <div class="empty"><strong>No documents uploaded yet</strong>Upload your first reusable business document using the form above.</div>
            <% } else { %>
                <div class="documents-list">
                    <% for (Document document : documents) {
                        String id = readProperty(document, "getDocumentId", "getId");
                        String type = readProperty(document, "getDocumentType", "getType");
                        String fileName = readProperty(document, "getOriginalFileName", "getFileName", "getStoredFileName");
                        String status = readProperty(document, "getVerificationStatus", "getStatus");
                        String uploadDate = readProperty(document, "getUploadDate", "getUploadedAt", "getCreatedAt");
                        if (type.isBlank()) type = "Business Document";
                        if (fileName.isBlank()) fileName = "Uploaded file";
                        if (status.isBlank()) status = "UPLOADED";
                    %>
                        <article class="document-card">
                            <div class="file-icon">D</div>
                            <div>
                                <h4><%= escapeHtml(type.replace('_', ' ')) %></h4>
                                <div class="document-meta"><span><%= escapeHtml(fileName) %></span><% if (!uploadDate.isBlank()) { %><span>Uploaded: <%= escapeHtml(uploadDate) %></span><% } %></div>
                            </div>
                            <span class="status <%= statusClass(status) %>"><%= escapeHtml(status.replace('_', ' ')) %></span>
                        </article>
                    <% } %>
                </div>
            <% } %>
        </section>
    </main>
</div>
<jsp:include page="/WEB-INF/views/common/cera-widget.jsp" />
</body>
</html>
