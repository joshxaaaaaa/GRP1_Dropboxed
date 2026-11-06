-- Group 08: run against grp08_restore_test and catering_management_db, then compare.
SET search_path TO "public";
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE' ORDER BY 1;
SELECT 'admin' AS table_name, COUNT(*) FROM "admin";
SELECT 'cancellation' AS table_name, COUNT(*) FROM "cancellation";
SELECT 'customer' AS table_name, COUNT(*) FROM "customer";
SELECT 'employee' AS table_name, COUNT(*) FROM "employee";
SELECT 'event_assignment' AS table_name, COUNT(*) FROM "event_assignment";
SELECT 'inventory' AS table_name, COUNT(*) FROM "inventory";
SELECT 'menu_item' AS table_name, COUNT(*) FROM "menu_item";
SELECT 'package' AS table_name, COUNT(*) FROM "package";
SELECT 'payment' AS table_name, COUNT(*) FROM "payment";
SELECT 'reservation' AS table_name, COUNT(*) FROM "reservation";
SELECT 'reservation_menu' AS table_name, COUNT(*) FROM "reservation_menu";
SELECT 'session' AS table_name, COUNT(*) FROM "session";
SELECT contype, COUNT(*) FROM pg_constraint WHERE connamespace = 'public'::regnamespace GROUP BY 1 ORDER BY 1;
SELECT COUNT(*) AS indexes FROM pg_indexes WHERE schemaname = 'public';
SELECT r.reservation_id, r.event_date, r.status, c.first_name, c.last_name, p.package_name FROM reservation r JOIN customer c ON c.customer_id = r.customer_id JOIN package p ON p.package_id = r.package_id WHERE r.status = 'Pending' ORDER BY r.event_date;
