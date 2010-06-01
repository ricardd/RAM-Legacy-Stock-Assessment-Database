-- load-tsmetrics.sql

COPY srDB.tsmetrics
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/tsmetrics.dat'
CSV HEADER
;
