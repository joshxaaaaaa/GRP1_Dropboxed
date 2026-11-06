# Group 11 privilege tests

Database `ReserveIT`. Run 2026-11-06T10:59:05 on an isolated PostgreSQL 18.6 test server, using psql with each account's own login.

| # | Account | Statement or operation | Expected | Actual | Result | Server response |
|---|---|---|---|---|---|---|
| 1 | grp11_app | `SELECT COUNT(*) FROM "reservation"` | Allowed | Allowed | PASS |  count  -------      3 (1 row) |
| 2 | grp11_app | `INSERT INTO "department" ("department_name") VALUES ('ACTIVITY-TEST')` | Allowed | Allowed | PASS | INSERT 0 1 |
| 3 | grp11_app | `DELETE FROM "reservation" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table reservation |
| 4 | grp11_app | `TRUNCATE "reservation"` | Denied | Denied | PASS | ERROR:  permission denied for table reservation |
| 5 | grp11_app | `DROP TABLE "reservation"` | Denied | Denied | PASS | ERROR:  must be owner of table reservation |
| 6 | grp11_app | `CREATE TABLE "public".access_test (id INTEGER)` | Denied | Denied | PASS | ERROR:  permission denied for schema public LINE 1: CREATE TABLE "public".access_test (id INTEGER);                      ^ |
| 7 | grp11_app | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 8 | grp11_app | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 9 | grp11_app | `Connect to database access_unrelated_db` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "access_unrelated_db" DETAIL:  User does not have CONNEC |
| 10 | grp11_report | `SELECT COUNT(*) FROM "reservation"` | Allowed | Allowed | PASS |  count  -------      3 (1 row) |
| 11 | grp11_report | `UPDATE "reservation" SET "user_id" = "user_id" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table reservation |
| 12 | grp11_report | `INSERT INTO "department" ("department_name") VALUES ('ACTIVITY-TEST')` | Denied | Denied | PASS | ERROR:  permission denied for table department |
| 13 | grp11_report | `DELETE FROM "reservation" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table reservation |
| 14 | grp11_report | `ANALYZE "reservation"` | Denied | Denied | PASS | ANALYZE WARNING:  permission denied to analyze "reservation", skipping it |
| 15 | grp11_report | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 16 | grp11_report | `SELECT "user_id" FROM "app_user" LIMIT 1` | Allowed | Allowed | PASS |  user_id  ---------        1 (1 row) |
| 17 | grp11_report | `SELECT "email" FROM "app_user" LIMIT 1` | Denied | Denied | PASS | ERROR:  permission denied for table app_user |
| 18 | grp11_backup | `SELECT COUNT(*) FROM "reservation"` | Allowed | Allowed | PASS |  count  -------      3 (1 row) |
| 19 | grp11_backup | `LOCK TABLE "reservation" IN ACCESS SHARE MODE` | Allowed | Allowed | PASS | LOCK TABLE |
| 20 | grp11_backup | `DELETE FROM "reservation" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table reservation |
| 21 | grp11_backup | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 22 | grp11_dba | `SELECT COUNT(*) FROM "reservation"` | Allowed | Allowed | PASS |  count  -------      3 (1 row) |
| 23 | grp11_dba | `ANALYZE "reservation"` | Allowed | Allowed | PASS | ANALYZE |
| 24 | grp11_dba | `VACUUM "reservation"` | Allowed | Allowed | PASS | VACUUM |
| 25 | grp11_dba | `SELECT COUNT(query) FROM pg_stat_activity` | Allowed | Allowed | PASS |  count  -------      9 (1 row) |
| 26 | grp11_dba | `DROP TABLE "reservation"` | Denied | Denied | PASS | ERROR:  must be owner of table reservation |
| 27 | grp11_dba | `TRUNCATE "reservation"` | Denied | Denied | PASS | ERROR:  permission denied for table reservation |
| 28 | grp11_dba | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 29 | grp11_dba | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 30 | grp11_outsider | `Connect to database ReserveIT` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "ReserveIT" DETAIL:  User does not have CONNECT privileg |
| 31 | grp11_app | `Log in with a wrong password` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  password authentication failed for user "grp11_app" |
