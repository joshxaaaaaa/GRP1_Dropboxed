# Group 05: backup and recovery

Backup plan: Every 4 hours; 7 daily, 4 weekly, 3 monthly; proposed RPO 4 hours, RTO 2 hours. Payments and store credit change often and must balance.

Backup: grp10_shioricafedb_activity6.dump, 98926 bytes, SHA-256 a98cc5336dc8f3efd7353478ad81d92603b4bf29b881d4b2b333f3aa8ea93b7e, taken 2026-11-06T20:05:16. The file is not committed.

Restore: succeeded into a separate database. Row counts match: true. Indexes 50/50.

Access after restore: permitted SELECT true; denied DELETE true.

Recovery simulation on category: before 1, after deletion 0, recovered 1.
