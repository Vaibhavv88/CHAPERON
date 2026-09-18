package com.chaperon.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import com.chaperon.dao.GisLayerDAO;
import com.chaperon.dao.impl.GisLayerDAOImpl;
import com.chaperon.model.GisFeature;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class GeoJsonImportService {

    private final GisLayerDAO gisLayerDAO;

    /*
     * Default constructor.
     */
    public GeoJsonImportService() {
        this.gisLayerDAO = new GisLayerDAOImpl();
    }

    /*
     * Constructor used by AdminGisLayerServlet.
     */
    public GeoJsonImportService(GisLayerDAO gisLayerDAO) {

        if (gisLayerDAO == null) {
            throw new IllegalArgumentException(
                    "GisLayerDAO cannot be null."
            );
        }

        this.gisLayerDAO = gisLayerDAO;
    }

    public ImportResult importGeoJson(
            long gisLayerId,
            String geoJsonText,
            String defaultStateName,
            String defaultDistrictName
    ) throws SQLException {

        if (gisLayerId <= 0) {
            throw new IllegalArgumentException(
                    "Valid GIS layer ID is required."
            );
        }

        if (geoJsonText == null || geoJsonText.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "GeoJSON data cannot be empty."
            );
        }

        JsonElement rootElement;

        try {
            rootElement = JsonParser.parseString(geoJsonText);
        } catch (Exception exception) {
            throw new IllegalArgumentException(
                    "Invalid GeoJSON JSON format.",
                    exception
            );
        }

        if (!rootElement.isJsonObject()) {
            throw new IllegalArgumentException(
                    "GeoJSON root must be a JSON object."
            );
        }

        JsonObject rootObject = rootElement.getAsJsonObject();

        String rootType = getString(rootObject, "type");

        if (rootType == null) {
            throw new IllegalArgumentException(
                    "GeoJSON type is missing."
            );
        }

        List<GisFeature> features = new ArrayList<>();

        int skippedCount = 0;

        if ("FeatureCollection".equalsIgnoreCase(rootType)) {

            JsonElement featuresElement = rootObject.get("features");

            if (featuresElement == null
                    || !featuresElement.isJsonArray()) {

                throw new IllegalArgumentException(
                        "FeatureCollection must contain a features array."
                );
            }

            JsonArray featureArray =
                    featuresElement.getAsJsonArray();

            int featureNumber = 1;

            for (JsonElement element : featureArray) {

                if (element == null || !element.isJsonObject()) {
                    skippedCount++;
                    featureNumber++;
                    continue;
                }

                GisFeature feature = createFeature(
                        gisLayerId,
                        element.getAsJsonObject(),
                        featureNumber,
                        defaultStateName,
                        defaultDistrictName
                );

                if (feature != null) {
                    features.add(feature);
                } else {
                    skippedCount++;
                }

                featureNumber++;
            }

        } else if ("Feature".equalsIgnoreCase(rootType)) {

            GisFeature feature = createFeature(
                    gisLayerId,
                    rootObject,
                    1,
                    defaultStateName,
                    defaultDistrictName
            );

            if (feature != null) {
                features.add(feature);
            } else {
                skippedCount++;
            }

        } else if ("Polygon".equalsIgnoreCase(rootType)
                || "MultiPolygon".equalsIgnoreCase(rootType)) {

            GisFeature feature = createGeometryFeature(
                    gisLayerId,
                    rootObject,
                    1,
                    defaultStateName,
                    defaultDistrictName
            );

            features.add(feature);

        } else {
            throw new IllegalArgumentException(
                    "Only FeatureCollection, Feature, Polygon and "
                    + "MultiPolygon GeoJSON are supported."
            );
        }

        if (features.isEmpty()) {
            throw new IllegalArgumentException(
                    "No valid Polygon or MultiPolygon feature was found."
            );
        }

        gisLayerDAO.saveFeatures(features);

        return new ImportResult(
                features.size(),
                skippedCount,
                features.size() + skippedCount
        );
    }

    private GisFeature createFeature(
            long gisLayerId,
            JsonObject featureObject,
            int featureNumber,
            String defaultStateName,
            String defaultDistrictName
    ) {

        String objectType = getString(featureObject, "type");

        if (!"Feature".equalsIgnoreCase(objectType)) {
            return null;
        }

        JsonElement geometryElement =
                featureObject.get("geometry");

        if (geometryElement == null
                || geometryElement.isJsonNull()
                || !geometryElement.isJsonObject()) {
            return null;
        }

        JsonObject geometryObject =
                geometryElement.getAsJsonObject();

        String geometryType =
                getString(geometryObject, "type");

        if (!isSupportedGeometry(geometryType)) {
            return null;
        }

        validateCoordinates(geometryObject);

        JsonObject properties = null;

        JsonElement propertiesElement =
                featureObject.get("properties");

        if (propertiesElement != null
                && !propertiesElement.isJsonNull()
                && propertiesElement.isJsonObject()) {

            properties = propertiesElement.getAsJsonObject();
        }

        String featureName = firstAvailableProperty(
                properties,
                "feature_name",
                "name",
                "NAME",
                "Name",
                "title",
                "TITLE",
                "area_name",
                "protected_area_name",
                "forest_name"
        );

        if (featureName == null) {
            featureName = "GIS Feature " + featureNumber;
        }

        String suppliedCode = firstAvailableProperty(
                properties,
                "feature_code",
                "code",
                "CODE",
                "id",
                "ID"
        );

        String featureCode = buildFeatureCode(
                suppliedCode,
                featureName,
                featureNumber
        );

        String featureType = firstAvailableProperty(
                properties,
                "feature_type",
                "category",
                "type",
                "TYPE",
                "class",
                "CLASS"
        );

        if (featureType == null) {
            featureType = geometryType.toUpperCase(
                    Locale.ROOT
            );
        }

        String stateName = firstAvailableProperty(
                properties,
                "state_name",
                "state",
                "STATE",
                "st_name",
                "STATE_NAME"
        );

        if (stateName == null) {
            stateName = clean(defaultStateName);
        }

        String districtName = firstAvailableProperty(
                properties,
                "district_name",
                "district",
                "DISTRICT",
                "dt_name",
                "DISTRICT_NAME"
        );

        if (districtName == null) {
            districtName = clean(defaultDistrictName);
        }

        GisFeature feature = new GisFeature();

        feature.setGisLayerId(gisLayerId);
        feature.setFeatureCode(featureCode);
        feature.setFeatureName(limit(featureName, 250));
        feature.setFeatureType(limit(featureType, 100));
        feature.setStateName(limit(stateName, 150));
        feature.setDistrictName(limit(districtName, 150));

        feature.setSourceProperties(
                properties == null
                        ? "{}"
                        : properties.toString()
        );

        feature.setBoundaryGeoJson(
                geometryObject.toString()
        );

        feature.setActive(true);

        return feature;
    }

    private GisFeature createGeometryFeature(
            long gisLayerId,
            JsonObject geometryObject,
            int featureNumber,
            String defaultStateName,
            String defaultDistrictName
    ) {

        String geometryType =
                getString(geometryObject, "type");

        if (!isSupportedGeometry(geometryType)) {
            throw new IllegalArgumentException(
                    "Unsupported geometry type: " + geometryType
            );
        }

        validateCoordinates(geometryObject);

        GisFeature feature = new GisFeature();

        feature.setGisLayerId(gisLayerId);

        feature.setFeatureCode(
                "FEATURE_" + featureNumber
        );

        feature.setFeatureName(
                "GIS Feature " + featureNumber
        );

        feature.setFeatureType(
                geometryType.toUpperCase(Locale.ROOT)
        );

        feature.setStateName(
                limit(clean(defaultStateName), 150)
        );

        feature.setDistrictName(
                limit(clean(defaultDistrictName), 150)
        );

        feature.setSourceProperties("{}");
        feature.setBoundaryGeoJson(geometryObject.toString());
        feature.setActive(true);

        return feature;
    }

    private void validateCoordinates(
            JsonObject geometryObject
    ) {

        JsonElement coordinatesElement =
                geometryObject.get("coordinates");

        if (coordinatesElement == null
                || coordinatesElement.isJsonNull()
                || !coordinatesElement.isJsonArray()
                || coordinatesElement
                        .getAsJsonArray()
                        .size() == 0) {

            throw new IllegalArgumentException(
                    "Geometry coordinates are missing."
            );
        }
    }

    private boolean isSupportedGeometry(String geometryType) {

        return "Polygon".equalsIgnoreCase(geometryType)
                || "MultiPolygon".equalsIgnoreCase(
                        geometryType
                );
    }

    private String firstAvailableProperty(
            JsonObject properties,
            String... propertyNames
    ) {

        if (properties == null || propertyNames == null) {
            return null;
        }

        for (String propertyName : propertyNames) {

            if (!properties.has(propertyName)) {
                continue;
            }

            JsonElement value = properties.get(propertyName);

            if (value == null
                    || value.isJsonNull()
                    || !value.isJsonPrimitive()) {
                continue;
            }

            String result = clean(value.getAsString());

            if (result != null) {
                return result;
            }
        }

        return null;
    }

    private String buildFeatureCode(
            String suppliedCode,
            String featureName,
            int featureNumber
    ) {

        String value = suppliedCode;

        if (value == null) {
            value = featureName;
        }

        String normalized = value
                .toUpperCase(Locale.ROOT)
                .replaceAll("[^A-Z0-9]+", "_")
                .replaceAll("^_+|_+$", "");

        if (normalized.isEmpty()) {
            normalized = "FEATURE";
        }

        if (normalized.length() > 100) {
            normalized = normalized.substring(0, 100);
        }

        /*
         * Number is appended so identical names inside one uploaded
         * GeoJSON do not produce identical feature codes.
         */
        String suffix = "_" + featureNumber;

        if (normalized.length() + suffix.length() > 120) {
            normalized = normalized.substring(
                    0,
                    120 - suffix.length()
            );
        }

        return normalized + suffix;
    }

    private String getString(
            JsonObject object,
            String propertyName
    ) {

        if (object == null || !object.has(propertyName)) {
            return null;
        }

        JsonElement element = object.get(propertyName);

        if (element == null
                || element.isJsonNull()
                || !element.isJsonPrimitive()) {
            return null;
        }

        return clean(element.getAsString());
    }

    private String clean(String value) {

        if (value == null) {
            return null;
        }

        String cleaned = value.trim();

        return cleaned.isEmpty() ? null : cleaned;
    }

    private String limit(String value, int maximumLength) {

        if (value == null) {
            return null;
        }

        if (value.length() <= maximumLength) {
            return value;
        }

        return value.substring(0, maximumLength);
    }

    public static class ImportResult {

        private final int importedCount;
        private final int skippedCount;
        private final int totalCount;

        public ImportResult(
                int importedCount,
                int skippedCount,
                int totalCount
        ) {
            this.importedCount = importedCount;
            this.skippedCount = skippedCount;
            this.totalCount = totalCount;
        }

        public int getImportedCount() {
            return importedCount;
        }

        public int getSkippedCount() {
            return skippedCount;
        }

        public int getTotalCount() {
            return totalCount;
        }
    }
}