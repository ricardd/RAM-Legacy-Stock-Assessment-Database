-- views for stock-recruitment database
-- original code by Coilin Minto
-- Time-stamp: <2010-03-23 12:10:14 (srdbadmin)>
-- Modification history:
-- 2009-03-18: <ricardd> on Olaf's request, creating a new view that doesn't contain RAM's original data
-- 2010-02-12: <ricardd> adding a new view of timeseries relative to reference points 
-- 2010-03-23: <ricardd> rewrote the reference points views, old definitions were moved to "srDB-views-old.sql"
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- time series values view 
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CREATE LANGUAGE plpgsql;
CREATE or REPLACE FUNCTION srdb.srdb_metric_boolean(category text, metric text, assessment text)
-- returns a true/false if metric exists, used in create table below
-- 1st argument is tsmetric category
-- 2nd argument is metric e.g. TB-MT
-- 3rd argumant is assessid 
RETURNS boolean AS $$
DECLARE
	result boolean;
	sqlquery text;
BEGIN
sqlquery:=  
	'select (count(distinct tsid)!=0) 
	from srdb.timeseries as ts1, srdb.tsmetrics
	where 
	tscategory =' || quote_literal(category)  || ' AND
	ts1.assessid='    || quote_literal(assessment)|| ' AND
	tsunique='    || quote_literal(metric)|| ' AND
	ts1.tsid=tsunique';
EXECUTE sqlquery
INTO result;
return result;
END;
$$ language plpgsql;


drop table srdb.timeseries_values_view;
create table srdb.timeseries_values_view as

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
-- code makes sure only a single time series is returned from the query i.e. no double summation!
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
select 	assessid, 
	tsyear,
	pt_avail,
	ssb,
	r,
	total,
	f,
	cpue,
	catch_landings
