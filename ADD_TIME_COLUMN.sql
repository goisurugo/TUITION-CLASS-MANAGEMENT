
-- Add a 'time' column to the attendance table to record the class time
ALTER TABLE public.attendance 
ADD COLUMN IF NOT EXISTS time text; 
-- precise time type 'time' or 'text' is fine, text is easier for frontend 'HH:mm' format

-- Update the history view (if any) or just the table query will work.
