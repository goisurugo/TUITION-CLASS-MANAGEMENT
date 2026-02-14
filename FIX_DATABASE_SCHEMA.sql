
-- 1. ADD MISSING TIME COLUMN TO ATTENDANCE
-- This enables the time-based filtering
ALTER TABLE public.attendance 
ADD COLUMN IF NOT EXISTS time text DEFAULT '00:00';

-- 2. FIX ATTENDANCE CONSTRAINTS
-- Allows multiple attendance records for same student/course/date if times are different
ALTER TABLE public.attendance 
DROP CONSTRAINT IF EXISTS unique_attendance_record;

ALTER TABLE public.attendance
DROP CONSTRAINT IF EXISTS unique_attendance_session;

ALTER TABLE public.attendance
ADD CONSTRAINT unique_attendance_session UNIQUE (student_id, course_id, date, time);

-- 3. ENABLE ALL PERMISSIONS (RLS)
-- Ensures students/attendance/payments are visible and editable
-- STUDENTS
DROP POLICY IF EXISTS "Enable all access for students" ON "public"."students";
CREATE POLICY "Enable all access for students" ON "public"."students"
AS PERMISSIVE FOR ALL
TO public
USING (true)
WITH CHECK (true);

-- ATTENDANCE
DROP POLICY IF EXISTS "Enable all access for attendance" ON "public"."attendance";
CREATE POLICY "Enable all access for attendance" ON "public"."attendance"
AS PERMISSIVE FOR ALL
TO public
USING (true)
WITH CHECK (true);

-- COURSES
DROP POLICY IF EXISTS "Enable all access for courses" ON "public"."courses";
CREATE POLICY "Enable all access for courses" ON "public"."courses"
AS PERMISSIVE FOR ALL
TO public
USING (true)
WITH CHECK (true);

-- PAYMENTS
DROP POLICY IF EXISTS "Enable all access for payments" ON "public"."payments";
CREATE POLICY "Enable all access for payments" ON "public"."payments"
AS PERMISSIVE FOR ALL
TO public
USING (true)
WITH CHECK (true);
