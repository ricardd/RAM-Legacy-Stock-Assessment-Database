-- RAM-tables.sql
--
-- table to associate RAM's units to those defined in srDB
--
-- Daniel Ricard
-- Started: 2008-10-15

CREATE TABLE srdb.ramunits (
ramcat VARCHAR(40),
ramunits VARCHAR(100),
tsunitsshort VARCHAR(40) REFERENCES srdb.tsmetrics
);

COPY srdb.ramunits
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/ramunits.dat'
CSV HEADER 
;
