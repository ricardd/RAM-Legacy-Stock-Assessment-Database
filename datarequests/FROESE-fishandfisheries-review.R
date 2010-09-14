## creating csv files for Rainer Froese' review of the database
## just dumping the management table, and the timeseries and referencepoints views
## Daniel Ricard started 2010-08-30
## last modified Time-stamp: <2010-08-30 11:08:21 (srdbadmin)>

require(RODBC)
chan <- odbcConnect(dsn="srdbcalo")
qu <- paste("select * from srdb.assessment where recorder != 'MYERS'",sep="")
write.csv(sqlQuery(chan,qu), "management.csv")

qu <- paste("select * from srdb.newtimeseries_values_view",sep="")
write.csv(sqlQuery(chan,qu), "timeseries-values.csv")

qu <- paste("select * from srdb.newtimeseries_unitss_view",sep="")
write.csv(sqlQuery(chan,qu), "timeseries-units.csv")

qu <- paste("select * from srdb.reference_point_values_view where assessid in (select assessid from srdb.assessment where recorder != 'MYERS')",sep="")
write.csv(sqlQuery(chan,qu), "refpoints-values.csv")

qu <- paste("select * from srdb.reference_point_values_view where assessid in (select assessid from srdb.assessment where recorder != 'MYERS')",sep="")
write.csv(sqlQuery(chan,qu), "refpoints-units.csv")

odbcClose(chan)
