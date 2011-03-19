## code to extract data for Shelton Harley
## interested in sharks and rays
## Daniel Ricard started 2011-03-18
## Modification history:
require(RODBC)

chan<-odbcConnect(dsn='srdbcalo')


qu <- paste("
select * from srdb.timeseries_values_view where assessid in (select assessid from srdb.assessment where stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where classname  = 'Chondrichthyes')) and recorder !='MYERS')
",sep="")

my.ts.dat<-sqlQuery(chan,qu)

qu <- paste("
select * from srdb.timeseries_units_view where assessid in (select assessid from srdb.assessment where stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where classname  = 'Chondrichthyes')) and recorder !='MYERS')
",sep="")

my.units.dat<-sqlQuery(chan,qu)

qu <- paste("
select a.assessid, s.stockid, s.stocklong, t.scientificname, t.commonname1 from srdb.assessment a, srdb.stock s, srdb.taxonomy t where a.stockid=s.stockid and t.tsn=s.tsn and classname='Chondrichthyes'
",sep="")

my.dets.dat <- sqlQuery(chan,qu)

my.merged1.dat <- merge(my.ts.dat, my.units.dat, by="assessid")
my.merged2.dat <- merge(my.units.dat, my.dets.dat, by="assessid")

my.merged.dat <- merge(my.merged1.dat,my.merged2.dat,by="assessid")

## make a neat data frame to write to a text file
my.df.for.csv <- data.frame(assessid=my.merged.dat$assessid, stockid=my.merged.dat$stockid, stocklong=my.merged.dat$stocklong, scientificname=my.merged.dat$scientificname, commonname1=my.merged.dat$commonname1, tsyear=my.merged.dat$tsyear, ssb=my.merged.dat$ssb, ssb_unit=my.merged.dat$ssb_unit.x, r=my.merged.dat$r, r_unit=my.merged.dat$r_unit.x, total=my.merged.dat$total, total_unit=my.merged.dat$total_unit.x, f=my.merged.dat$f, f_unit=my.merged.dat$f_unit.x, cpue=my.merged.dat$cpue, cpue_unit=my.merged.dat$cpue_unit.x, catch_landings=my.merged.dat$catch_landings, catch_landings_unit=my.merged.dat$catch_landings_unit.x)

write.csv(my.df.for.csv, "Shelton-Harley-March2011-request.csv",row.names=FALSE)

odbcClose(chan)
