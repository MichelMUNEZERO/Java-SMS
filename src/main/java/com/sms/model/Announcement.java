package com.sms.model;

import java.util.Date;

/**
 * Announcement model class
 */
public class Announcement {
    private int announcementId;
    private String message;
    private Date date;
    private String targetGroup;
    
    /**
     * Default constructor
     */
    public Announcement() {
    }
    
    /**
     * Constructor with all fields except id
     * @param message the announcement message
     * @param date the announcement date
     * @param targetGroup the target audience group
     */
    public Announcement(String message, Date date, String targetGroup) {
        this.message = message;
        this.date = date;
        this.targetGroup = targetGroup;
    }
    
    /**
     * Constructor with all fields
     * @param announcementId the announcement id
     * @param message the announcement message
     * @param date the announcement date
     * @param targetGroup the target audience group
     */
    public Announcement(int announcementId, String message, Date date, String targetGroup) {
        this.announcementId = announcementId;
        this.message = message;
        this.date = date;
        this.targetGroup = targetGroup;
    }
    
    public int getAnnouncementId() {
        return announcementId;
    }
    
    public void setAnnouncementId(int announcementId) {
        this.announcementId = announcementId;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public Date getDate() {
        return date;
    }
    
    public void setDate(Date date) {
        this.date = date;
    }
    
    public String getTargetGroup() {
        return targetGroup;
    }
    
    public void setTargetGroup(String targetGroup) {
        this.targetGroup = targetGroup;
    }
    
    @Override
    public String toString() {
        return "Announcement [announcementId=" + announcementId + ", message=" + message + 
               ", date=" + date + ", targetGroup=" + targetGroup + "]";
    }
} 