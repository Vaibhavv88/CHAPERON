package com.chaperon.model;

import java.sql.Timestamp;

public class ApprovalDependency {

    private long dependencyId;

    private long approvalId;

    private long dependsOnApprovalId;

    private String dependencyType;

    private String conditionDescription;

    private boolean active;

    private Timestamp createdAt;

    private Timestamp updatedAt;

    // Extra display fields for UI
    private String approvalName;

    private String approvalCode;

    private String dependsOnApprovalName;

    private String dependsOnApprovalCode;

    public ApprovalDependency() {

    }

    public long getDependencyId() {

        return dependencyId;

    }

    public void setDependencyId(long dependencyId) {

        this.dependencyId = dependencyId;

    }

    public long getApprovalId() {

        return approvalId;

    }

    public void setApprovalId(long approvalId) {

        this.approvalId = approvalId;

    }

    public long getDependsOnApprovalId() {

        return dependsOnApprovalId;

    }

    public void setDependsOnApprovalId(long dependsOnApprovalId) {

        this.dependsOnApprovalId = dependsOnApprovalId;

    }

    public String getDependencyType() {

        return dependencyType;

    }

    public void setDependencyType(String dependencyType) {

        this.dependencyType = dependencyType;

    }

    public String getConditionDescription() {

        return conditionDescription;

    }

    public void setConditionDescription(String conditionDescription) {

        this.conditionDescription = conditionDescription;

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

    public String getApprovalName() {

        return approvalName;

    }

    public void setApprovalName(String approvalName) {

        this.approvalName = approvalName;

    }

    public String getApprovalCode() {

        return approvalCode;

    }

    public void setApprovalCode(String approvalCode) {

        this.approvalCode = approvalCode;

    }

    public String getDependsOnApprovalName() {

        return dependsOnApprovalName;

    }

    public void setDependsOnApprovalName(String dependsOnApprovalName) {

        this.dependsOnApprovalName = dependsOnApprovalName;

    }

    public String getDependsOnApprovalCode() {

        return dependsOnApprovalCode;

    }

    public void setDependsOnApprovalCode(String dependsOnApprovalCode) {

        this.dependsOnApprovalCode = dependsOnApprovalCode;

    }

}