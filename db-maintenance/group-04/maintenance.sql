-- Group 04: routine maintenance. Run as grp04_dba. VACUUM runs outside a transaction; VACUUM FULL is not used.
SET search_path TO "public";
ANALYZE VERBOSE "appointments", "billing", "deleted_records", "doctors", "medical_notes", "patient_password_resets", "patients", "prescriptions", "specialties", "staff_password_resets", "staff_users";
VACUUM (VERBOSE, ANALYZE) "appointments";
SELECT relname, n_live_tup, n_dead_tup, last_vacuum, last_analyze FROM pg_stat_user_tables WHERE schemaname = 'public' AND relname = 'appointments';
