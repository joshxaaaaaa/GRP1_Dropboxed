# Group 07: log review

| Evidence | Count | Explanation | Impact | Next step |
|---|---|---|---|---|
| Permission-denied errors from grp07_app, grp07_report, grp07_backup, grp07_dba, grp07_outsider | 60 | Expected: these are the denied operations from the Activity 4 tests, repeated across test runs while scripts were corrected. | None. They show that the restrictions work. | No action. |
| ERROR: aggregate functions are not allowed in GROUP BY | 1 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
| FATAL: password authentication failed for user "grp07_app" | 1 | Deliberate wrong-password test, so failed logins are visibly logged. | None for this test. In production, repeated failures could mean password guessing. | Keep failed-login logging on. |
