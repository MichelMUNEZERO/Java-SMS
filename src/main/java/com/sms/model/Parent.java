package com.sms.model;

/**
 * Parent model class representing a parent/guardian in the system
 */
public class Parent {
    private int id;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String address;
    private String occupation;
    private int userId;
    // Additional fields
    private String status;
    private int childrenCount;

    public Parent() {
    }

    public Parent(int id, String firstName, String lastName, String email, String phone, String address, 
                 String occupation, int userId) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.occupation = occupation;
        this.userId = userId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getOccupation() {
        return occupation;
    }

    public void setOccupation(String occupation) {
        this.occupation = occupation;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    // New methods that were missing
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public int getChildrenCount() {
        return childrenCount;
    }
    
    public void setChildrenCount(int childrenCount) {
        this.childrenCount = childrenCount;
    }

    @Override
    public String toString() {
        return "Parent [id=" + id + ", firstName=" + firstName + ", lastName=" + lastName + 
               ", email=" + email + ", phone=" + phone + "]";
    }
} 