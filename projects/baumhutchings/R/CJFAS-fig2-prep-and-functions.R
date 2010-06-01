##------------------------------------------------------------------------------
## Relative abundance over time updated analysis (Hutchings and Baum, 2005)
## code for figure 2
## CM, DR
## date: Fri Aug 21 11:42:47 ADT 2009
## Time-stamp: <Last modified: 23 FEBRUARY 2010  (srdbadmin)>
## Notes: data query in 'reanalysis-models.R' return 'dat' data object used here
##------------------------------------------------------------------------------

require(nlme)

## find out what stocks meet the criteria

stocks<-unique(dat$stockid)
index<-sapply(seq(1,length(stocks)), function(x){
  return(1970%in%dat$tsyear[dat$stockid==stocks[x]] & 2007%in%dat$tsyear[dat$stockid==stocks[x]])
})
stocks[index]

get.scaled.index<-function(region, category, all.stocks.present=FALSE, min.year){
  ## returns year and estimated fixed effects index
  ## category is 'Pelagic' all else gets lumped as demersals
  ## all.stocks.present is turned on if we want to analyze only years for which all stocks are present
  if(category=="Pelagic"){
    t<-subset(dat,geo==region & taxocategory==category & tsyear>=min.year)
  }else{
    t<-subset(dat,geo==region & taxocategory!="Pelagic" & tsyear>=min.year)
  }
  ##if(length(t[,1])<1){stop("No data in this region-category combination")}
  if(length(t[,1])<1){return(c("No data in this region-category combination"))}else{
  ##stocks<-unique(t$stockid)
  assessids<-unique(t$assessid)
  ## SCALING
  ## mean on log scale values
  scale.logmean<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
        return(c(as.character(assessids[x]),mean(log(t$ssb[t$assessid==assessids[x]]), na.rm=TRUE)))
      })), stringsAsFactors=FALSE)
  scale.logmean[,2]<-as.numeric(scale.logmean[,2])
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
  if(length(assessids)>=2){
    ## ar1 fit
    logssb.mixed.fit<-lme(logssb.mean.scaled~-1+as.factor(tsyear), data=t[t$tsyear%in%years,], random=~1|assessid,  correlation = corCAR1(form = ~tsyear))
  }
      if(length(assessids)>=2){
        upr<-fixef(logssb.mixed.fit)+1.96*sqrt(diag(summary(logssb.mixed.fit)$varFix))
        lwr<-fixef(logssb.mixed.fit)-1.96*sqrt(diag(summary(logssb.mixed.fit)$varFix))
        return(data.frame(years, region, category, n=length(assessids), index=fixef(logssb.mixed.fit), upr=upr,lwr=lwr))
      }
  }
}

regions.vec<-c("NEAtl", "NWAtl", "NorthMidAtl", "Med", "SAfr", "NEPac", "Aust-NZ", "HighSeas")

##-----------------------
## Mixed effects fits
##-----------------------
## 1970
pelagic.mixed.list.1970<-list()
for(i in 1:length(regions.vec)){
  print(i)
  pelagic.mixed.list.1970[[regions.vec[i]]]<-get.scaled.index(region=regions.vec[i], category="Pelagic", all.stocks.present=FALSE, min.year=1970)
}
demersal.mixed.list.1970<-list()
for(i in 1:length(regions.vec)){
  print(i)
  demersal.mixed.list.1970[[regions.vec[i]]]<-get.scaled.index(region=regions.vec[i], category="Demersal", all.stocks.present=FALSE, min.year=1970)
}

## 1880
pelagic.mixed.list.1880<-list()
for(i in 1:length(regions.vec)){
  print(i)
  pelagic.mixed.list.1880[[regions.vec[i]]]<-get.scaled.index(region=regions.vec[i], category="Pelagic", all.stocks.present=FALSE, min.year=1880)
}
demersal.mixed.list.1880<-list()
for(i in 1:length(regions.vec)){
  print(i)
  demersal.mixed.list.1880[[regions.vec[i]]]<-get.scaled.index(region=regions.vec[i], category="Demersal", all.stocks.present=FALSE, min.year=1880)
}

## 1978
pelagic.mixed.list.1978<-list()
for(i in 1:length(regions.vec)){
  print(i)
  pelagic.mixed.list.1978[[regions.vec[i]]]<-get.scaled.index(region=regions.vec[i], category="Pelagic", all.stocks.present=FALSE, min.year=1978)
}
demersal.mixed.list.1978<-list()
for(i in 1:length(regions.vec)){
  print(i)
  demersal.mixed.list.1978[[regions.vec[i]]]<-get.scaled.index(region=regions.vec[i], category="Demersal", all.stocks.present=FALSE, min.year=1978)
}



