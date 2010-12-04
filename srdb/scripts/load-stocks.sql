-- load-rfmos.sql
-- Daniel Ricard
-- Started: 2008-01-30

COPY srdb.stock
--FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/stocks.dat'
--FROM '/home/srdbadmin/srdb/srdb/data/stocks-updated.dat'
FROM '/home/srdbadmin/srdb/srdb/data/stock-fromdb.dat'
NULL AS 'NA'
CSV HEADER 
;
