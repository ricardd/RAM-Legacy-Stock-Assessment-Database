-- NMFS-tables.sql
--
-- table to associate stockid to NMFS stock name from Mike Fogarty's spreadhseet
--
-- Daniel Ricard
-- Started: 2008-05-14

-- table for the different management authorities
CREATE TABLE srdb.nmfsstock (
stockid VARCHAR(40) PRIMARY KEY,
NMFSname VARCHAR(200)
);

COPY srdb.nmfsstock
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/stocks-NMFS.dat'
CSV HEADER 
;

CREATE TABLE srdb.nmfstsmetrics (
tsunique VARCHAR(40),
NMFScategory VARCHAR(200),
NMFSunit VARCHAR(200)
);

COPY srdb.nmfstsmetrics
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/tsmetrics-NMFS.dat'
CSV HEADER 
;

CREATE TABLE srdb.nmfsbiometrics (
NMFSname VARCHAR(200),
category VARCHAR(200),
subcategory VARCHAR(200),
bioshort VARCHAR(40)
);

COPY srdb.nmfsbiometrics
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/biometrics-NMFS.dat'
CSV HEADER 
;
