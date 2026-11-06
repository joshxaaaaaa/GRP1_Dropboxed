-- Group 09: Batumbakal Gym Membership Management System
-- Database grp99_gymdb, schema public. Least-privilege access control (Activity 4).
-- Run as a superuser, connected to grp99_gymdb. Safe to re-run; also used after a restore (Activity 6).
-- No password is stored here. After running, set each login's password in psql:
--   \password grp09_app
--   \password grp09_report
--   \password grp09_dba
--   \password grp09_backup

-- Part 1: cluster-wide roles. Names carry the group number so projects on one server cannot collide.
DO $$
DECLARE r text;
BEGIN
  FOREACH r IN ARRAY ARRAY['grp09_runtime_grp','grp09_readonly_grp','grp09_dba_grp','grp09_backup_grp'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
  FOREACH r IN ARRAY ARRAY['grp09_app','grp09_report','grp09_dba','grp09_backup'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
END $$;
GRANT grp09_runtime_grp TO grp09_app;
GRANT grp09_readonly_grp TO grp09_report;
GRANT grp09_dba_grp TO grp09_dba;
GRANT grp09_backup_grp TO grp09_backup;
GRANT pg_monitor TO grp09_dba_grp;

-- Part 2: database and schema access. PUBLIC loses its default CONNECT and TEMPORARY.
DO $$
BEGIN
  EXECUTE format('REVOKE ALL ON DATABASE %I FROM PUBLIC', current_database());
  EXECUTE format('GRANT CONNECT ON DATABASE %I TO grp09_runtime_grp, grp09_readonly_grp, grp09_dba_grp, grp09_backup_grp', current_database());
END $$;
REVOKE ALL ON SCHEMA "public" FROM PUBLIC;
GRANT USAGE ON SCHEMA "public" TO grp09_runtime_grp, grp09_readonly_grp, grp09_dba_grp, grp09_backup_grp;
SET search_path TO "public";

-- Start clean, so this file is the full statement of who can do what.
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp09_runtime_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp09_runtime_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp09_readonly_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp09_readonly_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp09_dba_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp09_dba_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp09_backup_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp09_backup_grp;

-- Part 3: application runtime. Only what the application's code uses.
GRANT SELECT, INSERT, UPDATE, DELETE ON "attendance" TO grp09_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "class_enrollments" TO grp09_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "classes" TO grp09_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "membership_plans" TO grp09_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "payments" TO grp09_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "trainers" TO grp09_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "members" TO grp09_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "memberships" TO grp09_runtime_grp;
-- These tables use SERIAL-style defaults, so INSERT calls nextval() and needs USAGE on the sequence.
GRANT USAGE ON SEQUENCE public.attendance_attendance_id_seq TO grp09_runtime_grp;
GRANT USAGE ON SEQUENCE public.classes_class_id_seq TO grp09_runtime_grp;
GRANT USAGE ON SEQUENCE public.members_member_id_seq TO grp09_runtime_grp;
GRANT USAGE ON SEQUENCE public.membership_plans_plan_id_seq TO grp09_runtime_grp;
GRANT USAGE ON SEQUENCE public.memberships_membership_id_seq TO grp09_runtime_grp;
GRANT USAGE ON SEQUENCE public.payments_payment_id_seq TO grp09_runtime_grp;
GRANT USAGE ON SEQUENCE public.trainers_trainer_id_seq TO grp09_runtime_grp;

-- Part 4: read-only reporting. Credentials and contact details are excluded.
GRANT SELECT ON "attendance" TO grp09_readonly_grp;
GRANT SELECT ON "class_enrollments" TO grp09_readonly_grp;
GRANT SELECT ON "classes" TO grp09_readonly_grp;
GRANT SELECT ("member_id", "first_name", "last_name", "status", "trainer_id") ON "members" TO grp09_readonly_grp;
GRANT SELECT ON "membership_plans" TO grp09_readonly_grp;
GRANT SELECT ON "memberships" TO grp09_readonly_grp;
GRANT SELECT ON "payments" TO grp09_readonly_grp;
GRANT SELECT ("trainer_id", "first_name", "last_name", "specialty") ON "trainers" TO grp09_readonly_grp;

-- Part 5: backup. pg_dump must read every table and sequence, but changes nothing.
GRANT SELECT ON ALL TABLES IN SCHEMA "public" TO grp09_backup_grp;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA "public" TO grp09_backup_grp;

-- Part 6: DBA. Data correction, VACUUM, ANALYZE and monitoring. No TRUNCATE, no DDL, not a superuser.
GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON ALL TABLES IN SCHEMA "public" TO grp09_dba_grp;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA "public" TO grp09_dba_grp;

-- Part 7: future objects. Backups and the DBA cover them; the runtime and read-only roles need a deliberate grant.
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT ON TABLES TO grp09_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT ON SEQUENCES TO grp09_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON TABLES TO grp09_dba_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT USAGE, SELECT ON SEQUENCES TO grp09_dba_grp;
