
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

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- time series units view 
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
	min(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'CPUEraw-2-C/E') THEN tsunitsshort ELSE NULL END)
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
