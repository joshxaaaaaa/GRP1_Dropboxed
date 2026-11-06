# Group 05: log review

| Evidence | Count | Explanation | Impact | Next step |
|---|---|---|---|---|
| Permission-denied errors from grp05_app, grp05_report, grp05_backup, grp05_dba, grp05_outsider | 113 | Mostly expected: the denied operations from the Activity 4 tests. Some are contact.php trying to create a table, and some are from the first test at commit 4060a8a. | The contact form fails until the code stops creating a table. | Immediate: move the table to a migration. |
| ERROR: aggregate functions are not allowed in GROUP BY | 2 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
| FATAL: password authentication failed for user "grp05_app" | 3 | Deliberate wrong-password test, so failed logins are visibly logged. | None for this test. In production, repeated failures could mean password guessing. | Keep failed-login logging on. |
| ERROR: column "table_name" does not exist | 1 | Came from the tester's own inspection or a corrected test script, not from the application. | None. | No action. |
| ERROR: relation "orders" does not exist | 2 | From the first test, at commit 4060a8a. The newest commit no longer uses this table name. | None now. | No action. |
| ERROR: new row for relation "reservation" violates check constraint "ck_reservation_online_complete" | 4 | create-reservation.php leaves out required_minimum_amount, so the check constraint rejects every online reservation. | Customers cannot reserve. | Immediate: fix the INSERT. |
| ERROR: column "customer_id" of relation "order" does not exist | 2 | create-order.php uses a column that the order table does not have. | Customers cannot order. | Immediate: align the code and migrations. |
