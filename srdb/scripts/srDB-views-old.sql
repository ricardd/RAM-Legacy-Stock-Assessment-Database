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
	count(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Bmsy-MT') THEN biovalue ELSE NULL END) as count_bmsy,
	max(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Bmsy-MT') THEN biovalue ELSE NULL END)
	as "bmsy",
--~~~~~~~~~~~~~~SSBmsy~~~~~~~~~~~~~~~~~~~~~~~~~
--	count(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-MT') THEN biovalue ELSE NULL END) as count_ssbmsy,
--	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-MT') THEN biovalue ELSE NULL END)
--	as "ssbmsy",
	case when
	'SSBmsy-MT' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN
	count(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-MT') THEN biovalue ELSE NULL END)
	else
	count(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-E03eggs') THEN biovalue ELSE NULL END)
	end
	as count_ssbmsy,
	case when
	'SSBmsy-MT' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-MT') THEN biovalue ELSE NULL END)
	else
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-E03eggs') THEN biovalue ELSE NULL END)
	end
	as ssbmsy,

--~~~~~~~~~~~~~~Blim~~~~~~~~~~~~~~~~~~~~~~~~~
	count(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Blim-MT') THEN biovalue ELSE NULL END) as count_blim,
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Blim-MT') THEN biovalue ELSE NULL END)
	as "blim",
--~~~~~~~~~~~~~~SSBlim~~~~~~~~~~~~~~~~~~~~~~~~~
	count(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBlim-MT') THEN biovalue ELSE NULL END) as count_ssblim,
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBlim-MT') THEN biovalue ELSE NULL END)
	as "ssblim",
--~~~~~~~~~~~~~~SSBpa~~~~~~~~~~~~~~~~~~~~~~~~~
	count(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBpa-MT') THEN biovalue ELSE NULL END) as count_ssbpa,
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBpa-MT') THEN biovalue ELSE NULL END)
	as "ssbpa",
--~~~~~~~~~~~~~~SSBtarget~~~~~~~~~~~~~~~~~~~~~~~~~
	count(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBtarget-MT') THEN biovalue ELSE NULL END) as count_ssbtarget,
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBtarget-MT') THEN biovalue ELSE NULL END)
	as "ssbtarget",
--~~~~~~~~~~~~~~Umsy~~~~~~~~~~~~~~~~~~~~~~~~~
	count(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Umsy-ratio') THEN biovalue ELSE NULL END) as count_umsy,
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Umsy-ratio') THEN biovalue ELSE NULL END)
	as "umsy",
--~~~~~~~~~~~~~~~~Fmsy~~~~~~~~~~~~~~~~~~~~~~~~~~
	--counts
	case when
	'Fmsy-1/T' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN 
	count(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Fmsy-1/T') THEN biovalue ELSE NULL END)
	else
	count(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Fmsy-1/yr') THEN biovalue ELSE NULL END)
	end
	as "count_fmsy",

	case when
	'Fmsy-1/T' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN 
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Fmsy-1/T') THEN biovalue ELSE NULL END)
	else
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Fmsy-1/yr') THEN biovalue ELSE NULL END)
	end
	as "fmsy", --N.B. make sure this is working okay, no Fmsy-1/T currently entered
--~~~~~~~~~~~~~~~~Flim~~~~~~~~~~~~~~~~~~~~~~~~~~
	--count
	case when
	'Flim-1/T' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN 
	count(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/T') THEN biovalue ELSE NULL END)
	else
	count(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/yr') THEN biovalue ELSE NULL END)
	end
	as "count_flim",
	case when
	'Flim-1/T' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN 
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/T') THEN biovalue ELSE NULL END)
	else
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/yr') THEN biovalue ELSE NULL END)
	end
	as "flim"
from 
	srdb.bioparams as biopar, srdb.biometrics, srdb.assessment as assess, srdb.stock as stock, srdb.area as area
where 
	bioid=biounique
--and 
--	biopar.assessid!='DFO-NFLD-AMPL3Ps-1960-2005-PREFONTAINE' -- has a hyphen in the value?
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

AND ref_count.count_ssblim <2

AND ref_count.count_ssbpa <2

AND ref_count.count_ssbtarget <2

AND ref_count.count_Fmsy <2 

AND ref_count.count_Flim <2
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
	count(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Bmsy-MT') THEN biovalue ELSE NULL END ) as count_bmsy,
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Bmsy-MT') THEN biounitsshort ELSE NULL END)
	as "bmsy_unit",
--	count(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-MT') THEN biovalue ELSE NULL END ) as count_ssbmsy,
--	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-MT') THEN biounitsshort ELSE NULL END )
--	as "ssbmsy_unit",
	case when
	'SSBmsy-MT' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN
	count(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-MT') THEN biovalue ELSE NULL END)
	else
	count(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-E03eggs') THEN biovalue ELSE NULL END)
	end
	as count_ssbmsy,
	case when
	'SSBmsy-MT' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-MT') THEN biounitsshort ELSE NULL END)
	else
	max(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBmsy-E03eggs') THEN biounitsshort ELSE NULL END)
	end
	as ssbmsy_unit,
	count(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Blim-MT') THEN biovalue ELSE NULL END ) as count_blim,
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Blim-MT') THEN biounitsshort ELSE NULL END )
	as "blim_unit",
	count(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBlim-MT') THEN biovalue ELSE NULL END ) as count_ssblim,
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBlim-MT') THEN biounitsshort ELSE NULL END )
	as "ssblim_unit",
	count(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBpa-MT') THEN biovalue ELSE NULL END ) as count_ssbpa,
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBpa-MT') THEN biounitsshort ELSE NULL END )
	as "ssbpa_unit",
	count(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBtarget-MT') THEN biovalue ELSE NULL END ) as count_ssbtarget,
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'SSBtarget-MT') THEN biounitsshort ELSE NULL END )
	as "ssbtarget_unit",
	count(CASE WHEN upper(subcategory) = 'REFERENCE POINTS ETC.' AND (biounique = 'Umsy-ratio') THEN biovalue ELSE NULL END ) as count_umsy,
	min(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Umsy-ratio') THEN biounitsshort ELSE NULL END)
	as "umsy_unit",
--~~~~~~~~~~~~~~~~Fmsy~~~~~~~~~~~~~~~~~~~~~~~~~~
	--counts
	case when
	'Fmsy-1/T' in (select distinct biounique from srdb.biometrics, srdb.bioparams as biopar1  where subcategory = 'REFERENCE POINTS ETC.' AND bioid=biounique and biopar1.assessid=biopar.assessid)
	THEN 
	count(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Fmsy-1/T') THEN biovalue ELSE NULL END )
	else
	count(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Fmsy-1/yr') THEN biovalue ELSE NULL END )
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
	count(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/T') THEN biovalue ELSE NULL END )
	else
	count(CASE WHEN subcategory = 'REFERENCE POINTS ETC.' AND (biounique = 'Flim-1/yr') THEN biovalue ELSE NULL END )
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
--and 
--	biopar.assessid!='DFO-NFLD-AMPL3Ps-1960-2005-PREFONTAINE' -- has a hyphen in the value?
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

AND ref_units.count_ssblim <2

AND ref_units.count_ssbpa <2

AND ref_units.count_umsy <2

AND ref_units.count_fmsy <2 

AND ref_units.count_flim <2
;
