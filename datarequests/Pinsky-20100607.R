## R code to extract data for Malin Pinsky's paper on fisheries collapse
## Daniel Ricard 2010-06-07
## Last modified Time-stamp: <2010-06-08 22:43:04 (srdbadmin)>
require(RODBC)
chan <- odbcConnect(dsn="srdbusercalo")


## bring back assessment-derived reference points and associated timeseries
qu.pepper <- paste("
SELECT 
a.assessid,
a.stockid,
t.scientificname,
s.stocklong,
v.tsyear,
v.biovalue as bmsy,
v.bioid || ' linked to ' || v.tsid as type,
v.tsvalue,
v.tstobrpratio as ratio
FROM 
srdb.tsrelative_explicit_view v,
srdb.assessment a,
srdb.stock s,
srdb.taxonomy t
WHERE
v.assessid=a.assessid AND
a.stockid = s.stockid and 
s.tsn = t.tsn AND
v.bioid like '%Bmsy%'
",sep="")

pepper.dat <-  sqlQuery(chan,qu.pepper, stringsAsFactors=FALSE)
#pepper <- data.frame()

## bring back Schaefer-derived reference points and associated timeseries
qu.salt <- paste("
SELECT
a.assessid,
a.stockid,
t.scientificname,
s.stocklong,
tsv.tsyear,
sp.bmsy,
'Schaefer Bmsy' as type,
tsv.total as tsvalue,
tsv.total/sp.bmsy as ratio
FROM
srdb.assessment a,
srdb.stock s,
srdb.taxonomy t,
srdb.spfits sp,
srdb.timeseries_values_view tsv
WHERE
sp.assessid=a.assessid AND
a.stockid = s.stockid AND
s.tsn=t.tsn AND
a.assessid = tsv.assessid AND
tsv.total is not null AND
a.assessid not in (select distinct assessid from srdb.tsrelative_explicit_view where bioid like '%Bmsy%')
",sep="")
salt.dat <- sqlQuery(chan,qu.salt, stringsAsFactors=FALSE)

#salt <- data.frame()

both.dat <- rbind(pepper.dat,salt.dat)

## preferentially keep the assessment-derived BRPs over the Schaefer-derived ones
both.dat.ord <- both.dat[order(both.dat$assessid,both.dat$tsyear),]


oo <- unlist(tapply(both.dat.ord$assessid,paste(both.dat.ord$assessid,both.dat.ord$tsyear,sep="." ), order))
oo2 <- tapply(oo,paste(both.dat.ord$assessid,both.dat.ord$tsyear,sep="." ),var)

both.dat.singleBRP <- both.dat.ord[oo==1,]

## keep only years 1950 to 2008
both.dat.singleBRP.1950to2008 <- subset(both.dat.singleBRP, tsyear <= 2008 & tsyear >= 1950)

## transpose into a new matrix with years 1950 to 2008 as columns

transposed.dat <- as.data.frame(tapply(both.dat.singleBRP.1950to2008$ratio, list(both.dat.singleBRP.1950to2008$assessid,both.dat.singleBRP.1950to2008$tsyear), min))

# add new column with the minimum value of the timeseries
transposed.dat$minratio <- tapply(both.dat.singleBRP.1950to2008$ratio, both.dat.singleBRP.1950to2008$assessid, min)
transposed.dat$assessid <- tapply(as.character(both.dat.singleBRP.1950to2008$assessid), both.dat.singleBRP.1950to2008$assessid, unique)
transposed.dat$stockid <- tapply(as.character(both.dat.singleBRP.1950to2008$stockid), both.dat.singleBRP.1950to2008$assessid, unique)
transposed.dat$scientificname <- tapply(as.character(both.dat.singleBRP.1950to2008$scientificname), both.dat.singleBRP.1950to2008$assessid, unique)
transposed.dat$stocklong  <- tapply(as.character(both.dat.singleBRP.1950to2008$stocklong), both.dat.singleBRP.1950to2008$assessid, unique)
transposed.dat$Bmsy <- tapply(as.character(both.dat.singleBRP.1950to2008$bmsy), both.dat.singleBRP.1950to2008$assessid, unique)
transposed.dat$Btype <- tapply(as.character(both.dat.singleBRP.1950to2008$type), both.dat.singleBRP.1950to2008$assessid, unique)


transposed.dat <- transposed.dat[,c(61,62,63,64,65,66,1:59,60)]
## the data frame created here has the same format as the CSV file that was provided by Malin on June 4th 2010
## write the resulting data frame to a CSV file
write.csv(transposed.dat,"PINSKY-BBmsy-20100608.csv", row.names=FALSE)

odbcClose(chan)

