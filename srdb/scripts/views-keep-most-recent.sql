-- remove older assessments from the timeseries, so that only updated assessments are included
-- see "most-recent.sql" which determines which assessid is most recent
-- Last modified Time-stamp: <2011-06-27 10:48:02 (srdbadmin)>

-- remove from srdb.timeseries_values_view and srdb.timeseries_units_view
DELETE 
FROM
srdb.timeseries_values_view 
WHERE 
assessid not in 
(select assessid from srdb.mostrecent where ismostrecent = 1);

DELETE 
FROM
srdb.timeseries_units_view 
WHERE 
assessid not in 
(select assessid from srdb.mostrecent where ismostrecent = 1);

DELETE 
FROM
srdb.reference_point_values_view
WHERE 
assessid not in 
(select assessid from srdb.mostrecent where ismostrecent = 1);

DELETE 
FROM
srdb.reference_point_units_view
WHERE 
assessid not in 
(select assessid from srdb.mostrecent where ismostrecent = 1);

-- 
DELETE 
FROM
srdb.newtimeseries_values_view 
WHERE 
assessid not in 
(select assessid from srdb.mostrecent where ismostrecent = 1 and assessid not like '%MYERS');

-- 
DELETE 
FROM
srdb.tsrelative_explicit_view 
WHERE 
assessid not in 
(select assessid from srdb.mostrecent where ismostrecent = 1 and assessid not like '%MYERS');
