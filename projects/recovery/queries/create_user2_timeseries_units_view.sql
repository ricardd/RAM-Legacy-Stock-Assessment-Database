-- get units for the timeseries
-- date: Tue Nov  5 11:25:35 AST 2008
-- Time-stamp: <2008-11-14 14:58:53 (mintoc)>
-- uses function 'srdb_metric_boolean' from create_user2_timeseries_view.sql

CREATE OR REPLACE VIEW timeseries_units_view AS
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
	-- if TN-E03 is not there, have a look for the SSB-relative
	else  
	min(CASE WHEN tscategory = 'SPAWNING STOCK BIOMASS or CPUE' AND (tsunique = 'SSB-relative') THEN tsunitsshort ELSE NULL END)
	end
	end
	end
	end
	as "ssb_unit",
	--~~~~~~~~~~~~~~~~~~~~~ Recruitment ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
	as "f_units",
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
	as "catch-landings_unit"
from 
	srdb.timeseries as ts, srdb.tsmetrics as tm
where 
	tsid=tsunique
group by 
	assessid
order by 
	assessid
;


-- select * from timeseries_units_view;