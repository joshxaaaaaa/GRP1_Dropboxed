# Group 10: backup and recovery

Backup plan: Daily at 02:00; 7 daily, 4 weekly, 3 monthly; proposed RPO 24 hours, RTO 8 hours. Events are planned ahead, and a day of registrations can be re-entered.

Backup: grp10_unisyncdb_activity6.dump, 66673 bytes, SHA-256 c04a9300955090730c2a62fc3450c4c6a218992e8a408f108459c1159a7b120b, taken 2026-11-06T20:05:42. The file is not committed.

Restore: succeeded into a separate database. Row counts match: true. Indexes 21/21.

Access after restore: permitted SELECT true; denied DELETE true.

Recovery simulation on venue: before 1, after deletion 0, recovered 1.
