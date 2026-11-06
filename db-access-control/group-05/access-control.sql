-- Group 05: SHIORIcafe
-- Database grp10_shioricafedb, schema shioricafe_schema. Least-privilege access control (Activity 4).
-- Run as a superuser, connected to grp10_shioricafedb. Safe to re-run; also used after a restore (Activity 6).
-- No password is stored here. After running, set each login's password in psql:
--   \password grp05_app
--   \password grp05_report
--   \password grp05_dba
--   \password grp05_backup

-- Part 1: cluster-wide roles. Names carry the group number so projects on one server cannot collide.
DO $$
DECLARE r text;
BEGIN
  FOREACH r IN ARRAY ARRAY['grp05_runtime_grp','grp05_readonly_grp','grp05_dba_grp','grp05_backup_grp'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
  FOREACH r IN ARRAY ARRAY['grp05_app','grp05_report','grp05_dba','grp05_backup'] LOOP
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = r) THEN EXECUTE format('CREATE ROLE %I', r); END IF;
    EXECUTE format('ALTER ROLE %I LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS INHERIT', r);
  END LOOP;
END $$;
GRANT grp05_runtime_grp TO grp05_app;
GRANT grp05_readonly_grp TO grp05_report;
GRANT grp05_dba_grp TO grp05_dba;
GRANT grp05_backup_grp TO grp05_backup;
GRANT pg_monitor TO grp05_dba_grp;

-- Part 2: database and schema access. PUBLIC loses its default CONNECT and TEMPORARY.
DO $$
BEGIN
  EXECUTE format('REVOKE ALL ON DATABASE %I FROM PUBLIC', current_database());
  EXECUTE format('GRANT CONNECT ON DATABASE %I TO grp05_runtime_grp, grp05_readonly_grp, grp05_dba_grp, grp05_backup_grp', current_database());
END $$;
REVOKE ALL ON SCHEMA "shioricafe_schema" FROM PUBLIC;
GRANT USAGE ON SCHEMA "shioricafe_schema" TO grp05_runtime_grp, grp05_readonly_grp, grp05_dba_grp, grp05_backup_grp;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
SET search_path TO "shioricafe_schema";

-- This table is normally created by the application at run time, which a restricted account cannot do.
CREATE TABLE IF NOT EXISTS inquiry (inquiry_id SERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL, email VARCHAR(255) NOT NULL, subject VARCHAR(255) NOT NULL, message TEXT NOT NULL, status VARCHAR(50) DEFAULT 'Unread', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

-- Start clean, so this file is the full statement of who can do what.
REVOKE ALL ON ALL TABLES IN SCHEMA "shioricafe_schema" FROM grp05_runtime_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "shioricafe_schema" FROM grp05_runtime_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "shioricafe_schema" FROM grp05_readonly_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "shioricafe_schema" FROM grp05_readonly_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "shioricafe_schema" FROM grp05_dba_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "shioricafe_schema" FROM grp05_dba_grp;
REVOKE ALL ON ALL TABLES IN SCHEMA "shioricafe_schema" FROM grp05_backup_grp;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA "shioricafe_schema" FROM grp05_backup_grp;

-- Part 3: application runtime. Only what the application's code uses.
GRANT SELECT ON "category" TO grp05_runtime_grp;
GRANT SELECT, INSERT ON "customer" TO grp05_runtime_grp;
GRANT SELECT, INSERT, UPDATE, DELETE ON "inquiry" TO grp05_runtime_grp;
GRANT SELECT ON "menu_item" TO grp05_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "order" TO grp05_runtime_grp;
GRANT SELECT, INSERT ON "order_item" TO grp05_runtime_grp;
GRANT SELECT, INSERT, UPDATE ON "reservation" TO grp05_runtime_grp;
GRANT SELECT, INSERT ON "staff" TO grp05_runtime_grp;
GRANT SELECT ON "table" TO grp05_runtime_grp;
-- These tables use SERIAL-style defaults, so INSERT calls nextval() and needs USAGE on the sequence.
GRANT USAGE ON SEQUENCE shioricafe_schema.inquiry_inquiry_id_seq TO grp05_runtime_grp;

-- Part 4: read-only reporting. Credentials and contact details are excluded.
GRANT SELECT ON "category" TO grp05_readonly_grp;
GRANT SELECT ("customer_id", "full_name", "created_at", "updated_at") ON "customer" TO grp05_readonly_grp;
GRANT SELECT ("inquiry_id", "name", "subject", "message", "status", "created_at") ON "inquiry" TO grp05_readonly_grp;
GRANT SELECT ON "menu_item" TO grp05_readonly_grp;
GRANT SELECT ON "order" TO grp05_readonly_grp;
GRANT SELECT ON "order_discount" TO grp05_readonly_grp;
GRANT SELECT ON "order_discount_allocation" TO grp05_readonly_grp;
GRANT SELECT ON "order_item" TO grp05_readonly_grp;
GRANT SELECT ON "payment_attempt" TO grp05_readonly_grp;
GRANT SELECT ON "payment_refund" TO grp05_readonly_grp;
GRANT SELECT ON "payment_refund_item_allocation" TO grp05_readonly_grp;
GRANT SELECT ON "payment_reversal" TO grp05_readonly_grp;
GRANT SELECT ON "payment_transaction" TO grp05_readonly_grp;
GRANT SELECT ON "provider_event" TO grp05_readonly_grp;
GRANT SELECT ON "reservation" TO grp05_readonly_grp;
GRANT SELECT ("staff_id", "full_name", "role", "created_by_staff_id", "created_at", "updated_at") ON "staff" TO grp05_readonly_grp;
GRANT SELECT ON "store_credit_ledger" TO grp05_readonly_grp;
GRANT SELECT ON "table" TO grp05_readonly_grp;
GRANT SELECT ON "v_order_item_summary" TO grp05_readonly_grp;
GRANT SELECT ON "v_order_summary" TO grp05_readonly_grp;
GRANT SELECT ON "v_payment_summary" TO grp05_readonly_grp;

-- Part 5: backup. pg_dump must read every table and sequence, but changes nothing.
GRANT SELECT ON ALL TABLES IN SCHEMA "shioricafe_schema" TO grp05_backup_grp;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA "shioricafe_schema" TO grp05_backup_grp;

-- Part 6: DBA. Data correction, VACUUM, ANALYZE and monitoring. No TRUNCATE, no DDL, not a superuser.
GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON ALL TABLES IN SCHEMA "shioricafe_schema" TO grp05_dba_grp;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA "shioricafe_schema" TO grp05_dba_grp;

-- Part 7: future objects. Backups and the DBA cover them; the runtime and read-only roles need a deliberate grant.
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "shioricafe_schema" GRANT SELECT ON TABLES TO grp05_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "shioricafe_schema" GRANT SELECT ON SEQUENCES TO grp05_backup_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "shioricafe_schema" GRANT SELECT, INSERT, UPDATE, DELETE, MAINTAIN ON TABLES TO grp05_dba_grp;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "shioricafe_schema" GRANT USAGE, SELECT ON SEQUENCES TO grp05_dba_grp;
