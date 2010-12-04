-- load-assessors.sql
-- Daniel Ricard
-- Started: 2007-12-20

COPY srdb.assessor
--FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/assessors.dat'
FROM '/home/srdbadmin/srdb/srdb/data/assessor-fromdb.dat'
CSV HEADER 
;
