-- load-rfmos.sql
-- Daniel Ricard
-- Started: 2008-01-06

COPY srdb.taxonomy
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/taxonomy.dat'
CSV HEADER 
;
