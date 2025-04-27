package com.sms.model;

/**
 * Nurse model class representing a nurse in the system
 */
public class Nurse {
    private int nurseId;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String qualification;
    private Integer userId;

    /**
     * Default constructor
     */
    public Nurse() {
    }

    /**
     * Constructor with all fields
     */
    public Nurse(int nurseId, String firstName, String lastName, String email, 
                String phone, String qualification, Integer userId) {
        this.nurseId = nurseId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.qualification = qualification;
        this.userId = userId;
    }

    // Getters and Setters
    public int getNurseId() {
        return nurseId;
    }

    public void setNurseId(int nurseId) {
        this.nurseId = nurseId;
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

    public String getQualification() {
        return qualification;
    }

    public void setQualification(String qualification) {
        this.qualification = qualification;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    /**
     * Get full name by combining first and last name
     * @return Full name
     */
    public String getFullName() {
        return firstName + " " + lastName;
    }

    @Override
    public String toString() {
        return "Nurse [nurseId=" + nurseId + ", firstName=" + firstName + 
               ", lastName=" + lastName + ", email=" + email + 
               ", qualification=" + qualification + "]";
    }
} 