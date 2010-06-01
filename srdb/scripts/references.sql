-- build a readable string from the referencedocs table contents
-- Last modified Time-stamp: <2009-12-01 13:59:29 (srdbadmin)>
--
DROP TABLE srdb.citation;
CREATE TABLE srdb.citation AS
(
SELECT
a.assessid, 
assess.pdffile,
min(a.risentry || ' (' || y.risentry || ') ' || t.risentry) as citation
FROM
 (select assessid, risentry from srdb.referencedoc where risfield='T1') as t,
 (select assessid, risentry from srdb.referencedoc where risfield='A1') as a,
 (select assessid, risentry from srdb.referencedoc where risfield='Y1') as y,
 srdb.assessment assess
WHERE
t.assessid=a.assessid and
a.assessid=y.assessid and
assess.assessid=t.assessid
group by a.assessid, assess.pdffile
)
;


select 
rd.assessid, 
(CASE WHEN ct.ct = 1 THEN rd.risentry ELSE (rd.risentry || ' et al.') END)
from 
srdb.referencedoc rd, 
(select assessid, count(*) as ct from srdb.referencedoc where risfield = 'A1' group by assessid) ct 
where 
risfield = 'A1' and 
ct.assessid=rd.assessid
;
