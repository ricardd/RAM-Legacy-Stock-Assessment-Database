##------------------------------------------------------------------------------
## Estimate multispecies trends in un-scaled SSB
## CM
## date: Tue Feb 23 20:01:37 AST 2010
## Time-stamp: <Last modified: 25 FEBRUARY 2010  (srdbadmin)>
##------------------------------------------------------------------------------
require(nlme)
science.dat<-read.csv("/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/data/Global_assessments_v3.csv", header=TRUE, as.is=TRUE,stringsAsFactors=FALSE)
numeric.col.index<-grep("[0-9]",names(science.dat))
totbio.sum<-apply(science.dat[,numeric.col.index], 2,sum,na.rm=TRUE)
n<-length(totbio.sum)
percent.decline.sum<-100*(1-totbio.sum[n]/totbio.sum[1])

## extract years
years.list<-unlist(strsplit(names(science.dat)[grep("X",names(science.dat))],"X"))
years<-as.numeric(years.list[grep("[0-9]", years.list)])
science.dat<-science.dat[,names(science.dat)%in%c("Assessid",names(science.dat)[grep("X",names(science.dat))])]

## RESHAPE FOR ANALYSES
science.dat.long<-reshape(science.dat, idvar="Assessid",times=years,varying=names(science.dat)[grep("X",names(science.dat))], v.names="total",direction="long")
row.names(science.dat.long)<-NULL
science.dat.long<-science.dat.long[order(science.dat.long$Assessid),]

## on regular scale
tb.mixed.fit1<-lme(total~-1+as.factor(time), data=science.dat.long, random=~1|Assessid,  correlation = corCAR1(form = ~time))
percent.decline.1<-100*(1-fixef(tb.mixed.fit1)[n]/fixef(tb.mixed.fit1)[1])

## on log scale
science.dat.long$lntb<-log(science.dat.long$total)
##tb.mixed.fit2<-lme(lntb~-1+as.factor(time), data=science.dat.long, random=~1|Assessid,  correlation = corCAR1(form = ~ time))
tb.mixed.fit2<-lme(lntb~-1+as.factor(time), data=science.dat.long, random=~1|Assessid)
## note the very clear pattern in the residuals
## plot(fitted(tb.mixed.fit2),resid(tb.mixed.fit2))
##plot(tb.mixed.fit2, idResType="normalized")
## not here: plot(science.dat.long$time, resid(tb.mixed.fit2))
##tb.mixed.fit2<-lme(lntb~-1+as.factor(time), data=science.dat.long, random=~1|Assessid)

pdf("./lmefit1.pdf")
##plot(tb.mixed.fit2,fitted(.)~time|Assessid, type="l", abline=(fixef(tb.mixed.fit2)[1]))
with(tb.mixed.fit2,xyplot(data$lntb~data$time|data$Assessid, groups=data$Assessid, strip=FALSE, panel = function(x, y,subscripts, groups) {
  panel.xyplot(x, y, col="lightgrey")
  fitted<-tb.mixed.fit2$fitted[,2][tb.mixed.fit2$data$Assessid==groups[subscripts]]##[,2]
  panel.lines(x,fitted)
  ##print(as.character(groups[subscripts]))
            })
     )
dev.off()

var.random.effects<-as.numeric(getVarCov(tb.mixed.fit2))
var.residuals<-(tb.mixed.fit2$sigma)^2
var.residuals.t<-sapply(years, function(x){var(resid(tb.mixed.fit2)[science.dat.long$time==x])})

##antilog.index<-exp(fixef(tb.mixed.fit2)+(var.random.effects+var.residuals)/2)
antilog.index<-exp(fixef(tb.mixed.fit2)+(var.random.effects+var.residuals.t)/2)
percent.decline.2<-100*(1-antilog.index[n]/antilog.index[1])

## de-meaned on the log scale
assessids<-unique(science.dat.long$Assessid)
scale.logmean<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
    return(c(as.character(assessids[x]),mean(log(science.dat.long$total[science.dat.long$Assessid==assessids[x]]), na.rm=TRUE)))
  })), stringsAsFactors=FALSE)
scale.logmean[,2]<-as.numeric(scale.logmean[,2])
science.dat.long$lntb.mean.scaled<-sapply(seq(1, length(science.dat.long$total)), function(x){log(science.dat.long$total[x])- scale.logmean[scale.logmean[,1]==science.dat.long$Assessid[x],2]})
tb.mixed.fit3<-lme(lntb.mean.scaled~-1+as.factor(time), data=science.dat.long, random=~1|Assessid,  correlation = corCAR1(form = ~time))
var.random.effects<-as.numeric(getVarCov(tb.mixed.fit3))
var.residuals<-tb.mixed.fit3$sigma
antilog.index3<-exp(fixef(tb.mixed.fit3)+(var.random.effects+var.residuals)/2)
percent.decline.3<-100*(1-antilog.index3[n]/antilog.index3[1])

