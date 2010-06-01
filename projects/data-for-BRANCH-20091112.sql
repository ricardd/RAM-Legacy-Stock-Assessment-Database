-- a quick data extraction for Trevor Branch, for his talk at UW 
-- Time-stamp: <2009-11-12 15:04:31 (srdbadmin)>
-- invoked as follows: "psql srdb -A -F "," -f data-for-BRANCH-20091112.sql > data-for-BRANCH-20091112.csv"
SELECT
vi.assessid,
tt.commonname1,
tt.scientificname,
tt.family,
vi.tsyear,
vi.total,
vu.total_unit,
vi.ssb,
vu.ssb_unit
FROM
srdb.assessment aa,
srdb.stock ss,
srdb.taxonomy tt,
srdb.newtimeseries_values_view vi,
srdb.timeseries_units_view vu
WHERE 
vi.assessid = vu.assessid AND
vi.assessid = aa.assessid AND
aa.stockid = ss.stockid AND
ss.tsn = tt.tsn AND
vi.assessid in 
(select assessid from (SELECT assessid, min(tsyear) as minyr, max(tsyear) as maxyr FROM srdb.newtimeseries_values_view GROUP BY assessid) as a where minyr<=1977 and maxyr>=2004 )
ORDER BY
tt.scientificname,
vi.tsyear
;
