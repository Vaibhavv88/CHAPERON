<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.chaperon.model.Business" %>
<%@ page import="com.chaperon.model.Document" %>

<%
    Business business =
            (Business) request.getAttribute("business");

    List<Document> documents =
            (List<Document>) request.getAttribute("documents");

    String uploaded =
            request.getParameter("uploaded");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Document Vault | CHAPERON</title>

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

.topbar {
    min-height: 70px;
    background: white;
    border-bottom: 1px solid #e5eaf0;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 6%;
}

.logo {
    font-size: 25px;
    font-weight: 800;
    color: #10233f;
}

.topbar a {
    text-decoration: none;
    color: #46566b;
    font-weight: 700;
}

.page {
    padding: 45px 20px 70px;
}

.container {
    max-width: 1100px;
    margin: auto;
}

.hero {
    background: white;
    border: 1px solid #e5eaf1;
    border-radius: 20px;
    padding: 34px;
    box-shadow: 0 10px 30px rgba(24, 50, 84, 0.07);
    margin-bottom: 24px;
}

.hero h1 {
    margin: 0 0 10px;
    font-size: 34px;
}

.hero p {
    margin: 0;
    color: #66768a;
    line-height: 1.6;
}

.success {
    background: #eaf8ef;
    border: 1px solid #cfead9;
    color: #267a42;
    border-radius: 12px;
    padding: 14px 16px;
    margin-bottom: 20px;
    font-weight: 700;
}

.grid {
    display: grid;
    grid-template-columns: 1fr 1.4fr;
    gap: 22px;
}

.card {
    background: white;
    border: 1px solid #e4eaf1;
    border-radius: 18px;
    padding: 24px;
}

.card h2 {
    margin-top: 0;
    font-size: 21px;
}

.form-group {
    margin-bottom: 17px;
}

.form-group label {
    display: block;
    margin-bottom: 7px;
    font-weight: 700;
    color: #34465d;
}

select,
input[type="file"] {
    width: 100%;
    padding: 12px;
    border: 1px solid #ccd6e2;
    border-radius: 10px;
    background: white;
}

.help-text {
    margin-top: 7px;
    color: #78879a;
    font-size: 13px;
    line-height: 1.5;
}

.upload-btn {
    border: none;
    background: #1677e8;
    color: white;
    padding: 13px 20px;
    border-radius: 10px;
    font-weight: 800;
    cursor: pointer;
}

.upload-btn:hover {
    background: #0f67c8;
}

.document-list {
    display: grid;
    gap: 13px;
}

.document-item {
    border: 1px solid #e4eaf1;
    border-radius: 14px;
    padding: 16px;
    background: #fafcff;
}

.document-top {
    display: flex;
    justify-content: space-between;
    gap: 14px;
    align-items: flex-start;
}

.document-name {
    font-size: 17px;
    font-weight: 800;
    margin-bottom: 5px;
}

.document-type {
    color: #1768c7;
    font-size: 13px;
    font-weight: 700;
}

.status {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 800;
}

.uploaded {
    background: #eef5ff;
    color: #1768c7;
}

.verified {
    background: #e8f7ed;
    color: #267a42;
}

.rejected {
    background: #ffe9e7;
    color: #c43329;
}

.expired {
    background: #fff2d9;
    color: #986000;
}

.meta {
    margin-top: 11px;
    color: #68778a;
    font-size: 13px;
    line-height: 1.6;
}

.empty {
    text-align: center;
    border: 1px dashed #cbd6e2;
    border-radius: 14px;
    padding: 32px;
    color: #68778a;
    line-height: 1.6;
}

@media (max-width: 800px) {

    .grid {
        grid-template-columns: 1fr;
    }

    .hero h1 {
        font-size: 28px;
    }
}

</style>

</head>

<body>

<div class="topbar">

    <div class="logo">
        CHAPERON
    </div>

    <a href="<%= request.getContextPath() %>/entrepreneur/dashboard">
        Dashboard
    </a>

</div>

<div class="page">

<div class="container">

<div class="hero">

    <h1>
        Document Vault
    </h1>

    <p>
        Upload important business documents once and reuse them
        across multiple approval applications.
    </p>

