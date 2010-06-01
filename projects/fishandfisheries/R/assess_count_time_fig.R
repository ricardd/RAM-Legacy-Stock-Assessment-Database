##-----------------------------------------------------------------------------
## plot the count of assessments for a given data type by year in the database
## DR, CM
## date: Tue Dec  1 14:26:02 AST 2009
## Time-stamp: <Last modified: 3 DECEMBER 2009  (mintoc)>
##-----------------------------------------------------------------------------

require(RODBC)
## open a channel to the database
mychan<-odbcConnect(dsn="srdbusercalo") # note how the DSN is used here

## catch
catch.span.qu<-paste("select assessid, min(tsyear) as minyear, max(tsyear) as maxyear, max(tsyear)-min(tsyear) as span from srdb.newtimeseries_values_view where catch_landings is not null group by assessid order by minyear, span desc, maxyear;")
catch.span.dat<-sqlQuery(mychan, catch.span.qu)

## ssb
ssb.span.qu<-paste("select assessid, min(tsyear) as minyear, max(tsyear) as maxyear, max(tsyear)-min(tsyear) as span from srdb.newtimeseries_values_view where ssb is not null group by assessid order by minyear, span desc, maxyear;")
ssb.span.dat<-sqlQuery(mychan, catch.span.qu)

## recruits
r.span.qu<-paste("select assessid, min(tsyear) as minyear, max(tsyear) as maxyear, max(tsyear)-min(tsyear) as span from srdb.newtimeseries_values_view where r is not null group by assessid order by minyear, span desc, maxyear;")
r.span.dat<-sqlQuery(mychan, r.span.qu)

##line.col.binary<-rep(c("black"), 400)
line.col.binary<-rep(c("black","darkgrey"), 400)
##line.col.binary<-seq(1,400)

plot.span.func<-function(data, xaxt, yaxt, my.legend, hist.lab){
  plot(1, type="n", xlim=plot.xlim, ylim=plot.ylim, axes=FALSE, xlab="", ylab="", bty="n", cex=0.5)
  if(xaxt){axis(side=1, cex.axis=1.4, lwd=0.5)}
  if(yaxt){axis(side=2, cex.axis=1.4, lwd=0.5)}
  box(lwd=0.5)
  sapply(seq(1,length(data[,1])), function(i){
  lines(c(data$minyear[i], data$maxyear[i]),c(i,i), lwd=(308/(96*2.5))/3, col=line.col.binary[i])
  })
  legend("topleft", legend=my.legend, cex=1.7, bty="n")
  ## counts per year, for percentiles
  years<-seq(min(data$minyear), 2011)
  count.per.year<-sapply(seq(1, length(years)), function(x){
  dat<-data[data$minyear<=years[x] & data$maxyear>=years[x],]
  return(length(dat[,1]))
  })
  ##percent.per.year<-count.per.year/dim(data)[1]
  percent.per.year<-count.per.year/max(count.per.year)
  ## linearly interpolate
  percent.interp<-approx(years,percent.per.year, xout=seq(min(years), max(years), length=10000))
  lwr.year.index<-percent.interp$x<percent.interp$x[which.max(percent.interp$y)]
  lwr.years<-percent.interp$x[lwr.year.index]
  lwr.percent.dat<-percent.interp$y[lwr.year.index]
  lwr.90.percent<-lwr.years[which.min(abs(lwr.percent.dat-0.9))]
  lwr.50.percent<-lwr.years[which.min(abs(lwr.percent.dat-0.5))]  
  upr.year.index<-percent.interp$x>=percent.interp$x[which.max(percent.interp$y)]
  upr.years<-percent.interp$x[upr.year.index]
  upr.percent.dat<-percent.interp$y[upr.year.index]
  upr.90.percent<-upr.years[which.min(abs(upr.percent.dat-0.9))]
  upr.50.percent<-upr.years[which.min(abs(upr.percent.dat-0.5))]
  polygon(c(lwr.50.percent, lwr.50.percent, upr.50.percent, upr.50.percent), c(-6,-3,-3,-6), border=NA, col="darkgrey")  
  polygon(c(lwr.90.percent, lwr.90.percent, upr.90.percent, upr.90.percent), c(-6,-3,-3,-6), border=NA, col=1)
  ##lines(c(lwr.90.percent, lwr.90.percent), c(-20,0), lwd=1.2)
  ##lines(c(upr.90.percent, upr.90.percent), c(-20,0), lwd=1.2)
  ##lines(c(lwr.50.percent, lwr.50.percent), c(-20,0), lwd=1.2, col="darkgrey")
  ##lines(c(upr.50.percent, upr.50.percent), c(-20,0), lwd=1.2, col="darkgrey")  
  ##----------------------------------
  hist(data$span, breaks=30, col="darkgrey", border=NA, ylim=c(0,45), main="",axes=FALSE)
  axis(side=4, lwd=0.5);axis(side=1, at=seq(10,120, by=20), lwd=0.5)
  abline(v=quantile(data$span, p=c(0.05,0.5,0.95)), lty=c(5,1,5), lwd=0.5)
  if(hist.lab){
    mtext(side=1,text="Span (years)", line=2)
    mtext(side=4,text="Frequency", line=2)
  }
  box(lwd=0.5)
}


