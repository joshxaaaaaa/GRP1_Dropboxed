-- Group 05: routine maintenance. Run as grp05_dba. VACUUM runs outside a transaction; VACUUM FULL is not used.
SET search_path TO "shioricafe_schema";
ANALYZE VERBOSE "category", "customer", "inquiry", "menu_item", "order", "order_discount", "order_discount_allocation", "order_item", "payment_attempt", "payment_refund", "payment_refund_item_allocation", "payment_reversal", "payment_transaction", "provider_event", "reservation", "staff", "store_credit_ledger", "table";
VACUUM (VERBOSE, ANALYZE) "menu_item";
SELECT relname, n_live_tup, n_dead_tup, last_vacuum, last_analyze FROM pg_stat_user_tables WHERE schemaname = 'shioricafe_schema' AND relname = 'menu_item';
