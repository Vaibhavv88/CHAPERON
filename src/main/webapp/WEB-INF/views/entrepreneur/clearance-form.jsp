<%@ page language="java"

    contentType="text/html; charset=UTF-8"

    pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>

<%@ page import="java.util.Collections" %>

<%@ page import="com.chaperon.model.Business" %>

<%@ page import="com.chaperon.model.Document" %>

<%@ page import="com.chaperon.model.ClearanceType" %>

<%@ page import="com.chaperon.model.ClearanceApplication" %>

<%@ page import="com.chaperon.model.ClearanceApplicationMap" %>

<%@ page import="com.chaperon.model.ClearanceApplicationRequirement" %>

<%

    ClearanceType selectedClearanceType =

            (ClearanceType) request.getAttribute(

                    "selectedClearanceType");

    ClearanceApplication clearanceApplication =

            (ClearanceApplication) request.getAttribute(

                    "clearanceApplication");

    ClearanceApplicationMap clearanceMap =

            (ClearanceApplicationMap) request.getAttribute(

                    "clearanceMap");

    Business business =

            (Business) request.getAttribute("business");

    List<ClearanceApplicationRequirement> applicationChecklist =

            (List<ClearanceApplicationRequirement>)

                    request.getAttribute(

                            "applicationChecklist");

    if (applicationChecklist == null) {

        applicationChecklist =

                Collections.emptyList();

    }

    List<Document> businessDocuments =

            (List<Document>) request.getAttribute(

                    "businessDocuments");

    if (businessDocuments == null) {

        businessDocuments =

                Collections.emptyList();

    }

    Integer readinessValue =

            (Integer) request.getAttribute(

                    "readinessPercentage");

    int readinessPercentage =

            readinessValue == null

                    ? 0

                    : readinessValue;

    boolean editMode =

            clearanceApplication != null;

    String projectTitle =

            editMode

            && clearanceApplication.getProjectTitle() != null

                    ? clearanceApplication.getProjectTitle()

                    : "";

    String projectDescription =

            editMode

            && clearanceApplication.getProjectDescription() != null

                    ? clearanceApplication.getProjectDescription()

                    : "";

    String state =

            editMode

            && clearanceApplication.getState() != null

                    ? clearanceApplication.getState()

                    : "";

    String district =

            editMode

            && clearanceApplication.getDistrict() != null

                    ? clearanceApplication.getDistrict()

                    : "";

    String locationAddress =

            editMode

            && clearanceApplication.getLocationAddress() != null

                    ? clearanceApplication.getLocationAddress()

                    : "";

    String latitude =

            editMode

            && clearanceApplication.getLatitude() != null

                    ? clearanceApplication

                            .getLatitude()

                            .toPlainString()

                    : "";

    String longitude =

            editMode

            && clearanceApplication.getLongitude() != null

                    ? clearanceApplication

                            .getLongitude()

                            .toPlainString()

                    : "";

    String projectArea =

            editMode

            && clearanceApplication

                    .getProjectAreaHectares() != null

                    ? clearanceApplication

                            .getProjectAreaHectares()

                            .toPlainString()

                    : "";

    if (request.getAttribute("formProjectTitle") != null) {

        projectTitle =

                String.valueOf(

                        request.getAttribute(

                                "formProjectTitle"));

    }

    if (request.getAttribute(

            "formProjectDescription") != null) {

        projectDescription =

                String.valueOf(

                        request.getAttribute(

                                "formProjectDescription"));

    }

    if (request.getAttribute("formState") != null) {

        state =

                String.valueOf(

                        request.getAttribute(

                                "formState"));

    }

    if (request.getAttribute("formDistrict") != null) {

        district =

                String.valueOf(

                        request.getAttribute(

                                "formDistrict"));

    }

    if (request.getAttribute(

            "formLocationAddress") != null) {

        locationAddress =

                String.valueOf(

                        request.getAttribute(

                                "formLocationAddress"));

    }

    if (request.getAttribute("formLatitude") != null) {

        latitude =

                String.valueOf(

                        request.getAttribute(

                                "formLatitude"));

    }

    if (request.getAttribute("formLongitude") != null) {

        longitude =

                String.valueOf(

                        request.getAttribute(

                                "formLongitude"));

    }

    if (request.getAttribute(

            "formProjectAreaHectares") != null) {

        projectArea =

                String.valueOf(

                        request.getAttribute(

                                "formProjectAreaHectares"));

    }

    String savedGeoJson = "";

    if (clearanceMap != null

            && clearanceMap.getGeojsonData() != null) {

        savedGeoJson =

                clearanceMap.getGeojsonData();

    }

    if (request.getAttribute(

            "formBoundaryGeoJson") != null) {

        savedGeoJson =

                String.valueOf(

                        request.getAttribute(

                                "formBoundaryGeoJson"));

    }

    savedGeoJson =

            savedGeoJson

                    .replace("\\\\", "\\\\\\\\")

                    .replace("'", "\\\\'")

                    .replace("\r", "")

                    .replace("\n", "")

                    .replace("</", "<\\\\/");

    boolean declarationChecked =

            editMode

            && clearanceApplication

                    .isApplicantDeclaration();

