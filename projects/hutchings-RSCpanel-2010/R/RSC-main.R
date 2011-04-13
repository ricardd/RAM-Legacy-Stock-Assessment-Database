## main script for Jeff Hutching's Royal Society of Canada panel
## Daniel Ricard: started 2011-04-07
## Last modified Time-stamp: <2011-04-07 12:31:31 (srdbadmin)>
## Modification history:
##
## plots required:
# 1 - for each assessment, timeseries plots of SSB, TB and catch
# 2 - beanplot of B/Bmsy for different management bodies 
# 3 - timeseries of SSB/SSBmsy and SSB/meanSSB, for all, all by pelagic/demersal, Pacific by pelagic/demersal, Atlantic by pelagic/demersal and High Seas by pelagic/demersal
# 4 - timeseries of F/Fmsy and F/meanF, for all, all by pelagic/demersal, Pacific by pelagic/demersal, Atlantic by pelagic/demersal and High Seas by pelagic/demersal
# 5 - plots of total catch, for all, all by pelagic/demersal, Pacific by pelagic/demersal and Atlantic by pelagic/demersal

# start with a clean slate
rm(list=ls(all=TRUE))

# generate #1 above, the timeseries plots for all assessments of Canadian interest
source("RSC-tsplots-all.R")

# generate #2 above, the beanplots
source("RSC-bean.R")

## source the functions used for fitting the multi-stock indices and the plotting routines
source("RSC-functions.R")

## source the R script that performs the data extraction and that assesmbles the proper data frames required for the multi-stock analyses
source("RSC-data.R")

## generate #3 and #4 above, the multi-stock indices for SSB/SSBmsy, SSB/meanSSB, F/Fmsy and F/meanF
source("RSC-multistocks.R")

## write text files with the data for archiving purposes

save.image()
