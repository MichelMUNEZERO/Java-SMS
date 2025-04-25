USE SMS;

-- Add some users (if not already present)
INSERT INTO Users (username, password, role, email, active) 
VALUES
('teacher1', '$2a$10$h.dl5J86rGH7I8bD9bZeZe', 'teacher', 'teacher1@school.com', true),
('parent1', '$2a$10$h.dl5J86rGH7I8bD9bZeZe', 'parent', 'parent1@gmail.com', true),
('student1', '$2a$10$h.dl5J86rGH7I8bD9bZeZe', 'student', 'student1@school.com', true);

-- Add a teacher
INSERT INTO Teachers (first_name, last_name, email, phone, qualification, experience, specialization, address, user_id)
SELECT 'John', 'Smith', 'teacher1@school.com', '555-123-4567', 'Master of Education', 5, 'Mathematics', '123 Faculty Street', user_id
FROM Users WHERE username = 'teacher1' AND NOT EXISTS (SELECT 1 FROM Teachers WHERE email = 'teacher1@school.com');

-- Add a parent
INSERT INTO Parents (first_name, last_name, email, phone, address, occupation, user_id)
SELECT 'Robert', 'Johnson', 'parent1@gmail.com', '555-987-6543', '456 Parent Ave', 'Engineer', user_id
FROM Users WHERE username = 'parent1' AND NOT EXISTS (SELECT 1 FROM Parents WHERE email = 'parent1@gmail.com');

-- Add a student
INSERT INTO Students (first_name, last_name, email, phone, address, date_of_birth, reg_number, admission_date, grade, parent_id, user_id)
SELECT 'Michael', 'Johnson', 'student1@school.com', '555-111-2222', '456 Parent Ave', '2008-05-10', 'STU20240001', '2023-09-01', '9', 
    (SELECT parent_id FROM Parents WHERE email = 'parent1@gmail.com'), 
    (SELECT user_id FROM Users WHERE username = 'student1')
WHERE NOT EXISTS (SELECT 1 FROM Students WHERE email = 'student1@school.com');

-- Add a course
INSERT INTO Courses (course_name, course_code, description, credits, teacher_id)
SELECT 'Algebra I', 'MATH101', 'Introduction to algebraic concepts', 4, teacher_id
FROM Teachers WHERE email = 'teacher1@school.com' AND NOT EXISTS (SELECT 1 FROM Courses WHERE course_code = 'MATH101');

-- Enroll student in course
INSERT INTO Student_Courses (student_id, course_id)
SELECT s.student_id, c.course_id
FROM Students s, Courses c
WHERE s.email = 'student1@school.com' AND c.course_code = 'MATH101'
AND NOT EXISTS (SELECT 1 FROM Student_Courses sc WHERE sc.student_id = s.student_id AND sc.course_id = c.course_id);

-- Add an announcement
INSERT INTO Announcements (content, target_audience, created_by)
SELECT 'Welcome to the new school year! This is a test announcement.', 'All', user_id
FROM Users WHERE username = 'admin' AND NOT EXISTS (SELECT 1 FROM Announcements WHERE content LIKE 'Welcome to the new school year%'); 