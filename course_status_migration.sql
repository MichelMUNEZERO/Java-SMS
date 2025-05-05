-- Migration script to add status column to Courses table
-- Check if status column exists, if not add it
ALTER TABLE Courses ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'active';

-- Update existing courses to have 'active' status if it's null
UPDATE Courses SET status = 'active' WHERE status IS NULL; 