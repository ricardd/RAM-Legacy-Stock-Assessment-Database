require(RODBC)

# connect to srDB
chan <- odbcConnect(dsn="srDBcalo", uid = "ricardd", pwd="ricardd", case='postgresql',believeNRows=FALSE)


qu <- paste("select distinct aa.assessid, aa.tsid as SSB from srdb.timeseries aa, srdb.tsmetrics bb WHERE aa.tsid=bb.tsunique AND bb.tscategory = \'SPAWNING STOCK BIOMASS or CPUE\' GROUP BY aa.assessid, bb.tscategory, aa.tsid",sep="")
my.ssbs <- sqlQuery(chan,qu)

qu <- paste("select distinct aa.assessid, aa.tsid as R from srdb.timeseries aa, srdb.tsmetrics bb WHERE aa.tsid=bb.tsunique AND bb.tscategory = \'RECRUITS (NOTE: RECRUITS ARE OFFSET IN TIME SERIES BY THE AGE OF RECRUITMENT)\' GROUP BY aa.assessid, bb.tscategory, aa.tsid",sep="")
my.rs <- sqlQuery(chan,qu)

my.merged <- merge(my.ssbs, my.rs, "assessid")

qu <- paste("select distinct aa.assessid, aa.tsid as R from srdb.timeseries aa, srdb.tsmetrics bb WHERE aa.tsid=bb.tsunique AND bb.tscategory = \'FISHING MORTALITY\' GROUP BY aa.assessid, bb.tscategory, aa.tsid",sep="")
my.fs <- sqlQuery(chan,qu)

my.merged2 <- merge(my.merged, my.fs, "assessid")

qu <- paste("select distinct aa.assessid, aa.tsid as R from srdb.timeseries aa, srdb.tsmetrics bb WHERE aa.tsid=bb.tsunique AND bb.tscategory = \'CATCH or LANDINGS\' GROUP BY aa.assessid, bb.tscategory, aa.tsid",sep="")
my.cs <- sqlQuery(chan,qu)

my.merged3 <- merge(my.merged2, my.cs, "assessid")


odbcClose(chan)

