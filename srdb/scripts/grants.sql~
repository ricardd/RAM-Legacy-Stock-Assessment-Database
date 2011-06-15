-- create the statements required to GRANT SELECT to all tables in srDB to user srdbuser
-- Time-stamp: <2008-11-19 14:23:43 (ricardd)>
-- this script is meant to be fed back to the database

SELECT 'GRANT SELECT ON ' || schemaname || '.' || tablename ||
' TO srdbuser ;'
FROM pg_tables
WHERE tableowner = CURRENT_USER;

SELECT 'GRANT SELECT ON ' || schemaname || '.' || viewname ||
' TO srdbuser ;'
FROM pg_views
WHERE viewowner = CURRENT_USER;


SELECT 'GRANT SELECT ON ' || schemaname || '.' || tablename ||
' TO srdbrecovery ;'
FROM pg_tables
WHERE tableowner = CURRENT_USER;


SELECT 'GRANT SELECT ON ' || schemaname || '.' || viewname ||
' TO srdbrecovery ;'
FROM pg_views
WHERE viewowner = CURRENT_USER;
