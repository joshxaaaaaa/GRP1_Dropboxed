-- Group 02: routine maintenance. Run as grp02_dba. VACUUM runs outside a transaction; VACUUM FULL is not used.
SET search_path TO "school_event_management_db";
ANALYZE VERBOSE "attendance", "audit_log", "event", "event_assignment", "event_schedule", "flyway_schema_history", "participant", "role", "user_account", "venue";
VACUUM (VERBOSE, ANALYZE) "event";
SELECT relname, n_live_tup, n_dead_tup, last_vacuum, last_analyze FROM pg_stat_user_tables WHERE schemaname = 'school_event_management_db' AND relname = 'event';
