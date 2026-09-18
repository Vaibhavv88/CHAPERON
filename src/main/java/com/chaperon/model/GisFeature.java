package com.chaperon.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class GisFeature {

    private long gisFeatureId;

    private long gisLayerId;

    private String featureCode;

    private String featureName;

    private String featureType;

    private String stateName;

    private String districtName;

    private String sourceProperties;

    /*
     * Geometry is transferred between Java and MySQL
     * as GeoJSON.
     */
    private String boundaryGeoJson;

    private BigDecimal calculatedAreaHectares;

    private boolean active;

    private Timestamp createdAt;

    private Timestamp updatedAt;

    /*
     * Joined display fields from gis_layers.
     */
    private String layerCode;

    private String layerName;

    private String layerCategory;

    public GisFeature() {
    }

    public long getGisFeatureId() {
        return gisFeatureId;
    }

    public void setGisFeatureId(
            long gisFeatureId
    ) {
        this.gisFeatureId = gisFeatureId;
    }

    public long getGisLayerId() {
        return gisLayerId;
    }

    public void setGisLayerId(
            long gisLayerId
    ) {
        this.gisLayerId = gisLayerId;
    }

    public String getFeatureCode() {
        return featureCode;
    }

    public void setFeatureCode(
            String featureCode
    ) {
        this.featureCode = featureCode;
    }

    public String getFeatureName() {
        return featureName;
    }

    public void setFeatureName(
            String featureName
    ) {
        this.featureName = featureName;
    }

    public String getFeatureType() {
        return featureType;
    }

    public void setFeatureType(
            String featureType
    ) {
        this.featureType = featureType;
    }

    public String getStateName() {
        return stateName;
    }

    public void setStateName(
            String stateName
    ) {
        this.stateName = stateName;
    }

    public String getDistrictName() {
        return districtName;
    }

    public void setDistrictName(
            String districtName
    ) {
        this.districtName = districtName;
    }

    public String getSourceProperties() {
        return sourceProperties;
    }

    public void setSourceProperties(
            String sourceProperties
    ) {
        this.sourceProperties = sourceProperties;
    }

    public String getBoundaryGeoJson() {
        return boundaryGeoJson;
    }

    public void setBoundaryGeoJson(
            String boundaryGeoJson
    ) {
        this.boundaryGeoJson = boundaryGeoJson;
    }

    public BigDecimal getCalculatedAreaHectares() {
        return calculatedAreaHectares;
    }

    public void setCalculatedAreaHectares(
            BigDecimal calculatedAreaHectares
    ) {
        this.calculatedAreaHectares =
                calculatedAreaHectares;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(
            boolean active
    ) {
        this.active = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(
            Timestamp createdAt
    ) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(
            Timestamp updatedAt
    ) {
        this.updatedAt = updatedAt;
    }

    public String getLayerCode() {
        return layerCode;
    }

    public void setLayerCode(
            String layerCode
    ) {
        this.layerCode = layerCode;
    }

    public String getLayerName() {
        return layerName;
    }

    public void setLayerName(
            String layerName
    ) {
        this.layerName = layerName;
    }

    public String getLayerCategory() {
        return layerCategory;
    }

    public void setLayerCategory(
            String layerCategory
    ) {
        this.layerCategory = layerCategory;
    }

    public String getCoverageLabel() {

        if (stateName == null ||
                stateName.isBlank()) {

            return "All India";
        }

        if (districtName == null ||
                districtName.isBlank()) {

            return stateName;
        }

        return districtName
                + ", "
                + stateName;
    }
}