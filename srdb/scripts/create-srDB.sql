-- create-srDB.sql
--
-- postgreSQL implementation of stock-recruitment database
-- create tables and load data required by foreign keys
--
-- Daniel Ricard
-- Started: 2007-12-19
-- Last modified: Time-stamp: <2010-07-13 14:39:59 (srdbadmin)>
--
-- Modification history:
-- 2007-12-20: finalising the table definitions
-- 2008-01-30: final tweaks so that spreadsheet data can be added
-- 2008-02-08: added foreign keys
-- 2008-02-11: changed table name from "rfmo" to "management"
-- 2008-02-13: stock table modified to accept more than one area
-- 2008-07-16: postgresql version 8.2.9 changed its handling of ALTER TABLE, and I had to create the PRIMARY KEY after loading data, not before (other gives an error that the primary key has null values)
-- 2008-11-27: adding tables for RIS fields/ citation data
-- 2009-03-02: adding tables for LMEs
-- 2009-03-10: adding table for recorders

-- create a separate schema for this database
CREATE SCHEMA srdb;
-- create a separate schema for the recovery work
CREATE SCHEMA srdbrecovery;


-- table for the different management authorities
CREATE TABLE srdb.management (
mgmt VARCHAR(40) PRIMARY KEY,
country VARCHAR(50),
managementauthority VARCHAR(200)
);

COPY srdb.management
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/mgmt.dat'
-- FROM './data/mgmt.dat'
CSV HEADER 
;


-- table for the different geographic areas
CREATE TABLE srdb.area (
country VARCHAR(50),
areatype VARCHAR(40) REFERENCES srdb.management,
areacode VARCHAR(50),
areaname VARCHAR(100),
alternateareaname VARCHAR(50)
);
-- add a centroid point to the table
--SELECT AddGeometryColumn(
--           'srdb', 'area', 'the_centroid', 4326, 'POINT'
--            );
-- add a polygon to the table
--SELECT AddGeometryColumn(
--           'srdb', 'area', 'the_geom', 4326, 'POLYGON',
--            2);

COPY srdb.area
--FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/areas.dat'
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/areas-updated-formatted.csv'
CSV HEADER 
;

ALTER TABLE srDB.area 
ADD COLUMN areaID VARCHAR(70); -- PRIMARY KEY;

UPDATE srDB.area SET areaID = (country || '-' || areatype || '-' || areacode);

ALTER TABLE srDB.area 
ADD PRIMARY KEY (areaID);

-- table for taxonomic information
CREATE TABLE srdb.taxonomy (
tsn INT PRIMARY KEY,
scientificname VARCHAR(200) PRIMARY KEY, -- ALTER TABLE srdb.taxonomy ADD CONSTRAINT scientificname_id UNIQUE (scientificname);
-- commonname VARCHAR(200),
kingdom VARCHAR(200),
phylum VARCHAR(200),
classname VARCHAR(200),
ordername VARCHAR(200),
family VARCHAR(200),
genus VARCHAR(200),
species VARCHAR(200),
myersname VARCHAR(20),
commonname1 VARCHAR(200),
commonname2 VARCHAR(200),
myersscientificname VARCHAR(200),
myersfamily VARCHAR(50)
);

COPY srdb.taxonomy
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/taxonomy.dat'
CSV HEADER 
;


---
-- table for the different stocks
CREATE TABLE srdb.stock (
stockid VARCHAR(40) PRIMARY KEY,
tsn INT REFERENCES srDB.taxonomy, -- foreign key refers to table srDB.taxonomy
scientificname VARCHAR(200),
commonname VARCHAR(200),
areaID VARCHAR(70) REFERENCES srDB.area,
stocklong VARCHAR(200),
inMYERSDB INT,
MYERSstockid VARCHAR(40)
);

--CREATE TABLE srdb.stockarea (
--stockid VARCHAR(40) REFERENCES srdb.stock,
--areaID VARCHAR(70) REFERENCES srdb.area
--);



-- table for the different assessors
CREATE TABLE srdb.assessor (
assessorid VARCHAR(40) PRIMARY KEY,
mgmt VARCHAR(40) REFERENCES srdb.management,
country VARCHAR(50),
assessorfull VARCHAR(200)
);


-- table for the different assessment methods
CREATE TABLE srdb.assessmethod (
category VARCHAR(100),
methodshort VARCHAR(20) PRIMARY KEY,
methodlong VARCHAR(200)
);


