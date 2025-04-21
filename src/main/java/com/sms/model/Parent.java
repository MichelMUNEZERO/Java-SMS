package com.sms.model;

/**
 * Model class for Parent entity
 */
public class Parent {
    private int parentId;
    private int userId;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String address;
    private String emergencyContact;
    
    /**
     * Default constructor
     */
    public Parent() {
    }
    
    /**
     * Parameterized constructor
     * 
     * @param parentId Parent ID
     * @param userId User ID
     * @param firstName First name
     * @param lastName Last name
     * @param email Email address
     * @param phone Phone number
     * @param address Address
     * @param emergencyContact Emergency contact
     */
    public Parent(int parentId, int userId, String firstName, String lastName, String email, String phone, String address, String emergencyContact) {
        this.parentId = parentId;
        this.userId = userId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.emergencyContact = emergencyContact;
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
     * Get the emergency contact
     * 
     * @return The emergency contact
     */
    public String getEmergencyContact() {
        return emergencyContact;
    }
    
    /**
     * Set the emergency contact
     * 
     * @param emergencyContact The emergency contact
     */
    public void setEmergencyContact(String emergencyContact) {
        this.emergencyContact = emergencyContact;
    }
    
    @Override
    public String toString() {
        return "Parent [parentId=" + parentId + ", userId=" + userId + ", firstName=" + firstName + ", lastName="
                + lastName + ", email=" + email + ", phone=" + phone + ", address=" + address + ", emergencyContact="
                + emergencyContact + "]";
    }
} 