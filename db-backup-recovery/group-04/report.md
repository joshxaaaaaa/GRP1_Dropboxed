# Group 04: backup and recovery

Backup plan: Every 6 hours; 7 daily, 4 weekly, 3 monthly; proposed RPO 6 hours, RTO 4 hours. Medical notes and prescriptions are hard to recreate, and bills must stay accurate.

Backup: grp03_projectdb_activity6.dump, 57610 bytes, SHA-256 db7689daa0eef38cca1e94bd0a3c4e5bf84e3cd31131562ed8e6faa6970bd23f, taken 2026-11-06T20:05:02. The file is not committed.

Restore: succeeded into a separate database. Row counts match: true. Indexes 22/22.

Access after restore: permitted SELECT true; denied DELETE true.

Recovery simulation on specialties: before 1, after deletion 0, recovered 1.
