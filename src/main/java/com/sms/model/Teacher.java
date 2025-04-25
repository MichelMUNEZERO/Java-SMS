package com.sms.model;

import java.sql.Date;

/**
 * Model class for teachers in the School Management System
 */
public class Teacher {
    private int id;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String qualification;
    private int experience;
    private String specialization;
    private String address;
    private int userId;
    private String imageLink;
    private Date joinDate;
    private String status;
    
    /**
     * Default constructor
     */
    public Teacher() {
    }
    
    /**
     * Constructor with essential fields
     */
    public Teacher(String firstName, String lastName, String email, String phone, 
                  String qualification, int experience, String specialization) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.qualification = qualification;
        this.experience = experience;
        this.specialization = specialization;
    }
    
    /**
     * Constructor with all fields
     */
    public Teacher(int id, String firstName, String lastName, String email, String phone,
                  String qualification, int experience, String specialization, String address,
                  int userId, String imageLink, Date joinDate, String status) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.qualification = qualification;
        this.experience = experience;
        this.specialization = specialization;
        this.address = address;
        this.userId = userId;
        this.imageLink = imageLink;
        this.joinDate = joinDate;
        this.status = status;
    }
    
    // Getters and Setters
    
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
    
    public String getQualification() {
        return qualification;
    }
    
    public void setQualification(String qualification) {
        this.qualification = qualification;
    }
    
    public int getExperience() {
        return experience;
    }
    
    public void setExperience(int experience) {
        this.experience = experience;
    }
    
    public String getSpecialization() {
        return specialization;
    }
    
    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getImageLink() {
        return imageLink;
    }
    
    public void setImageLink(String imageLink) {
        this.imageLink = imageLink;
    }
    
    public Date getJoinDate() {
        return joinDate;
    }
    
    public void setJoinDate(Date joinDate) {
        this.joinDate = joinDate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
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
        return "Teacher [id=" + id + ", firstName=" + firstName + ", lastName=" + lastName + ", email=" + email
                + ", qualification=" + qualification + ", experience=" + experience + ", specialization="
                + specialization + "]";
    }
} 