plot.poly.base.func<-function(region, ylim=ylim, yaxt="n", xaxt="n", min.year){
  plot(NA, xlim=c(min.year,2010), ylim=ylim, xlab="", xaxt=xaxt, yaxt="n", cex.axis=1.2)
  if(yaxt=="s"){axis(side=2,at=pretty(ylim),cex.axis=1.2)}
  pel.dat<-get(paste("pelagic.mixed.list.",min.year, sep=""))
  dem.dat<-get(paste("demersal.mixed.list.",min.year, sep=""))
  pel.n<-try(unique(pel.dat[[region]]$n), silent=TRUE)
  dem.n<-try(unique(dem.dat[[region]]$n), silent=TRUE)
  legend("topright", legend=c(paste("N=", ifelse(is.numeric(pel.n), pel.n,0), sep=""), paste("N=", ifelse(is.numeric(dem.n), dem.n,0), sep="")), col=c("#D95F02","#1B9E77"), lty=c(1,1) ,lwd=1.5, bty="n")
  legend("topleft", legend=region, bty="n", cex=1.1)
}


plot.poly.mixed.func<-function(region, category, min.year){
  if(category=="Pelagic"){
    pel.dat<-try(get(paste("pelagic.mixed.list.",min.year, sep="")), silent=TRUE)    
    ##try(with(pel.dat[[region]], polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#D95F0240", border=NA)), silent=TRUE)
    ##try(with(pel.dat[[region]], lines(years,index,col="#D95F02", lty=1, lwd=1.2)), silent=TRUE)
    try(with(pel.dat[[region]], polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#D95F0240", border=NA)), silent=TRUE)
    try(with(pel.dat[[region]], lines(years,index,col="#D95F02", lty=1, lwd=1.2)), silent=TRUE)
   }
 if(category=="Demersal"){
   dem.dat<-get(paste("demersal.mixed.list.",min.year, sep=""))
   ##try(with(dem.dat[[region]], polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#1B9E7740", border=NA)), silent=TRUE)
   ##try(with(dem.dat[[region]], lines(years,index,col="#1B9E77", lwd=1.2)), silent=TRUE)
   try(with(dem.dat[[region]], polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#1B9E7740", border=NA)), silent=TRUE)
   try(with(dem.dat[[region]], lines(years,index,col="#1B9E77", lwd=1.2)), silent=TRUE)      
  }
}

## for exponential (original) scale plot

plot.poly.mixed.func.exp<-function(region, category, min.year){
  if(category=="Pelagic"){
    pel.dat<-try(get(paste("pelagic.mixed.list.",min.year, sep="")), silent=TRUE)    
    ##try(with(pel.dat[[region]], polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#D95F0240", border=NA)), silent=TRUE)
    ##try(with(pel.dat[[region]], lines(years,index,col="#D95F02", lty=1, lwd=1.2)), silent=TRUE)
    try(with(pel.dat[[region]], polygon(c(years,rev(years)),exp(c(lwr,rev(upr))),col="#D95F0240", border=NA)), silent=TRUE)
    try(with(pel.dat[[region]], lines(years,exp(index),col="#D95F02", lty=1, lwd=1.2)), silent=TRUE)
   }
 if(category=="Demersal"){
   dem.dat<-get(paste("demersal.mixed.list.",min.year, sep=""))
   ##try(with(dem.dat[[region]], polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#1B9E7740", border=NA)), silent=TRUE)
   ##try(with(dem.dat[[region]], lines(years,index,col="#1B9E77", lwd=1.2)), silent=TRUE)
   try(with(dem.dat[[region]], polygon(c(years,rev(years)),exp(c(lwr,rev(upr))),col="#1B9E7740", border=NA)), silent=TRUE)
   try(with(dem.dat[[region]], lines(years,exp(index),col="#1B9E77", lwd=1.2)), silent=TRUE)      
  }
}


##----------------
## OVERALL TRENDS
##----------------

get.overall.index<-function(category, all.stocks.present=FALSE, min.year){
  if(category=="Pelagic"){
    t<-subset(dat, taxocategory==category & tsyear>=min.year)
  }
  if(category=="Demersal"){  
    t<-subset(dat, taxocategory!="Pelagic" & tsyear>=min.year)
  }
  if(category=="All"){
    t<-subset(dat, tsyear>=min.year)
  }
  ##if(length(t[,1])<1){stop("No data in this region-category combination")}
  if(length(t[,1])<1){return(c("No data in this region-category combination"))}else{
  ##stocks<-unique(t$stockid)
  assessids<-unique(t$assessid)
  ## SCALING
  ## mean on log scale values
  scale.logmean<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
        return(c(as.character(assessids[x]),mean(log(t$ssb[t$assessid==assessids[x]]), na.rm=TRUE)))
      })), stringsAsFactors=FALSE)
  scale.logmean[,2]<-as.numeric(scale.logmean[,2])
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
  ## ar1 fit
      if(length(assessids)>=2){
        logssb.mixed.fit<-lme(logssb.mean.scaled~-1+as.factor(tsyear), data=t[t$tsyear%in%years,], random=~1|assessid,  correlation = corCAR1(form = ~tsyear))
        upr<-fixef(logssb.mixed.fit)+1.96*sqrt(diag(summary(logssb.mixed.fit)$varFix))
        lwr<-fixef(logssb.mixed.fit)-1.96*sqrt(diag(summary(logssb.mixed.fit)$varFix))
        return(data.frame(years, category, n=length(assessids), index=fixef(logssb.mixed.fit), upr=upr, lwr=lwr))
      }
  }
}

