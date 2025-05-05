package com.sms.model;

import java.util.Date;

/**
 * Model class representing a student health record
 */
public class HealthRecord {
    private Integer recordId;
    private Integer studentId;
    private Date recordDate;
    private String recordType;
    private String description;
    private String treatment;
    private String medication;
    private Integer doctorId;
    private String doctorName;
    private Integer nurseId;
    private String nurseName;
    private Date nextAppointment;
    private String notes;
    
    /**
     * Default constructor
     */
    public HealthRecord() {
    }
    
    /**
     * Constructor with all fields
     */
    public HealthRecord(Integer recordId, Integer studentId, Date recordDate, String recordType, 
                      String description, String treatment, String medication, Integer doctorId, 
                      String doctorName, Integer nurseId, String nurseName, Date nextAppointment, String notes) {
        this.recordId = recordId;
        this.studentId = studentId;
        this.recordDate = recordDate;
        this.recordType = recordType;
        this.description = description;
        this.treatment = treatment;
        this.medication = medication;
        this.doctorId = doctorId;
        this.doctorName = doctorName;
        this.nurseId = nurseId;
        this.nurseName = nurseName;
        this.nextAppointment = nextAppointment;
        this.notes = notes;
    }
    
    // Getters and Setters
    public Integer getRecordId() {
        return recordId;
    }
    
    public void setRecordId(Integer recordId) {
        this.recordId = recordId;
    }
    
    public Integer getStudentId() {
        return studentId;
    }
    
    public void setStudentId(Integer studentId) {
        this.studentId = studentId;
    }
    
    public Date getRecordDate() {
        return recordDate;
    }
    
    public void setRecordDate(Date recordDate) {
        this.recordDate = recordDate;
    }
    
    public String getRecordType() {
        return recordType;
    }
    
    public void setRecordType(String recordType) {
        this.recordType = recordType;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getTreatment() {
        return treatment;
    }
    
    public void setTreatment(String treatment) {
        this.treatment = treatment;
    }
    
    public String getMedication() {
        return medication;
    }
    
    public void setMedication(String medication) {
        this.medication = medication;
    }
    
    public Integer getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(Integer doctorId) {
        this.doctorId = doctorId;
    }
    
    public String getDoctorName() {
        return doctorName;
    }
    
    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }
    
    public Integer getNurseId() {
        return nurseId;
    }
    
    public void setNurseId(Integer nurseId) {
        this.nurseId = nurseId;
    }
    
    public String getNurseName() {
        return nurseName;
    }
    
    public void setNurseName(String nurseName) {
        this.nurseName = nurseName;
    }
    
    public Date getNextAppointment() {
        return nextAppointment;
    }
    
    public void setNextAppointment(Date nextAppointment) {
        this.nextAppointment = nextAppointment;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
} 