# Group 03 privilege tests

Database `group3_pawpaw`. Run 2026-11-06T10:58:27 on an isolated PostgreSQL 18.6 test server, using psql with each account's own login.

| # | Account | Statement or operation | Expected | Actual | Result | Server response |
|---|---|---|---|---|---|---|
| 1 | grp03_app | `SELECT COUNT(*) FROM "appointment"` | Allowed | Allowed | PASS |  count  -------      0 (1 row) |
| 2 | grp03_app | `INSERT INTO "service" ("service_name", "price") VALUES ('ACTIVITY-TEST', 1)` | Allowed | Allowed | PASS | INSERT 0 1 |
| 3 | grp03_app | `DELETE FROM "medical_record" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table medical_record |
| 4 | grp03_app | `DELETE FROM "audit_log" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table audit_log |
| 5 | grp03_app | `TRUNCATE "appointment"` | Denied | Denied | PASS | ERROR:  permission denied for table appointment |
| 6 | grp03_app | `DROP TABLE "appointment"` | Denied | Denied | PASS | ERROR:  must be owner of table appointment |
| 7 | grp03_app | `CREATE TABLE "public".access_test (id INTEGER)` | Denied | Denied | PASS | ERROR:  permission denied for schema public LINE 1: CREATE TABLE "public".access_test (id INTEGER);                      ^ |
| 8 | grp03_app | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 9 | grp03_app | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 10 | grp03_app | `Connect to database access_unrelated_db` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "access_unrelated_db" DETAIL:  User does not have CONNEC |
| 11 | grp03_report | `SELECT COUNT(*) FROM "appointment"` | Allowed | Allowed | PASS |  count  -------      0 (1 row) |
| 12 | grp03_report | `UPDATE "appointment" SET "pet_id" = "pet_id" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table appointment |
| 13 | grp03_report | `INSERT INTO "service" ("service_name", "price") VALUES ('ACTIVITY-TEST', 1)` | Denied | Denied | PASS | ERROR:  permission denied for table service |
| 14 | grp03_report | `DELETE FROM "appointment" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table appointment |
| 15 | grp03_report | `ANALYZE "appointment"` | Denied | Denied | PASS | ANALYZE WARNING:  permission denied to analyze "appointment", skipping it |
| 16 | grp03_report | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 17 | grp03_report | `SELECT "owner_id" FROM "owner" LIMIT 1` | Allowed | Allowed | PASS |  owner_id  ----------         1 (1 row) |
| 18 | grp03_report | `SELECT "email" FROM "owner" LIMIT 1` | Denied | Denied | PASS | ERROR:  permission denied for table owner |
| 19 | grp03_backup | `SELECT COUNT(*) FROM "appointment"` | Allowed | Allowed | PASS |  count  -------      0 (1 row) |
| 20 | grp03_backup | `LOCK TABLE "appointment" IN ACCESS SHARE MODE` | Allowed | Allowed | PASS | LOCK TABLE |
| 21 | grp03_backup | `DELETE FROM "appointment" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table appointment |
| 22 | grp03_backup | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 23 | grp03_dba | `SELECT COUNT(*) FROM "appointment"` | Allowed | Allowed | PASS |  count  -------      0 (1 row) |
| 24 | grp03_dba | `ANALYZE "appointment"` | Allowed | Allowed | PASS | ANALYZE |
| 25 | grp03_dba | `VACUUM "appointment"` | Allowed | Allowed | PASS | VACUUM |
| 26 | grp03_dba | `SELECT COUNT(query) FROM pg_stat_activity` | Allowed | Allowed | PASS |  count  -------      9 (1 row) |
| 27 | grp03_dba | `DROP TABLE "appointment"` | Denied | Denied | PASS | ERROR:  must be owner of table appointment |
| 28 | grp03_dba | `TRUNCATE "appointment"` | Denied | Denied | PASS | ERROR:  permission denied for table appointment |
| 29 | grp03_dba | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 30 | grp03_dba | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 31 | grp03_outsider | `Connect to database group3_pawpaw` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "group3_pawpaw" DETAIL:  User does not have CONNECT priv |
| 32 | grp03_app | `Log in with a wrong password` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  password authentication failed for user "grp03_app" |
