-- RUN THIS IN SUPABASE SQL EDITOR TO ENABLE DELETION

-- 1. Get permissions to delete students
drop policy if exists "Enable delete for all users" on "public"."students";
create policy "Enable delete for all users" on "public"."students"
as permissive for delete
to public
using ( true );

-- 2. Get permissions to delete payments (needed for cascade)
drop policy if exists "Enable delete for all users" on "public"."payments";
create policy "Enable delete for all users" on "public"."payments"
as permissive for delete
to public
using ( true );

-- 3. Get permissions to delete attendance (needed for cascade)
drop policy if exists "Enable delete for all users" on "public"."attendance";
create policy "Enable delete for all users" on "public"."attendance"
as permissive for delete
to public
using ( true );

-- 4. Enable insert/update/select just in case (optional, if missing)
-- (Supabase default is often "no access" if RLS is on and no policy exists)