%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"

          content="width=device-width, initial-scale=1.0">

    <title>

        Clearance Application | CHAPERON

    </title>

    <link rel="stylesheet"

          href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">

    <link rel="stylesheet"

          href="https://unpkg.com/leaflet-draw@1.0.4/dist/leaflet.draw.css">

    <style>

        * {

            box-sizing: border-box;

        }

        body {

            margin: 0;

            font-family: Arial, sans-serif;

            color: #172b4d;

            background: #f3f7fc;

        }

        .header {

            padding: 22px 35px;

            color: white;

            background: linear-gradient(

                    135deg,

                    #0755b5,

                    #2581e8);

        }

        .header h1 {

            margin: 0 0 7px;

        }

        .header p {

            margin: 0;

            opacity: 0.9;

        }

        .container {

            width: 94%;

            max-width: 1250px;

            margin: 25px auto;

        }

        .back-link {

            display: inline-block;

            margin-bottom: 17px;

            color: #0755b5;

            text-decoration: none;

            font-weight: bold;

        }

        .card {

            margin-bottom: 22px;

            padding: 27px;

            border-radius: 15px;

            background: white;

            box-shadow: 0 6px 23px

                    rgba(0, 44, 95, 0.09);

        }

        .clearance-summary {

            border-left: 6px solid #1672d8;

        }

        .clearance-code {

            display: inline-block;

            padding: 5px 11px;

            border-radius: 20px;

            color: #0755b5;

            background: #e9f3ff;

            font-size: 12px;

            font-weight: bold;

        }

        .clearance-summary h2 {

            margin: 11px 0 6px;

        }

        .section-title {

            margin: 7px 0 19px;

            padding-bottom: 11px;

            border-bottom: 1px solid #dbe6f2;

            font-size: 20px;

        }

        .form-grid {

            display: grid;

            grid-template-columns:

                    repeat(2, minmax(0, 1fr));

            gap: 18px;

        }

        .full-width {

            grid-column: 1 / -1;

        }

        .form-group label,

        .attachment-form label {

            display: block;

            margin-bottom: 7px;

            font-weight: bold;

        }

        .required {

            color: #d82727;

        }

        input,

        textarea,

        select {

            width: 100%;

            padding: 12px 13px;

            border: 1px solid #cbd8e6;

            border-radius: 8px;

            font-size: 15px;

            outline: none;

        }

        input:focus,

        textarea:focus,

        select:focus {

            border-color: #1672d8;

            box-shadow: 0 0 0 3px

                    rgba(22, 114, 216, 0.12);

        }

        input[readonly] {

            background: #f5f8fb;

        }

        textarea {

            min-height: 105px;

            resize: vertical;

        }

        .message {

            margin-bottom: 18px;

            padding: 13px;

            border-radius: 8px;

        }

        .error-message {

            color: #b31818;

            background: #fff0f0;

            border: 1px solid #ffc1c1;

        }

        .success-message {

            color: #17643a;

            background: #edfff5;

            border: 1px solid #afe3c6;

        }

        .map-help {

            margin-bottom: 13px;

            padding: 13px 15px;

            border-radius: 8px;

            color: #174d83;

            background: #eef6ff;

        }

        #projectMap {

            width: 100%;

            height: 440px;

            border: 1px solid #cad9e8;

            border-radius: 12px;

            z-index: 1;

        }

        .map-status {

            display: none;

            margin-top: 12px;

            padding: 11px 14px;

            border-radius: 8px;

            color: #17643a;

            background: #eaf9f1;

        }

        .map-status.visible {

            display: block;

        }

        .map-actions {

            display: flex;

            gap: 10px;

            margin-top: 12px;

        }

        .map-button {

            padding: 10px 15px;

            border: 0;

            border-radius: 7px;

            color: #0755b5;

            background: #e7f1fc;

            cursor: pointer;

            font-weight: bold;

        }

        .declaration {

            display: flex;

            gap: 10px;

            margin-top: 24px;

            padding: 16px;

            border-radius: 9px;

            background: #f7f9fc;

        }

        .declaration input {

            width: auto;

        }

        .form-actions {

            display: flex;

            justify-content: flex-end;

            gap: 12px;

            margin-top: 25px;

        }

        .button {

            padding: 12px 22px;

            border: 0;

            border-radius: 8px;

            text-decoration: none;

            cursor: pointer;

            font-weight: bold;

        }

        .button-secondary {

            color: #25415e;

            background: #e7edf4;

        }

        .button-primary {

            color: white;

            background: #126bd1;

        }

        .button-gis {

            color: white;

            background: linear-gradient(

                    135deg,

                    #0877e8,

                    #6645c7

            );

        }

        .button-gis:hover {

            background: linear-gradient(

                    135deg,

                    #0664c7,

                    #5233ae

            );

        }

        .readiness-header {

            display: flex;

            justify-content: space-between;

            margin-bottom: 12px;

            font-weight: bold;

        }

        .progress-track {

            height: 15px;

            overflow: hidden;

            border-radius: 20px;

            background: #dfe9f4;

        }

        .progress-fill {

            height: 100%;

            border-radius: 20px;

            background: linear-gradient(

                    90deg,

                    #1473e6,

                    #21b66f);

        }

        .vault-notice {

            margin-top: 17px;

            padding: 14px;

            border-radius: 8px;

            color: #174d83;

            background: #eef6ff;

        }

        .vault-notice a {

            color: #0755b5;

            font-weight: bold;

        }

        .requirement-list {

            display: grid;

            gap: 15px;

            margin-top: 20px;

        }

        .requirement-card {

            padding: 18px;

            border: 1px solid #dce6f1;

            border-radius: 10px;

            background: #fbfdff;

        }

        .requirement-top {

            display: flex;

            justify-content: space-between;

            gap: 12px;

        }

        .requirement-name {

            font-size: 17px;

            font-weight: bold;

        }

        .requirement-description {

            margin: 9px 0;

            color: #53677c;

            line-height: 1.5;

        }

        .badge {

            display: inline-block;

            margin: 4px 5px 0 0;

            padding: 4px 9px;

            border-radius: 20px;

            font-size: 11px;

            font-weight: bold;

        }

        .required-badge {

            color: #a51d1d;

            background: #ffe8e8;

        }

        .optional-badge {

            color: #586776;

            background: #edf1f5;

        }

        .status-badge {

            color: #0755b5;

            background: #e6f1ff;

        }

        .role-badge {

            color: #655000;

            background: #fff5ca;

        }

        .attached-badge {

            color: #17643a;

            background: #e5f8ed;

        }

        .attached-document {

            margin-top: 14px;

            padding: 12px;

            border-radius: 8px;

            color: #17643a;

            background: #eaf9f1;

        }

        .attachment-form {

            display: grid;

            grid-template-columns: 2fr 2fr auto;

            align-items: end;

            gap: 12px;

            margin-top: 15px;

            padding-top: 15px;

            border-top: 1px solid #dce6f1;

        }

        .attach-button {

            height: 44px;

            padding: 0 18px;

            border: 0;

            border-radius: 8px;

            color: white;

            background: #126bd1;

            cursor: pointer;

            font-weight: bold;

        }

        .submit-section {

            margin-top: 23px;

            text-align: right;

        }

        .submit-button {

            padding: 13px 24px;

            border: 0;

            border-radius: 8px;

            color: white;

            background: #169452;

            cursor: pointer;

            font-weight: bold;

        }

        .submit-button:disabled {

            cursor: not-allowed;

            background: #9ba9b7;

        }

        .readiness-warning {

            color: #b45e00;

            font-size: 13px;

        }

        @media (max-width: 800px) {

            .form-grid,

            .attachment-form {

                grid-template-columns: 1fr;

            }

            .full-width {

                grid-column: auto;

            }

            #projectMap {

                height: 350px;

            }

            .form-actions {

                flex-direction: column;

            }

            .button {

                text-align: center;

            }

        }

    </style>

