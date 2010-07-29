#!/bin/bash
# load spreadsheets that have passed QA/QC and have been processed for the Fish and Fisheries manuscript, JUNE 2010
# Last modified Time-stamp: <2010-07-28 10:21:28 (srdbadmin)>
#
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/RICARD-PERUVIANANCHOVETA-1963-2004-editedDR.xls

# assessments are here in the order they appear in F&F manuscript Table S1, ie. by management body
# AFMA stocks
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-bight_redfish-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-east-ling-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-west-ling-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-cascade_orange_roughy-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-east_orange_roughy-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-morwong-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-tiger_flathead-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-brown_tiger_prawn-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-grooved_tiger_prawn-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-deepwater_flathead-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-TASGIANTCRAB-2008-editedDR.xls ## NOT QAQCed
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-east-gemfish-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-east_blue_warehou-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-west_blue_warehou-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-silver_warehou-australia-2007_v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Fulton-whiting-australia-2007_v2-editedDR-QAQC.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-TOOTHFISHRS-2007-v2-editedDR.xls ## NOT QAQCed



perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Parma-ANCHOVY-ARG-S-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Parma-ANCHOVY-ARG-N-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Parma-POLACA-ARG-S-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Parma-AHAKE-ARG-S-2009-v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Parma-AHAKE-ARG-N-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Parma-HOKI-ARG-S-2007-editedDR-QAQC.xls

# DFO stocks
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-HAD5Zejm-2003-editedDR-jbQAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-HERR4TFA-2007-editedRP-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-HERR4TSP-2007-editedRP-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-HERR4RFA-2004-editedRP-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-HERR4RSP-2004-editedRP-QAQC.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-COD3Pn4RS-2007-editedDR-QAQC.xls

perl ../perl/srDB-load-xls-forv4-BATCH.pl ../spreadsheets/COLLIE-HERRQCI-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4-BATCH.pl ../spreadsheets/COLLIE-HERRCC-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4-BATCH.pl ../spreadsheets/COLLIE-HERRPRD-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4-BATCH.pl ../spreadsheets/COLLIE-HERRSOG-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4-BATCH.pl ../spreadsheets/COLLIE-HERRWCVI-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4-BATCH.pl ../spreadsheets/COLLIE-PCODHS-2005-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4-BATCH.pl ../spreadsheets/COLLIE-PCODWCVANI-2002-editedDR-QAQC.xls

# South Africa's DETMC
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Branch-SA-PToothfish-2007-editedOJ.xls   ## NOT QAQCed
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Branch-SA-Kingklip-2008-editedOJ.xls   ## NOT QAQCed
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/deMoor-SAAnchovy-2007-editedDR.xls   ## NOT QAQCed
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/deMoor-SASardine-2007-editedDR.xls   ## NOT QAQCed

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Plaganyi-SA-abalone-2008-editedDR.xls  ## NOT QAQCed

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Johnston-SAWestRockLobster-A1-2-2007-editedDR.xls  ## NOT QAQCed
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Johnston-SAWestRockLobster-A3-4-2007-editedDR.xls  ## NOT QAQCed
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Johnston-SAWestRockLobster-A5-6-2007-editedDR.xls  ## NOT QAQCed
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Johnston-SAWestRockLobster-A7-2007-editedDR.xls  ## NOT QAQCed
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Johnston-SAWestRockLobster-A8-2007-editedDR.xls  ## NOT QAQCed
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/DEDECKER-SA-Mparadoxus-2008-editedDR.xls  ## NOT QAQCed
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/DEDECKER-SA-Mcapensis-2008-editedOJ.xls  ## NOT QAQCed
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Johnston-SASouthRockLobster-2008-editedDR.xls  ## NOT QAQCed
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Johnston-SAHorseMackerel-2007-editedDR.xls  ## NOT QAQCed

##
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-YFINEPAC-2006-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-BETEPAC-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-BETWPO-2008-editedDR-OJ-QAQC.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-BIGEYEATL-2008-editedOJ.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-SKJEATL-2008-editedOJ.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-SKJWATL-2008-editedOJ.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-YFINATL-2008-editedOJ.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/WORM-ALBANATL-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/WORM-ATBTUNAEATL-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/WORM-ATBTUNAWATL-2008-editedDR-QAQC.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-SWORDSATL-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-SWORDNATL-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-SWORDMED-2007-editedDR.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-BIGEYEIO-2007-editedDR.xls


