-- Create the Attendance table which is missing from schema but referenced in code
CREATE TABLE IF NOT EXISTS Attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL, 
    date DATE NOT NULL,
    status ENUM('present', 'absent', 'late') NOT NULL DEFAULT 'present',
    remarks TEXT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- Insert some sample data
INSERT INTO Attendance (student_id, course_id, date, status, remarks)
SELECT s.student_id, c.course_id, CURDATE() - INTERVAL (RAND() * 30) DAY, 
    CASE 
        WHEN RAND() < 0.8 THEN 'present' 
        WHEN RAND() < 0.9 THEN 'late' 
        ELSE 'absent' 
    END,
    CASE 
        WHEN RAND() < 0.8 THEN NULL 
        ELSE 'Student provided excuse note' 
    END
FROM Students s
CROSS JOIN Courses c
WHERE (s.student_id, c.course_id) IN (
    SELECT student_id, course_id FROM Student_Courses
)
LIMIT 50; 