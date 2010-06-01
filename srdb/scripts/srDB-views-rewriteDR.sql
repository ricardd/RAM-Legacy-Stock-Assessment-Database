-- re-writing the srdb views to make them a bit more manageable to update
-- Daniel Ricard Started 2010-03-23 from earlier view definitions
-- Last modified Time-stamp: <2010-03-23 11:57:52 (srdbadmin)>


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
