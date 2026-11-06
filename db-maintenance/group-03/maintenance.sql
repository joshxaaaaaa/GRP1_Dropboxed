-- Group 03: routine maintenance. Run as grp03_dba. VACUUM runs outside a transaction; VACUUM FULL is not used.
SET search_path TO "public";
ANALYZE VERBOSE "appointment", "appointment_service", "audit_log", "auth_session", "medical_record", "notification", "owner", "password_reset_code", "pet", "prescription", "service", "user_account", "vaccination", "veterinarian";
VACUUM (VERBOSE, ANALYZE) "appointment";
SELECT relname, n_live_tup, n_dead_tup, last_vacuum, last_analyze FROM pg_stat_user_tables WHERE schemaname = 'public' AND relname = 'appointment';
