-- Group 10: UniSync: A University Event Scheduling and Registration System
-- Database grp10_unisyncdb, schema public. Least-privilege access control (Activity 4).
-- Run as a superuser, connected to grp10_unisyncdb. Safe to re-run; also used after a restore (Activity 6).
-- No password is stored here. After running, set each login's password in psql:
--   \password grp10_app
--   \password grp10_report
--   \password grp10_dba
--   \password grp10_backup

-- Part 1: cluster-wide roles. Names carry the group number so projects on one server cannot collide.
DO $$
DECLARE r text;
BEGIN
  FOREACH r IN ARRAY ARRAY['grp10_runtime_grp','grp10_readonly_grp','grp10_dba_grp','grp10_backup_grp'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
  FOREACH r IN ARRAY ARRAY['grp10_app','grp10_report','grp10_dba','grp10_backup'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
END $$;
GRANT grp10_runtime_grp TO grp10_app;
GRANT grp10_readonly_grp TO grp10_report;
GRANT grp10_dba_grp TO grp10_dba;
GRANT grp10_backup_grp TO grp10_backup;
GRANT pg_monitor TO grp10_dba_grp;

-- Part 2: database and schema access. PUBLIC loses its default CONNECT and TEMPORARY.
DO $$
BEGIN
  EXECUTE format('REVOKE ALL ON DATABASE %I FROM PUBLIC', current_database());
  EXECUTE format('GRANT CONNECT ON DATABASE %I TO grp10_runtime_grp, grp10_readonly_grp, grp10_dba_grp, grp10_backup_grp', current_database());
END $$;
REVOKE ALL ON SCHEMA "public" FROM PUBLIC;
GRANT USAGE ON SCHEMA "public" TO grp10_runtime_grp, grp10_readonly_grp, grp10_dba_grp, grp10_backup_grp;
SET search_path TO "public";

-- Start clean, so this file is the full statement of who can do what.
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp10_runtime_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp10_runtime_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp10_readonly_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp10_readonly_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp10_dba_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp10_dba_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp10_backup_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp10_backup_grp;

-- Part 3: application runtime. Only what the application's code uses.
GRANT SELECT, INSERT, UPDATE ON "account" TO grp10_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "event" TO grp10_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "event_schedule" TO grp10_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "membership" TO grp10_runtime_grp;
GRANT INSERT ON "notification" TO grp10_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "organization" TO grp10_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "registration" TO grp10_runtime_grp;
GRANT SELECT, INSERT ON "venue" TO grp10_runtime_grp;
-- These tables use SERIAL-style defaults, so INSERT calls nextval() and needs USAGE on the sequence.
GRANT USAGE ON SEQUENCE public.account_account_id_seq TO grp10_runtime_grp;
GRANT USAGE ON SEQUENCE public.event_event_id_seq TO grp10_runtime_grp;
GRANT USAGE ON SEQUENCE public.event_schedule_schedule_id_seq TO grp10_runtime_grp;
GRANT USAGE ON SEQUENCE public.membership_membership_id_seq TO grp10_runtime_grp;
GRANT USAGE ON SEQUENCE public.notification_notification_id_seq TO grp10_runtime_grp;
GRANT USAGE ON SEQUENCE public.organization_organization_id_seq TO grp10_runtime_grp;
GRANT USAGE ON SEQUENCE public.registration_registration_id_seq TO grp10_runtime_grp;
GRANT USAGE ON SEQUENCE public.venue_venue_id_seq TO grp10_runtime_grp;

-- Part 4: read-only reporting. Credentials and contact details are excluded.
GRANT SELECT ("account_id", "account_name", "avatar_url", "account_status") ON "account" TO grp10_readonly_grp;
GRANT SELECT ON "event" TO grp10_readonly_grp;
GRANT SELECT ON "event_schedule" TO grp10_readonly_grp;
GRANT SELECT ON "membership" TO grp10_readonly_grp;
GRANT SELECT ON "notification" TO grp10_readonly_grp;
GRANT SELECT ON "organization" TO grp10_readonly_grp;
GRANT SELECT ON "registration" TO grp10_readonly_grp;
GRANT SELECT ON "venue" TO grp10_readonly_grp;

-- Part 5: backup. pg_dump must read every table and sequence, but changes nothing.
GRANT SELECT ON ALL TABLES IN SCHEMA "public" TO grp10_backup_grp;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA "public" TO grp10_backup_grp;

-- Part 6: DBA. Data correction, VACUUM, ANALYZE and monitoring. No TRUNCATE, no DDL, not a superuser.
GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON ALL TABLES IN SCHEMA "public" TO grp10_dba_grp;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA "public" TO grp10_dba_grp;

-- Part 7: future objects. Backups and the DBA cover them; the runtime and read-only roles need a deliberate grant.
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT ON TABLES TO grp10_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT ON SEQUENCES TO grp10_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON TABLES TO grp10_dba_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT USAGE, SELECT ON SEQUENCES TO grp10_dba_grp;
