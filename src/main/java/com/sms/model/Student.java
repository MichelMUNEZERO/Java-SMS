package com.sms.model;

import java.sql.Date;

/**
 * Student model class
 */
public class Student {
    private int studentId;
    private int userId;
    private String firstName;
    private String lastName;
    private String regNumber;
    private String email;
    private String gender;
    private Date dateOfBirth;
    private String gradeClass;
    private int parentId;
    private String phone;
    private String address;
    private String medicalInfo;
    private String status;
    
    /**
     * Default constructor
     */
    public Student() {
    }
    
    /**
     * Constructor with essential fields
     * @param firstName the first name
     * @param lastName the last name
     * @param regNumber the registration number
     * @param email the email
     * @param gender the gender
     * @param gradeClass the grade/class
     */
    public Student(String firstName, String lastName, String regNumber, String email, String gender, String gradeClass) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.regNumber = regNumber;
        this.email = email;
        this.gender = gender;
        this.gradeClass = gradeClass;
    }
    
    /**
     * Full constructor
     * @param studentId the student id
     * @param userId the user id
     * @param firstName the first name
     * @param lastName the last name
     * @param regNumber the registration number
     * @param email the email
     * @param gender the gender
     * @param dateOfBirth the date of birth
     * @param gradeClass the grade/class
     * @param parentId the parent id
     * @param phone the phone number
     * @param address the address
     * @param medicalInfo the medical information
     * @param status the status
     */
    public Student(int studentId, int userId, String firstName, String lastName, String regNumber, String email, 
                  String gender, Date dateOfBirth, String gradeClass, int parentId, String phone, 
                  String address, String medicalInfo, String status) {
        this.studentId = studentId;
        this.userId = userId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.regNumber = regNumber;
        this.email = email;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.gradeClass = gradeClass;
        this.parentId = parentId;
        this.phone = phone;
        this.address = address;
        this.medicalInfo = medicalInfo;
        this.status = status;
    }
    
    // Getters and setters
    
    public int getStudentId() {
        return studentId;
    }
    
    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
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
    
    public String getRegNumber() {
        return regNumber;
    }
    
    public void setRegNumber(String regNumber) {
        this.regNumber = regNumber;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getGender() {
        return gender;
    }
    
    public void setGender(String gender) {
        this.gender = gender;
    }
    
    public Date getDateOfBirth() {
        return dateOfBirth;
    }
    
    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }
    
    public String getGradeClass() {
        return gradeClass;
    }
    
    public void setGradeClass(String gradeClass) {
        this.gradeClass = gradeClass;
    }
    
    public int getParentId() {
        return parentId;
    }
    
    public void setParentId(int parentId) {
        this.parentId = parentId;
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
    
    public String getMedicalInfo() {
        return medicalInfo;
    }
    
    public void setMedicalInfo(String medicalInfo) {
        this.medicalInfo = medicalInfo;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    /**
     * Get full name
     * @return the full name of the student
     */
    public String getFullName() {
        return firstName + " " + lastName;
    }
    
    @Override
    public String toString() {
        return "Student [studentId=" + studentId + ", firstName=" + firstName + ", lastName=" + lastName + 
                ", regNumber=" + regNumber + ", gradeClass=" + gradeClass + "]";
    }
} 