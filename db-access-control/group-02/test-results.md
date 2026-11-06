# Group 02 privilege tests

Database `grp02_event_management_db`. Run 2026-11-06T11:35:48 on an isolated PostgreSQL 18.6 test server, using psql with each account's own login.

| # | Account | Statement or operation | Expected | Actual | Result | Server response |
|---|---|---|---|---|---|---|
| 1 | grp02_app | `SELECT COUNT(*) FROM "event"` | Allowed | Allowed | PASS |  count  -------      0 (1 row) |
| 2 | grp02_app | `INSERT INTO "venue" ("venue_name", "location") VALUES ('ACTIVITY-TEST', 'ACTIVITY-TEST')` | Allowed | Allowed | PASS | INSERT 0 1 |
| 3 | grp02_app | `DELETE FROM "user_account" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table user_account |
| 4 | grp02_app | `DELETE FROM "audit_log" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table audit_log |
| 5 | grp02_app | `TRUNCATE "event"` | Denied | Denied | PASS | ERROR:  permission denied for table event |
| 6 | grp02_app | `DROP TABLE "event"` | Denied | Denied | PASS | ERROR:  must be owner of table event |
| 7 | grp02_app | `CREATE TABLE "school_event_management_db".access_test (id INTEGER)` | Denied | Denied | PASS | ERROR:  permission denied for schema school_event_management_db LINE 1: CREATE TABLE "school_event_management_db".access_test (id IN...                      ^ |
| 8 | grp02_app | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 9 | grp02_app | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 10 | grp02_app | `Connect to database access_unrelated_db` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "access_unrelated_db" DETAIL:  User does not have CONNEC |
| 11 | grp02_report | `SELECT COUNT(*) FROM "event"` | Allowed | Allowed | PASS |  count  -------      0 (1 row) |
| 12 | grp02_report | `UPDATE "event" SET "event_name" = "event_name" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table event |
| 13 | grp02_report | `INSERT INTO "venue" ("venue_name", "location") VALUES ('ACTIVITY-TEST', 'ACTIVITY-TEST')` | Denied | Denied | PASS | ERROR:  permission denied for table venue |
| 14 | grp02_report | `DELETE FROM "event" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table event |
| 15 | grp02_report | `ANALYZE "event"` | Denied | Denied | PASS | ANALYZE WARNING:  permission denied to analyze "event", skipping it |
| 16 | grp02_report | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 17 | grp02_report | `SELECT "user_id" FROM "user_account" LIMIT 1` | Allowed | Allowed | PASS |  user_id  ---------        1 (1 row) |
| 18 | grp02_report | `SELECT "password_hash" FROM "user_account" LIMIT 1` | Denied | Denied | PASS | ERROR:  permission denied for table user_account |
| 19 | grp02_backup | `SELECT COUNT(*) FROM "event"` | Allowed | Allowed | PASS |  count  -------      0 (1 row) |
| 20 | grp02_backup | `LOCK TABLE "event" IN ACCESS SHARE MODE` | Allowed | Allowed | PASS | LOCK TABLE |
| 21 | grp02_backup | `DELETE FROM "event" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table event |
| 22 | grp02_backup | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 23 | grp02_dba | `SELECT COUNT(*) FROM "event"` | Allowed | Allowed | PASS |  count  -------      0 (1 row) |
| 24 | grp02_dba | `ANALYZE "event"` | Allowed | Allowed | PASS | ANALYZE |
| 25 | grp02_dba | `VACUUM "event"` | Allowed | Allowed | PASS | VACUUM |
| 26 | grp02_dba | `SELECT COUNT(query) FROM pg_stat_activity` | Allowed | Allowed | PASS |  count  -------     19 (1 row) |
| 27 | grp02_dba | `DROP TABLE "event"` | Denied | Denied | PASS | ERROR:  must be owner of table event |
| 28 | grp02_dba | `TRUNCATE "event"` | Denied | Denied | PASS | ERROR:  permission denied for table event |
| 29 | grp02_dba | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 30 | grp02_dba | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 31 | grp02_outsider | `Connect to database grp02_event_management_db` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "grp02_event_management_db" DETAIL:  User does not have  |
| 32 | grp02_app | `Log in with a wrong password` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  password authentication failed for user "grp02_app" |
