-- total number of assessments
select count(*) as "total number of assessments in srDB"
from srdb.assessment;

select count(*) as "total number of assessments in srDB excluding RAM original data"
from srdb.assessment
where recorder !='MYERS';


-- number of assessments per recorder
SELECT
recorder, count(*) as "total number of assessments in srDB"
FROM srdb.assessment
GROUP by recorder
ORDER BY count(*) DESC, recorder
;

-- number of assessment for tstruncation project
select count(distinct stockid) as "number of assessment in time-truncation view" from srdb.tstruncation_ssbseries;

-- number of assessment per recorder with time-series data
select recorder, count(*) as "total number of assessments with time-series data in srDB" 
from srdb. assessment where assessid in 
(select distinct assessid from srdb.timeseries) 
group by recorder
ORDER BY count(*) DESC
;

-- number of assessment per recorder with biometrics data
select recorder, count(*) as "total number of assessments with biometrics data in srDB" 
from srdb. assessment where assessid in 
(select distinct assessid from srdb.bioparams) 
group by recorder
ORDER BY count(*) DESC
;


-- each stock by recorder
SELECT
-- aa.recorder, bb.stocklong, bb.scientificname, bb.commonname, aa.stockid
aa.recorder, bb.stocklong, bb.scientificname, aa.stockid
FROM
srdb.assessment aa,
srdb.stock bb
WHERE
aa.stockid=bb.stockid
ORDER BY
aa.recorder, aa.stockid
;

select
tt.ordername, count(*)
FROM
srdb.assessment aa,
srdb.stock bb,
srdb.taxonomy tt
WHERE
aa.stockid=bb.stockid AND
bb.tsn=tt.tsn
GROUP BY
tt.ordername
ORDER BY
tt.ordername
;

select
tt.family, count(*)
FROM
srdb.assessment aa,
srdb.stock bb,
srdb.taxonomy tt
WHERE
aa.stockid=bb.stockid AND
bb.tsn=tt.tsn
GROUP BY
tt.family
ORDER BY
tt.family
;

-- number of assessment(s) per species
select
tt.commonname1, tt.family, tt.ordername, tt.scientificname, count(*)
FROM
srdb.assessment aa,
srdb.stock bb,
srdb.taxonomy tt
WHERE
aa.stockid=bb.stockid AND
bb.tsn=tt.tsn
GROUP BY
tt.commonname1, tt.family, tt.ordername, tt.scientificname
ORDER BY
tt.family, tt.ordername, tt.scientificname
;

-- number of assessment(s) per stock
select
tt.commonname1, tt.family, tt.ordername, tt.scientificname, bb.stocklong, count(*)
FROM
srdb.assessment aa,
srdb.stock bb,
srdb.taxonomy tt
WHERE
aa.stockid=bb.stockid AND
bb.tsn=tt.tsn
GROUP BY
tt.commonname1, tt.family, tt.ordername, tt.scientificname, bb.stocklong
ORDER BY
tt.family, tt.ordername, tt.scientificname
;


--_________________________________________________
-- how many biometrics are available for each assessment?
SELECT
aa.recorder, aa.assessid, count(*) as "number of biometrics"
FROM srdb.assessment aa, srdb.bioparams bb
WHERE aa.assessid=bb.assessid
GROUP by aa.recorder, aa.assessid
ORDER BY aa.recorder, aa.assessid;


--_________________________________________________
-- how many time-series are available for each assessment?
select t.recorder, t.assessid, count(*) as "number of time-series" 
from 
(select aa.recorder, aa.assessid, bb.tsid from srdb.assessment aa, srdb.timeseries bb WHERE aa.assessid=bb.assessid GROUP by aa.recorder, aa.assessid, bb.tsid) as t 
group by t.recorder, t.assessid
ORDER BY t.recorder,t.assessid;

