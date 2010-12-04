

require(RODBC)
chan <- odbcConnect(dsn='srdbcalo')

qu <- paste("
select * from srdb.newtimeseries_values_view where assessid = 'ADFG-HERRPWS-1980-2006-COLLIE'
", sep="")
my.data <- sqlQuery(chan,qu)
