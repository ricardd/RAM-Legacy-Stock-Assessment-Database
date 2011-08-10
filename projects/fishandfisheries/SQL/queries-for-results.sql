--
-- usage: psql srdb -f queries-for-results.sql 1> queries-for-results.log
DROP TABLE fishfisheries.results;
DROP SCHEMA fishfisheries;
CREATE SCHEMA fishfisheries;
GRANT USAGE ON SCHEMA fishfisheries to srdbuser;

-- some function definitions
-- Median
CREATE OR REPLACE FUNCTION array_median(numeric[])
RETURNS numeric AS
$$
SELECT CASE WHEN array_upper($1,1) = 0 THEN null ELSE asorted[ceiling(array_upper(asorted,1)/2.0)] END
FROM (SELECT ARRAY(SELECT ($1)[n] FROM
generate_series(1, array_upper($1, 1)) AS n
WHERE ($1)[n] IS NOT NULL
ORDER BY ($1)[n]
) As asorted) As foo ;
$$
LANGUAGE 'sql' IMMUTABLE;
--
CREATE AGGREGATE median(numeric) (
SFUNC=array_append,
STYPE=numeric[],
FINALFUNC=array_median
);


-- DROP TABLE fishfisheries.results;

-- temporary sequence created for lme flag generation
CREATE TEMP sequence temp_seq;
CREATE TEMP sequence temp2_seq;
CREATE TEMP sequence temp3_seq;

CREATE TABLE fishfisheries.results
AS