## 1970
overall.pelagic.mixed.index.1970<-get.overall.index(category="Pelagic", all.stocks.present=FALSE, min.year=1970)
overall.demersal.mixed.index.1970<-get.overall.index(category="Demersal", all.stocks.present=FALSE, min.year=1970)
overall.all.mixed.index.1970<-get.overall.index(category="All", all.stocks.present=FALSE, min.year=1970)

## 1880
overall.pelagic.mixed.index.1880<-get.overall.index(category="Pelagic", all.stocks.present=FALSE, min.year=1880)
overall.demersal.mixed.index.1880<-get.overall.index(category="Demersal", all.stocks.present=FALSE, min.year=1880)
overall.all.mixed.index.1880<-get.overall.index(category="All", all.stocks.present=FALSE, min.year=1880)

## 1978
overall.pelagic.mixed.index.1978<-get.overall.index(category="Pelagic", all.stocks.present=FALSE, min.year=1978)
overall.demersal.mixed.index.1978<-get.overall.index(category="Demersal", all.stocks.present=FALSE, min.year=1978)
overall.all.mixed.index.1978<-get.overall.index(category="All", all.stocks.present=FALSE, min.year=1978)

##-----------------------------
## PLOTS OF ALL SERIES AND FITS
##-----------------------------

plot.scaled.indices<-function(region, category, xaxt, yaxt, min.year,linecolor=grey(0.7), ylim=ylim, all.stocks.present=FALSE){
  if(category=="Pelagic"){
    t<-subset(dat,geo==region & taxocategory==category & tsyear>=min.year)
  }else{
    t<-subset(dat,geo==region & taxocategory!="Pelagic" & tsyear>=min.year)
  }
  ##if(length(t[,1])<1){stop("No data in this region-category combination")}
  if(length(t[,1])<1){return(c("No data in this region-category combination"))}else{
  ##stocks<-unique(t$stockid)
  assessids<-unique(t$assessid)
  ## SCALING
  ## mean on log scale values
  scale.logmean<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
        return(c(as.character(assessids[x]),mean(log(t$ssb[t$assessid==assessids[x]]), na.rm=TRUE)))
      })), stringsAsFactors=FALSE)
  scale.logmean[,2]<-as.numeric(scale.logmean[,2])
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
  ## mixed effects fit
  if(length(assessids)>=2){
    logssb.mixed.fit<-lme(logssb.mean.scaled~-1+as.factor(tsyear), data=t[t$tsyear%in%years,], random=~1|assessid,  correlation = corCAR1(form = ~tsyear))
  }
    with(t, plot(tsyear, logssb.mean.scaled, type="n", xaxt=xaxt, yaxt=yaxt, xlim=c(min.year,2010), ylim=ylim))
    sapply(seq(1, length(assessids)), function(x){with(t[t$assessid==assessids[x],], lines(tsyear,logssb.mean.scaled, col=linecolor))})
    ##legend("topleft", legend="Demeaned on log scale \n (mixed effects fit)", bty="n", cex=1.2)
    legend("topleft", legend=paste(region," : ", category, sep=""), bty="n", cex=1.2)
}
}

