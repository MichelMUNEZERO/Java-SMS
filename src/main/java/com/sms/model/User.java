package com.sms.model;

/**
 * User model class
 */
public class User {
    private int userId;
    private String username;
    private String password;
    private String userType;
    private String imageLink;
    
    /**
     * Default constructor
     */
    public User() {
    }
    
    /**
     * Constructor with all fields except userId
     * @param username the username
     * @param password the password
     * @param userType the user type
     * @param imageLink the image link
     */
    public User(String username, String password, String userType, String imageLink) {
        this.username = username;
        this.password = password;
        this.userType = userType;
        this.imageLink = imageLink;
    }
    
    /**
     * Constructor with all fields
     * @param userId the user id
     * @param username the username
     * @param password the password
     * @param userType the user type
     * @param imageLink the image link
     */
    public User(int userId, String username, String password, String userType, String imageLink) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.userType = userType;
        this.imageLink = imageLink;
    }
    
    // Getters and setters
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getUserType() {
        return userType;
    }
    
    public void setUserType(String userType) {
        this.userType = userType;
    }
    
    public String getImageLink() {
        return imageLink;
    }
    
    public void setImageLink(String imageLink) {
        this.imageLink = imageLink;
    }
    
    @Override
    public String toString() {
        return "User [userId=" + userId + ", username=" + username + ", userType=" + userType + "]";
    }
} 