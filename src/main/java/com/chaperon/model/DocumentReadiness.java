package com.chaperon.model;

public class DocumentReadiness {

    private String documentType;
    private String description;
    private boolean mandatory;

    private String status;

    private Long uploadedDocumentId;

    private String uploadedFileName;

    public DocumentReadiness() {
    }

    public String getDocumentType() {
        return documentType;
    }

    public void setDocumentType(String documentType) {
        this.documentType = documentType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isMandatory() {
        return mandatory;
    }

    public void setMandatory(boolean mandatory) {
        this.mandatory = mandatory;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Long getUploadedDocumentId() {
        return uploadedDocumentId;
    }

    public void setUploadedDocumentId(Long uploadedDocumentId) {
        this.uploadedDocumentId = uploadedDocumentId;
    }

    public String getUploadedFileName() {
        return uploadedFileName;
    }

    public void setUploadedFileName(String uploadedFileName) {
        this.uploadedFileName = uploadedFileName;
    }
}