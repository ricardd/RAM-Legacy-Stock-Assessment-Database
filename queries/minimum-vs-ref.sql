-- example query for a single stock
-- returns data about the minimum value of a time-series and its associated reference point
-- this example uses:
-- assessid: AFWG-CODNEAR-1943-2006-MINTO
-- TB metric and reference point: TB-1-MT and Blim-MT
SELECT t.assessid, t.mintb,b.refb, t.mintb/CAST(b.refb as float) as ratio
FROM
(SELECT 
a.assessid, min(ts.tsvalue) as mintb
FROM
srdb.assessment a,
srdb.timeseries ts
WHERE
a.assessid=ts.assessid AND
ts.tsid like '%TB%'-- ts.tsid = 'TB-1-MT' AND
-- a.assessid ='AFWG-CODNEAR-1943-2006-MINTO'
GROUP BY a.assessid
) as t,
(SELECT 
a.assessid, bi.biovalue as refb
FROM
srdb.assessment a,
srdb.bioparams bi
WHERE
a.assessid=bi.assessid AND
bi.bioid = 'Bmsy-MT'
-- bi.bioid = 'Blim-MT' -- AND
-- a.assessid ='AFWG-CODNEAR-1943-2006-MINTO'
) as b
WHERE t.assessid=b.assessid
;

