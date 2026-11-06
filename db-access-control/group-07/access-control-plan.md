# Group 07: Applicant Management System (AMS)

Database `grp07_applicantdb`, schema `public`. Setup: Success. db/01_schema.sql and db/02_seed.sql ran without errors, and the app ran on PHP 8.0.30 from XAMPP, as the README describes.

Application check: Ran as grp07_app on PHP 8.0.30 at the newest commit. All 3 roles logged in, Staff scheduled an interview using the code changed in that commit, and a Viewer was refused when creating a record. The 60-page crawl was done on the commit before it, which changed only the interview pages and the README. Checks passed: 9 of 9, with no permission errors from the application account.

| Login | Group | Responsibility |
|---|---|---|
| grp07_app | grp07_runtime_grp | Application runtime |
| grp07_report | grp07_readonly_grp | Read-only reports |
| grp07_dba | grp07_dba_grp | Maintenance and monitoring |
| grp07_backup | grp07_backup_grp | Backups |

Runtime privileges (S select, I insert, U update, D delete): applicant: SIUD, applicant_requirement: SIUD, application: SIUD, application_status: S, department: SIUD, interview: SIUD, position: SIUD, requirement: SIUD, users: SU.

Full script: access-control.sql. Results: test-results.md.

## Findings for the owners

- **README connects as postgres** (Immediate action): The README sets DB_USER=postgres in .env. Point the README at a restricted login.
- **No role scripts in the repository** (Follow-up action): docs/user-roles.md names intended roles, but no SQL creates them. Add a role and grant script.
