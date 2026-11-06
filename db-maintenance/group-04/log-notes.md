# Group 04: log review

| Evidence | Count | Explanation | Impact | Next step |
|---|---|---|---|---|
| Permission-denied errors from grp04_app, grp04_report, grp04_backup, grp04_dba, grp04_outsider | 20 | Expected: these are the denied operations from the Activity 4 tests, repeated across test runs while scripts were corrected. | None. They show that the restrictions work. | No action. |
| FATAL: password authentication failed for user "grp04_app" | 1 | Deliberate wrong-password test, so failed logins are visibly logged. | None for this test. In production, repeated failures could mean password guessing. | Keep failed-login logging on. |
| ERROR: duplicate key value violates unique constraint "appointments_doctor_slot" | 2 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
| ERROR: duplicate key value violates unique constraint "one_note_per_visit" | 3 | Tester's script saved the same visit twice while being corrected. The constraint correctly refused it. | None. | No action. |
| ERROR: current transaction is aborted, commands ignored until end of transaction block | 3 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