--_________________________________________________
-- what time-series data are available for the different assessments
select t.recorder, t.assessid, t.tsid 
from 
(select aa.recorder, aa.assessid, bb.tsid from srdb.assessment aa, srdb.timeseries bb WHERE aa.assessid=bb.assessid GROUP by aa.recorder, aa.assessid, bb.tsid) as t 
ORDER BY t.recorder,t.assessid;

-- what biometrics data are available for the different assessments
select t.recorder, t.assessid, t.bioid
from 
(select aa.recorder, aa.assessid, bb.bioid from srdb.assessment aa, srdb.bioparams bb WHERE aa.assessid=bb.assessid GROUP by aa.recorder, aa.assessid, bb.bioid) as t 
ORDER BY t.recorder,t.assessid;

--SELECT
--aa.recorder, aa.assessid, count(*) as "number of time-series points"
--FROM srdb.assessment aa, srdb.timeseries bb
--WHERE aa.assessid=bb.assessid
--GROUP by aa.recorder, aa.assessid
--ORDER BY aa.recorder,aa.assessid;


--_________________________________________________
-- NMFS time-series units matched to srDB table
-- distinct tsmetrics from Fogarty
select distinct t.tsid 
from 
(select aa.recorder, aa.assessid, bb.tsid from srdb.assessment aa, srdb.timeseries bb WHERE aa.assessid=bb.assessid GROUP by aa.recorder, aa.assessid, bb.tsid) as t 
where recorder='FOGARTY'
;

--_________________________________________________
-- number of Chondrichthyes assessments from NMFS
-- number of skates and rays from Fogarty
select commonname as "NMFS Chondrichthyes" from srdb.stock where stockid in (select stockid from srdb.assessment where stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where classname= 'Chondrichthyes')) and recorder = 'FOGARTY');

-- number of assessments per country
select (CASE WHEN country= '' THEN 'MYERS' ELSE country END), count(*) from (select aa.assessid, bb.assessorid, bb.country from srdb.assessment aa, srdb.assessor bb where aa.assessorid=bb.assessorid) as a group by country order by count(*);

-- number of assessments per country and assessor
select (CASE WHEN country= '' THEN 'MYERS' ELSE country END), assessorid, count(*) from (select aa.assessid, bb.assessorid, bb.country from srdb.assessment aa, srdb.assessor bb where aa.assessorid=bb.assessorid) as a group by country, assessorid order by country, assessorid, count(*);

-- duplicate assessments for a given stock
select recorder, stockid, assessyear from srdb.assessment where stockid in (select stockid FROM (select stockid, count(*) as tot from srdb.assessment group by stockid) as a where tot > 1) order by stockid;


-- LMEs by stock
select stockid, stocklong, max(p) as primarylme, max(s) as secondarylme, max(t) as tertiarylme, max(q) as quaternarylme, max(qq) as quinarylme from (select s.stockid, s.stocklong, (case when stocktolmerelation = 'primary' then l.lme_name else NULL end) as p, (case when stocktolmerelation = 'secondary' then l.lme_name else NULL end) as s, (case when stocktolmerelation = 'tertiary' then l.lme_name else NULL end) as t, (case when stocktolmerelation = 'quaternary' then l.lme_name else NULL end) as q, (case when stocktolmerelation = 'quinary' then l.lme_name else NULL end) as qq from srdb.stock s, srdb.lmerefs l, srdb.lmetostocks ls where ls.lme_number=l.lme_number and s.stockid=ls.stockid) as aa group by stockid, stocklong;

-- identify assessments with multiple time-series for each tscategory
SELECT * FROM
(
select recorder, assessid, tscategory, count(*) as ct
FROM
(
select t.recorder, t.assessid, t.tsid, tsm.tscategory 
from 
(select aa.recorder, aa.assessid, bb.tsid from srdb.assessment aa, srdb.timeseries bb WHERE aa.assessid=bb.assessid GROUP by aa.recorder, aa.assessid, bb.tsid) as t,
srdb.tsmetrics tsm
WHERE
t.tsid=tsm.tsunique
) as tt
GROUP BY recorder, assessid, tscategory
) as ttt
WHERE ct >= 2
;


