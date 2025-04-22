package com.sms.model;

import java.util.Date;

/**
 * Appointment model class
 */
public class Appointment {
    private int appointmentId;
    private String purpose;
    private Integer responsible;
    private Date date;
    private String status;
    private String notes;
    
    /**
     * Default constructor
     */
    public Appointment() {
    }
    
    /**
     * Constructor with all fields except id
     * @param purpose the appointment purpose
     * @param responsible the ID of the responsible person
     * @param date the appointment date
     * @param status the appointment status
     * @param notes additional notes
     */
    public Appointment(String purpose, Integer responsible, Date date, String status, String notes) {
        this.purpose = purpose;
        this.responsible = responsible;
        this.date = date;
        this.status = status;
        this.notes = notes;
    }
    
    /**
     * Constructor with all fields
     * @param appointmentId the appointment id
     * @param purpose the appointment purpose
     * @param responsible the ID of the responsible person
     * @param date the appointment date
     * @param status the appointment status
     * @param notes additional notes
     */
    public Appointment(int appointmentId, String purpose, Integer responsible, Date date, String status, String notes) {
        this.appointmentId = appointmentId;
        this.purpose = purpose;
        this.responsible = responsible;
        this.date = date;
        this.status = status;
        this.notes = notes;
    }
    
    public int getAppointmentId() {
        return appointmentId;
    }
    
    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }
    
    public String getPurpose() {
        return purpose;
    }
    
    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }
    
    public Integer getResponsible() {
        return responsible;
    }
    
    public void setResponsible(Integer responsible) {
        this.responsible = responsible;
    }
    
    public Date getDate() {
        return date;
    }
    
    public void setDate(Date date) {
        this.date = date;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    @Override
    public String toString() {
        return "Appointment [appointmentId=" + appointmentId + ", purpose=" + purpose + 
               ", responsible=" + responsible + ", date=" + date + 
               ", status=" + status + ", notes=" + notes + "]";
    }
} 