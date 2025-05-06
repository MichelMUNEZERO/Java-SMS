package com.sms.model;

import java.sql.Timestamp;

/**
 * Model class for announcements in the School Management System
 */
public class Announcement {
    private int announcementId;
    private String title;
    private String message;
    private Timestamp date;
    private String postedBy;
    private String targetGroup;
    
    /**
     * Default constructor
     */
    public Announcement() {
    }
    
    /**
     * Constructor with all fields
     */
    public Announcement(int announcementId, String title, String message, Timestamp date, 
                        String postedBy, String targetGroup) {
        this.announcementId = announcementId;
        this.title = title;
        this.message = message;
        this.date = date;
        this.postedBy = postedBy;
        this.targetGroup = targetGroup;
    }
    
    // Getters and Setters
    
    public int getAnnouncementId() {
        return announcementId;
    }
    
    public void setAnnouncementId(int announcementId) {
        this.announcementId = announcementId;
    }

    // Alias for ID to maintain JSP compatibility
    public int getId() {
        return announcementId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public Timestamp getDate() {
        return date;
    }
    
    public void setDate(Timestamp date) {
        this.date = date;
    }
    
    // Alias for date to maintain JSP compatibility
    public Timestamp getCreatedAt() {
        return date;
    }
    
    public String getPostedBy() {
        return postedBy;
    }
    
    public void setPostedBy(String postedBy) {
        this.postedBy = postedBy;
    }
    
    public String getTargetGroup() {
        return targetGroup;
    }
    
    public void setTargetGroup(String targetGroup) {
        this.targetGroup = targetGroup;
    }
    
    @Override
    public String toString() {
        return "Announcement [announcementId=" + announcementId + ", title=" + title + ", message=" + message
                + ", date=" + date + ", postedBy=" + postedBy + ", targetGroup=" + targetGroup + "]";
    }
} 