(select CAST('REF:SQL:TOTNUMASSESSMENT' as varchar(100)) as flag, CAST(count(*) as varchar(10)) as value
from srdb.assessment
where recorder !='MYERS' and assess=1 and mostrecent='yes'
)
UNION
(
select 'REF:SQL:TOTNUMWITHOUTMODEL' as flag, CAST(count(*) as varchar(10)) as value
from
srdb.assessment aa
WHERE
aa.recorder !='MYERS' and aa.assess=0 and mostrecent='yes'
)
UNION
(select 'REF:SQL:TOTNUMASSESSFISH' as flag, CAST(count(*) as varchar(10)) as value
from 
srdb.assessment aa,
srdb.stock bb,
srdb.taxonomy tt
where tt.classname IN ('Chondrichthyes','Myxini','Actinopterygii') and
aa.recorder !='MYERS' and aa.assess=1  and mostrecent='yes' AND
aa.stockid=bb.stockid and
bb.tsn=tt.tsn
)
UNION
(select CAST(flag as varchar(100)), CAST(value as VARCHAR(10)) from (select 'REF:SQL:TOTNUMASSESSBYFISHSPECIES' as flag, count(*) as value from (select distinct ss.tsn from srdb.assessment aa, srdb.stock ss, srdb.taxonomy tt where ss.tsn=tt.tsn and tt.classname IN ('Chondrichthyes','Myxini','Actinopterygii') and aa.recorder != 'MYERS' and aa.assess=1 and mostrecent='yes' and aa.stockid=ss.stockid) as a) as b
)
UNION
(select CAST(flag as varchar(100)), CAST(value as VARCHAR(10)) from (select 'REF:SQL:TOTNUMASSESSBYINVERTSPECIES' as flag, count(*) as value from (select distinct ss.tsn from srdb.assessment aa, srdb.stock ss, srdb.taxonomy tt where ss.tsn=tt.tsn and tt.classname NOT IN ('Chondrichthyes','Myxini','Actinopterygii') and aa.recorder != 'MYERS' and aa.assess=1 and mostrecent='yes' and aa.stockid=ss.stockid) as a) as b
)
UNION
(select 'REF:SQL:TOTNUMFISHFAMILIES' as flag, CAST(count(distinct tt.family) as varchar(10)) as value
from 
srdb.assessment aa,
srdb.stock bb,
srdb.taxonomy tt
where tt.classname IN ('Chondrichthyes','Myxini','Actinopterygii') and
aa.recorder !='MYERS' and aa.assess=1  and mostrecent='yes' AND
aa.stockid=bb.stockid and
bb.tsn=tt.tsn
)
UNION
(select CAST('REF:SQL:TOTNUMASSESSINVERT' as varchar(100)) as flag, CAST(count(*) as varchar(10)) as value
from 
srdb.assessment aa,
srdb.stock bb,
srdb.taxonomy tt
where tt.classname IN ('Merostomata','Malacostraca','Gastropoda','Bivalvia','Cephalopoda') and
aa.recorder !='MYERS' and aa.assess=1  and mostrecent='yes' AND
aa.stockid=bb.stockid and
bb.tsn=tt.tsn
)
UNION
(select CAST('REF:SQL:TOTNUMINVERTFAMILIES' as varchar(100)) as flag, CAST(count(distinct tt.family) as varchar(10)) as value
from 
srdb.assessment aa,
srdb.stock bb,
srdb.taxonomy tt
where tt.classname IN ('Merostomata','Malacostraca','Gastropoda','Bivalvia','Cephalopoda') and
aa.recorder !='MYERS' and aa.assess=1  and mostrecent='yes' AND
aa.stockid=bb.stockid and
bb.tsn=tt.tsn
)
UNION
(
select CAST(flag as varchar(100)), CAST(value as VARCHAR(10)) from (select 'REF:SQL:TOTNUMASSESS' || mgmt as flag, mgmt, managementauthority, count(*) as value from (select mm.mgmt, mm.managementauthority, ass.assessid from srdb.assessor aa,  srdb.management mm, srdb.assessment ass where ass.recorder != 'MYERS' and ass.assess=1 and mostrecent='yes' and aa.mgmt=mm.mgmt and aa.assessorid = ass.assessorid) as a group by mgmt, managementauthority) as b
)
UNION
(
select CAST(flag as varchar(100)), CAST(value as VARCHAR(10)) from (select 'REF:SQL:TOTNUMASSESSBYSPECIES' as flag, count(*) as value from (select distinct ss.tsn from srdb.assessment aa, srdb.stock ss where aa.recorder != 'MYERS' and aa.assess=1 and mostrecent='yes' and aa.stockid=ss.stockid) as a) as b
)
UNION
(
 select CAST(flag as varchar(100)), CAST(value as VARCHAR(10)) from (select 'REF:SQL:TOTNUMASSESSBYORDERS' as flag, count(*) as value from (select distinct tt.ordername from srdb.assessment aa, srdb.stock ss, srdb.taxonomy tt where aa.recorder != 'MYERS' and aa.assess=1 and mostrecent='yes' and aa.stockid=ss.stockid and ss.tsn=tt.tsn) as a) as b
)
UNION
(
select dd.flag || ':' || dd.row_number as flag, dd.value from (SELECT CAST(nextval('temp3_seq') as varchar(100)) As row_number, CAST('REF:SQL:NUMASSESSORDERS' as varchar(100)) as flag, CAST(c.value as VARCHAR(100)) from (select a.ordername || ' (n=' || a.ct || ')' as value from (select t.ordername, count(*) as ct from srdb.taxonomy t, srdb.stock s, srdb.assessment a where t.tsn=s.tsn and s.stockid=a.stockid and a.recorder != 'MYERS' and a.assess=1 and mostrecent='yes' group by t.ordername order by count(*) desc ) as a ) as c limit 7) as dd)
UNION
(
 select CAST(flag as varchar(100)), CAST(value as VARCHAR(10)) from (select 'REF:SQL:TOTNUMASSESSBYFAMILY' as flag, count(*) as value from (select distinct tt.family from srdb.assessment aa, srdb.stock ss, srdb.taxonomy tt where aa.recorder != 'MYERS' and aa.assess=1 and mostrecent='yes' and aa.stockid=ss.stockid and ss.tsn=tt.tsn) as a) as b
)
UNION 
(
 select CAST(flag as varchar(100)), CAST(value as VARCHAR(10)) from (select 'REF:SQL:TOTNUMCOUNTRIES' as flag, count(distinct mm.country)-1 as value from srdb.management mm, srdb.assessor aa, srdb.assessment a where a.assessorid=aa.assessorid and aa.mgmt=mm.mgmt and a.recorder != 'MYERS' and a.assess=1 and mostrecent='yes' ) as a
)
UNION
(
 select CAST(flag as varchar(100)), CAST(value as VARCHAR(10)) from (select 'REF:SQL:TOTNUMMGMT' as flag, count(distinct mm.managementauthority) as value from srdb.management mm, srdb.assessor aa, srdb.assessment a where a.assessorid=aa.assessorid and aa.mgmt=mm.mgmt and a.recorder != 'MYERS' and a.assess=1 and mostrecent='yes' ) as a
)
UNION
(
 select CAST(flag as varchar(100)), CAST(value as VARCHAR(10)) from (select 'REF:SQL:TOTNUMLMESPRIMARY' as flag, count(distinct lme_number) as value from (select distinct lme_number from srdb.lmetostocks where lme_number >0 and stocktolmerelation = 'primary' and stockid in (select stockid from srdb.assessment where assess=1 and recorder !='MYERS' and mostrecent='yes')) as a) as b
)
UNION
(
select dd.flag || ':' || dd.row_number as flag, dd.value from (SELECT CAST(nextval('temp_seq') as varchar(100)) As row_number, CAST('REF:SQL:NUMASSESSLME' as varchar(100)) as flag, CAST(c.value as VARCHAR(100)) from (select lr.lme_name || ' (n=' || a.ct || ')' as value from srdb.lmerefs lr, (select ls.lme_number, count(*) as ct from srdb.lmetostocks ls, srdb.assessment aa where aa.stockid=ls.stockid and aa.recorder != 'MYERS' and aa.assess=1 and mostrecent='yes' group by lme_number) as a where lr.lme_number=a.lme_number order by ct desc) as c limit 7) as dd
)
UNION
(
select CAST('REF:SQL:MEDCATCHLEN' as varchar(100)) as flag, median as value from (select CAST(median(span) as varchar(100)) from (select assessid, max(tsyear)-min(tsyear) as span from srdb.newtimeseries_values_view where catch_landings is not null group by assessid) as aa) as bb
)
UNION
(
select CAST('REF:SQL:MEDSSBLEN' as varchar(100)) as flag, median as value from (select CAST(median(span) as varchar(100)) from (select assessid, max(tsyear)-min(tsyear) as span from srdb.newtimeseries_values_view where ssb is not null group by assessid) as aa) as bb
)
UNION
(
select CAST('REF:SQL:MEDRLEN' as varchar(100)) as flag, median as value from (select CAST(median(span) as varchar(100)) from (select assessid, max(tsyear)-min(tsyear) as span from srdb.newtimeseries_values_view where r is not null group by assessid) as aa) as bb
)
UNION
(
select cast('REF:SQL:NUMCATCHSERIES' as varchar(100)) as flag, cast(count(assessid) as varchar(100)) as value from (select distinct assessid from srdb.newtimeseries_values_view where catch_landings is not null and assessid in (select assessid from srdb.assessment where assess=1 and recorder !='MYERS' and mostrecent='yes')) as aa
)
UNION
(
select cast('REF:SQL:NUMSSBSERIES' as varchar(100)) as flag, cast(count(assessid) as varchar(100)) as value from (select distinct assessid from srdb.newtimeseries_values_view where ssb is not null and assessid in (select assessid from srdb.assessment where assess=1 and recorder !='MYERS' and mostrecent='yes')) as aa
)
UNION
(
select cast('REF:SQL:NUMRSERIES' as varchar(100)) as flag, cast(count(assessid) as varchar(100)) as value from (select distinct assessid from srdb.newtimeseries_values_view where r is not null and assessid in (select assessid from srdb.assessment where assess=1 and recorder !='MYERS' and mostrecent='yes')) as aa
)
UNION
(
select cast('REF:SQL:NUMASSESSBIOREF' as varchar(100)) as flag, cast(count(distinct b.assessid) as varchar(100)) as value from srdb.assessment a, srdb.bioparams b where b.bioid in (select biounique from srdb.biometrics where a.assessid = b.assessid AND biounique like '%B%' and subcategory = 'REFERENCE POINTS ETC.') and a.recorder != 'MYERS' and a.assess=1 and mostrecent='yes' 
)
UNION
(
select cast('REF:SQL:PERCENTASSESSBIOREF' as varchar(100)) as flag, cast((num.numassessmentref*100)/(den.totnumassessments*1) as varchar(100)) as value from (select count(distinct b.assessid) as numassessmentref from srdb.assessment a, srdb.bioparams b where b.bioid in (select biounique from srdb.biometrics where a.assessid = b.assessid AND biounique like '%B%' and subcategory = 'REFERENCE POINTS ETC.') and a.recorder != 'MYERS') as num, (select count(*) as totnumassessments from srdb.assessment where recorder != 'MYERS' and assess=1 and mostrecent='yes' ) as den
-- Dan, can you check this?
-- select cast('REF:SQL:PERCENTASSESSBIOREF' as varchar(100)) as flag, cast(ROUND(100.0*SUM(case when sumval > 0 then 1 else 0 end)/count(assessid),2) as varchar(100)) as value from (select assessid, sum(val) as sumval from (select a.assessid, (case when a.bioid like '%B%' and b.subcategory='REFERENCE POINTS ETC.' then 1 else 0 end) as val from srdb.bioparams a, srdb.biometrics b where assessid in (select distinct(a.assessid) from srdb.bioparams a, srdb.biometrics b, srdb.assessment c where a.assessid=c.assessid and a.bioid=b.biounique and c.recorder != 'MYERS') and a.bioid=b.biounique group by a.assessid, a.bioid, b.subcategory) as aa group by assessid) as bb
)
UNION
(
select cast('REF:SQL:NUMASSESSEXPLOITREF' as varchar(100)) as flag, cast(count(distinct b.assessid) as varchar(100)) as value from srdb.assessment a, srdb.bioparams b where b.bioid in (select biounique from srdb.biometrics where a.assessid = b.assessid AND (biounique like '%F%' or biounique like '%U%') and subcategory = 'REFERENCE POINTS ETC.') and a.recorder != 'MYERS' and a.assess=1 and mostrecent='yes' 
--select cast('REF:SQL:NUMASSESSEXPLOITREF' as varchar(100)), cast(count(distinct cc.assessid) as varchar(100)) as value from ((select aa.assessid, aa.bioid, bb.bioshort, aa.biovalue from srdb.bioparams as aa, srdb.biometrics as bb where aa.bioid=bb.biounique and bb.subcategory='REFERENCE POINTS ETC.' and bioshort LIKE '%F%') UNION (select aa.assessid, aa.bioid, bb.bioshort, aa.biovalue from srdb.bioparams as aa, srdb.biometrics as bb where aa.bioid=bb.biounique and bb.subcategory='REFERENCE POINTS ETC.' and bioshort LIKE '%U%')) as cc
)
UNION
(
select cast('REF:SQL:PERCENTASSESSEXPLOITREF' as varchar(100)) as flag, cast((num.numassessmentref*100)/(den.totnumassessments*1) as varchar(100)) as value from (select count(distinct b.assessid) as numassessmentref from srdb.assessment a, srdb.bioparams b where b.bioid in (select biounique from srdb.biometrics where a.assessid = b.assessid AND (biounique like '%F%' OR biounique like '%U%') and subcategory = 'REFERENCE POINTS ETC.') and a.recorder != 'MYERS') as num, (select count(*) as totnumassessments from srdb.assessment where recorder != 'MYERS' and assess=1 and mostrecent='yes' ) as den
-- Dan to check -want the percentage of stocks with exploitation reference points
--select 
--cast('REF:SQL:PERCENTASSESSEXPLOITREF' as varchar(100)), 
--cast(ROUND(100.0*SUM(case when sumval > 0 then 1 else 0 end)/count(assessid),2) as varchar(100)) as value 
--from 
--(select assessid, sum(val) as sumval 
--from 
--((select a.assessid, (case when a.bioid like '%F%' and b.subcategory='REFERENCE POINTS ETC.' then 1 else 0 end) as val from srdb.bioparams a, srdb.biometrics b where assessid in (select distinct(a.assessid) from srdb.bioparams a, srdb.biometrics b, srdb.assessment c where a.assessid=c.assessid and a.bioid=b.biounique and c.recorder != 'MYERS') and a.bioid=b.biounique group by a.assessid, a.bioid, b.subcategory) union (select a.assessid, (case when a.bioid like '%U%' and b.subcategory='REFERENCE POINTS ETC.' then 1 else 0 end) as val from srdb.bioparams a, srdb.biometrics b where assessid in (select distinct(a.assessid) from srdb.bioparams a, srdb.biometrics b, srdb.assessment c where a.assessid=c.assessid and a.bioid=b.biounique and c.recorder != 'MYERS') and a.bioid=b.biounique group by a.assessid, a.bioid, b.subcategory))
--as aa group by assessid)
--as bb
)
UNION
-- assessment methods
(SELECT dd.flag || ':' || dd.row_number as flag, dd.value from (select CAST(nextval('temp2_seq') as varchar(100)) as row_number, CAST('REF:SQL:NUMASSESSMETHOD' as varchar(100)) as flag, CAST(ct as varchar(100)) as value from (select a.category || ' (n=' || count(*) || ')' as ct from (select (CASE when am.category in ('Integrated Analysis','Statistical catch at age model', 'Statistical catch at length model') THEN 'Statistical catch-at-age/length models' ELSE (CASE WHEN am.category='VPA' THEN 'Virtual Population Analyses' ELSE (CASE WHEN am.category='' THEN 'Biomass dynamics models' ELSE am.category END) END) END) as category from srdb.assessment aa, srdb.assessmethod am where aa.assessmethod=am.methodshort and aa.recorder != 'MYERS' and aa.assess=1 and mostrecent='yes') as a group by a.category order by count(*) desc) as c) as dd  limit 3)
UNION
-- assessments with life-history data
(
select cast('REF:SQL:NUMASSESSLIFE' as varchar(100)) as flag, cast(count(distinct b.assessid) as varchar(100)) as value from srdb.assessment a, srdb.bioparams b where b.bioid in (select biounique from srdb.biometrics where a.assessid = b.assessid AND subcategory = 'LIFE HISTORY') and a.recorder != 'MYERS' and a.assess=1 and mostrecent='yes' )
;


ALTER TABLE fishfisheries.results 
ADD PRIMARY KEY (flag);

DROP SEQUENCE temp_seq;

DROP SEQUENCE temp2_seq;

DROP SEQUENCE temp3_seq;


-- (select m.managementauthority, aa.assess, (CASE when am.category in ('Integrated Analysis','Statistical catch at age model', 'Statistical catch at length model') THEN 'SCA' ELSE am.category END) as category, am.methodshort, aa.assessid, aa.assessorid from srdb.assessment aa, srdb.assessmethod am, srdb.assessor a, srdb.management m where m.mgmt=a.mgmt and a.assessorid=aa.assessorid and aa.assessmethod=am.methodshort and aa.recorder != 'MYERS' order by aa.assess, am.category);

 

GRANT SELECT ON fishfisheries.results TO srdbuser ;