</head>

<body>

<header class="header">

    <h1>Unified Clearance Application</h1>

    <p>

        Environmental, Forest, Wildlife and CRZ clearance

        on one CHAPERON platform.

    </p>

</header>

<main class="container">

    <a class="back-link"

       href="<%= request.getContextPath() %>/entrepreneur/clearances">

        ← Back to clearances

    </a>

    <% if (selectedClearanceType != null) { %>

        <section class="card clearance-summary">

            <span class="clearance-code">

                <%= selectedClearanceType.getClearanceCode() %>

            </span>

            <h2>

                <%= selectedClearanceType.getClearanceName() %>

            </h2>

            <p>

                Fill the project details and select the exact

                project location on the map.

            </p>

        </section>

    <% } %>

    <section class="card">

        <% if (request.getAttribute("errorMessage") != null) { %>

            <div class="message error-message">

                <%= request.getAttribute("errorMessage") %>

            </div>

        <% } %>

        <% if (session.getAttribute("errorMessage") != null) { %>

            <div class="message error-message">

                <%= session.getAttribute("errorMessage") %>

            </div>

            <%

                session.removeAttribute("errorMessage");

            %>

        <% } %>

        <% if (session.getAttribute("successMessage") != null) { %>

            <div class="message success-message">

                <%= session.getAttribute("successMessage") %>

            </div>

            <%

                session.removeAttribute("successMessage");

            %>

        <% } %>

        <form method="post"

              id="clearanceForm"

              action="<%= request.getContextPath() %>/entrepreneur/clearances/new">

            <% if (editMode) { %>

                <input type="hidden"

                       name="applicationId"

                       value="<%= clearanceApplication.getClearanceApplicationId() %>">

            <% } %>

            <input type="hidden"

                   name="clearanceTypeId"

                   value="<%= selectedClearanceType != null

                           ? selectedClearanceType.getClearanceTypeId()

                           : "" %>">

            <input type="hidden"

                   name="boundaryGeoJson"

                   id="boundaryGeoJson">

            <h3 class="section-title">

                1. Project Information

            </h3>

            <div class="form-grid">

                <div class="form-group full-width">

                    <label>Project title *</label>

                    <input type="text"

                           name="projectTitle"

                           maxlength="200"

                           value="<%= projectTitle %>"

                           required>

                </div>

                <div class="form-group full-width">

                    <label>Project description</label>

                    <textarea name="projectDescription"><%= projectDescription %></textarea>

                </div>

                <div class="form-group">

                    <label>State *</label>

                    <input type="text"

                           name="state"

                           value="<%= state %>"

                           required>

                </div>

                <div class="form-group">

                    <label>District *</label>

                    <input type="text"

                           name="district"

                           value="<%= district %>"

                           required>

                </div>

                <div class="form-group full-width">

                    <label>Project location/address *</label>

                    <textarea name="locationAddress"

                              required><%= locationAddress %></textarea>

                </div>

            </div>

            <h3 class="section-title">

                2. Project Location Map

            </h3>

            <div class="map-help">

                Click on the map to select the project location.

                Use the polygon tool to draw the project boundary.

            </div>

            <div id="projectMap"></div>

            <div id="savedMapMessage"

                 class="map-status">

                The previously saved project boundary has been loaded.

            </div>

            <div class="map-actions">

                <button type="button"

                        class="map-button"

                        id="currentLocationButton">

                    Use Current Location

                </button>

                <button type="button"

                        class="map-button"

                        id="clearMapButton">

                    Clear Map

                </button>

            </div>

            <div class="form-grid"

                 style="margin-top:18px;">

                <div class="form-group">

                    <label>Latitude *</label>

                    <input type="number"

                           id="latitude"

                           name="latitude"

                           step="0.0000001"

                           value="<%= latitude %>"

                           readonly

                           required>

                </div>

                <div class="form-group">

                    <label>Longitude *</label>

                    <input type="number"

                           id="longitude"

                           name="longitude"

                           step="0.0000001"

                           value="<%= longitude %>"

                           readonly

                           required>

                </div>

                <div class="form-group">

                    <label>Project area (hectares)</label>

                    <input type="number"

                           id="projectAreaHectares"

                           name="projectAreaHectares"

                           step="0.0001"

                           value="<%= projectArea %>"

                           readonly>

                </div>

            </div>

            <label class="declaration">

                <input type="checkbox"

                       name="applicantDeclaration"

                       value="true"

                       <%= declarationChecked

                               ? "checked"

                               : "" %>>

                <span>

                    I declare that the project and location

                    information provided by me is correct.

                </span>

            </label>

            <div class="form-actions">

                <% if (editMode) { %>

                    <a class="button button-gis"

                       href="<%= request.getContextPath() %>/entrepreneur/gis-screening?applicationId=<%= clearanceApplication.getClearanceApplicationId() %>">

                        Run GIS Screening

                    </a>

                <% } %>

                <a class="button button-secondary"

                   href="<%= request.getContextPath() %>/entrepreneur/clearances">

                    Cancel

                </a>

                <button type="submit"

                        class="button button-primary">

                    Save Draft

                </button>

            </div>

        </form>

    </section>

    <% if (editMode) { %>

        <section class="card">

            <h3 class="section-title">

                3. Requirements and Readiness

            </h3>

            <div class="readiness-header">

                <span>Application readiness</span>

                <span>

                    <%= readinessPercentage %>%

                </span>

            </div>

            <div class="progress-track">

                <div class="progress-fill"

                     style="width:<%= readinessPercentage %>%;">

                </div>

            </div>

            <% if (businessDocuments.isEmpty()) { %>

                <div class="vault-notice">

                    Your Document Vault is empty.

                    <a href="<%= request.getContextPath() %>/entrepreneur/documents">

                        Upload documents in Document Vault

                    </a>

                    before attaching them to requirements.

                </div>

            <% } else { %>

                <div class="vault-notice">

                    Select an existing document from your

                    Document Vault and attach it to the relevant

                    requirement.

                </div>

            <% } %>

            <div class="requirement-list">

                <% if (applicationChecklist.isEmpty()) { %>

                    <div class="requirement-card">

                        No requirements are currently available.

                    </div>

                <% } else { %>

                    <% for (

                        ClearanceApplicationRequirement requirement

                            : applicationChecklist) {

                    %>

                        <article class="requirement-card">

                            <div class="requirement-top">

                                <span class="requirement-name">

                                    <%= requirement.getRequirementName() %>

                                </span>

                                <span class="badge status-badge">

                                    <%= requirement.getRequirementStatus() %>

                                </span>

                            </div>

                            <% if (requirement

                                    .getRequirementDescription() != null) { %>

                                <p class="requirement-description">

                                    <%= requirement.getRequirementDescription() %>

                                </p>

                            <% } %>

                            <% if (requirement.isMandatory()) { %>

                                <span class="badge required-badge">

                                    REQUIRED

                                </span>

                            <% } else { %>

                                <span class="badge optional-badge">

                                    CONDITIONAL

                                </span>

                            <% } %>

                            <span class="badge role-badge">

                                <%= requirement.getResponsibleRole() %>

                            </span>

                            <% if (requirement.getCategory() != null) { %>

                                <span class="badge status-badge">

                                    <%= requirement.getCategory() %>

                                </span>

                            <% } %>

                            <% if (requirement.getDocumentId() != null) { %>

                                <div class="attached-document">

                                    <strong>Attached document:</strong>

                                    <%= requirement.getDocumentType() != null

                                            ? requirement.getDocumentType()

                                            : "Document #" + requirement.getDocumentId() %>

                                    <span class="badge attached-badge">

                                        ATTACHED

                                    </span>

                                </div>

                            <% } %>

                            <% if ("APPLICANT".equalsIgnoreCase(

                                    requirement.getResponsibleRole())) { %>

                                <% if (!businessDocuments.isEmpty()) { %>

                                    <form method="post"

                                          class="attachment-form"

                                          action="<%= request.getContextPath() %>/entrepreneur/clearances/requirements/attach">

                                        <input type="hidden"

                                               name="applicationId"

                                               value="<%= clearanceApplication.getClearanceApplicationId() %>">

                                        <input type="hidden"

                                               name="applicationRequirementId"

                                               value="<%= requirement.getApplicationRequirementId() %>">

                                        <div>

                                            <label>

                                                Select Document

                                            </label>

                                            <select name="documentId"

                                                    required>

                                                <option value="">

                                                    -- Select from Document Vault --

                                                </option>

                                                <% for (

                                                    Document document

                                                        : businessDocuments) {

                                                    if (!document.isActive()) {

                                                        continue;

                                                    }

                                                %>

                                                    <option value="<%= document.getDocumentId() %>"

                                                        <%= requirement.getDocumentId() != null

                                                                && requirement.getDocumentId()

                                                                        .longValue()

                                                                    == document.getDocumentId()

                                                                ? "selected"

                                                                : "" %>>

                                                        <%= document.getDocumentType() %>

                                                        -

                                                        <%= document.getOriginalFileName() %>

                                                    </option>

                                                <% } %>

                                            </select>

                                        </div>

                                        <div>

                                            <label>

                                                Applicant remarks

                                            </label>

                                            <input type="text"

                                                   name="applicantRemarks"

                                                   maxlength="500"

                                                   value="<%= requirement.getApplicantRemarks() != null

                                                           ? requirement.getApplicantRemarks()

                                                           : "" %>"

                                                   placeholder="Optional remarks">

                                        </div>

                                        <button type="submit"

                                                class="attach-button">

                                            <%= requirement.getDocumentId() == null

                                                    ? "Attach Document"

                                                    : "Replace Document" %>

                                        </button>

                                    </form>

                                <% } %>

                            <% } else { %>

                                <div class="vault-notice">

                                    This requirement will be completed by:

                                    <strong>

                                        <%= requirement.getResponsibleRole() %>

                                    </strong>

                                </div>

                            <% } %>

                        </article>

                    <% } %>

                <% } %>

            </div>

            <div class="submit-section">

                <form method="post"

                      action="<%= request.getContextPath() %>/entrepreneur/clearances/submit"

                      onsubmit="return confirm('Submit this application for official review?');">

                    <input type="hidden"

                           name="applicationId"

                           value="<%= clearanceApplication.getClearanceApplicationId() %>">

                    <button type="submit"

                            class="submit-button"

                            <%= readinessPercentage < 100

                                    ? "disabled"

                                    : "" %>>

                        Submit Application

                    </button>

                </form>

                <% if (readinessPercentage < 100) { %>

                    <p class="readiness-warning">

                        Complete all mandatory applicant requirements

                        before submission.

                    </p>

                <% } %>

            </div>

        </section>

    <% } %>

