-- Update admin password to match the expected hash
USE SMS;
UPDATE Users 
SET Password='$2a$10$vQyTh.ELiD0g7dBpECegwuXLnVYRs7MfhIZRVTpZm9ATmPdG.FQoC' 
WHERE Username='admin'; 