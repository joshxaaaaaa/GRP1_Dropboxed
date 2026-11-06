-- Group 04: HealthBridge Clinic Management System (HBCMS)
-- Database grp03_projectdb, schema public. Least-privilege access control (Activity 4).
-- Run as a superuser, connected to grp03_projectdb. Safe to re-run; also used after a restore (Activity 6).
-- No password is stored here. After running, set each login's password in psql:
--   \password grp04_app
--   \password grp04_report
--   \password grp04_dba
--   \password grp04_backup

-- Part 1: cluster-wide roles. Names carry the group number so projects on one server cannot collide.
DO $$
DECLARE r text;
BEGIN
  FOREACH r IN ARRAY ARRAY['grp04_runtime_grp','grp04_readonly_grp','grp04_dba_grp','grp04_backup_grp'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
  FOREACH r IN ARRAY ARRAY['grp04_app','grp04_report','grp04_dba','grp04_backup'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
END $$;
GRANT grp04_runtime_grp TO grp04_app;
GRANT grp04_readonly_grp TO grp04_report;
GRANT grp04_dba_grp TO grp04_dba;
GRANT grp04_backup_grp TO grp04_backup;
GRANT pg_monitor TO grp04_dba_grp;

-- Part 2: database and schema access. PUBLIC loses its default CONNECT and TEMPORARY.
DO $$
BEGIN
  EXECUTE format('REVOKE ALL ON DATABASE %I FROM PUBLIC', current_database());
  EXECUTE format('GRANT CONNECT ON DATABASE %I TO grp04_runtime_grp, grp04_readonly_grp, grp04_dba_grp, grp04_backup_grp', current_database());
END $$;
REVOKE ALL ON SCHEMA "public" FROM PUBLIC;
GRANT USAGE ON SCHEMA "public" TO grp04_runtime_grp, grp04_readonly_grp, grp04_dba_grp, grp04_backup_grp;
SET search_path TO "public";

-- Start clean, so this file is the full statement of who can do what.
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp04_runtime_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp04_runtime_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp04_readonly_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp04_readonly_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp04_dba_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp04_dba_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp04_backup_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp04_backup_grp;

-- Part 3: application runtime. Only what the application's code uses.
GRANT SELECT, INSERT, UPDATE, DELETE ON "appointments" TO grp04_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "billing" TO grp04_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "deleted_records" TO grp04_runtime_grp;
GRANT SELECT ON "doctors" TO grp04_runtime_grp;
GRANT SELECT, INSERT, DELETE ON "medical_notes" TO grp04_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "patients" TO grp04_runtime_grp;
GRANT SELECT, INSERT, DELETE ON "prescriptions" TO grp04_runtime_grp;
GRANT SELECT ON "specialties" TO grp04_runtime_grp;
GRANT SELECT, UPDATE ON "staff_users" TO grp04_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "staff_password_resets" TO grp04_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "patient_password_resets" TO grp04_runtime_grp;
-- These tables use SERIAL-style defaults, so INSERT calls nextval() and needs USAGE on the sequence.
GRANT USAGE ON SEQUENCE public.appointments_appointment_id_seq TO grp04_runtime_grp;
GRANT USAGE ON SEQUENCE public.billing_bill_id_seq TO grp04_runtime_grp;
GRANT USAGE ON SEQUENCE public.deleted_records_record_id_seq TO grp04_runtime_grp;
GRANT USAGE ON SEQUENCE public.medical_notes_note_id_seq TO grp04_runtime_grp;
GRANT USAGE ON SEQUENCE public.patient_password_resets_reset_id_seq TO grp04_runtime_grp;
GRANT USAGE ON SEQUENCE public.patients_patient_id_seq TO grp04_runtime_grp;
GRANT USAGE ON SEQUENCE public.prescriptions_prescription_id_seq TO grp04_runtime_grp;
GRANT USAGE ON SEQUENCE public.staff_password_resets_reset_id_seq TO grp04_runtime_grp;

-- Part 4: read-only reporting. Credentials and contact details are excluded.
GRANT SELECT ON "appointments" TO grp04_readonly_grp;
GRANT SELECT ON "billing" TO grp04_readonly_grp;
GRANT SELECT ("doctor_id", "first_name", "last_name", "specialty_id") ON "doctors" TO grp04_readonly_grp;
GRANT SELECT ON "medical_notes" TO grp04_readonly_grp;
GRANT SELECT ("patient_id", "first_name", "last_name", "date_of_birth", "gender") ON "patients" TO grp04_readonly_grp;
GRANT SELECT ON "prescriptions" TO grp04_readonly_grp;
GRANT SELECT ON "specialties" TO grp04_readonly_grp;
GRANT SELECT ("user_id", "first_name", "last_name", "role", "doctor_id", "is_active", "created_at") ON "staff_users" TO grp04_readonly_grp;
GRANT SELECT ON "appointment_details" TO grp04_readonly_grp;
GRANT SELECT ON "visit_records" TO grp04_readonly_grp;

-- Part 5: backup. pg_dump must read every table and sequence, but changes nothing.
GRANT SELECT ON ALL TABLES IN SCHEMA "public" TO grp04_backup_grp;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA "public" TO grp04_backup_grp;

-- Part 6: DBA. Data correction, VACUUM, ANALYZE and monitoring. No TRUNCATE, no DDL, not a superuser.
GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON ALL TABLES IN SCHEMA "public" TO grp04_dba_grp;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA "public" TO grp04_dba_grp;

-- Part 7: future objects. Backups and the DBA cover them; the runtime and read-only roles need a deliberate grant.
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT ON TABLES TO grp04_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT ON SEQUENCES TO grp04_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON TABLES TO grp04_dba_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT USAGE, SELECT ON SEQUENCES TO grp04_dba_grp;
