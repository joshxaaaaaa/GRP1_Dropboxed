-- Group 03: PAWPAW: Veterinary Appointment and Pet Management System
-- Database group3_pawpaw, schema public. Least-privilege access control (Activity 4).
-- Run as a superuser, connected to group3_pawpaw. Safe to re-run; also used after a restore (Activity 6).
-- No password is stored here. After running, set each login's password in psql:
--   \password grp03_app
--   \password grp03_report
--   \password grp03_dba
--   \password grp03_backup

-- Part 1: cluster-wide roles. Names carry the group number so projects on one server cannot collide.
DO $$
DECLARE r text;
BEGIN
  FOREACH r IN ARRAY ARRAY['grp03_runtime_grp','grp03_readonly_grp','grp03_dba_grp','grp03_backup_grp'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
  FOREACH r IN ARRAY ARRAY['grp03_app','grp03_report','grp03_dba','grp03_backup'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
END $$;
GRANT grp03_runtime_grp TO grp03_app;
GRANT grp03_readonly_grp TO grp03_report;
GRANT grp03_dba_grp TO grp03_dba;
GRANT grp03_backup_grp TO grp03_backup;
GRANT pg_monitor TO grp03_dba_grp;

-- Part 2: database and schema access. PUBLIC loses its default CONNECT and TEMPORARY.
DO $$
BEGIN
  EXECUTE format('REVOKE ALL ON DATABASE %I FROM PUBLIC', current_database());
  EXECUTE format('GRANT CONNECT ON DATABASE %I TO grp03_runtime_grp, grp03_readonly_grp, grp03_dba_grp, grp03_backup_grp', current_database());
END $$;
REVOKE ALL ON SCHEMA "public" FROM PUBLIC;
GRANT USAGE ON SCHEMA "public" TO grp03_runtime_grp, grp03_readonly_grp, grp03_dba_grp, grp03_backup_grp;
SET search_path TO "public";

-- Start clean, so this file is the full statement of who can do what.
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp03_runtime_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp03_runtime_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp03_readonly_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp03_readonly_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp03_dba_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp03_dba_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp03_backup_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp03_backup_grp;

-- Part 3: application runtime. Only what the application's code uses.
GRANT SELECT, INSERT, UPDATE ON "appointment" TO grp03_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "appointment_service" TO grp03_runtime_grp;
GRANT SELECT, INSERT ON "audit_log" TO grp03_runtime_grp;
GRANT SELECT, INSERT ON "medical_record" TO grp03_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "notification" TO grp03_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "owner" TO grp03_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "password_reset_code" TO grp03_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "pet" TO grp03_runtime_grp;
GRANT SELECT, INSERT, DELETE ON "prescription" TO grp03_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "service" TO grp03_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "user_account" TO grp03_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "vaccination" TO grp03_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "veterinarian" TO grp03_runtime_grp;
-- All generated keys are identity columns, so INSERT needs no sequence privilege.

-- Part 4: read-only reporting. Credentials and contact details are excluded.
GRANT SELECT ON "appointment" TO grp03_readonly_grp;
GRANT SELECT ON "appointment_service" TO grp03_readonly_grp;
GRANT SELECT ON "audit_log" TO grp03_readonly_grp;
GRANT SELECT ON "medical_record" TO grp03_readonly_grp;
GRANT SELECT ON "notification" TO grp03_readonly_grp;
GRANT SELECT ("owner_id", "user_id", "name", "first_name", "middle_name", "last_name", "photo", "registration_date") ON "owner" TO grp03_readonly_grp;
GRANT SELECT ON "pet" TO grp03_readonly_grp;
GRANT SELECT ON "prescription" TO grp03_readonly_grp;
GRANT SELECT ON "service" TO grp03_readonly_grp;
GRANT SELECT ("user_id", "username", "role", "account_status", "created_date", "display_name", "profile_photo") ON "user_account" TO grp03_readonly_grp;
GRANT SELECT ON "vaccination" TO grp03_readonly_grp;
GRANT SELECT ("veterinarian_id", "user_id", "name", "specialization") ON "veterinarian" TO grp03_readonly_grp;

-- Part 5: backup. pg_dump must read every table and sequence, but changes nothing.
GRANT SELECT ON ALL TABLES IN SCHEMA "public" TO grp03_backup_grp;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA "public" TO grp03_backup_grp;

-- Part 6: DBA. Data correction, VACUUM, ANALYZE and monitoring. No TRUNCATE, no DDL, not a superuser.
GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON ALL TABLES IN SCHEMA "public" TO grp03_dba_grp;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA "public" TO grp03_dba_grp;

-- Part 7: future objects. Backups and the DBA cover them; the runtime and read-only roles need a deliberate grant.
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT ON TABLES TO grp03_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT ON SEQUENCES TO grp03_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON TABLES TO grp03_dba_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT USAGE, SELECT ON SEQUENCES TO grp03_dba_grp;
