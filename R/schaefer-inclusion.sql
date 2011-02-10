-- remove stocks from the srdb.spfits_schaefer table for those assessid deemed appropriate 
-- Last modified Time-stamp: <2011-02-07 11:15:26 (srdbadmin)>
-- once the R code in surplus-production-fits.R is executed, the contents of table srdb.spfits_schaefer contains fitted parameter values for all the stocks for which a Schaefer model could be applied (i.e. had total catch and total biomass timeseries)
-- Modification history: 
-- 2011-02-04: I am shufflign the table names a bit, spfits_schaefer_all has all the fits, spfits_schaefer only those that are OKed manuall, and spfits is just a copy of spfits_schaefer

DROP TABLE srdb.spfits;
DROP TABLE srdb.spfits_schaefer;


CREATE TABLE srdb.spfits_schaefer AS (
SELECT * FROM srdb.spfits_schaefer_all
WHERE assessid in (
'AFSC-ALPLAICBSAI-1972-2008-MELNYCHUK',
'AFSC-ARFLOUNDBSAI-1970-2008-STANTON',
'AFSC-ARFLOUNDGA-1958-2010-STANTON',
'AFSC-ATKABSAI-1976-2009-STANTON',
'AFSC-CABEZNCAL-1916-2005-STANTON',
'AFSC-CABEZSCAL-1932-2005-STANTON',
'AFSC-DUSROCKGA-1973-2008-MELNYCHUK',
'AFSC-FLSOLEBSAI-1977-2008-STANTON',
'AFSC-NROCKBSAI-1974-2009-STANTON',
'AFSC-NROCKGA-1959-2008-MELNYCHUK',
'AFSC-NRSOLEEBSAI-1971-2008-STANTON',
'AFSC-PCODBSAI-1964-2008-MELNYCHUK',
'AFSC-PCODGA-1964-2008-MELNYCHUK',
'AFSC-PERCHEBSAI-1974-2009-STANTON',
'AFSC-POPERCHGA-1959-2008-MELNYCHUK',
'AFSC-RKCRABBB-1960-2008-JENSEN',
'AFSC-SABLEFEBSAIGA-1956-2008-MELNYCHUK',
'AFSC-SNOWCRABBS-1979-2008-JENSEN',
'AFSC-TANNERCRABBSAI-1965-2008-JENSEN',
'AFSC-WPOLLEBS-1963-2008-MELNYCHUK',
'AFWG-CAPENOR-1965-2007-MINTO',
'AFWG-CODCOASTNOR-1982-2006-MINTO',
'AFWG-CODNEAR-1943-2006-MINTO',
'AFWG-GHALNEAR-1959-2007-JENNINGS',
'AFWG-HADNEAR-1947-2006-MINTO',
'AFWG-POLLNEAR-1957-2006-MINTO',
'ASMFC-PANDALGOM-1960-2009-IDOINE',
'CSIRO-DEEPFLATHEADSE-1978-2007-FULTON',
'CSIRO-GEMFISHSE-1966-2007-FULTON',
'CSIRO-MORWONGSE-1913-2007-FULTON',
'CSIRO-NZLINGESE-1968-2007-FULTON',
'CSIRO-OROUGHYSE-1978-2007-FULTON',
'CSIRO-SILVERFISHSE-1978-2006-FULTON',
'CSIRO-SWHITSE-1945-2007-FULTON',
'CSIRO-TIGERFLATSE-1913-2006-FULTON',
'CSIRO-WAREHOUESE-1984-2006-FULTON',
'CSIRO-WAREHOUWSE-1984-2006-FULTON',
'DFO-COD5Zjm-1978-2003-PREFONTAINE',
'DFO-HAD4X5Y-1960-2003-PREFONTAINE',
'DFO-HAD5Zejm-1969-2003-PREFONTAINE',
'DFO-NFLD-COD3Ps-1959-2004-PREFONTAINE',
'DFO-PAC-ESOLEHS-1944-2001-COLLIE',
'DFO-PAC-HERRCC-1951-2007-COLLIE',
'DFO-PAC-HERRPRD-1951-2007-COLLIE',
'DFO-PAC-HERRQCI-1951-2007-COLLIE',
'DFO-PAC-HERRSOG-1951-2007-COLLIE',
'DFO-PAC-HERRWCVANI-1951-2007-COLLIE',
'DFO-PAC-PCODHS-1956-2005-COLLIE',
'DFO-PAC-PCODWCVANI-1956-2002-COLLIE',
'DFO-PAC-RSOLEHSTR-1945-2001-COLLIE',
'DFO-POLL4VWX5Zc-1974-2007-PREFONTAINE',
'DFO-QUE-COD3Pn4RS-1964-2007-PREFONTAINE',
'DFO-SG-COD4TVn-1965-2007-PREFONTAINE',
'HAWG-HERRNIRS-1960-2006-JENNINGS',
'HAWG-HERRNS-1960-2007-MINTO',
'HAWG-HERRVIa-1957-2006-MINTO',
'HAWG-HERRVIaVIIbc-1969-2000-MINTO',
'ICCAT-ALBANATL-1929-2005-WORM',
'ICCAT-ATBTUNAEATL-1969-2007-WORM',
'ICCAT-BIGEYEATL-1950-2005-JENSEN',
'ICCAT-SKJEATL-1950-2006-JENSEN',
'ICCAT-SKJWATL-1952-2006-JENSEN',
'ICCAT-SWORDMED-1968-2006-JENSEN',
'ICCAT-SWORDNATL-1978-2007-JENSEN',
'ICCAT-SWORDSATL-1950-2005-JENSEN',
'ICCAT-YFINATL-1970-2006-JENSEN',
'IFOP-CHTRACCH-1975-2007-JENSEN',
'INIDEP-ARGHAKENARG-1985-2007-Parma',
'INIDEP-ARGHAKESARG-1985-2008-Parma',
'INIDEP-PATGRENADIERSARG-1983-2006-Parma',
'MARAM-ANCHOSA-1984-2006-deMoor',
'MARAM-CHAKESA-1917-2008-DEDECKER',
'MARAM-CTRACSA-1950-2007-Johnston',
'MARAM-KINGKLIPSA-1932-2008-DEDECKER',
'MARAM-SARDSA-1984-2006-deMoor',
'MARAM-SSLOBSTERSASC-1973-2008-Johnston',
'NAFO-SC-AMPL3LNO-1955-2007-BAUM',
'NAFO-SC-COD3NO-1953-2007-BAUM',
'NAFO-SC-GHAL23KLMNO-1960-2006-PREFONTAINE',
'NAFO-SC-REDFISHSPP3LN-1959-2008-BAUM',
'NAFO-SC-YELL3LNO-1960-2009-BAUM',
'NEFSC-AMPL5YZ-1960-2008-OBRIEN',
'NEFSC-BLUEFISHATLC-1981-2007-SHEPHERD',
'NEFSC-BSBASSMATLC-1968-2007-SHEPHERD',
'NEFSC-CODGB-1960-2008-BAUM',
'NEFSC-CODGOM-1893-2008-BAUM',
'NEFSC-HAD5Y-1956-2008-BAUM',
'NEFSC-MONKGOMNGB-1964-2006-RICHARDS',
'NEFSC-MONKSGBMATL-1964-2006-RICHARDS',
'NEFSC-SCALLGB-1964-2006-HART',
'NEFSC-SCALLMATLC-1964-2006-HART',
'NEFSC-TILEMATLC-1973-2008-NITSCHKE',
'NEFSC-WHAKEGBGOM-1963-2007-SOSEBEE',
'NEFSC-WINFLOUN5Z-1982-2007-HENDRICKSON',
'NEFSC-WINFLOUNSNEMATL-1940-2007-TERCEIRO',
'NEFSC-YELLGB-1935-2008-BAUM',
'NIWA-AUSSALMONNZ-1975-2006-JENSEN',
'NIWA-OROUGHYNZMEC-1981-2004-JENSEN',
'NMFS-MENATLAN-1940-2005-STANTON',
'NMFS-SARDNPAC-1981-2008-STANTON',
'NWFSC-ARFLOUNDPCOAST-1916-2007-BRANCH',
'NWFSC-BLACKROCKNPCOAST-1914-2006-BRANCH',
'NWFSC-BLACKROCKSPCOAST-1915-2007-BRANCH',
'NWFSC-BOCACCSPCOAST-1951-2006-BRANCH',
'NWFSC-CHILISPCOAST-1892-2007-BRANCH',
'NWFSC-CROCKPCOAST-1916-2007-BRANCH',
'NWFSC-DKROCKPCOAST-1928-2007-BRANCH',
'NWFSC-ESOLEPCOAST-1876-2007-BRANCH',
'NWFSC-LNOSESKAPCOAST-1915-2007-BRANCH',
'NWFSC-PHAKEPCOAST-1966-2008-BRANCH',
'NWFSC-POPERCHPCOAST-1953-2007-BRANCH',
'NWFSC-PSOLENPCOAST-1910-2005-STANTON',
'NWFSC-PSOLESPCOAST-1874-2005-STANTON',
'NWFSC-WROCKPCOAST-1955-2006-BRANCH',
'NWFSC-YEYEROCKPCOAST-1923-2006-BRANCH',
'NWFSC-YTROCKNPCOAST-1967-2005-STANTON',
'NWWG-CAPEICE-1977-2007-MINTO',
'NWWG-CODFAPL-1959-2006-MINTO',
'NWWG-CODICE-1952-2006-MINTO',
'NWWG-HADFAPL-1955-2006-MINTO',
'NWWG-HADICE-1977-2007-MINTO',
'NWWG-POLLFAPL-1958-2006-MINTO',
'NZMFishDEEPWATER-SMOOTHOREOCR-1979-2006-JENSEN',
'NZMFishDEEPWATER-SMOOTHOREOWECR-1973-2004-JENSEN',
'NZMFishHOKIWG-HOKIENZ-1972-2007-FRANCIS',
'NZMFishHOKIWG-HOKIWNZ-1972-2007-FRANCIS',
'NZMFishINSHOREWG-NZSNAPNZ8-1931-2005-JENSEN',
'NZMFishINSHOREWG-TREVALLYTRE7-1944-2005-JENSEN',
'NZMFishLOBSTERWG-RROCKLOBSTERCRA1-1945-2001-JENSEN',
'NZMFishLOBSTERWG-RROCKLOBSTERCRA2-1945-2001-JENSEN',
'NZMFishLOBSTERWG-RROCKLOBSTERCRA4-1945-2005-JENSEN',
'NZMFishLOBSTERWG-RROCKLOBSTERCRA5-1945-2002-JENSEN',
'NZMFishLOBSTERWG-RROCKLOBSTERCRA7-1976-2005-JENSEN',
'NZMFishLOBSTERWG-RROCKLOBSTERCRA8-1976-2005-JENSEN',
'NZMFishMIDDEPTHSWG-NZLINGLIN3-4-1972-2007-JENSEN',
'NZMFishMIDDEPTHSWG-NZLINGLIN5-6-1972-2007-JENSEN',
'NZMFishMIDDEPTHSWG-NZLINGLIN6b-1980-2006-JENSEN',
'NZMFishMIDDEPTHSWG-NZLINGLIN72-1972-2007-JENSEN',
'NZMFishMIDDEPTHSWG-NZLINGLIN7WC-1972-2008-JENSEN',
'NZMFishMIDDEPTHSWG-SBWHITACIR-1979-2006-JENSEN',
'NZMFishSHELLFISHWG-PAUAPAU5A-1964-2006-JENSEN',
'NZMFishSHELLFISHWG-PAUAPAU5B-1963-2007-JENSEN',
'NZMFishSHELLFISHWG-PAUAPAU5D-1964-2006-JENSEN',
'NZMFishSHELLFISHWG-PAUAPAU7-1964-2008-JENSEN',
'RIDEM-LOBSTERRI-1959-2007-COLLIE',
'RIDEM-TAUTOGRI-1959-2007-COLLIE',
'RIDEM-WINFLOUNDRI-1959-2007-COLLIE',
'SEFSC-GAGGM-1963-2004-JENSEN',
'SEFSC-MENATGM-1964-2004-GILROY',
'SEFSC-RPORGYSATLC-1972-2005-JENSEN',
'SEFSC-SPANMACKSATLC-1950-2008-JENSEN',
'SEFSC-TILESATLC-1961-2002-STANTON',
'SPC-ALBASPAC-1959-2007-JENSEN',
'SPC-BIGEYEWPO-1952-2007-JENSEN',
'SPC-SKJCWPAC-1972-2007-JENSEN',
'SPC-YFINCWPAC-1952-2006-JENSEN',
'SWFSC-DSOLEPCOAST-1910-2005-STANTON',
'SWFSC-STFLOUNNPCOAST-1970-2005-STANTON',
'SWFSC-STFLOUNSPCOAST-1970-2005-STANTON',
'WGBFAS-CODBA2224-1969-2007-JENNINGS',
'WGBFAS-CODBA2532-1964-2007-JENNINGS',
'WGBFAS-CODKAT-1970-2006-MINTO',
'WGBFAS-HERR2532-1973-2006-JENNINGS',
'WGBFAS-HERR30-1972-2007-JENNINGS',
'WGBFAS-HERR31-1979-2006-JENNINGS',
'WGBFAS-HERRIsum-1983-2007-JENNINGS',
'WGBFAS-HERRRIGA-1976-2007-JENNINGS',
'WGBFAS-SOLEIIIa-1982-2007-JENNINGS',
'WGBFAS-SPRAT22-32-1973-2007-JENNINGS',
'WGHMM-FMEG8c9a-1986-2006-JENNINGS',
'WGHMM-HAKENRTN-1977-2007-JENNINGS',
'WGHMM-MEG8c9a-1985-2007-JENNINGS',
'WGHMM-SOLEVIII-1982-2006-JENNINGS',
'WGMHSA-MACKNEICES-1972-2007-JENNINGS',
'WGNPBW-BWHITNEA-1980-2007-JENNINGS',
'WGNSDS-CODIS-1968-2006-MINTO',
'WGNSDS-CODVIa-1977-2006-MINTO',
'WGNSDS-HADVIa-1977-2006-MINTO',
'WGNSDS-PLAICIS-1962-2006-MINTO',
'WGNSDS-SOLEIS-1968-2006-MINTO',
'WGNSSK-CODNS-1962-2007-MINTO',
'WGNSSK-HADNS-IIIa-1963-2006-MINTO',
'WGNSSK-NPOUTNS-1983-2007-MINTO',
'WGNSSK-POLLNS-VI-IIIa-1964-2006-MINTO',
'WGNSSK-SEELNS-1983-2007-MINTO',
'WGNSSK-WHITNS-VIId-IIIa-1979-2006-MINTO',
'WGSSDS-PLAICCELT-1976-2006-JENNINGS',
'WGSSDS-PLAICECHW-1975-2006-JENNINGS',
'WGSSDS-SOLECS-1970-2006-JENNINGS',
'WGSSDS-SOLEVIIe-1968-2006-JENNINGS',
'WGSSDS-WHITVIIek-1982-2007-JENNINGS'
)
);

