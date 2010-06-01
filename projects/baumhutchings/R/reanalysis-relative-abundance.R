##------------------------------------------------------------------------------
## Relative abundance over time updated analysis (Hutchings and Baum, 2005)
## CM, DR
## date: Fri Aug 21 11:42:47 ADT 2009
## Time-stamp: <Last modified: 20 JANUARY 2010  (srdbadmin)>
## Notes: data query in 'reanalysis-models.R' return 'dat' data object used here
##------------------------------------------------------------------------------


## function to return geometric mean of abundance
## scaling can be by the maximum or relative to scale year (here 1980 -should be 1978)
require(nlme)

get.scaled.index<-function(region, category, scale.year=1978, scaling,all.stocks.present=FALSE){
  ## returns year and estimated scaled index
  ## category is 'Pelagic' all else gets lumped as demersals
  ## scale.year is the year the data are scaled to (valid only for scaling = 'by.scale.year')
  ## scaling is what the data are scaled to, options are: 'by.max', 'by.scale.year', 'by.log.demeaned'
  ## the first two scaling options return the geometric mean, the last returns the fixed effects by year
  ## all.stocks.present is turned on if we want to analyze only years for which all stocks are present
  if(category=="Pelagic"){
    t<-subset(dat,geo==region & taxocategory==category & tsyear>=scale.year)
  }else{
    t<-subset(dat,geo==region & taxocategory!="Pelagic" & tsyear>=scale.year)
  }
  ##if(length(t[,1])<1){stop("No data in this region-category combination")}
  if(length(t[,1])<1){return(c("No data in this region-category combination"))}else{
  ##stocks<-unique(t$stockid)
  assessids<-unique(t$assessid)
  ## SCALING
  ## value of each stock in scale.year
  ##scale.by.year<- data.frame(t(sapply(seq(1, length(stocks)), function(x){
  scale.by.year<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
    ## if 1978 not present, choose earliest value in the timeseries
    if(1978%in%t$tsyear[t$assessid==assessids[x]]){
      return(c(as.character(assessids[x]),t$ssb[t$tsyear==scale.year&t$assessid==assessids[x]]))
    }else{
      return(c(as.character(assessids[x]),t$ssb[t$tsyear==min(t$tsyear[t$assessid==assessids[x]]) & t$assessid==assessids[x]]))
    }
    })), stringsAsFactors=FALSE)
  scale.by.year[,2]<-as.numeric(scale.by.year[,2])
  ## max scale values
  scale.max<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
        return(c(as.character(assessids[x]),max(t$ssb[t$assessid==assessids[x]], na.rm=TRUE)))
      })), stringsAsFactors=FALSE)
  scale.max[,2]<-as.numeric(scale.max[,2])
  ## mean on log scale values
  scale.logmean<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
        return(c(as.character(assessids[x]),mean(log(t$ssb[t$assessid==assessids[x]]), na.rm=TRUE)))
      })), stringsAsFactors=FALSE)
  scale.logmean[,2]<-as.numeric(scale.logmean[,2])
  t$ssb.by.year.scaled<-sapply(seq(1, length(t$ssb)), function(x){
    t$ssb[x]/(scale.by.year[scale.by.year[,1]==t$assessid[x],2])
  })
  t$ssb.max.scaled<-sapply(seq(1, length(t$ssb)), function(x){
    t$ssb[x]/(scale.max[scale.max[,1]==t$assessid[x],2])})
  t$logssb.mean.scaled<-sapply(seq(1, length(t$ssb)), function(x){
    log(t$ssb[x])- scale.logmean[scale.logmean[,1]==t$assessid[x],2]})
  if(all.stocks.present){
    ## which years are fully present
    years1<-unique(t$tsyear)[order(unique(t$tsyear))]
    num.assess.by.year<-sapply(seq(1, length(years1)), function(x){length(t$assessid[t$tsyear==years1[x]&!is.na(t$ssb)])})
    n.total.assess<-length(unique(t$assessid))
    years.index <-as.logical(ifelse(num.assess.by.year==n.total.assess,1,0))
    years<-years1[years.index]
  }else{
    years<-unique(t$tsyear)[order(unique(t$tsyear))]
  }
  ## FITS
  ## geometric means
  pred.by.year.scaled<-sapply(seq(1, length(years)), function(x){return(exp(mean(log(t$ssb.by.year.scaled[t$tsyear==years[x]]), na.rm=TRUE)))})
  pred.max.scaled<-sapply(seq(1, length(years)), function(x){return(exp(mean(log(t$ssb.max.scaled[t$tsyear==years[x]]), na.rm=TRUE)))})
  ## mixed effects fit
  if(length(assessids)>=2){
    ##logssb.mixed.fit<-lme(logssb.mean.scaled~-1+as.factor(tsyear), data=t, random=~1|assessid,  correlation = corCAR1(form = ~tsyear))
    logssb.mixed.fit<-lme(logssb.mean.scaled~-1+as.factor(tsyear), data=t[t$tsyear%in%years,], random=~1|assessid,  correlation = corCAR1(form = ~tsyear))
  }
  ## ar1 fit
  if(scaling=="by.max"){
    return(data.frame(years, region, category, n=length(assessids), index=pred.max.scaled))
  }
  if(scaling=="by.scale.year"){
    return(data.frame(years, region, category, n=length(assessids), index=pred.by.year.scaled))
  }
  if(scaling=="by.log.demeaned"){
      if(length(assessids)>=2){
        upr<-fixef(logssb.mixed.fit)+1.96*sqrt(diag(summary(logssb.mixed.fit)$varFix))
        lwr<-fixef(logssb.mixed.fit)-1.96*sqrt(diag(summary(logssb.mixed.fit)$varFix))
        return(data.frame(years, region, category, n=length(assessids), index=fixef(logssb.mixed.fit), upr=upr,lwr=lwr))
      }
  }}
}

