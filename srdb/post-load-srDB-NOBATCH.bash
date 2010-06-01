#!/bin/bash
# bash script to perform post-load tasks in the stock-recruitment database
# - adding calls to the appropriate Perl script as the assessments come in
# 
# Last modified Time-stamp: <2008-08-25 13:51:43 (ricardd)>
# load spreadsheets

# initial spreadsheets, using Excel template v3
# first 3 assessments - Feb. 2008
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/BAUM-PCODGA_2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/HUTCHINGS-COD4T-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-CODNEAR-2007-editedDR.xls


# Coilin's first batch - April 09 2008
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-CAPENOR-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-CODFAPL-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-CODNORCOAST-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-GHALNEAR-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-GOLDREDNEAR-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-HADFAPL-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-HADNEAR-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-POLLNEAR-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-REDDEEPI_II-2007-editedDR.xls


# Coilin's second batch - April 14 2008
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-CAPEICE-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-CODICE-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-CODNS-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-HADICE-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-HERRIsum-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-NPOUTNS-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-PLAIC7d-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-PLAICIIIa-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-POLLFAPL-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-SEELNS-2007-editedDR.xls

# Coilin's third batch - April 15 2008
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-CODVIa-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-CODIS-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-HADNS-IIIa-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-HADVIa-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-PLAICNS-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-POLLNS-VI-IIIa-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-SOLENS-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-SOLEVIId-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-WHITNS-VIId-IIIa-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-WHITVIa-2007-editedDR.xls

# Coilin's fourth batch - April 16 2008
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-CODKAT-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-HADIS-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-HERRNS-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-HERRVIa-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-HERRVIaVIIbc-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-HERR2224IIIa-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-HERRNIRS-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-PLAICIS-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-SOLEIS-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv3.pl ../spreadsheets/MINTO-SPRATNS-2007-editedDR.xls

####################################################
# post-NCEAS-meeting spreadsheets, using Excel template v4
####################################################

# Julia's spreadsheets before NCEAS meeting - Sent early April 2008
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/BAUM-AMPL3M-2006-editedDR.xls
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/BAUM-AMPL3LNO-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/BAUM-COD3NO-2007-editedDR.xls

# Jeremy Collie's first 5 assessments, 2008-04-14
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/COLLIE-LOBRIDEM-2008-editedDR.xls
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/COLLIE-PCODHS-2005-editedDR.xls
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/COLLIE-PCODWCVANI-2002-editedDR.xls
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/COLLIE-TORIDEM-2008-editedDR.xls
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/COLLIE-WFRIDEM-2008-editedDR.xls

# Beth Fulton's first 7 assessments, not including NWS data, sent 2008-04-19
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/Fulton-east-gemfish-australia-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/Fulton-east-ling-australia-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/Fulton-morwong-australia-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/Fulton-silver_warehou-australia-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/Fulton-tiger_flathead-australia-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/Fulton-west-ling-australia-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/Fulton-whiting-australia-2007-editedDR.xls
###
### TO DO: Beth sent revised versions of spreadsheet, and other assessments on 2008-05-05
###
# Fulton-brown_tiger_prawn-australia-2007_v2.xls 
# Fulton-cascade_orange_roughy-australia-2007_v2.xls 	
# Fulton-silver_warehou-australia-2007_v2.xls 
# Fulton-west_blue_warehou-australia-2007_v2.xls 
# Fulton-east_orange_roughy-australia-2007_v2.xls 
# Fulton-deepwater_flathead-australia-2007_v2.xls 
# Fulton-bight_redfish-australia-2007_v2.xls 
# Fulton-east_blue_warehou-australia-2007_v2.xls 
# Fulton-west-ling-australia-2007_v2.xls 
# Fulton-east-gemfish-australia-2007_v2.xls 
# Fulton-whiting-australia-2007_v2.xls 
# Fulton-morwong-australia-2007_v2.xls 
# Fulton-east-ling-australia-2007_v2.xls 
# Fulton-tiger_flathead-australia-2007_v2.xls 
# Fulton-grooved_tiger_prawn-australia-2007_v2.xls 

# Mike Fogarty's spreadhseet with NMFS stocks
perl ../perl/srDB-load-NMFS.pl ../spreadsheets/FOGARTY-SIS_TimeSeriesData-1-editedDR.xls


# Renee Prefontaine's assessments for Jeffrey Hutchings

# second batch, received 2008-07-02, edited and loaded 2008-08-21
perl ../perl/srDB-load-xls-forv4.2.pl ../spreadsheets/PREFONTAINE-COD3NO-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2.pl ../spreadsheets/PREFONTAINE-COD5Zjm-2003-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2.pl ../spreadsheets/PREFONTAINE-HERR4VWX-2006-editedDR.xls

# third batch, received 2008-08-18
perl ../perl/srDB-load-xls-forv4.2.pl ../spreadsheets/PREFONTAINE-HAD4X5Y-2003-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2.pl ../spreadsheets/PREFONTAINE-HAD5Zejm-2003-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2.pl ../spreadsheets/PREFONTAINE-HERR4RFA-2004-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2.pl ../spreadsheets/PREFONTAINE-HERR4RSP-2004-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2.pl ../spreadsheets/PREFONTAINE-POLL4VWX5Zc-2006-editedDR.xls

# fourth batch, received 2008-08-20
perl ../perl/srDB-load-xls-forv4.2.pl ../spreadsheets/PREFONTAINE-COD2J3KLIS-2006-editedDR.xls
perl ../perl/srDB-load-xls-forv4.2.pl ../spreadsheets/PREFONTAINE-COD3Pn4RS-2007-editedDR.xls

# Olaf Jensen's spreadsheets
perl ../perl/srDB-load-xls-forv4.2.pl ../spreadsheets/JENSEN-YFINEPAC-2006-editedDR.xls


# Jeremy Collie's Pacific assessments, received on 2008-08-12, edited and loaded on 2008-08-21
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/COLLIE-HERRCC-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/COLLIE-HERRPRD-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/COLLIE-HERRQCI-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/COLLIE-HERRSOG-2007-editedDR.xls
perl ../perl/srDB-load-xls-forv4.pl ../spreadsheets/COLLIE-HERRWCVI-2007-editedDR.xls