</main>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

<script src="https://unpkg.com/leaflet-draw@1.0.4/dist/leaflet.draw.js"></script>

<script>

    const savedBoundaryGeoJson =

        '<%= savedGeoJson %>';

    const latitudeInput =

        document.getElementById("latitude");

    const longitudeInput =

        document.getElementById("longitude");

    const areaInput =

        document.getElementById(

            "projectAreaHectares");

    const geoJsonInput =

        document.getElementById(

            "boundaryGeoJson");

    const savedMapMessage =

        document.getElementById(

            "savedMapMessage");

    const existingLatitude =

        parseFloat(latitudeInput.value);

    const existingLongitude =

        parseFloat(longitudeInput.value);

    const defaultLatitude =

        Number.isFinite(existingLatitude)

            ? existingLatitude

            : 22.9734;

    const defaultLongitude =

        Number.isFinite(existingLongitude)

            ? existingLongitude

            : 78.6569;

    const defaultZoom =

        Number.isFinite(existingLatitude)

        && Number.isFinite(existingLongitude)

            ? 15

            : 5;

    const map =

        L.map("projectMap").setView(

            [

                defaultLatitude,

                defaultLongitude

            ],

            defaultZoom

        );

    L.tileLayer(

        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",

        {

            maxZoom: 19,

            attribution:

                "&copy; OpenStreetMap contributors"

        }

    ).addTo(map);

    let projectMarker = null;

    const drawnItems =

        new L.FeatureGroup();

    map.addLayer(drawnItems);

    const drawControl =

        new L.Control.Draw({

            edit: {

                featureGroup: drawnItems,

                remove: true

            },

            draw: {

                polygon: {

                    allowIntersection: false,

                    showArea: true

                },

                rectangle: {

                    showArea: true

                },

                marker: false,

                circle: false,

                circlemarker: false,

                polyline: false

            }

        });

    map.addControl(drawControl);

    function setProjectMarker(latitude, longitude) {

        if (projectMarker !== null) {

            map.removeLayer(projectMarker);

        }

        projectMarker =

            L.marker([latitude, longitude])

                .addTo(map)

                .bindPopup("Project location");

        latitudeInput.value =

            Number(latitude).toFixed(7);

        longitudeInput.value =

            Number(longitude).toFixed(7);

    }

    function calculateLayerArea(layer) {

        if (!layer.getLatLngs) {

            return;

        }

        let latLngs =

            layer.getLatLngs();

        if (latLngs.length > 0

                && Array.isArray(latLngs[0])) {

            latLngs = latLngs[0];

        }

        if (latLngs.length < 3) {

            return;

        }

        const squareMetres =

            L.GeometryUtil.geodesicArea(

                latLngs);

        areaInput.value =

            (squareMetres / 10000)

                .toFixed(4);

    }

    function updateGeoJsonField() {

        let boundary = null;

        drawnItems.eachLayer(

            function (layer) {

                if (boundary === null) {

                    boundary =

                        layer.toGeoJSON();

                }

            }

        );

        geoJsonInput.value =

            boundary === null

                ? ""

                : JSON.stringify(boundary);

    }

    if (Number.isFinite(existingLatitude)

            && Number.isFinite(existingLongitude)) {

        setProjectMarker(

            existingLatitude,

            existingLongitude);

    }

    if (savedBoundaryGeoJson !== "") {

        try {

            const parsedBoundary =

                JSON.parse(

                    savedBoundaryGeoJson);

            const savedLayer =

                L.geoJSON(

                    parsedBoundary);

            savedLayer.eachLayer(

                function (layer) {

                    drawnItems.addLayer(layer);

                    calculateLayerArea(layer);

                }

            );

            geoJsonInput.value =

                savedBoundaryGeoJson;

            const bounds =

                drawnItems.getBounds();

            if (bounds.isValid()) {

                map.fitBounds(

                    bounds,

                    {

                        padding: [25, 25]

                    });

            }

            savedMapMessage

                .classList

                .add("visible");

        } catch (error) {

            console.error(

                "Saved boundary could not be loaded.",

                error);

        }

    }

    map.on(

        "click",

        function (event) {

            setProjectMarker(

                event.latlng.lat,

                event.latlng.lng);

        }

    );

    map.on(

        L.Draw.Event.CREATED,

        function (event) {

            drawnItems.clearLayers();

            const layer =

                event.layer;

            drawnItems.addLayer(layer);

            calculateLayerArea(layer);

            const centre =

                layer.getBounds()

                    .getCenter();

            setProjectMarker(

                centre.lat,

                centre.lng);

            updateGeoJsonField();

            savedMapMessage

                .classList

                .remove("visible");

        }

    );

    map.on(

        L.Draw.Event.EDITED,

        function (event) {

            event.layers.eachLayer(

                function (layer) {

                    calculateLayerArea(layer);

                    const centre =

                        layer.getBounds()

                            .getCenter();

                    setProjectMarker(

                        centre.lat,

                        centre.lng);

                }

            );

            updateGeoJsonField();

        }

    );

    map.on(

        L.Draw.Event.DELETED,

        function () {

            updateGeoJsonField();

            if (drawnItems.getLayers().length === 0) {

                areaInput.value = "";

            }

        }

    );

    document.getElementById(

        "currentLocationButton"

    ).addEventListener(

        "click",

        function () {

            if (!navigator.geolocation) {

                alert(

                    "Your browser does not support geolocation.");

                return;

            }

            navigator.geolocation

                .getCurrentPosition(

                    function (position) {

                        const currentLatitude =

                            position.coords.latitude;

                        const currentLongitude =

                            position.coords.longitude;

                        map.setView(

                            [

                                currentLatitude,

                                currentLongitude

                            ],

                            16);

                        setProjectMarker(

                            currentLatitude,

                            currentLongitude);

                    },

                    function () {

                        alert(

                            "Current location could not be accessed.");

                    }

                );

        }

    );

    document.getElementById(

        "clearMapButton"

    ).addEventListener(

        "click",

        function () {

            if (projectMarker !== null) {

                map.removeLayer(projectMarker);

                projectMarker = null;

            }

            drawnItems.clearLayers();

            latitudeInput.value = "";

            longitudeInput.value = "";

            areaInput.value = "";

            geoJsonInput.value = "";

            savedMapMessage

                .classList

                .remove("visible");

        }

    );

    document.getElementById(

        "clearanceForm"

    ).addEventListener(

        "submit",

        function (event) {

            if (latitudeInput.value === ""

                    || longitudeInput.value === "") {

                event.preventDefault();

                alert(

                    "Please select the project location on the map.");

                return;

            }

            updateGeoJsonField();

        }

    );

    window.setTimeout(

        function () {

            map.invalidateSize();

        },

        250

    );

</script>

</body>

</html>