regions.vec<-c("NEAtl", "NWAtl", "NorthMidAtl", "Med", "SAfr", "NEPac", "Aust-NZ", "HighSeas")

##-----------------------
## Relative to 1978
##-----------------------

pelagic.1978.list<-list()
for(i in 1:length(regions.vec)){
  print(i)
  pelagic.1978.list[[regions.vec[i]]]<-get.scaled.index(region=regions.vec[i], category="Pelagic", scale.year=1978, scaling="by.scale.year", all.stocks.present=FALSE)
}


demersal.1978.list<-list()
for(i in 1:length(regions.vec)){
  print(i)
  demersal.1978.list[[regions.vec[i]]]<-get.scaled.index(region=regions.vec[i], category="Demersal", scale.year=1978, scaling="by.scale.year", all.stocks.present=FALSE)
}


## plotting functions
plot.base.1978.func<-function(region, ylim=c(0,2.9), xlim=c(1978,2010), yaxt="n", xaxt="n"){
  plot(NA, xlim=xlim, ylim=ylim, xlab="", xaxt=xaxt, yaxt="n", cex.axis=1.2)
  if(yaxt=="s"){axis(side=2,at=seq(0,2.9,by=0.5))}
  pel.n<-try(unique(pelagic.1978.list[[region]]$n), silent=TRUE)
  dem.n<-try(unique(demersal.1978.list[[region]]$n), silent=TRUE)
  legend("topright", legend=c(paste("N=", ifelse(is.numeric(pel.n), pel.n,0), sep=""), paste("N=", ifelse(is.numeric(dem.n), dem.n,0), sep="")), pch=c(2,17), bty="n")
  legend("topleft", legend=region, bty="n", cex=1.1)
}


plot.trend.1978.func<-function(region, category){
  if(category=="Pelagic"){
    with(pelagic.1978.list[[region]], try(points(years,index, type="o", pch=24, bg = "white", col = "black"), silent=TRUE))
  }
 if(category=="Demersal"){
    with(demersal.1978.list[[region]], try(points(years,index, type="o", pch=17), silent=TRUE))
  }
}
    

##-----------------------
## Relative to maximum
##-----------------------

pelagic.max.list<-list()
for(i in 1:length(regions.vec)){
  print(i)
  pelagic.max.list[[regions.vec[i]]]<-get.scaled.index(region=regions.vec[i], category="Pelagic", scale.year=1978, scaling="by.max", all.stocks.present=FALSE)
}


demersal.max.list<-list()
for(i in 1:length(regions.vec)){
  print(i)
  demersal.max.list[[regions.vec[i]]]<-get.scaled.index(region=regions.vec[i], category="Demersal", scale.year=1978, scaling="by.max", all.stocks.present=FALSE)
}

## plotting functions
plot.max.base.func<-function(region, ylim=c(0,1.2), xlim=c(1978,2010), yaxt="n", xaxt="n"){
  plot(NA, xlim=xlim, ylim=ylim, xlab="", xaxt=xaxt, yaxt="n", cex.axis=1.2)
  if(yaxt=="s"){axis(side=2,at=seq(0,1.5,by=0.25),cex.axis=1.2)}
  pel.n<-try(unique(pelagic.max.list[[region]]$n), silent=TRUE)
  dem.n<-try(unique(demersal.max.list[[region]]$n), silent=TRUE)
  legend("topright", legend=c(paste("N=", ifelse(is.numeric(pel.n), pel.n,0), sep=""), paste("N=", ifelse(is.numeric(dem.n), dem.n,0), sep="")), pch=c(2,17), bty="n")
  legend("topleft", legend=region, bty="n", cex=1.1)
}

plot.trend.max.func<-function(region, category){
  if(category=="Pelagic"){
    with(pelagic.max.list[[region]], try(points(years,index, type="o", pch=24, bg = "white", col = "black"), silent=TRUE))    
    ##with(pelagic.max.list[[region]], try(points(years,index, type="o", pch=2), silent=TRUE))
  }
 if(category=="Demersal"){
    with(demersal.max.list[[region]], try(points(years,index, type="o", pch=17), silent=TRUE))
  }
}


##-----------------------
## Mixed effects fits
##-----------------------

