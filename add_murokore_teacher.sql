-- SQL script to add teacher 'Murokore' and a corresponding user account
USE SMS;

-- Add teacher to Teachers table
INSERT INTO Teachers (FirstName, LastName, Qualification, Experience, Email, Telephone)
VALUES ('Murokore', 'Patric', 'Computer Science', 5, 'murokorepatric@gmail.com', '0780123456');

-- Add user account for the teacher
INSERT INTO Users (Username, Password, UserType)
VALUES ('murokorepatric@gmail.com', 'password123', 'Teacher');

-- Verify the teacher was added
SELECT * FROM Teachers WHERE Email = 'murokorepatric@gmail.com';

-- Verify the user was added
SELECT * FROM Users WHERE Username = 'murokorepatric@gmail.com'; 