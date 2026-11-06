# Group 06: log review

| Evidence | Count | Explanation | Impact | Next step |
|---|---|---|---|---|
| Permission-denied errors from grp06_app, grp06_report, grp06_backup, grp06_dba, grp06_outsider | 63 | Expected: these are the denied operations from the Activity 4 tests, repeated across test runs while scripts were corrected. | None. They show that the restrictions work. | No action. |
| ERROR: there is no unique constraint matching given keys for referenced table "staff" | 1 | schema.sql error during setup. psql continued past it. | A foreign key on payment.received_by is missing. | Immediate: reorder schema.sql. |
| ERROR: no schema has been selected to create in | 1 | schema.sql error during setup: the inspection_item table failed, then inspection_checklist.sql created it later. | Confusing for testers, but no lasting damage. | Follow-up: fix the block in schema.sql. |
| ERROR: aggregate functions are not allowed in GROUP BY | 1 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
| FATAL: password authentication failed for user "grp06_app" | 1 | Deliberate wrong-password test, so failed logins are visibly logged. | None for this test. In production, repeated failures could mean password guessing. | Keep failed-login logging on. |
