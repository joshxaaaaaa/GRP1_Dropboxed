# Group 10 privilege tests

Database `grp10_unisyncdb`. Run 2026-11-06T20:05:35 on an isolated PostgreSQL 18.6 test server, using psql with each account's own login.

| # | Account | Statement or operation | Expected | Actual | Result | Server response |
|---|---|---|---|---|---|---|
| 1 | grp10_app | `SELECT COUNT(*) FROM "event"` | Allowed | Allowed | PASS |  count  -------     50 (1 row) |
| 2 | grp10_app | `INSERT INTO "venue" ("account_id", "venue_name", "location") VALUES (1, 'ACTIVITY-TEST', 'ACTIVITY-TEST')` | Allowed | Allowed | PASS | INSERT 0 1 |
| 3 | grp10_app | `DELETE FROM "account" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table account |
| 4 | grp10_app | `DELETE FROM "notification" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table notification |
| 5 | grp10_app | `TRUNCATE "event"` | Denied | Denied | PASS | ERROR:  permission denied for table event |
| 6 | grp10_app | `DROP TABLE "event"` | Denied | Denied | PASS | ERROR:  must be owner of table event |
| 7 | grp10_app | `CREATE TABLE "public".access_test (id INTEGER)` | Denied | Denied | PASS | ERROR:  permission denied for schema public LINE 1: CREATE TABLE "public".access_test (id INTEGER);                      ^ |
| 8 | grp10_app | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 9 | grp10_app | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 10 | grp10_app | `Connect to database access_unrelated_db` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "access_unrelated_db" DETAIL:  User does not have CONNEC |
| 11 | grp10_report | `SELECT COUNT(*) FROM "event"` | Allowed | Allowed | PASS |  count  -------     50 (1 row) |
| 12 | grp10_report | `UPDATE "event" SET "organization_id" = "organization_id" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table event |
| 13 | grp10_report | `INSERT INTO "venue" ("account_id", "venue_name", "location") VALUES (1, 'ACTIVITY-TEST', 'ACTIVITY-TEST')` | Denied | Denied | PASS | ERROR:  permission denied for table venue |
| 14 | grp10_report | `DELETE FROM "event" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table event |
| 15 | grp10_report | `ANALYZE "event"` | Denied | Denied | PASS | ANALYZE WARNING:  permission denied to analyze "event", skipping it |
| 16 | grp10_report | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 17 | grp10_report | `SELECT "account_id" FROM "account" LIMIT 1` | Allowed | Allowed | PASS |  account_id  ------------           1 (1 row) |
| 18 | grp10_report | `SELECT "email" FROM "account" LIMIT 1` | Denied | Denied | PASS | ERROR:  permission denied for table account |
| 19 | grp10_backup | `SELECT COUNT(*) FROM "event"` | Allowed | Allowed | PASS |  count  -------     50 (1 row) |
| 20 | grp10_backup | `LOCK TABLE "event" IN ACCESS SHARE MODE` | Allowed | Allowed | PASS | LOCK TABLE |
| 21 | grp10_backup | `DELETE FROM "event" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table event |
| 22 | grp10_backup | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 23 | grp10_dba | `SELECT COUNT(*) FROM "event"` | Allowed | Allowed | PASS |  count  -------     50 (1 row) |
| 24 | grp10_dba | `ANALYZE "event"` | Allowed | Allowed | PASS | ANALYZE |
| 25 | grp10_dba | `VACUUM "event"` | Allowed | Allowed | PASS | VACUUM |
| 26 | grp10_dba | `SELECT COUNT(query) FROM pg_stat_activity` | Allowed | Allowed | PASS |  count  -------      9 (1 row) |
| 27 | grp10_dba | `DROP TABLE "event"` | Denied | Denied | PASS | ERROR:  must be owner of table event |
| 28 | grp10_dba | `TRUNCATE "event"` | Denied | Denied | PASS | ERROR:  permission denied for table event |
| 29 | grp10_dba | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 30 | grp10_dba | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 31 | grp10_outsider | `Connect to database grp10_unisyncdb` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "grp10_unisyncdb" DETAIL:  User does not have CONNECT pr |
| 32 | grp10_app | `Log in with a wrong password` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  password authentication failed for user "grp10_app" |
