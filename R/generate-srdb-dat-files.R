## script to generate text files with the contents of the background tables for srdb
## I'm doing this because I am upgrading to postgreSQL 8.4 and migrating to nautilus-vm, and the current .dat files are likely to be missing some values that were added to the database using INSERT statements
## Daniel Ricard
## last modified Time-stamp: <2010-12-02 16:35:28 (srdbadmin)>
require(RODBC)
chan <- odbcConnect(dsn='srdbcalo')

## management
qu <- paste("select * from srdb.management",sep="")
mgmt <- sqlQuery(chan,qu)
write.csv(mgmt, "../srdb/data/management-fromdb.dat",row.names=FALSE)

## taxonomy
qu <- paste("select * from srdb.taxonomy",sep="")
tax <- sqlQuery(chan,qu)
write.csv(tax, "../srdb/data/taxonomy-fromdb.dat",row.names=FALSE)

## area
qu <- paste("select * from srdb.area",sep="")
area <- sqlQuery(chan,qu)
write.csv(area[,1:5], "../srdb/data/area-fromdb.dat",row.names=FALSE)

## recorder
qu <- paste("select * from srdb.recorder",sep="")
recorder <- sqlQuery(chan,qu)
write.csv(recorder, "../srdb/data/recorder-fromdb.dat",row.names=FALSE)

## tsmetrics
qu <- paste("select * from srdb.tsmetrics",sep="")
tsmetrics <- sqlQuery(chan,qu)
write.csv(tsmetrics, "../srdb/data/tsmetrics-fromdb.dat",row.names=FALSE)

## biometrics
qu <- paste("select * from srdb.biometrics",sep="")
biometrics <- sqlQuery(chan,qu)
write.csv(biometrics, "../srdb/data/biometrics-fromdb.dat",row.names=FALSE)

## risfields
qu <- paste("select * from srdb.risfields",sep="")
risfields <- sqlQuery(chan,qu)
write.csv(risfields, "../srdb/data/risfields-fromdb.dat",row.names=FALSE)

## risfieldvalues
qu <- paste("select * from srdb.risfieldvalues",sep="")
risfieldvalues <- sqlQuery(chan,qu)
write.csv(risfieldvalues, "../srdb/data/risfieldvalues-fromdb.dat",row.names=FALSE)

## stocks
qu <- paste("select * from srdb.stock",sep="")
stock <- sqlQuery(chan,qu)
write.csv(stock, "../srdb/data/stock-fromdb.dat",row.names=FALSE)

## assessors

## assessmethods


odbcClose(chan)
