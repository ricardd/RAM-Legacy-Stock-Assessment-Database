-- query to produce postGIS/shapefile/KML showing number of stocks per LME
-- Last modified Time-stamp: <2010-04-28 10:55:39 (srdbadmin)>
DROP TABLE stocksbylme;
CREATE TABLE stocksbylme
AS (
SELECT 
lr.lme_number,
lr.lme_name,
l.the_geom,
count(*) as numassessments
FROM
srdb.lmerefs lr,
srdb.lmetostocks ls,
srdb.assessment aa,
lmes l
WHERE
cast(l.lme_number as int)=lr.lme_number AND
ls.stocktolmerelation = 'primary' AND
ls.lme_number = lr.lme_number AND
ls.stockid = aa.stockid AND
aa.assess=1 AND
aa.recorder != 'MYERS'
GROUP BY 
lr.lme_number,
lr.lme_name,
l.the_geom
ORDER BY
lr.lme_number
)
;
