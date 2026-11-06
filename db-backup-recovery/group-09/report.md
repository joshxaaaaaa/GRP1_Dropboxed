# Group 09: backup and recovery

Backup plan: Daily at 02:00; 7 daily, 4 weekly, 3 monthly; proposed RPO 24 hours, RTO 4 hours. Payments matter, but daily volume is small.

Backup: grp99_gymdb_activity6.dump, 32908 bytes, SHA-256 0ad5e41f3a12a85acb85b6f3f0d869b4ae3602c70e0b109277b5770395462600, taken 2026-11-06T10:59:02. The file is not committed.

Restore: succeeded into a separate database. Row counts match: true. Indexes 11/11.

Access after restore: permitted SELECT true; denied DELETE true.

Recovery simulation on membership_plans: before 1, after deletion 0, recovered 1.
