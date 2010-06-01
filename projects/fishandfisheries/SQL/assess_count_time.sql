
-- extract the count of assements with particular data for a given year
-- catch
select tsyear, count(distinct assessid) from srdb.newtimeseries_values_view where catch_landings is not null group by tsyear;

-- ssb 
select tsyear, count(distinct assessid) from srdb.newtimeseries_values_view where ssb is not null group by tsyear;

-- recruitment
select tsyear, count(distinct assessid) from srdb.newtimeseries_values_view where r is not null group by tsyear;

-- for the horizontal bars

select assessid, min(tsyear) as minyear, max(tsyear) as maxyear from srdb.newtimeseries_values_view where r is not null group by assessid order by minyear;


-- all of the years returned

-- 
select assessid, min(tsyear) as minyear, max(tsyear) as maxyear from srdb.newtimeseries_values_view where r is not null group by assessid order by minyear, maxyear;
-- 

select 
  aa.assessid, 
  aa.tsyear, 
  aa.r
from 
  srdb.newtimeseries_values_view as aa,
  (select assessid, min(tsyear) as minyear, max(tsyear) as maxyear from srdb.newtimeseries_values_view where r is not null group by assessid order by minyear, maxyear) as bb
where 
  aa.assessid=bb.assessid
and 
  aa.r is not null
group by 
  aa.assessid,
  aa.tsyear,
  aa.r,
  bb.minyear
order by 
  bb.minyear,
  aa.tsyear
limit 500;




select * from (select assessid, count(*) from srdb.newtimeseries_values_view where r is null group by assessid) as aa where aa.assessid in (select distinct(assessid) from srdb.newtimeseries_values_view where r is not null);


select assessid, count(ssb), count(r), count(catch_landings) from srdb.newtimeseries_values_view group by assessid;

-- check for missing values within a series
select * from srdb.newtimeseries_values_view v, (select assessid, min(tsyear) as minyr, max(tsyear) as maxyr from srdb.newtimeseries_values_view where r is not null group by assessid) as aa where aa.assessid = v.assessid and v.tsyear>aa.minyr and v.tsyear < aa.maxyr and v.r = 0  ;