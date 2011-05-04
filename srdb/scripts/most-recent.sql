-- create a table with information about which assessment is the most recent, what it updates, whether it's a duplicate, etc.
-- Daniel Ricard, started 2010-01-04
-- Last modified Time-stamp: <2011-05-03 11:42:42 (srdbadmin)>
-- 2011-04-05: updates are starting to come in so I want to make sure that this table does a good job at capturing whether an entry is a true duplicate (same stock and same years, i.e. from the same assessment) or an update to an assessment (new years in the timeseries, maybe a different recorder)
-- 2011-05-03: adding some code so that the "mostrecent" field of srdb.assessment is filled in using srdb.mostrecent
DROP TABLE srdb.mostrecent;

CREATE TABLE srdb.mostrecent
AS
(
SELECT
ff.stockid, ff.assessid, gg.ismostrecent, ff.isduplicate
FROM
(
select ee.stockid, a.assessid, 
(CASE WHEN ee.n > 1 THEN 1 ELSE 0 END) as isduplicate
FROM
srdb.assessment a,
(
select dd.stockid, count(*) as n
from
(
select cc.stockid, cc.assessid, 
(CASE WHEN bb.maxyrstock=cc.maxyear THEN 1 ELSE 0 END) as ismostrecent
FROM
(
select stockid, max(maxyear) as maxyrstock
from
(select a.stockid, a.assessid, a.recorder, min(v.tsyear) as minyear, max(v.tsyear) as maxyear, max(v.tsyear)-min(v.tsyear) as span from srdb.timeseries_values_view v, srdb.assessment a where a.assessid=v.assessid group by a.stockid, a.assessid, a.recorder order by a.stockid, minyear, span desc, maxyear) 
as aa
group by stockid
order by stockid
) as bb,
(select a.stockid, a.assessid, a.recorder, min(v.tsyear) as minyear, max(v.tsyear) as maxyear, max(v.tsyear)-min(v.tsyear) as span from srdb.timeseries_values_view v, srdb.assessment a where a.assessid=v.assessid group by a.stockid, a.assessid, a.recorder order by a.stockid, minyear, span desc, maxyear) as cc
where bb.stockid=cc.stockid
) as dd
where ismostrecent = 1
group by dd.stockid
) as ee
where ee.stockid=a.stockid
) as ff,
(
select cc.stockid, cc.assessid, 
(CASE WHEN bb.maxyrstock=cc.maxyear THEN 1 ELSE 0 END) as ismostrecent
FROM
(
select stockid, max(maxyear) as maxyrstock
from
(select a.stockid, a.assessid, a.recorder, min(v.tsyear) as minyear, max(v.tsyear) as maxyear, max(v.tsyear)-min(v.tsyear) as span from srdb.timeseries_values_view v, srdb.assessment a where a.assessid=v.assessid group by a.stockid, a.assessid, a.recorder order by a.stockid, minyear, span desc, maxyear) 
as aa
group by stockid
order by stockid
) as bb,
(select a.stockid, a.assessid, a.recorder, min(v.tsyear) as minyear, max(v.tsyear) as maxyear, max(v.tsyear)-min(v.tsyear) as span from srdb.timeseries_values_view v, srdb.assessment a where a.assessid=v.assessid group by a.stockid, a.assessid, a.recorder order by a.stockid, minyear, span desc, maxyear) as cc
where bb.stockid=cc.stockid
) as gg
where ff.assessid=gg.assessid
);

COMMENT ON TABLE srdb.mostrecent IS 'Table with information about which assessment is the most recent, what it updates, whether it is a duplicate, etc..';

UPDATE srdb.assessment
SET mostrecent='yes'
WHERE assessid in (select assessid from srdb.mostrecent where ismostrecent=1)
;

UPDATE srdb.assessment
SET mostrecent='no'
WHERE assessid in (select assessid from srdb.mostrecent where ismostrecent=0)
;
