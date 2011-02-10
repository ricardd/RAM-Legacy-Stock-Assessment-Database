--
-- Last modified Time-stamp: <2011-02-04 11:39:27 (srdbadmin)>
-- once the R code in surplus-production-fits.R is executed, the contents of table srdb.spfits contains fitted parameter values for all the stocks for which a Schaefer model could be applied (i.e. had total catch and total biomass timeseries)

-- first, produce a table that show all assessid and whether there is an SP fit available
DROP TABLE srdb.spfits_schaefer_summary;

CREATE TABLE srdb.spfits_schaefer_summary AS (
SELECT
a.assessid,
(CASE WHEN (a.assessid = sp.assessid) THEN 'yes' ELSE 'no' END) as catchandbiomass,
(CASE WHEN (a.assessid = sp.assessid) THEN (CASE WHEN (sp.qualityflag = -8) THEN 'no' ELSE 'yes' END) ELSE '' END)  as convergence
FROM
srdb.assessment a
LEFT OUTER JOIN
srdb.spfits_schaefer sp
ON (a.assessid = sp.assessid)
WHERE
a.recorder != 'MYERS'
order by catchandbiomass, convergence, a.assessid
)
;
