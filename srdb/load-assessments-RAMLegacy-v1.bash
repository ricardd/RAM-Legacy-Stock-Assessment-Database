#!/bin/bash
# load spreadsheets that have passed QA/QC and have been processed for the Fish and Fisheries manuscript, JUNE 2010
# Last modified Time-stamp: <2010-07-14 18:22:57 (srdbadmin)>
#

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

# South Africa's DETMC
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/deMoor-SAAnchovy-2007-editedDR.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Plaganyi-SA-abalone-2008-editedDR.xls  ## NOT QAQCed

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/WORM-ATBTUNAEATL-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/WORM-ATBTUNAWATL-2008-editedDR-QAQC.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Parma-ANCHOVY-ARG-S-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Parma-ANCHOVY-ARG-N-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Parma-POLACA-ARG-S-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Parma-AHAKE-ARG-S-2009-v2-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Parma-AHAKE-ARG-N-2008-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/Parma-HOKI-ARG-S-2007-editedDR-QAQC.xls

perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-SWORDSATL-2007-editedDR-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/JENSEN-SWORDNATL-2007-editedDR-QAQC.xls

# DFO stocks
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-HAD5Zejm-2003-editedDR-jbQAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-HERR4TFA-2007-editedRP-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-HERR4TSP-2007-editedRP-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-HERR4RFA-2004-editedRP-QAQC.xls
perl ../perl/srDB-load-xls-forv4.2-BATCH.pl ../spreadsheets/PREFONTAINE-HERR4RSP-2004-editedRP-QAQC.xls
