-- SQL script to add user entries for existing teachers
USE SMS;

-- Check if users already exist for these teachers
SELECT * FROM Users WHERE Username IN ('hirwacedr12@gmail.com', 'hirwacedric123@gmail.com');

-- Add users for the teachers if they don't exist
-- Using the email as username and 'password123' as the default password
-- In a production environment, you would use securely hashed passwords

INSERT INTO Users (Username, Password, UserType)
SELECT 'hirwacedr12@gmail.com', 'password123', 'Teacher'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Users WHERE Username = 'hirwacedr12@gmail.com');

INSERT INTO Users (Username, Password, UserType)
SELECT 'hirwacedric123@gmail.com', 'password123', 'Teacher'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Users WHERE Username = 'hirwacedric123@gmail.com');

-- Verify the users were added
SELECT * FROM Users WHERE Username IN ('hirwacedr12@gmail.com', 'hirwacedric123@gmail.com');

-- Check if users already exist for this teacher
SELECT * FROM Users WHERE Username = 'murokorepatrick@gmail.com';

-- Add users for the teacher if they don't exist
-- Using the email as username and 'password123' as the default password
-- In a production environment, you would use securely hashed passwords

INSERT INTO Users (Username, Password, UserType)
SELECT 'murokorepatrick@gmail.com', 'password123', 'Teacher'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Users WHERE Username = 'murokorepatrick@gmail.com');

-- First let's check if the teacher already exists in the Teachers table
SELECT * FROM Teachers WHERE Email = 'murokorepatrick@gmail.com';

-- Add teacher to Teachers table if not exists
INSERT INTO Teachers (FirstName, LastName, Qualification, Experience, Email, Telephone)
SELECT 'Murokore', 'Patric', 'Computer Science', 5, 'murokorepatrick@gmail.com', '0780123456'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM Teachers WHERE Email = 'murokorepatrick@gmail.com');

-- Verify the user was added
SELECT * FROM Users WHERE Username = 'murokorepatrick@gmail.com';

-- Verify the teacher was added
SELECT * FROM Teachers WHERE Email = 'murokorepatrick@gmail.com'; 