## straight-up geometric mean
numeric.col.index<-grep("[0-9]",names(science.dat))
geo.mean<-apply(science.dat[,numeric.col.index], 2,FUN=function(x){exp(mean(log(x)))})
percent.decline.4<-100*(1-geo.mean[n]/geo.mean[1])

## relative to the maximum
scale.max<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
    return(c(as.character(assessids[x]),max(science.dat.long$total[science.dat.long$Assessid==assessids[x]], na.rm=TRUE)))
  })), stringsAsFactors=FALSE)
scale.max[,2]<-as.numeric(scale.max[,2])
science.dat.long$tb.max.scaled<-sapply(seq(1, length(science.dat.long$total)), function(x){science.dat.long$total[x]/scale.max[scale.max[,1]==science.dat.long$Assessid[x],2]})
geo.mean.rel.max<-sapply(years, function(x){exp(mean(log(science.dat.long$tb.max.scaled[science.dat.long$time==x])))})
percent.decline.5<-100*(1-geo.mean.rel.max[n]/geo.mean.rel.max[which.max(geo.mean.rel.max)])

## median
tb.median<-apply(science.dat[,numeric.col.index], 2,median,na.rm=TRUE)
percent.decline.6<-100*(1-tb.median[n]/tb.median[1])

###
arith.mean.0<-mean(science.dat.long$total[science.dat.long$time==years[1]])
geo.mean.0<-exp(mean(log(science.dat.long$total[science.dat.long$time==years[1]])))


pdf("./Temporal_TB_histogram.pdf", height=7,width=2)
par(mfrow=c(length(years),1), mar=c(0,0,0,0), oma=c(2.5,1.5,1,1), mgp=c(0,0.2,0.2))
sapply(seq(1,length(years)), function(x){
  ##plot(density(science.dat.long$total[science.dat.long$time==years[x]]), xlim=c(0,1e+6),axes=FALSE,xlab="",ylab="", main="");
  hist(science.dat.long$total[science.dat.long$time==years[x]], xlim=c(0,1e+6),axes=FALSE,xlab="",ylab="", main="", col=grey(0.7), breaks=1e+3,border=NA, ylim=c(0,40))
  plus.group<-length(science.dat.long$total[science.dat.long$time==years[x]][science.dat.long$total[science.dat.long$time==years[x]]>1e+6])
  polygon(c(1.03e+6,1.04e+6,1.04e+6,1.03e+6),c(0,0,plus.group,plus.group), border=NA, col="seagreen")
  box(bty="L", lwd=0.5)
  arith.mean<-mean(science.dat.long$total[science.dat.long$time==years[x]])
  geo.mean<-exp(mean(log(science.dat.long$total[science.dat.long$time==years[x]])))
  abline(v=arith.mean,lwd=1,col=grey(0.5))
  abline(v=geo.mean,lwd=1,col="red")
  abline(v=arith.mean.0,lwd=0.8,col=grey(0.5), lty=2)
  abline(v=geo.mean.0,lwd=0.8,col="red", lty=2)
  legend("topright",legend=as.character(years[x]), bty="n", cex=0.6)
})
##options(scipen=-1e+6) 
axis(side=1, lwd=0.5, tck=-0.1, cex.axis=0.7)
##mtext(side=2,text="Density", line=1, cex=1, outer=TRUE)
##options(scipen=10) 
mtext(side=2,text="Frequency", line=0.5, cex=0.5, outer=TRUE)
mtext(side=1,text="Stock biomass (tonnes)", line=1.25, cex=0.5, outer=TRUE)
dev.off()

