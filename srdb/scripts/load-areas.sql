-- load-areas.sql
-- Daniel Ricard
-- Started: 2007-12-20

COPY srdb.area
--FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/areas.dat'
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/area-fromdb.dat'
CSV HEADER 
;
