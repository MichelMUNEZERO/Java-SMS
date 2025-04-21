package com.sms.model;

/**
 * Parent model class
 */
public class Parent {
    private int parentId;
    private String firstName;
    private String lastName;
    private String email;
    private String telephone;
    private String location;
    
    /**
     * Default constructor
     */
    public Parent() {
    }
    
    /**
     * Constructor with all fields except parentId
     * @param firstName the first name
     * @param lastName the last name
     * @param email the email
     * @param telephone the telephone
     * @param location the location
     */
    public Parent(String firstName, String lastName, String email, String telephone, String location) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.telephone = telephone;
        this.location = location;
    }
    
    /**
     * Constructor with all fields
     * @param parentId the parent id
     * @param firstName the first name
     * @param lastName the last name
     * @param email the email
     * @param telephone the telephone
     * @param location the location
     */
    public Parent(int parentId, String firstName, String lastName, String email, String telephone, String location) {
        this.parentId = parentId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.telephone = telephone;
        this.location = location;
    }
    
    // Getters and setters
    
    public int getParentId() {
        return parentId;
    }
    
    public void setParentId(int parentId) {
        this.parentId = parentId;
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
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getTelephone() {
        return telephone;
    }
    
    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    /**
     * Get full name
     * @return the full name of the parent
     */
    public String getFullName() {
        return firstName + " " + lastName;
    }
    
    @Override
    public String toString() {
        return "Parent [parentId=" + parentId + ", firstName=" + firstName + ", lastName=" + lastName + ", email=" + email + "]";
    }
} 