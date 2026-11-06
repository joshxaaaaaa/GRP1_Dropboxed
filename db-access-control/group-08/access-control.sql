-- Group 08: Catering Management System
-- Database catering_management_db, schema public. Least-privilege access control (Activity 4).
-- Run as a superuser, connected to catering_management_db. Safe to re-run; also used after a restore (Activity 6).
-- No password is stored here. After running, set each login's password in psql:
--   \password grp08_app
--   \password grp08_report
--   \password grp08_dba
--   \password grp08_backup

-- Part 1: cluster-wide roles. Names carry the group number so projects on one server cannot collide.
DO $$
DECLARE r text;
BEGIN
  FOREACH r IN ARRAY ARRAY['grp08_runtime_grp','grp08_readonly_grp','grp08_dba_grp','grp08_backup_grp'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
  FOREACH r IN ARRAY ARRAY['grp08_app','grp08_report','grp08_dba','grp08_backup'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
END $$;
GRANT grp08_runtime_grp TO grp08_app;
GRANT grp08_readonly_grp TO grp08_report;
GRANT grp08_dba_grp TO grp08_dba;
GRANT grp08_backup_grp TO grp08_backup;
GRANT pg_monitor TO grp08_dba_grp;

-- Part 2: database and schema access. PUBLIC loses its default CONNECT and TEMPORARY.
DO $$
BEGIN
  EXECUTE format('REVOKE ALL ON DATABASE %I FROM PUBLIC', current_database());
  EXECUTE format('GRANT CONNECT ON DATABASE %I TO grp08_runtime_grp, grp08_readonly_grp, grp08_dba_grp, grp08_backup_grp', current_database());
END $$;
REVOKE ALL ON SCHEMA "public" FROM PUBLIC;
GRANT USAGE ON SCHEMA "public" TO grp08_runtime_grp, grp08_readonly_grp, grp08_dba_grp, grp08_backup_grp;
SET search_path TO "public";

-- This table is normally created by the application at run time, which a restricted account cannot do.
CREATE TABLE IF NOT EXISTS "session" ("sid" varchar NOT NULL COLLATE "default" PRIMARY KEY, "sess" json NOT NULL, "expire" timestamp(6) NOT NULL);
CREATE INDEX IF NOT EXISTS "IDX_session_expire" ON "session" ("expire");

-- Start clean, so this file is the full statement of who can do what.
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp08_runtime_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp08_runtime_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp08_readonly_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp08_readonly_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp08_dba_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp08_dba_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp08_backup_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp08_backup_grp;

-- Part 3: application runtime. Only what the application's code uses.
GRANT SELECT ON "admin" TO grp08_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "cancellation" TO grp08_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "customer" TO grp08_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "employee" TO grp08_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "event_assignment" TO grp08_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "inventory" TO grp08_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "menu_item" TO grp08_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "package" TO grp08_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "payment" TO grp08_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "reservation" TO grp08_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "reservation_menu" TO grp08_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "session" TO grp08_runtime_grp;
-- All generated keys are identity columns, so INSERT needs no sequence privilege.

-- Part 4: read-only reporting. Credentials and contact details are excluded.
GRANT SELECT ("admin_id", "username", "created_at") ON "admin" TO grp08_readonly_grp;
GRANT SELECT ON "cancellation" TO grp08_readonly_grp;
GRANT SELECT ("customer_id", "first_name", "last_name") ON "customer" TO grp08_readonly_grp;
GRANT SELECT ("employee_id", "first_name", "last_name", "role") ON "employee" TO grp08_readonly_grp;
GRANT SELECT ON "event_assignment" TO grp08_readonly_grp;
GRANT SELECT ON "inventory" TO grp08_readonly_grp;
GRANT SELECT ON "menu_item" TO grp08_readonly_grp;
GRANT SELECT ON "package" TO grp08_readonly_grp;
GRANT SELECT ON "payment" TO grp08_readonly_grp;
GRANT SELECT ON "reservation" TO grp08_readonly_grp;
GRANT SELECT ON "reservation_menu" TO grp08_readonly_grp;

-- Part 5: backup. pg_dump must read every table and sequence, but changes nothing.
GRANT SELECT ON ALL TABLES IN SCHEMA "public" TO grp08_backup_grp;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA "public" TO grp08_backup_grp;

-- Part 6: DBA. Data correction, VACUUM, ANALYZE and monitoring. No TRUNCATE, no DDL, not a superuser.
GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON ALL TABLES IN SCHEMA "public" TO grp08_dba_grp;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA "public" TO grp08_dba_grp;

-- Part 7: future objects. Backups and the DBA cover them; the runtime and read-only roles need a deliberate grant.
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT ON TABLES TO grp08_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT ON SEQUENCES TO grp08_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON TABLES TO grp08_dba_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "public" GRANT USAGE, SELECT ON SEQUENCES TO grp08_dba_grp;
