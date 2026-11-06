-- Group 10: run against grp10_restore_test and grp10_unisyncdb, then compare.
SET search_path TO "public";
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE' ORDER BY 1;
SELECT 'account' AS table_name, COUNT(*) FROM "account";
SELECT 'event' AS table_name, COUNT(*) FROM "event";
SELECT 'event_schedule' AS table_name, COUNT(*) FROM "event_schedule";
SELECT 'membership' AS table_name, COUNT(*) FROM "membership";
SELECT 'notification' AS table_name, COUNT(*) FROM "notification";
SELECT 'organization' AS table_name, COUNT(*) FROM "organization";
SELECT 'registration' AS table_name, COUNT(*) FROM "registration";
SELECT 'venue' AS table_name, COUNT(*) FROM "venue";
SELECT contype, COUNT(*) FROM pg_constraint WHERE connamespace = 'public'::regnamespace GROUP BY 1 ORDER BY 1;
SELECT COUNT(*) AS indexes FROM pg_indexes WHERE schemaname = 'public';
SELECT e.event_name, s.event_date, s.start_time, v.venue_name, o.organization_name FROM event_schedule s JOIN event e ON e.event_id = s.event_id JOIN venue v ON v.venue_id = s.venue_id JOIN organization o ON o.organization_id = e.organization_id WHERE s.status = 'confirmed' ORDER BY s.event_date, s.start_time;
