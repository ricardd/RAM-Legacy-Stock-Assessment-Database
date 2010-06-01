require(RODBC)

chan<-odbcConnect(dsn="srdbcalo")
my.qu <- paste("
select * from srdb.timeseries where assessid = \'NWFSC-WROCKPCOAST-1955-2006-BRANCH\'
", sep="")
wrock.dat <- sqlQuery(chan,my.qu)
odbcClose(chan)

ssb.mt<-subset(wrock.dat, tsid=="SSB-MT")
ssb.eggs<-subset(wrock.dat, tsid=="SSB-E03eggs")

cor(na.omit(ssb.mt$tsvalue),na.omit(ssb.eggs$tsvalue))
plot(ssb.mt$tsvalue,ssb.eggs$tsvalue,type='p')

plot(ssb.mt$tsyear,ssb.mt$tsvalue, type='b')
lines(ssb.eggs$tsyear,ssb.eggs$tsvalue, type='b')


require(RODBC)

chan<-odbcConnect(dsn="srdbcalo")

my.qu <- paste("
select * from srdb.timeseries_values_view where assessid in (\'SWFSC-CMACKPCOAST-1929-2008-PINSKY\',\'NMFS-CMACKNPAC-1929-2005-STANTON\')
", sep="")
cmack.dat <- sqlQuery(chan,my.qu)
odbcClose(chan)

kate.dat<-subset(cmack.dat,assessid=="NMFS-CMACKNPAC-1929-2005-STANTON")
malin.dat<-subset(cmack.dat,assessid=="SWFSC-CMACKPCOAST-1929-2008-PINSKY")

dim(kate.dat)
dim(malin.dat)

pdf("CMACK-duplicate.pdf")
plot(kate.dat$tsyear,kate.dat$ssb,type='b', ylim=range(c(kate.dat$ssb,malin.dat$ssb)),col="red")
lines(malin.dat$tsyear,malin.dat$ssb,type='b',pch=2,lty=2,col="blue")
legend("topright",c("Kate","Malin"),pch=c(1,2),lty=c(1,2),col=c("red","blue"))
dev.off()
