## R script to extract srdb data for tuna and billfish stocks, requested by Boriw Worm and Derek Tittensor
## Daniel Ricard created 2010-11-03
## Last modified Time-stamp: <2010-11-03 14:09:20 (srdbadmin)>
##
require(RODBC)
require(lattice)

chan <- odbcConnect(dsn='srdbcalo')

qu <- paste("
SELECT
s.stockid, s.stocklong,
t.scientificname, t.commonname1,
tsv.*,
tsu.*
FROM
srdb.assessment a,
srdb.stock s,
srdb.taxonomy t,
srdb.timeseries_values_view tsv,
srdb.timeseries_units_view tsu
WHERE
tsv.assessid=tsu.assessid AND
a.assessid = tsv.assessid AND
a.stockid=s.stockid AND
s.tsn = t.tsn AND
t.genus in ('Thunnus','Makaira','Istiophorus','Tetrapturus','Xiphias','Katsuwonus')
ORDER BY
tsv.assessid, tsv.tsyear
            ",
            sep="")

billfish.tuna.data <- sqlQuery(chan,qu,stringsAsFactors=FALSE)
odbcClose(chan)


summary(billfish.tuna.data)
my.xlim <- range(billfish.tuna.data$tsyear)

my.ssb <- subset(billfish.tuna.data,ssb != 'NA')
my.ylim <- as.vector(tapply(my.ssb$ssb,my.ssb$stockid,range))
xyplot(ssb~tsyear|stockid, data=my.ssb, xlim=my.xlim)

my.total <- subset(billfish.tuna.data,total != 'NA')
xyplot(total~tsyear|stockid, data=my.total, xlim=my.xlim)

write.csv(billfish.tuna.data, "Worm-Tittensor-tuna-billfish-20101103.csv", row.names=FALSE)

## test.load.data <- read.csv("Worm-Tittensor-tuna-billfish-20101103.csv")
