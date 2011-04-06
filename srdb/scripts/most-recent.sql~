-- create a table with information about which assessment is the most recent, what it updates, whether it's a duplicate, etc.
-- Daniel Ricard, started 2010-01-04
-- Last modified Time-stamp: <2010-01-08 14:40:30 (srdbadmin)>

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
(select a.stockid, a.assessid, a.recorder, min(v.tsyear) as minyear, max(v.tsyear) as maxyear, max(v.tsyear)-min(v.tsyear) as span from srdb.timeseries_values_view v, srdb.assessment a where a.assessid=v.assessid and v.catch_landings is not null group by a.stockid, a.assessid, a.recorder order by a.stockid, minyear, span desc, maxyear) 
as aa
group by stockid
order by stockid
) as bb,
(select a.stockid, a.assessid, a.recorder, min(v.tsyear) as minyear, max(v.tsyear) as maxyear, max(v.tsyear)-min(v.tsyear) as span from srdb.timeseries_values_view v, srdb.assessment a where a.assessid=v.assessid and v.catch_landings is not null group by a.stockid, a.assessid, a.recorder order by a.stockid, minyear, span desc, maxyear) as cc
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
(select a.stockid, a.assessid, a.recorder, min(v.tsyear) as minyear, max(v.tsyear) as maxyear, max(v.tsyear)-min(v.tsyear) as span from srdb.timeseries_values_view v, srdb.assessment a where a.assessid=v.assessid and v.catch_landings is not null group by a.stockid, a.assessid, a.recorder order by a.stockid, minyear, span desc, maxyear) 
as aa
group by stockid
order by stockid
) as bb,
(select a.stockid, a.assessid, a.recorder, min(v.tsyear) as minyear, max(v.tsyear) as maxyear, max(v.tsyear)-min(v.tsyear) as span from srdb.timeseries_values_view v, srdb.assessment a where a.assessid=v.assessid and v.catch_landings is not null group by a.stockid, a.assessid, a.recorder order by a.stockid, minyear, span desc, maxyear) as cc
where bb.stockid=cc.stockid
) as gg
where ff.assessid=gg.assessid
);
