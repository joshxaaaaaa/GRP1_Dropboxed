-- Group 02: run against grp02_restore_test and grp02_event_management_db, then compare.
SET search_path TO "school_event_management_db";
SELECT table_name FROM information_schema.tables WHERE table_schema = 'school_event_management_db' AND table_type = 'BASE TABLE' ORDER BY 1;
SELECT 'attendance' AS table_name, COUNT(*) FROM "attendance";
SELECT 'audit_log' AS table_name, COUNT(*) FROM "audit_log";
SELECT 'event' AS table_name, COUNT(*) FROM "event";
SELECT 'event_assignment' AS table_name, COUNT(*) FROM "event_assignment";
SELECT 'event_schedule' AS table_name, COUNT(*) FROM "event_schedule";
SELECT 'flyway_schema_history' AS table_name, COUNT(*) FROM "flyway_schema_history";
SELECT 'participant' AS table_name, COUNT(*) FROM "participant";
SELECT 'role' AS table_name, COUNT(*) FROM "role";
SELECT 'user_account' AS table_name, COUNT(*) FROM "user_account";
SELECT 'venue' AS table_name, COUNT(*) FROM "venue";
SELECT contype, COUNT(*) FROM pg_constraint WHERE connamespace = 'school_event_management_db'::regnamespace GROUP BY 1 ORDER BY 1;
SELECT COUNT(*) AS indexes FROM pg_indexes WHERE schemaname = 'school_event_management_db';
SELECT e.event_id, e.event_name, a.attendance_status, COUNT(*) AS total FROM attendance a JOIN event e ON e.event_id = a.event_id WHERE e.event_status = 'Completed' GROUP BY e.event_id, e.event_name, a.attendance_status ORDER BY e.event_id;
