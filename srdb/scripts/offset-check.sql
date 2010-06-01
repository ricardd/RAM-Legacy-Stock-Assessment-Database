-- queries to check whether the recruitment offset matches "REC-AGE"
-- Daniel Ricard, started 2009-06-11
-- Last modified Time-stamp: <2009-06-11 11:41:17 (ricardd)>
select r.assessid, ssb.ssbmaxyr, r.rmaxyr, ssb.ssbmaxyr - r.rmaxyr, recage.recage from (select assessid, min(tsyear) as rminyr, max(tsyear) as rmaxyr from srdb.timeseries_values_view where r is not null group by assessid) as r, (select assessid, min(tsyear) as ssbminyr, max(tsyear) as ssbmaxyr from srdb.timeseries_values_view where ssb is not null group by assessid) as ssb, (select assessid, biovalue as recage from srdb.bioparams where bioid = 'REC-AGE-yr') as recage where r.assessid = ssb.assessid and recage.assessid=r.assessid;


select assessid, roffset, recage  from (select r.assessid, ssb.ssbmaxyr, r.rmaxyr, ssb.ssbmaxyr - r.rmaxyr as roffset, recage.recage from (select assessid, min(tsyear) as rminyr, max(tsyear) as rmaxyr from srdb.timeseries_values_view where r is not null group by assessid) as r, (select assessid, min(tsyear) as ssbminyr, max(tsyear) as ssbmaxyr from srdb.timeseries_values_view where ssb is not null group by assessid) as ssb, (select assessid, biovalue as recage from srdb.bioparams where bioid = 'REC-AGE-yr') as recage where r.assessid = ssb.assessid and recage.assessid=r.assessid) as a where assessid in (select * from srdb.science2009stocks);
