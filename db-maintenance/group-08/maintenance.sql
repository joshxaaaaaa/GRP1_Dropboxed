-- Group 08: routine maintenance. Run as grp08_dba. VACUUM runs outside a transaction; VACUUM FULL is not used.
SET search_path TO "public";
ANALYZE VERBOSE "admin", "cancellation", "customer", "employee", "event_assignment", "inventory", "menu_item", "package", "payment", "reservation", "reservation_menu", "session";
VACUUM (VERBOSE, ANALYZE) "reservation";
SELECT relname, n_live_tup, n_dead_tup, last_vacuum, last_analyze FROM pg_stat_user_tables WHERE schemaname = 'public' AND relname = 'reservation';
