-- Drop database if exists and create a new one
DROP DATABASE IF EXISTS SMS;
CREATE DATABASE SMS;
USE SMS;

-- Users table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE,
    image_link VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    active BOOLEAN DEFAULT TRUE
);

-- Teachers table
CREATE TABLE Teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    qualification VARCHAR(100),
    experience INT,
    specialization VARCHAR(100),
    address VARCHAR(255),
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- Students table
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255),
    date_of_birth DATE,
    reg_number VARCHAR(20) UNIQUE NOT NULL,
    admission_date DATE,
    grade VARCHAR(10),
    parent_id INT,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- Parents table
CREATE TABLE Parents (
    parent_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(255),
    occupation VARCHAR(100),
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- Update Students table to add foreign key for parents
ALTER TABLE Students 
ADD CONSTRAINT fk_student_parent 
FOREIGN KEY (parent_id) REFERENCES Parents(parent_id) ON DELETE SET NULL;

-- Courses table
CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    description TEXT,
    credits INT,
    teacher_id INT,
    status VARCHAR(20) DEFAULT 'active',
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id) ON DELETE SET NULL
);

-- Student-Course enrollment table
CREATE TABLE Student_Courses (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    UNIQUE (student_id, course_id)
);

-- Marks table
CREATE TABLE Marks (
    mark_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    assessment_type VARCHAR(50) NOT NULL,
    score DECIMAL(5,2) NOT NULL,
    max_score DECIMAL(5,2) NOT NULL,
    term VARCHAR(20),
    assessment_date DATE,
    remarks TEXT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- Appointment table
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    appointment_date DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'Scheduled',
    created_by INT,
    student_id INT,
    parent_id INT,
    teacher_id INT,
    FOREIGN KEY (created_by) REFERENCES Users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES Parents(parent_id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id) ON DELETE CASCADE
);

-- Announcement table
CREATE TABLE Announcements (
    announcement_id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    target_audience VARCHAR(50) NOT NULL, -- 'All', 'Teachers', 'Students', 'Parents'
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- Student Behavior table
CREATE TABLE StudentBehavior (
    behavior_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    behavior_type VARCHAR(50) NOT NULL, -- 'Positive', 'Negative'
    description TEXT NOT NULL,
    behavior_date DATE NOT NULL,
    reported_by INT NOT NULL,
    action_taken TEXT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (reported_by) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Student Tracking table
CREATE TABLE StudentTracking (
    tracking_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    tracking_date DATE NOT NULL,
    attendance_status VARCHAR(20) NOT NULL, -- 'Present', 'Absent', 'Late'
    arrival_time TIME,
    departure_time TIME,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE
);

-- Reports table
CREATE TABLE Reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    report_type VARCHAR(50) NOT NULL,
    report_name VARCHAR(100) NOT NULL,
    generated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    generated_by INT,
    file_path VARCHAR(255),
    parameters TEXT,
    FOREIGN KEY (generated_by) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- HEALTH-RELATED TABLES

-- Nurses table
CREATE TABLE Nurses (
    nurse_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    qualification VARCHAR(100),
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- Doctors table
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    specialization VARCHAR(100),
    hospital VARCHAR(100),
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- Diagnosis table
CREATE TABLE Diagnosis (
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    diagnosis_date DATETIME NOT NULL,
    symptoms TEXT,
    diagnosis TEXT NOT NULL,
    treatment TEXT,
    nurse_id INT,
    doctor_id INT,
    follow_up_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (nurse_id) REFERENCES Nurses(nurse_id) ON DELETE SET NULL,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE SET NULL
);

-- Create an admin user
INSERT INTO Users (username, password, role, email, active) 
VALUES ('admin', '$2a$10$h.dl5J86rGH7I8bD9bZeZe', 'admin', 'admin@school.com', true); 