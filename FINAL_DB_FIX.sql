--------------------------------------------------------------------------------
-- RUN THIS SCRIPT IN SUPABASE SQL EDITOR TO *COMPLETELY* FIX THE ERROR
--------------------------------------------------------------------------------

-- 1. DROP ALL OLD/CONFLICTING CONSTRAINTS
-- We must remove any constraint that forces uniqueness on (student, course, date) ONLY
ALTER TABLE public.attendance DROP CONSTRAINT IF EXISTS attendance_student_id_course_id_date_key; 
ALTER TABLE public.attendance DROP CONSTRAINT IF EXISTS unique_attendance_record;
ALTER TABLE public.attendance DROP CONSTRAINT IF EXISTS unique_attendance_session;

-- 2. ENSURE TIME COLUMN EXISTS
ALTER TABLE public.attendance ADD COLUMN IF NOT EXISTS time text DEFAULT '00:00';

-- 3. ADD THE NEW CORRECT CONSTRAINT
-- This allows same student/course/date acceptable IF time is different
ALTER TABLE public.attendance 
ADD CONSTRAINT unique_attendance_session UNIQUE (student_id, course_id, date, time);

-- 4. REFRESH PERMISSIONS
DROP POLICY IF EXISTS "Enable all access for attendance" ON "public"."attendance";
CREATE POLICY "Enable all access for attendance" ON "public"."attendance"
AS PERMISSIVE FOR ALL
TO public
USING (true)
WITH CHECK (true);
