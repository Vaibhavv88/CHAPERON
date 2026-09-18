package com.chaperon.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class ClearanceApplicationMap {

    private long clearanceMapId;
    private long clearanceApplicationId;
    private String mapName;
    private String mapType;
    private String boundarySource;
    private String geojsonData;
    private Long mapDocumentId;

    private BigDecimal centreLatitude;
    private BigDecimal centreLongitude;
    private BigDecimal calculatedAreaHectares;

    private Boolean protectedAreaIntersection;
    private Boolean ecoSensitiveZoneIntersection;
    private String nearestProtectedArea;
    private BigDecimal distanceFromProtectedAreaKm;

    private String validationStatus;
    private String validationMessage;
    private long uploadedByUserId;
    private Long verifiedByUserId;
    private Timestamp verifiedAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Joined display fields.
    private String mapDocumentPath;
    private String uploadedByName;
    private String verifiedByName;

    public ClearanceApplicationMap() {
    }

    public long getClearanceMapId() {
        return clearanceMapId;
    }

    public void setClearanceMapId(long clearanceMapId) {
        this.clearanceMapId = clearanceMapId;
    }

    public long getClearanceApplicationId() {
        return clearanceApplicationId;
    }

    public void setClearanceApplicationId(long clearanceApplicationId) {
        this.clearanceApplicationId = clearanceApplicationId;
    }

    public String getMapName() {
        return mapName;
    }

    public void setMapName(String mapName) {
        this.mapName = mapName;
    }

    public String getMapType() {
        return mapType;
    }

    public void setMapType(String mapType) {
        this.mapType = mapType;
    }

    public String getBoundarySource() {
        return boundarySource;
    }

    public void setBoundarySource(String boundarySource) {
        this.boundarySource = boundarySource;
    }

    public String getGeojsonData() {
        return geojsonData;
    }

    public void setGeojsonData(String geojsonData) {
        this.geojsonData = geojsonData;
    }

    public Long getMapDocumentId() {
        return mapDocumentId;
    }

    public void setMapDocumentId(Long mapDocumentId) {
        this.mapDocumentId = mapDocumentId;
    }

    public BigDecimal getCentreLatitude() {
        return centreLatitude;
    }

    public void setCentreLatitude(BigDecimal centreLatitude) {
        this.centreLatitude = centreLatitude;
    }

    public BigDecimal getCentreLongitude() {
        return centreLongitude;
    }

    public void setCentreLongitude(BigDecimal centreLongitude) {
        this.centreLongitude = centreLongitude;
    }

    public BigDecimal getCalculatedAreaHectares() {
        return calculatedAreaHectares;
    }

    public void setCalculatedAreaHectares(BigDecimal calculatedAreaHectares) {
        this.calculatedAreaHectares = calculatedAreaHectares;
    }

    public Boolean getProtectedAreaIntersection() {
        return protectedAreaIntersection;
    }

    public void setProtectedAreaIntersection(Boolean protectedAreaIntersection) {
        this.protectedAreaIntersection = protectedAreaIntersection;
    }

    public Boolean getEcoSensitiveZoneIntersection() {
        return ecoSensitiveZoneIntersection;
    }

    public void setEcoSensitiveZoneIntersection(Boolean ecoSensitiveZoneIntersection) {
        this.ecoSensitiveZoneIntersection = ecoSensitiveZoneIntersection;
    }

    public String getNearestProtectedArea() {
        return nearestProtectedArea;
    }

    public void setNearestProtectedArea(String nearestProtectedArea) {
        this.nearestProtectedArea = nearestProtectedArea;
    }

    public BigDecimal getDistanceFromProtectedAreaKm() {
        return distanceFromProtectedAreaKm;
    }

    public void setDistanceFromProtectedAreaKm(BigDecimal distanceFromProtectedAreaKm) {
        this.distanceFromProtectedAreaKm = distanceFromProtectedAreaKm;
    }

    public String getValidationStatus() {
        return validationStatus;
    }

    public void setValidationStatus(String validationStatus) {
        this.validationStatus = validationStatus;
    }

    public String getValidationMessage() {
        return validationMessage;
    }

    public void setValidationMessage(String validationMessage) {
        this.validationMessage = validationMessage;
    }

    public long getUploadedByUserId() {
        return uploadedByUserId;
    }

    public void setUploadedByUserId(long uploadedByUserId) {
        this.uploadedByUserId = uploadedByUserId;
    }

    public Long getVerifiedByUserId() {
        return verifiedByUserId;
    }

    public void setVerifiedByUserId(Long verifiedByUserId) {
        this.verifiedByUserId = verifiedByUserId;
    }

    public Timestamp getVerifiedAt() {
        return verifiedAt;
    }

    public void setVerifiedAt(Timestamp verifiedAt) {
        this.verifiedAt = verifiedAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getMapDocumentPath() {
        return mapDocumentPath;
    }

    public void setMapDocumentPath(String mapDocumentPath) {
        this.mapDocumentPath = mapDocumentPath;
    }

    public String getUploadedByName() {
        return uploadedByName;
    }

    public void setUploadedByName(String uploadedByName) {
        this.uploadedByName = uploadedByName;
    }

    public String getVerifiedByName() {
        return verifiedByName;
    }

    public void setVerifiedByName(String verifiedByName) {
        this.verifiedByName = verifiedByName;
    }
}