pelagic.mixed.list<-list()
for(i in 1:length(regions.vec)){
  print(i)
  pelagic.mixed.list[[regions.vec[i]]]<-get.scaled.index(region=regions.vec[i], category="Pelagic", scale.year=1978, scaling="by.log.demeaned", all.stocks.present=FALSE)
}


demersal.mixed.list<-list()
for(i in 1:length(regions.vec)){
  print(i)
  demersal.mixed.list[[regions.vec[i]]]<-get.scaled.index(region=regions.vec[i], category="Demersal", scale.year=1978, scaling="by.log.demeaned", all.stocks.present=FALSE)
}

## plotting functions
plot.mixed.base.func<-function(region, ylim=c(-1.0,1.0), xlim=c(1978,2010), yaxt="n", xaxt="n"){
  plot(NA, xlim=xlim, ylim=ylim, xlab="", xaxt=xaxt, yaxt="n", cex.axis=1.2)
  if(yaxt=="s"){axis(side=2,at=seq(-1.0,0.75,by=0.25),cex.axis=1.2)}
  pel.n<-try(unique(pelagic.mixed.list[[region]]$n), silent=TRUE)
  dem.n<-try(unique(demersal.mixed.list[[region]]$n), silent=TRUE)
  legend("topright", legend=c(paste("N=", ifelse(is.numeric(pel.n), pel.n,0), sep=""), paste("N=", ifelse(is.numeric(dem.n), dem.n,0), sep="")), pch=c(2,17), bty="n")
  legend("topleft", legend=region, bty="n", cex=1.1)
}

plot.trend.mixed.func<-function(region, category){
  if(category=="Pelagic"){
    with(pelagic.mixed.list[[region]], try(points(years,index, type="o", pch=24, bg = "white", col = "black"), silent=TRUE))    
    ##with(pelagic.mixed.list[[region]], try(points(years,index, type="o", pch=2), silent=TRUE))
  }
 if(category=="Demersal"){
    with(demersal.mixed.list[[region]], try(points(years,index, type="o", pch=17), silent=TRUE))
  }
}

    

##-----------------------------
## PLOTS OF ALL SERIES AND FITS
##-----------------------------


plot.scaled.indices<-function(region, category, scale.year=1978, scaling, xaxt, yaxt, xlim,linecolor=grey(0.7), ylim=ylim, all.stocks.present=FALSE){
  if(category=="Pelagic"){
    t<-subset(dat,geo==region & taxocategory==category & tsyear>=scale.year)
  }else{
    t<-subset(dat,geo==region & taxocategory!="Pelagic" & tsyear>=scale.year)
  }
  ##if(length(t[,1])<1){stop("No data in this region-category combination")}
  if(length(t[,1])<1){return(c("No data in this region-category combination"))}else{
  ##stocks<-unique(t$stockid)
  assessids<-unique(t$assessid)
  ## SCALING
  ## value of each stock in scale.year
  ##scale.by.year<- data.frame(t(sapply(seq(1, length(stocks)), function(x){
  scale.by.year<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
    ## if 1978 not present, choose earliest value in the timeseries
    if(1978%in%t$tsyear[t$assessid==assessids[x]]){
      return(c(as.character(assessids[x]),t$ssb[t$tsyear==scale.year&t$assessid==assessids[x]]))
    }else{
      return(c(as.character(assessids[x]),t$ssb[t$tsyear==min(t$tsyear[t$assessid==assessids[x]]) & t$assessid==assessids[x]]))
    }
    })), stringsAsFactors=FALSE)
  scale.by.year[,2]<-as.numeric(scale.by.year[,2])
  ## max scale values
  scale.max<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
        return(c(as.character(assessids[x]),max(t$ssb[t$assessid==assessids[x]], na.rm=TRUE)))
      })), stringsAsFactors=FALSE)
  scale.max[,2]<-as.numeric(scale.max[,2])
  ## mean on log scale values
  scale.logmean<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
        return(c(as.character(assessids[x]),mean(log(t$ssb[t$assessid==assessids[x]]), na.rm=TRUE)))
      })), stringsAsFactors=FALSE)
  scale.logmean[,2]<-as.numeric(scale.logmean[,2])
  t$ssb.by.year.scaled<-sapply(seq(1, length(t$ssb)), function(x){
    t$ssb[x]/(scale.by.year[scale.by.year[,1]==t$assessid[x],2])
  })
  t$ssb.max.scaled<-sapply(seq(1, length(t$ssb)), function(x){
    t$ssb[x]/(scale.max[scale.max[,1]==t$assessid[x],2])})
  t$logssb.mean.scaled<-sapply(seq(1, length(t$ssb)), function(x){
    log(t$ssb[x])- scale.logmean[scale.logmean[,1]==t$assessid[x],2]})
  if(all.stocks.present){
    ## which years are fully present
    years1<-unique(t$tsyear)[order(unique(t$tsyear))]
    num.assess.by.year<-sapply(seq(1, length(years1)), function(x){length(t$assessid[t$tsyear==years1[x]&!is.na(t$ssb)])})
    n.total.assess<-length(unique(t$assessid))
    years.index <-as.logical(ifelse(num.assess.by.year==n.total.assess,1,0))
    years<-years1[years.index]
  }else{
    years<-unique(t$tsyear)[order(unique(t$tsyear))]
  }
  ## FITS
  ##years<-unique(t$tsyear)[order(unique(t$tsyear))]
  ## geometric means
  pred.by.year.scaled<-sapply(seq(1, length(years)), function(x){return(exp(mean(log(t$ssb.by.year.scaled[t$tsyear==years[x]]), na.rm=TRUE)))})
  pred.max.scaled<-sapply(seq(1, length(years)), function(x){return(exp(mean(log(t$ssb.max.scaled[t$tsyear==years[x]]), na.rm=TRUE)))})
  ## mixed effects fit
  if(length(assessids)>=2){
    logssb.mixed.fit<-lme(logssb.mean.scaled~-1+as.factor(tsyear), data=t[t$tsyear%in%years,], random=~1|assessid,  correlation = corCAR1(form = ~tsyear))
  }
  if(scaling=="by.max"){
    with(t, plot(tsyear, ssb.max.scaled, type="n", xaxt=xaxt, yaxt=yaxt, xlim=xlim))
    sapply(seq(1, length(assessids)), function(x){with(t[t$assessid==assessids[x],], lines(tsyear,ssb.max.scaled, col=linecolor))})
    legend("topleft", legend="Scaled relative to maximum \n (geometric mean)", bty="n", cex=1.2)
  }
  if(scaling=="by.scale.year"){
    with(t, plot(tsyear, ssb.by.year.scaled, type="n", xaxt=xaxt, yaxt=yaxt, xlim=xlim))
    sapply(seq(1, length(assessids)), function(x){with(t[t$assessid==assessids[x],], lines(tsyear,ssb.by.year.scaled, col=linecolor))})
    legend("topleft", legend="Scaled relative to 1978 \n (geometric mean)", bty="n", cex=1.2)
  }
  if(scaling=="by.log.demeaned"){
    with(t, plot(tsyear, logssb.mean.scaled, type="n", xaxt=xaxt, yaxt=yaxt, xlim=xlim, ylim=ylim))
    sapply(seq(1, length(assessids)), function(x){with(t[t$assessid==assessids[x],], lines(tsyear,logssb.mean.scaled, col=linecolor))})
    ##legend("topleft", legend="Demeaned on log scale \n (mixed effects fit)", bty="n", cex=1.2)
    legend("topleft", legend=paste(region," : ", category, sep=""), bty="n", cex=1.2)
  }
}
}

