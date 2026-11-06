# Group 09: Batumbakal Gym Membership Management System

Database `grp99_gymdb`, schema `public`. Setup: Success with issues. Database scripts ran without errors, and the app ran on Java 25. The README run command has a typo.

Application check: Ran on Java 25 as grp09_app. Checks passed: 11 of 11, with no permission errors from the application account.

| Login | Group | Responsibility |
|---|---|---|
| grp09_app | grp09_runtime_grp | Application runtime |
| grp09_report | grp09_readonly_grp | Read-only reports |
| grp09_dba | grp09_dba_grp | Maintenance and monitoring |
| grp09_backup | grp09_backup_grp | Backups |

Runtime privileges (S select, I insert, U update, D delete): attendance: SIUD, class_enrollments: SIUD, classes: SIUD, membership_plans: SIUD, payments: SIUD, trainers: SIUD, members: SIU, memberships: SIU.

Full script: access-control.sql. Results: test-results.md.

## Findings for the owners

- **No login or application roles** (Immediate action): The README states there is no authentication, and the API allows any origin. Add authentication before any real use.
- **Defaults to the postgres superuser** (Immediate action): application.properties defaults DB_USERNAME to postgres. Remove the default, or use a restricted account.
- **README command typo** (Follow-up action): The README shows .\mvnw\.cmd spring-boot:run, which does not run. Change it to .\mvnw.cmd spring-boot:run.
- **Database name uses another number** (Follow-up action): The database is grp99_gymdb, but this is Group 9. Rename it, or explain why.
- **Broad sequence and table grants** (Follow-up action): docs/ROLES.md gives gym_app UPDATE on sequences and DELETE on all tables. Narrow the grants table by table.
