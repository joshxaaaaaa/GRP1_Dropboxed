-- Group 07: run against grp07_restore_test and grp07_applicantdb, then compare.
SET search_path TO "public";
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE' ORDER BY 1;
SELECT 'applicant' AS table_name, COUNT(*) FROM "applicant";
SELECT 'applicant_requirement' AS table_name, COUNT(*) FROM "applicant_requirement";
SELECT 'application' AS table_name, COUNT(*) FROM "application";
SELECT 'application_status' AS table_name, COUNT(*) FROM "application_status";
SELECT 'department' AS table_name, COUNT(*) FROM "department";
SELECT 'interview' AS table_name, COUNT(*) FROM "interview";
SELECT 'position' AS table_name, COUNT(*) FROM "position";
SELECT 'requirement' AS table_name, COUNT(*) FROM "requirement";
SELECT 'users' AS table_name, COUNT(*) FROM "users";
SELECT contype, COUNT(*) FROM pg_constraint WHERE connamespace = 'public'::regnamespace GROUP BY 1 ORDER BY 1;
SELECT COUNT(*) AS indexes FROM pg_indexes WHERE schemaname = 'public';
SELECT a.application_id, ap.first_name, ap.last_name, p.position_title, s.status_name, a.application_date FROM application a JOIN applicant ap ON ap.applicant_id = a.applicant_id JOIN position p ON p.position_id = a.position_id JOIN application_status s ON s.status_id = a.status_id WHERE s.status_name <> 'Rejected' ORDER BY a.application_date DESC;
