-- Group 06: Car Rental Management System
-- Database car_rental_db, schema public. Least-privilege access control (Activity 4).
-- Run as a superuser, connected to car_rental_db. Safe to re-run; also used after a restore (Activity 6).
-- No password is stored here. After running, set each login's password in psql:
--   \password grp06_app
--   \password grp06_report
--   \password grp06_dba
--   \password grp06_backup

-- Part 1: cluster-wide roles. Names carry the group number so projects on one server cannot collide.
DO $$
DECLARE r text;
BEGIN
  FOREACH r IN ARRAY ARRAY['grp06_runtime_grp','grp06_readonly_grp','grp06_dba_grp','grp06_backup_grp'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
  FOREACH r IN ARRAY ARRAY['grp06_app','grp06_report','grp06_dba','grp06_backup'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
END $$;
GRANT grp06_runtime_grp TO grp06_app;
GRANT grp06_readonly_grp TO grp06_report;
GRANT grp06_dba_grp TO grp06_dba;
GRANT grp06_backup_grp TO grp06_backup;
GRANT pg_monitor TO grp06_dba_grp;

-- Part 2: database and schema access. PUBLIC loses its default CONNECT and TEMPORARY.
DO $$
BEGIN
  EXECUTE format('REVOKE ALL ON DATABASE %I FROM PUBLIC', current_database());
  EXECUTE format('GRANT CONNECT ON DATABASE %I TO grp06_runtime_grp, grp06_readonly_grp, grp06_dba_grp, grp06_backup_grp', current_database());
END $$;
REVOKE ALL ON SCHEMA "public" FROM PUBLIC;
GRANT USAGE ON SCHEMA "public" TO grp06_runtime_grp, grp06_readonly_grp, grp06_dba_grp, grp06_backup_grp;
SET search_path TO "public";

-- Start clean, so this file is the full statement of who can do what.
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp06_runtime_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp06_runtime_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp06_readonly_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp06_readonly_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp06_dba_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp06_dba_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp06_backup_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp06_backup_grp;

-- Part 3: application runtime. Only what the application's code uses.
GRANT SELECT, INSERT ON "audit_log" TO grp06_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "cancellation" TO grp06_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "customer" TO grp06_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "damage_fee" TO grp06_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "damage_incident" TO grp06_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "driver_license" TO grp06_runtime_grp;
GRANT SELECT, INSERT ON "inspection_item" TO grp06_runtime_grp;
GRANT SELECT, INSERT ON "inspection_photo" TO grp06_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "payment" TO grp06_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "rental" TO grp06_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "rental_rate" TO grp06_runtime_grp;
GRANT SELECT, INSERT ON "rental_terms" TO grp06_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "staff" TO grp06_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "vehicle" TO grp06_runtime_grp;
GRANT SELECT, INSERT ON "vehicle_category" TO grp06_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "vehicle_inspection" TO grp06_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "vehicle_maintenance" TO grp06_runtime_grp;
-- These tables use SERIAL-style defaults, so INSERT calls nextval() and needs USAGE on the sequence.
GRANT USAGE ON SEQUENCE public.audit_log_audit_id_seq TO grp06_runtime_grp;
GRANT USAGE ON SEQUENCE public.cancellation_cancellation_id_seq TO grp06_runtime_grp;
GRANT USAGE ON SEQUENCE public.customer_customer_id_seq TO grp06_runtime_grp;
GRANT USAGE ON SEQUENCE public.damage_fee_damage_fee_id_seq TO grp06_runtime_grp;
GRANT USAGE ON SEQUENCE public.damage_incident_damage_id_seq TO grp06_runtime_grp;
GRANT USAGE ON SEQUENCE public.driver_license_license_id_seq TO grp06_runtime_grp;
GRANT USAGE ON SEQUENCE public.inspection_item_item_id_seq TO grp06_runtime_grp;
GRANT USAGE ON SEQUENCE public.inspection_photo_photo_id_seq TO grp06_runtime_grp;
GRANT USAGE ON SEQUENCE public.payment_payment_id_seq TO grp06_runtime_grp;
GRANT USAGE ON SEQUENCE public.rental_rate_rate_id_seq TO grp06_runtime_grp;
GRANT USAGE ON SEQUENCE public.rental_rental_id_seq TO grp06_runtime_grp;
GRANT USAGE ON SEQUENCE public.rental_terms_terms_id_seq TO grp06_runtime_grp;
GRANT USAGE ON SEQUENCE public.staff_staff_id_seq TO grp06_runtime_grp;
GRANT USAGE ON SEQUENCE public.vehicle_category_category_id_seq TO grp06_runtime_grp;
GRANT USAGE ON SEQUENCE public.vehicle_inspection_inspection_id_seq TO grp06_runtime_grp;
GRANT USAGE ON SEQUENCE public.vehicle_maintenance_maintenance_id_seq TO grp06_runtime_grp;
GRANT USAGE ON SEQUENCE public.vehicle_vehicle_id_seq TO grp06_runtime_grp;

-- Part 4: read-only reporting. Credentials and contact details are excluded.
GRANT SELECT ON "audit_log" TO grp06_readonly_grp;
GRANT SELECT ON "cancellation" TO grp06_readonly_grp;
GRANT SELECT ("customer_id", "first_name", "last_name", "account_status", "created_at") ON "customer" TO grp06_readonly_grp;
GRANT SELECT ON "damage_fee" TO grp06_readonly_grp;
GRANT SELECT ON "damage_incident" TO grp06_readonly_grp;
GRANT SELECT ("license_id", "customer_id", "license_type", "issue_date", "expiration_date", "verification_status", "rejection_reason", "verified_at", "verified_by_staff_id") ON "driver_license" TO grp06_readonly_grp;
GRANT SELECT ON "inspection_item" TO grp06_readonly_grp;
GRANT SELECT ON "inspection_photo" TO grp06_readonly_grp;
GRANT SELECT ON "payment" TO grp06_readonly_grp;
GRANT SELECT ON "rental" TO grp06_readonly_grp;
GRANT SELECT ON "rental_rate" TO grp06_readonly_grp;
GRANT SELECT ON "rental_terms" TO grp06_readonly_grp;
GRANT SELECT ("staff_id", "first_name", "last_name", "role", "account_status", "created_at") ON "staff" TO grp06_readonly_grp;
GRANT SELECT ON "vehicle" TO grp06_readonly_grp;
GRANT SELECT ON "vehicle_category" TO grp06_readonly_grp;
GRANT SELECT ON "vehicle_inspection" TO grp06_readonly_grp;
GRANT SELECT ON "vehicle_maintenance" TO grp06_readonly_grp;

-- Part 5: backup. pg_dump must read every table and sequence, but changes nothing.
GRANT SELECT ON ALL TABLES IN SCHEMA "public" TO grp06_backup_grp;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA "public" TO grp06_backup_grp;

-- Part 6: DBA. Data correction, VACUUM, ANALYZE and monitoring. No TRUNCATE, no DDL, not a superuser.
GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON ALL TABLES IN SCHEMA "public" TO grp06_dba_grp;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA "public" TO grp06_dba_grp;

-- Part 7: future objects. Backups and the DBA cover them; the runtime and read-only roles need a deliberate grant.
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT ON TABLES TO grp06_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT ON SEQUENCES TO grp06_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON TABLES TO grp06_dba_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT USAGE, SELECT ON SEQUENCES TO grp06_dba_grp;
