
-- Update Attendance table to support Time-based sessions
ALTER TABLE public.attendance 
ADD COLUMN IF NOT EXISTS time text DEFAULT '00:00'; -- ensuring existing rows get a default

-- Drop old constraint to allow multiple sessions per day if times differ
ALTER TABLE attendance 
DROP CONSTRAINT IF EXISTS unique_attendance_record;

-- Add new constraint including time
ALTER TABLE attendance
ADD CONSTRAINT unique_attendance_session UNIQUE (student_id, course_id, date, time);
