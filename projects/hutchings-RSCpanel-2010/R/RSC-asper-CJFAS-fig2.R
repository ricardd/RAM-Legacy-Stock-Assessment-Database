## plots for RSC expert panel report
## from earlier work by CM, DR
## started: 2011-03-11
## last modified Time-stamp: <2011-03-16 22:51:06 (srdbadmin)>

## REQUIRED PACKAGES
require(nlme); require(gregmisc)
rm(list=ls(all=TRUE))

source("RSCpanel-final-report.R")

## LOAD FUNCTIONS 
source("./RSC-asper-CJFAS-fig2-functions.R")

## DATA
source("./RSC-data-1010.R")
source("./RSC-asper-CJFAS-fig2-prep.R")

ts.dat <- dat.1010
brp.ratio.dat <- ts.ratios.dat



## make sure required years are present
min.year<-1978
max.year<-2002

## ts.dat
ts.assessid.vec<-unique(ts.dat$assessid)
## find out if 1978 and 2002 available?
ts.years.present.mat<-sapply(ts.assessid.vec, function(x){c(min.year,max.year) %in% subset(ts.dat,assessid==x)$tsyear})
##
table(apply(ts.years.present.mat,2,function(x){sum(x)}))
## need both to be true so the sum should be >1
ts.years.present.index<-apply(ts.years.present.mat,2,function(x){sum(x)>1})
ts.dat2<-subset(ts.dat, assessid %in% ts.assessid.vec[ts.years.present.index])

## RESTRICT THE ASSESSMENTS TO THOSE OF CANADIAN INTEREST
ts.dat2<-merge(tt.dat,ts.dat2,by.x=c("aid"),by.y=c("assessid"))


## brp.ratio.dat
brp.ratio.assessid.vec<-unique(brp.ratio.dat$assessid)
## find out if 1978 and 2002 available?
brp.years.present.mat<-sapply(brp.ratio.assessid.vec, function(x){c(min.year,max.year) %in% subset(brp.ratio.dat,assessid==x)$tsyear})
##
table(apply(brp.years.present.mat,2,function(x){sum(x)}))
## Are the both FALSE stocks, those without reference points?
## need both to be true so the sum should be >1
brp.years.present.index<-apply(brp.years.present.mat,2,function(x){sum(x)>1})
## fewer number of stocks
brp.ratio.dat2<-subset(brp.ratio.dat, assessid %in% brp.ratio.assessid.vec[brp.years.present.index])
## RESTRICT THE ASSESSMENTS TO THOSE OF CANADIAN INTEREST
brp.ratio.dat2<-merge(tt.dat,brp.ratio.dat2,by.x=c("aid"),by.y=c("assessid"))


## INDICES
## Note that 'orig' refers to original analysis
## i.e. ssb trends scaled by subtracting the mean on the log scale
## 'brp' refers to trends of the reference point scaled series
## get the indices and associated confidence intervals
## use function get.scaled.index in ./CJFAS-shortcomm-fig2-functions.R

## get the log of the brp ratio data to go from lognormal to normal
brp.ratio.dat2$lnratio<-log(brp.ratio.dat2$ratio)

regions.vec<-c("NWAtl", "NEPac","HighSeas")
#regions.vec<-c("NEAtl", "NWAtl", "NorthMidAtl", "SAfr", "NEPac", "Aust-NZ", "HighSeas")

## Pelagic by region
## brp
brp.pelagic.mixed.list<-list()
for(i in 1:length(regions.vec)){
  print(i)
  brp.pelagic.mixed.list[[regions.vec[i]]]<-get.mixed.index(region=regions.vec[i], category="Pelagic", min.year=1970, brp=TRUE)
}
## orig
orig.pelagic.mixed.list<-list()
for(i in 1:length(regions.vec)){
  print(i)
  orig.pelagic.mixed.list[[regions.vec[i]]]<-get.mixed.index(region=regions.vec[i], category="Pelagic", min.year=1970, brp=FALSE)
}

## Demersal by region
## brp
brp.demersal.mixed.list<-list()
for(i in 1:length(regions.vec)){
  print(i)
  brp.demersal.mixed.list[[regions.vec[i]]]<-get.mixed.index(region=regions.vec[i], category="Demersal", min.year=1970, brp=TRUE)
}

## orig
orig.demersal.mixed.list<-list()
for(i in 1:length(regions.vec)){
  print(i)
  orig.demersal.mixed.list[[regions.vec[i]]]<-get.mixed.index(region=regions.vec[i], category="Demersal", min.year=1970, brp=FALSE)
}

