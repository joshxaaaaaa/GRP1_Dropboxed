# Group 08: backup and recovery

Backup plan: Every 12 hours; 7 daily, 4 weekly, 3 monthly; proposed RPO 12 hours, RTO 8 hours. Reservations and payments matter, but changes are few each day and can be re-entered from records.

Backup: catering_management_db_activity6.dump, 37233 bytes, SHA-256 b795320cf4fedf2fff7bea0bae0657d53b783f366bf9af3a732c1ed64f1b3dd1, taken 2026-11-06T20:05:30. The file is not committed.

Restore: succeeded into a separate database. Row counts match: true. Indexes 16/16.

Access after restore: permitted SELECT true; denied DELETE true.

Recovery simulation on package: before 1, after deletion 0, recovered 1.