from 
(select 
	ts.assessid,
	tsyear, 
	count(*) as pt_avail,-- count of available timeseries for assessment
	--~~~~~~~~~~~~~~~~~~~~~ Spawning stock biomass~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-MT', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-MT') THEN tsvalue ELSE NULL END)
	-- if SSB-MT is not there, have a look for the others
	else
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-1-MT', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-1-MT') THEN tsvalue ELSE NULL END)
	-- if SSB-1-MT is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-E03', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-E03') THEN tsvalue ELSE NULL END)
	-- if SSB-E03 is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-E03eggs', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-E03eggs') THEN tsvalue ELSE NULL END)
	else  
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-E06larvae', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-E06larvae') THEN tsvalue ELSE NULL END)
	-- if TN-E03 is not there, have a look for the SSB-relative
	else  
	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-relative') THEN tsvalue ELSE NULL END)
	end
	end
	end
	end
	end
	as ssb,
	--~~~~~~~~~~~~~~~~~~~~~ Count of spawning stock biomass~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-MT', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-MT') THEN tsvalue ELSE NULL END)
	-- if SSB-MT is not there, have a look for the others
	else
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-1-MT', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-1-MT') THEN tsvalue ELSE NULL END)
	-- if SSB-1-MT is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-E03', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-E03') THEN tsvalue ELSE NULL END)
	-- if SSB-E03 is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-E03eggs', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-E03eggs') THEN tsvalue ELSE NULL END)
	else  
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-E06larvae', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-E06larvae') THEN tsvalue ELSE NULL END)
	-- if TN-E03 is not there, have a look for the SSB-relative
	else  
	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-relative') THEN tsvalue ELSE NULL END)
	end
	end
	end
	end
	end
	as ssb_count,
	--~~~~~~~~~~~~~~~~~~~~~ Recruitment ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)', 'R-MT', ts.assessid) 
	THEN
 	sum(CASE WHEN tscategory = 'RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)' AND (tsunique = 'R-MT') THEN tsvalue ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)', 'R-E03', ts.assessid) 
	THEN
 	sum(CASE WHEN tscategory = 'RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)' AND (tsunique = 'R-E03') THEN tsvalue ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)', 'R-1-E03', ts.assessid) --change to R-1-E03
	THEN
 	sum(CASE WHEN tscategory = 'RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)' AND (tsunique = 'R-1-E03') THEN tsvalue ELSE NULL END)
	else  
	sum(CASE WHEN tscategory = 'RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)' AND (tsunique = 'R-relative') THEN tsvalue ELSE NULL END)
	end
	end
	end
	as r,
	--~~~~~~~~~~~~~~~~~~~~~ Count of recruitment ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)', 'R-MT', ts.assessid) 
	THEN
 	count(CASE WHEN tscategory = 'RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)' AND (tsunique = 'R-MT') THEN tsvalue ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)', 'R-E03', ts.assessid) 
	THEN
 	count(CASE WHEN tscategory = 'RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)' AND (tsunique = 'R-E03') THEN tsvalue ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)', 'R-1-E03', ts.assessid) --change to R-1-E03
	THEN
 	count(CASE WHEN tscategory = 'RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)' AND (tsunique = 'R-1-E03') THEN tsvalue ELSE NULL END)
	else  
	count(CASE WHEN tscategory = 'RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)' AND (tsunique = 'R-relative') THEN tsvalue ELSE NULL END)
	end
	end
	end
	as r_count,
	--~~~~~~~~~~~~~~~~~~~~~ Total biomass~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('TOTAL BIOMASS', 'TB-MT', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-MT') THEN tsvalue ELSE NULL END)
	-- if TB-MT is not there, have a look for the others
	else
	case when 
	srdb_metric_boolean('TOTAL BIOMASS', 'TB-1-MT', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-1-MT') THEN tsvalue ELSE NULL END)
	-- if TB-1-MT is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('TOTAL BIOMASS', 'TB-relative', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-relative') THEN tsvalue ELSE NULL END)
	-- if TB-relative is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('TOTAL BIOMASS', 'TN-E03', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TN-E03') THEN tsvalue ELSE NULL END)
	-- if TN-E03 is not there, have a look for the TN-relative
	else  
	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TN-relative') THEN tsvalue ELSE NULL END)
	end
	end
	end
	end
	as total,
	--~~~~~~~~~~~~~~~~~~~~~ Count of total biomass~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('TOTAL BIOMASS', 'TB-MT', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	count(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-MT') THEN tsvalue ELSE NULL END)
	-- if TB-MT is not there, have a look for the others
	else
	case when 
	srdb_metric_boolean('TOTAL BIOMASS', 'TB-1-MT', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-1-MT') THEN tsvalue ELSE NULL END)
	-- if TB-1-MT is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('TOTAL BIOMASS', 'TB-relative', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-relative') THEN tsvalue ELSE NULL END)
	-- if TB-relative is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('TOTAL BIOMASS', 'TN-E03', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TN-E03') THEN tsvalue ELSE NULL END)
	-- if TN-E03 is not there, have a look for the TN-relative
	else  
	count(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TN-relative') THEN tsvalue ELSE NULL END)
	end
	end
	end
	end
	as total_count,
	--~~~~~~~~~~~~~~~~~~~~~ Fishing mortality ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'F-1/T', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	sum(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'F-1/T') THEN tsvalue ELSE NULL END)
	-- if TB-MT is not there, have a look for the others
	else
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'F-1/yr', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'F-1/yr') THEN tsvalue ELSE NULL END)
	-- if TB-1-MT is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'F-1-1/T', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'F-1-1/T') THEN tsvalue ELSE NULL END)
	-- if TB-relative is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'F-unweighted-1/T', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'F-unweighted-1/T') THEN tsvalue ELSE NULL END)
	else  
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'ER-ratio', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'ER-ratio') THEN tsvalue ELSE NULL END)
	-- if TN-E03 is not there, have a look for the TN-relative
	else  
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'ER-1-ratio', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'ER-1-ratio') THEN tsvalue ELSE NULL END)
	-- if TN-E03 is not there, have a look for the TN-relative
	else  
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'ER-none', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'ER-none') THEN tsvalue ELSE NULL END)
	-- if TN-E03 is not there, have a look for the TN-relative
	else  
	sum(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'EI-ratio') THEN tsvalue ELSE NULL END)
	end
	end
	end
	end
	end
	end
	end
	as f,
	--~~~~~~~~~~~~~~~~~~~~~ Count of fishing mortality ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'F-1/T', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	count(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'F-1/T') THEN tsvalue ELSE NULL END)
	-- if TB-MT is not there, have a look for the others
	else
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'F-1/yr', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'F-1/yr') THEN tsvalue ELSE NULL END)
	-- if TB-1-MT is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'F-1-1/T', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'F-1-1/T') THEN tsvalue ELSE NULL END)
	-- if TB-relative is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'F-unweighted-1/T', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'F-unweighted-1/T') THEN tsvalue ELSE NULL END)
	else  
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'ER-ratio', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'ER-ratio') THEN tsvalue ELSE NULL END)
	-- if TN-E03 is not there, have a look for the TN-relative
	else  
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'ER-none', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'ER-none') THEN tsvalue ELSE NULL END)
	-- if TN-E03 is not there, have a look for the TN-relative
	else  
	count(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'EI-ratio') THEN tsvalue ELSE NULL END)
	end
	end
	end
	end
	end
	end
	as f_count,
	--~~~~~~~~~~~~~~~~~~~~~ Catch per unit effort ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'CPUEraw-C/E', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-C/E') THEN tsvalue ELSE NULL END)
	-- if SSB-MT is not there, have a look for the others
	else
	case when
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'CPUEraw-C/E', ts.assessid)
	THEN
	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-2-C/E') THEN tsvalue ELSE NULL END)
	ELSE
	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUE-kgpertow') THEN tsvalue ELSE NULL END)
	end
	end
	as cpue,
	--~~~~~~~~~~~~~~~~~~~~~ Count of catch per unit effort ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'CPUEraw-C/E', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-C/E') THEN tsvalue ELSE NULL END)
	-- if SSB-MT is not there, have a look for the others
	else
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'CPUEraw-C/E', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-2-C/E') THEN tsvalue ELSE NULL END)
	ELSE
	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUE-kgpertow') THEN tsvalue ELSE NULL END)
	end
	end
	as cpue_count,
	--~~~~~~~~~~~~~~~~~~~~~ Catch or landings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TC-MT', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	sum(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TC-MT') THEN tsvalue ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TL-MT', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TL-MT') THEN tsvalue ELSE NULL END)
	else  
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TC-1-MT', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TC-1-MT') THEN tsvalue ELSE NULL END)
	else  
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TL-1-MT', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TL-1-MT') THEN tsvalue ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TC-E03', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TC-E03') THEN tsvalue ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TL-E03', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TL-E03') THEN tsvalue ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TC-1-E03', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TC-1-E03') THEN tsvalue ELSE NULL END)
	else 
	sum(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TL-1-E03') THEN tsvalue ELSE NULL END)
	end
	end
	end
	end
	end
	end
	end
	as catch_landings,
	--~~~~~~~~~~~~~~~~~~~~~ Count of catch or landings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TC-MT', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	count(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TC-MT') THEN tsvalue ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TL-MT', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TL-MT') THEN tsvalue ELSE NULL END)
	else  
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TC-1-MT', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TC-1-MT') THEN tsvalue ELSE NULL END)
	else  
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TL-1-MT', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TL-1-MT') THEN tsvalue ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TC-E03', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TC-E03') THEN tsvalue ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TL-E03', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TL-E03') THEN tsvalue ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TC-1-E03', ts.assessid)
	THEN
 	count(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TC-1-E03') THEN tsvalue ELSE NULL END)
	else 
	count(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TL-1-E03') THEN tsvalue ELSE NULL END)
	end
	end
	end
	end
	end
	end
	end
	as catch_landings_count
from 
	srdb.timeseries as ts, srdb.tsmetrics as tm
where 
	tsid=tsunique
--and 
--	ts.assessid='AFWG-CODNEAR-1943-2006-MINTO'
group by 
	assessid, tsyear
order by 
	assessid, tsyear) as tsview_with_counts
where
	ssb_count<2 
and
	r_count <2 
and 
	total_count <2 
and  
	f_count <2 
and 
	cpue_count <2 
and 
	catch_landings_count <2
--limit 1000
;


CREATE OR REPLACE VIEW srdb.timeseries_units_view AS
select 
	ts.assessid,
	count(*),-- count of available timeseries for assessment
	--~~~~~~~~~~~~~~~~~~~~~ Spawning stock biomass~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-MT', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	min(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-MT') THEN tsunitsshort ELSE NULL END)
	-- if SSB-MT is not there, have a look for the others
	else
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-1-MT', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-1-MT') THEN tsunitsshort ELSE NULL END)
	-- if SSB-1-MT is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-E03', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-E03') THEN tsunitsshort ELSE NULL END)
	-- if SSB-E03 is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-E03eggs', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-E03eggs') THEN tsunitsshort ELSE NULL END)
	else  
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-E06larvae', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-E06larvae') THEN tsunitsshort ELSE NULL END)
	-- if TN-E03 is not there, have a look for the SSB-relative
	else  
	min(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-relative') THEN tsunitsshort ELSE NULL END)
	end
	end
	end
	end
	end
	as "ssb_unit",
	--~~~~~~~~~~~~~~~~~~~~~ Recruitment ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)', 'R-MT', ts.assessid) 
	THEN
 	min(CASE WHEN tscategory = 'RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)' AND (tsunique = 'R-MT') THEN tsunitsshort ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)', 'R-E03', ts.assessid) 
	THEN
 	min(CASE WHEN tscategory = 'RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)' AND (tsunique = 'R-E03') THEN tsunitsshort ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)', 'R-1-E03', ts.assessid) --change to R-1-E03
	THEN
 	min(CASE WHEN tscategory = 'RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)' AND (tsunique = 'R-1-E03') THEN tsunitsshort ELSE NULL END)
	else  
	min(CASE WHEN tscategory = 'RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)' AND (tsunique = 'R-relative') THEN tsunitsshort ELSE NULL END)
	end
	end
	end
	as "r_unit",
	--~~~~~~~~~~~~~~~~~~~~~ Total biomass~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('TOTAL BIOMASS', 'TB-MT', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	min(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-MT') THEN tsunitsshort ELSE NULL END)
	-- if TB-MT is not there, have a look for the others
	else
	case when 
	srdb_metric_boolean('TOTAL BIOMASS', 'TB-1-MT', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-1-MT') THEN tsunitsshort ELSE NULL END)
	-- if TB-1-MT is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('TOTAL BIOMASS', 'TB-relative', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-relative') THEN tsunitsshort ELSE NULL END)
	-- if TB-relative is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('TOTAL BIOMASS', 'TN-E03', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TN-E03') THEN tsunitsshort ELSE NULL END)
	-- if TN-E03 is not there, have a look for the TN-relative
	else  
	min(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TN-relative') THEN tsunitsshort ELSE NULL END)
	end
	end
	end
	end
	as "total_unit",
	--~~~~~~~~~~~~~~~~~~~~~ Fishing mortality ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'F-1/T', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	min(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'F-1/T') THEN tsunitsshort ELSE NULL END)
	-- if TB-MT is not there, have a look for the others
	else
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'F-1/yr', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'F-1/yr') THEN tsunitsshort ELSE NULL END)
	-- if TB-1-MT is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'F-1-1/T', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'F-1-1/T') THEN tsunitsshort ELSE NULL END)
	-- if TB-relative is not there, have a look for the others
	else  
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'F-unweighted-1/T', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'F-unweighted-1/T') THEN tsunitsshort ELSE NULL END)
	else  
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'ER-ratio', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'ER-ratio') THEN tsunitsshort ELSE NULL END)
	-- if TN-E03 is not there, have a look for the TN-relative
	else  
	case when 
	srdb_metric_boolean('FISHING MORTALITY', 'ER-none', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'ER-none') THEN tsunitsshort ELSE NULL END)
	-- if TN-E03 is not there, have a look for the TN-relative
	else  
	min(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'EI-ratio') THEN tsunitsshort ELSE NULL END)
	end
	end
	end
	end
	end
	end
	as "f_unit",
	--~~~~~~~~~~~~~~~~~~~~~ Catch per unit effort ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'CPUEraw-C/E', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	min(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-C/E') THEN tsunitsshort ELSE NULL END)
	-- if SSB-MT is not there, have a look for the others
	else
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'CPUEraw-C/E', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
	min(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-2-C/E') THEN tsunitsshort ELSE NULL END)
	ELSE
	min(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUE-kgpertow') THEN tsunitsshort ELSE NULL END)
	end
	end
	as "cpue_unit",
	--~~~~~~~~~~~~~~~~~~~~~ Catch or landings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TC-MT', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	min(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TC-MT') THEN tsunitsshort ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TL-MT', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TL-MT') THEN tsunitsshort ELSE NULL END)
	else  
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TC-1-MT', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TC-1-MT') THEN tsunitsshort ELSE NULL END)
	else  
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TL-1-MT', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TL-1-MT') THEN tsunitsshort ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TC-E03', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TC-E03') THEN tsunitsshort ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TL-E03', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TL-E03') THEN tsunitsshort ELSE NULL END)
	else
	case when 
	srdb_metric_boolean('CATCH or LANDINGS', 'TC-1-E03', ts.assessid)
	THEN
 	min(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TC-1-E03') THEN tsunitsshort ELSE NULL END)
	else 
	min(CASE WHEN tscategory = 'CATCH or LANDINGS' AND (tsunique = 'TL-1-E03') THEN tsunitsshort ELSE NULL END)
	end
	end
	end
	end
	end
	end
	end
	as "catch_landings_unit"
from 
	srdb.timeseries as ts, srdb.tsmetrics as tm
where 
	tsid=tsunique
group by 
	assessid
order by 
	assessid
;

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- reference point values view 
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CREATE OR REPLACE VIEW srdb.reference_point_values_view AS

select assessid, common, area, points_available, bmsy, ssbmsy, blim, ssblim, ssbpa, ssbtarget, umsy, fmsy, flim from 

(select 
	biopar.assessid as "assessid", 
	stock.commonname as "common", 
	area.areaname as "area",
	count(*) as "points_available",
--~~~~~~~~~~~~~~Bmsy~~~~~~~~~~~~~~~~~~~~~~~~~
	max(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Bmsy-MT') THEN biovalue ELSE NULL END)
	as "bmsy",
--~~~~~~~~~~~~~~SSBmsy~~~~~~~~~~~~~~~~~~~~~~~~~
	max(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique in ('SSBmsy-MT','SSBmsy-E03egss','SSBmsy-E06larvae')) THEN biovalue ELSE NULL END)
	as "ssbmsy",
--~~~~~~~~~~~~~~Blim~~~~~~~~~~~~~~~~~~~~~~~~~
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Blim-MT') THEN biovalue ELSE NULL END)
	as "blim",
--~~~~~~~~~~~~~~SSBlim~~~~~~~~~~~~~~~~~~~~~~~~~
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBlim-MT') THEN biovalue ELSE NULL END)
	as "ssblim",
--~~~~~~~~~~~~~~SSBpa~~~~~~~~~~~~~~~~~~~~~~~~~
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBpa-MT') THEN biovalue ELSE NULL END)
	as "ssbpa",
--~~~~~~~~~~~~~~SSBtarget~~~~~~~~~~~~~~~~~~~~~~~~~
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBtarget-MT') THEN biovalue ELSE NULL END)
	as "ssbtarget",
--~~~~~~~~~~~~~~Umsy~~~~~~~~~~~~~~~~~~~~~~~~~
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Umsy-ratio') THEN biovalue ELSE NULL END)
	as "umsy",
--~~~~~~~~~~~~~~~~Fmsy~~~~~~~~~~~~~~~~~~~~~~~~~~
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique in ('Fmsy-1/yr','Fmsy-1/T')) THEN biovalue ELSE NULL END)
	as "fmsy",
