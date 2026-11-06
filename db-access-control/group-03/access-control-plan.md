# Group 03: PAWPAW: Veterinary Appointment and Pet Management System

Database `group3_pawpaw`, schema `public`. Setup: Success with issues. README steps fail at npm run migrate until the database name in DATABASE_URL is written in lowercase.

Application check: Ran as grp03_app. All 4 roles logged in and opened their pages. Checks passed: 1 of 1, with no permission errors from the application account.

| Login | Group | Responsibility |
|---|---|---|
| grp03_app | grp03_runtime_grp | Application runtime |
| grp03_report | grp03_readonly_grp | Read-only reports |
| grp03_dba | grp03_dba_grp | Maintenance and monitoring |
| grp03_backup | grp03_backup_grp | Backups |

Runtime privileges (S select, I insert, U update, D delete): appointment: SIU, appointment_service: SIU, audit_log: SI, medical_record: SI, notification: SIU, owner: SIU, password_reset_code: SIUD, pet: SIU, prescription: SID, service: SIU, user_account: SIU, vaccination: SIUD, veterinarian: SIU.

Full script: access-control.sql. Results: test-results.md.

## Findings for the owners

- **Database name fails as documented** (Immediate action): CREATE DATABASE group3_Pawpaw without quotes creates group3_pawpaw, but DATABASE_URL uses group3_Pawpaw. Use one lowercase name in the README and .env.example.
- **Broken README link** (Follow-up action): The roles link points to PAWPAW_App_User_Roles.md, but the file is in docs/. Change the link to docs/PAWPAW_App_User_Roles.md.
- **Date of birth shifts by a day in the API** (Follow-up action): A pet saved with 2022-01-01 came back as 2021-12-31T16:00 UTC. Return DATE columns as YYYY-MM-DD strings.
- **auth_session looks unused** (Follow-up action): The table is in schema.sql, but no server code refers to it. Remove it or document its purpose.