##------------------------------
## PLOT ALL SERIES AND FITS
##------------------------------
## 1880
## DEMERSAL
pdf("./demersal-multispecies-allseries-1880.pdf", height=8, width=8)
par(mfrow=c(3,2), mar=c(0,0,0,0), oma=c(4,4,2,2))
## NWAtl
plot.scaled.indices(region="NWAtl", category="Demersal", min.year=1880, xaxt="n", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1880[["NWAtl"]], lines(years, index, lwd=1.5))
## NEAtl
plot.scaled.indices(region="NEAtl", category="Demersal", min.year=1880, xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1880[["NEAtl"]], lines(years, index, lwd=1.5))
## NorthMidAtl
plot.scaled.indices(region="NorthMidAtl", category="Demersal", min.year=1880, xaxt="n", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1880[["NorthMidAtl"]], lines(years, index, lwd=1.5))
## NEPac
plot.scaled.indices(region="NEPac", category="Demersal", min.year=1880, xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1880[["NEPac"]], lines(years, index, lwd=1.5))
## High-Seas
plot.scaled.indices(region="HighSeas", category="Demersal", min.year=1880, xaxt="s", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1880[["HighSeas"]], lines(years, index, lwd=1.5))
## Aust-NZ
plot.scaled.indices(region="Aust-NZ", category="Demersal", min.year=1880, xaxt="s", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1880[["Aust-NZ"]], lines(years, index, lwd=1.5))
mtext(text="Standardized series and fixed effects fits",side=2, outer=TRUE, line=2.5)
mtext(text="Year",side=1, outer=TRUE, line=2.5)
dev.off()
## PELAGIC
pdf("./pelagic-multispecies-allseries-1880.pdf", height=8, width=8)
par(mfrow=c(3,2), mar=c(0,0,0,0), oma=c(4,4,2,2))
## NWAtl
plot.scaled.indices(region="NWAtl", category="Pelagic", min.year=1880, xaxt="n", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list.1880[["NWAtl"]], lines(years, index, lwd=1.5))
## NEAtl
plot.scaled.indices(region="NEAtl", category="Pelagic", min.year=1880, xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list.1880[["NEAtl"]], lines(years, index, lwd=1.5))
## NorthMidAtl
plot.scaled.indices(region="NorthMidAtl", category="Pelagic", min.year=1880, xaxt="n", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list.1880[["NorthMidAtl"]], lines(years, index, lwd=1.5))
## NEPac
plot.scaled.indices(region="NEPac", category="Pelagic", min.year=1880, xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list.1880[["NEPac"]], lines(years, index, lwd=1.5))
## High-Seas
plot.scaled.indices(region="HighSeas", category="Pelagic",min.year=1880, xaxt="s", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list.1880[["HighSeas"]], lines(years, index, lwd=1.5))
## Aust-NZ
plot(seq(1880,2010), rep(1, length(seq(1880,2010))), type="n", ylim=c(-3,2), yaxt="n")
legend("topleft", legend="Aust-NZ pelagic: \nNo data in this region-category combination", bty="n", cex=1.2)
mtext(text="Standardized series and fixed effects fits",side=2, outer=TRUE, line=2.5)
mtext(text="Year",side=1, outer=TRUE, line=2.5)
dev.off()

## 1970
## DEMERSAL
pdf("./demersal-multispecies-allseries-1970.pdf", height=8, width=8)
par(mfrow=c(3,2), mar=c(0,0,0,0), oma=c(4,4,2,2))
## NWAtl
plot.scaled.indices(region="NWAtl", category="Demersal", min.year=1970, xaxt="n", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1970[["NWAtl"]], lines(years, index, lwd=1.5))
## NEAtl
plot.scaled.indices(region="NEAtl", category="Demersal", min.year=1970, xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1970[["NEAtl"]], lines(years, index, lwd=1.5))
## NorthMidAtl
plot.scaled.indices(region="NorthMidAtl", category="Demersal", min.year=1970, xaxt="n", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1970[["NorthMidAtl"]], lines(years, index, lwd=1.5))
## NEPac
plot.scaled.indices(region="NEPac", category="Demersal", min.year=1970, xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1970[["NEPac"]], lines(years, index, lwd=1.5))
## High-Seas
plot.scaled.indices(region="HighSeas", category="Demersal", min.year=1970, xaxt="s", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1970[["HighSeas"]], lines(years, index, lwd=1.5))
## Aust-NZ
plot.scaled.indices(region="Aust-NZ", category="Demersal", min.year=1970, xaxt="s", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1970[["Aust-NZ"]], lines(years, index, lwd=1.5))
mtext(text="Standardized series and fixed effects fits",side=2, outer=TRUE, line=2.5)
mtext(text="Year",side=1, outer=TRUE, line=2.5)
dev.off()
## PELAGIC
pdf("./pelagic-multispecies-allseries-1970.pdf", height=8, width=8)
par(mfrow=c(3,2), mar=c(0,0,0,0), oma=c(4,4,2,2))
## NWAtl
plot.scaled.indices(region="NWAtl", category="Pelagic", min.year=1970, xaxt="n", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list.1970[["NWAtl"]], lines(years, index, lwd=1.5))
## NEAtl
plot.scaled.indices(region="NEAtl", category="Pelagic", min.year=1970, xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list.1970[["NEAtl"]], lines(years, index, lwd=1.5))
## NorthMidAtl
plot.scaled.indices(region="NorthMidAtl", category="Pelagic", min.year=1970, xaxt="n", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list.1970[["NorthMidAtl"]], lines(years, index, lwd=1.5))
## NEPac
plot.scaled.indices(region="NEPac", category="Pelagic", min.year=1970, xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list.1970[["NEPac"]], lines(years, index, lwd=1.5))
## High-Seas
plot.scaled.indices(region="HighSeas", category="Pelagic",min.year=1970, xaxt="s", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list.1970[["HighSeas"]], lines(years, index, lwd=1.5))
## Aust-NZ
plot(seq(1970,2010), rep(1, length(seq(1970,2010))), type="n", ylim=c(-3,2), yaxt="n")
legend("topleft", legend="Aust-NZ pelagic: \nNo data in this region-category combination", bty="n", cex=1.2)
mtext(text="Standardized series and fixed effects fits",side=2, outer=TRUE, line=2.5)
mtext(text="Year",side=1, outer=TRUE, line=2.5)
dev.off()


