# Group 08: log review

| Evidence | Count | Explanation | Impact | Next step |
|---|---|---|---|---|
| Permission-denied errors from grp08_app, grp08_report, grp08_backup, grp08_dba, grp08_outsider | 20 | Expected: these are the denied operations from the Activity 4 tests, repeated across test runs while scripts were corrected. | None. They show that the restrictions work. | No action. |
| FATAL: password authentication failed for user "grp08_app" | 1 | Deliberate wrong-password test, so failed logins are visibly logged. | None for this test. In production, repeated failures could mean password guessing. | Keep failed-login logging on. |
| ERROR: relation "session" does not exist | 2 | Deliberate test: the session table was hidden to see what a restricted account does on first run. | Admin login fails until the table exists. | Immediate: add the table to schema.sql. |