</div>

<%
    if ("1".equals(uploaded)) {
%>

<div class="success">
    Document uploaded successfully.
</div>

<%
    }
%>

<div class="grid">

    <div class="card">

        <h2>
            Upload Document
        </h2>

        <form method="post"
              action="<%= request.getContextPath() %>/entrepreneur/document-upload"
              enctype="multipart/form-data">

            <div class="form-group">

                <label>
                    Document Type
                </label>

                <select name="documentType"
                        required>

                    <option value="">
                        Select document type
                    </option>

                    <option value="PAN">
                        PAN
                    </option>

                    <option value="BUSINESS_REGISTRATION">
                        Business Registration
                    </option>

                    <option value="FACTORY_LAYOUT">
                        Factory Layout
                    </option>

                    <option value="BUILDING_PLAN">
                        Building Plan
                    </option>

                    <option value="FIRE_LAYOUT">
                        Fire Layout
                    </option>

                    <option value="LAND_DOCUMENT">
                        Land Document
                    </option>

                    <option value="GST">
                        GST Certificate
                    </option>

                    <option value="IDENTITY_PROOF">
                        Identity Proof
                    </option>

                    <option value="OTHER">
                        Other
                    </option>

                </select>

            </div>

            <div class="form-group">

                <label>
                    Choose File
                </label>

                <input type="file"
                       name="documentFile"
                       accept=".pdf,.jpg,.jpeg,.png"
                       required>

                <div class="help-text">
                    Allowed: PDF, JPG, JPEG, PNG.
                    Maximum file size: 10 MB.
                </div>

            </div>

            <button type="submit"
                    class="upload-btn">

                Upload Document

            </button>

        </form>

    </div>


    <div class="card">

        <h2>
            Uploaded Documents
        </h2>

        <%
            if (documents != null &&
                !documents.isEmpty()) {
        %>

        <div class="document-list">

        <%
            for (Document document
                    : documents) {

                String status =
                        document.getVerificationStatus();

                String statusClass =
                        "uploaded";

                if ("VERIFIED".equalsIgnoreCase(status)) {

                    statusClass = "verified";

                } else if ("REJECTED".equalsIgnoreCase(status)) {

                    statusClass = "rejected";

                } else if ("EXPIRED".equalsIgnoreCase(status)) {

                    statusClass = "expired";
                }

                String documentType =
                        document.getDocumentType();

                if (documentType != null) {

                    documentType =
                            documentType.replace("_", " ");
                }
        %>

            <div class="document-item">

                <div class="document-top">

                    <div>

                        <div class="document-name">

                            <%= document.getOriginalFileName() != null
                                    ? document.getOriginalFileName()
                                    : "Uploaded Document" %>

                        </div>

                        <div class="document-type">

                            <%= documentType != null
                                    ? documentType
                                    : "DOCUMENT" %>

                        </div>

                    </div>

                    <span class="status <%= statusClass %>">

                        <%= status != null
                                ? status
                                : "UPLOADED" %>

                    </span>

                </div>

                <div class="meta">

                    File Type:
                    <strong>
                        <%= document.getFileExtension() != null
                                ? document.getFileExtension().toUpperCase()
                                : "N/A" %>
                    </strong>

                    <br>

                    Uploaded:
                    <strong>
                        <%= document.getUploadDate() != null
                                ? document.getUploadDate()
                                : "N/A" %>
                    </strong>

                    <%
                        if (document.getFileSize() != null) {
                    %>

                    <br>

                    Size:
                    <strong>
                        <%= String.format(
                                "%.2f MB",
                                document.getFileSize()
                                / 1024.0
                                / 1024.0
                        ) %>
                    </strong>

                    <%
                        }
                    %>

                </div>

            </div>

        <%
            }
        %>

        </div>

        <%
            } else {
        %>

        <div class="empty">

            No documents uploaded yet.

            <br><br>

            Upload your PAN, business registration,
            layout plans and other reusable documents here.

        </div>

        <%
            }
        %>

    </div>

</div>

</div>

</div>

</body>

</html>