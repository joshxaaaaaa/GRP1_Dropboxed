# Group 04: HealthBridge Clinic Management System (HBCMS)

Database `grp03_projectdb`, schema `public`. Setup: Success with issues. All 8 scripts ran in the README order with no errors. The project calls itself Group 03. Tested at commit 22206bf. The later commits up to 2e5abb5 changed only docs/ and .env.example, so the results still apply.

Application check: Ran as grp04_app on PHP 8.0.30. The full README path worked: patient booked, staff assigned, doctor saved a visit, bill paid, record deleted and restored from Backup. Doctor and staff were refused on pages outside their role. Checks passed: 22 of 22, with no permission errors from the application account.

| Login | Group | Responsibility |
|---|---|---|
| grp04_app | grp04_runtime_grp | Application runtime |
| grp04_report | grp04_readonly_grp | Read-only reports |
| grp04_dba | grp04_dba_grp | Maintenance and monitoring |
| grp04_backup | grp04_backup_grp | Backups |

Runtime privileges (S select, I insert, U update, D delete): appointments: SIUD, billing: SIUD, deleted_records: SIUD, doctors: S, medical_notes: SID, patients: SIUD, prescriptions: SID, specialties: S, staff_users: SU, staff_password_resets: SIU, patient_password_resets: SIU.

Full script: access-control.sql. Results: test-results.md.

## Findings for the owners

- **Reset codes are shown on screen by default** (Follow-up action): config.sample.php sets demo_mode to true. Tested: the password-reset response returns demo_code to the browser. Default demo_mode to false, and warn about it in the README.
- **Group number does not match the tracker** (Follow-up action): The tracker lists G04, but the README says Group 03, and the repository, folder and database use GRP03 and grp03. Rename them, or explain the difference in the README.
- **No read-only or backup role, and CONNECT stays open** (Follow-up action): roles.sql has no reporting or backup account and does not revoke the default CONNECT from PUBLIC. It also fails on a second run, because CREATE ROLE has no existence check. Add those roles, revoke PUBLIC access, and make the script re-runnable.
- **Default password placeholder** (Follow-up action): roles.sql sets hb_app to CHANGE_ME if the tester forgets the replacement step. Have psql supply the password as a variable.