COMMENT ON TABLE srdb.spfits_schaefer IS 'This table stores the parameter estimates from the Schaefer surplus production model ran against the catch and total biomass timeseries. The assessment included in this table are only those who have been manually checked for proper fit.';

CREATE TABLE srdb.spfits AS (
SELECT * FROM srdb.spfits_schaefer
);

COMMENT ON TABLE srdb.spfits IS 'This table stores the parameter estimates from the Schaefer surplus production model ran against the catch and total biomass timeseries. The assessment included in this table are only those who have been manually checked for proper fit.';


CREATE TABLE srdb.spfits_schaefer_temp AS (
SELECT
a.assessid,
(CASE WHEN (a.assessid = sp.assessid) THEN 'yes' ELSE 'no' END) as catchandbiomass,
(CASE WHEN (a.assessid = sp.assessid) THEN (CASE WHEN (sp.qualityflag = -8) THEN 'no' ELSE 'yes' END) ELSE '' END)  as convergence
FROM
srdb.assessment a
LEFT OUTER JOIN
srdb.spfits_schaefer_all sp
ON (a.assessid = sp.assessid)
WHERE
a.recorder != 'MYERS'
order by catchandbiomass, convergence, assessid
)
;


DROP TABLE srdb.spfits_schaefer_summary;

CREATE TABLE srdb.spfits_schaefer_summary AS (
SELECT
spt.assessid,
spt.catchandbiomass,
spt.convergence,
(CASE WHEN (spt.catchandbiomass='no') THEN '' ELSE (CASE WHEN (spt.assessid=sp.assessid) THEN 'yes' ELSE 'no' END) END) as kept
FROM
srdb.spfits_schaefer_temp spt
LEFT OUTER JOIN
srdb.spfits_schaefer sp
on (spt.assessid = sp.assessid)
order by catchandbiomass, convergence, kept, assessid
);

DROP TABLE srdb.spfits_schaefer_temp;