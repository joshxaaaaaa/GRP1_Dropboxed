-- Group 10: routine maintenance. Run as grp10_dba. VACUUM runs outside a transaction; VACUUM FULL is not used.
SET search_path TO "public";
ANALYZE VERBOSE "account", "event", "event_schedule", "membership", "notification", "organization", "registration", "venue";
VACUUM (VERBOSE, ANALYZE) "event";
SELECT relname, n_live_tup, n_dead_tup, last_vacuum, last_analyze FROM pg_stat_user_tables WHERE schemaname = 'public' AND relname = 'event';
