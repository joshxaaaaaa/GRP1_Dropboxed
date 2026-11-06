-- Group 11: routine maintenance. Run as grp11_dba. VACUUM runs outside a transaction; VACUUM FULL is not used.
SET search_path TO "public";
ANALYZE VERBOSE "app_user", "department", "material", "penalty", "reservation", "reservation_material", "room", "staff";
VACUUM (VERBOSE, ANALYZE) "reservation";
SELECT relname, n_live_tup, n_dead_tup, last_vacuum, last_analyze FROM pg_stat_user_tables WHERE schemaname = 'public' AND relname = 'reservation';
