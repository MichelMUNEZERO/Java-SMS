package com.sms.model;

/**
 * Mark model class
 */
public class Mark {
    private int marksId;
    private int courseId;
    private int studentId;
    private float marks;
    private String grade;
    
    // Additional fields for displaying course and student names
    private String courseName;
    private String studentName;
    
    /**
     * Default constructor
     */
    public Mark() {
    }
    
    /**
     * Constructor with all fields except marksId
     * @param courseId the course id
     * @param studentId the student id
     * @param marks the marks
     * @param grade the grade
     */
    public Mark(int courseId, int studentId, float marks, String grade) {
        this.courseId = courseId;
        this.studentId = studentId;
        this.marks = marks;
        this.grade = grade;
    }
    
    /**
     * Constructor with all fields
     * @param marksId the marks id
     * @param courseId the course id
     * @param studentId the student id
     * @param marks the marks
     * @param grade the grade
     */
    public Mark(int marksId, int courseId, int studentId, float marks, String grade) {
        this.marksId = marksId;
        this.courseId = courseId;
        this.studentId = studentId;
        this.marks = marks;
        this.grade = grade;
    }
    
    // Getters and setters
    
    public int getMarksId() {
        return marksId;
    }
    
    public void setMarksId(int marksId) {
        this.marksId = marksId;
    }
    
    public int getCourseId() {
        return courseId;
    }
    
    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }
    
    public int getStudentId() {
        return studentId;
    }
    
    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }
    
    public float getMarks() {
        return marks;
    }
    
    public void setMarks(float marks) {
        this.marks = marks;
    }
    
    public String getGrade() {
        return grade;
    }
    
    public void setGrade(String grade) {
        this.grade = grade;
    }
    
    public String getCourseName() {
        return courseName;
    }
    
    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }
    
    public String getStudentName() {
        return studentName;
    }
    
    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }
    
    /**
     * Calculate the grade based on marks
     * @param marks the marks
     * @return the corresponding grade
     */
    public static String calculateGrade(float marks) {
        if (marks >= 90) {
            return "A+";
        } else if (marks >= 80) {
            return "A";
        } else if (marks >= 70) {
            return "B";
        } else if (marks >= 60) {
            return "C";
        } else if (marks >= 50) {
            return "D";
        } else {
            return "F";
        }
    }
    
    @Override
    public String toString() {
        return "Mark [marksId=" + marksId + ", courseId=" + courseId + ", studentId=" + studentId + 
                ", marks=" + marks + ", grade=" + grade + "]";
    }
} 
 