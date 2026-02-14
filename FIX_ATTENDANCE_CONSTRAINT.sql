
-- 1. Ensure Attendance table has the correct Unique Constraint for Upsert
-- This is critical for the "Save Attendance" button to work without Duplicate Key errors
ALTER TABLE attendance 
DROP CONSTRAINT IF EXISTS unique_attendance_record;

ALTER TABLE attendance
ADD CONSTRAINT unique_attendance_record UNIQUE (student_id, course_id, date);

-- 2. (Optional) Check data types if needed, though likely standard
-- 3. Ensure RLS allows upsert (insert/update)
DROP POLICY IF EXISTS "Enable all access for attendance" ON "public"."attendance";
CREATE POLICY "Enable all access for attendance" ON "public"."attendance"
AS PERMISSIVE FOR ALL
TO public
USING (true)
WITH CHECK (true);
