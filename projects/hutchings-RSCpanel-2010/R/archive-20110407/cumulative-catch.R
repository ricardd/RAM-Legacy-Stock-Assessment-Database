## a plot to show how much catch data is in the database, a first pass at answering "how much of the world's catch is in the database?
##
## plot the cumulative catch of all assessments over time
## overlay number of assessments
## overlay number of LMEs
library(RODBC)
chan<-odbcConnect(dsn='srdbcalo')
qu<-paste("select * from (select tsyear, count(distinct tsv.assessid) as numassessment, count(distinct l.lme_number) as numlme, sum(catch_landings) as totcat from srdb.timeseries_values_view tsv, srdb.timeseries_units_view tsu, srdb.lmetostocks l, srdb.assessment a where a.stockid=l.stockid and l.stocktolmerelation='primary' and a.assessid=tsv.assessid and tsv.assessid=tsu.assessid and tsu.catch_landings_unit = 'MT' and tsv.assessid in (select assessid from srdb.assessment where recorder != 'MYERS') group by tsyear order by tsyear) as a where totcat is not null",sep="")
cum.c.dat <- sqlQuery(chan,qu)

pdf("RAM-Legacy-totalcatch.pdf",width=11,height=11/1.6)
my.xlim <- c(1950,2010)
par(mar=c(5,4,1,4))
plot(totcat~tsyear, dat=cum.c.dat,type='b',xlim=my.xlim,xlab="Year",ylab="catch(MT)",lty=1,lwd=3,pch=19)
par(new=TRUE)
plot(numassessment~tsyear, dat=cum.c.dat,type='l',xlim=my.xlim,axes=FALSE,lwd=2,lty=1,xlab="",ylab="")
lines(numlme~tsyear, dat=cum.c.dat,lwd=1,lty=2)
axis(side=4,at=seq(0,300,25))
mtext(side=4,c("count"),line=2)
abline(v=c(1950,1955,1960,1965,1970,1975,1980,1985,1990,1995,2000,2005,2010),lty=2,lwd=0.5,col=grey(0.5))
legend('topleft',c("total catch","num. assessments","num. LMEs"),lty=c(1,1,2),lwd=c(3,2,1),pch=c(19,-1,-1))
mtext(side=1,paste("generated on ",Sys.time(),sep=""),line=4,at=2005,cex=0.8)
dev.off()

odbcClose(chan)
