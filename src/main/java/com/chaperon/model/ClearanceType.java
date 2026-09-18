package com.chaperon.model;

import java.sql.Timestamp;

public class ClearanceType {

    private long clearanceTypeId;
    private String clearanceCode;
    private String clearanceName;
    private String description;
    private boolean requiresMap;
    private boolean requiresKml;
    private boolean active;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public ClearanceType() {
    }

    public long getClearanceTypeId() {
        return clearanceTypeId;
    }

    public void setClearanceTypeId(long clearanceTypeId) {
        this.clearanceTypeId = clearanceTypeId;
    }

    public String getClearanceCode() {
        return clearanceCode;
    }

    public void setClearanceCode(String clearanceCode) {
        this.clearanceCode = clearanceCode;
    }

    public String getClearanceName() {
        return clearanceName;
    }

    public void setClearanceName(String clearanceName) {
        this.clearanceName = clearanceName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isRequiresMap() {
        return requiresMap;
    }

    public void setRequiresMap(boolean requiresMap) {
        this.requiresMap = requiresMap;
    }

    public boolean isRequiresKml() {
        return requiresKml;
    }

    public void setRequiresKml(boolean requiresKml) {
        this.requiresKml = requiresKml;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
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
}
