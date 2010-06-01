-- how many time-series metric of each category are availble in each assessment?
SELECT 
assessid,
SUM(TB) as TB,
SUM(SSB) as SSB,
SUM(R) as R,
SUM(C) as C,
SUM(F) as F
FROM
(
SELECT
assessid,
(CASE WHEN tscategory = 'TOTAL BIOMASS' THEN 1 ELSE 0 END) as TB,
(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' THEN 1 ELSE 0 END) as SSB,
(CASE WHEN tscategory = 'RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)' THEN 1 ELSE 0 END) as R,
(CASE WHEN tscategory = 'CATCH or LANDINGS' THEN 1 ELSE 0 END) as C,
(CASE WHEN tscategory = 'FISHING MORTALITY' THEN 1 ELSE 0 END) as F
FROM
(select aa.assessid, bb.tscategory, aa.tsid from srdb.timeseries aa, srdb.tsmetrics bb WHERE aa.tsid=bb.tsunique GROUP BY aa.assessid, bb.tscategory, aa.tsid) as a
) as b
GROUP BY 
assessid
;
