-- Group 06: routine maintenance. Run as grp06_dba. VACUUM runs outside a transaction; VACUUM FULL is not used.
SET search_path TO "public";
ANALYZE VERBOSE "audit_log", "cancellation", "customer", "damage_fee", "damage_incident", "driver_license", "inspection_item", "inspection_photo", "payment", "rental", "rental_rate", "rental_terms", "staff", "vehicle", "vehicle_category", "vehicle_inspection", "vehicle_maintenance";
VACUUM (VERBOSE, ANALYZE) "vehicle";
SELECT relname, n_live_tup, n_dead_tup, last_vacuum, last_analyze FROM pg_stat_user_tables WHERE schemaname = 'public' AND relname = 'vehicle';
