package com.sms.model;

/**
 * Teacher model class
 */
public class Teacher {
    private int teacherId;
    private int userId;
    private String firstName;
    private String lastName;
    private int courseId;
    private String qualification;
    private int experience;
    private String email;
    private String telephone;
    private String password;
    private String phone;
    private String address;
    private String specialization;
    
    /**
     * Default constructor
     */
    public Teacher() {
    }
    
    /**
     * Constructor with all fields except teacherId
     * @param firstName the first name
     * @param lastName the last name
     * @param courseId the course id
     * @param qualification the qualification
     * @param experience the experience in years
     * @param email the email
     * @param telephone the telephone
     */
    public Teacher(String firstName, String lastName, int courseId, String qualification, int experience, String email, String telephone) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.courseId = courseId;
        this.qualification = qualification;
        this.experience = experience;
        this.email = email;
        this.telephone = telephone;
    }
    
    /**
     * Constructor with all fields
     * @param teacherId the teacher id
     * @param firstName the first name
     * @param lastName the last name
     * @param courseId the course id
     * @param qualification the qualification
     * @param experience the experience in years
     * @param email the email
     * @param telephone the telephone
     */
    public Teacher(int teacherId, String firstName, String lastName, int courseId, String qualification, int experience, String email, String telephone) {
        this.teacherId = teacherId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.courseId = courseId;
        this.qualification = qualification;
        this.experience = experience;
        this.email = email;
        this.telephone = telephone;
    }
    
    // Getters and setters
    
    public int getTeacherId() {
        return teacherId;
    }
    
    public void setTeacherId(int teacherId) {
        this.teacherId = teacherId;
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
    
    public int getCourseId() {
        return courseId;
    }
    
    public void setCourseId(int courseId) {
        this.courseId = courseId;
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
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
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
    
    public String getSpecialization() {
        return specialization;
    }
    
    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }
    
    /**
     * Get full name
     * @return the full name of the teacher
     */
    public String getFullName() {
        return firstName + " " + lastName;
    }
    
    @Override
    public String toString() {
        return "Teacher [teacherId=" + teacherId + ", firstName=" + firstName + ", lastName=" + lastName + ", email=" + email + "]";
    }
} 