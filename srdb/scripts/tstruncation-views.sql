-- tstruncation.sql
-- definition of views for Renee Prefontaine's honours project

-- first view is a summary of what assessments are available from RAM's original datasets and from the updated dataset

-- SELECT a.stockid, a.recorder, min(ts.tsyear) || '-' ||max(ts.tsyear) from srdb.assessment a, srdb.timeseries ts where stockid in (SELECT stockid from srdb.assessment where recorder = 'MYERS') and a.assessid=ts.assessid group by a.stockid, a.recorder order by a.stockid;

-- SELECT a.stockid, a.recorder, min(ts.tsyear) || '-' ||max(ts.tsyear) as years from srdb.assessment a, srdb.timeseries ts where stockid in (select stockid from (SELECT stockid, count(*) as ct from srdb.assessment where stockid in (SELECT stockid from srdb.assessment where recorder = 'MYERS') group by stockid) as a where ct >=2) and a.assessid=ts.assessid group by a.stockid, a.recorder order by a.stockid;


-- 
-- select a.stockid, a.assessid, a.recorder, a.assessmethod, am.methodlong, a.pdffile from srdb.assessment a, srdb.assessmethod am where stockid in (select stockid from srdb.tstruncation_summary where tsid like '%SSB%' and "First year similar" = 'no') and a.assessmethod=am.methodshort order by stockid;


--SELECT a.stockid, a.assessid, a.recorder 
--from 
--srdb.assessment a
--where
--a.stockid in (select distinct stockid from srdb.assessment where recorder = 'MYERS') AND
--a.recorder != 'MYERS'
--;


--SELECT
--stockid, tsid,
--ramyrs as "Myers years",
--newyrs as "Updated years",
--(CASE WHEN newminyr = ramminyr THEN 'yes' ELSE 'no' END) as "First year similar"
--FROM
--(
--SELECT
--stockid, tsid,
--max(ramyrs) as ramyrs,
--max(ramminyr) as ramminyr,
--max(rammaxyr) as rammaxyr,
--max(newyrs) as newyrs,
--max(newminyr) as newminyr,
--max(newmaxyr) as newmaxyr
--FROM
--(
--SELECT 
--stockid,
--tsid,
--(CASE WHEN recorder='MYERS' THEN yrs ELSE NULL END) as ramyrs,
--(CASE WHEN recorder='MYERS' THEN minyr ELSE NULL END) as ramminyr,
--(CASE WHEN recorder='MYERS' THEN maxyr ELSE NULL END) as rammaxyr,
--(CASE WHEN recorder!='MYERS' THEN yrs ELSE NULL END) as newyrs,
--(CASE WHEN recorder!='MYERS' THEN minyr ELSE NULL END) as newminyr,
--(CASE WHEN recorder!='MYERS' THEN maxyr ELSE NULL END) as newmaxyr
--FROM
--(
--select 
--a.stockid,
--a.recorder,
--ts.assessid, ts.tsid, 
--min(ts.tsyear) as minyr, max(ts.tsyear) as maxyr,
--min(ts.tsyear) ||'-' || max(ts.tsyear) as yrs
--FROM 
--srdb.timeseries ts,
--srdb.assessment a
--WHERE ts.tsvalue IS NOT NULL AND
--a.assessid=ts.assessid
--group by a.stockid, a.recorder, ts.assessid, ts.tsid
--ORDER by a.stockid, a.recorder
--) as aa
--) as bb
--GROUP BY 
--stockid, tsid
--) as cc
--WHERE 
--ramyrs IS NOT NULL AND
--newyrs IS NOT NULL
--;


-- DROP VIEW srdb.tstruncation_summary;

CREATE OR REPLACE VIEW srdb.tstruncation_summary AS
(
SELECT
stockid, stocklong, tsid,
ramyrs as "Myers years",
newyrs as "Updated years",
(CASE WHEN newminyr = ramminyr THEN 'yes' ELSE 'no' END) as "First year similar"
FROM
(
SELECT
stockid, tsid, stocklong,
max(ramyrs) as ramyrs,
max(ramminyr) as ramminyr,
max(rammaxyr) as rammaxyr,
max(newyrs) as newyrs,
max(newminyr) as newminyr,
max(newmaxyr) as newmaxyr
FROM
(
SELECT 
stockid,stocklong,
tsid,
(CASE WHEN recorder='MYERS' THEN yrs ELSE NULL END) as ramyrs,
(CASE WHEN recorder='MYERS' THEN minyr ELSE NULL END) as ramminyr,
(CASE WHEN recorder='MYERS' THEN maxyr ELSE NULL END) as rammaxyr,
(CASE WHEN recorder!='MYERS' THEN yrs ELSE NULL END) as newyrs,
(CASE WHEN recorder!='MYERS' THEN minyr ELSE NULL END) as newminyr,
(CASE WHEN recorder!='MYERS' THEN maxyr ELSE NULL END) as newmaxyr
FROM
(
select 
a.stockid, st.stocklong,
a.recorder,
ts.assessid, ts.tsid, 
min(ts.tsyear) as minyr, max(ts.tsyear) as maxyr,
min(ts.tsyear) ||'-' || max(ts.tsyear) as yrs
FROM 
srdb.timeseries ts,
srdb.assessment a,
srdb.stock st
WHERE ts.tsvalue IS NOT NULL AND
a.assessid=ts.assessid AND a.stockid=st.stockid 
group by a.stockid, st.stocklong, a.recorder, ts.assessid, ts.tsid
ORDER by a.stockid, a.recorder
) as aa
) as bb
GROUP BY 
stockid, stocklong, tsid
) as cc
WHERE 
ramyrs IS NOT NULL AND
newyrs IS NOT NULL
);


CREATE OR REPLACE VIEW srdb.tstruncation_ssbseries AS
(
SELECT
stockid,
tsyear,
max(ssbmyers) as ssbmyers,
max(ssbnew) as ssbnew
FROM
(
SELECT 
ass.stockid,
ts.tsyear,
(CASE WHEN ass.recorder = 'MYERS' THEN ts.tsvalue ELSE NULL END) as ssbmyers,
(CASE WHEN ass.recorder != 'MYERS' THEN ts.tsvalue ELSE NULL END) as ssbnew
FROM
srdb.assessment ass,
srdb.timeseries ts
WHERE
ass.assessid = ts.assessid AND
ts.tsid LIKE '%SSB%' AND
ass.stockid IN (select stockid from srdb.tstruncation_summary where tsid like '%SSB%' and "First year similar" = 'no')
) as aa
GROUP BY 
stockid,
tsyear
ORDER BY
stockid,
tsyear

);


-- what are the pdf files for tstruncation stocks?
CREATE OR REPLACE view srdb.tstruncation_pdfs
AS
(
SELECT
aa.stockid,
bb.assessid,
bb.pdffile as pdffile
FROM
srdb.tstruncation_summary aa,
srdb.assessment bb
WHERE
aa.stockid = bb.stockid AND
bb.recorder != 'MYERS' AND
aa.tsid LIKE 'SSB%' AND
"First year similar" = 'no'
ORDER BY aa.stockid
);
