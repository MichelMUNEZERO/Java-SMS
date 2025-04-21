package com.sms.model;

/**
 * User model class
 */
public class User {
    private int userId;
    private String email;
    private String password;
    private String firstName;
    private String lastName;
    private String role;
    private String status;
    private String imageLink; // Added for compatibility

    /**
     * Default constructor
     */
    public User() {
    }

    /**
     * Constructor with all fields except userId
     * @param email the email address
     * @param password the password (hashed)
     * @param firstName the first name
     * @param lastName the last name
     * @param role the role
     * @param status the status
     */
    public User(String email, String password, String firstName, String lastName, String role, String status) {
        this.email = email;
        this.password = password;
        this.firstName = firstName;
        this.lastName = lastName;
        this.role = role;
        this.status = status;
    }

    /**
     * Constructor with all fields
     * @param userId the user id
     * @param email the email address
     * @param password the password (hashed)
     * @param firstName the first name
     * @param lastName the last name
     * @param role the role
     * @param status the status
     */
    public User(int userId, String email, String password, String firstName, String lastName, String role, String status) {
        this.userId = userId;
        this.email = email;
        this.password = password;
        this.firstName = firstName;
        this.lastName = lastName;
        this.role = role;
        this.status = status;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    // For backwards compatibility
    public String getUsername() {
        return email;
    }

    // For backwards compatibility
    public void setUsername(String username) {
        this.email = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    // For backwards compatibility
    public String getUserType() {
        return role;
    }

    // For backwards compatibility
    public void setUserType(String userType) {
        this.role = userType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    // For backwards compatibility
    public String getImageLink() {
        return imageLink;
    }
    
    // For backwards compatibility
    public void setImageLink(String imageLink) {
        this.imageLink = imageLink;
    }

    /**
     * Get full name
     * @return the full name of the user
     */
    public String getFullName() {
        return firstName + " " + lastName;
    }

    @Override
    public String toString() {
        return "User [userId=" + userId + ", email=" + email + 
               ", firstName=" + firstName + ", lastName=" + lastName + 
               ", role=" + role + ", status=" + status + "]";
    }
} 