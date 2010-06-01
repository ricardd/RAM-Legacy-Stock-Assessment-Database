-- example query for a single stock
-- produce data suitable for phase-plane analysis
-- recode the ratio of SSB and F to reference points and assign to 4 categories
-- this example uses:
-- assessid: AFWG-CODNEAR-1943-2006-MINTO
-- SSB metric and reference point: SSB-1-MT and Blim-MT
-- F metric and reference point: F-1-1/T and Flim-1/yr

select assessid, tsyear, bts/(CAST(bref AS FLOAT)) as Brel, fts/(CAST(fref AS FLOAT)) as Frel
FROM
(
select bts.assessid, bts.tsyear, bts.tsvalue as bts, bref.biovalue as bref, fts.tsvalue as fts, fref.biovalue as fref
FROM
(SELECT
ts.assessid, 
ts.tsyear,
ts.tsvalue
FROM
srdb.timeseries ts
WHERE
ts.assessid = 'AFWG-CODNEAR-1943-2006-MINTO' AND
ts.tsid = 'SSB-1-MT'
) as bts,
(SELECT 
bi.assessid,
bi.biovalue
FROM 
srdb.bioparams bi
WHERE
bi.assessid = 'AFWG-CODNEAR-1943-2006-MINTO' AND
bi.bioid = 'Blim-MT'
) as bref,
(SELECT
ts.assessid, 
ts.tsyear,
ts.tsvalue
FROM
srdb.timeseries ts
WHERE
ts.assessid = 'AFWG-CODNEAR-1943-2006-MINTO' AND
ts.tsid = 'F-1-1/T'
) as fts,
(SELECT 
bi.assessid,
bi.biovalue
FROM 
srdb.bioparams bi
WHERE
bi.assessid = 'AFWG-CODNEAR-1943-2006-MINTO' AND
bi.bioid = 'Flim-1/yr'
) as fref
WHERE bts.tsyear=fts.tsyear
) as a
;