pdf("./Temporal_TB_density.pdf", height=7,width=2)
par(mfrow=c(length(years),1), mar=c(0,0,0,0), oma=c(2.5,1.5,1,1), mgp=c(0,0.2,0.2))
sapply(seq(1,length(years)), function(x){
  max.tb<-max(science.dat.long$total[science.dat.long$time==years[x]], na.rm=TRUE)
  plot(density(science.dat.long$total[science.dat.long$time==years[x]], from=0, to=max.tb), xlim=c(0,1e+6),axes=FALSE,xlab="",ylab="", main="");
  ##hist(science.dat.long$total[science.dat.long$time==years[x]], xlim=c(0,1e+6),axes=FALSE,xlab="",ylab="", main="", col=grey(0.7), breaks=1e+3,border=NA, ylim=c(0,40))
  plus.group<-length(science.dat.long$total[science.dat.long$time==years[x]][science.dat.long$total[science.dat.long$time==years[x]]>1e+6])
  ##polygon(c(1.03e+6,1.04e+6,1.04e+6,1.03e+6),c(0,0,plus.group,plus.group), border=NA, col="seagreen")
  box(bty="L", lwd=0.5)
  arith.mean<-mean(science.dat.long$total[science.dat.long$time==years[x]])
  geo.mean<-exp(mean(log(science.dat.long$total[science.dat.long$time==years[x]])))
  abline(v=arith.mean,lwd=1,col=grey(0.5))
  abline(v=geo.mean,lwd=1,col="red")
  abline(v=arith.mean.0,lwd=0.8,col=grey(0.5), lty=2)
  abline(v=geo.mean.0,lwd=0.8,col="red", lty=2)
  legend("topright",legend=as.character(years[x]), bty="n", cex=0.6)
})
##options(scipen=-1e+6) 
axis(side=1, lwd=0.5, tck=-0.1, cex.axis=0.7)
##mtext(side=2,text="Density", line=1, cex=1, outer=TRUE)
##options(scipen=10) 
mtext(side=2,text="Density", line=0.5, cex=0.5, outer=TRUE)
mtext(side=1,text="Stock biomass (tonnes)", line=1.25, cex=0.5, outer=TRUE)
dev.off()


## proportion of stocks in different categories
##bounds<-quantile(science.dat.long$total, p=c(0.1,0.25,0.5,0.75,0.9))
bounds<-c(0,5e+3,1e+4,5e+4,3e+5,1e+6)

proportion.stocks<-function(x){
  n.1<-length(x[x>bounds[1] & x<=bounds[2]])
  n.2<-length(x[x>bounds[2] & x<=bounds[3]])
  n.3<-length(x[x>bounds[3] & x<=bounds[4]])
  n.4<-length(x[x>bounds[4] & x<=bounds[5]])
  n.5<-length(x[x>bounds[5] & x<=bounds[6]])
  n.6<-length(x[x>bounds[6]])
  n<-length(x)
  return(c(n.1,n.2,n.3,n.4,n.5,n.6)/n)
}

require(plotrix)
proportion.stocks<-sapply(numeric.col.index, function(x){proportion.stocks(science.dat[,x])})
require(gplots)
mypalette<-rich.colors(50)
mycols<-rev(mypalette[seq(5,30,length=6)])

stackpoly(t(proportion.stocks),border=NULL,staxx=TRUE, stack=TRUE, col=mycols)


## plot legend
index<-seq(1, length(bounds))
bounds.legend<-paste(bounds[index], bounds[index+1], sep="-")
bounds.legend[6]<-paste(bounds[6], "+", sep="")

pdf("Proportion_stocks_tonnage.pdf", height=6, width=6)
matplot(years,t(proportion.stocks), type="l", col=mycols, lwd=2, lty=1, ylab="Proporion of stocks in tonnage category", xlab="Year", bty="n", ylim=c(0,0.4), bty="L")
legend("topright", legend=bounds.legend, horiz=FALSE, cex=0.9, bty="n", lty=1, lwd=2, col=mycols)
dev.off()


## with biomass included
n0<-sum(science.dat[,2])
proportion.stocks.biomass<-function(x){
  n.1<-sum(x[x>bounds[1] & x<=bounds[2]])
  n.2<-sum(x[x>bounds[2] & x<=bounds[3]])
  n.3<-sum(x[x>bounds[3] & x<=bounds[4]])
  n.4<-sum(x[x>bounds[4] & x<=bounds[5]])
  n.5<-sum(x[x>bounds[5] & x<=bounds[6]])
  n.6<-sum(x[x>bounds[6]])
  n<-sum(x)
  return(n/n0*(c(n.1,n.2,n.3,n.4,n.5,n.6))/n)
}

proportion.stocks.biomass.mat<-sapply(numeric.col.index, function(x){proportion.stocks.biomass(science.dat[,x])})

matplot(years,t(proportion.stocks.biomass.mat), type="l", col=mycols, lwd=2, lty=1, ylab="Proporion of stocks in tonnage category", xlab="Year", bty="n", bty="L")
legend("topright", legend=bounds.legend, horiz=FALSE, cex=0.9, bty="n", lty=1, lwd=2, col=mycols)
dev.off()
