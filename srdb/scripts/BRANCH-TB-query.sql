-- BRANCH-TB-query.sql
-- Daniel Ricard, started 2009-05-03
-- Last modified Time-stamp: <2009-05-03 18:26:50 (ricardd)>

-- psql srdb -f BRANCH-TB-query.sql -A -F "," -o BRANCH-TB.csv
SELECT
assessid,
scientificname,
commonname1,
stocklong,
lme_name,
tsyear,
(CASE WHEN tsid = 'TB-1-MT' THEN 'TB-MT' ELSE tsid END),
tsvalue
FROM
(
SELECT 
a.assessid,
t.scientificname,
t.commonname1,
s.stocklong,
lr.lme_name,
ts.tsyear,
ts.tsid,
ts.tsvalue
FROM 
srdb.assessment a, 
srdb.stock s,
srdb.taxonomy t,
srdb.lmerefs lr, 
srdb.lmetostocks ls, 
srdb.timeseries ts
WHERE
t.tsn=s.tsn AND
ls.stocktolmerelation = 'primary' AND
lr.lme_number=ls.lme_number AND
a.stockid=ls.stockid AND
s.stockid=a.stockid AND
ts.assessid=a.assessid AND
ts.tsid like 'TB-%' AND
ts.tsvalue IS NOT NULL
ORDER BY
a.assessid,
ts.tsid,
ts.tsyear
) as a
WHERE 
tsid in ('TB-MT','TB-1-MT')
;
