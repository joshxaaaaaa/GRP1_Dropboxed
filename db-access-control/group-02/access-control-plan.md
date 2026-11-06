# Group 02: Eventer: A High School Event Management System (HSEMS)

Database `grp02_event_management_db`, schema `school_event_management_db`. Setup: Success with issues. Database and roles created from docs/database-setup.sql. The backend then ran Flyway V1 to V3 on Java 25 as event_owner, as documented, and created the first accounts. Other tables start empty.

Application check: Ran on Java 25 as grp02_app, with Flyway as event_owner. Checks passed: 8 of 8, with no permission errors from the application account.

| Login | Group | Responsibility |
|---|---|---|
| grp02_app | grp02_runtime_grp | Application runtime |
| grp02_report | grp02_readonly_grp | Read-only reports |
| grp02_dba | grp02_dba_grp | Maintenance and monitoring |
| grp02_backup | grp02_backup_grp | Backups |

Runtime privileges (S select, I insert, U update, D delete): role: S, user_account: SIU, venue: SIUD, participant: SIUD, event: SIUD, event_schedule: SIUD, event_assignment: SIUD, attendance: SIUD, audit_log: SI.

Full script: access-control.sql. Results: test-results.md.

## Findings for the owners

- **No SQL sample data** (Follow-up action): V2 seeds only the 2 roles. Accounts come from the Spring bootstrap, and other tables start empty. Add a dev-only seed script.
- **event_app has no explicit CONNECT** (Follow-up action): V3 grants schema and table privileges but relies on PUBLIC for CONNECT. Add GRANT CONNECT to V3 or setup.
