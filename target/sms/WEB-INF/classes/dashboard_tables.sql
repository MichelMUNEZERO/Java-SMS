-- Tests table
CREATE TABLE Tests (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    test_name VARCHAR(100) NOT NULL,
    description TEXT,
    test_date DATE NOT NULL,
    duration INT, -- Duration in minutes
    max_marks INT,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- Sample data for Tests
INSERT INTO Tests (course_id, test_name, description, test_date, duration, max_marks)
VALUES 
    (1, 'Algebra and Calculus', 'Mid-term test covering algebra and calculus', DATE_ADD(CURDATE(), INTERVAL 1 DAY), 90, 100),
    (3, 'Mechanics and Thermodynamics', 'Physics test on mechanics and thermodynamics', DATE_ADD(CURDATE(), INTERVAL 3 DAY), 120, 100),
    (2, 'Shakespearean Sonnets', 'Analysis of Shakespearean sonnets', DATE_ADD(CURDATE(), INTERVAL 10 DAY), 90, 100);

-- Assignments table
CREATE TABLE Assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    assignment_name VARCHAR(100) NOT NULL,
    description TEXT,
    due_date DATE NOT NULL,
    max_marks INT,
    priority VARCHAR(20) DEFAULT 'medium', -- 'high', 'medium', 'low'
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- Sample data for Assignments
INSERT INTO Assignments (course_id, assignment_name, description, due_date, max_marks, priority)
VALUES 
    (1, 'Calculus Problems', 'Set of calculus problems from chapter 5', DATE_ADD(CURDATE(), INTERVAL 1 DAY), 50, 'high'),
    (3, 'Lab Report', 'Lab report on the pendulum experiment', DATE_ADD(CURDATE(), INTERVAL 3 DAY), 30, 'medium'),
    (4, 'Programming Project', 'Implement a simple database system in Java', DATE_ADD(CURDATE(), INTERVAL 7 DAY), 100, 'low');

-- Assignment Submissions table
CREATE TABLE Assignment_Submissions (
    submission_id INT AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT NOT NULL,
    student_id INT NOT NULL,
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    file_path VARCHAR(255),
    comments TEXT,
    marks INT,
    status VARCHAR(20) DEFAULT 'submitted', -- 'submitted', 'graded', 'returned'
    FOREIGN KEY (assignment_id) REFERENCES Assignments(assignment_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE
);

-- Class Schedule table
CREATE TABLE ClassSchedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    day_of_week INT NOT NULL, -- 1 = Sunday, 2 = Monday, ..., 7 = Saturday
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    room_number VARCHAR(20),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- Sample data for ClassSchedule (assuming today is a weekday)
INSERT INTO ClassSchedule (course_id, day_of_week, start_time, end_time, room_number)
VALUES 
    (1, DAYOFWEEK(CURDATE()), '08:00:00', '09:30:00', '301'),
    (2, DAYOFWEEK(CURDATE()), '09:45:00', '11:15:00', '203'),
    (3, DAYOFWEEK(CURDATE()), '11:30:00', '13:00:00', '305'),
    (4, DAYOFWEEK(CURDATE()), '14:00:00', '15:30:00', '401'); 