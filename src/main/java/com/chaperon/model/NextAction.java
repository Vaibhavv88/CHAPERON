package com.chaperon.model;

public class NextAction {

    private String actionType;
    private String title;
    private String description;
    private String buttonText;
    private String actionUrl;
    private String priority;
    private String relatedEntity;
    private Long relatedId;

    public NextAction() {
    }

    public NextAction(
            String actionType,
            String title,
            String description,
            String buttonText,
            String actionUrl,
            String priority,
            String relatedEntity,
            Long relatedId) {

        this.actionType = actionType;
        this.title = title;
        this.description = description;
        this.buttonText = buttonText;
        this.actionUrl = actionUrl;
        this.priority = priority;
        this.relatedEntity = relatedEntity;
        this.relatedId = relatedId;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getButtonText() {
        return buttonText;
    }

    public void setButtonText(String buttonText) {
        this.buttonText = buttonText;
    }

    public String getActionUrl() {
        return actionUrl;
    }

    public void setActionUrl(String actionUrl) {
        this.actionUrl = actionUrl;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getRelatedEntity() {
        return relatedEntity;
    }

    public void setRelatedEntity(String relatedEntity) {
        this.relatedEntity = relatedEntity;
    }

    public Long getRelatedId() {
        return relatedId;
    }

    public void setRelatedId(Long relatedId) {
        this.relatedId = relatedId;
    }
}