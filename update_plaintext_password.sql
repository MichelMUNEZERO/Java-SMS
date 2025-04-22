-- Update admin password to plain text
USE SMS;
UPDATE Users 
SET Password='admin123' 
WHERE Username='admin'; 