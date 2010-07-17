#!/bin/bash
# load spreadsheets that have passed QA/QC
# - adding calls to the appropriate Perl script as the submissions are QAQCed
# Last modified Time-stamp: <2010-07-16 12:11:09 (srdbadmin)>
#

# submissions from Beth Fulton
# select q.issueid, q.issueurl, a.xlsfilename from srdb.qaqc q, srdb.assessment a where a.assessid=q.assessid and q.assessid in (select assessid from srdb.assessment where recorder = 'FULTON');
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-east_orange_roughy-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-east-gemfish-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-west-ling-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-east-ling-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-morwong-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-silver_warehou-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-tiger_flathead-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-whiting-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-cascade_orange_roughy-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-west_blue_warehou-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-deepwater_flathead-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-bight_redfish-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-east_blue_warehou-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-brown_tiger_prawn-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-grooved_tiger_prawn-australia-2007_v2-editedDR-QAQC.xls

# submissions from Ana Parma
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Parma-PHALCANUS-NPacific-editedDR-QAQC.xls

# submissions from Trevor Branch and South African scientists
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/BRANCH-DKROCKPCOAST-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/BRANCH-ARFLOUNDPCOAST-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/BRANCH-BLACKROCKNPCOAST-2007-editedDR-QAQC-revised.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/BRANCH-BLACKROCKSPCOAST-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/BRANCH-BLUEROCKCAL-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/BRANCH-SABLEFPCOAST-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/BRANCH-COWCODSCAL-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/BRANCH-LNOSESKAPCOAST-2007-editedDR-QAQC.xls


# submissions from Jeremy Collie
perl ../perl/srDB-load-xls-forv4-BATCH.pl ../spreadsheets/COLLIE-RSOLEHSTR-2001-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4-BATCH.pl ../spreadsheets/COLLIE-ESOLEHSTR-2001-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4-BATCH.pl ../spreadsheets/COLLIE-LOBRIDEM-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4-BATCH.pl ../spreadsheets/COLLIE-WFRIDEM-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4-BATCH.pl ../spreadsheets/COLLIE-TORIDEM-2008-editedDR-QAQC.xls

# Simon Jennings
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-COD2224-1970-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-COD2532-1966-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-HADROCK-1991-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-HER2532-1974-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-HER30-1973-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-HER31-1973-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-HERRIGA-1977-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-HKENRTN-1978-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-HKESOTH-1982-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-SPR2232-1974-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-ANEBISC-1987-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-HAD7BK-1993-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-HERVASU-1986-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-MACNEA-1972-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-MGB8C9A-1986-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-MGW8C9A-1986-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-PLECELT-1977-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-PLEECHW-1976-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-SOLBISC-1984-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-SARSOTH-1978-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-SOLCELT-1971-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-GHLARCT-1969-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-HERIRLN-1961-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-SOLECHW-1969-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-WHBCOMB-1972-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-SOLKASK-1984-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENNINGS-ICES-WHG7EK-1982-2007-editedDR-QAQC.xls


# submissions from Boris Worm
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/WORM-ATBTUNAEATL-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/WORM-ATBTUNAWATL-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/WORM-ALBANATL-2007-editedDR-QAQC.xls

# submissions from Coilin Minto
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CODNEAR-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-GOLDREDNEAR-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CAPENOR-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CODNORCOAST-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HADNEAR-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-POLLNEAR-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-REDDEEPI-II-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HERR2224IIIa-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HERRNS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HERRVIa-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HERRVIaVIIbc-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-SPRATNS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CAPEICE-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CODFAPL-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CODICE-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HADFAPL-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HADICE-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-POLLFAPL-2007-editedDR-QAQC.xls

perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CODKAT-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CODVIIa-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CODVIa-2007-editedDR-QAQC-revised.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HADIS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HADVIa-2007-editedDR-QAQC-revised.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-PLAICIS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-SOLEIS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-WHITVIa-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HADNS-IIIa-2007-editedDR-QAQC-revised.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-NPOUTNS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-PLAIC7d-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-PLAICIIIa-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-PLAICNS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-POLLNS-VI-IIIa-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-SEELNS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-SOLENS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-SOLEVIId-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-WHITNS-VIId-IIIa-2007-editedDR-QAQC-revised.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/MINTO-CODNS-2007-example-editedDR-QAQC.xls

# submissions from Olaf Jensen and minions 
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl  ../spreadsheets/JENSEN-RKCRABBB-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl  ../spreadsheets/JENSEN-TANNERCRABBSAI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl  ../spreadsheets/JENSEN-RKCRABPI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl  ../spreadsheets/JENSEN-BKINGCRABPI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl  ../spreadsheets/JENSEN-BKINGCRABSMI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl  ../spreadsheets/JENSEN-RGROUPGM-2006-editedDR-QAQC.xls

# KATE STANTON, working with Olaf Jensen
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-FLSOLEBSAI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-REYEROCKBSAI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-SRAKEROCKBSAI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-NRSOLEEBSAI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-ATKABSAI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-GHALBSAI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-ARFLOUNDBSAI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-NROCKBSAI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-PERCHEBSAI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-ARFLOUNDGA-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-DSOLEWC-2005-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-WCgopher-2005-editedDR-QAQC-longtimeseries.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-SouthStarryFlounder-2005-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-NorthStarryFlounder-2005-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-VSNAPSATLC-editedDR-QAQC.xls




# submissions from Julia Baum, Renee Prefontaine and Jeffrey Hutchings
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl  ../spreadsheets/PREFONTAINE-GHAL01ABCDEF-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl  ../spreadsheets/PREFONTAINE-MONK2J3KLNOPs-2001-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-WHAKE4VWX5-2005-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-AMPL23K-2003-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-COD4TVn-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-COD3Ps-2004-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-COD4VsW-2003-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-COD5Zjm-2003-editedDR-QAQC.xls

perl ../perl/srDB-load-xls-forv4-BATCH.pl ../spreadsheets/BAUM-COD3NO-2007-editedDR-QAQC.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-GAGSATLC-2006-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-GAGGM-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-VSNAPGM-2006-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-GRAMBERGM-2006-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-SPANMACKSATLC-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-ALBWPO-2008-editedDR-OJ-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-BETWPO-2008-editedDR-OJ-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-YFINCWPAC-2008-editedDR-OJ-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-SKJCWPAC-2008-editedDR-OJ-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-RPORGYSATLC-2006-editedDR-QAQC.xls




perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/MELNYCHUK-WPOLLEBS-2008-editedDR-QAQC.xls

# BRANCH
# Trevor Branch spreadsheets
# received 2008-11-19
# QAQCed
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/BRANCH-ESOLEPCOAST-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/BRANCH-ARFLOUNDPCOAST-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/BRANCH-BLACKROCKSPCOAST-2007-editedDR-QAQC.xls


perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-SNOWGROUPSATLC-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-TILESATLC-editedDR-QAQC.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-YellowTailWC-editedDR-QAQC.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/BRANCH-POPERCHPCOAST-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/BRANCH-BOCACCSPCOAST-2007-editedDR-QAQC.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/MELNYCHUK-SABLEFEBSAIGA-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/MELNYCHUK-ALPLAICBSAI-2008-editedDR-QAQC.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/BRANCH-PHAKEPCOAST-2008-editedDR-QAQC.xls
