-- used for initial population of table "srdb.brptots"
-- Daniel Ricard 2010-03-15
-- Last modified Time-stamp: <2010-03-15 10:49:38 (srdbadmin)>
--
SELECT
 bp.assessid,
 b.biounique,
 max(t.tsunique)
 FROM
 srdb.bioparams bp,
 srdb.biometrics b,
 srdb.timeseries ts,
 srdb.tsmetrics t,
 srdb.assessment a
 WHERE
 a.assessid=bp.assessid AND
 bp.assessid =ts.assessid AND
 b.biounitsshort = t.tsunitsshort AND
 bp.assessid = ts.assessid AND
 b.biounique=bp.bioid AND
 t.tsunique=ts.tsid AND
 b.subcategory like '%REFERENCE%' AND
 (b.biounique like '%SB%' OR b.biounique like '%F%' OR b.biounique like
 '%U%') AND
 (t.tsunique like '%SB%' OR t.tsunique like '%F%' OR t.tsunique like '%U%')
 GROUP BY
 bp.assessid,
 b.biounique,
 a.recorder
 ORDER BY
 a.recorder,
 bp.assessid,
 b.biounique
 ;