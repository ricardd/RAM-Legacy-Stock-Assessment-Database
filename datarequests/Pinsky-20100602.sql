-- data extraction for Malin Pinsky
--
-- notes from Skype call on June 02 2010
--
--each stock a line
--each column is a year
--ratios in there

-- get the stocks that have an MSY reference point
-- one of SSB or TB, just one, with a reference point, if they both have reference points, chose SSB preferentially

---no SSB but TB and Bmsy
--1950 to the present

--after the fact, Malin trims out non-species and does manual edits for scientific names that are not in fishbase
-- WHAT ARE THOSE SPECIES?

-- + compare the trophic leve data that I have with his + add other life-history characterisics

-- query to obtain BRPs from the assessments
SELECT 
a.assessid,
a.stockid,
t.scientificname,
s.stocklong,
v.tsyear,
v.biovalue,
v.bioid as type,
v.tsid,
v.tsvalue,
v.tstobrpratio
FROM 
srdb.tsrelative_explicit_view v,
srdb.assessment a,
srdb.stock s,
srdb.taxonomy t
WHERE
v.assessid=a.assessid AND
a.stockid = s.stockid and 
s.tsn = t.tsn AND
v.bioid like '%Bmsy%'
;


-- query to obtain BRPs from the surplus production models

SELECT
a.assessid,
a.stockid,
t.scientificname,
s.stocklong,
sp.bmsy,
'Schaefer Bmsy' as type,
tsv.ssb,
tsv.total,
tsv.total/sp.bmsy as ratio
FROM
srdb.assessment a,
srdb.stock s,
srdb.taxonomy t,
srdb.spfits sp,
srdb.timeseries_values_view tsv
WHERE
sp.assessid=a.assessid AND
a.stockid = s.stockid AND
s.tsn=t.tsn AND
a.assessid = tsv.assessid
;
