-- testing some boolean constructs on srdb to create a user-friendly view
-- output the data in column format 
-- date: Tue Nov  5 11:25:35 AST 2008
-- Time-stamp: <2008-11-14 15:00:41 (mintoc)>
-- want to get out a preferential hierarchy, as detailed in 1_makedata_README

-- functions make it cleaner
-- initialize the language
-- CREATE LANGUAGE plpgsql;

-- write a function to return whether the metric exists for that assessment

CREATE or REPLACE FUNCTION srdb_metric_boolean(category text, metric text, assessment text)
-- returns a true/false if metric exists
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

-- to get rid of function use:
-- drop function srdb_metric_boolean(category text, metric text, assessment text);

-- should write a function to extract data but haven't time now (CM)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- apply to assessments
--~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- see below for code to make sure there is only one timeseries contributing
create table timeseries_values_view as
select 
	ts.assessid,
	tsyear, 
	count(*),-- count of available timeseries for assessment
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
	-- if TN-E03 is not there, have a look for the SSB-relative
	else  
	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-relative') THEN tsvalue ELSE NULL END)
	end
	end
	end
	end
	as "SSB",
	--~~~~~~~~~~~~~~~~~~~~~ Recruitment ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
	as "R",
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
	as "TOTAL",
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
	srdb_metric_boolean('FISHING MORTALITY', 'ER-ratio', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'ER-ratio') THEN tsvalue ELSE NULL END)
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
	as "F",
	--~~~~~~~~~~~~~~~~~~~~~ Catch per unit effort ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'CPUEraw-C/E', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-C/E') THEN tsvalue ELSE NULL END)
	-- if SSB-MT is not there, have a look for the others
	else
	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-2-C/E') THEN tsvalue ELSE NULL END)
	end
	as "CPUE",
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
	as "CATCH-LANDINGS"
from 
	srdb.timeseries as ts, srdb.tsmetrics as tm
where 
	tsid=tsunique
group by 
	assessid, tsyear
order by 
	assessid, tsyear
-- limit 150 --change this to get out more

;



--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
-- code to make sure only a single time series is returned from the query i.e. no double summation!
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
	-- if TN-E03 is not there, have a look for the SSB-relative
	else  
	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-relative') THEN tsvalue ELSE NULL END)
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
	-- if TN-E03 is not there, have a look for the SSB-relative
	else  
	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-relative') THEN tsvalue ELSE NULL END)
	end
	end
	end
	end
	as ssb_count,
	--~~~~~~~~~~~~~~~~~~~~~ Recruitment ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
	as r,
	--~~~~~~~~~~~~~~~~~~~~~ Count of recruitment ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
	srdb_metric_boolean('FISHING MORTALITY', 'ER-ratio', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'ER-ratio') THEN tsvalue ELSE NULL END)
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
	as f_count,
	--~~~~~~~~~~~~~~~~~~~~~ Catch per unit effort ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'CPUEraw-C/E', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-C/E') THEN tsvalue ELSE NULL END)
	-- if SSB-MT is not there, have a look for the others
	else
	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-2-C/E') THEN tsvalue ELSE NULL END)
	end
	as cpue,
	--~~~~~~~~~~~~~~~~~~~~~ Count of catch per unit effort ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'CPUEraw-C/E', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-C/E') THEN tsvalue ELSE NULL END)
	-- if SSB-MT is not there, have a look for the others
	else
	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-2-C/E') THEN tsvalue ELSE NULL END)
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


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- see which ones have >1?
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~
select 	distinct assessid
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
	-- if TN-E03 is not there, have a look for the SSB-relative
	else  
	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-relative') THEN tsvalue ELSE NULL END)
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
	-- if TN-E03 is not there, have a look for the SSB-relative
	else  
	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-relative') THEN tsvalue ELSE NULL END)
	end
	end
	end
	end
	as ssb_count,
	--~~~~~~~~~~~~~~~~~~~~~ Recruitment ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
	as r,
	--~~~~~~~~~~~~~~~~~~~~~ Count of recruitment ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
	srdb_metric_boolean('FISHING MORTALITY', 'ER-ratio', ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'FISHING MORTALITY' AND (tsunique = 'ER-ratio') THEN tsvalue ELSE NULL END)
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
	as f_count,
	--~~~~~~~~~~~~~~~~~~~~~ Catch per unit effort ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'CPUEraw-C/E', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-C/E') THEN tsvalue ELSE NULL END)
	-- if SSB-MT is not there, have a look for the others
	else
	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-2-C/E') THEN tsvalue ELSE NULL END)
	end
	as cpue,
	--~~~~~~~~~~~~~~~~~~~~~ Count of catch per unit effort ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'CPUEraw-C/E', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
 	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-C/E') THEN tsvalue ELSE NULL END)
	-- if SSB-MT is not there, have a look for the others
	else
	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-2-C/E') THEN tsvalue ELSE NULL END)
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
	ssb_count>1 
