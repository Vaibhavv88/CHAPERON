package com.chaperon.model;

import java.sql.Timestamp;

public class OfficerProfile {

    private long officerProfileId;

    private long userId;

    private long departmentId;

    private String departmentName;

    private String departmentCode;

    private String designation;

    private String employeeCode;

    private boolean active;

    private Timestamp createdAt;

    private Timestamp updatedAt;

    public OfficerProfile() {
    }

    public long getOfficerProfileId() {
        return officerProfileId;
    }

    public void setOfficerProfileId(
            long officerProfileId
    ) {
        this.officerProfileId =
                officerProfileId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(
            long userId
    ) {
        this.userId =
                userId;
    }

    public long getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(
            long departmentId
    ) {
        this.departmentId =
                departmentId;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(
            String departmentName
    ) {
        this.departmentName =
                departmentName;
    }

    public String getDepartmentCode() {
        return departmentCode;
    }

    public void setDepartmentCode(
            String departmentCode
    ) {
        this.departmentCode =
                departmentCode;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(
            String designation
    ) {
        this.designation =
                designation;
    }

    public String getEmployeeCode() {
        return employeeCode;
    }

    public void setEmployeeCode(
            String employeeCode
    ) {
        this.employeeCode =
                employeeCode;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(
            boolean active
    ) {
        this.active =
                active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(
            Timestamp createdAt
    ) {
        this.createdAt =
                createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(
            Timestamp updatedAt
    ) {
        this.updatedAt =
                updatedAt;
    }
}