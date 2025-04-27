package com.sms.model;

/**
 * Doctor model class representing a doctor in the system
 */
public class Doctor {
    private int doctorId;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String specialization;
    private String hospital;
    private Integer userId;

    /**
     * Default constructor
     */
    public Doctor() {
    }

    /**
     * Constructor with all fields
     */
    public Doctor(int doctorId, String firstName, String lastName, String email, 
                 String phone, String specialization, String hospital, Integer userId) {
        this.doctorId = doctorId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.specialization = specialization;
        this.hospital = hospital;
        this.userId = userId;
    }

    // Getters and Setters
    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
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

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }

    public String getHospital() {
        return hospital;
    }

    public void setHospital(String hospital) {
        this.hospital = hospital;
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
        return "Doctor [doctorId=" + doctorId + ", firstName=" + firstName + ", lastName=" + lastName + 
               ", email=" + email + ", specialization=" + specialization + ", hospital=" + hospital + "]";
    }
} 