##------------------------------
## PLOT THE SERIES AND FITS
##------------------------------
## DEMERSAL

pdf("./Demersal_mixed_effects_fits.pdf", height=8, width=8)
par(mfrow=c(3,2), mar=c(0,0,0,0), oma=c(4,4,2,2))
## NWAtl
plot.scaled.indices(region="NWAtl", category="Demersal", scale.year=1978, scaling="by.log.demeaned", xlim=c(1978,2010), xaxt="n", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list[["NWAtl"]], lines(years, index, lwd=1.5))
## NEAtl
plot.scaled.indices(region="NEAtl", category="Demersal", scale.year=1978, scaling="by.log.demeaned", xlim=c(1978,2010), xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list[["NEAtl"]], lines(years, index, lwd=1.5))
## NorthMidAtl
plot.scaled.indices(region="NorthMidAtl", category="Demersal", scale.year=1978, scaling="by.log.demeaned", xlim=c(1978,2010), xaxt="n", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list[["NorthMidAtl"]], lines(years, index, lwd=1.5))
## NEPac
plot.scaled.indices(region="NEPac", category="Demersal", scale.year=1978, scaling="by.log.demeaned", xlim=c(1978,2010), xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list[["NEPac"]], lines(years, index, lwd=1.5))
## Aust-NZ
plot.scaled.indices(region="Aust-NZ", category="Demersal", scale.year=1978, scaling="by.log.demeaned", xlim=c(1978,2010), xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list[["Aust-NZ"]], lines(years, index, lwd=1.5))
## NEPac
plot.scaled.indices(region="SAfr", category="Demersal", scale.year=1978, scaling="by.log.demeaned", xlim=c(1978,2010), xaxt="s", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list[["SAfr"]], lines(years, index, lwd=1.5))
mtext(text="Standardized series and fixed effect fits",side=2, outer=TRUE, line=2.5)
mtext(text="Year",side=1, outer=TRUE, line=2.5)
dev.off()
system("xpdf ./Demersal_mixed_effects_fits.pdf &")


