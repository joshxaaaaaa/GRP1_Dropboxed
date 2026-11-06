# Group 11: log review

| Evidence | Count | Explanation | Impact | Next step |
|---|---|---|---|---|
| Permission-denied errors from grp11_app, grp11_report, grp11_backup, grp11_dba, grp11_outsider | 57 | Expected: these are the denied operations from the Activity 4 tests, repeated across test runs while scripts were corrected. | None. They show that the restrictions work. | No action. |
| ERROR: aggregate functions are not allowed in GROUP BY | 1 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
| ERROR: permission denied for schema public | 4 | Tester's first restore used the wrong database owner. Not a fault in normal use. | Recovery fails unless the owner matches. | Document createdb -O reserveit_owner. |
| FATAL: password authentication failed for user "grp11_app" | 1 | Deliberate wrong-password test, so failed logins are visibly logged. | None for this test. In production, repeated failures could mean password guessing. | Keep failed-login logging on. |
| ERROR: duplicate key value violates unique constraint "app_user_email_key" | 1 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
| ERROR: conflicting key value violates exclusion constraint "no_overlapping_approved_reservations" | 1 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
| ERROR: duplicate key value violates unique constraint "penalty_reservation_id_key" | 1 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
| ERROR: update or delete on table "room" violates foreign key constraint "reservation_room_id_fkey" on  | 1 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
