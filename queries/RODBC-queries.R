# RODBC-queries.R
# first pass at getting data out of srDB
#

require(RODBC)

chan <- odbcConnect(dsn="gfsDBcalo", uid = "ricardd", pwd="ricardd", case='postgresql',believeNRows=FALSE)

a.id <- paste("AFSC-PCODGOA-1977-2007-BAUM")
qu <- paste("select ts.tsid, ts.tsyear, ts.tsvalue from srdb.timeseries ts where ts.assessid = '", a.id, "'", sep="")

res <- sqlQuery(chan, qu, errors= TRUE)
}
odbcClose(chan)

yy <- subset(res, tsid == "YEAR-yr")
ssb <-  subset(res, tsid == "SSB-MT")
r <-  subset(res, tsid == "R-E04")

postscript("PCODGOA.pdf")
par(mfrow=c(3,1))
plot(yy$tsvalue, ssb$tsvalue, xlab="year", ylab="SSB", type='b')
title("Gulf of Alaska - Pacific Cod")
plot(yy$tsvalue, r$tsvalue, xlab="year", ylab="R", type='b')
plot(ssb$tsvalue, r$tsvalue, xlab="SSB", ylab="R", type='b')
dev.off()
  