## PELAGIC
pdf("./Pelagic_mixed_effects_fits.pdf", height=8, width=8)
par(mfrow=c(3,2), mar=c(0,0,0,0), oma=c(4,4,2,2))
## NWAtl
plot.scaled.indices(region="NWAtl", category="Pelagic", scale.year=1978, scaling="by.log.demeaned", xlim=c(1978,2010), xaxt="n", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list[["NWAtl"]], lines(years, index, lwd=1.5))
## NEAtl
plot.scaled.indices(region="NEAtl", category="Pelagic", scale.year=1978, scaling="by.log.demeaned", xlim=c(1978,2010), xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list[["NEAtl"]], lines(years, index, lwd=1.5))
## NorthMidAtl
plot.scaled.indices(region="NorthMidAtl", category="Pelagic", scale.year=1978, scaling="by.log.demeaned", xlim=c(1978,2010), xaxt="n", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list[["NorthMidAtl"]], lines(years, index, lwd=1.5))
## NEPac
plot.scaled.indices(region="NEPac", category="Pelagic", scale.year=1978, scaling="by.log.demeaned", xlim=c(1978,2010), xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list[["NEPac"]], lines(years, index, lwd=1.5))
## Aust-NZ
plot(seq(1978,2010),rep(1, length(seq(1978,2010))), xlim=c(1978,2010), type="n", ylim=c(-3,2))
legend("topleft", legend=paste("Aust-NZ"," : ", "Pelagic", "\n No data in this region-category combination", sep=""), bty="n", cex=1.2)
## NEPac
plot.scaled.indices(region="SAfr", category="Pelagic", scale.year=1978, scaling="by.log.demeaned", xlim=c(1978,2010), xaxt="s", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list[["SAfr"]], lines(years, index, lwd=1.5))
mtext(text="Standardized series and fixed effect fits",side=2, outer=TRUE, line=2.5)
mtext(text="Year",side=1, outer=TRUE, line=2.5)
dev.off()
system("xpdf ./Pelagic_mixed_effects_fits.pdf &")



plot.fits.panel.func<-function(region, category){
  par(mfrow=c(3,1), mar=c(0,0,0,0), oma=c(5,5,4,2))
  plot.scaled.indices(region=region, category=category, scale.year=1978, scaling="by.scale.year", xlim=c(1978,2009), xaxt="n", yaxt="s", linecolor=grey(0.7))
  if(category=="Pelagic"){
    with(pelagic.1978.list[[region]], lines(years, index, lwd=1.5))
  }
  if(category=="Demersal"){
    with(demersal.1978.list[[region]], lines(years, index, lwd=1.5))
  }
  plot.scaled.indices(region=region, category=category, scale.year=1978, scaling="by.max", xlim=c(1978,2009), xaxt="n", yaxt="s", linecolor=grey(0.7))
  if(category=="Pelagic"){
    with(pelagic.max.list[[region]], lines(years, index, lwd=1.5))
  }
  if(category=="Demersal"){
    with(demersal.max.list[[region]], lines(years, index, lwd=1.5))
  }
  plot.scaled.indices(region=region, category=category, scale.year=1978, scaling="by.log.demeaned", xlim=c(1978,2009), xaxt="s", yaxt="s", linecolor=grey(0.7))
  if(category=="Pelagic"){
    with(pelagic.mixed.list[[region]], lines(years, index, lwd=1.5))
  }
  if(category=="Demersal"){
    with(demersal.mixed.list[[region]], lines(years, index, lwd=1.5))
  }
  mtext(side=1, text="Year", cex=1.2, line=2.5, outer=TRUE)
  mtext(side=2, text="Scaled SSB", cex=1.2, line=2.5, outer=TRUE)
  mtext(side=3, text=paste(region, category, sep=" "), cex=1.2, line=1.5, outer=TRUE)
}


pdf("Temporal_trends_and_fits.pdf", width=8, height=10)
plot.fits.panel.func(region="NEAtl", category="Pelagic")
plot.fits.panel.func(region="NEAtl", category="Demersal")
plot.fits.panel.func(region="NWAtl", category="Pelagic")
plot.fits.panel.func(region="NWAtl", category="Demersal")
plot.fits.panel.func(region="NorthMidAtl", category="Pelagic")
plot.fits.panel.func(region="NorthMidAtl", category="Demersal")
plot.fits.panel.func(region="NEPac", category="Pelagic")
plot.fits.panel.func(region="NEPac", category="Demersal")
dev.off()


##----------------
## OVERALL TRENDS
##----------------

