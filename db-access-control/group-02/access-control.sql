-- Group 02: Eventer: A High School Event Management System (HSEMS)
-- Database grp02_event_management_db, schema school_event_management_db. Least-privilege access control (Activity 4).
-- Run as a superuser, connected to grp02_event_management_db. Safe to re-run; also used after a restore (Activity 6).
-- No password is stored here. After running, set each login's password in psql:
--   \password grp02_app
--   \password grp02_report
--   \password grp02_dba
--   \password grp02_backup

-- Part 1: cluster-wide roles. Names carry the group number so projects on one server cannot collide.
DO $$
DECLARE r text;
BEGIN
  FOREACH r IN ARRAY ARRAY['grp02_runtime_grp','grp02_readonly_grp','grp02_dba_grp','grp02_backup_grp'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
  FOREACH r IN ARRAY ARRAY['grp02_app','grp02_report','grp02_dba','grp02_backup'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
END $$;
GRANT grp02_runtime_grp TO grp02_app;
GRANT grp02_readonly_grp TO grp02_report;
GRANT grp02_dba_grp TO grp02_dba;
GRANT grp02_backup_grp TO grp02_backup;
GRANT pg_monitor TO grp02_dba_grp;

-- Part 2: database and schema access. PUBLIC loses its default CONNECT and TEMPORARY.
DO $$
BEGIN
  EXECUTE format('REVOKE ALL ON DATABASE %I FROM PUBLIC', current_database());
  EXECUTE format('GRANT CONNECT ON DATABASE %I TO grp02_runtime_grp, grp02_readonly_grp, grp02_dba_grp, grp02_backup_grp', current_database());
  EXECUTE format('GRANT CONNECT ON DATABASE %I TO event_owner', current_database());
END $$;
REVOKE ALL ON SCHEMA "school_event_management_db" FROM PUBLIC;
GRANT USAGE ON SCHEMA "school_event_management_db" TO grp02_runtime_grp, grp02_readonly_grp, grp02_dba_grp, grp02_backup_grp;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
SET search_path TO "school_event_management_db";

-- Start clean, so this file is the full statement of who can do what.
REVOKE ALL ON ALL TABLES IN SCHEMA "school_event_management_db" FROM grp02_runtime_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "school_event_management_db" FROM grp02_runtime_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "school_event_management_db" FROM grp02_readonly_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "school_event_management_db" FROM grp02_readonly_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "school_event_management_db" FROM grp02_dba_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "school_event_management_db" FROM grp02_dba_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "school_event_management_db" FROM grp02_backup_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "school_event_management_db" FROM grp02_backup_grp;

-- Part 3: application runtime. Only what the application's code uses.
GRANT SELECT ON "role" TO grp02_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "user_account" TO grp02_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "venue" TO grp02_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "participant" TO grp02_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "event" TO grp02_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "event_schedule" TO grp02_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "event_assignment" TO grp02_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "attendance" TO grp02_runtime_grp;
GRANT SELECT, INSERT ON "audit_log" TO grp02_runtime_grp;
-- All generated keys are identity columns, so INSERT needs no sequence privilege.

-- Part 4: read-only reporting. Credentials and contact details are excluded.
GRANT SELECT ON "attendance" TO grp02_readonly_grp;
GRANT SELECT ON "audit_log" TO grp02_readonly_grp;
GRANT SELECT ON "event" TO grp02_readonly_grp;
GRANT SELECT ON "event_assignment" TO grp02_readonly_grp;
GRANT SELECT ON "event_schedule" TO grp02_readonly_grp;
GRANT SELECT ON "flyway_schema_history" TO grp02_readonly_grp;
GRANT SELECT ON "participant" TO grp02_readonly_grp;
GRANT SELECT ON "role" TO grp02_readonly_grp;
GRANT SELECT ("user_id", "username", "first_name", "last_name", "role_id", "account_status") ON "user_account" TO grp02_readonly_grp;
GRANT SELECT ON "venue" TO grp02_readonly_grp;

-- Part 5: backup. pg_dump must read every table and sequence, but changes nothing.
GRANT SELECT ON ALL TABLES IN SCHEMA "school_event_management_db" TO grp02_backup_grp;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA "school_event_management_db" TO grp02_backup_grp;

-- Part 6: DBA. Data correction, VACUUM, ANALYZE and monitoring. No TRUNCATE, no DDL, not a superuser.
GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON ALL TABLES IN SCHEMA "school_event_management_db" TO grp02_dba_grp;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA "school_event_management_db" TO grp02_dba_grp;

-- Part 7: future objects. Backups and the DBA cover them; the runtime and read-only roles need a deliberate grant.
ALTER DEFAULT PRIVILEGES FOR ROLE event_owner IN SCHEMA "school_event_management_db" GRANT SELECT ON TABLES TO grp02_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE event_owner IN SCHEMA "school_event_management_db" GRANT SELECT ON SEQUENCES TO grp02_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE event_owner IN SCHEMA "school_event_management_db" GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON TABLES TO grp02_dba_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE event_owner IN SCHEMA "school_event_management_db" GRANT USAGE, SELECT ON SEQUENCES TO grp02_dba_grp;
