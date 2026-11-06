# Group 03: backup and recovery

Backup plan: Every 6 hours; 7 daily, 4 weekly, 3 monthly; proposed RPO 6 hours, RTO 4 hours. Medical and vaccination records are hard to recreate.

Backup: group3_pawpaw_activity6.dump, 54593 bytes, SHA-256 24978cbcfe5896d33afc15c6ae20af304e8eabae1e50d0dbd875dc8ca69601fa, taken 2026-11-06T10:58:31. The file is not committed.

Restore: succeeded into a separate database. Row counts match: true. Indexes 23/23.

Access after restore: permitted SELECT true; denied DELETE true.

Recovery simulation on service: before 1, after deletion 0, recovered 1.
