# Group 05: SHIORIcafe

Database `grp10_shioricafedb`, schema `shioricafe_schema`. Setup: Success with issues. Rebuilt at the newest commit. Migrations 001 to 005 and seed.sql ran cleanly. Copying .env.example as documented still stops the app, so a shorter .env was used. Run on PHP 8.0.30 from XAMPP (the README asks for 8.2+); all PHP files passed a syntax check.

Application check: Ran as grp05_app on PHP 8.0.30. Guest pages, customer sign-up and login, and the Manager dashboard, orders, reservations, inquiries and audit pages worked. Reservations, orders, the contact form and the Cashier and POS pages failed. See the findings: only the contact form failure is related to permissions, and it comes from table creation in the code. Checks passed: 17 of 26. The failed checks are listed in the findings.

| Login | Group | Responsibility |
|---|---|---|
| grp05_app | grp05_runtime_grp | Application runtime |
| grp05_report | grp05_readonly_grp | Read-only reports |
| grp05_dba | grp05_dba_grp | Maintenance and monitoring |
| grp05_backup | grp05_backup_grp | Backups |

Runtime privileges (S select, I insert, U update, D delete): category: S, customer: SI, inquiry: SIUD, menu_item: S, order: SIU, order_item: SI, reservation: SIU, staff: SI, table: S.

Full script: access-control.sql. Results: test-results.md.

## Findings for the owners

- **Customers cannot create a reservation** (Immediate action): create-reservation.php leaves out required_minimum_amount. Tested: ERROR new row violates check constraint "ck_reservation_online_complete". Save required_minimum_amount in the INSERT.
- **Customers cannot place an order** (Immediate action): create-order.php inserts customer_id, but the "order" table has no such column. Tested: ERROR column "customer_id" of relation "order" does not exist. Align create-order.php with the migrations, or add the column in a migration.
- **Cashier role cannot log in** (Immediate action): login.php accepts customers only, and admin/login.php answers "Access denied. Manager credentials required." No page creates Cashier accounts, although the README says the Manager can. Add Cashier login and account creation.
- **Manager is sent away from POS and Cashier pages** (Immediate action): These pages call require_role(['admin', 'cashier']), but the role is stored as Manager. Tested: redirect to admin/index.php?error=unauthorized. Add manager to the allowed roles.
- **contact.php creates a table while running** (Immediate action): It runs CREATE TABLE IF NOT EXISTS on each message. Tested as grp05_app: ERROR permission denied for schema shioricafe_schema, even when the table already exists. Move the inquiry table to a migration and remove the CREATE TABLE from the page.
- **.env.example cannot be used as written** (Immediate action): Line 9 has a comment with parentheses, which parse_ini_file rejects. Tested: "Unable to read .env file". Remove the # comments, or read .env another way.
- **README contradicts the code** (Follow-up action): The README still says the app uses MySQLi and XAMPP MySQL, but backend/config/db.php uses PDO for PostgreSQL. Update the README.
- **Fixed /SHIORIcafe/ redirect path** (Follow-up action): Redirects and menu links go to /SHIORIcafe/..., whatever the folder or server. Use relative paths or APP_URL.
- **Database name uses another group number** (Follow-up action): The database is grp10_shioricafedb, but this is Group 5. Group 10 is a different project. Rename it, or explain why in the README.
- **No staff account after seed.sql** (Follow-up action): The staff table is empty until backend/database/create-manager.php is run. That script worked. Document this step in the setup section.
