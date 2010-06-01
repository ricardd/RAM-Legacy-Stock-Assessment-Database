# ICES-fried-egg-plots.R
# generate a fried egg plot per year for ICES data
# generate an AVI file with all the files

require(RODBC)
chan <- odbcConnect(dsn="srdbcalo")


qu.assessids <- paste("select assessid from ((select assessid, min(tsyear) as minyr, max(tsyear) as maxyr from srdb.timeseries where assessid in (select assessid from srdb.assessment where recorder in ('JENNINGS','MINTO')) group by assessid) order by minyr) as a where minyr<=1980 and maxyr>=2005", sep="")


for (i in 1980:2005) {
  
my.data <- sqlQuery(chan,qu)

}

