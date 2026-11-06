SELECT current_user AS account, current_database() AS database, version();
SELECT pg_size_pretty(pg_database_size(current_database())) AS database_size;
SELECT CASE c.relkind WHEN 'r' THEN 'table' WHEN 'i' THEN 'index' WHEN 'S' THEN 'sequence' WHEN 'v' THEN 'view' END AS object_type, COUNT(*) FROM pg_class c WHERE c.relnamespace = 'public'::regnamespace AND c.relkind IN ('r','i','S','v') GROUP BY 1 ORDER BY 1;
SELECT datname, numbackends, xact_commit, xact_rollback, deadlocks FROM pg_stat_database WHERE datname = current_database();
SELECT pid, usename, state, wait_event_type, wait_event, query_start, left(query, 60) AS query FROM pg_stat_activity WHERE datname = current_database() ORDER BY query_start NULLS LAST;
SELECT pid, usename, now() - query_start AS duration, left(query, 60) AS query FROM pg_stat_activity WHERE datname = current_database() AND state = 'active' AND now() - query_start > interval '5 seconds';
SELECT r.rolname, r.rolcanlogin, r.rolsuper, r.rolcreatedb, r.rolcreaterole, (SELECT string_agg(g.rolname, ', ') FROM pg_auth_members m JOIN pg_roles g ON g.oid = m.roleid WHERE m.member = r.oid) AS member_of FROM pg_roles r WHERE r.rolname LIKE 'grp11\_%' ORDER BY r.rolname;
SELECT relname, n_live_tup, n_dead_tup, n_mod_since_analyze, last_vacuum, last_autovacuum, last_analyze, last_autoanalyze FROM pg_stat_user_tables WHERE schemaname = 'public' ORDER BY n_dead_tup DESC, relname;
SELECT relname AS table_name, indexrelname AS index_name, idx_scan, pg_size_pretty(pg_relation_size(indexrelid)) AS size FROM pg_stat_user_indexes WHERE schemaname = 'public' ORDER BY relname, indexrelname;
