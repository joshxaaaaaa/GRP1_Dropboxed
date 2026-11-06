# Group 06: backup and recovery

Backup plan: Every 6 hours; 7 daily, 4 weekly, 3 monthly; proposed RPO 6 hours, RTO 4 hours. Rentals and payments are financial records.

Backup: car_rental_db_activity6.dump, 84125 bytes, SHA-256 d910e9d662b82bfb028346ed6b0af01305dc73b9161da3ce0a9fcc0d04a19cf7, taken 2026-11-06T10:58:47. The file is not committed.

Restore: succeeded into a separate database. Row counts match: true. Indexes 38/38.

Access after restore: permitted SELECT true; denied DELETE true.

Recovery simulation on vehicle_category: before 1, after deletion 0, recovered 1.
