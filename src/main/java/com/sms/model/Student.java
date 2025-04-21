package com.sms.model;

/**
 * Student model class
 */
public class Student {
    private int studentId;
    private String firstName;
    private String lastName;
    private String regNumber;
    private String telephone;
    private String email;
    private String address;
    
    /**
     * Default constructor
     */
    public Student() {
    }
    
    /**
     * Constructor with all fields except studentId
     * @param firstName the first name
     * @param lastName the last name
     * @param regNumber the registration number
     * @param telephone the telephone
     * @param email the email
     * @param address the address
     */
    public Student(String firstName, String lastName, String regNumber, String telephone, String email, String address) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.regNumber = regNumber;
        this.telephone = telephone;
        this.email = email;
        this.address = address;
    }
    
    /**
     * Constructor with all fields
     * @param studentId the student id
     * @param firstName the first name
     * @param lastName the last name
     * @param regNumber the registration number
     * @param telephone the telephone
     * @param email the email
     * @param address the address
     */
    public Student(int studentId, String firstName, String lastName, String regNumber, String telephone, String email, String address) {
        this.studentId = studentId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.regNumber = regNumber;
        this.telephone = telephone;
        this.email = email;
        this.address = address;
    }
    
    // Getters and setters
    
    public int getStudentId() {
        return studentId;
    }
    
    public void setStudentId(int studentId) {
        this.studentId = studentId;
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
    
    public String getTelephone() {
        return telephone;
    }
    
    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
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
                ", regNumber=" + regNumber + "]";
    }
} 