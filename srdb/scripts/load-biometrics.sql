-- load-biometrics.sql

COPY srDB.biometrics
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/biometrics.dat'
CSV HEADER
;
