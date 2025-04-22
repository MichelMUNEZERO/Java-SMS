-- MySQL database schema for School Management System
-- Creates the database and all required tables

-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS SMS;
USE SMS;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('ADMIN', 'TEACHER', 'STUDENT', 'PARENT') NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE', 'PENDING') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL
);

-- Teachers table
CREATE TABLE IF NOT EXISTS teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    specialization VARCHAR(100),
    qualification VARCHAR(100),
    experience INT,
    join_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Students table
CREATE TABLE IF NOT EXISTS students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    reg_number VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    gender ENUM('MALE', 'FEMALE', 'OTHER') NOT NULL,
    date_of_birth DATE,
    grade_class VARCHAR(20),
    parent_id INT,
    phone VARCHAR(20),
    address TEXT,
    medical_info TEXT,
    status ENUM('ACTIVE', 'INACTIVE', 'GRADUATED', 'SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Parents table
CREATE TABLE IF NOT EXISTS parents (
    parent_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    address TEXT,
    occupation VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Add foreign key constraint for parent_id in students
ALTER TABLE students
ADD CONSTRAINT fk_student_parent
FOREIGN KEY (parent_id) REFERENCES parents(parent_id) ON DELETE SET NULL;

-- Courses table
CREATE TABLE IF NOT EXISTS courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    description TEXT,
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id) ON DELETE SET NULL
);

-- Student-Course enrollments join table
CREATE TABLE IF NOT EXISTS student_courses (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Marks/Grades table
CREATE TABLE IF NOT EXISTS marks (
    mark_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    assessment_type VARCHAR(50) NOT NULL,
    score DECIMAL(5,2) NOT NULL,
    max_score DECIMAL(5,2) NOT NULL,
    grade VARCHAR(5),
    remarks TEXT,
    date_recorded TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Attendance table
CREATE TABLE IF NOT EXISTS attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    date DATE NOT NULL,
    status ENUM('PRESENT', 'ABSENT', 'LATE', 'EXCUSED') NOT NULL,
    remarks TEXT,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Announcements table
CREATE TABLE IF NOT EXISTS announcements (
    announcement_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    created_by INT NOT NULL,
    target_audience ENUM('ALL', 'TEACHERS', 'STUDENTS', 'PARENTS') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Course materials table
CREATE TABLE IF NOT EXISTS course_materials (
    material_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    file_path VARCHAR(255),
    uploaded_by INT NOT NULL,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Insert default admin user with BCrypt hashed password
-- admin123 hashed with BCrypt
INSERT INTO users (username, password, email, role)
VALUES ('admin', '$2a$10$vQyTh.ELiD0g7dBpECegwuXLnVYRs7MfhIZRVTpZm9ATmPdG.FQoC', 'admin@school.com', 'ADMIN');

-- Insert a teacher with BCrypt hashed password
-- teacher123 hashed with BCrypt
INSERT INTO users (username, password, email, role)
VALUES ('teacher1', '$2a$10$H4Gg4kH.Mjo7dLz2nFXx4Op6PhT.ruJ1iKQVm4tScPCFNJRzYuGIa', 'teacher1@school.com', 'TEACHER');

INSERT INTO teachers (user_id, first_name, last_name, email, phone, specialization, qualification, experience)
VALUES (2, 'John', 'Smith', 'teacher1@school.com', '123-456-7890', 'Mathematics', 'M.Sc Mathematics', 5);

-- Insert a student with BCrypt hashed password
-- student123 hashed with BCrypt
INSERT INTO users (username, password, email, role)
VALUES ('student1', '$2a$10$EcPz78BbkPR9.FH0SQoI5ObxQ1S2ZYjj8sJPFxPd0ZzSJZE0A.UDq', 'student1@school.com', 'STUDENT');

INSERT INTO students (user_id, first_name, last_name, reg_number, email, gender, grade_class)
VALUES (3, 'Emily', 'Jones', 'S001', 'student1@school.com', 'FEMALE', '10-A');

-- Insert a parent with BCrypt hashed password
-- parent123 hashed with BCrypt
INSERT INTO users (username, password, email, role)
VALUES ('parent1', '$2a$10$I4c7C6veN2lI.PBlB2jT9eun/tILTFbJMxw5AHGc5hsVQkYgzH0Rm', 'parent1@example.com', 'PARENT');

INSERT INTO parents (user_id, first_name, last_name, email, phone)
VALUES (4, 'Robert', 'Jones', 'parent1@example.com', '987-654-3210');

-- Update student with parent ID
UPDATE students SET parent_id = 1 WHERE student_id = 1;

-- Insert some courses
INSERT INTO courses (course_name, description, teacher_id)
VALUES 
('Mathematics', 'Advanced mathematics including algebra, geometry, and calculus', 1),
('Physics', 'Study of matter, energy, and their interactions', 1),
('Chemistry', 'Study of substances, their properties, and reactions', 1);

-- Enroll the student in courses
INSERT INTO student_courses (student_id, course_id)
VALUES 
(1, 1),
(1, 2),
(1, 3); 