get.overall.index<-function(category, scale.year=1978, scaling, all.stocks.present=FALSE){
  if(category=="Pelagic"){
    t<-subset(dat, taxocategory==category& tsyear>=scale.year)
  }
  if(category=="Demersal"){  
    t<-subset(dat, taxocategory!="Pelagic" & tsyear>=scale.year)
  }
  if(category=="All"){
    t<-subset(dat, tsyear>=scale.year)
  }
  ##if(length(t[,1])<1){stop("No data in this region-category combination")}
  if(length(t[,1])<1){return(c("No data in this region-category combination"))}else{
  ##stocks<-unique(t$stockid)
  assessids<-unique(t$assessid)
  ## SCALING
  ## value of each stock in scale.year
  ##scale.by.year<- data.frame(t(sapply(seq(1, length(stocks)), function(x){
  scale.by.year<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
    ## if 1978 not present, choose earliest value in the timeseries
    if(1978%in%t$tsyear[t$assessid==assessids[x]]){
      return(c(as.character(assessids[x]),t$ssb[t$tsyear==scale.year&t$assessid==assessids[x]]))
    }else{
      return(c(as.character(assessids[x]),t$ssb[t$tsyear==min(t$tsyear[t$assessid==assessids[x]]) & t$assessid==assessids[x]]))
    }
    })), stringsAsFactors=FALSE)
  scale.by.year[,2]<-as.numeric(scale.by.year[,2])
  ## max scale values
  scale.max<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
        return(c(as.character(assessids[x]),max(t$ssb[t$assessid==assessids[x]], na.rm=TRUE)))
      })), stringsAsFactors=FALSE)
  scale.max[,2]<-as.numeric(scale.max[,2])
  ## mean on log scale values
  scale.logmean<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
        return(c(as.character(assessids[x]),mean(log(t$ssb[t$assessid==assessids[x]]), na.rm=TRUE)))
      })), stringsAsFactors=FALSE)
  scale.logmean[,2]<-as.numeric(scale.logmean[,2])
  t$ssb.by.year.scaled<-sapply(seq(1, length(t$ssb)), function(x){
    t$ssb[x]/(scale.by.year[scale.by.year[,1]==t$assessid[x],2])
  })
  t$ssb.max.scaled<-sapply(seq(1, length(t$ssb)), function(x){
    t$ssb[x]/(scale.max[scale.max[,1]==t$assessid[x],2])})
  t$logssb.mean.scaled<-sapply(seq(1, length(t$ssb)), function(x){
    log(t$ssb[x])- scale.logmean[scale.logmean[,1]==t$assessid[x],2]})
  if(all.stocks.present){
    ## which years are fully present
    years1<-unique(t$tsyear)[order(unique(t$tsyear))]
    num.assess.by.year<-sapply(seq(1, length(years1)), function(x){length(t$assessid[t$tsyear==years1[x]&!is.na(t$ssb)])})
    n.total.assess<-length(unique(t$assessid))
    years.index <-as.logical(ifelse(num.assess.by.year==n.total.assess,1,0))
    years<-years1[years.index]
  }else{
    years<-unique(t$tsyear)[order(unique(t$tsyear))]
  }
  ## FITS
  ##years<-unique(t$tsyear)[order(unique(t$tsyear))]
  ## geometric means
  pred.by.year.scaled<-sapply(seq(1, length(years)), function(x){return(exp(mean(log(t$ssb.by.year.scaled[t$tsyear==years[x]]), na.rm=TRUE)))})
  pred.max.scaled<-sapply(seq(1, length(years)), function(x){return(exp(mean(log(t$ssb.max.scaled[t$tsyear==years[x]]), na.rm=TRUE)))})
  ## mixed effects fit
  if(length(assessids)>=2){
    logssb.mixed.fit<-lme(logssb.mean.scaled~-1+as.factor(tsyear), data=t[t$tsyear%in%years,], random=~1|assessid,  correlation = corCAR1(form = ~tsyear))
  }
  ## ar1 fit
  if(scaling=="by.max"){
    return(data.frame(years, category, n=length(assessids), index=pred.max.scaled))
  }
  if(scaling=="by.scale.year"){
    return(data.frame(years, category, n=length(assessids), index=pred.by.year.scaled))
  }
  if(scaling=="by.log.demeaned"){
      if(length(assessids)>=2){
        upr<-fixef(logssb.mixed.fit)+1.96*sqrt(diag(summary(logssb.mixed.fit)$varFix))
        lwr<-fixef(logssb.mixed.fit)-1.96*sqrt(diag(summary(logssb.mixed.fit)$varFix))
        return(data.frame(years, category, n=length(assessids), index=fixef(logssb.mixed.fit), upr=upr, lwr=lwr))
      }
  }}
}

## pelagic
overall.pelagic.max.index<-get.overall.index(category="Pelagic", scale.year=1978, scaling="by.max", all.stocks.present=FALSE)
overall.pelagic.1978.index<-get.overall.index(category="Pelagic", scale.year=1978, scaling="by.scale.year", all.stocks.present=FALSE)
overall.pelagic.mixed.index<-get.overall.index(category="Pelagic", scale.year=1978, scaling="by.log.demeaned", all.stocks.present=FALSE)

## demersal
overall.demersal.max.index<-get.overall.index(category="Demersal", scale.year=1978, scaling="by.max", all.stocks.present=FALSE)
overall.demersal.1978.index<-get.overall.index(category="Demersal", scale.year=1978, scaling="by.scale.year", all.stocks.present=FALSE)
overall.demersal.mixed.index<-get.overall.index(category="Demersal", scale.year=1978, scaling="by.log.demeaned", all.stocks.present=FALSE)

## All combined
overall.all.max.index<-get.overall.index(category="All", scale.year=1978, scaling="by.max", all.stocks.present=FALSE)
overall.all.1978.index<-get.overall.index(category="All", scale.year=1978, scaling="by.scale.year", all.stocks.present=FALSE)
overall.all.mixed.index<-get.overall.index(category="All", scale.year=1978, scaling="by.log.demeaned", all.stocks.present=FALSE)

