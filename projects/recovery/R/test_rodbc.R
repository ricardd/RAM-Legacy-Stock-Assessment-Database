# Purpose: generate the data for recovery analysis from the srdb views
# Started: Thu Oct 30 13:42:00 ADT 2008
# JB
# Last modified: Time-stamp: <2009-01-16 16:37:03 (mintoc)>

# Load necessaries
require(RODBC)
require(MASS)
# connect to the srDB
chan <- odbcConnect(dsn="srdbusercalo", uid = "srdbuser", pwd="srd6us3r!", case='postgresql',believeNRows=FALSE)
qu<-paste("select * from srdb.timeseries_values_view limit 100")
my.dat<-sqlQuery(chan,qu)
