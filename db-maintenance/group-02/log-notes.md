# Group 02: log review

| Evidence | Count | Explanation | Impact | Next step |
|---|---|---|---|---|
| Permission-denied errors from grp02_app, grp02_report, grp02_backup, grp02_dba, grp02_outsider | 84 | Expected: these are the denied operations from the Activity 4 tests, repeated across test runs while scripts were corrected. | None. They show that the restrictions work. | No action. |
| ERROR: permission denied for schema public | 1 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
| ERROR: relation "role" does not exist | 1 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
| ERROR: schema "school_event_management_db" does not exist | 1 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
| ERROR: aggregate functions are not allowed in GROUP BY | 1 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
| FATAL: password authentication failed for user "grp02_app" | 2 | Deliberate wrong-password test, so failed logins are visibly logged. | None for this test. In production, repeated failures could mean password guessing. | Keep failed-login logging on. |
| ERROR: column "is_active" does not exist | 1 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
