# Group 08: Catering Management System

Database `catering_management_db`, schema `public`. Setup: Success with issues. schema.sql and seed.sql ran with no errors, and create-admin.js worked. Tested at commit 95aa601. The later commit 4626dc1 changed only the README clone link, so the results still apply. The session table had to be created before the restricted account could log in.

Application check: Ran as grp08_app on Node.js. Administrator and Customer flows worked, including reservation, confirmation, payment, verification and cancellation. A second customer could not see the first customer's reservation. Checks passed: 30 of 30, with no permission errors from the application account.

| Login | Group | Responsibility |
|---|---|---|
| grp08_app | grp08_runtime_grp | Application runtime |
| grp08_report | grp08_readonly_grp | Read-only reports |
| grp08_dba | grp08_dba_grp | Maintenance and monitoring |
| grp08_backup | grp08_backup_grp | Backups |

Runtime privileges (S select, I insert, U update, D delete): admin: S, cancellation: SIUD, customer: SIUD, employee: SIUD, event_assignment: SIUD, inventory: SIUD, menu_item: SIUD, package: SIUD, payment: SIUD, reservation: SIUD, reservation_menu: SIUD, session: SIUD.

Full script: access-control.sql. Results: test-results.md.

## Findings for the owners

- **Restricted account cannot create the session table** (Immediate action): The server uses createTableIfMissing, which needs CREATE on the schema. Tested as grp08_app with no table: admin login returned 500, relation "session" does not exist. Add the session table to schema.sql, and turn off createTableIfMissing.
- **Examples point at the postgres superuser** (Immediate action): backend/.env.example sets DB_USER=postgres. Use a restricted login in the example.
- **Documents disagree on roles** (Follow-up action): docs/roles-and-privileges.md names catering_admin and others, while roles.sql creates app_admin_grp and others, and calls full DML on every table "only the DML the code performs". Keep one design, narrow the grants, and prefix the names.
- **README contradicts the code on login** (Follow-up action): The README says the staff dashboard has no authentication, but the code requires an admin session. Tested: 401 with no login. Update the Security and Limitations section.
- **Staff role has no login** (Follow-up action): Documents list Customer, Staff and Administrator, but only customer and admin logins exist. Add Staff login, or remove the role from the documents.
- **create-admin.js needs more than the runtime account** (Follow-up action): It inserts into admin, which the application itself only reads. It worked with an administrative login. State in the README which account runs it.
