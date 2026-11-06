# Group 07 privilege tests

Database `grp07_applicantdb`. Run 2026-11-06T10:58:51 on an isolated PostgreSQL 18.6 test server, using psql with each account's own login.

| # | Account | Statement or operation | Expected | Actual | Result | Server response |
|---|---|---|---|---|---|---|
| 1 | grp07_app | `SELECT COUNT(*) FROM "application"` | Allowed | Allowed | PASS |  count  -------     12 (1 row) |
| 2 | grp07_app | `INSERT INTO "department" ("department_name") VALUES ('ACTIVITY-TEST')` | Allowed | Allowed | PASS | INSERT 0 1 |
| 3 | grp07_app | `DELETE FROM "users" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table users |
| 4 | grp07_app | `TRUNCATE "application"` | Denied | Denied | PASS | ERROR:  permission denied for table application |
| 5 | grp07_app | `DROP TABLE "application"` | Denied | Denied | PASS | ERROR:  must be owner of table application |
| 6 | grp07_app | `CREATE TABLE "public".access_test (id INTEGER)` | Denied | Denied | PASS | ERROR:  permission denied for schema public LINE 1: CREATE TABLE "public".access_test (id INTEGER);                      ^ |
| 7 | grp07_app | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 8 | grp07_app | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 9 | grp07_app | `Connect to database access_unrelated_db` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "access_unrelated_db" DETAIL:  User does not have CONNEC |
| 10 | grp07_report | `SELECT COUNT(*) FROM "application"` | Allowed | Allowed | PASS |  count  -------     12 (1 row) |
| 11 | grp07_report | `UPDATE "application" SET "applicant_id" = "applicant_id" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table application |
| 12 | grp07_report | `INSERT INTO "department" ("department_name") VALUES ('ACTIVITY-TEST')` | Denied | Denied | PASS | ERROR:  permission denied for table department |
| 13 | grp07_report | `DELETE FROM "application" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table application |
| 14 | grp07_report | `ANALYZE "application"` | Denied | Denied | PASS | ANALYZE WARNING:  permission denied to analyze "application", skipping it |
| 15 | grp07_report | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 16 | grp07_report | `SELECT "applicant_id" FROM "applicant" LIMIT 1` | Allowed | Allowed | PASS |  applicant_id  --------------             1 (1 row) |
| 17 | grp07_report | `SELECT "email" FROM "applicant" LIMIT 1` | Denied | Denied | PASS | ERROR:  permission denied for table applicant |
| 18 | grp07_backup | `SELECT COUNT(*) FROM "application"` | Allowed | Allowed | PASS |  count  -------     12 (1 row) |
| 19 | grp07_backup | `LOCK TABLE "application" IN ACCESS SHARE MODE` | Allowed | Allowed | PASS | LOCK TABLE |
| 20 | grp07_backup | `DELETE FROM "application" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table application |
| 21 | grp07_backup | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 22 | grp07_dba | `SELECT COUNT(*) FROM "application"` | Allowed | Allowed | PASS |  count  -------     12 (1 row) |
| 23 | grp07_dba | `ANALYZE "application"` | Allowed | Allowed | PASS | ANALYZE |
| 24 | grp07_dba | `VACUUM "application"` | Allowed | Allowed | PASS | VACUUM |
| 25 | grp07_dba | `SELECT COUNT(query) FROM pg_stat_activity` | Allowed | Allowed | PASS |  count  -------      9 (1 row) |
| 26 | grp07_dba | `DROP TABLE "application"` | Denied | Denied | PASS | ERROR:  must be owner of table application |
| 27 | grp07_dba | `TRUNCATE "application"` | Denied | Denied | PASS | ERROR:  permission denied for table application |
| 28 | grp07_dba | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 29 | grp07_dba | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 30 | grp07_outsider | `Connect to database grp07_applicantdb` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "grp07_applicantdb" DETAIL:  User does not have CONNECT  |
| 31 | grp07_app | `Log in with a wrong password` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  password authentication failed for user "grp07_app" |
