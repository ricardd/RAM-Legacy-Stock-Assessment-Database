-- accompanies srdb-views.sql but shows any assessments for which there are multiple entries for the same metric e.g. SSB-E03 not unique by year

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- see which time series ones have multiple entries for the same tsid
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- same for reference points
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

select distinct assessid from 

(select 
	biopar.assessid as "assessid", 
	stock.commonname as "common", 
	area.areaname as "area",
	count(*) as "points_available",
	count(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Bmsy-MT') THEN biovalue ELSE NULL END as float)) as count_bmsy,
	sum(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Bmsy-MT') THEN biovalue ELSE NULL END as float))
	as "bmsy",
	count(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-MT') THEN biovalue ELSE NULL END as float)) as count_ssbmsy,
	sum(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-MT') THEN biovalue ELSE NULL END as float))
	as "ssbmsy",
	count(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Blim-MT') THEN biovalue ELSE NULL END as float)) as count_blim,
	sum(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Blim-MT') THEN biovalue ELSE NULL END as float))
	as "blim",
	count(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Umsy-ratio') THEN biovalue ELSE NULL END as float)) as count_umsy,
	sum(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Umsy-ratio') THEN biovalue ELSE NULL END as float))
	as "umsy",
--~~~~~~~~~~~~~~~~Fmsy~~~~~~~~~~~~~~~~~~~~~~~~~~
	--counts
	case when
	'Fmsy-1/T' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN 
	count(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Fmsy-1/T') THEN biovalue ELSE NULL END as float))
	else
	count(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Fmsy-1/yr') THEN biovalue ELSE NULL END as float))
	end
	as "count_fmsy",

	case when
	'Fmsy-1/T' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN 
	sum(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Fmsy-1/T') THEN biovalue ELSE NULL END as float))
	else
	sum(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Fmsy-1/yr') THEN biovalue ELSE NULL END as float))
	end
	as "fmsy", --N.B. make sure this is working okay, no Fmsy-1/T currently entered
--~~~~~~~~~~~~~~~~Flim~~~~~~~~~~~~~~~~~~~~~~~~~~
	--count
	case when
	'Flim-1/T' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN 
	count(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/T') THEN biovalue ELSE NULL END as float))
	else
	count(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/yr') THEN biovalue ELSE NULL END as float))
	end
	as "count_flim",
	case when
	'Flim-1/T' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN 
	sum(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/T') THEN biovalue ELSE NULL END as float))
	else
	sum(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/yr') THEN biovalue ELSE NULL END as float))
	end
	as "flim"
from 
	srdb.bioparams as biopar, srdb.biometrics, srdb.assessment as assess, srdb.stock as stock, srdb.area as area
where 
	bioid=biounique
and 
	biopar.assessid!='DFO-NFLD-AMPL3Ps-1960-2005-PREFONTAINE' -- has a hyphen in the value?
and 
	stock.stockid=assess.stockid 
and 	
	stock.areaid=area.areaid
and 
	biopar.assessid=assess.assessid
group by 
	biopar.assessid, stock.commonname, area.areaname
order by 
	biopar.assessid) as ref_count

where 

ref_count.count_bmsy <1 

AND ref_count.count_ssbmsy >1 

AND ref_count.count_umsy >1 

AND ref_count.count_blim >1

AND ref_count.count_Fmsy >1 

AND ref_count.count_Flim >1
;

