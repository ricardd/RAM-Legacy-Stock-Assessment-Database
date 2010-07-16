-- table to handle the FishBase and SAUP species codes
DROP TABLE srdb.fishbasesaupcodes;
CREATE TABLE srdb.fishbasesaupcodes
(
TaxonKey INT,
SpeCode INT,
TaxonNom_TaxonName VARCHAR(200),
CommonName VARCHAR(100),
scientificname VARCHAR(200) REFERENCES srdb.taxonomy(scientificname)
);

COPY srdb.fishbasesaupcodes
FROM '/home/srdbadmin/srdb/srdb/data/SAUP-codes.csv'
NULL AS 'NA'
CSV HEADER 
;

-- to see which species do not have FishBase and SAUP codes:
-- select tsn, scientificname, commonname1 from srdb.taxonomy where scientificname not in (select scientificname from srdb.fishbasesaupcodes );