-- table for the different recorders
CREATE TABLE srdb.recorder (
firstname VARCHAR(50),
lastname VARCHAR(50),
email VARCHAR(50),
institution VARCHAR(100),
address VARCHAR(1000),
phonenumber VARCHAR(50),
notes VARCHAR(1000),
nameinxls VARCHAR(50) PRIMARY KEY
);

COPY srDB.recorder
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/recorders.dat'
CSV HEADER
;


--ALTER TABLE srDB.recorder
--ADD COLUMN recorderunique VARCHAR(70);

--UPDATE srDB.recorder SET recorderunique = (firstname || ' ' || lastname);




-- table for the different assessments
CREATE TABLE srdb.assessment (
assessid VARCHAR(200) PRIMARY KEY,
assessorid VARCHAR(40) REFERENCES srdb.assessor,
stockid VARCHAR(40)  REFERENCES srdb.stock,
recorder VARCHAR(40) REFERENCES srdb.recorder(nameinxls),
-- daterecorded INT, -- 
daterecorded DATE,
dateloaded DATE,
assessyear VARCHAR(9),
-- assessyear INT,
assesssource VARCHAR(1000),
contacts VARCHAR(300),
notes VARCHAR(1000),
pdffile VARCHAR(300),
assess INT,
refpoints INT,
assessmethod VARCHAR(200) REFERENCES srdb.assessmethod,
assesscomments VARCHAR(1000),
xlsfilename VARCHAR(100)
);


-- table for references to stock assessment documents
--CREATE TABLE srdb.references (
--BibTexID VARCHAR(50),
--BibTex-entry TEXT
--);

-- codes for time-series metrics
CREATE TABLE srdb.tsmetrics (
tscategory VARCHAR(200),
tsshort VARCHAR(40),
tslong VARCHAR(200),
tsunitsshort VARCHAR(40),
tsunitslong VARCHAR(300)
);

COPY srDB.tsmetrics
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/tsmetrics.dat'
CSV HEADER
;

ALTER TABLE srDB.tsmetrics
ADD COLUMN tsunique VARCHAR(70);

UPDATE srDB.tsmetrics SET tsunique = (tsshort || '-' || tsunitsshort);

ALTER TABLE srDB.tsmetrics
ADD PRIMARY KEY (tsunique);

-- table for time-series
CREATE TABLE srdb.timeseries (
assessid VARCHAR(200) REFERENCES srdb.assessment,
tsid VARCHAR(40) REFERENCES srdb.tsmetrics,
tsyear INT,
tsvalue FLOAT
);


-- codes for point metrics
CREATE TABLE srdb.biometrics (
category VARCHAR(100),
subcategory VARCHAR(100),
bioshort VARCHAR(40),
biolong VARCHAR(300),
biounitsshort VARCHAR(40),
biounitslong VARCHAR(200)
);

COPY srDB.biometrics
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/biometrics.dat'
CSV HEADER
;

ALTER TABLE srDB.biometrics
ADD COLUMN biounique VARCHAR(70);

UPDATE srDB.biometrics SET biounique = (bioshort || '-' || biounitsshort);

ALTER TABLE srDB.biometrics
ADD PRIMARY KEY (biounique);

-- table for biological parameters
CREATE TABLE srdb.bioparams (
assessid VARCHAR(200),
bioid VARCHAR(40) REFERENCES srdb.biometrics,
biovalue VARCHAR(200),
bionotes VARCHAR(1000),
bioyear VARCHAR(15)
);

-- table for RIS data fields for handling references
CREATE TABLE srdb.risfields (
risfield VARCHAR(50),
risdescription VARCHAR(200)
);

ALTER TABLE srDB.risfields
ADD PRIMARY KEY (risfield);

-- load the RIS fields from a text file
COPY srdb.risfields
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/risfields.dat'
CSV HEADER 
;

-- restrict possible values for certain RIS fields
CREATE TABLE srdb.risfieldvalues (
risfield VARCHAR(50) REFERENCES srDB.risfields,
allowedvalueshort VARCHAR(10),
allowedvaluelong VARCHAR(200)
);

-- load the allowed RIS fields from a text file
COPY srdb.risfieldvalues
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/risfieldvalues.dat'
CSV HEADER 
;

-- table for actual references (data to be loaded from assessments)
CREATE TABLE srdb.referencedoc (
assessid VARCHAR(200) REFERENCES srdb.assessment,
risfield VARCHAR(50) REFERENCES srdb.risfields,
risentry VARCHAR(300) 
);

