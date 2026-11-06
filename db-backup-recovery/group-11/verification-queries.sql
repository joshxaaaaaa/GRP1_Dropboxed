-- Group 11: run against grp11_restore_test and ReserveIT, then compare.
SET search_path TO "public";
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE' ORDER BY 1;
SELECT 'app_user' AS table_name, COUNT(*) FROM "app_user";
SELECT 'department' AS table_name, COUNT(*) FROM "department";
SELECT 'material' AS table_name, COUNT(*) FROM "material";
SELECT 'penalty' AS table_name, COUNT(*) FROM "penalty";
SELECT 'reservation' AS table_name, COUNT(*) FROM "reservation";
SELECT 'reservation_material' AS table_name, COUNT(*) FROM "reservation_material";
SELECT 'room' AS table_name, COUNT(*) FROM "room";
SELECT 'staff' AS table_name, COUNT(*) FROM "staff";
SELECT contype, COUNT(*) FROM pg_constraint WHERE connamespace = 'public'::regnamespace GROUP BY 1 ORDER BY 1;
SELECT COUNT(*) AS indexes FROM pg_indexes WHERE schemaname = 'public';
SELECT r.reservation_id, rm.room_name, r.reservation_date, r.start_time, r.status FROM reservation r JOIN room rm ON rm.room_id = r.room_id WHERE r.status = 'PENDING' ORDER BY r.reservation_date, r.start_time;
