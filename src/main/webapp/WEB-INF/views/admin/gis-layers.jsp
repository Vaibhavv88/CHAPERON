<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>GIS Layer Management | CHAPERON</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f3f7fc;
            color: #102b52;
        }

        a {
            text-decoration: none;
        }

        .topbar {
            min-height: 76px;
            background: #ffffff;
            border-bottom: 1px solid #dce7f3;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 34px;
            position: sticky;
            top: 0;
            z-index: 20;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .brand-icon {
            width: 44px;
            height: 44px;
            border-radius: 13px;
            background: linear-gradient(135deg, #0877ee, #2352bd);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-weight: 800;
            font-size: 20px;
        }

        .brand h1 {
            font-size: 22px;
            color: #082957;
        }

        .brand p {
            margin-top: 3px;
            color: #7589a5;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.6px;
        }

        .top-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .nav-link {
            background: #edf5ff;
            color: #075fc8;
            border-radius: 10px;
            padding: 11px 16px;
            font-size: 14px;
            font-weight: 700;
        }

        .nav-link:hover {
            background: #dcecff;
        }

        .page {
            width: min(1480px, 95%);
            margin: 28px auto 60px;
        }

        .hero {
            background:
                linear-gradient(120deg, #ffffff 35%, #e7f3ff);
            border: 1px solid #d8e7f6;
            border-radius: 22px;
            padding: 28px 32px;
            box-shadow: 0 12px 35px rgba(20, 66, 115, 0.08);
        }

        .eyebrow {
            color: #0872e5;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 1px;
            margin-bottom: 9px;
        }

        .hero h2 {
            font-size: 30px;
            line-height: 1.25;
            color: #092854;
        }

        .hero-description {
            margin-top: 10px;
            max-width: 920px;
            color: #617793;
            font-size: 15px;
            line-height: 1.7;
        }

        .warning-note {
            margin-top: 18px;
            padding: 13px 16px;
            border-radius: 10px;
            background: #fff8df;
            border: 1px solid #f2dfa0;
            color: #775700;
            font-size: 13px;
            line-height: 1.6;
        }

        .summary-row {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        .summary-pill {
            padding: 9px 14px;
            background: #ffffff;
            border: 1px solid #d7e6f6;
            border-radius: 100px;
            font-size: 13px;
            font-weight: 700;
            color: #24517f;
        }

        .message {
            margin-top: 22px;
            padding: 15px 18px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 700;
        }

        .message-success {
            background: #e8f8ee;
            border: 1px solid #a5dbb8;
            color: #087331;
        }

        .message-error {
            background: #fff0ef;
            border: 1px solid #f0b8b3;
            color: #b42318;
        }

        .main-grid {
            display: grid;
            grid-template-columns: minmax(370px, 0.82fr)
                                   minmax(550px, 1.65fr);
            gap: 22px;
            align-items: start;
            margin-top: 22px;
        }

        .card {
            background: #ffffff;
            border: 1px solid #dbe7f3;
            border-radius: 18px;
            box-shadow: 0 10px 28px rgba(27, 67, 112, 0.07);
            overflow: hidden;
        }

        .card-header {
            padding: 22px 24px 17px;
            border-bottom: 1px solid #e6eef7;
        }

        .card-header h3 {
            font-size: 20px;
            color: #0b2c59;
        }

        .card-header p {
            margin-top: 7px;
            font-size: 13px;
            line-height: 1.6;
            color: #70839d;
        }

        .card-body {
            padding: 22px 24px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        .form-label {
            font-size: 13px;
            font-weight: 700;
            color: #173a66;
        }

        .required {
            color: #dc2626;
        }

        .form-control {
            width: 100%;
            min-height: 44px;
            padding: 11px 12px;
            border-radius: 9px;
            border: 1px solid #cbd9e8;
            background: #ffffff;
            color: #17375f;
            outline: none;
            font-size: 14px;
        }

        textarea.form-control {
            min-height: 92px;
            resize: vertical;
            font-family: inherit;
        }

        .form-control:focus {
            border-color: #1682ef;
            box-shadow: 0 0 0 3px rgba(22, 130, 239, 0.12);
        }

        .field-note {
            font-size: 11px;
            line-height: 1.5;
            color: #8192a8;
        }

        .file-box {
            background: #f4f9ff;
            border: 2px dashed #a8cbed;
            border-radius: 12px;
            padding: 18px;
        }

        .checkbox-row {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 14px;
            background: #f4f8fc;
            border-radius: 10px;
        }

        .checkbox-row input {
            width: 18px;
            height: 18px;
            margin-top: 1px;
        }

        .checkbox-row label {
            font-size: 13px;
            color: #34516f;
            line-height: 1.5;
        }

        .primary-button {
            width: 100%;
            border: 0;
            border-radius: 10px;
            padding: 13px 20px;
            background: linear-gradient(135deg, #087cf0, #0758cc);
            color: #ffffff;
            font-size: 14px;
            font-weight: 800;
            cursor: pointer;
        }

        .primary-button:hover {
            background: linear-gradient(135deg, #076ad2, #0647a6);
        }

        .layer-list {
            display: flex;
            flex-direction: column;
            gap: 13px;
        }

        .empty-state {
            padding: 40px 20px;
            text-align: center;
            border: 1px dashed #bbcee2;
            background: #f8fbff;
            border-radius: 12px;
            color: #71859e;
            line-height: 1.7;
        }

        .layer-item {
            border: 1px solid #d8e5f2;
            border-radius: 13px;
            padding: 17px;
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 14px;
            transition: 0.2s;
        }

        .layer-item:hover {
            border-color: #8fc1ef;
            box-shadow: 0 7px 20px rgba(28, 91, 151, 0.08);
        }

        .layer-item.selected {
            border-color: #1682ef;
            background: #f2f8ff;
        }

        .layer-title-row {
            display: flex;
            gap: 9px;
            align-items: center;
            flex-wrap: wrap;
        }

        .layer-name {
            color: #0b2d5a;
            font-weight: 800;
            font-size: 16px;
        }

        .code {
            font-size: 11px;
            padding: 5px 8px;
            border-radius: 6px;
            background: #eaf3fd;
            color: #0a5cb8;
            font-weight: 800;
        }

        .layer-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 8px 16px;
            margin-top: 10px;
            color: #6d8199;
            font-size: 12px;
        }

        .layer-source {
            margin-top: 10px;
            color: #4e6680;
            font-size: 13px;
            line-height: 1.5;
        }

        .item-actions {
            min-width: 128px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .view-button,
        .status-button {
            border: 0;
            border-radius: 8px;
            padding: 9px 12px;
            font-size: 12px;
            font-weight: 800;
            text-align: center;
            cursor: pointer;
        }

        .view-button {
            background: #e8f3ff;
            color: #075fc4;
        }

        .disable-button {
            background: #fff0e6;
            color: #b54c00;
        }

        .enable-button {
            background: #e4f8eb;
            color: #087634;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            padding: 5px 9px;
            border-radius: 50px;
            font-size: 11px;
            font-weight: 800;
        }

        .badge-active {
            background: #ddf7e7;
            color: #087535;
        }

        .badge-inactive {
            background: #eef1f5;
            color: #67778a;
        }

        .badge-category {
            background: #e8efff;
            color: #3f51aa;
        }

        .details-card {
            margin-top: 22px;
        }

        .detail-summary {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
        }

        .detail-box {
            padding: 15px;
            border-radius: 10px;
            background: #f5f9fd;
            border: 1px solid #e0eaf4;
        }

        .detail-box span {
            display: block;
            font-size: 11px;
            color: #7589a0;
            font-weight: 700;
            margin-bottom: 7px;
        }

        .detail-box strong {
            color: #173b68;
            font-size: 13px;
            overflow-wrap: anywhere;
        }

        .feature-heading {
            margin: 23px 0 13px;
            font-size: 17px;
            color: #123664;
        }

        .table-container {
            overflow-x: auto;
            border: 1px solid #dce7f2;
            border-radius: 12px;
        }

        table {
            width: 100%;
            min-width: 850px;
            border-collapse: collapse;
        }

        th {
            background: #eef5fc;
            color: #345370;
            padding: 13px 12px;
            text-align: left;
            font-size: 12px;
            white-space: nowrap;
        }

        td {
            padding: 13px 12px;
            border-top: 1px solid #e4edf6;
            color: #4d657e;
            font-size: 12px;
            vertical-align: middle;
        }

        .small-form {
            display: inline;
        }

        .small-button {
            border: 0;
            padding: 7px 10px;
            border-radius: 7px;
            cursor: pointer;
            font-size: 11px;
            font-weight: 800;
        }

        .official-note {
            margin-top: 18px;
            border-left: 4px solid #087cf0;
            padding: 13px 15px;
            background: #edf6ff;
            color: #315675;
            font-size: 12px;
            line-height: 1.7;
        }

        @media (max-width: 1050px) {
            .main-grid {
                grid-template-columns: 1fr;
            }

            .detail-summary {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 680px) {
            .topbar {
                padding: 13px 16px;
                align-items: flex-start;
                flex-direction: column;
            }

            .page {
                width: 94%;
                margin-top: 18px;
            }

            .hero {
                padding: 22px 20px;
            }

            .hero h2 {
                font-size: 24px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full {
                grid-column: auto;
            }

            .layer-item {
                grid-template-columns: 1fr;
            }

            .item-actions {
                flex-direction: row;
            }

            .detail-summary {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<c:url var="gisLayersUrl"
       value="/admin/gis-layers"/>

<header class="topbar">

    <div class="brand">
        <div class="brand-icon">C</div>

        <div>
            <h1>CHAPERON Admin</h1>
            <p>GIS AND SPATIAL SCREENING MANAGEMENT</p>
        </div>
    </div>

    <nav class="top-actions">
        <a class="nav-link"
           href="${pageContext.request.contextPath}/admin/dashboard">
            Dashboard
        </a>

        <a class="nav-link"
           href="${pageContext.request.contextPath}/admin/approvals">
            Approvals
        </a>

        <a class="nav-link"
           href="${pageContext.request.contextPath}/admin/gis-layers">
            GIS Layers
        </a>
    </nav>

</header>

<main class="page">

    <section class="hero">

        <div class="eyebrow">
            ALL-INDIA SPATIAL DATA MANAGEMENT
        </div>

        <h2>Official GIS Layer Management</h2>

        <p class="hero-description">
            Upload verified GeoJSON boundaries for forest land,
            protected areas, eco-sensitive zones, CRZ areas,
            settlements and other regulatory zones. These layers
            will be used to screen entrepreneur project boundaries
            and generate clearance recommendations.
        </p>

        <div class="warning-note">
            Upload only authorised or officially sourced spatial
            data. GIS results are system-generated screening
            recommendations and remain subject to verification by
            the concerned government officer.
        </div>

        <div class="summary-row">

            <div class="summary-pill">
                ${empty gisLayers ? 0 : gisLayers.size()}
                GIS layers
            </div>

            <div class="summary-pill">
                Coordinate system: EPSG:4326
            </div>

            <div class="summary-pill">
                Coverage: All India + State/District
            </div>

        </div>

    </section>

    <c:if test="${not empty successMessage}">
        <div class="message message-success">
            ${successMessage}
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="message message-error">
            ${errorMessage}
        </div>
    </c:if>

    <section class="main-grid">

        <!-- Upload form -->
        <div class="card">

            <div class="card-header">
                <h3>Upload Official GIS Layer</h3>

                <p>
                    Supported geometry types: Polygon and
                    MultiPolygon. Maximum file size: 50 MB.
                </p>
            </div>

            <div class="card-body">

                <form method="post"
                      action="${gisLayersUrl}"
                      enctype="multipart/form-data">

                    <input type="hidden"
                           name="action"
                           value="upload">

                    <div class="form-grid">

                        <div class="form-group">
                            <label class="form-label"
                                   for="layerCode">
                                Layer code
                                <span class="required">*</span>
                            </label>

                            <input class="form-control"
                                   type="text"
                                   id="layerCode"
                                   name="layerCode"
                                   maxlength="120"
                                   placeholder="Example: INDIA_FOREST_2026"
                                   required>

                            <div class="field-note">
                                Unique code for this layer.
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label"
                                   for="layerCategory">
                                Layer category
                                <span class="required">*</span>
                            </label>

                            <select class="form-control"
                                    id="layerCategory"
                                    name="layerCategory"
                                    required>

                                <option value="">
                                    -- Select category --
                                </option>

                                <option value="FOREST">
                                    Forest Land
                                </option>

                                <option value="PROTECTED_AREA">
                                    Protected Area
                                </option>

                                <option value="ECO_SENSITIVE_ZONE">
                                    Eco-Sensitive Zone
                                </option>

                                <option value="CRZ">
                                    Coastal Regulation Zone
                                </option>

                                <option value="SETTLEMENT">
                                    Settlement / Habitation
                                </option>

                                <option value="WETLAND">
                                    Wetland
                                </option>

                                <option value="GROUNDWATER">
                                    Groundwater Regulatory Zone
                                </option>

                                <option value="INDUSTRIAL_AREA">
                                    Industrial Area
                                </option>

                                <option value="OTHER">
                                    Other Regulatory Layer
                                </option>

                            </select>
                        </div>

                        <div class="form-group full">
                            <label class="form-label"
                                   for="layerName">
                                Layer name
                                <span class="required">*</span>
                            </label>

                            <input class="form-control"
                                   type="text"
                                   id="layerName"
                                   name="layerName"
                                   maxlength="250"
                                   placeholder="Official descriptive layer name"
                                   required>
                        </div>

                        <div class="form-group full">
                            <label class="form-label"
                                   for="description">
                                Description
                            </label>

                            <textarea class="form-control"
                                      id="description"
                                      name="description"
                                      placeholder="Describe what this layer represents"></textarea>
                        </div>

                        <div class="form-group">
                            <label class="form-label"
                                   for="sourceAuthority">
                                Source authority
                                <span class="required">*</span>
                            </label>

                            <input class="form-control"
                                   type="text"
                                   id="sourceAuthority"
                                   name="sourceAuthority"
                                   maxlength="250"
                                   placeholder="Example: State Forest Department"
                                   required>
                        </div>

                        <div class="form-group">
                            <label class="form-label"
                                   for="dataSource">
                                Data source
                                <span class="required">*</span>
                            </label>

                            <input class="form-control"
                                   type="text"
                                   id="dataSource"
                                   name="dataSource"
                                   maxlength="500"
                                   placeholder="Portal, notification or dataset URL"
                                   required>
                        </div>

                        <div class="form-group">
                            <label class="form-label"
                                   for="sourceVersion">
                                Source version
                            </label>

                            <input class="form-control"
                                   type="text"
                                   id="sourceVersion"
                                   name="sourceVersion"
                                   maxlength="100"
                                   placeholder="Example: 2026.1">
                        </div>

                        <div class="form-group">
                            <label class="form-label"
                                   for="sourceDate">
                                Source publication date
                            </label>

                            <input class="form-control"
                                   type="date"
                                   id="sourceDate"
                                   name="sourceDate">
                        </div>

                        <div class="form-group">
                            <label class="form-label"
                                   for="stateName">
                                State coverage
                            </label>

                            <input class="form-control"
                                   type="text"
                                   id="stateName"
                                   name="stateName"
                                   maxlength="150"
                                   placeholder="Leave empty for All India">

                            <div class="field-note">
                                Empty state means All-India coverage.
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label"
                                   for="districtName">
                                District coverage
                            </label>

                            <input class="form-control"
                                   type="text"
                                   id="districtName"
                                   name="districtName"
                                   maxlength="150"
                                   placeholder="Optional district">
                        </div>

                        <div class="form-group full">
                            <div class="file-box">

                                <label class="form-label"
                                       for="geoJsonFile">
                                    Official GeoJSON file
                                    <span class="required">*</span>
                                </label>

                                <input class="form-control"
                                       type="file"
                                       id="geoJsonFile"
                                       name="geoJsonFile"
                                       accept=".geojson,.json,application/geo+json,application/json"
                                       required>

                                <div class="field-note"
                                     style="margin-top: 8px;">
                                    Coordinates must use WGS84
                                    longitude/latitude (EPSG:4326).
                                </div>

                            </div>
                        </div>

                        <div class="form-group full">
                            <div class="checkbox-row">

                                <input type="checkbox"
                                       id="active"
                                       name="active"
                                       value="true"
                                       checked>

                                <label for="active">
                                    Activate this layer after successful
                                    import. Keep this unchecked if an
                                    officer must verify the data first.
                                </label>

                            </div>
                        </div>

                        <div class="form-group full">
                            <button class="primary-button"
                                    type="submit"
                                    id="uploadButton">
                                Upload and Import GIS Layer
                            </button>
                        </div>

                    </div>

                </form>

                <div class="official-note">
                    Recommended official sources include Forest Survey
                    of India, State Forest Departments, MoEFCC,
                    PARIVESH, NCSCM, State CZMAs, NRSC Bhuvan,
                    Survey of India and authorised government datasets.
                </div>

            </div>
        </div>

        <!-- Existing layers -->
        <div class="card">

            <div class="card-header">
                <h3>Available GIS Layers</h3>

                <p>
                    Active layers can participate in project spatial
                    screening and clearance recommendation generation.
                </p>
            </div>

            <div class="card-body">

                <c:choose>

                    <c:when test="${empty gisLayers}">
                        <div class="empty-state">
                            No GIS layer has been uploaded yet.<br>
                            Upload the first official GeoJSON layer
                            using the form.
                        </div>
                    </c:when>

                    <c:otherwise>

                        <div class="layer-list">

                            <c:forEach var="layer"
                                       items="${gisLayers}">

                                <div class="layer-item
                                     ${not empty selectedLayer
                                     and selectedLayer.gisLayerId
                                     eq layer.gisLayerId
                                     ? 'selected' : ''}">

                                    <div>

                                        <div class="layer-title-row">

                                            <span class="layer-name">
                                                <c:out value="${layer.layerName}"/>
                                            </span>

                                            <span class="code">
                                                <c:out value="${layer.layerCode}"/>
                                            </span>

                                            <span class="badge badge-category">
                                                <c:out value="${layer.layerCategory}"/>
                                            </span>

                                            <c:choose>
                                                <c:when test="${layer.active}">
                                                    <span class="badge badge-active">
                                                        ACTIVE
                                                    </span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="badge badge-inactive">
                                                        INACTIVE
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>

                                        </div>

                                        <div class="layer-meta">
                                            <span>
                                                Coverage:
                                                <strong>
                                                    <c:out value="${layer.coverageLabel}"/>
                                                </strong>
                                            </span>

                                            <span>
                                                Features:
                                                <strong>
                                                    ${layer.featureCount}
                                                </strong>
                                            </span>

                                            <span>
                                                CRS:
                                                <strong>
                                                    <c:out value="${layer.coordinateSystem}"/>
                                                </strong>
                                            </span>
                                        </div>

                                        <div class="layer-source">
                                            Authority:
                                            <strong>
                                                <c:out value="${layer.sourceAuthority}"/>
                                            </strong>
                                        </div>

                                    </div>

                                    <div class="item-actions">

                                        <a class="view-button"
                                           href="${gisLayersUrl}?layerId=${layer.gisLayerId}">
                                            View Features
                                        </a>

                                        <form method="post"
                                              action="${gisLayersUrl}">

                                            <input type="hidden"
                                                   name="action"
                                                   value="toggle-layer">

                                            <input type="hidden"
                                                   name="layerId"
                                                   value="${layer.gisLayerId}">

                                            <input type="hidden"
                                                   name="active"
                                                   value="${not layer.active}">

                                            <c:choose>
                                                <c:when test="${layer.active}">
                                                    <button type="submit"
                                                            class="status-button disable-button">
                                                        Deactivate
                                                    </button>
                                                </c:when>

                                                <c:otherwise>
                                                    <button type="submit"
                                                            class="status-button enable-button">
                                                        Activate
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>

                                        </form>

                                    </div>

                                </div>

                            </c:forEach>

                        </div>

                    </c:otherwise>

                </c:choose>

            </div>
        </div>

    </section>

    <!-- Selected layer details -->
    <c:if test="${not empty selectedLayer}">

        <section class="card details-card">

            <div class="card-header">
                <h3>
                    <c:out value="${selectedLayer.layerName}"/>
                    — Imported Features
                </h3>

                <p>
                    Review individual boundaries before using this
                    layer in automatic project screening.
                </p>
            </div>

            <div class="card-body">

                <div class="detail-summary">

                    <div class="detail-box">
                        <span>LAYER CODE</span>
                        <strong>
                            <c:out value="${selectedLayer.layerCode}"/>
                        </strong>
                    </div>

                    <div class="detail-box">
                        <span>CATEGORY</span>
                        <strong>
                            <c:out value="${selectedLayer.layerCategory}"/>
                        </strong>
                    </div>

                    <div class="detail-box">
                        <span>COVERAGE</span>
                        <strong>
                            <c:out value="${selectedLayer.coverageLabel}"/>
                        </strong>
                    </div>

                    <div class="detail-box">
                        <span>FEATURE COUNT</span>
                        <strong>
                            ${selectedLayer.featureCount}
                        </strong>
                    </div>

                </div>

                <h4 class="feature-heading">
                    Boundary Features
                </h4>

                <c:choose>

                    <c:when test="${empty selectedLayerFeatures}">
                        <div class="empty-state">
                            This GIS layer currently has no imported
                            Polygon or MultiPolygon features.
                        </div>
                    </c:when>

                    <c:otherwise>

                        <div class="table-container">

                            <table>
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Feature code</th>
                                    <th>Feature name</th>
                                    <th>Feature type</th>
                                    <th>State</th>
                                    <th>District</th>
                                    <th>Area (hectares)</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                                </thead>

                                <tbody>

                                <c:forEach var="feature"
                                           items="${selectedLayerFeatures}">

                                    <tr>
                                        <td>
                                            ${feature.gisFeatureId}
                                        </td>

                                        <td>
                                            <strong>
                                                <c:out value="${feature.featureCode}"/>
                                            </strong>
                                        </td>

                                        <td>
                                            <c:out value="${feature.featureName}"/>
                                        </td>

                                        <td>
                                            <c:out value="${feature.featureType}"/>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${empty feature.stateName}">
                                                    All India
                                                </c:when>

                                                <c:otherwise>
                                                    <c:out value="${feature.stateName}"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${empty feature.districtName}">
                                                    —
                                                </c:when>

                                                <c:otherwise>
                                                    <c:out value="${feature.districtName}"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${empty feature.calculatedAreaHectares}">
                                                    —
                                                </c:when>

                                                <c:otherwise>
                                                    ${feature.calculatedAreaHectares}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${feature.active}">
                                                    <span class="badge badge-active">
                                                        ACTIVE
                                                    </span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="badge badge-inactive">
                                                        INACTIVE
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <form class="small-form"
                                                  method="post"
                                                  action="${gisLayersUrl}">

                                                <input type="hidden"
                                                       name="action"
                                                       value="toggle-feature">

                                                <input type="hidden"
                                                       name="featureId"
                                                       value="${feature.gisFeatureId}">

                                                <input type="hidden"
                                                       name="layerId"
                                                       value="${selectedLayer.gisLayerId}">

                                                <input type="hidden"
                                                       name="active"
                                                       value="${not feature.active}">

                                                <c:choose>
                                                    <c:when test="${feature.active}">
                                                        <button type="submit"
                                                                class="small-button disable-button">
                                                            Disable
                                                        </button>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <button type="submit"
                                                                class="small-button enable-button">
                                                            Enable
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>

                                            </form>
                                        </td>
                                    </tr>

                                </c:forEach>

                                </tbody>
                            </table>

                        </div>

                    </c:otherwise>

                </c:choose>

            </div>
        </section>

    </c:if>

</main>

<script>
    const uploadForm = document.querySelector(
        'form[enctype="multipart/form-data"]'
    );

    const uploadButton = document.getElementById(
        'uploadButton'
    );

    const geoJsonFile = document.getElementById(
        'geoJsonFile'
    );

    uploadForm.addEventListener('submit', function (event) {
        const file = geoJsonFile.files[0];

        if (!file) {
            event.preventDefault();
            alert('Please select a GeoJSON file.');
            return;
        }

        const fileName = file.name.toLowerCase();

        if (!fileName.endsWith('.geojson')
                && !fileName.endsWith('.json')) {

            event.preventDefault();

            alert(
                'Only .geojson or .json files are supported.'
            );

            return;
        }

        const maximumSize = 50 * 1024 * 1024;

        if (file.size > maximumSize) {
            event.preventDefault();

            alert(
                'GeoJSON file size cannot exceed 50 MB.'
            );

            return;
        }

        uploadButton.disabled = true;
        uploadButton.textContent = 'Importing GIS Layer...';
    });
</script>

</body>
</html>