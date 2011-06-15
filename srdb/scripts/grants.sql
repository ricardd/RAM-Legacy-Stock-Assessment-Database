-- create the statements required to GRANT SELECT to all tables in srDB to user srdbuser
-- Time-stamp: <2011-06-13 10:50:39 (srdbadmin)>
-- this script is meant to be fed back to the database

SELECT 'GRANT SELECT ON ' || schemaname || '.' || tablename ||
' TO srdbuser ;'
FROM pg_tables
WHERE tableowner = CURRENT_USER;

SELECT 'GRANT SELECT ON ' || schemaname || '.' || viewname ||
' TO srdbuser ;'
FROM pg_views
WHERE viewowner = CURRENT_USER;


--SELECT 'GRANT SELECT ON ' || schemaname || '.' || tablename ||
--' TO srdbrecovery ;'
--FROM pg_tables
--WHERE tableowner = CURRENT_USER;


--SELECT 'GRANT SELECT ON ' || schemaname || '.' || viewname ||
--' TO srdbrecovery ;'
--FROM pg_views
--WHERE viewowner = CURRENT_USER;
