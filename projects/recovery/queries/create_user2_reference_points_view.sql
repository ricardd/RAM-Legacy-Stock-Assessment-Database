-- create a user2 (user friendly) view of the biometrics
-- output the data in column format 
-- date: Thu Nov  6 15:49:00 AST 2008
-- Time-stamp: <2008-11-11 18:47:13 (mintoc)>
-- to create a tex table for inclusion in a LaTeX document use:
-- LaTeX psql -d srDB -U ricardd -W -P format=latex -f "/home/ricardd/linux_sync_folder/SQL/SQLpg/srDB/projects/recovery/R/create_user2_biometrics_view.sql" > /home/ricardd/linux_sync_folder/SQL/SQLpg/srDB/projects/recovery/R/ref.tex

--CREATE OR REPLACE TEMP VIEW reference_point_view AS

-- this query returns the values for the reference points and a column beside that indicates the number of points
-- matching the criteria

select 
	biopar.assessid as "ASSESSID", 
	stock.commonname as "COMMON", 
	area.areaname as "AREA",
	count(*) as "Points available",
	count(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Bmsy-MT') THEN biovalue ELSE NULL END as float)) as count_bmsy,
	sum(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Bmsy-MT') THEN biovalue ELSE NULL END as float))
	as "Bmsy",
	count(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-MT') THEN biovalue ELSE NULL END as float)) as count_ssbmsy,
	sum(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-MT') THEN biovalue ELSE NULL END as float))
	as "SSBmsy",
	count(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Blim-MT') THEN biovalue ELSE NULL END as float)) as count_blim,
	sum(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Blim-MT') THEN biovalue ELSE NULL END as float))
	as "Blim",
--~~~~~~~~~~~~~~~~Fmsy~~~~~~~~~~~~~~~~~~~~~~~~~~
	--counts
	case when
	'Fmsy-1/T' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN 
	count(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Fmsy-1/T') THEN biovalue ELSE NULL END as float))
	else
	count(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Fmsy-1/yr') THEN biovalue ELSE NULL END as float))
	end
	as "count_Fmsy",

	case when
	'Fmsy-1/T' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN 
	sum(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Fmsy-1/T') THEN biovalue ELSE NULL END as float))
	else
	sum(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Fmsy-1/yr') THEN biovalue ELSE NULL END as float))
	end
	as "Fmsy", --N.B. make sure this is working okay, no Fmsy-1/T currently entered
--~~~~~~~~~~~~~~~~Flim~~~~~~~~~~~~~~~~~~~~~~~~~~
	--count
	case when
	'Flim-1/T' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN 
	count(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/T') THEN biovalue ELSE NULL END as float))
	else
	count(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/yr') THEN biovalue ELSE NULL END as float))
	end
	as "count_Flim",
	case when
	'Flim-1/T' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN 
	sum(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/T') THEN biovalue ELSE NULL END as float))
	else
	sum(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/yr') THEN biovalue ELSE NULL END as float))
	end
	as "Flim"
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
	biopar.assessid
;

-- make this into a table and see if there are any duplicates
-- only return those for which there are no duplicates e.g. Bmsy-MT entered twice

select * from

(select 
	biopar.assessid as "ASSESSID", 
	stock.commonname as "COMMON", 
	area.areaname as "AREA",
	count(*) as "Points available",
	count(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Bmsy-MT') THEN biovalue ELSE NULL END as float)) as count_bmsy,
	sum(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Bmsy-MT') THEN biovalue ELSE NULL END as float))
	as "Bmsy",
	count(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-MT') THEN biovalue ELSE NULL END as float)) as count_ssbmsy,
	sum(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-MT') THEN biovalue ELSE NULL END as float))
	as "SSBmsy",
	count(cast(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Blim-MT') THEN biovalue ELSE NULL END as float)) as count_blim,
	sum(cast(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Blim-MT') THEN biovalue ELSE NULL END as float))
	as "Blim",
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
	as "Fmsy", --N.B. make sure this is working okay, no Fmsy-1/T currently entered
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
	as "Flim"
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

ref_count.count_bmsy < 2 

AND ref_count.count_ssbmsy <2 

AND ref_count.count_blim <2

AND ref_count.count_Fmsy <2 

AND ref_count.count_Flim <2
;

-- similarly you could change the '<2' to '>1' to see the problematic assessments
-- for the view, no need to have the counts displayed but make sure that they are only a single value


CREATE OR REPLACE VIEW reference_point_values_view AS

select assessid, common, area, points_available, bmsy, ssbmsy,  blim, umsy, fmsy, flim from 

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

ref_count.count_bmsy < 2 

AND ref_count.count_ssbmsy <2 

AND ref_count.count_umsy <2 

AND ref_count.count_blim <2

AND ref_count.count_Fmsy <2 

AND ref_count.count_Flim <2
;


-- select * from reference_point_values_view;