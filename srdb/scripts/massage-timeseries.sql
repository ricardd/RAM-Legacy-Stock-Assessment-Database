-- SQL code to normalize units of time-series data
-- to address Julia's requests for same units
-- Started 2008-11-12
-- Last modified Time-stamp: <2010-07-21 16:32:37 (srdbadmin)>

--------------------------------------------------------------------------
-- recruitment units
UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 0.001, tsid = 'R-E03'
WHERE tsid = 'R-E00';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 0.001, tsid = 'R-1-E03'
WHERE tsid = 'R-1-E00';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 0.001, tsid = 'R-2-E03'
WHERE tsid = 'R-2-E00';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 0.001, tsid = 'R-3-E03'
WHERE tsid = 'R-3-E00';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 0.001, tsid = 'R-4-E03'
WHERE tsid = 'R-4-E00';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'R-E03'
WHERE tsid = 'R-E06';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 10000, tsid = 'R-E03'
WHERE tsid = 'R-E07';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000000, tsid = 'R-E03'
WHERE tsid = 'R-E09';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000000000, tsid = 'R-E03'
WHERE tsid = 'R-E12';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'R-MT'
WHERE tsid = 'R-E03MT';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 0.001, tsid = 'R-E03'
WHERE tsid = 'R-E00fry';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 0.1, tsid = 'R-E03'
WHERE tsid = 'R-E02fry';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1, tsid = 'R-E03'
WHERE tsid = 'R-E03fry';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'R-E03'
WHERE tsid = 'R-E06fry';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 0.001, tsid = 'R-E03pertow'
WHERE tsid = 'R-E00pertow';

--------------------------------------------------------------------------
-- spawning stock biomass units

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 0.001, tsid = 'SSB-E03eggs'
WHERE tsid = 'SSB-E00eggs';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'SSB-E03eggs'
WHERE tsid = 'SSB-E06eggs';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 100000, tsid = 'SSB-E03eggs'
WHERE tsid = 'SSB-E08eggs';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000000, tsid = 'SSB-E03eggs'
WHERE tsid = 'SSB-E09eggs';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000000000, tsid = 'SSB-E03eggs'
WHERE tsid = 'SSB-E12eggs';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 0.00045359237, tsid = 'SSB-MT'
WHERE tsid = 'SSB-E00lbs';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'SSB-MT'
WHERE tsid = 'SSB-E03MT';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 100000, tsid = 'SSB-MT'
WHERE tsid = 'SSB-E05MT';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000000, tsid = 'SSB-MT'
WHERE tsid = 'SSB-E06MT';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 0.001, tsid = 'SSB-E03'
WHERE tsid = 'SSB-E00';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'SSB-relative'
WHERE tsid = 'SSB-E03relative';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 0.001, tsid = 'SSB-E03pertow'
WHERE tsid = 'SSB-E00pertow';


--------------------------------------------------------------------------
-- total abundance units and total biomass units
UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'TB-MT'
WHERE tsid = 'TB-E03MT';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'TN-E03'
WHERE tsid = 'TN-E06';


--------------------------------------------------------------------------
-- total catch units and total landing units
UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'TC-E03'
WHERE tsid = 'TC-E06';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'TC-1-E03'
WHERE tsid = 'TC-1-E06';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'TC-2-E03'
WHERE tsid = 'TC-2-E06';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'TC-3-E03'
WHERE tsid = 'TC-3-E06';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'TC-4-E03'
WHERE tsid = 'TC-4-E06';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'TC-MT'
WHERE tsid = 'TC-E03MT';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'TL-1-MT'
WHERE tsid = 'TL-1-E03MT';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 0.45359237, tsid = 'TL-MT'
WHERE tsid = 'TL-E03lbs';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'TL-MT'
WHERE tsid = 'TL-E03MT';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000000, tsid = 'TL-MT'
WHERE tsid = 'TL-E06MT';

UPDATE srdb.timeseries 
SET tsvalue = tsvalue * 1000, tsid = 'TL-E03'
WHERE tsid = 'TL-E06';

--------------------------------------------------------------------------
-- other
UPDATE srdb.timeseries
SET tsvalue = tsvalue * 1000, tsid = 'DIS-MT'
WHERE tsid = 'DIS-E03MT';


-- use the following query to test that all is good:
-- SELECT DISTINCT tsm.tscategory, ts.tsid from srdb.timeseries ts, srdb.tsmetrics tsm where ts.tsid=tsm.tsunique;
