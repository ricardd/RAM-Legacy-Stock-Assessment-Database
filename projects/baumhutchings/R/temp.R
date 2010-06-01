require(RODBC)
chan <- odbcConnect(dsn="srdbusercalo", case='postgresql',believeNRows=FALSE)

qu <- paste("select * from srdb.timeseries_values_view where assessid like \'%PCODGA%\' and assessid not like \'%MYERS%\'",sep="")
pcod<-sqlQuery(chan,qu)

baum <- subset(pcod, assessid =='AFSC-PCODGA-1977-2007-BAUM')
melnychuk <- subset(pcod, assessid =='AFSC-PCODGA-1964-2008-MELNYCHUK')

par(mfrow=c(2,1))
plot(baum$tsyear,baum$ssb,type='b', ylim=range(c(baum$ssb, melnychuk$ssb),na.rm=TRUE),xlim=range(c(baum$tsyear, melnychuk$tsyear),na.rm=TRUE))
lines(melnychuk$tsyear,melnychuk$ssb, type='b')

odbcClose(chan)
