package com.sms.model;

import java.sql.Timestamp;

public class CourseMaterial {
    private int id;
    private int courseId;
    private String title;
    private String description;
    private String fileUrl;
    private String fileType;
    private int uploadedBy;
    private Timestamp uploadDate;
    
    // Default constructor
    public CourseMaterial() {
    }
    
    // Parameterized constructor
    public CourseMaterial(int id, int courseId, String title, String description, 
                         String fileUrl, String fileType, int uploadedBy, Timestamp uploadDate) {
        this.id = id;
        this.courseId = courseId;
        this.title = title;
        this.description = description;
        this.fileUrl = fileUrl;
        this.fileType = fileType;
        this.uploadedBy = uploadedBy;
        this.uploadDate = uploadDate;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getCourseId() {
        return courseId;
    }
    
    public void setCourseId(int courseId) {
        this.courseId = courseId;
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
    
    public String getFileUrl() {
        return fileUrl;
    }
    
    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }
    
    public String getFileType() {
        return fileType;
    }
    
    public void setFileType(String fileType) {
        this.fileType = fileType;
    }
    
    public int getUploadedBy() {
        return uploadedBy;
    }
    
    public void setUploadedBy(int uploadedBy) {
        this.uploadedBy = uploadedBy;
    }
    
    public Timestamp getUploadDate() {
        return uploadDate;
    }
    
    public void setUploadDate(Timestamp uploadDate) {
        this.uploadDate = uploadDate;
    }
    
    @Override
    public String toString() {
        return "CourseMaterial{" +
                "id=" + id +
                ", courseId=" + courseId +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", fileUrl='" + fileUrl + '\'' +
                ", fileType='" + fileType + '\'' +
                ", uploadedBy=" + uploadedBy +
                ", uploadDate=" + uploadDate +
                '}';
    }
} 