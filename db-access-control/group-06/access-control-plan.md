# Group 06: Car Rental Management System

Database `car_rental_db`, schema `public`. Setup: Success with issues. schema.sql reported 2 errors. The later migration recreated inspection_item, but payment_received_by_fkey stayed missing.

Application check: Ran as grp06_app on Java 17, as the README requires. Checks passed: 5 of 5, with no permission errors from the application account.

| Login | Group | Responsibility |
|---|---|---|
| grp06_app | grp06_runtime_grp | Application runtime |
| grp06_report | grp06_readonly_grp | Read-only reports |
| grp06_dba | grp06_dba_grp | Maintenance and monitoring |
| grp06_backup | grp06_backup_grp | Backups |

Runtime privileges (S select, I insert, U update, D delete): audit_log: SI, cancellation: SIU, customer: SIU, damage_fee: SIU, damage_incident: SIU, driver_license: SIU, inspection_item: SI, inspection_photo: SI, payment: SIU, rental: SIU, rental_rate: SIU, rental_terms: SI, staff: SIU, vehicle: SIUD, vehicle_category: SI, vehicle_inspection: SIU, vehicle_maintenance: SIU.

Full script: access-control.sql. Results: test-results.md.

## Findings for the owners

- **Foreign key missing after setup** (Immediate action): schema.sql line 859 adds payment_received_by_fkey before staff has its primary key, so it fails. psql continues without stopping. Reorder schema.sql, and run it with ON_ERROR_STOP.
- **Script error on inspection_item** (Follow-up action): schema.sql line 1240 runs with an empty search_path, so CREATE TABLE fails. inspection_checklist.sql recreates it later. Remove the block or qualify it with public.
- **Generic role names** (Follow-up action): db_roles_and_grants.sql creates app_runtime_grp, the same name Groups 4, 8 and 11 document or use. Prefix roles with the project name.
