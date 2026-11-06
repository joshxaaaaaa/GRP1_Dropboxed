-- Group 07: Applicant Management System (AMS)
-- Database grp07_applicantdb, schema public. Least-privilege access control (Activity 4).
-- Run as a superuser, connected to grp07_applicantdb. Safe to re-run; also used after a restore (Activity 6).
-- No password is stored here. After running, set each login's password in psql:
--   \password grp07_app
--   \password grp07_report
--   \password grp07_dba
--   \password grp07_backup

-- Part 1: cluster-wide roles. Names carry the group number so projects on one server cannot collide.
DO $$
DECLARE r text;
BEGIN
  FOREACH r IN ARRAY ARRAY['grp07_runtime_grp','grp07_readonly_grp','grp07_dba_grp','grp07_backup_grp'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
  FOREACH r IN ARRAY ARRAY['grp07_app','grp07_report','grp07_dba','grp07_backup'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
END $$;
GRANT grp07_runtime_grp TO grp07_app;
GRANT grp07_readonly_grp TO grp07_report;
GRANT grp07_dba_grp TO grp07_dba;
GRANT grp07_backup_grp TO grp07_backup;
GRANT pg_monitor TO grp07_dba_grp;

-- Part 2: database and schema access. PUBLIC loses its default CONNECT and TEMPORARY.
DO $$
BEGIN
  EXECUTE format('REVOKE ALL ON DATABASE %I FROM PUBLIC', current_database());
  EXECUTE format('GRANT CONNECT ON DATABASE %I TO grp07_runtime_grp, grp07_readonly_grp, grp07_dba_grp, grp07_backup_grp', current_database());
END $$;
REVOKE ALL ON SCHEMA "public" FROM PUBLIC;
GRANT USAGE ON SCHEMA "public" TO grp07_runtime_grp, grp07_readonly_grp, grp07_dba_grp, grp07_backup_grp;
SET search_path TO "public";

-- Start clean, so this file is the full statement of who can do what.
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp07_runtime_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp07_runtime_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp07_readonly_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp07_readonly_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp07_dba_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp07_dba_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp07_backup_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp07_backup_grp;

-- Part 3: application runtime. Only what the application's code uses.
GRANT SELECT, INSERT, UPDATE, DELETE ON "applicant" TO grp07_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "applicant_requirement" TO grp07_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "application" TO grp07_runtime_grp;
GRANT SELECT ON "application_status" TO grp07_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "department" TO grp07_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "interview" TO grp07_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "position" TO grp07_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "requirement" TO grp07_runtime_grp;
GRANT SELECT, UPDATE ON "users" TO grp07_runtime_grp;
-- These tables use SERIAL-style defaults, so INSERT calls nextval() and needs USAGE on the sequence.
GRANT USAGE ON SEQUENCE public.applicant_applicant_id_seq TO grp07_runtime_grp;
GRANT USAGE ON SEQUENCE public.application_application_id_seq TO grp07_runtime_grp;
GRANT USAGE ON SEQUENCE public.department_department_id_seq TO grp07_runtime_grp;
GRANT USAGE ON SEQUENCE public.interview_interview_id_seq TO grp07_runtime_grp;
GRANT USAGE ON SEQUENCE public.position_position_id_seq TO grp07_runtime_grp;
GRANT USAGE ON SEQUENCE public.requirement_requirement_id_seq TO grp07_runtime_grp;

-- Part 4: read-only reporting. Credentials and contact details are excluded.
GRANT SELECT ("applicant_id", "first_name", "last_name", "date_of_birth", "created_at") ON "applicant" TO grp07_readonly_grp;
GRANT SELECT ON "applicant_requirement" TO grp07_readonly_grp;
GRANT SELECT ON "application" TO grp07_readonly_grp;
GRANT SELECT ON "application_status" TO grp07_readonly_grp;
GRANT SELECT ON "department" TO grp07_readonly_grp;
GRANT SELECT ON "interview" TO grp07_readonly_grp;
GRANT SELECT ON "position" TO grp07_readonly_grp;
GRANT SELECT ON "requirement" TO grp07_readonly_grp;
GRANT SELECT ("user_id", "username", "role", "created_at") ON "users" TO grp07_readonly_grp;

-- Part 5: backup. pg_dump must read every table and sequence, but changes nothing.
GRANT SELECT ON ALL TABLES IN SCHEMA "public" TO grp07_backup_grp;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA "public" TO grp07_backup_grp;

-- Part 6: DBA. Data correction, VACUUM, ANALYZE and monitoring. No TRUNCATE, no DDL, not a superuser.
GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON ALL TABLES IN SCHEMA "public" TO grp07_dba_grp;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA "public" TO grp07_dba_grp;

-- Part 7: future objects. Backups and the DBA cover them; the runtime and read-only roles need a deliberate grant.
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT ON TABLES TO grp07_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT ON SEQUENCES TO grp07_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON TABLES TO grp07_dba_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT USAGE, SELECT ON SEQUENCES TO grp07_dba_grp;
