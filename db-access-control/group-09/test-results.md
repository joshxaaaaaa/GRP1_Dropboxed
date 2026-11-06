# Group 09 privilege tests

Database `grp99_gymdb`. Run 2026-11-06T10:58:58 on an isolated PostgreSQL 18.6 test server, using psql with each account's own login.

| # | Account | Statement or operation | Expected | Actual | Result | Server response |
|---|---|---|---|---|---|---|
| 1 | grp09_app | `SELECT COUNT(*) FROM "memberships"` | Allowed | Allowed | PASS |  count  -------      5 (1 row) |
| 2 | grp09_app | `INSERT INTO "membership_plans" ("plan_name", "duration_months", "price") VALUES ('ACTIVITY-TEST', 1, 1)` | Allowed | Allowed | PASS | INSERT 0 1 |
| 3 | grp09_app | `DELETE FROM "members" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table members |
| 4 | grp09_app | `TRUNCATE "memberships"` | Denied | Denied | PASS | ERROR:  permission denied for table memberships |
| 5 | grp09_app | `DROP TABLE "memberships"` | Denied | Denied | PASS | ERROR:  must be owner of table memberships |
| 6 | grp09_app | `CREATE TABLE "public".access_test (id INTEGER)` | Denied | Denied | PASS | ERROR:  permission denied for schema public LINE 1: CREATE TABLE "public".access_test (id INTEGER);                      ^ |
| 7 | grp09_app | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 8 | grp09_app | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 9 | grp09_app | `Connect to database access_unrelated_db` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "access_unrelated_db" DETAIL:  User does not have CONNEC |
| 10 | grp09_report | `SELECT COUNT(*) FROM "memberships"` | Allowed | Allowed | PASS |  count  -------      5 (1 row) |
| 11 | grp09_report | `UPDATE "memberships" SET "member_id" = "member_id" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table memberships |
| 12 | grp09_report | `INSERT INTO "membership_plans" ("plan_name", "duration_months", "price") VALUES ('ACTIVITY-TEST', 1, 1)` | Denied | Denied | PASS | ERROR:  permission denied for table membership_plans |
| 13 | grp09_report | `DELETE FROM "memberships" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table memberships |
| 14 | grp09_report | `ANALYZE "memberships"` | Denied | Denied | PASS | ANALYZE WARNING:  permission denied to analyze "memberships", skipping it |
| 15 | grp09_report | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 16 | grp09_report | `SELECT "member_id" FROM "members" LIMIT 1` | Allowed | Allowed | PASS |  member_id  -----------          1 (1 row) |
| 17 | grp09_report | `SELECT "email" FROM "members" LIMIT 1` | Denied | Denied | PASS | ERROR:  permission denied for table members |
| 18 | grp09_backup | `SELECT COUNT(*) FROM "memberships"` | Allowed | Allowed | PASS |  count  -------      5 (1 row) |
| 19 | grp09_backup | `LOCK TABLE "memberships" IN ACCESS SHARE MODE` | Allowed | Allowed | PASS | LOCK TABLE |
| 20 | grp09_backup | `DELETE FROM "memberships" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table memberships |
| 21 | grp09_backup | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 22 | grp09_dba | `SELECT COUNT(*) FROM "memberships"` | Allowed | Allowed | PASS |  count  -------      5 (1 row) |
| 23 | grp09_dba | `ANALYZE "memberships"` | Allowed | Allowed | PASS | ANALYZE |
| 24 | grp09_dba | `VACUUM "memberships"` | Allowed | Allowed | PASS | VACUUM |
| 25 | grp09_dba | `SELECT COUNT(query) FROM pg_stat_activity` | Allowed | Allowed | PASS |  count  -------      9 (1 row) |
| 26 | grp09_dba | `DROP TABLE "memberships"` | Denied | Denied | PASS | ERROR:  must be owner of table memberships |
| 27 | grp09_dba | `TRUNCATE "memberships"` | Denied | Denied | PASS | ERROR:  permission denied for table memberships |
| 28 | grp09_dba | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 29 | grp09_dba | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 30 | grp09_outsider | `Connect to database grp99_gymdb` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "grp99_gymdb" DETAIL:  User does not have CONNECT privil |
| 31 | grp09_app | `Log in with a wrong password` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  password authentication failed for user "grp09_app" |
