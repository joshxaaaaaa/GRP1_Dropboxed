# Group 08 privilege tests

Database `catering_management_db`. Run 2026-11-06T20:05:23 on an isolated PostgreSQL 18.6 test server, using psql with each account's own login.

| # | Account | Statement or operation | Expected | Actual | Result | Server response |
|---|---|---|---|---|---|---|
| 1 | grp08_app | `SELECT COUNT(*) FROM "reservation"` | Allowed | Allowed | PASS |  count  -------      3 (1 row) |
| 2 | grp08_app | `INSERT INTO "package" ("package_name", "price_per_guest") VALUES ('ACTIVITY-TEST', 1)` | Allowed | Allowed | PASS | INSERT 0 1 |
| 3 | grp08_app | `DELETE FROM "admin" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table admin |
| 4 | grp08_app | `TRUNCATE "reservation"` | Denied | Denied | PASS | ERROR:  permission denied for table reservation |
| 5 | grp08_app | `DROP TABLE "reservation"` | Denied | Denied | PASS | ERROR:  must be owner of table reservation |
| 6 | grp08_app | `CREATE TABLE "public".access_test (id INTEGER)` | Denied | Denied | PASS | ERROR:  permission denied for schema public LINE 1: CREATE TABLE "public".access_test (id INTEGER);                      ^ |
| 7 | grp08_app | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 8 | grp08_app | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 9 | grp08_app | `Connect to database access_unrelated_db` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "access_unrelated_db" DETAIL:  User does not have CONNEC |
| 10 | grp08_report | `SELECT COUNT(*) FROM "reservation"` | Allowed | Allowed | PASS |  count  -------      3 (1 row) |
| 11 | grp08_report | `UPDATE "reservation" SET "customer_id" = "customer_id" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table reservation |
| 12 | grp08_report | `INSERT INTO "package" ("package_name", "price_per_guest") VALUES ('ACTIVITY-TEST', 1)` | Denied | Denied | PASS | ERROR:  permission denied for table package |
| 13 | grp08_report | `DELETE FROM "reservation" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table reservation |
| 14 | grp08_report | `ANALYZE "reservation"` | Denied | Denied | PASS | ANALYZE WARNING:  permission denied to analyze "reservation", skipping it |
| 15 | grp08_report | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 16 | grp08_report | `SELECT "admin_id" FROM "admin" LIMIT 1` | Allowed | Allowed | PASS |  admin_id  ---------- (0 rows) |
| 17 | grp08_report | `SELECT "password_hash" FROM "admin" LIMIT 1` | Denied | Denied | PASS | ERROR:  permission denied for table admin |
| 18 | grp08_backup | `SELECT COUNT(*) FROM "reservation"` | Allowed | Allowed | PASS |  count  -------      3 (1 row) |
| 19 | grp08_backup | `LOCK TABLE "reservation" IN ACCESS SHARE MODE` | Allowed | Allowed | PASS | LOCK TABLE |
| 20 | grp08_backup | `DELETE FROM "reservation" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table reservation |
| 21 | grp08_backup | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 22 | grp08_dba | `SELECT COUNT(*) FROM "reservation"` | Allowed | Allowed | PASS |  count  -------      3 (1 row) |
| 23 | grp08_dba | `ANALYZE "reservation"` | Allowed | Allowed | PASS | ANALYZE |
| 24 | grp08_dba | `VACUUM "reservation"` | Allowed | Allowed | PASS | VACUUM |
| 25 | grp08_dba | `SELECT COUNT(query) FROM pg_stat_activity` | Allowed | Allowed | PASS |  count  -------      9 (1 row) |
| 26 | grp08_dba | `DROP TABLE "reservation"` | Denied | Denied | PASS | ERROR:  must be owner of table reservation |
| 27 | grp08_dba | `TRUNCATE "reservation"` | Denied | Denied | PASS | ERROR:  permission denied for table reservation |
| 28 | grp08_dba | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 29 | grp08_dba | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 30 | grp08_outsider | `Connect to database catering_management_db` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "catering_management_db" DETAIL:  User does not have CON |
| 31 | grp08_app | `Log in with a wrong password` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  password authentication failed for user "grp08_app" |