or
	r_count >1
or 
	total_count >1 
or  
	f_count >1
or 
	cpue_count >1 
or 
	catch_landings_count >1
;



--~~~~~~~~~~~~~~~~~~~~~~~sandbox code~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

select 
	ts.assessid,
	tsyear, 
	count(*),-- count of available timeseries for assessment
	--~~~~~~~~~~~~~~~~~~~~~ Spawning stock biomass~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-MT', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-MT') THEN tsvalue ELSE NULL END)
 	else  
	sum(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-1-MT') THEN tsvalue ELSE NULL END)
	end
	as ssb,
	--~~~~~~~~~~~~~~~~~~~~~ Spawning stock biomass count ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	case when 
	srdb_metric_boolean('SPAWNING STOCK BIOMASS or CPUE', 'SSB-MT', ts.assessid) --note no quotes on ts.assessid as it is coming in from outside the function
	THEN
	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-MT') THEN tsvalue ELSE NULL END)
 	else  
	count(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-1-MT') THEN tsvalue ELSE NULL END)
	end
	as count_ssb
from 
	srdb.timeseries as ts, srdb.tsmetrics as tm
where 
	tsid=tsunique
and 
	ts.assessid='AFWG-CODNEAR-1943-2006-MINTO'
group by 
	assessid, tsyear
order by 
	assessid, tsyear
;

-- try for one population and total biomass alone, doesn't use functions i.e. verbose
select 
	assessid, 
	tsyear, 
	count(*),
	-- see if TB-MT is there on its own, if so assign to tb

	case when 
	'TB-MT' in (select distinct tsunique from srdb.tsmetrics, srdb.timeseries where tscategory = 'TOTAL BIOMASS' AND assessid='AFWG-CODNEAR-1943-2006-MINTO' AND tsid=tsunique) -
	THEN
 	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-MT') THEN tsvalue ELSE 0 END)
	-- if TB-MT is not there, have a look for the others
	else  

	case when 
	'TB-1-MT' in (select distinct tsunique from srdb.tsmetrics, srdb.timeseries where tscategory = 'TOTAL BIOMASS' AND assessid='AFWG-CODNEAR-1943-2006-MINTO' AND tsid=tsunique) 
	THEN
 	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-1-MT') THEN tsvalue ELSE 0 END)
	-- if TB-1-MT is not there, have a look for the others
	else  

	case when 
	'TB-relative' in (select distinct tsunique from srdb.tsmetrics, srdb.timeseries where tscategory = 'TOTAL BIOMASS' AND assessid='AFWG-CODNEAR-1943-2006-MINTO' AND tsid=tsunique) 
	THEN
 	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-relative') THEN tsvalue ELSE 0 END)
	-- if TB-relative is not there, have a look for the others
	else  

	case when 
	'TN-E03' in (select distinct tsunique from srdb.tsmetrics, srdb.timeseries where tscategory = 'TOTAL BIOMASS' AND assessid='AFWG-CODNEAR-1943-2006-MINTO' AND tsid=tsunique) 
	THEN
 	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TN-E03') THEN tsvalue ELSE 0 END)
	-- if TN-E03 is not there, have a look for the TN-relative
	else  
	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TN-relative') THEN tsvalue ELSE 0 END)
	end
	end
	end
	end
	as TOTAL

from 
	srdb.timeseries, srdb.tsmetrics
where 
	tsid=tsunique
and 
	assessid='AFWG-CODNEAR-1943-2006-MINTO'
group by 
	assessid, tsyear
order by 
	assessid, tsyear
;

-- for all populations, not using functions


select 
	ts.assessid, 
	tsyear, 
	count(*),
	-- see if TB-MT is there on its own, if so assign to tb

	case when 
	'TB-MT' in (select distinct tsunique from srdb.tsmetrics, srdb.timeseries as ts1 where tscategory = 'TOTAL BIOMASS' AND tsid=tsunique and ts1.assessid=ts.assessid) 
	THEN
 	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-MT') THEN tsvalue ELSE 0 END)
	-- if TB-MT is not there, have a look for the others
	else  

	case when 
	'TB-1-MT' in (select distinct tsunique from srdb.tsmetrics, srdb.timeseries as ts1 where tscategory = 'TOTAL BIOMASS' AND tsid=tsunique and ts1.assessid=ts.assessid) 
	THEN
 	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-1-MT') THEN tsvalue ELSE 0 END)
	-- if TB-1-MT is not there, have a look for the others
	else  

	case when 
	'TB-relative' in (select distinct tsunique from srdb.tsmetrics, srdb.timeseries  as ts1 where tscategory = 'TOTAL BIOMASS' AND tsid=tsunique and ts1.assessid=ts.assessid) 
	THEN
 	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-relative') THEN tsvalue ELSE 0 END)
	-- if TB-relative is not there, have a look for the others
	else  

	case when 
	'TN-E03' in (select distinct tsunique from srdb.tsmetrics, srdb.timeseries as ts1 where tscategory = 'TOTAL BIOMASS' AND tsid=tsunique and ts1.assessid=ts.assessid) 
	THEN
 	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TN-E03') THEN tsvalue ELSE 0 END)
	-- if TN-E03 is not there, have a look for the TN-relative
	else  
	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TN-relative') THEN tsvalue ELSE 0 END)
	end
	end
	end
	end
	as TOTAL

from 
	srdb.timeseries as ts, srdb.tsmetrics as tm
where 
	tsid=tsunique
--and 
--	assessid='AFWG-CODNEAR-1943-2006-MINTO'
group by 
	assessid, tsyear
order by 
	assessid, tsyear
limit 100
;



CREATE or REPLACE FUNCTION srdb_metric_text(category text, metric text, assessment text)
-- returns a true/false if metric exists
-- 1st argument is tsmetric category
-- 2nd argument is metric e.g. TB-MT
-- 3rd argumant is assessid 
RETURNS text AS $$
DECLARE
	result text;
	sqlquery text;
BEGIN
sqlquery:=  
	'select (count(distinct tsid)!=0) 
	from srdb.timeseries as ts1, srdb.tsmetrics
	where 
	tscategory =' || quote_literal(category)  || 'AND
	ts1.assessid='    || quote_literal(assessment)|| 'AND
	tsunique='    || quote_literal(metric)|| 'AND
	tsid=tsunique';
EXECUTE sqlquery
INTO STRICT result;
return result;
END;
$$ language plpgsql;



-- drop function srdb_metric_text(category text, metric text, assessment text);


--~~~~~~~~~~~~~~~~~~~~~~~~~~
-- try out function
--~~~~~~~~~~~~~~~~~~~~~~~~~~

select 	ts.assessid, tsyear,
	case when 
		srdb_metric_boolean('TOTAL BIOMASS', 'TB-MT', ts.assessid)
	then 
		cast(sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-MT') THEN tsvalue ELSE 0 END) as text)
	else
		srdb_metric_text('TOTAL BIOMASS', 'TB-MT', ts.assessid)
	END
	as TOTAL 
from srdb.timeseries as ts, srdb.tsmetrics 

where 
	tsid=tsunique
and 
	assessid='AFWG-CODCOASTNOR-1982-2006-MINTO'
group by 
	assessid, tsyear
order by 
	assessid, tsyear
--limit 1000
;

select 
	ts.assessid, 
	tsyear, 
	count(*),
	-- see if TB-MT is there on its own, if so assign to tb

	case when 
	srdb_metric_boolean('TOTAL BIOMASS', 'TB-MT', ts.assessid)
	-- tb_boolean('TB-MT')
	--'TB-MT' in (select distinct tsunique from srdb.tsmetrics, srdb.timeseries as ts1 where tscategory = 'TOTAL BIOMASS' AND tsid=tsunique and ts1.assessid=ts.assessid) 
	THEN
 	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-MT') THEN tsvalue ELSE 0 END)
	-- if TB-MT is not there, have a look for the others
	else  

	case when 
	srdb_metric_boolean('TOTAL BIOMASS', 'TB-1-MT', ts.assessid)
	--'TB-1-MT' in (select distinct tsunique from srdb.tsmetrics, srdb.timeseries as ts1 where tscategory = 'TOTAL BIOMASS' AND tsid=tsunique and ts1.assessid=ts.assessid)
	THEN
 	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-1-MT') THEN tsvalue ELSE 0 END)
	-- if TB-1-MT is not there, have a look for the others
	else  
 	sum(CASE WHEN tscategory = 'TOTAL BIOMASS' AND (tsunique = 'TB-relative') THEN tsvalue ELSE 0 END)
	end
	end
	as TOTAL
from 
	srdb.timeseries as ts, srdb.tsmetrics as tm
where 
	tsid=tsunique
and 
	assessid='AFWG-CODCOASTNOR-1982-2006-MINTO'
group by 
	assessid, tsyear
order by 
	assessid, tsyear
limit 1000
;