--~~~~~~~~~~~~~~~~Flim~~~~~~~~~~~~~~~~~~~~~~~~~~
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique in ('Flim-1/yr','Flim-1/T')) THEN biovalue ELSE NULL END)
	as "flim"
from 
	srdb.bioparams as biopar, srdb.biometrics, srdb.assessment as assess, srdb.stock as stock, srdb.area as area
where 
	bioid=biounique
and 
	stock.stockid=assess.stockid 
and 	
	stock.areaid=area.areaid
and 
	biopar.assessid=assess.assessid
group by 
	biopar.assessid, stock.commonname, area.areaname
order by 
	biopar.assessid) as aa
;

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- reference point units view 
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CREATE OR REPLACE VIEW srdb.reference_point_units_view AS
select assessid, common, area, points_available,  bmsy_unit,   ssbmsy_unit,   blim_unit,  ssblim_unit, ssbpa_unit, ssbtarget_unit, umsy_unit,  fmsy_unit,   flim_unit  from
(select
	biopar.assessid as "assessid", 
	stock.commonname as "common", 
	area.areaname as "area",
	count(*) as "points_available",
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Bmsy-MT') THEN biounitsshort ELSE NULL END)
	as "bmsy_unit",
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique in ('SSBmsy-MT','SSBmsy-E03egss','SSBmsy-E06larvae')) THEN biounitsshort ELSE NULL END)
	as "ssbmsy_unit",
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Blim-MT') THEN biounitsshort ELSE NULL END)
	as "blim_unit",
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBlim-MT') THEN biounitsshort ELSE NULL END)
	as "ssblim_unit",
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBpa-MT') THEN biounitsshort ELSE NULL END)
	as "ssbpa_unit",
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBtarget-MT') THEN biounitsshort ELSE NULL END)
	as "ssbtarget_unit",
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Umsy-ratio') THEN biounitsshort ELSE NULL END)
	as "umsy_unit",
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique in ('Fmsy-1/yr','Fmsy-1/T')) THEN biounitsshort ELSE NULL END)
	as "fmsy_unit",
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique in ('Flim-1/yr','Flim-1/T')) THEN biounitsshort ELSE NULL END)
	as "flim_unit"