layout.mat<-matrix(c(
                     rep(c(2,2,1,1,4,4,3,3,6,6,5,5),2),
                     rep(c(rep(1,4),rep(3,4),rep(5,4)),4)
                     ), nrow=6,byrow=TRUE)

pdf("./orca_plot_v2.pdf", height=3, width=6.7, pointsize=1)
##bitmap("./orca_plot.png", width=8,height=5, type="png256", res=1000,units="in", pointsize=12)
##postscript("./orca_plot.eps", height=5, width=8, pointsize=1)
layout(layout.mat)
par(mar=c(0,0,0,0), oma=c(5,5,2,2))
## catch
##plot.span.func(test.dat, xaxt=TRUE, yaxt=TRUE, my.legend="Catch/Landings")
plot.span.func(catch.span.dat, xaxt=TRUE, yaxt=TRUE, my.legend="", hist.lab=TRUE)
legend(-20,50, legend="A", cex=1.7, bty="n")
## ssb
plot.span.func(ssb.span.dat, xaxt=TRUE, yaxt=FALSE, my.legend="", hist.lab=FALSE)
legend(-20,50, legend="B", cex=1.7, bty="n")
## recruits
plot.span.func(r.span.dat, xaxt=TRUE, yaxt=FALSE, my.legend="", hist.lab=FALSE)
legend(-20,50, legend="C", cex=1.7, bty="n")
mtext(side=1, line=2.75, text="Year", cex=1.2, outer=TRUE)
mtext(side=2, line=2.75, text="Assessment count", outer=TRUE, cex=1.2)
dev.off()

system("open ./orca_plot_v2.pdf")
##system("gwenview ./orca_plot.png")
##system("gwenview ./orca_plot.eps")


##------------
## SANDBOX
##------------
## total counts by year
## catch
catch.qu<-paste("select tsyear, count(distinct assessid) as catchcount from srdb.newtimeseries_values_view where catch_landings is not null group by tsyear;")
catch.dat<-sqlQuery(mychan, catch.qu)

## ssb
ssb.qu<-paste("select tsyear, count(distinct assessid) as ssbcount from srdb.newtimeseries_values_view where ssb is not null group by tsyear;")
ssb.dat<-sqlQuery(mychan, ssb.qu)

## recruitment
r.qu<-paste("select tsyear, count(distinct assessid) as rcount from srdb.newtimeseries_values_view where r is not null group by tsyear;")
r.dat<-sqlQuery(mychan, r.qu)

plot.xlim<-range(c(range(r.dat$tsyear), range(catch.dat$tsyear), range(ssb.dat$tsyear)))
plot.ylim<-c(0,max(c(range(r.dat$rcount), range(catch.dat$catchcount), range(ssb.dat$ssbcount))))

par(mar=c(5,5,2,2))
with(catch.dat, plot(tsyear, catchcount, type="l", xlim=plot.xlim, ylim=plot.ylim, cex.lab=1.3, cex.axis=1.3, ylab="Count", xlab="Year", lwd=1.5))
with(ssb.dat, lines(tsyear, ssbcount, lty=5, lwd=1.5))
with(r.dat, lines(tsyear, rcount, lty=6, lwd=1.5))
legend("topleft", bty="n", legend=c("Catch","Spawning stock biomass","Recruitment"), lty=c(1,5,6), lwd=1.5, cex=1.3)

## with the vertical bars
