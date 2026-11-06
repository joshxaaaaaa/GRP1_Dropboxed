# Group 07: backup and recovery

Backup plan: Daily at 02:00; 7 daily, 4 weekly, 3 monthly; proposed RPO 24 hours, RTO 8 hours. Recruitment data changes slowly.

Backup: grp07_applicantdb_activity6.dump, 43598 bytes, SHA-256 afca72d56d45b70abaa7d6501c25c6cba23537e2cd18b14e5adc63fbd45b3f91, taken 2026-11-06T10:58:55. The file is not committed.

Restore: succeeded into a separate database. Row counts match: true. Indexes 22/22.

Access after restore: permitted SELECT true; denied DELETE true.

Recovery simulation on department: before 1, after deletion 0, recovered 1.
