-- load-stockareas.sql
-- Daniel Ricard
-- Started: 2007-12-20

COPY srdb.stockarea
FROM '/home/ricardd/linux_sync_folder/SQL/SQLpg/srDB/srDB/data/stockareas.dat'
CSV HEADER 
;
