# Group 03: log review

| Evidence | Count | Explanation | Impact | Next step |
|---|---|---|---|---|
| Permission-denied errors from grp03_app, grp03_report, grp03_backup, grp03_dba, grp03_outsider | 63 | Expected: these are the denied operations from the Activity 4 tests, repeated across test runs while scripts were corrected. | None. They show that the restrictions work. | No action. |
| FATAL: database "group3_Pawpaw" does not exist | 1 | Setup followed the README: the URL uses mixed case, but the database name was folded to lowercase. | New testers cannot run the migration. | Immediate: fix the name in the README. |
| ERROR: aggregate functions are not allowed in GROUP BY | 1 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
| FATAL: password authentication failed for user "grp03_app" | 1 | Deliberate wrong-password test, so failed logins are visibly logged. | None for this test. In production, repeated failures could mean password guessing. | Keep failed-login logging on. |
| ERROR: column "status" does not exist | 1 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
