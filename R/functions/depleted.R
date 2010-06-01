# analyse depletion data for recovery project
# OJ, JB, CM
# Time-stamp: <2008-10-29 18:01:55 (mintoc)>

#~~~~~~~~~~~~~~~~~~~~
#queries on sql side
#~~~~~~~~~~~~~~~~~~~~
# what are the tables
\dt srdb.*;
\d srdb.bioparams;
select distinct bioid from  srdb.bioparams;
select distinct bioid from  srdb.bioparams where bioid like '%Bmsy%';


# individual queries
# reference points
select assessid, bioid, biovalue from  srdb.bioparams where bioid like '%Bmsy%';
# timeseries minima 
select t.assessid, min(t.tsvalue) from srdb.timeseries t, srdb.assessment a where tsid like 'SSB%' and a.assessid=t.assessid group by t.assessid;

# joining them
select t.assessid, min(t.tsvalue), res.bioid, res.biovalue from srdb.timeseries t, srdb.assessment a, (select assessid, bioid, biovalue from  srdb.bioparams where bioid like 'Bmsy%') res where tsid like 'TB%' and a.assessid=t.assessid and t.assessid=res.assessid group by t.assessid, res.bioid, res.biovalue;

# concatenate with the SSB output
select t.assessid, min(t.tsvalue), res.bioid, res.biovalue from srdb.timeseries t, srdb.assessment a, (select assessid, bioid, biovalue from  srdb.bioparams where bioid like 'SSBmsy%') res where tsid like 'SSB%' and a.assessid=t.assessid and t.assessid=res.assessid group by t.assessid, res.bioid, res.biovalue
union
select t.assessid, min(t.tsvalue), res.bioid, res.biovalue from srdb.timeseries t, srdb.assessment a, (select assessid, bioid, biovalue from  srdb.bioparams where bioid like 'Bmsy%') res where tsid like 'TB%' and a.assessid=t.assessid and t.assessid=res.assessid group by t.assessid, res.bioid, res.biovalue;

#select the assessments not selected in the inner select statement
(select distinct a.assessid from srdb.assessment a, srdb.timeseries ts where a.assessid not in (select distinct t.assessid from srdb.timeseries t, srdb.assessment a, (select assessid, bioid, biovalue from  srdb.bioparams where bioid like 'SSBmsy%') res where tsid like 'SSB%' and a.assessid=t.assessid and t.assessid=res.assessid) and a.assessid = ts.assessid);

# note that the "like" statement can handle regular expression patterns


select t.assessid, min(t.tsvalue), res.bioid, res.biovalue from srdb.timeseries t, srdb.assessment a, (select assessid, bioid, biovalue from  srdb.bioparams where bioid like 'SSBmsy%') res where tsid like 'SSB%' and a.assessid=t.assessid and t.assessid=res.assessid group by t.assessid, res.bioid, res.biovalue;

union

select t.assessid, min(t.tsvalue), res.bioid, res.biovalue from srdb.timeseries t, srdb.assessment a, (select assessid, bioid, biovalue from  srdb.bioparams where bioid like 'Bmsy%') res where tsid like 'TB%' and a.assessid=t.assessid and t.assessid=res.assessid group by t.assessid, res.bioid, res.biovalue;


# where ssb reference exists, don't want tb entry
select t.assessid, min(t.tsvalue) as minstock, res.bioid, res.biovalue from srdb.timeseries t, srdb.assessment a, (select assessid, bioid, biovalue from  srdb.bioparams where bioid like 'SSBmsy%') res where tsid like 'SSB%' and a.assessid=t.assessid and t.assessid=res.assessid group by t.assessid, res.bioid, res.biovalue
union
select t.assessid, min(t.tsvalue), res.bioid, res.biovalue from srdb.timeseries t, srdb.assessment a, (select assessid, bioid, biovalue from  srdb.bioparams where bioid like 'Bmsy%') res,
(select distinct a.assessid from srdb.assessment a, srdb.timeseries ts where a.assessid not in (select distinct t.assessid from srdb.timeseries t, srdb.assessment a, (select assessid, bioid, biovalue from  srdb.bioparams where bioid like 'SSBmsy%') res where tsid like 'SSB%' and a.assessid=t.assessid and t.assessid=res.assessid) and a.assessid = ts.assessid) tb
where tsid like 'TB%' and t.assessid=tb.assessid and t.assessid=res.assessid group by t.assessid, res.bioid, res.biovalue;


# collapsed stocks


create or replace view refs as (select t.assessid, min(t.tsvalue) as minstock, res.bioid, cast(cast(res.biovalue as float) as float) from srdb.timeseries t, srdb.assessment a, (select assessid, bioid, biovalue from  srdb.bioparams where bioid like 'SSBmsy%') res where tsid like 'SSB%' and a.assessid=t.assessid and t.assessid=res.assessid group by t.assessid, res.bioid, cast(res.biovalue as float)
union
select t.assessid, min(t.tsvalue), res.bioid, cast(res.biovalue as float) from srdb.timeseries t, srdb.assessment a, (select assessid, bioid, biovalue from  srdb.bioparams where bioid like 'Bmsy%') res,
(select distinct a.assessid from srdb.assessment a, srdb.timeseries ts where a.assessid not in (select distinct t.assessid from srdb.timeseries t, srdb.assessment a, (select assessid, bioid, biovalue from  srdb.bioparams where bioid like 'SSBmsy%') res where tsid like 'SSB%' and a.assessid=t.assessid and t.assessid=res.assessid) and a.assessid = ts.assessid) tb
where tsid like 'TB%' and t.assessid=tb.assessid and t.assessid=res.assessid group by t.assessid, res.bioid, cast(res.biovalue as float));



--drop view refs;

select * from refs where minstock < biovalue;

-- there are some non-numeric biovalues 
select * from refs where minstock < biovalue and biovalue !='SEE NOTES';

-- collapsed
select refs.assessid,
(CASE WHEN minstock < biovalue THEN 1 ELSE 0 END) as collapsed
from refs;

-- hard time with non integer values

select * from refs where biovalue !='SEE NOTES' and biovalue !='417,813';


select refs.assessid, (CASE WHEN minstock < cast(biovalue as float) THEN 1 ELSE 0 END) as collapsed
from refs where biovalue !='SEE NOTES' and biovalue !='417,813';

-- what is the fraction

select trim(trailing '0' from ((sum(coll.collapsed)))*1.0 / ((count(coll.collapsed)))*1.0) as percent_collapsed from (select (CASE WHEN minstock < cast(biovalue as float) THEN 1 ELSE 0 END) as collapsed from refs where biovalue !='SEE NOTES') as coll;





# what about the blanks?




select notes from srdb.assessment where assessid = 'DFO-HERR4VWX-1965-2006-PREFONTAINE';
