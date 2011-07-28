-- create-srDB.sql
--
-- postgreSQL implementation of stock-recruitment database
-- create tables and load data required by foreign keys
--
-- Daniel Ricard
-- Started: 2007-12-19
-- Last modified: Time-stamp: <2011-07-25 12:12:32 (srdbadmin)>
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
-- 2010-08-31: adding comments on the tables and views, I haven't used this script for a long time since there is rarely a need to rebuild the database from scratch now

-- COMMENT ON DATABASE srdb IS 'RAM Legacy assessment database.';

-- create a separate schema for this database
CREATE SCHEMA srdb;

--GRANT USAGE ON SCHEMA srdb TO srdbuser;

-- create a separate schema for the recovery work 
-- CREATE SCHEMA srdbrecovery;

COMMENT ON SCHEMA srdb IS 'This schema handles all tables and views for the RAM Legacy assessment database.';

-- table for the different management authorities
CREATE TABLE srdb.management (
mgmt VARCHAR(40) PRIMARY KEY,
country VARCHAR(50),
managementauthority VARCHAR(200)
);

COPY srdb.management
--FROM '/home/srdbadmin/srdb/srdb/data/mgmt.dat'
FROM '/home/srdbadmin/srdb/srdb/data/management-fromdb.dat'
-- FROM './data/mgmt.dat'
NULL AS 'NA'
CSV HEADER 
;

COMMENT ON TABLE srdb.management IS 'Management bodies, used in the definition of stock areas and stock assessors.';


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
--FROM '/home/srdbadmin/srdb/srdb/data/areas.dat'
--FROM '/home/srdbadmin/srdb/srdb/data/areas-updated-formatted.csv'
FROM '/home/srdbadmin/srdb/srdb/data/area-fromdb.dat'
NULL AS 'NA'
CSV HEADER 
;

ALTER TABLE srDB.area 
ADD COLUMN areaID VARCHAR(70); -- PRIMARY KEY;

UPDATE srDB.area SET areaID = (country || '-' || areatype || '-' || areacode);

ALTER TABLE srDB.area 
ADD PRIMARY KEY (areaID);

COMMENT ON TABLE srdb.area IS 'Stock areas, used in the definition of stocks.';

-- table for taxonomic information
CREATE TABLE srdb.taxonomy (
tsn INT PRIMARY KEY,
scientificname VARCHAR(200), -- 
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

ALTER TABLE srdb.taxonomy ADD CONSTRAINT scientificname_id UNIQUE (scientificname);

COPY srdb.taxonomy
--FROM '/home/srdbadmin/srdb/srdb/data/taxonomy.dat'
FROM '/home/srdbadmin/srdb/srdb/data/taxonomy-fromdb.dat'
NULL AS 'NA'
CSV HEADER 
;

COMMENT ON TABLE srdb.taxonomy IS 'Taxonomic information obtained from the Integrated Taxonomic Information System (ITIS). Negative values for taxonomic serial number (TSN) are used in cases where a stock is of a species not present in ITIS.';

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

COMMENT ON TABLE srdb.stock IS 'A stock consists of a species (field "tsn" from srdb.taxonomy), an area (field "areaid" from srdb.area). This table also keeps track of stocks that were in RAM''s original database and the name used there if it is different from the stockid defined in the RAM Legacy database';

-- table for the different assessors
CREATE TABLE srdb.assessor (
assessorid VARCHAR(40) PRIMARY KEY,
mgmt VARCHAR(40) REFERENCES srdb.management,
country VARCHAR(50),
assessorfull VARCHAR(200)
);

COMMENT ON TABLE srdb.assessor IS 'Details of assessors. An assessor must be associated with a management boby from the table srdb.management.';


-- table for the different assessment methods
CREATE TABLE srdb.assessmethod (
category VARCHAR(100),
methodshort VARCHAR(20) PRIMARY KEY,
methodlong VARCHAR(200)
);

COMMENT ON TABLE srdb.assessmethod IS 'Details of assessment methods.';


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
--FROM '/home/srdbadmin/srdb/srdb/data/recorders.dat'
FROM '/home/srdbadmin/srdb/srdb/data/recorder-fromdb.dat'
NULL AS 'NA'
CSV HEADER
;

COMMENT ON TABLE srdb.recorder IS 'Details for recorders of assessments.';


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
xlsfilename VARCHAR(100),
mostrecent VARCHAR(3)
);

