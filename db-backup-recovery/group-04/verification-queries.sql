-- Group 04: run against grp04_restore_test and grp03_projectdb, then compare.
SET search_path TO "public";
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE' ORDER BY 1;
SELECT 'appointments' AS table_name, COUNT(*) FROM "appointments";
SELECT 'billing' AS table_name, COUNT(*) FROM "billing";
SELECT 'deleted_records' AS table_name, COUNT(*) FROM "deleted_records";
SELECT 'doctors' AS table_name, COUNT(*) FROM "doctors";
SELECT 'medical_notes' AS table_name, COUNT(*) FROM "medical_notes";
SELECT 'patient_password_resets' AS table_name, COUNT(*) FROM "patient_password_resets";
SELECT 'patients' AS table_name, COUNT(*) FROM "patients";
SELECT 'prescriptions' AS table_name, COUNT(*) FROM "prescriptions";
SELECT 'specialties' AS table_name, COUNT(*) FROM "specialties";
SELECT 'staff_password_resets' AS table_name, COUNT(*) FROM "staff_password_resets";
SELECT 'staff_users' AS table_name, COUNT(*) FROM "staff_users";
SELECT contype, COUNT(*) FROM pg_constraint WHERE connamespace = 'public'::regnamespace GROUP BY 1 ORDER BY 1;
SELECT COUNT(*) AS indexes FROM pg_indexes WHERE schemaname = 'public';
SELECT a.appointment_id, a.appointment_date, a.status, d.last_name AS doctor, s.specialty_name FROM appointments a JOIN doctors d ON d.doctor_id = a.doctor_id LEFT JOIN specialties s ON s.specialty_id = d.specialty_id WHERE a.patient_id = 1 ORDER BY a.appointment_date DESC;
