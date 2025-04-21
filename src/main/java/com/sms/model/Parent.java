package com.sms.model;

/**
 * Parent model class
 */
public class Parent {
    private int parentId;
    private int userId;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String address;
    private String occupation;
    
    /**
     * Default constructor
     */
    public Parent() {
    }
    
    /**
     * Constructor with essential fields
     * @param firstName the first name
     * @param lastName the last name
     * @param email the email
     * @param phone the phone number
     */
    public Parent(String firstName, String lastName, String email, String phone) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
    }
    
    /**
     * Full constructor
     * @param parentId the parent id
     * @param userId the user id
     * @param firstName the first name
     * @param lastName the last name
     * @param email the email
     * @param phone the phone number
     * @param address the address
     * @param occupation the occupation
     */
    public Parent(int parentId, int userId, String firstName, String lastName, String email, String phone, String address, String occupation) {
        this.parentId = parentId;
        this.userId = userId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.occupation = occupation;
    }
    
    /**
     * Get the parent ID
     * 
     * @return The parent ID
     */
    public int getParentId() {
        return parentId;
    }
    
    /**
     * Set the parent ID
     * 
     * @param parentId The parent ID
     */
    public void setParentId(int parentId) {
        this.parentId = parentId;
    }
    
    /**
     * Get the user ID
     * 
     * @return The user ID
     */
    public int getUserId() {
        return userId;
    }
    
    /**
     * Set the user ID
     * 
     * @param userId The user ID
     */
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    /**
     * Get the first name
     * 
     * @return The first name
     */
    public String getFirstName() {
        return firstName;
    }
    
    /**
     * Set the first name
     * 
     * @param firstName The first name
     */
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    
    /**
     * Get the last name
     * 
     * @return The last name
     */
    public String getLastName() {
        return lastName;
    }
    
    /**
     * Set the last name
     * 
     * @param lastName The last name
     */
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    
    /**
     * Get the email address
     * 
     * @return The email address
     */
    public String getEmail() {
        return email;
    }
    
    /**
     * Set the email address
     * 
     * @param email The email address
     */
    public void setEmail(String email) {
        this.email = email;
    }
    
    /**
     * Get the phone number
     * 
     * @return The phone number
     */
    public String getPhone() {
        return phone;
    }
    
    /**
     * Set the phone number
     * 
     * @param phone The phone number
     */
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    /**
     * Get the address
     * 
     * @return The address
     */
    public String getAddress() {
        return address;
    }
    
    /**
     * Set the address
     * 
     * @param address The address
     */
    public void setAddress(String address) {
        this.address = address;
    }
    
    /**
     * Get the occupation
     * 
     * @return The occupation
     */
    public String getOccupation() {
        return occupation;
    }
    
    /**
     * Set the occupation
     * 
     * @param occupation The occupation
     */
    public void setOccupation(String occupation) {
        this.occupation = occupation;
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
        return "Parent [parentId=" + parentId + ", firstName=" + firstName + ", lastName=" + lastName + 
                ", email=" + email + "]";
    }
} 