-- example queries
-- also see: /home/ricardd/linux_sync_folder/SQL/SQLpg/srDB/srDB/scripts/summaries-srDB.sql for many useful 
-- 'summary statistic' type queries on the srDB

\dt srdb.*;		--This lists the name of each table in the database. 'dt' is short for describe table
\d srdb.timeseries;	--This lists the name of each column in the timeseries table, and the columns that reference 
			--columns in other tables (which is how tables are linked together)	
select distinct tsid from srdb.timeseries;	--This lists each unique entry in the tsid column in the time series table	
select distinct bioid from  srdb.bioparams;  
select distinct bioid from  srdb.bioparams where bioid like '%Bmsy%';
select distinct tsunique from srdb.tsmetrics where tscategory like 'FISHING MORTALITY';

SELECT
recorder, count(*) as "total number of assessments in srDB"
FROM srdb.assessment
GROUP by recorder
ORDER BY count(*) DESC
;

select 
 	assessid, 
	tsyear, 
	count(*), 
	sum(CASE WHEN tsid = 'TB-MT' THEN tsvalue ELSE 0 END) as TB, 
	sum(CASE WHEN tsid = 'F-1/T' THEN tsvalue ELSE 0 END) as F 
from 
	srdb.timeseries 
group by 
	assessid, tsyear 
order by 
	assessid, tsyear
;


select 
	assessid, 
	tsyear, 
	count(*), 
	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' THEN tsvalue ELSE 0 END) as TB, 
	sum(CASE WHEN tscategory = 'FISHING MORTALITY' THEN tsvalue ELSE 0 END) as F 
from 
	srdb.timeseries, srdb.tsmetrics
where 
	tsid=tsunique
group by 
	assessid, tsyear 
order by 
	assessid, tsyear
;

\d srdb.tsmetrics;
-- what are the categories?
select distinct tscategory from srdb.tsmetrics;
select distinct tsunique from srdb.tsmetrics where tscategory = 'FISHING MORTALITY';


-- query to output completed assessments for Simon Jennings

select 
	st.commonname as common_name, 
	ar.areatype || '-' || ar.areacode as area_id,
	ar.areaname as area_name,
	pdffile as pdf
	--a.assessid
from 
	srdb.stock as st, 
	srdb.assessment as a, 
	srdb.area as ar
where 
	a.assessid like '%MINTO%'
and 
	a.stockid=st.stockid
and
	st.areaid=ar.areaid
order by
	common_name
;
