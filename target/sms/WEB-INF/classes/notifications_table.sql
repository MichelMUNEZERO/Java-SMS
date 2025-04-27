-- Notifications table
CREATE TABLE Notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    notification_type VARCHAR(50) NOT NULL, -- 'Grade', 'Announcement', 'Assignment', 'Calendar'
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    related_id INT, -- ID of related entity (grade_id, announcement_id, etc.)
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE
);

-- Sample data for Notifications
INSERT INTO Notifications (student_id, notification_type, content, is_read, related_id)
VALUES 
    (1, 'Grade', 'Your Physics quiz has been graded.', false, 1),
    (1, 'Announcement', 'Field trip permission slips due this Friday.', false, 1),
    (1, 'Assignment', 'Don''t forget to submit your Math homework!', false, 1),
    (1, 'Calendar', 'School holiday announced for next Monday.', false, 1),
    (2, 'Grade', 'Your Math test has been graded.', false, 2),
    (2, 'Announcement', 'Parent-teacher meeting next week.', false, 2),
    (3, 'Assignment', 'New English assignment added.', false, 3); 