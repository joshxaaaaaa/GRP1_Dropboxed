-- Group 09: run against grp09_restore_test and grp99_gymdb, then compare.
SET search_path TO "public";
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE' ORDER BY 1;
SELECT 'attendance' AS table_name, COUNT(*) FROM "attendance";
SELECT 'class_enrollments' AS table_name, COUNT(*) FROM "class_enrollments";
SELECT 'classes' AS table_name, COUNT(*) FROM "classes";
SELECT 'members' AS table_name, COUNT(*) FROM "members";
SELECT 'membership_plans' AS table_name, COUNT(*) FROM "membership_plans";
SELECT 'memberships' AS table_name, COUNT(*) FROM "memberships";
SELECT 'payments' AS table_name, COUNT(*) FROM "payments";
SELECT 'trainers' AS table_name, COUNT(*) FROM "trainers";
SELECT contype, COUNT(*) FROM pg_constraint WHERE connamespace = 'public'::regnamespace GROUP BY 1 ORDER BY 1;
SELECT COUNT(*) AS indexes FROM pg_indexes WHERE schemaname = 'public';
SELECT m.membership_id, mb.first_name, mb.last_name, p.plan_name, m.end_date FROM memberships m JOIN members mb ON mb.member_id = m.member_id JOIN membership_plans p ON p.plan_id = m.plan_id WHERE m.status = 'Active' ORDER BY m.end_date;
