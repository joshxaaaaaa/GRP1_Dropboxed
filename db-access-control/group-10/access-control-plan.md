# Group 10: UniSync: A University Event Scheduling and Registration System

Database `grp10_unisyncdb`, schema `public`. Setup: Success. db/init.sql and db/seed.sql ran with no errors, and the README steps worked as written. Run on PHP 8.0.30 from XAMPP (the README asks for 8.1 or newer); all PHP files passed a syntax check.

Application check: Ran as grp10_app on PHP 8.0.30. Registration, login, organizations, joining, publishing an event, registering, cancelling, role changes, removing members, and soft deletes all worked. A plain member was refused when changing roles. Image upload and editing an event were not tested. Checks passed: 29 of 29, with no permission errors from the application account.

| Login | Group | Responsibility |
|---|---|---|
| grp10_app | grp10_runtime_grp | Application runtime |
| grp10_report | grp10_readonly_grp | Read-only reports |
| grp10_dba | grp10_dba_grp | Maintenance and monitoring |
| grp10_backup | grp10_backup_grp | Backups |

Runtime privileges (S select, I insert, U update, D delete): account: SIU, event: SIU, event_schedule: SIU, membership: SIU, notification: I, organization: SIU, registration: SIUD, venue: SI.

Full script: access-control.sql. Results: test-results.md.

## Findings for the owners

- **Documented runtime role would break a feature** (Immediate action): docs/database-roles.md gives the runtime no DELETE and says rows are never removed, but cancel_registration.php runs DELETE FROM registration. Change the code to a soft delete, or grant DELETE on registration only.
- **Examples point at the postgres superuser** (Immediate action): .env.example and php/db.php default to DB_USER=postgres, and the README says this is fine for testing. Use unisync_app in the example, and ship a role script.
- **No role script in the repository** (Follow-up action): The roles appear only as SQL inside docs/database-roles.md, marked as intended. Add db/roles.sql.
- **Connection errors are shown to the user** (Follow-up action): php/db.php prints the PDO error message when the connection fails. Log the detail, and show a general message.
- **README details out of date** (Follow-up action): It mentions db/migrate_student_to_account.sql, which is not in the repository, and says NOTIFICATION is unused, although create_event.php inserts into it. Update the README and docs/database.md.
