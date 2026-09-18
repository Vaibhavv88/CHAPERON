package com.chaperon.model;

import java.sql.Date;
import java.sql.Timestamp;

public class GisLayer {

    private long gisLayerId;

    private String layerCode;

    private String layerName;

    private String layerCategory;

    private String description;

    private String dataSource;

    private String sourceAuthority;

    private String sourceVersion;

    private Date sourceDate;

    /*
     * NULL state means the layer applies across India.
     */
    private String stateName;

    /*
     * NULL district means the layer applies across
     * the complete selected state.
     */
    private String districtName;

    private String coordinateSystem;

    private boolean active;

    private Long uploadedByUserId;

    private Timestamp createdAt;

    private Timestamp updatedAt;

    /*
     * Joined/display-only field.
     * This is calculated using COUNT(gis_feature_id).
     */
    private int featureCount;

    public GisLayer() {
    }

    public long getGisLayerId() {
        return gisLayerId;
    }

    public void setGisLayerId(
            long gisLayerId
    ) {
        this.gisLayerId = gisLayerId;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(
            String description
    ) {
        this.description = description;
    }

    public String getDataSource() {
        return dataSource;
    }

    public void setDataSource(
            String dataSource
    ) {
        this.dataSource = dataSource;
    }

    public String getSourceAuthority() {
        return sourceAuthority;
    }

    public void setSourceAuthority(
            String sourceAuthority
    ) {
        this.sourceAuthority = sourceAuthority;
    }

    public String getSourceVersion() {
        return sourceVersion;
    }

    public void setSourceVersion(
            String sourceVersion
    ) {
        this.sourceVersion = sourceVersion;
    }

    public Date getSourceDate() {
        return sourceDate;
    }

    public void setSourceDate(
            Date sourceDate
    ) {
        this.sourceDate = sourceDate;
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

    public String getCoordinateSystem() {
        return coordinateSystem;
    }

    public void setCoordinateSystem(
            String coordinateSystem
    ) {
        this.coordinateSystem = coordinateSystem;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(
            boolean active
    ) {
        this.active = active;
    }

    public Long getUploadedByUserId() {
        return uploadedByUserId;
    }

    public void setUploadedByUserId(
            Long uploadedByUserId
    ) {
        this.uploadedByUserId = uploadedByUserId;
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

    public int getFeatureCount() {
        return featureCount;
    }

    public void setFeatureCount(
            int featureCount
    ) {
        this.featureCount = featureCount;
    }

    public String getCoverageLabel() {

        boolean stateMissing =
                stateName == null
                        || stateName.isBlank();

        boolean districtMissing =
                districtName == null
                        || districtName.isBlank();

        if (stateMissing) {
            return "All India";
        }

        if (districtMissing) {
            return stateName;
        }

        return districtName
                + ", "
                + stateName;
    }

    public String getStatusLabel() {

        return active
                ? "Active"
                : "Inactive";
    }
}