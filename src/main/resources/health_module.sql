-- Health Module SQL Script

-- Add doctor and nurse users

-- Doctor user
INSERT INTO Users (username, password, role, email, image_link, active) 
VALUES ('doctor', 'doctor123', 'doctor', 'doctor@school.com', '/images/doctor.jpg', true);

-- Nurse user
INSERT INTO Users (username, password, role, email, image_link, active) 
VALUES ('nurse', 'nurse123', 'nurse', 'nurse@school.com', '/images/nurse.jpg', true);

-- Add a doctor entry
INSERT INTO Doctors (first_name, last_name, email, phone, specialization, hospital, user_id)
VALUES ('Michael', 'Johnson', 'doctor@school.com', '555-123-4567', 'Pediatrics', 'City General Hospital', 
       (SELECT user_id FROM Users WHERE username = 'doctor'));

-- Add a nurse entry
INSERT INTO Nurses (first_name, last_name, email, phone, qualification, user_id)
VALUES ('Sarah', 'Williams', 'nurse@school.com', '555-987-6543', 'Registered Nurse (RN)', 
       (SELECT user_id FROM Users WHERE username = 'nurse'));

-- Add some sample diagnosis data
INSERT INTO Diagnosis (student_id, diagnosis_date, symptoms, diagnosis, treatment, nurse_id, doctor_id, follow_up_date)
SELECT 
    s.student_id,
    NOW() - INTERVAL FLOOR(RAND() * 30) DAY,
    CASE 
        WHEN RAND() < 0.3 THEN 'Fever, headache, fatigue'
        WHEN RAND() < 0.6 THEN 'Cough, runny nose, sore throat'
        ELSE 'Stomach pain, nausea'
    END AS symptoms,
    CASE 
        WHEN RAND() < 0.3 THEN 'Common cold'
        WHEN RAND() < 0.6 THEN 'Seasonal allergies'
        ELSE 'Minor stomach infection'
    END AS diagnosis,
    CASE 
        WHEN RAND() < 0.3 THEN 'Rest, fluids, over-the-counter pain reliever'
        WHEN RAND() < 0.6 THEN 'Antihistamines, nasal spray'
        ELSE 'Light diet, increased fluids, probiotics'
    END AS treatment,
    (SELECT nurse_id FROM Nurses LIMIT 1),
    (SELECT doctor_id FROM Doctors LIMIT 1),
    CURDATE() + INTERVAL FLOOR(RAND() * 14) DAY
FROM 
    Students s
ORDER BY 
    RAND()
LIMIT 5;

-- Add more varied diagnosis records
INSERT INTO Diagnosis (student_id, diagnosis_date, symptoms, diagnosis, treatment, nurse_id, follow_up_date)
SELECT 
    s.student_id,
    NOW() - INTERVAL FLOOR(RAND() * 60) DAY,
    'Headache, sensitivity to light, dizziness',
    'Migraine',
    'Rest in dark room, migraine medication, stay hydrated',
    (SELECT nurse_id FROM Nurses LIMIT 1),
    NULL
FROM 
    Students s
ORDER BY 
    RAND()
LIMIT 3;

-- Doctor-only diagnosis (more serious conditions)
INSERT INTO Diagnosis (student_id, diagnosis_date, symptoms, diagnosis, treatment, doctor_id, follow_up_date)
SELECT 
    s.student_id,
    NOW() - INTERVAL FLOOR(RAND() * 90) DAY,
    'Persistent cough, fatigue, mild fever',
    'Bronchitis',
    'Antibiotics, increased rest, cough suppressant',
    (SELECT doctor_id FROM Doctors LIMIT 1),
    CURDATE() + INTERVAL 7 DAY
FROM 
    Students s
ORDER BY 
    RAND()
LIMIT 2; 