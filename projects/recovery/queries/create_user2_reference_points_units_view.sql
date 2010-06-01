-- create a user2 (user friendly) view of the reference point units
-- output the data in column format 
-- date: Fri Nov  7 11:55:34 AST 2008
-- Time-stamp: <2008-11-11 18:26:26 (mintoc)>

-- 
-- same as the create_user2_reference_points_values.sql, filter out records with duplicate entries

CREATE OR REPLACE VIEW reference_point_units_view AS
select assessid, common, area, points_available,  bmsy_unit,   ssbmsy_unit,   blim_unit,  umsy_unit,  fmsy_unit,   flim_unit  from
(select
	biopar.assessid as "assessid", 
	stock.commonname as "common", 
	area.areaname as "area",
	count(*) as "points_available",
	count(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Bmsy-MT') THEN biovalue ELSE NULL END as float)) as count_bmsy,
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Bmsy-MT') THEN biounitsshort ELSE NULL END)
	as "bmsy_unit",
	count(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-MT') THEN biovalue ELSE NULL END as float)) as count_ssbmsy,
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-MT') THEN biounitsshort ELSE NULL END )
	as "ssbmsy_unit",
	count(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Blim-MT') THEN biovalue ELSE NULL END as float)) as count_blim,
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Blim-MT') THEN biounitsshort ELSE NULL END )
	as "blim_unit",
	count(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Umsy-ratio') THEN biovalue ELSE NULL END as float)) as count_umsy,
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Umsy-ratio') THEN biounitsshort ELSE NULL END)
	as "umsy_unit",
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
	-- units 
	case when
	'Fmsy-1/T' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN 
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Fmsy-1/T') THEN biounitsshort ELSE NULL END )
	else
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Fmsy-1/yr') THEN biounitsshort ELSE NULL END )
	end
	as "fmsy_unit", --N.B. make sure this is working okay, no Fmsy-1/T currently entered
--~~~~~~~~~~~~~~~~Flim~~~~~~~~~~~~~~~~~~~~~~~~~~
	--counts
	case when
	'Flim-1/T' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN 
	count(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/T') THEN biovalue ELSE NULL END as float))
	else
	count(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/yr') THEN biovalue ELSE NULL END as float))
	end
	as "count_flim",
	--units
	case when
	'Flim-1/T' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN 
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/T') THEN biounitsshort ELSE NULL END )
	else
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/yr') THEN biounitsshort ELSE NULL END )
	end
	as "flim_unit"
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
	biopar.assessid, stock.commonname, area.areaname--, biometrics.subcategory, biometrics.biounique, biometrics.biounitsshort
order by 
	biopar.assessid
) as ref_units

where

ref_units.count_bmsy < 2 

AND ref_units.count_ssbmsy <2 

AND ref_units.count_blim <2

AND ref_units.count_umsy <2

AND ref_units.count_fmsy <2 

AND ref_units.count_flim <2
;

--select * from reference_point_units_view;



-- sandbox code~~~~~~~~~~~~~~~~~~~~~~~~~
-- test query


select 	assessid, 
	count(*),
	sum(case when tscategory = 'SPAWNING STOCK BIOMASS or CPUE' and (tsid = 'SSB-E03MT') then tsvalue else NULL end) as "ssb"
from srdb.timeseries, srdb.tsmetrics
where
	tsid=tsunique
and
	assessid='WGNSDS-CODVIa-1977-2006-MINTO'
group by
	assessid, tsyear
order by assessid, tsyear
;

-- sum acts elementwise and removes the need to group by whatever is in the summation
-- it is convenient that sum returns the value, count would return 1 for each
-- for a character string, try 'lower'

select 	assessid, 
	count(*),
	count(case when tscategory = 'SPAWNING STOCK BIOMASS or CPUE' and (tsid = 'SSB-E03MT') then tsvalue else NULL end) as "ssb"
from srdb.timeseries, srdb.tsmetrics
where
	tsid=tsunique
and
	assessid='WGNSDS-CODVIa-1977-2006-MINTO'
group by
	assessid, tsyear--, tscategory, tsid, tsvalue
order by assessid, tsyear
;
