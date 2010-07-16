-- two tables to handle data for Large Marine Ecosystems and their link to stocks
-- REQUIRES THAT THE "lmes" table be defined, see at /home/srdbadmin/SQLpg/srDB/srDB/data/LMEs
DROP TABLE srdb.lmetostocks;
DROP TABLE srdb.lmerefs;
CREATE TABLE srdb.lmerefs as
(
select distinct lme_number, lme_name from (select cast(lme_number as int), lme_name from lmes order by lme_number) as a
);

-- add high seas areas
--INSERT INTO srdb.lmerefs VALUES (-99,'Pacific High Seas');
--INSERT INTO srdb.lmerefs VALUES (-98,'Atlantic High Seas');
--INSERT INTO srdb.lmerefs VALUES (-97,'Indian Ocean High Seas');
--INSERT INTO srdb.lmerefs VALUES (-96,'Subantarctic High Seas');


ALTER TABLE srdb.lmerefs
ADD PRIMARY KEY (lme_number);

-- the_geom

CREATE TABLE srdb.lmetostocks (
stockid VARCHAR(40) REFERENCES srdb.stock,
lme_number INT REFERENCES srdb.lmerefs,
stocktolmerelation VARCHAR(10) -- PRIMARY, SECONDARY, TERTIARY
);


COPY srdb.lmetostocks
FROM '/home/srdbadmin/srdb/srdb/data/lmetostocks.dat'
CSV HEADER 
;