COMMENT ON TABLE srdb.assessment IS 'Assesment-level details, defines ASSESSID.';

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
tsunitslong VARCHAR(300),
tsunique VARCHAR(70) PRIMARY KEY
);

COPY srDB.tsmetrics
--FROM '/home/srdbadmin/srdb/srdb/data/tsmetrics.dat'
FROM '/home/srdbadmin/srdb/srdb/data/tsmetrics-fromdb.dat'
NULL AS 'NA'
CSV HEADER
;

--ALTER TABLE srDB.tsmetrics
--ADD COLUMN tsunique VARCHAR(70);

--UPDATE srDB.tsmetrics SET tsunique = (tsshort || '-' || tsunitsshort);

--ALTER TABLE srDB.tsmetrics
--ADD PRIMARY KEY (tsunique);

COMMENT ON TABLE srdb.tsmetrics IS 'Definition of tiemseries such as recruits, spawning stock biomass, total abundance, etc.';


-- table for time-series
CREATE TABLE srdb.timeseries (
assessid VARCHAR(200) REFERENCES srdb.assessment,
tsid VARCHAR(40) REFERENCES srdb.tsmetrics,
tsyear INT,
tsvalue FLOAT
);

COMMENT ON TABLE srdb.timeseries IS 'Values of timeseries';


-- codes for point metrics
CREATE TABLE srdb.biometrics (
category VARCHAR(100),
subcategory VARCHAR(100),
bioshort VARCHAR(40),
biolong VARCHAR(300),
biounitsshort VARCHAR(40),
biounitslong VARCHAR(200),
biounique VARCHAR(70) PRIMARY KEY
);

COPY srDB.biometrics
--FROM '/home/srdbadmin/srdb/srdb/data/biometrics.dat'
FROM '/home/srdbadmin/srdb/srdb/data/biometrics-fromdb.dat'
NULL AS 'NA'
CSV HEADER
;

--ALTER TABLE srDB.biometrics
--ADD COLUMN biounique VARCHAR(70);

--UPDATE srDB.biometrics SET biounique = (bioshort || '-' || biounitsshort);

--ALTER TABLE srDB.biometrics
--ADD PRIMARY KEY (biounique);

COMMENT ON TABLE srdb.biometrics IS 'Definition of point metrics such as reference points, life-history parameters and description of timeseries (e.g. age of recruitment, ages used in F calculations, etc.).';

-- table for biological parameters
CREATE TABLE srdb.bioparams (
assessid VARCHAR(200),
bioid VARCHAR(40) REFERENCES srdb.biometrics,
biovalue VARCHAR(200),
bioyear VARCHAR(15),
bionotes VARCHAR(1000)
);

COMMENT ON TABLE srdb.bioparams IS 'Values of point metrics.';

-- table for RIS data fields for handling references
CREATE TABLE srdb.risfields (
risfield VARCHAR(50),
risdescription VARCHAR(200)
);

ALTER TABLE srDB.risfields
ADD PRIMARY KEY (risfield);

-- load the RIS fields from a text file
COPY srdb.risfields
--FROM '/home/srdbadmin/srdb/srdb/data/risfields.dat'
FROM '/home/srdbadmin/srdb/srdb/data/risfields-fromdb.dat'
NULL AS 'NA'
CSV HEADER 
;

COMMENT ON TABLE srdb.risfields IS 'Name of RIS fields.';

-- restrict possible values for certain RIS fields
CREATE TABLE srdb.risfieldvalues (
risfield VARCHAR(50) REFERENCES srDB.risfields,
allowedvalueshort VARCHAR(10),
allowedvaluelong VARCHAR(200)
);

-- load the allowed RIS fields from a text file
COPY srdb.risfieldvalues
--FROM '/home/srdbadmin/srdb/srdb/data/risfieldvalues.dat'
FROM '/home/srdbadmin/srdb/srdb/data/risfieldvalues-fromdb.dat'
NULL AS 'NA'
CSV HEADER 
;

COMMENT ON TABLE srdb.risfieldvalues IS 'Allowed RIS field values.';


-- table for actual references (data to be loaded from assessments)
CREATE TABLE srdb.referencedoc (
assessid VARCHAR(200) REFERENCES srdb.assessment,
risfield VARCHAR(50) REFERENCES srdb.risfields,
risentry VARCHAR(300) 
);

COMMENT ON TABLE srdb.referencedoc IS 'RIS fields containing the reference document for an assessment.';
