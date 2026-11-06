-- Group 07: routine maintenance. Run as grp07_dba. VACUUM runs outside a transaction; VACUUM FULL is not used.
SET search_path TO "public";
ANALYZE VERBOSE "applicant", "applicant_requirement", "application", "application_status", "department", "interview", "position", "requirement", "users";
VACUUM (VERBOSE, ANALYZE) "application";
SELECT relname, n_live_tup, n_dead_tup, last_vacuum, last_analyze FROM pg_stat_user_tables WHERE schemaname = 'public' AND relname = 'application';
