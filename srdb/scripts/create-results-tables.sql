

DROP TABLE srdbuser.SMTableS1;
CREATE TABLE srdbuser.SMTableS1 (
assessid VARCHAR(200) REFERENCES srdb.assessment,
lme_name VARCHAR(70), -- REFERENCES srdb.lmerefs(lme_name),
commonname1 VARCHAR(200), -- REFERENCES srdb.taxonomy(commonname1),
Bratio FLOAT, 
Ffratio FLOAT, 
fromassessment BOOLEAN
);


COPY srdbuser.SMTableS1
FROM '/home/srdbadmin/SQLpg/srDB/srDB/data/Data4figS1.csv'
CSV HEADER
;

GRANT SELECT ON srdbuser.SMTableS1 TO srdbuser;
