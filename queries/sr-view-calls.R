#
#
#

require(RODBC)

chan <- odbcConnect(dsn="srDBcalo", uid = "ricardd", pwd="ricardd", case='postgresql',believeNRows=FALSE)

qu <- paste("select distinct ts.assessid from srdb.timeseries ts, srdb.tsmetrics tsm where tsm.tsunique=ts.tsid and tsm.tsshort like 'SSB%'", sep="")
stocks.with.ssb <- sqlQuery(chan, qu, errors= TRUE)


qu <- paste("select distinct ts.assessid from srdb.timeseries ts, srdb.tsmetrics tsm where tsm.tsunique=ts.tsid and tsm.tsshort like 'R%'", sep="")
stocks.with.r <- sqlQuery(chan, qu, errors= TRUE)

qu <- paste("select distinct ts.assessid from srdb.timeseries ts, srdb.tsmetrics tsm where tsm.tsunique=ts.tsid and tsm.tsshort like 'F%'", sep="")
stocks.with.f <- sqlQuery(chan, qu, errors= TRUE)


odbcClose(chan)

source("sr-view-fct.R")

pdf("HADFAPL.pdf", paper='letter')
sr.view.fct("NWWG-HADFAPL-1955-2007-MINTO")
dev.off()
