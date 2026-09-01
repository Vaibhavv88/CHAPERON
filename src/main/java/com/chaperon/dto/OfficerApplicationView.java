package com.chaperon.dto;

import com.chaperon.model.Application;

public class OfficerApplicationView {

    private Application application;

    private String approvalName;

    private String approvalCode;

    private String applicantName;

    private String businessName;

    public OfficerApplicationView() {
    }

    public OfficerApplicationView(
            Application application,
            String approvalName,
            String approvalCode,
            String applicantName,
            String businessName
    ) {

        this.application = application;
        this.approvalName = approvalName;
        this.approvalCode = approvalCode;
        this.applicantName = applicantName;
        this.businessName = businessName;
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

    public String getApplicantName() {
        return applicantName;
    }

    public void setApplicantName(
            String applicantName
    ) {
        this.applicantName = applicantName;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(
            String businessName
    ) {
        this.businessName = businessName;
    }
}