-- load-rfmos.sql
-- Daniel Ricard
-- Started: 2007-12-20

COPY srdb.rfmo
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/rfmo.dat'
CSV HEADER 
;
