--
-- Last modified Time-stamp: <2011-01-17 13:19:11 (srdbadmin)>
-- once the R code in surplus-production-fits.R is executed, the contents of table srdb.spfits contains fitted parameter values for all the stocks for which a Schaefer model could be applied (i.e. had total catch and total biomass timeseries)

-- first, produce a table that show all assessid and whether there is an SP fit available
DROP TABLE srdb.spfitssummary_fox;

CREATE TABLE srdb.spfitssummary_fox AS (
SELECT
a.assessid,
(CASE WHEN (a.assessid = sp.assessid) THEN 'yes' ELSE 'no' END) as catchandbiomass,
(CASE WHEN (a.assessid = sp.assessid) THEN (CASE WHEN (sp.qualityflag = -8) THEN 'no' ELSE 'yes' END) ELSE '' END)  as convergence,
(CASE WHEN ((a.assessid = sp.assessid) and (sp.qualityflag != -8)) THEN (
CASE WHEN sp.assessid in -- stocks identified by Olaf as "not good"
(
'AFSC-BKINGCRABPI-1960-2008-JENSEN',
'AFSC-FLSOLEGA-1978-2008-STANTON',
'AFSC-GHALBSAI-1960-2009-STANTON',
'AFSC-SRAKEROCKBSAI-1977-2008-STANTON',
'AFSC-WPOLLAI-1976-2008-MELNYCHUK',
'CSIRO-BIGHTREDSE-1958-2007-FULTON',
'CSIRO-NZLINGWSE-1968-2007-FULTON',
'MARAM-CRLOBSTERSA12-1910-2008-Johnston',
'MARAM-CRLOBSTERSA34-1910-2008-Johnston',
'MARAM-CRLOBSTERSA56-1910-2008-Johnston',
'MARAM-CRLOBSTERSA7-1910-2008-Johnston',
'MARAM-CRLOBSTERSA8-1910-2008-Johnston',
'MARAM-PTOOTHFISHPEI-1960-2008-DEDECKER',
'MARAM-SAABALONESA-1951-2008-PLAGANYI',
'NEFSC-QUAHATLC-1978-2008-CHUTE',
'NZMFishMIDDEPTHSWG-SOUTHHAKECR-1975-2006-JENSEN',
'NZMFishMIDDEPTHSWG-SOUTHHAKESA-1975-2007-JENSEN',
'SEFSC-SNOWGROUPSATLC-1961-2002-STANTON',
'SWFSC-SBELLYROCKPCOAST-1950-2005-BRANCH') THEN 'no' ELSE 'yes' END
) ELSE '' END) as keepschaefer
FROM
srdb.assessment a
LEFT OUTER JOIN
srdb.spfits_fox sp
ON (a.assessid = sp.assessid)
WHERE
a.recorder != 'MYERS'
order by catchandbiomass, convergence, keepschaefer, a.assessid
)
;