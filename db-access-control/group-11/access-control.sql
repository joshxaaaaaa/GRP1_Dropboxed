-- Group 11: ReserveIT: Classroom and Material Reservation System
-- Database ReserveIT, schema public. Least-privilege access control (Activity 4).
-- Run as a superuser, connected to ReserveIT. Safe to re-run; also used after a restore (Activity 6).
-- No password is stored here. After running, set each login's password in psql:
--   \password grp11_app
--   \password grp11_report
--   \password grp11_dba
--   \password grp11_backup

-- Part 1: cluster-wide roles. Names carry the group number so projects on one server cannot collide.
DO $$
DECLARE r text;
BEGIN
  FOREACH r IN ARRAY ARRAY['grp11_runtime_grp','grp11_readonly_grp','grp11_dba_grp','grp11_backup_grp'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
  FOREACH r IN ARRAY ARRAY['grp11_app','grp11_report','grp11_dba','grp11_backup'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
END $$;
GRANT grp11_runtime_grp TO grp11_app;
GRANT grp11_readonly_grp TO grp11_report;
GRANT grp11_dba_grp TO grp11_dba;
GRANT grp11_backup_grp TO grp11_backup;
GRANT pg_monitor TO grp11_dba_grp;

-- Part 2: database and schema access. PUBLIC loses its default CONNECT and TEMPORARY.
DO $$
BEGIN
  EXECUTE format('REVOKE ALL ON DATABASE %I FROM PUBLIC', current_database());
  EXECUTE format('GRANT CONNECT ON DATABASE %I TO grp11_runtime_grp, grp11_readonly_grp, grp11_dba_grp, grp11_backup_grp', current_database());
  EXECUTE format('GRANT CONNECT ON DATABASE %I TO reserveit_owner', current_database());
END $$;
REVOKE ALL ON SCHEMA "public" FROM PUBLIC;
GRANT USAGE ON SCHEMA "public" TO grp11_runtime_grp, grp11_readonly_grp, grp11_dba_grp, grp11_backup_grp;
SET search_path TO "public";

-- Start clean, so this file is the full statement of who can do what.
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp11_runtime_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp11_runtime_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp11_readonly_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp11_readonly_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp11_dba_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp11_dba_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "public" FROM grp11_backup_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "public" FROM grp11_backup_grp;

-- Part 3: application runtime. Only what the application's code uses.
GRANT SELECT, INSERT ON "department" TO grp11_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "app_user" TO grp11_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "staff" TO grp11_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "room" TO grp11_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "material" TO grp11_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "reservation" TO grp11_runtime_grp;
GRANT SELECT, INSERT ON "reservation_material" TO grp11_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "penalty" TO grp11_runtime_grp;
-- These tables use SERIAL-style defaults, so INSERT calls nextval() and needs USAGE on the sequence.
GRANT USAGE ON SEQUENCE public.app_user_user_id_seq TO grp11_runtime_grp;
GRANT USAGE ON SEQUENCE public.department_department_id_seq TO grp11_runtime_grp;
GRANT USAGE ON SEQUENCE public.material_material_id_seq TO grp11_runtime_grp;
GRANT USAGE ON SEQUENCE public.penalty_penalty_id_seq TO grp11_runtime_grp;
GRANT USAGE ON SEQUENCE public.reservation_reservation_id_seq TO grp11_runtime_grp;
GRANT USAGE ON SEQUENCE public.room_room_id_seq TO grp11_runtime_grp;
GRANT USAGE ON SEQUENCE public.staff_staff_id_seq TO grp11_runtime_grp;

-- Part 4: read-only reporting. Credentials and contact details are excluded.
GRANT SELECT ("user_id", "first_name", "last_name", "role", "department_id", "status") ON "app_user" TO grp11_readonly_grp;
GRANT SELECT ON "department" TO grp11_readonly_grp;
GRANT SELECT ON "material" TO grp11_readonly_grp;
GRANT SELECT ON "penalty" TO grp11_readonly_grp;
GRANT SELECT ON "reservation" TO grp11_readonly_grp;
GRANT SELECT ON "reservation_material" TO grp11_readonly_grp;
GRANT SELECT ON "room" TO grp11_readonly_grp;
GRANT SELECT ("staff_id", "full_name", "role", "status") ON "staff" TO grp11_readonly_grp;

-- Part 5: backup. pg_dump must read every table and sequence, but changes nothing.
GRANT SELECT ON ALL TABLES IN SCHEMA "public" TO grp11_backup_grp;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA "public" TO grp11_backup_grp;

-- Part 6: DBA. Data correction, VACUUM, ANALYZE and monitoring. No TRUNCATE, no DDL, not a superuser.
GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON ALL TABLES IN SCHEMA "public" TO grp11_dba_grp;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA "public" TO grp11_dba_grp;

-- Part 7: future objects. Backups and the DBA cover them; the runtime and read-only roles need a deliberate grant.
ALTER DEFAULT PRIVILEGES FOR ROLE reserveit_owner IN SCHEMA "public" GRANT SELECT ON TABLES TO grp11_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE reserveit_owner IN SCHEMA "public" GRANT SELECT ON SEQUENCES TO grp11_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE reserveit_owner IN SCHEMA "public" GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON TABLES TO grp11_dba_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE reserveit_owner IN SCHEMA "public" GRANT USAGE, SELECT ON SEQUENCES TO grp11_dba_grp;
