package com.chaperon.dto;

import com.chaperon.model.Application;

public class ApplicationView {

    private Application application;

    private String approvalName;

    private String approvalCode;

    private String departmentName;

    public ApplicationView() {
    }

    public ApplicationView(
            Application application,
            String approvalName,
            String approvalCode,
            String departmentName
    ) {

        this.application = application;

        this.approvalName = approvalName;

        this.approvalCode = approvalCode;

        this.departmentName = departmentName;
    }

    public Application getApplication() {
        return application;
    }

    public void setApplication(
            Application application
    ) {
        this.application = application;
    }

    public String getApprovalName() {
        return approvalName;
    }

    public void setApprovalName(
            String approvalName
    ) {
        this.approvalName = approvalName;
    }

    public String getApprovalCode() {
        return approvalCode;
    }

    public void setApprovalCode(
            String approvalCode
    ) {
        this.approvalCode = approvalCode;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(
            String departmentName
    ) {
        this.departmentName = departmentName;
    }
}