-- load data that links reference points to timeseries 

DROP TABLE srdb.brptots;

BEGIN;

CREATE TABLE srdb.brptots (
assessid VARCHAR(200) REFERENCES srdb.assessment,
bioid VARCHAR(70) REFERENCES srdb.biometrics(biounique),
tsid VARCHAR(40) REFERENCES srdb.tsmetrics(tsunique)
);


-- NOTE: to generate the initial list of entries for this data table, I actually ran a query on the underlying tables, see "get-data-for-brptots.sql"

COPY srdb.brptots
FROM '/home/srdbadmin/srdb/srdb/data/reference-points-to-timeseries.dat'
CSV HEADER 
;

-- set a constraint that the assessid-bioid and the assessid-tsid must be present in srdb.bioparams and srdb.timeseries


-- set a unique constraint to avoid duplication of entries
ALTER TABLE srdb.brptots ADD COLUMN brptotsunique VARCHAR(300);
UPDATE srdb.brptots SET brptotsunique = assessid || '-' || bioid || '-' ||  tsid;

ALTER TABLE srdb.brptots ADD PRIMARY KEY (brptotsunique);
COMMIT;
