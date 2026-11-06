# Group 11: backup and recovery

Backup plan: Daily at 02:00; 7 daily, 4 weekly, 3 monthly; proposed RPO 24 hours, RTO 4 hours. Reservations are near-term, and a day of requests can be re-filed.

Backup: reserveit_activity6.dump, 45642 bytes, SHA-256 235ecb44acb295b37a85326304412b0b68ef2a31cd3ea767e23898250522f7ff, taken 2026-11-06T10:59:09. The file is not committed.

Restore: succeeded into a separate database. Row counts match: true. Indexes 19/19.

Access after restore: permitted SELECT true; denied DELETE true.

Recovery simulation on department: before 1, after deletion 0, recovered 1.
