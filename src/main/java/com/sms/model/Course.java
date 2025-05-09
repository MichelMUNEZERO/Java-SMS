package com.sms.model;

public class Course {
    private int id;
    private String courseName;
    private String courseCode;
    private String description;
    private int teacherId;
    private String teacherName;
    private int credits;
    private String status;
    private int studentCount;

    public Course() {
    }

    public Course(int id, String courseName, String courseCode, String description, int teacherId,
                  int credits) {
        this.id = id;
        this.courseName = courseName;
        this.courseCode = courseCode;
        this.description = description;
        this.teacherId = teacherId;
        this.credits = credits;
        this.status = "active"; // Default status
        this.studentCount = 0; // Default student count
    }
    
    public Course(int id, String courseName, String courseCode, String description, int teacherId,
                  int credits, String status) {
        this.id = id;
        this.courseName = courseName;
        this.courseCode = courseCode;
        this.description = description;
        this.teacherId = teacherId;
        this.credits = credits;
        this.status = status;
        this.studentCount = 0; // Default student count
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCourseId() {
        return id;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getCourseCode() {
        return courseCode;
    }

    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(int teacherId) {
        this.teacherId = teacherId;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }

    public int getCredits() {
        return credits;
    }

    public void setCredits(int credits) {
        this.credits = credits;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public int getStudentCount() {
        return studentCount;
    }
    
    public void setStudentCount(int studentCount) {
        this.studentCount = studentCount;
    }
} 