# Group 05 privilege tests

Database `grp10_shioricafedb`. Run 2026-11-06T20:05:08 on an isolated PostgreSQL 18.6 test server, using psql with each account's own login.

| # | Account | Statement or operation | Expected | Actual | Result | Server response |
|---|---|---|---|---|---|---|
| 1 | grp05_app | `SELECT COUNT(*) FROM "reservation"` | Allowed | Allowed | PASS |  count  -------      0 (1 row) |
| 2 | grp05_app | `INSERT INTO customer (full_name, email, password_hash) VALUES ('Activity Test', 'activity.test@example.com', 'x')` | Allowed | Allowed | PASS | INSERT 0 1 |
| 3 | grp05_app | `DELETE FROM "menu_item" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table menu_item |
| 4 | grp05_app | `TRUNCATE "reservation"` | Denied | Denied | PASS | ERROR:  permission denied for table reservation |
| 5 | grp05_app | `DROP TABLE "reservation"` | Denied | Denied | PASS | ERROR:  must be owner of table reservation |
| 6 | grp05_app | `CREATE TABLE "shioricafe_schema".access_test (id INTEGER)` | Denied | Denied | PASS | ERROR:  permission denied for schema shioricafe_schema LINE 1: CREATE TABLE "shioricafe_schema".access_test (id INTEGER);                      ^ |
| 7 | grp05_app | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 8 | grp05_app | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 9 | grp05_app | `Connect to database access_unrelated_db` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "access_unrelated_db" DETAIL:  User does not have CONNEC |
| 10 | grp05_report | `SELECT COUNT(*) FROM "reservation"` | Allowed | Allowed | PASS |  count  -------      0 (1 row) |
| 11 | grp05_report | `UPDATE "reservation" SET "customer_id" = "customer_id" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table reservation |
| 12 | grp05_report | `INSERT INTO customer (full_name, email, password_hash) VALUES ('Activity Test', 'activity.test@example.com', 'x')` | Denied | Denied | PASS | ERROR:  permission denied for table customer |
| 13 | grp05_report | `DELETE FROM "reservation" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table reservation |
| 14 | grp05_report | `ANALYZE "reservation"` | Denied | Denied | PASS | ANALYZE WARNING:  permission denied to analyze "reservation", skipping it |
| 15 | grp05_report | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 16 | grp05_report | `SELECT "customer_id" FROM "customer" LIMIT 1` | Allowed | Allowed | PASS |  customer_id  ------------- (0 rows) |
| 17 | grp05_report | `SELECT "email" FROM "customer" LIMIT 1` | Denied | Denied | PASS | ERROR:  permission denied for table customer |
| 18 | grp05_backup | `SELECT COUNT(*) FROM "reservation"` | Allowed | Allowed | PASS |  count  -------      0 (1 row) |
| 19 | grp05_backup | `LOCK TABLE "reservation" IN ACCESS SHARE MODE` | Allowed | Allowed | PASS | LOCK TABLE |
| 20 | grp05_backup | `DELETE FROM "reservation" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table reservation |
| 21 | grp05_backup | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 22 | grp05_dba | `SELECT COUNT(*) FROM "reservation"` | Allowed | Allowed | PASS |  count  -------      0 (1 row) |
| 23 | grp05_dba | `ANALYZE "reservation"` | Allowed | Allowed | PASS | ANALYZE |
| 24 | grp05_dba | `VACUUM "reservation"` | Allowed | Allowed | PASS | VACUUM |
| 25 | grp05_dba | `SELECT COUNT(query) FROM pg_stat_activity` | Allowed | Allowed | PASS |  count  -------      9 (1 row) |
| 26 | grp05_dba | `DROP TABLE "reservation"` | Denied | Denied | PASS | ERROR:  must be owner of table reservation |
| 27 | grp05_dba | `TRUNCATE "reservation"` | Denied | Denied | PASS | ERROR:  permission denied for table reservation |
| 28 | grp05_dba | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 29 | grp05_dba | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 30 | grp05_outsider | `Connect to database grp10_shioricafedb` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "grp10_shioricafedb" DETAIL:  User does not have CONNECT |
| 31 | grp05_app | `Log in with a wrong password` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  password authentication failed for user "grp05_app" |