## All, Pelagic, Demersal over all regions
all.category.vec<-c("All", "Pelagic", "Demersal")
## brp
brp.all.mixed.list<-list()
for(i in 1:length(all.category.vec)){
  print(i)
  brp.all.mixed.list[[all.category.vec[i]]]<-get.mixed.index(region="All", category=all.category.vec[i], min.year=1970, brp=TRUE)
}

## orig
orig.all.mixed.list<-list()
for(i in 1:length(all.category.vec)){
  print(i)
  orig.all.mixed.list[[all.category.vec[i]]]<-get.mixed.index(region="All", category=all.category.vec[i], min.year=1970, brp=FALSE)
}

##-----------
## Plotting
##-----------
## consider placing this code in the functions file and adding an argument for brp or not
## Dan to change filepath here for calo
## brp
 ## Dan to change this directory
#png("/Users/mintoc/docs/analyses/sr/baumhutchings/tex/DRAFT2/figures/CJFAS-shortcomm-fig2_brp_v2.png", width=5.5,height=7.5, res=100,units="in")
pdf("CJFAS-shortcomm-fig2-BRPratio-1010.pdf",title='CJFAS-fig2-BRPratio')

par(mfrow=c(4,2), mar=c(0,0,0,0), oma=c(4,4,2,2), las=1)
## All
plot.poly.base.func(region="All", category="All", ylim=c(0,2.0), xlim=c(1970,2010), yaxt="n", xaxt="n", brp=TRUE)
plot.poly.trend.func(region="All", category="All", brp=TRUE, ylim=c(0,2))
abline(h=1, lty=2)
## All by category
plot.poly.base.func(region="All", category="Both", ylim=c(0,2.0), xlim=c(1970,2010), yaxt="n", xaxt="n", brp=TRUE)
plot.poly.trend.func(region="All", category="Both", brp=TRUE, ylim=c(0,2))
abline(h=1, lty=2)
## Region by category
plot.regions.vec<-c("NWAtl","NEPac","HighSeas")
ylim.upr<-4
for(i in 1:length(plot.regions.vec)){
  ## setup plotting region
  ## find out if i is odd (TRUE) or even (FALSE)
  index<-i/2-i-as.integer(i/2-i)!=0
    if(i>4){
      if(index){
        plot.poly.base.func(region=plot.regions.vec[i], category="Pelagic", ylim=c(0,ylim.upr), xlim=c(1970,2010), yaxt="s", xaxt="s", brp=TRUE)
      }else{
        plot.poly.base.func(region=plot.regions.vec[i], category="Pelagic", ylim=c(0,ylim.upr), xlim=c(1970,2010), yaxt="n", xaxt="n", brp=TRUE)
        axis(side=1,at=seq(1980,2010, by=10), cex.axis=1.2)
      }}else{
        if(index){
        plot.poly.base.func(region=plot.regions.vec[i], category="Pelagic", ylim=c(0,ylim.upr), xlim=c(1970,2010), yaxt="s", xaxt="n", brp=TRUE)
      }else{
        plot.poly.base.func(region=plot.regions.vec[i], category="Pelagic", ylim=c(0,ylim.upr), xlim=c(1970,2010), yaxt="n", xaxt="n", brp=TRUE)
      }
      }
  ## plot the trends
  plot.poly.trend.func(region=plot.regions.vec[i], category="Pelagic", ylim=c(0,ylim.upr))
  plot.poly.trend.func(region=plot.regions.vec[i], category="Demersal", ylim=c(0,ylim.upr))
  abline(h=1, lty=2)
}
par(las=0)
mtext(side=1, text="Year", cex=1.1, line=2.5, outer=TRUE)
mtext(side=2, text= "Relative biomass", cex=1.1, line=2.25, outer=TRUE)
dev.off()

