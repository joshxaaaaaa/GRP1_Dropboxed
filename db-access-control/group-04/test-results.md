# Group 04 privilege tests

Database `grp03_projectdb`. Run 2026-11-06T20:04:55 on an isolated PostgreSQL 18.6 test server, using psql with each account's own login.

| # | Account | Statement or operation | Expected | Actual | Result | Server response |
|---|---|---|---|---|---|---|
| 1 | grp04_app | `SELECT COUNT(*) FROM "appointments"` | Allowed | Allowed | PASS |  count  -------      2 (1 row) |
| 2 | grp04_app | `INSERT INTO patients (first_name, last_name, date_of_birth) VALUES ('Activity', 'Test', '2000-01-01')` | Allowed | Allowed | PASS | INSERT 0 1 |
| 3 | grp04_app | `DELETE FROM "staff_users" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table staff_users |
| 4 | grp04_app | `TRUNCATE "appointments"` | Denied | Denied | PASS | ERROR:  permission denied for table appointments |
| 5 | grp04_app | `DROP TABLE "appointments"` | Denied | Denied | PASS | ERROR:  must be owner of table appointments |
| 6 | grp04_app | `CREATE TABLE "public".access_test (id INTEGER)` | Denied | Denied | PASS | ERROR:  permission denied for schema public LINE 1: CREATE TABLE "public".access_test (id INTEGER);                      ^ |
| 7 | grp04_app | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 8 | grp04_app | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 9 | grp04_app | `Connect to database access_unrelated_db` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "access_unrelated_db" DETAIL:  User does not have CONNEC |
| 10 | grp04_report | `SELECT COUNT(*) FROM "appointments"` | Allowed | Allowed | PASS |  count  -------      2 (1 row) |
| 11 | grp04_report | `UPDATE "appointments" SET "patient_id" = "patient_id" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table appointments |
| 12 | grp04_report | `INSERT INTO patients (first_name, last_name, date_of_birth) VALUES ('Activity', 'Test', '2000-01-01')` | Denied | Denied | PASS | ERROR:  permission denied for table patients |
| 13 | grp04_report | `DELETE FROM "appointments" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table appointments |
| 14 | grp04_report | `ANALYZE "appointments"` | Denied | Denied | PASS | ANALYZE WARNING:  permission denied to analyze "appointments", skipping it |
| 15 | grp04_report | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 16 | grp04_report | `SELECT "doctor_id" FROM "doctors" LIMIT 1` | Allowed | Allowed | PASS |  doctor_id  -----------          1 (1 row) |
| 17 | grp04_report | `SELECT "email" FROM "doctors" LIMIT 1` | Denied | Denied | PASS | ERROR:  permission denied for table doctors |
| 18 | grp04_backup | `SELECT COUNT(*) FROM "appointments"` | Allowed | Allowed | PASS |  count  -------      2 (1 row) |
| 19 | grp04_backup | `LOCK TABLE "appointments" IN ACCESS SHARE MODE` | Allowed | Allowed | PASS | LOCK TABLE |
| 20 | grp04_backup | `DELETE FROM "appointments" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table appointments |
| 21 | grp04_backup | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 22 | grp04_dba | `SELECT COUNT(*) FROM "appointments"` | Allowed | Allowed | PASS |  count  -------      2 (1 row) |
| 23 | grp04_dba | `ANALYZE "appointments"` | Allowed | Allowed | PASS | ANALYZE |
| 24 | grp04_dba | `VACUUM "appointments"` | Allowed | Allowed | PASS | VACUUM |
| 25 | grp04_dba | `SELECT COUNT(query) FROM pg_stat_activity` | Allowed | Allowed | PASS |  count  -------      9 (1 row) |
| 26 | grp04_dba | `DROP TABLE "appointments"` | Denied | Denied | PASS | ERROR:  must be owner of table appointments |
| 27 | grp04_dba | `TRUNCATE "appointments"` | Denied | Denied | PASS | ERROR:  permission denied for table appointments |
| 28 | grp04_dba | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 29 | grp04_dba | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 30 | grp04_outsider | `Connect to database grp03_projectdb` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "grp03_projectdb" DETAIL:  User does not have CONNECT pr |
| 31 | grp04_app | `Log in with a wrong password` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  password authentication failed for user "grp04_app" |
