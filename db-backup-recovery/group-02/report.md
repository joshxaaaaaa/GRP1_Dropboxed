# Group 02: backup and recovery

Backup plan: Daily at 02:00; 7 daily, 4 weekly, 3 monthly; proposed RPO 24 hours, RTO 8 hours. School events change slowly and lost entries can be re-encoded from forms.

Backup: grp02_event_management_db_activity6.dump, 46768 bytes, SHA-256 fe96f3ad1bb416da2c00ef3b38027408fc173f8259837ebff9912c281c190a37, taken 2026-11-06T11:35:56. The file is not committed.

Restore: succeeded into a separate database. Row counts match: true. Indexes 27/27.

Access after restore: permitted SELECT true; denied DELETE true.

Recovery simulation on venue: before 1, after deletion 0, recovered 1.