from 
	srdb.bioparams as biopar, srdb.biometrics, srdb.assessment as assess, srdb.stock as stock, srdb.area as area
where 
	bioid=biounique
and 
	stock.stockid=assess.stockid 
and 	
	stock.areaid=area.areaid
and 
	biopar.assessid=assess.assessid
group by 
	biopar.assessid, stock.commonname, area.areaname
order by 
	biopar.assessid
) as aa
;


-- view WITHOUT RAM's DATA
drop table srdb.newtimeseries_values_view;
create table srdb.newtimeseries_values_view as
(
SELECT 
v.assessid,
v.tsyear,
v.pt_avail,
v.ssb,
v.r,
v.total,
v.f,
v.cpue,
v.catch_landings
FROM 
srdb.timeseries_values_view v,
srdb.assessment a
WHERE 
a.assessid=v.assessid AND
a.recorder != 'MYERS'
);

DELETE FROM srdb.newtimeseries_values_view 
where
ssb is null and 
r is null and 
total is null and 
f is null and 
cpue is null and 
catch_landings is null
;

drop table srdb.newtimeseries_ssbrelative_view;
create table srdb.newtimeseries_ssbrelative_view as
(
SELECT 
tsv.assessid,
tsv.tsyear,
tsv.ssb,
rpv.ssbmsy,
tsv.ssb/CAST(rpv.ssbmsy as NUMERIC) as ssbrelativetossbmsy
FROM
srdb.newtimeseries_values_view tsv,
srdb.timeseries_units_view tsu,
srdb.reference_point_units_view rpu,
srdb.reference_point_values_view rpv
WHERE
tsv.assessid = rpv.assessid AND
tsu.assessid = tsv.assessid AND
rpu.assessid = rpv.assessid AND
tsu.ssb_unit = rpu.ssbmsy_unit AND
tsv.ssb is not NULL
ORDER BY
tsv.assessid,
tsv.tsyear
)
;