## 1978
## DEMERSAL
pdf("./demersal-multispecies-allseries-1978.pdf", height=8, width=8)
par(mfrow=c(3,2), mar=c(0,0,0,0), oma=c(4,4,2,2))
## NWAtl
plot.scaled.indices(region="NWAtl", category="Demersal", min.year=1978, xaxt="n", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1978[["NWAtl"]], lines(years, index, lwd=1.5))
## NEAtl
plot.scaled.indices(region="NEAtl", category="Demersal", min.year=1978, xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1978[["NEAtl"]], lines(years, index, lwd=1.5))
## NorthMidAtl
plot.scaled.indices(region="NorthMidAtl", category="Demersal", min.year=1978, xaxt="n", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1978[["NorthMidAtl"]], lines(years, index, lwd=1.5))
## NEPac
plot.scaled.indices(region="NEPac", category="Demersal", min.year=1978, xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1978[["NEPac"]], lines(years, index, lwd=1.5))
## High-Seas
plot.scaled.indices(region="HighSeas", category="Demersal", min.year=1978, xaxt="s", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1978[["HighSeas"]], lines(years, index, lwd=1.5))
## Aust-NZ
plot.scaled.indices(region="Aust-NZ", category="Demersal", min.year=1978, xaxt="s", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(demersal.mixed.list.1978[["Aust-NZ"]], lines(years, index, lwd=1.5))
mtext(text="Standardized series and fixed effects fits",side=2, outer=TRUE, line=2.5)
mtext(text="Year",side=1, outer=TRUE, line=2.5)
dev.off()
## PELAGIC
pdf("./pelagic-multispecies-allseries-1978.pdf", height=8, width=8)
par(mfrow=c(3,2), mar=c(0,0,0,0), oma=c(4,4,2,2))
## NWAtl
plot.scaled.indices(region="NWAtl", category="Pelagic", min.year=1978, xaxt="n", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list.1978[["NWAtl"]], lines(years, index, lwd=1.5))
## NEAtl
plot.scaled.indices(region="NEAtl", category="Pelagic", min.year=1978, xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list.1978[["NEAtl"]], lines(years, index, lwd=1.5))
## NorthMidAtl
plot.scaled.indices(region="NorthMidAtl", category="Pelagic", min.year=1978, xaxt="n", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list.1978[["NorthMidAtl"]], lines(years, index, lwd=1.5))
## NEPac
plot.scaled.indices(region="NEPac", category="Pelagic", min.year=1978, xaxt="n", yaxt="n", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list.1978[["NEPac"]], lines(years, index, lwd=1.5))
## High-Seas
plot.scaled.indices(region="HighSeas", category="Pelagic",min.year=1978, xaxt="s", yaxt="s", linecolor=grey(0.7), ylim=c(-3,2))
with(pelagic.mixed.list.1978[["HighSeas"]], lines(years, index, lwd=1.5))
## Aust-NZ
plot(seq(1978,2010), rep(1, length(seq(1978,2010))), type="n", ylim=c(-3,2), yaxt="n")
legend("topleft", legend="Aust-NZ pelagic: \nNo data in this region-category combination", bty="n", cex=1.2)
mtext(text="Standardized series and fixed effects fits",side=2, outer=TRUE, line=2.5)
mtext(text="Year",side=1, outer=TRUE, line=2.5)
dev.off()
