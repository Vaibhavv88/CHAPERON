package com.chaperon.model;

import java.sql.Timestamp;

public class ClearanceRequirement {

    private long requirementId;
    private long clearanceTypeId;
    private String category;
    private String requirementName;
    private String description;
    private String requirementType;
    private String responsibleRole;
    private boolean mandatory;
    private int displayOrder;
    private boolean active;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Joined display field from clearance_types.
    private String clearanceName;

    public ClearanceRequirement() {
    }

    public long getRequirementId() {
        return requirementId;
    }

    public void setRequirementId(long requirementId) {
        this.requirementId = requirementId;
    }

    public long getClearanceTypeId() {
        return clearanceTypeId;
    }

    public void setClearanceTypeId(long clearanceTypeId) {
        this.clearanceTypeId = clearanceTypeId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getRequirementName() {
        return requirementName;
    }

    public void setRequirementName(String requirementName) {
        this.requirementName = requirementName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getRequirementType() {
        return requirementType;
    }

    public void setRequirementType(String requirementType) {
        this.requirementType = requirementType;
    }

    public String getResponsibleRole() {
        return responsibleRole;
    }

    public void setResponsibleRole(String responsibleRole) {
        this.responsibleRole = responsibleRole;
    }

    public boolean isMandatory() {
        return mandatory;
    }

    public void setMandatory(boolean mandatory) {
        this.mandatory = mandatory;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
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

    public String getClearanceName() {
        return clearanceName;
    }

    public void setClearanceName(String clearanceName) {
        this.clearanceName = clearanceName;
    }
}