## orig
#png("/Users/mintoc/docs/analyses/sr/baumhutchings/tex/DRAFT2/figures/CJFAS-shortcomm-fig2_orig_v1.png", width=5,height=7, res=600,units="in")
pdf("CJFAS-shortcomm-fig2-orig-1010.pdf",title='CJFAS-fig2-orig')
par(mfrow=c(4,2), mar=c(0,0,0,0), oma=c(4,4.5,2,2), las=1)
## All
plot.poly.base.func(region="All", category="All", ylim=c(-1.0,1.0), xlim=c(1970,2010), yaxt="n", xaxt="n", brp=FALSE)
plot.poly.trend.func(region="All", category="All", brp=FALSE, ylim=c(-1.0,1.0))
## All by category
plot.poly.base.func(region="All", category="Both", ylim=c(-1.0,1.0), xlim=c(1970,2010), yaxt="n", xaxt="n", brp=FALSE)
plot.poly.trend.func(region="All", category="Both", ylim=c(-1.0,1.0), brp=FALSE)
## Region by category
plot.regions.vec<-c("NWAtl", "NEPac", "HighSeas")
for(i in 1:length(plot.regions.vec)){
  ## setup plotting region
  ## find out if i is odd (TRUE) or even (FALSE)
  index<-i/2-i-as.integer(i/2-i)!=0
    if(i>4){
      if(index){
        plot.poly.base.func(region=plot.regions.vec[i], category="Pelagic", ylim=c(-1.0,1.0), xlim=c(1970,2010), yaxt="s", xaxt="s", brp=FALSE)
      }else{
        plot.poly.base.func(region=plot.regions.vec[i], category="Pelagic", ylim=c(-1.0,1.0), xlim=c(1970,2010), yaxt="n", xaxt="n", brp=FALSE)
        axis(side=1,at=seq(1980,2010, by=10), cex.axis=1.2)
      }}else{
        if(index){
        plot.poly.base.func(region=plot.regions.vec[i], category="Pelagic", ylim=c(-1.0,1.0), xlim=c(1970,2010), yaxt="s", xaxt="n", brp=FALSE)
      }else{
        plot.poly.base.func(region=plot.regions.vec[i], category="Pelagic", ylim=c(-1.0,1.0), xlim=c(1970,2010), yaxt="n", xaxt="n", brp=FALSE)
      }
      }
  ## plot the trends
  plot.poly.trend.func(region=plot.regions.vec[i], category="Pelagic", brp=FALSE, ylim=c(-1.0,1.0))
  plot.poly.trend.func(region=plot.regions.vec[i], category="Demersal", brp=FALSE, ylim=c(-1.0,1.0))  
}
par(las=0)
mtext(side=1, text="Year", cex=1.1, line=2.5, outer=TRUE)
mtext(side=2, text= "Relative SSB", cex=1.1, line=2.75, outer=TRUE)
dev.off()

##-------------------
## PERCENTAGE CHANGE
##-------------------
taxo.category.vec<-c("Pelagic", "Demersal")
## all regions, all categories
## brp
brp.percent.change.df<-data.frame(t(extract.percentage.change(region="All", category="All", n.years=5, brp=TRUE)))
## all regions by category
for(i in 1: length(taxo.category.vec)){
  brp.percent.change.df<-rbind(brp.percent.change.df,
  data.frame(t(extract.percentage.change(region="All", category=taxo.category.vec[i], n.years=5, brp=TRUE))))
}
## region by category
for(i in 1:length(regions.vec)){
  print(i)
  for(j in 1:length(taxo.category.vec)){
    brp.percent.change.df<-rbind(brp.percent.change.df,
    data.frame(t(extract.percentage.change(region=regions.vec[i], category=taxo.category.vec[j], n.years=5, brp=TRUE))))
  }}
names(brp.percent.change.df)<-c("region", "category", "n","index.start", "index.end", "percent.decline")
## Dan to change this output directory
##write.csv(brp.percent.change.df, file="../../data/CJFAS-shortcomm-fig2-brp-percent-change.csv", row.names=FALSE)
write.csv(brp.percent.change.df, file="./CJFAS-shortcomm-fig2-brp-percent-change.csv", row.names=FALSE)


## orig
orig.percent.change.df<-data.frame(t(extract.percentage.change(region="All", category="All", n.years=5, brp=FALSE)))
## all regions by category
for(i in 1: length(taxo.category.vec)){
  orig.percent.change.df<-rbind(orig.percent.change.df,
  data.frame(t(extract.percentage.change(region="All", category=taxo.category.vec[i], n.years=5, brp=FALSE))))
}
## region by category
for(i in 1:length(regions.vec)){
  print(i)
  for(j in 1:length(taxo.category.vec)){
    orig.percent.change.df<-rbind(orig.percent.change.df,
    data.frame(t(extract.percentage.change(region=regions.vec[i], category=taxo.category.vec[j], n.years=5, brp=FALSE))))
  }}
names(orig.percent.change.df)<-c("region", "category", "n","index.start", "index.end", "percent.decline")
## Dan to change this output directory
#write.csv(orig.percent.change.df, file="../../data/CJFAS-shortcomm-fig2-orig-percent-change.csv", row.names=FALSE)
write.csv(orig.percent.change.df, file="./CJFAS-shortcomm-fig2-orig-percent-change.csv", row.names=FALSE)
#q("yes")

##--------
