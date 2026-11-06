# Group 11: ReserveIT: Classroom and Material Reservation System

Database `ReserveIT`, schema `public`. Setup: Success. README steps worked as written, using manage.py setup-roles, init-db and seed.

Application check: Ran the group's own smoke_test.py as grp11_app: all 67 checks passed.

| Login | Group | Responsibility |
|---|---|---|
| grp11_app | grp11_runtime_grp | Application runtime |
| grp11_report | grp11_readonly_grp | Read-only reports |
| grp11_dba | grp11_dba_grp | Maintenance and monitoring |
| grp11_backup | grp11_backup_grp | Backups |

Runtime privileges (S select, I insert, U update, D delete): department: SI, app_user: SIU, staff: SIU, room: SIUD, material: SIUD, reservation: SIU, reservation_material: SI, penalty: SIU.

Full script: access-control.sql. Results: test-results.md.

## Findings for the owners

- **Generic group role names** (Follow-up action): roles_setup.sql creates app_runtime_grp, the same name Groups 4, 6 and 8 document or use. Prefix roles with reserveit_.
- **Restore needs the database owner** (Follow-up action): The database is owned by reserveit_owner. A restore into a database owned by postgres broke foreign-key checks ("permission denied for schema public") until it was created with -O reserveit_owner. Document createdb -O reserveit_owner in the recovery steps.
