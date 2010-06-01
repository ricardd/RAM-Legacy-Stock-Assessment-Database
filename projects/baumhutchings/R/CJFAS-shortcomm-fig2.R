## plot figure 2
## CM, DR
## date: Thu Jan 14 15:34:45 AST 2010
## Time-stamp: <Last modified: 26 FEBRUARY 2010  (srdbadmin)>
## plots first then percentage change calculations below
## this source may take a while to run, note that it uses dat
##source("reanalysis-relative-abundance.R")


source("CJFAS-fig2-prep-and-functions.R")


##----------------------------------------------
## MIXED EFFECTS ALTERNATIVE PLOT WITH POLYGONS
##----------------------------------------------
##plot.summary.mixed.plots(min.year=1880,pdf=TRUE)
plot.summary.mixed.plots(min.year=1970,pdf=TRUE)
plot.summary.mixed.plots(min.year=1970,pdf=FALSE)
##plot.summary.mixed.plots(min.year=1978,pdf=TRUE)

plot.summary.mixed.plots<-function(min.year, pdf=TRUE){
  ## min.year can be one of 1880, 1970, 1978
  if(pdf){pdf(paste("multispecies-trends-", min.year, ".pdf",sep=""), width=7, height=8)}
  par(mfrow=c(4,2), mar=c(0,0,0,0), oma=c(4,4.5,2,2))
  ## 2a
  if(min.year==1880){
    ylim<-range(c(as.numeric(unlist(lapply(pelagic.mixed.list.1880,"[","lwr"))),as.numeric(unlist(lapply(pelagic.mixed.list.1880,"[","upr")))), na.rm=TRUE)
    with(overall.all.mixed.index.1880, plot(years, index, type="l",, xlim=c(min.year,2010),xaxt="n", yaxt="n",cex.axis=1.2, col="#7570B3", lwd=1.2, ylim=ylim, ylab="", xlab=""))
    with(overall.all.mixed.index.1880, try(polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#7570B340", border=NA), silent=TRUE))
    axis(side=2,at=pretty(ylim),cex.axis=1.2)
    legend("topleft", legend=c(paste("All", " (N=", unique(overall.all.mixed.index.1880$n), ")", sep="")), lwd=1.2, col="#7570B3", bty="n", cex=1.1)
    ## 2b
    with(overall.pelagic.mixed.index.1880, plot(years, index, pch=19, type="l",  ylim=ylim, xlim=c(1880,2010),xaxt="n",yaxt="n", lwd=1.2, col="#D95F02"))
    with(overall.pelagic.mixed.index.1880, try(polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#D95F0240", border=NA), silent=TRUE))
    with(overall.demersal.mixed.index.1880, try(polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#1B9E7740", border=NA), silent=TRUE))
    with(overall.demersal.mixed.index.1880, lines(years, index, lwd=1.2,col="#1B9E77"))
    legend("topright", legend=c(paste("Pelagic", " (N=", unique(overall.pelagic.mixed.index.1880$n), ")", sep=""), paste("Demersal", " (N=", unique(overall.demersal.mixed.index.1880$n), ")", sep="")), lty=c(1,1),lwd=1.2,col=c("#D95F02","#1B9E77"), bty="n", cex=1.1)
    ## 2c-f
    ## NWAtl
    plot.poly.base.func(region="NWAtl", yaxt="s", xaxt="n", min.year=1880, ylim=ylim)
    plot.poly.mixed.func(region="NWAtl", category="Pelagic", min.year=1880)
    plot.poly.mixed.func(region="NWAtl", category="Demersal", min.year=1880)
    ## NEAtl
    plot.poly.base.func(region="NEAtl", yaxt="n", xaxt="n", min.year=1880, ylim=ylim)
    plot.poly.mixed.func(region="NEAtl", category="Pelagic", min.year=1880)
    plot.poly.mixed.func(region="NEAtl", category="Demersal", min.year=1880)
    ## NorthMidAtl
    plot.poly.base.func(region="NorthMidAtl", yaxt="s", xaxt="n", min.year=1880, ylim=ylim)
    plot.poly.mixed.func(region="NorthMidAtl", category="Pelagic", min.year=1880)
    plot.poly.mixed.func(region="NorthMidAtl", category="Demersal", min.year=1880)
    ## NEPac
    plot.poly.base.func(region="NEPac", yaxt="n", xaxt="n", min.year=1880, ylim=ylim)
    plot.poly.mixed.func(region="NEPac", category="Pelagic", min.year=1880)
    plot.poly.mixed.func(region="NEPac", category="Demersal", min.year=1880)
    ## SAfr
    plot.poly.base.func(region="HighSeas", yaxt="s", xaxt="s", min.year=1880, ylim=ylim)
    plot.poly.mixed.func(region="HighSeas", category="Pelagic", min.year=1880)
    plot.poly.mixed.func(region="HighSeas", category="Demersal", min.year=1880)
    ## Aust-NZ
    plot.poly.base.func(region="Aust-NZ", yaxt="n", xaxt="s", min.year=1880, ylim=ylim)
    plot.poly.mixed.func(region="Aust-NZ", category="Pelagic", min.year=1880)
    plot.poly.mixed.func(region="Aust-NZ", category="Demersal", min.year=1880)
    mtext(side=1, text="Year", cex=1.1, line=2.5, outer=TRUE)
    mtext(side=2, text= "Mean of scaled ln(SSB)", cex=1.1, line=2.5, outer=TRUE)
    ##mtext(side=3, text="Scaled relative to mixed", cex=1.2, line=1.5, outer=TRUE)
  }
  #########
  ## 1970
  #########
    if(min.year==1970){
    ylim<-range(c(as.numeric(unlist(lapply(pelagic.mixed.list.1970,"[","lwr"))),as.numeric(unlist(lapply(pelagic.mixed.list.1970,"[","upr")))), na.rm=TRUE)
    with(overall.all.mixed.index.1970, plot(years, index, type="l",, xlim=c(min.year,2010),xaxt="n", yaxt="n",cex.axis=1.2, col="#7570B3", lwd=1.2, ylim=ylim, ylab="", xlab=""))
    with(overall.all.mixed.index.1970, try(polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#7570B340", border=NA), silent=TRUE))
    axis(side=2,at=pretty(ylim),cex.axis=1.2)
    legend("topleft", legend=c(paste("All", " (N=", unique(overall.all.mixed.index.1970$n), ")", sep="")), lwd=1.2, col="#7570B3", bty="n", cex=1.1)
    ## 2b
    with(overall.pelagic.mixed.index.1970, plot(years, index, pch=19, type="l",  ylim=ylim, xlim=c(1970,2010),xaxt="n",yaxt="n", lwd=1.2, col="#D95F02"))
    with(overall.pelagic.mixed.index.1970, try(polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#D95F0240", border=NA), silent=TRUE))
    with(overall.demersal.mixed.index.1970, try(polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#1B9E7740", border=NA), silent=TRUE))
    with(overall.demersal.mixed.index.1970, lines(years, index, lwd=1.2,col="#1B9E77"))
    legend("topright", legend=c(paste("Pelagic", " (N=", unique(overall.pelagic.mixed.index.1970$n), ")", sep=""), paste("Demersal", " (N=", unique(overall.demersal.mixed.index.1970$n), ")", sep="")), lty=c(1,1),lwd=1.2,col=c("#D95F02","#1B9E77"), bty="n", cex=1.1)
    ## 2c-f
    ## NWAtl
    plot.poly.base.func(region="NWAtl", yaxt="s", xaxt="n", min.year=1970, ylim=ylim)
    plot.poly.mixed.func(region="NWAtl", category="Pelagic", min.year=1970)
    plot.poly.mixed.func(region="NWAtl", category="Demersal", min.year=1970)
    ## NEAtl
    plot.poly.base.func(region="NEAtl", yaxt="n", xaxt="n", min.year=1970, ylim=ylim)
    plot.poly.mixed.func(region="NEAtl", category="Pelagic", min.year=1970)
    plot.poly.mixed.func(region="NEAtl", category="Demersal", min.year=1970)
    ## NorthMidAtl
    plot.poly.base.func(region="NorthMidAtl", yaxt="s", xaxt="n", min.year=1970, ylim=ylim)
    plot.poly.mixed.func(region="NorthMidAtl", category="Pelagic", min.year=1970)
    plot.poly.mixed.func(region="NorthMidAtl", category="Demersal", min.year=1970)
    ## NEPac
    plot.poly.base.func(region="NEPac", yaxt="n", xaxt="n", min.year=1970, ylim=ylim)
    plot.poly.mixed.func(region="NEPac", category="Pelagic", min.year=1970)
    plot.poly.mixed.func(region="NEPac", category="Demersal", min.year=1970)
    ## SAfr
    plot.poly.base.func(region="HighSeas", yaxt="s", xaxt="s", min.year=1970, ylim=ylim)
    plot.poly.mixed.func(region="HighSeas", category="Pelagic", min.year=1970)
    plot.poly.mixed.func(region="HighSeas", category="Demersal", min.year=1970)
    ## Aust-NZ
    plot.poly.base.func(region="Aust-NZ", yaxt="n", xaxt="n", min.year=1970, ylim=ylim)
    plot.poly.mixed.func(region="Aust-NZ", category="Pelagic", min.year=1970)
    plot.poly.mixed.func(region="Aust-NZ", category="Demersal", min.year=1970)
    axis(side=1,at=seq(1980,2010, by=10), cex.axis=1.2)
    mtext(side=1, text="Year", cex=1.1, line=2.5, outer=TRUE)
    mtext(side=2, text= "Mean of scaled ln(SSB)", cex=1.1, line=2.5, outer=TRUE)
    ##mtext(side=3, text="Scaled relative to mixed", cex=1.2, line=1.5, outer=TRUE)
  }
  #########
  ## 1978
  #########
    if(min.year==1978){
    ylim<-range(c(as.numeric(unlist(lapply(pelagic.mixed.list.1978,"[","lwr"))),as.numeric(unlist(lapply(pelagic.mixed.list.1978,"[","upr")))), na.rm=TRUE)
    with(overall.all.mixed.index.1978, plot(years, index, type="l",, xlim=c(min.year,2010),xaxt="n", yaxt="n",cex.axis=1.2, col="#7570B3", lwd=1.2, ylim=ylim, ylab="", xlab=""))
    with(overall.all.mixed.index.1978, try(polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#7570B340", border=NA), silent=TRUE))
    axis(side=2,at=pretty(ylim),cex.axis=1.2)
    legend("topleft", legend=c(paste("All", " (N=", unique(overall.all.mixed.index.1978$n), ")", sep="")), lwd=1.2, col="#7570B3", bty="n", cex=1.1)
    ## 2b
    with(overall.pelagic.mixed.index.1978, plot(years, index, pch=19, type="l",  ylim=ylim, xlim=c(1978,2010),xaxt="n",yaxt="n", lwd=1.2, col="#D95F02"))
    with(overall.pelagic.mixed.index.1978, try(polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#D95F0240", border=NA), silent=TRUE))
    with(overall.demersal.mixed.index.1978, try(polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#1B9E7740", border=NA), silent=TRUE))
    with(overall.demersal.mixed.index.1978, lines(years, index, lwd=1.2,col="#1B9E77"))
    legend("topright", legend=c(paste("Pelagic", " (N=", unique(overall.pelagic.mixed.index.1978$n), ")", sep=""), paste("Demersal", " (N=", unique(overall.demersal.mixed.index.1978$n), ")", sep="")), lty=c(1,1),lwd=1.2,col=c("#D95F02","#1B9E77"), bty="n", cex=1.1)
    ## 2c-f
    ## NWAtl
    plot.poly.base.func(region="NWAtl", yaxt="s", xaxt="n", min.year=1978, ylim=ylim)
    plot.poly.mixed.func(region="NWAtl", category="Pelagic", min.year=1978)
    plot.poly.mixed.func(region="NWAtl", category="Demersal", min.year=1978)
    ## NEAtl
    plot.poly.base.func(region="NEAtl", yaxt="n", xaxt="n", min.year=1978, ylim=ylim)
    plot.poly.mixed.func(region="NEAtl", category="Pelagic", min.year=1978)
    plot.poly.mixed.func(region="NEAtl", category="Demersal", min.year=1978)
    ## NorthMidAtl
    plot.poly.base.func(region="NorthMidAtl", yaxt="s", xaxt="n", min.year=1978, ylim=ylim)
    plot.poly.mixed.func(region="NorthMidAtl", category="Pelagic", min.year=1978)
    plot.poly.mixed.func(region="NorthMidAtl", category="Demersal", min.year=1978)
    ## NEPac
    plot.poly.base.func(region="NEPac", yaxt="n", xaxt="n", min.year=1978, ylim=ylim)
    plot.poly.mixed.func(region="NEPac", category="Pelagic", min.year=1978)
    plot.poly.mixed.func(region="NEPac", category="Demersal", min.year=1978)
    ## SAfr
    plot.poly.base.func(region="HighSeas", yaxt="s", xaxt="s", min.year=1978, ylim=ylim)
    plot.poly.mixed.func(region="HighSeas", category="Pelagic", min.year=1978)
    plot.poly.mixed.func(region="HighSeas", category="Demersal", min.year=1978)
    ## Aust-NZ
    plot.poly.base.func(region="Aust-NZ", yaxt="n", xaxt="n", min.year=1978, ylim=ylim)
    plot.poly.mixed.func(region="Aust-NZ", category="Pelagic", min.year=1978)
    plot.poly.mixed.func(region="Aust-NZ", category="Demersal", min.year=1978)
    axis(side=1,at=seq(1980,2010, by=10), cex.axis=1.2)
    mtext(side=1, text="Year", cex=1.1, line=2.5, outer=TRUE)
    mtext(side=2, text= "Mean of scaled ln(SSB)", cex=1.1, line=2.5, outer=TRUE)
    ##mtext(side=3, text="Scaled relative to mixed", cex=1.2, line=1.5, outer=TRUE)
  }
  if(pdf){dev.off()}
}


bmp(filename = "CJFAS-shortcomm-fig2_v6.bmp",pointsize = 12, bg = "white", width=480*7/8, height=480)
##pdf("CJFAS-shortcomm-fig2_v6.pdf", width=7, height=8)
  par(mfrow=c(4,2), mar=c(0,0,0,0), oma=c(4,4.5,2,2))
    ##ylim<-range(c(as.numeric(unlist(lapply(pelagic.mixed.list.1970,"[","lwr"))),as.numeric(unlist(lapply(pelagic.mixed.list.1970,"[","upr")))), na.rm=TRUE)
ylim<-range(exp(c(as.numeric(unlist(lapply(pelagic.mixed.list.1970,"[","lwr"))),as.numeric(unlist(lapply(pelagic.mixed.list.1970,"[","upr"))))), na.rm=TRUE)
    with(overall.all.mixed.index.1970, plot(years, exp(index), type="l",, xlim=c(min.year,2010),xaxt="n", yaxt="n",cex.axis=1.2, col="#7570B3", lwd=1.2, ylim=ylim, ylab="", xlab=""))
##with(overall.all.mixed.index.1970, plot(years, exp(index), type="l",, xlim=c(min.year,2010),xaxt="n", yaxt="n",cex.axis=1.2, col="#7570B3", lwd=1.2, ylim=ylim, ylab="", xlab=""))
    with(overall.all.mixed.index.1970, try(polygon(c(years,rev(years)),exp(c(lwr,rev(upr))),col="#7570B340", border=NA), silent=TRUE))
    axis(side=2,at=pretty(ylim),cex.axis=1.2)
    legend("topleft", legend=c(paste("All", " (N=", unique(overall.all.mixed.index.1970$n), ")", sep="")), lwd=1.2, col="#7570B3", bty="n", cex=1.1)
    ## 2b
    ##with(overall.pelagic.mixed.index.1970, plot(years, index, pch=19, type="l",  ylim=ylim, xlim=c(1970,2010),xaxt="n",yaxt="n", lwd=1.2, col="#D95F02"))
with(overall.pelagic.mixed.index.1970, plot(years, exp(index), pch=19, type="l",  ylim=ylim, xlim=c(1970,2010),xaxt="n",yaxt="n", lwd=1.2, col="#D95F02"))
    with(overall.pelagic.mixed.index.1970, try(polygon(c(years,rev(years)),exp(c(lwr,rev(upr))),col="#D95F0240", border=NA), silent=TRUE))
    with(overall.demersal.mixed.index.1970, try(polygon(c(years,rev(years)),exp(c(lwr,rev(upr))),col="#1B9E7740", border=NA), silent=TRUE))
    with(overall.demersal.mixed.index.1970, lines(years, exp(index), lwd=1.2,col="#1B9E77"))
    legend("topright", legend=c(paste("Pelagic", " (N=", unique(overall.pelagic.mixed.index.1970$n), ")", sep=""), paste("Demersal", " (N=", unique(overall.demersal.mixed.index.1970$n), ")", sep="")), lty=c(1,1),lwd=1.2,col=c("#D95F02","#1B9E77"), bty="n", cex=1.1)
    ## 2c-f
    ## NWAtl
    plot.poly.base.func(region="NWAtl", yaxt="s", xaxt="n", min.year=1970, ylim=ylim)
    plot.poly.mixed.func.exp(region="NWAtl", category="Pelagic", min.year=1970)
    plot.poly.mixed.func.exp(region="NWAtl", category="Demersal", min.year=1970)
    ## NEAtl
    plot.poly.base.func(region="NEAtl", yaxt="n", xaxt="n", min.year=1970, ylim=ylim)
    plot.poly.mixed.func.exp(region="NEAtl", category="Pelagic", min.year=1970)
    plot.poly.mixed.func.exp(region="NEAtl", category="Demersal", min.year=1970)
    ## NorthMidAtl
    plot.poly.base.func(region="NorthMidAtl", yaxt="s", xaxt="n", min.year=1970, ylim=ylim)
    plot.poly.mixed.func.exp(region="NorthMidAtl", category="Pelagic", min.year=1970)
    plot.poly.mixed.func.exp(region="NorthMidAtl", category="Demersal", min.year=1970)
    ## NEPac
    plot.poly.base.func(region="NEPac", yaxt="n", xaxt="n", min.year=1970, ylim=ylim)
    plot.poly.mixed.func.exp(region="NEPac", category="Pelagic", min.year=1970)
    plot.poly.mixed.func.exp(region="NEPac", category="Demersal", min.year=1970)
    ## SAfr
    plot.poly.base.func(region="HighSeas", yaxt="s", xaxt="s", min.year=1970, ylim=ylim)
    plot.poly.mixed.func.exp(region="HighSeas", category="Pelagic", min.year=1970)
    plot.poly.mixed.func.exp(region="HighSeas", category="Demersal", min.year=1970)
    ## Aust-NZ
    plot.poly.base.func(region="Aust-NZ", yaxt="n", xaxt="n", min.year=1970, ylim=ylim)
    plot.poly.mixed.func.exp(region="Aust-NZ", category="Pelagic", min.year=1970)
    plot.poly.mixed.func.exp(region="Aust-NZ", category="Demersal", min.year=1970)
    axis(side=1,at=seq(1980,2010, by=10), cex.axis=1.2)
    mtext(side=1, text="Year", cex=1.1, line=2.5, outer=TRUE)
    mtext(side=2, text= "Relative SSB", cex=1.1, line=2.5, outer=TRUE)
    ##mtext(side=3, text="Scaled relative to mixed", cex=1.2, line=1.5, outer=TRUE)
dev.off()

##system("xpdf CJFAS-shortcomm-fig2_v5.pdf &")
system("gwenview CJFAS-shortcomm-fig2_v5.bmp &")



##------------------------------------------------
## Calculations for extracting percentage changes
##------------------------------------------------
percentage.change.df<-data.frame(name=rep(" ",11), start=rep(NA,11), end=rep(NA,11), percent=rep(NA,11), stringsAsFactors=FALSE)
## OVERALL
scale.year<-1970
t<-subset(dat.1010, tsyear>=scale.year)
assessids<-unique(t$assessid)
## SCALING
## mean on log scale values
scale.logmean<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
  return(c(as.character(assessids[x]),mean(log(t$ssb[t$assessid==assessids[x]]), na.rm=TRUE)))
})), stringsAsFactors=FALSE)
scale.logmean[,2]<-as.numeric(scale.logmean[,2])
t$logssb.mean.scaled<-sapply(seq(1, length(t$ssb)), function(x){log(t$ssb[x])- scale.logmean[scale.logmean[,1]==t$assessid[x],2]})
years<-unique(t$tsyear)[order(unique(t$tsyear))]
## mixed effects fit
logssb.mixed.fit<-lme(logssb.mean.scaled~-1+as.factor(tsyear), data=t[t$tsyear%in%years,], random=~1|assessid,  correlation = corCAR1(form = ~tsyear))
var.random.effects<-as.numeric(getVarCov(logssb.mixed.fit))
var.residuals<-logssb.mixed.fit$sigma
## Coilin to check this with Wade
##antilog.index<-exp(fixef(logssb.mixed.fit)+(var.random.effects+var.residuals)/2) ## see supp. info. for Worm et al (2009)
antilog.index<-exp(fixef(logssb.mixed.fit))
percentage.change.df$name[1]<-"overall"
percentage.change.df$start[1]<-mean(antilog.index[1:5])
percentage.change.df$end[1]<-mean(antilog.index[(length(antilog.index)-5):length(antilog.index)])
percentage.change.df$percent[1]<-round(100*(1-percentage.change.df$end[1]/percentage.change.df$start[1]),2)

## overall pelagic
t<-subset(dat.1010, taxocategory=="Pelagic"& tsyear>=scale.year)
assessids<-unique(t$assessid)
scale.logmean<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
  return(c(as.character(assessids[x]),mean(log(t$ssb[t$assessid==assessids[x]]), na.rm=TRUE)))
})), stringsAsFactors=FALSE)
scale.logmean[,2]<-as.numeric(scale.logmean[,2])
t$logssb.mean.scaled<-sapply(seq(1, length(t$ssb)), function(x){log(t$ssb[x])- scale.logmean[scale.logmean[,1]==t$assessid[x],2]})
years<-unique(t$tsyear)[order(unique(t$tsyear))]
## mixed effects fit
logssb.mixed.fit<-lme(logssb.mean.scaled~-1+as.factor(tsyear), data=t[t$tsyear%in%years,], random=~1|assessid,  correlation = corCAR1(form = ~tsyear))
var.random.effects<-as.numeric(getVarCov(logssb.mixed.fit))
var.residuals<-logssb.mixed.fit$sigma
##antilog.index<-exp(fixef(logssb.mixed.fit)+(var.random.effects+var.residuals)/2) ## see supp. info. for Worm et al (2009)
antilog.index<-exp(fixef(logssb.mixed.fit))
percentage.change.df$name[2]<-"pelagic"
percentage.change.df$start[2]<-mean(antilog.index[1:5])
percentage.change.df$end[2]<-mean(antilog.index[(length(antilog.index)-5):length(antilog.index)])
percentage.change.df$percent[2]<-round(100*(1-percentage.change.df$end[2]/percentage.change.df$start[2]),2)

## overall demersal
## overall pelagic or demersal
t<-subset(dat.1010, taxocategory!="Pelagic" & tsyear>=scale.year)
assessids<-unique(t$assessid)
scale.logmean<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
  return(c(as.character(assessids[x]),mean(log(t$ssb[t$assessid==assessids[x]]), na.rm=TRUE)))
})), stringsAsFactors=FALSE)
scale.logmean[,2]<-as.numeric(scale.logmean[,2])
t$logssb.mean.scaled<-sapply(seq(1, length(t$ssb)), function(x){log(t$ssb[x])- scale.logmean[scale.logmean[,1]==t$assessid[x],2]})
years<-unique(t$tsyear)[order(unique(t$tsyear))]
## mixed effects fit
logssb.mixed.fit<-lme(logssb.mean.scaled~-1+as.factor(tsyear), data=t[t$tsyear%in%years,], random=~1|assessid,  correlation = corCAR1(form = ~tsyear))
var.random.effects<-as.numeric(getVarCov(logssb.mixed.fit))
var.residuals<-logssb.mixed.fit$sigma
##antilog.index<-exp(fixef(logssb.mixed.fit)+(var.random.effects+var.residuals)/2) ## see supp. info. for Worm et al (2009)
antilog.index<-exp(fixef(logssb.mixed.fit))
percentage.change.df$name[3]<-"demersal"
percentage.change.df$start[3]<-mean(antilog.index[1:5])
percentage.change.df$end[3]<-mean(antilog.index[(length(antilog.index)-5):length(antilog.index)])
percentage.change.df$percent[3]<-round(100*(1-percentage.change.df$end[3]/percentage.change.df$start[3]),2)

my.regions<-c(rep("NEAtl",2), rep("NWAtl",2), rep("NorthMidAtl",2), rep("NEPac",2))
my.categories<-rep(c("Pelagic","Demersal"),4)

for(i in 1:8){
  print(i)
  rm(t)
  if(i%in%c(2,4,6,8)){
    t<-subset(dat.1010,geo==my.regions[i] & taxocategory!="Pelagic" & tsyear>=scale.year)
  }else{
    t<-subset(dat.1010,geo==my.regions[i] & taxocategory=="Pelagic" & tsyear>=scale.year)
  }
  assessids<-unique(t$assessid)
  scale.logmean<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
    return(c(as.character(assessids[x]),mean(log(t$ssb[t$assessid==assessids[x]]), na.rm=TRUE)))
  })), stringsAsFactors=FALSE)
  scale.logmean[,2]<-as.numeric(scale.logmean[,2])
  t$logssb.mean.scaled<-sapply(seq(1, length(t$ssb)), function(x){log(t$ssb[x])- scale.logmean[scale.logmean[,1]==t$assessid[x],2]})
  years<-unique(t$tsyear)[order(unique(t$tsyear))]
  ## mixed effects fit
  logssb.mixed.fit<-lme(logssb.mean.scaled~-1+as.factor(tsyear), data=t[t$tsyear%in%years,], random=~1|assessid,  correlation = corCAR1(form = ~tsyear))
  var.random.effects<-as.numeric(getVarCov(logssb.mixed.fit))
  var.residuals<-logssb.mixed.fit$sigma
  ##antilog.index<-exp(fixef(logssb.mixed.fit)+(var.random.effects+var.residuals)/2) ## see supp. info. for Worm et al (2009)
  antilog.index<-exp(fixef(logssb.mixed.fit))
  percentage.change.df$name[i+3]<-paste(my.regions[i],my.categories[i])
  percentage.change.df$start[i+3]<-mean(antilog.index[1:5])
  percentage.change.df$end[i+3]<-mean(antilog.index[(length(antilog.index)-5):length(antilog.index)])
  percentage.change.df$percent[i+3]<-round(100*(1-percentage.change.df$end[i+3]/percentage.change.df$start[i+3]),2)
}
  