## ICES
# submissions from Coilin Minto
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-SOLENS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-SOLEVIId-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HADICE-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-WHITNS-VIId-IIIa-2007-editedDR-QAQC-revised.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-GOLDREDNEAR-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CODNORCOAST-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CODNEAR-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CAPENOR-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/MINTO-CODNS-2007-example-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-REDDEEPI-II-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HERR2224IIIa-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HADNEAR-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-SPRATNS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CAPEICE-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-POLLNEAR-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HERRNS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HERRVIa-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HERRVIaVIIbc-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CODFAPL-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CODICE-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HADIS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HADFAPL-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-WHITVIa-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CODKAT-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-POLLFAPL-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CODVIIa-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-CODVIa-2007-editedDR-QAQC-revised.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HADVIa-2007-editedDR-QAQC-revised.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-PLAICIS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-SOLEIS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-HADNS-IIIa-2007-editedDR-QAQC-revised.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-NPOUTNS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-PLAIC7d-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-PLAICIIIa-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-PLAICNS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-POLLNS-VI-IIIa-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-SEELNS-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv3-BATCH.pl ../spreadsheets/MINTO-SEELNS-2007-editedDR-QAQC.xls

# submissions from Simon Jennings
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

## New Zealand stocks
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-SMOOTHOREOWECR-2004-v2-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-SMOOTHOREOCR-2004-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-BLACKOREOWECR-2007-v2-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/FRANCIS-HOK1W-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/FRANCIS-HOK1E-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-SQUIREFISHNZ8-2005-v2-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-TREVALLYNZ7-2005-v2-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-GEMFISHNZ-2007-v2-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-RROCKLOBSTERCRA1-2001-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-RROCKLOBSTERCRA2-2001-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-RROCKLOBSTERCRA3-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-RROCKLOBSTERCRA4-2005-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-RROCKLOBSTERCRA5-2002-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-RROCKLOBSTERCRA7-2005-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-RROCKLOBSTERCRA8-2005-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-KAHNZ-2006-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-PINKLINGNZ3-4-2007-v2-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-PINKLINGNZ5-6-2007-v2-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-PINKLINGNZ6b-2006-v2-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-PINKLINGNZ72-2007-v2-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-PINKLINGNZ7WC-2008-v2-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-SOHAKENZCR-2006-v2-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-SOHAKENZSA-2007-v2-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-BWHITINGNZCIR-2006-v2-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-BFOOTABALONENZ5A-2006-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-BFOOTABALONENZ5B-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-BFOOTABALONENZ5D-2006-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-BFOOTABALONENZ7-2008-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-OROUGHYMEC-2004-v2-editedDR.xls


## NMFS
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/MELNYCHUK-SABLEFEBSAIGA-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/BRANCH-SABLEFPCOAST-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Chute-oceanquahog-2008-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-GTRIGGM-2006-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/GILROY-MENHADENGM-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/FAUCONNET-BNOSESHARATL-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/FAUCONNET-FTOOTHSHARATL-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/FAUCONNET-BTIPSHARATL-2006-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/FAUCONNET-BTIPSHARSATL-2006-editedDR.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-ATLMENHADEN-editedDR.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/SHEPHERD-BLACKSEABASS-2008-editedOJ.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/COLLIE-HERRPWS-2006-editedOJ.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/COLLIE-HERRSIT-2007-editedOJ.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-SouthPetraleSole-2004-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-NorthPetraleSole-2004-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-SNOWGROUPSATLC-editedDR-QAQC.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/MELNYCHUK-PCODBSAI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/MELNYCHUK-PCODGA-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/WIGLEY-WITCH-2008-editedDR.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/STANTON-REXSOLEGA-2007-editedOJ-QAQC.xls


perl ../perl/srDB-load-xls-forv4.2-BATCH.pl  ../spreadsheets/JENSEN-RKCRABBB-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl  ../spreadsheets/JENSEN-BKINGCRABSMI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl  ../spreadsheets/JENSEN-GKINGCRABAIES-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl  ../spreadsheets/JENSEN-TANNERCRABBSAI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl  ../spreadsheets/JENSEN-RKCRABPI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl  ../spreadsheets/JENSEN-BKINGCRABPI-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl  ../spreadsheets/JENSEN-GKINGCRABAIWS-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl  ../spreadsheets/JENSEN-RKINGCRABNS-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-SNOWCRABBS-2008-editedDR-QAQC.xls


perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/OVERHOLTZ-ATLHERRING-2008-editedOJ.xls


