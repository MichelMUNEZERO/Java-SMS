package com.sms.model;

/**
 * User model class
 */
public class User {
    private int userId;
    private String username;
    private String password;
    private String email;
    private String firstName;
    private String lastName;
    private String role; // Maps to UserType in the database
    private String status;
    private String imageLink;

    /**
     * Default constructor
     */
    public User() {
    }

    /**
     * Constructor with essential fields
     * @param username the username
     * @param password the password (hashed)
     * @param role the role/userType
     */
    public User(String username, String password, String role) {
        this.username = username;
        this.password = password;
        this.role = role;
    }

    /**
     * Constructor with all fields except userId
     * @param username the username
     * @param email the email address
     * @param password the password (hashed)
     * @param firstName the first name
     * @param lastName the last name
     * @param role the role
     * @param status the status
     */
    public User(String username, String email, String password, String firstName, String lastName, String role, String status) {
        this.username = username;
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
     * @param username the username
     * @param email the email address
     * @param password the password (hashed)
     * @param firstName the first name
     * @param lastName the last name
     * @param role the role
     * @param status the status
     */
    public User(int userId, String username, String email, String password, String firstName, String lastName, String role, String status) {
        this.userId = userId;
        this.username = username;
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

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
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

    // For backwards compatibility with database schema
    public String getUserType() {
        return role;
    }

    // For backwards compatibility with database schema
    public void setUserType(String userType) {
        this.role = userType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getImageLink() {
        return imageLink;
    }
    
    public void setImageLink(String imageLink) {
        this.imageLink = imageLink;
    }

    /**
     * Get full name
     * @return the full name of the user
     */
    public String getFullName() {
        if (firstName != null && lastName != null) {
            return firstName + " " + lastName;
        } else {
            return username;
        }
    }

    @Override
    public String toString() {
        return "User [userId=" + userId + ", username=" + username + 
               ", email=" + email + ", firstName=" + firstName + 
               ", lastName=" + lastName + ", role=" + role + 
               ", status=" + status + "]";
    }
} 