drop table srdb.newtimeseries_frelative_view;
create table srdb.newtimeseries_frelative_view as
(
SELECT 
tsv.assessid,
tsv.tsyear,
tsv.f,
rpv.fmsy,
tsv.f/CAST(rpv.fmsy as NUMERIC) as frelativetofmsy
FROM
srdb.newtimeseries_values_view tsv,
srdb.timeseries_units_view tsu,
srdb.reference_point_units_view rpu,
srdb.reference_point_values_view rpv
WHERE
tsv.assessid = rpv.assessid AND
tsu.assessid = tsv.assessid AND
rpu.assessid = rpv.assessid AND
tsu.f_unit = rpu.fmsy_unit AND
tsv.f is not NULL
ORDER BY
tsv.assessid,
tsv.tsyear
)
;

DROP TABLE srdb.phaseplane;
CREATE TABLE srdb.phaseplane
AS
(
SELECT s.assessid, s.tsyear, s.ssbrelativetossbmsy, f.frelativetofmsy
FROM
srdb.newtimeseries_ssbrelative_view s,
srdb.newtimeseries_frelative_view f
where 
s.assessid = f.assessid AND
s.tsyear = f.tsyear
)
;


-- 2010-03-11: do the same but only using the stocks for which there is explicit linking between the reference point and the timeseries
drop table srdb.tsrelative_explicit_view;
create table srdb.tsrelative_explicit_view as
(
SELECT 
ts.assessid,
ts.tsyear,
ts.tsid,
ts.tsvalue,
rp.bioid,
rp.biovalue,
ts.tsvalue/cast(rp.biovalue as FLOAT) as tstobrpratio
FROM
srdb.timeseries ts,
srdb.bioparams rp,
srdb.brptots
WHERE
brptots.assessid = ts.assessid AND
brptots.assessid = rp.assessid AND
brptots.bioid = rp.bioid AND
brptots.tsid = ts.tsid 
--rp.biovalue is not null AND
--ts.tsvalue is not null
ORDER BY
ts.assessid,
rp.bioid,
ts.tsyear
)
;

DELETE FROM srdb.tsrelative_explicit_view WHERE tsvalue IS NULL;
