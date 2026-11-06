# Group 06 privilege tests

Database `car_rental_db`. Run 2026-11-06T10:58:43 on an isolated PostgreSQL 18.6 test server, using psql with each account's own login.

| # | Account | Statement or operation | Expected | Actual | Result | Server response |
|---|---|---|---|---|---|---|
| 1 | grp06_app | `SELECT COUNT(*) FROM "vehicle"` | Allowed | Allowed | PASS |  count  -------      8 (1 row) |
| 2 | grp06_app | `INSERT INTO "vehicle_category" ("category_name") VALUES ('ACTIVITY-TEST')` | Allowed | Allowed | PASS | INSERT 0 1 |
| 3 | grp06_app | `DELETE FROM "payment" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table payment |
| 4 | grp06_app | `DELETE FROM "audit_log" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table audit_log |
| 5 | grp06_app | `TRUNCATE "vehicle"` | Denied | Denied | PASS | ERROR:  permission denied for table vehicle |
| 6 | grp06_app | `DROP TABLE "vehicle"` | Denied | Denied | PASS | ERROR:  must be owner of table vehicle |
| 7 | grp06_app | `CREATE TABLE "public".access_test (id INTEGER)` | Denied | Denied | PASS | ERROR:  permission denied for schema public LINE 1: CREATE TABLE "public".access_test (id INTEGER);                      ^ |
| 8 | grp06_app | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 9 | grp06_app | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 10 | grp06_app | `Connect to database access_unrelated_db` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "access_unrelated_db" DETAIL:  User does not have CONNEC |
| 11 | grp06_report | `SELECT COUNT(*) FROM "vehicle"` | Allowed | Allowed | PASS |  count  -------      8 (1 row) |
| 12 | grp06_report | `UPDATE "vehicle" SET "category_id" = "category_id" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table vehicle |
| 13 | grp06_report | `INSERT INTO "vehicle_category" ("category_name") VALUES ('ACTIVITY-TEST')` | Denied | Denied | PASS | ERROR:  permission denied for table vehicle_category |
| 14 | grp06_report | `DELETE FROM "vehicle" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table vehicle |
| 15 | grp06_report | `ANALYZE "vehicle"` | Denied | Denied | PASS | ANALYZE WARNING:  permission denied to analyze "vehicle", skipping it |
| 16 | grp06_report | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 17 | grp06_report | `SELECT "customer_id" FROM "customer" LIMIT 1` | Allowed | Allowed | PASS |  customer_id  -------------            1 (1 row) |
| 18 | grp06_report | `SELECT "email" FROM "customer" LIMIT 1` | Denied | Denied | PASS | ERROR:  permission denied for table customer |
| 19 | grp06_backup | `SELECT COUNT(*) FROM "vehicle"` | Allowed | Allowed | PASS |  count  -------      8 (1 row) |
| 20 | grp06_backup | `LOCK TABLE "vehicle" IN ACCESS SHARE MODE` | Allowed | Allowed | PASS | LOCK TABLE |
| 21 | grp06_backup | `DELETE FROM "vehicle" WHERE FALSE` | Denied | Denied | PASS | ERROR:  permission denied for table vehicle |
| 22 | grp06_backup | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 23 | grp06_dba | `SELECT COUNT(*) FROM "vehicle"` | Allowed | Allowed | PASS |  count  -------      8 (1 row) |
| 24 | grp06_dba | `ANALYZE "vehicle"` | Allowed | Allowed | PASS | ANALYZE |
| 25 | grp06_dba | `VACUUM "vehicle"` | Allowed | Allowed | PASS | VACUUM |
| 26 | grp06_dba | `SELECT COUNT(query) FROM pg_stat_activity` | Allowed | Allowed | PASS |  count  -------      9 (1 row) |
| 27 | grp06_dba | `DROP TABLE "vehicle"` | Denied | Denied | PASS | ERROR:  must be owner of table vehicle |
| 28 | grp06_dba | `TRUNCATE "vehicle"` | Denied | Denied | PASS | ERROR:  permission denied for table vehicle |
| 29 | grp06_dba | `CREATE DATABASE access_test_db` | Denied | Denied | PASS | ERROR:  permission denied to create database |
| 30 | grp06_dba | `CREATE ROLE access_test_role` | Denied | Denied | PASS | ERROR:  permission denied to create role DETAIL:  Only roles with the CREATEROLE attribute may create roles. |
| 31 | grp06_outsider | `Connect to database car_rental_db` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  permission denied for database "car_rental_db" DETAIL:  User does not have CONNECT priv |
| 32 | grp06_app | `Log in with a wrong password` | Denied | Denied | PASS | psql: error: connection to server at "localhost" (::1), port 55440 failed: FATAL:  password authentication failed for user "grp06_app" |
