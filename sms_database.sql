-- MySQL database schema for School Management System

-- Create the database
CREATE DATABASE IF NOT EXISTS SMS;
USE SMS;

-- Users table
CREATE TABLE IF NOT EXISTS Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    UserType ENUM('Admin', 'Teacher', 'Student', 'Parent', 'Staff') NOT NULL,
    ImageLink VARCHAR(255)
);

-- Teachers table
CREATE TABLE IF NOT EXISTS Teachers (
    TeacherId INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    CourseId INT,
    Qualification VARCHAR(100) NOT NULL,
    Experience INT,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Telephone VARCHAR(20) NOT NULL
);

-- Students table
CREATE TABLE IF NOT EXISTS Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    reg_number VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    gender VARCHAR(10),
    date_of_birth DATE,
    grade_class VARCHAR(20),
    parent_id INT,
    phone VARCHAR(20),
    address TEXT,
    medical_info TEXT,
    status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Parents table
CREATE TABLE IF NOT EXISTS Parents (
    ParentId INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Telephone VARCHAR(20) NOT NULL,
    Location VARCHAR(100)
);

-- Student-Parent relationship
CREATE TABLE IF NOT EXISTS StudentParent (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT,
    ParentId INT,
    FOREIGN KEY (StudentID) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (ParentId) REFERENCES Parents(ParentId) ON DELETE CASCADE
);

-- Courses table
CREATE TABLE IF NOT EXISTS Courses (
    CourseId INT AUTO_INCREMENT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    Description TEXT,
    TeacherId INT,
    FOREIGN KEY (TeacherId) REFERENCES Teachers(TeacherId) ON DELETE SET NULL
);

-- Add foreign key to Teachers table
ALTER TABLE Teachers 
ADD CONSTRAINT fk_teacher_course 
FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) ON DELETE SET NULL;

-- Student-Course relationship
CREATE TABLE IF NOT EXISTS student_courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(CourseId) ON DELETE CASCADE
);

-- Marks table
CREATE TABLE IF NOT EXISTS Marks (
    MarksId INT AUTO_INCREMENT PRIMARY KEY,
    CourseId INT,
    StudentId INT,
    Marks FLOAT NOT NULL,
    Grade VARCHAR(5),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) ON DELETE CASCADE,
    FOREIGN KEY (StudentId) REFERENCES Students(student_id) ON DELETE CASCADE
);

-- Announcement table
CREATE TABLE IF NOT EXISTS Announcement (
    AnnouncementId INT AUTO_INCREMENT PRIMARY KEY,
    Message TEXT NOT NULL,
    Date DATETIME NOT NULL,
    TargetGroup ENUM('All', 'Teachers', 'Students', 'Parents') NOT NULL
);

-- StudentBehavior table
CREATE TABLE IF NOT EXISTS StudentBehavior (
    BehaviorId INT AUTO_INCREMENT PRIMARY KEY,
    StudentId INT,
    Behavior VARCHAR(100) NOT NULL,
    Description TEXT,
    Date DATE NOT NULL,
    FOREIGN KEY (StudentId) REFERENCES Students(student_id) ON DELETE CASCADE
);

-- StudentTracking table
CREATE TABLE IF NOT EXISTS StudentTracking (
    TrackId INT AUTO_INCREMENT PRIMARY KEY,
    StudentId INT,
    Status ENUM('Present', 'Absent', 'Late') NOT NULL,
    Progress VARCHAR(100),
    Location VARCHAR(100),
    Date DATE NOT NULL,
    FOREIGN KEY (StudentId) REFERENCES Students(student_id) ON DELETE CASCADE
);

-- Reports table
CREATE TABLE IF NOT EXISTS Reports (
    ReportId INT AUTO_INCREMENT PRIMARY KEY,
    Type VARCHAR(50) NOT NULL,
    Date DATE NOT NULL,
    Content TEXT
);

-- Appointment table
CREATE TABLE IF NOT EXISTS Appointment (
    AppointmentId INT AUTO_INCREMENT PRIMARY KEY,
    Purpose VARCHAR(100) NOT NULL,
    Responsible INT,
    Date DATETIME NOT NULL,
    Status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    Notes TEXT
);

-- Nurses table
CREATE TABLE IF NOT EXISTS Nurses (
    NurseId INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Telephone VARCHAR(20) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Address TEXT,
    HealthCenter VARCHAR(100)
);

-- Doctors table
CREATE TABLE IF NOT EXISTS Doctors (
    DoctorId INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Telephone VARCHAR(20) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Address TEXT,
    HospitalName VARCHAR(100)
);

-- Diagnosis table
CREATE TABLE IF NOT EXISTS Diagnosis (
    DiagnosisID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    NurseID INT,
    DoctorID INT,
    DiagnoStatus VARCHAR(100) NOT NULL,
    Result TEXT,
    Date DATETIME NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (NurseID) REFERENCES Nurses(NurseId) ON DELETE SET NULL,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorId) ON DELETE SET NULL
);

-- Insert default admin user
INSERT INTO Users (Username, Password, UserType) 
VALUES ('admin', '$2a$10$D5H/P1ZjuDDwvt3jXXCrIehQFkX0PJux9rDk7ukLAT/MYnKE8n9/2', 'Admin');
-- Default password is 'admin123' (hashed with BCrypt) 