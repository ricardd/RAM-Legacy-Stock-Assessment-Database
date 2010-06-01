-- queries to generate the tables (& #s for text) for the fish and fisheries manuscript
-- DR, JB, CM started 2009-05-27
-- Time-stamp: <2010-05-06 14:52:32 (srdbadmin)>
-- Note: All queries should include only MARINE FISHES (i.e. exclude invertebrates), only population dynamics models (i.e. assess=1), and should exclude MYERS stocks. Check this!

-- Table 1, assessments in the database, i.e. "stocklong" and the reference document
--SELECT
--stocklong
--FROM
--srdb.assessment
--WHERE
--recorder!='MYERS'
--;

----GEOGRAPHY
---- number of assessments per LME
--SELECT
--a.lme_number, 
--b.lme_name, 
--count(*) as "number of assessments" 
--FROM 
--(
--select stockid, lme_number from srdb.lmetostocks where stockid 
--in 
--(
--select a.stockid from srdb.stock as a, srdb.assessment as b where a.tsn IN (select tsn from srdb.taxonomy where classname IN ('Chondrichthyes','Myxini','Actinopterygii')) and b.recorder!='MYERS' and a.stockid=b.stockid
--)
--and stocktolmerelation = 'primary' 
--)
--as a, 
--srdb.lmerefs b 
--WHERE 
--a.lme_number=b.lme_number 
--GROUP BY 
--a.lme_number, 
--b.lme_name 
--ORDER BY 
--a.lme_number;


----TAXONOMY
----number of assessments per ORDER
--SELECT tt.species, count(*)
--FROM srdb.assessment aa, 
--	srdb.stock bb,
--	srdb.taxonomy tt
--WHERE aa.stockid=bb.stockid AND
--	bb.tsn=tt.tsn AND
--	aa.recorder != 'MYERS' AND
--	tt.classname IN ('Chondrichthyes','Myxini','Actinopterygii')
--GROUP BY tt.species
--ORDER by tt.species
--;

----number of assessments per FAMILY
--SELECT tt.family, count(*)
--FROM
--srdb.assessment aa,
--srdb.stock bb,
--srdb.taxonomy tt
--WHERE
--aa.stockid=bb.stockid AND
--bb.tsn=tt.tsn AND
--aa.recorder != 'MYERS' AND
--tt.classname IN ('Chondrichthyes','Myxini','Actinopterygii')
--GROUP BY tt.family
--ORDER BY tt.family
--;

----ASSESSMENTS
----type of assessment
--SELECT bb.category, count(assessid)
--FROM srdb.assessment aa,
--srdb.assessmethod bb,
--srdb.taxonomy tt,
--srdb.stock kk
--WHERE aa.assessmethod=bb.methodshort AND
--aa.recorder != 'MYERS' AND
--tt.classname IN ('Chondrichthyes','Myxini','Actinopterygii') AND
--kk.tsn=tt.tsn AND
--aa.stockid=kk.stockid AND
--aa.assess = 1
--GROUP BY bb.category
--;


----checks
--select * FROM srdb.taxonomy WHERE family='Menippidae';
--select DISTINCT classname FROM srdb.taxonomy;
--select * FROM srdb.taxonomy WHERE family = 'NULL';
--select category FROM srdb.assessmethod;
--SELECT assessid FROM srdb.assessment WHERE assessid like '%COD%' AND recorder != 'MYERS';


-- for table 1 in submitted manuscript
SELECT
m.country,
m.managementauthority,
m.mgmt,
count(*) as nassess
FROM
srdb.management m,
srdb.assessor aa,
srdb.assessment a
WHERE
a.assessorid = aa.assessorid AND
m.mgmt = aa.mgmt AND
a.recorder != 'MYERS' AND
a.assess=1
GROUP BY 
m.country,
m.managementauthority,
m.mgmt
ORDER BY 
m.country
;

-- Supporting info table, as per Science 20009 Table S2
SELECT
lr.lme_name, bb.scientificname, bb.stocklong, aa.stockid, aa.assessid
FROM
srdb.assessment aa,
srdb.stock bb,
srdb.lmetostocks lm,
srdb.lmerefs lr
WHERE
aa.stockid=bb.stockid AND aa.recorder != 'MYERS' AND aa.assess=1 AND bb.stockid=lm.stockid AND lm.stocktolmerelation = 'primary' AND lm.lme_number=lr.lme_number
ORDER BY
lr.lme_name,
bb.stocklong
;

select 
a.assessid, s.stocklong, t.scientificname 
from 
srdb.assessment a, srdb.stock s, srdb.taxonomy t 
where 
a.stockid=s.stockid and s.tsn=t.tsn and a.recorder != 'MYERS' and a.assess=1;  