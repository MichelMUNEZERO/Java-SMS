-- Add test users for different roles
-- Note: In a production environment, passwords should be properly hashed

-- Admin user
INSERT INTO Users (username, password, role, email, image_link, active) 
VALUES ('admin', 'admin123', 'admin', 'admin@school.com', '/images/admin.jpg', true);

-- Teacher user
INSERT INTO Users (username, password, role, email, image_link, active)
VALUES ('teacher', 'teacher123', 'teacher', 'teacher@school.com', '/images/teacher.jpg', true);

-- Student user  
INSERT INTO Users (username, password, role, email, image_link, active)
VALUES ('student', 'student123', 'student', 'student@school.com', '/images/student.jpg', true);

-- Parent user
INSERT INTO Users (username, password, role, email, image_link, active)
VALUES ('parent', 'parent123', 'parent', 'parent@school.com', '/images/parent.jpg', true);

-- Create corresponding entries in their respective tables
-- Note: You'll need to run this after inserting the users to maintain foreign key relationships

-- Add a teacher entry
INSERT INTO Teachers (first_name, last_name, email, phone, qualification, experience, specialization, address, user_id)
VALUES ('John', 'Smith', 'teacher@school.com', '123-456-7890', 'M.Ed', 5, 'Mathematics', '123 Teacher St, City', 
       (SELECT user_id FROM Users WHERE username = 'teacher'));

-- Add a student entry
INSERT INTO Students (first_name, last_name, email, phone, address, date_of_birth, reg_number, admission_date, grade, user_id)
VALUES ('Jane', 'Doe', 'student@school.com', '123-456-7891', '456 Student Ave, City', '2005-05-15', 'S12345', '2020-09-01', '10', 
       (SELECT user_id FROM Users WHERE username = 'student'));

-- Add a parent entry
INSERT INTO Parents (first_name, last_name, email, phone, address, occupation, user_id)
VALUES ('Robert', 'Doe', 'parent@school.com', '123-456-7892', '456 Student Ave, City', 'Engineer', 
       (SELECT user_id FROM Users WHERE username = 'parent'));

-- Link parent to student
UPDATE Students 
SET parent_id = (SELECT parent_id FROM Parents WHERE email = 'parent@school.com')
WHERE email = 'student@school.com'; 