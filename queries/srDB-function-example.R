# srDB-function-example.R
#

require(RODBC)

query.timeseries <- function(a.id) {

chan <- odbcConnect(dsn="srDBcalo", uid = "ricardd", pwd="ricardd", case='postgresql',believeNRows=FALSE)
qu <- paste("select ts.assessid, ts.tsid, ts.tsyear, ts.tsvalue from srdb.timeseries ts where ts.assessid = '", a.id, "'", sep="")

res <- sqlQuery(chan, qu, errors= TRUE)

odbcClose(chan)
return(res)
}