pel.overall.n<-unique(overall.pelagic.mixed.index$n)
dem.overall.n<-unique(overall.demersal.mixed.index$n)
all.overall.n<-unique(overall.all.mixed.index$n)

pdf("Overall_temporal_trends.pdf", width=8, height=10)
par(mfrow=c(3,1),mar=c(0,0,0,0), oma=c(5,5,5,2))
## relative to 1978
with(overall.pelagic.1978.index, plot(years, index, pch=2, type="o", ylim=c(0.5,1.5), xaxt="n"))
with(overall.demersal.1978.index, points(years, index, pch=17, type="o"))
legend("topleft", legend="Scaled relative to 1978", bty="n", cex=1.1)
legend("topright", legend=c(paste("Pelagic", " (N=", pel.overall.n, ")", sep=""), paste("Demersal", " (N=", dem.overall.n, ")", sep="")), pch=c(2,17), lty=1, bty="n", cex=1.1)
## relative to maximum
with(overall.pelagic.max.index, plot(years, index, pch=2, type="o", ylim=c(0.2,0.8), xaxt="n"))
with(overall.demersal.max.index, points(years, index, pch=17, type="o"))
legend("topleft", legend="Scaled relative to maximum", bty="n", cex=1.1)
## mixed effects fit
with(overall.pelagic.mixed.index, plot(years, index, pch=2, type="o", ylim=c(-0.5,0.3)))
with(overall.demersal.mixed.index, points(years, index, pch=17, type="o"))
legend("topleft", legend="Demeaned on log scale", bty="n", cex=1.1)
mtext(side=1, text="Year", cex=1.2, line=2.5, outer=TRUE)
mtext(side=2, text="Scaled SSB", cex=1.2, line=2.5, outer=TRUE)
mtext(side=3, text="Overall fits", cex=1.2, line=1.5, outer=TRUE)
dev.off()

##-------------------------------------------
## PLOTTING ROUTINES FOR MIXED EFFECTS FITS
##-------------------------------------------


plot.poly.base.func<-function(region, ylim=c(-1.0,1.0), xlim=c(1978,2010), yaxt="n", xaxt="n"){
  plot(NA, xlim=xlim, ylim=ylim, xlab="", xaxt=xaxt, yaxt="n", cex.axis=1.2)
  if(yaxt=="s"){axis(side=2,at=seq(-1.0,0.75,by=0.25),cex.axis=1.2)}
  pel.n<-try(unique(pelagic.mixed.list[[region]]$n), silent=TRUE)
  dem.n<-try(unique(demersal.mixed.list[[region]]$n), silent=TRUE)
  legend("topright", legend=c(paste("N=", ifelse(is.numeric(pel.n), pel.n,0), sep=""), paste("N=", ifelse(is.numeric(dem.n), dem.n,0), sep="")), col=c("#D95F02","#1B9E77"), lty=c(1,1) ,lwd=1.5, bty="n")
  legend("topleft", legend=region, bty="n", cex=1.1)
}


plot.poly.mixed.func<-function(region, category){
  if(category=="Pelagic"){
    with(pelagic.mixed.list[[region]], try(polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#D95F0240", border=NA), silent=TRUE))
    with(pelagic.mixed.list[[region]], try(lines(years,index,col="#D95F02", lty=1, lwd=1.2), silent=TRUE))
    ##with(pelagic.mixed.list[[region]], try(polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#0000ff22", border=NA), silent=TRUE))
    ##with(pelagic.mixed.list[[region]], try(lines(years,index,col="navy", lwd=1.5), silent=TRUE))
  }
 if(category=="Demersal"){
    with(demersal.mixed.list[[region]], try(polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#1B9E7740", border=NA), silent=TRUE))
    with(demersal.mixed.list[[region]], try(lines(years,index,col="#1B9E77", lwd=1.2), silent=TRUE))   
    ##with(demersal.mixed.list[[region]], try(polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#00ff0022", border=NA), silent=TRUE))
    ##with(demersal.mixed.list[[region]], try(lines(years,index,col="darkgreen", lwd=1.5), silent=TRUE))
  }
}


##------------------------------------------------
## Calculations for extracting percentage changes
##------------------------------------------------
percentage.change.df<-data.frame(name=rep(" ",11), start=rep(NA,11), end=rep(NA,11), percent=rep(NA,11), stringsAsFactors=FALSE)
## OVERALL
scale.year<-1978
t<-subset(dat, tsyear>=scale.year)
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
antilog.index<-exp(fixef(logssb.mixed.fit)+(var.random.effects+var.residuals)/2) ## see supp. info. for Worm et al (2009)
percentage.change.df$name[1]<-"overall"
percentage.change.df$start[1]<-mean(antilog.index[1:5])
percentage.change.df$end[1]<-mean(antilog.index[(length(antilog.index)-5):length(antilog.index)])
percentage.change.df$percent[1]<-round(100*(1-percentage.change.df$end[1]/percentage.change.df$start[1]),2)

## overall pelagic
t<-subset(dat, taxocategory=="Pelagic"& tsyear>=scale.year)
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
antilog.index<-exp(fixef(logssb.mixed.fit)+(var.random.effects+var.residuals)/2) ## see supp. info. for Worm et al (2009)
percentage.change.df$name[2]<-"pelagic"
percentage.change.df$start[2]<-mean(antilog.index[1:5])
percentage.change.df$end[2]<-mean(antilog.index[(length(antilog.index)-5):length(antilog.index)])
percentage.change.df$percent[2]<-round(100*(1-percentage.change.df$end[2]/percentage.change.df$start[2]),2)

## overall demersal
## overall pelagic or demersal
t<-subset(dat, taxocategory!="Pelagic" & tsyear>=scale.year)
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
antilog.index<-exp(fixef(logssb.mixed.fit)+(var.random.effects+var.residuals)/2) ## see supp. info. for Worm et al (2009)
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
    t<-subset(dat,geo==my.regions[i] & taxocategory!="Pelagic" & tsyear>=scale.year)
  }else{
    t<-subset(dat,geo==my.regions[i] & taxocategory=="Pelagic" & tsyear>=scale.year)
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
  antilog.index<-exp(fixef(logssb.mixed.fit)+(var.random.effects+var.residuals)/2) ## see supp. info. for Worm et al (2009)
  percentage.change.df$name[i+3]<-paste(my.regions[i],my.categories[i])
  percentage.change.df$start[i+3]<-mean(antilog.index[1:5])
  percentage.change.df$end[i+3]<-mean(antilog.index[(length(antilog.index)-5):length(antilog.index)])
  percentage.change.df$percent[i+3]<-round(100*(1-percentage.change.df$end[i+3]/percentage.change.df$start[i+3]),2)
}
  
  
## NEatl
regions.vec
t<-subset(dat,geo==region & taxocategory==category & tsyear>=scale.year)



## --------------
## SANDBOX
## --------------

    
pdf("Relative_to_maximum_temporal_trends.pdf", width=8, height=8)
par(mfrow=c(2,2), mar=c(0,0,0,0), oma=c(5,5,4,2))
## NEAtl
plot.max.base.func(region="NEAtl", yaxt="s", xaxt="n")
plot.trend.max.func(region="NEAtl", category="Pelagic")
plot.trend.max.func(region="NEAtl", category="Demersal")
## NWAtl
plot.max.base.func(region="NWAtl", yaxt="n", xaxt="n")
plot.trend.max.func(region="NWAtl", category="Pelagic")
plot.trend.max.func(region="NWAtl", category="Demersal")
## NorthMidAtl
plot.max.base.func(region="NorthMidAtl", yaxt="s", xaxt="s")
plot.trend.max.func(region="NorthMidAtl", category="Pelagic")
plot.trend.max.func(region="NorthMidAtl", category="Demersal")
## NEPac
plot.max.base.func(region="NEPac", yaxt="n", xaxt="s")
plot.trend.max.func(region="NEPac", category="Pelagic")
plot.trend.max.func(region="NEPac", category="Demersal")
mtext(side=1, text="Year", cex=1.2, line=2.5, outer=TRUE)
mtext(side=2, text="Scaled SSB", cex=1.2, line=2.5, outer=TRUE)
mtext(side=3, text="Scaled relative to maximum", cex=1.2, line=1.5, outer=TRUE)
dev.off()

pdf("Mixed_effects_temporal_trends.pdf", width=8, height=8)
par(mfrow=c(2,2), mar=c(0,0,0,0), oma=c(5,5,4,2))
## NEAtl
plot.mixed.base.func(region="NEAtl", yaxt="s", xaxt="n")
plot.trend.mixed.func(region="NEAtl", category="Pelagic")
plot.trend.mixed.func(region="NEAtl", category="Demersal")
## NWAtl
plot.mixed.base.func(region="NWAtl", yaxt="n", xaxt="n")
plot.trend.mixed.func(region="NWAtl", category="Pelagic")
plot.trend.mixed.func(region="NWAtl", category="Demersal")
## NorthMidAtl
plot.mixed.base.func(region="NorthMidAtl", yaxt="s", xaxt="s")
plot.trend.mixed.func(region="NorthMidAtl", category="Pelagic")
plot.trend.mixed.func(region="NorthMidAtl", category="Demersal")
## NEPac
plot.mixed.base.func(region="NEPac", yaxt="n", xaxt="s")
plot.trend.mixed.func(region="NEPac", category="Pelagic")
plot.trend.mixed.func(region="NEPac", category="Demersal")
mtext(side=1, text="Year", cex=1.2, line=2.5, outer=TRUE)
mtext(side=2, text="Scaled SSB", cex=1.2, line=2.5, outer=TRUE)
mtext(side=3, text="Mixed effects fits", cex=1.2, line=1.5, outer=TRUE)
dev.off()
