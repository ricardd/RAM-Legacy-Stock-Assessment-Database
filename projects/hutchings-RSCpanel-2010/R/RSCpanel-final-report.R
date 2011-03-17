## R code to generate the plots requestesd by Jeff Hutchings for the final report of his Royal Society of Canada expert panel
## Last modified Time-stamp: <2011-03-17 00:04:51 (srdbadmin)>
##
##
## plots requested:

## 1 - plots of SSB vs. time for stocks relevant to Canada
## done

## 2 - plots as per Fig. 2 of the 2010 CJFAS short communication but just for DFO, and breaking down the East Coast and the West Coast
##

## 3 - beanplots of B/Bmsy for different management bodies (DFO, NMFS, ICES)
## done for assessment-derived reference points

## tables requested

## 1 - list of stocks, scientific name, management body, assessor, Large Marine Ecosystem
## done

## the list of assessments that we have and that are deemed relevant for the RSC panel report is handled by the SQL file located at ../SQL/Canada-stocks.sql

## rm(list=ls(all=TRUE))

require(RODBC)
require(beanplot)
require(xtable)

## stocks of interest
##  -F \"\t\"
my.assessments <- strsplit(system("psql srdb -f ../SQL/Canada-stocks.sql -A -t", intern=TRUE, ignore.stdout=FALSE, ignore.stderr=TRUE, wait=FALSE),"[|]")

# turn into a data frame
tt.dat <- as.data.frame(matrix(unlist(my.assessments),ncol=length(my.assessments[[1]]),byrow=TRUE))
names(tt.dat) <- c("assessid","rec","stockid","stock","sciname","years","assessor","mgmt","LME")
table.dat<-data.frame(stock=tt.dat$stock,species=tt.dat$sciname,mgmt=tt.dat$mgmt,years=tt.dat$years,LME=tt.dat$LME)

## write to a LaTeX table
my.caption <- c("Stocks present in the RAM Legacy database that inhabit Canadian waters and are of national relevance.")
  my.table <- xtable(table.dat, caption=my.caption, label=c("tab:crosshair"), digits=2, align="p{6.5cm}p{4cm}p{3.5cm}ccp{5.5cm}")
  print(my.table, type="latex", file="../tex//Table.tex", include.rownames=FALSE, floating=FALSE, tabular.environment="longtable", caption.placement="bottom", sanitize.text.function=I)


ll <- dim(tt.dat)[1]

chan<-odbcConnect(dsn='srdbcalo')

pdf("RSC-report-plots.pdf",width=11/1.6,height=11,title="Timeseries plots for RSC expert panel report")

par(mfrow=c(3,2))
## loop over assessments and plot SSB and catch/landings vs time for each

for (i in 1:ll){
par(mar=c(4,3,2,4),new=FALSE)
my.aid <- tt.dat$assessid[i]
my.stock <- tt.dat$stock[i]
print(paste(i, my.stock,sep="  "))
qu <- paste("select * from srdb.timeseries_values_view where assessid='",my.aid,"'",sep="")
my.ts <- sqlQuery(chan,qu,stringsAsFactors=FALSE)

qu <- paste("select * from srdb.timeseries_units_view where assessid='",my.aid,"'",sep="")
my.tsu <- sqlQuery(chan,qu,stringsAsFactors=FALSE)

## what's available?
sum.dat.rows<-apply(my.ts[,4:length(my.ts[1,])],2,FUN=function(x){sum(as.numeric(x), na.rm=TRUE)})
sum.dat.rows[sum.dat.rows>0]
avail.series<-names(sum.dat.rows[sum.dat.rows>0])

## CASE 1
## SSB, TB and catch are available
if("ssb"%in%avail.series & "catch_landings"%in%avail.series & "total"%in%avail.series)
  {
    my.ssb.ylab <- paste("biomass (",my.tsu$ssb_unit,")",sep="")
    my.ssb.ylab.l <- paste("SSB (",my.tsu$ssb_unit,")",sep="")
    my.tb.ylab.l <- paste("TB (",my.tsu$total_unit,")",sep="")
    
  my.ylim<-c(range(na.omit(c(my.ts$ssb,my.ts$total)))[1],range(na.omit(c(my.ts$ssb,my.ts$total)))[2]*1.15)
plot(ssb~tsyear,data=my.ts, xlab="Year",ylab="",axes=FALSE,type='b',lwd=2,pch=19,lty=1,ylim=my.ylim)
title(my.stock,cex=0.75)
axis(side=1)
axis(side=2)
mtext(side=2,my.ssb.ylab,line=2)
lines(total~tsyear,data=my.ts, xlab="",ylab="",type='b',lwd=4,pch=19,lty=1,ylim=my.ylim)

par(new=TRUE)
my.c.ylab <- paste("Catch (",my.tsu$catch_landings_unit,")",sep="")
  my.ylim<-c(range(na.omit(my.ts$catch_landings))[1],range(na.omit(my.ts$catch_landings))[2]*1.15)
plot(catch_landings~tsyear,data=my.ts,xlab="",ylab="",axes=FALSE, type='b', pch=1, lty=2, lwd=2, col=grey(0.5),ylim=my.ylim)
axis(side=4)
mtext(side=4,my.c.ylab,line=2)
legend('topright',c(my.tb.ylab.l,my.ssb.ylab.l,my.c.ylab),pch=c(19,19,1),lty=c(1,1,2),col=c('black','black',grey(0.5)),lwd=c(4,2,2))
}

## CASE 2
## SSB and TB are available, catch is not available
if("ssb"%in%avail.series & !"catch_landings"%in%avail.series & !"total"%in%avail.series)
  {
    my.ssb.ylab <- paste("biomass (",my.tsu$ssb_unit,")",sep="")
    my.ssb.ylab.l <- paste("SSB (",my.tsu$ssb_unit,")",sep="")
    my.tb.ylab.l <- paste("TB (",my.tsu$total_unit,")",sep="")
  my.ylim<-c(range(na.omit(c(my.ts$ssb,my.ts$total)))[1],range(na.omit(c(my.ts$ssb,my.ts$total)))[2]*1.15)
plot(ssb~tsyear,data=my.ts, xlab="Year",ylab="",axes=FALSE,type='b',lwd=2,pch=19,lty=1,ylim=my.ylim)
lines(total~tsyear,data=my.ts, xlab="",ylab="",type='b',lwd=4,pch=19,lty=1,ylim=my.ylim)
title(my.stock,cex=0.75)
axis(side=1)
axis(side=2)
mtext(side=2,my.ssb.ylab,line=2)
legend('topright',c(my.tb.ylab.l,my.ssb.ylab.l),pch=c(19,19),lty=c(1,1),col=c('black','black'),lwd=c(4,2))
}

## CASE 3
## SSB and catch are available, TB is not available
if("ssb"%in%avail.series & "catch_landings"%in%avail.series & !"total"%in%avail.series)
  {
  my.ssb.ylab <- paste("biomass (",my.tsu$ssb_unit,")",sep="")
  my.ssb.ylab.l <- paste("SSB (",my.tsu$ssb_unit,")",sep="")
  my.ylim<-c(range(na.omit(my.ts$ssb))[1],range(na.omit(my.ts$ssb))[2]*1.15)
plot(ssb~tsyear,data=my.ts, xlab="Year",ylab="",axes=FALSE,type='b',lwd=2,pch=19,lty=1,ylim=my.ylim)
title(my.stock,cex=0.75)
axis(side=1)
axis(side=2)
mtext(side=2,my.ssb.ylab,line=2)

par(new=TRUE)
my.c.ylab <- paste("Catch (",my.tsu$catch_landings_unit,")",sep="")
  my.ylim<-c(range(na.omit(my.ts$catch_landings))[1],range(na.omit(my.ts$catch_landings))[2]*1.15)
plot(catch_landings~tsyear,data=my.ts,xlab="",ylab="",axes=FALSE, type='b', pch=1, lty=2, lwd=2, col=grey(0.5),ylim=my.ylim)
axis(side=4)
mtext(side=4,my.c.ylab,line=2)
legend('topright',c(my.ssb.ylab.l,my.c.ylab),pch=c(19,1),lty=c(1,2),col=c('black',grey(0.5)),lwd=c(2,2))
}
## CASE 4
## TB and catch are available, SSB is not available
if(!"ssb"%in%avail.series & "catch_landings"%in%avail.series & "total"%in%avail.series)
  {
    my.tb.ylab <- paste("biomass (",my.tsu$total_unit,")",sep="")
    my.tb.ylab.l <- paste("TB (",my.tsu$total_unit,")",sep="")
    
  my.ylim<-c(range(na.omit(my.ts$total))[1],range(na.omit(my.ts$total))[2]*1.15)
plot(total~tsyear,data=my.ts, xlab="Year",ylab="",axes=FALSE,type='b',lwd=4,pch=19,lty=1,ylim=my.ylim)
title(my.stock,cex=0.75)
axis(side=1)
axis(side=2)
mtext(side=2,my.ssb.ylab,line=2)

par(new=TRUE)
my.c.ylab <- paste("Catch (",my.tsu$catch_landings_unit,")",sep="")
  my.ylim<-c(range(na.omit(my.ts$catch_landings))[1],range(na.omit(my.ts$catch_landings))[2]*1.15)
plot(catch_landings~tsyear,data=my.ts,xlab="",ylab="",axes=FALSE, type='b', pch=1, lty=2, lwd=2, col=grey(0.5),ylim=my.ylim)
axis(side=4)
mtext(side=4,my.c.ylab,line=2)
legend('topright',c(my.tb.ylab.l,my.c.ylab),pch=c(19,1),lty=c(1,2),col=c('black',grey(0.5)),lwd=c(4,2))
}

## CASE 5
## only SSB is available
if("ssb"%in%avail.series & !"catch_landings"%in%avail.series & !"total"%in%avail.series)
  {
  my.ssb.ylab <- paste("biomass (",my.tsu$ssb_unit,")",sep="")
  my.ssb.ylab.l <- paste("SSB (",my.tsu$ssb_unit,")",sep="")
  my.ylim<-c(range(na.omit(my.ts$ssb))[1],range(na.omit(my.ts$ssb))[2]*1.15)
plot(ssb~tsyear,data=my.ts, xlab="Year",ylab="",axes=FALSE,type='b',lwd=2,pch=19,lty=1,ylim=my.ylim)
title(my.stock,cex=0.75)
axis(side=1)
axis(side=2)
mtext(side=2,my.ssb.ylab,line=2)
legend('topright',c(my.ssb.l.ylab),pch=c(19),lty=c(1),col=c('black'),lwd=c(2))
}

## CASE 6
## only TB is available
if(!"ssb"%in%avail.series & !"catch_landings"%in%avail.series & "total"%in%avail.series)
  {
    my.tb.ylab <- paste("biomass (",my.tsu$total_unit,")",sep="")
    my.tb.ylab.l <- paste("TB (",my.tsu$total_unit,")",sep="")
  my.ylim<-c(range(na.omit(my.ts$total))[1],range(na.omit(my.ts$total))[2]*1.15)
plot(total~tsyear,data=my.ts, xlab="Year",ylab="",axes=FALSE,type='b',lwd=4,pch=19,lty=1,ylim=my.ylim)
title(my.stock,cex=0.75)
axis(side=1)
axis(side=2)
mtext(side=2,my.ssb.ylab,line=2)
legend('topright',c(my.tb.ylab.l),pch=c(19),lty=c(1),col=c('black'),lwd=c(4))
}

## CASE 7
## only catch is available
if(!"ssb"%in%avail.series & "catch_landings"%in%avail.series & !"total"%in%avail.series)
  {  nn <- length(my.ts$tsyear)
plot(rep(-1,nn)~tsyear,data=my.ts, xlab="Year",ylab="",axes=FALSE,type='b',lwd=2,pch=19,lty=1,ylim=c(0,0.1))
title(my.stock,cex=0.75)
axis(side=1)
#axis(side=2)
#mtext(side=2,my.ssb.ylab,line=2)
par(new=TRUE)
my.c.ylab <- paste("Catch (",my.tsu$catch_landings_unit,")",sep="")
  my.ylim<-c(range(na.omit(my.ts$catch_landings))[1],range(na.omit(my.ts$catch_landings))[2]*1.15)
plot(catch_landings~tsyear,data=my.ts,xlab="",ylab="",axes=FALSE, type='b', pch=1, lty=2, lwd=2, col=grey(0.5),ylim=my.ylim)
axis(side=4)
mtext(side=4,my.c.ylab,line=2)
legend('topright',c(my.c.ylab),pch=c(1),lty=c(2),col=c(grey(0.5)),lwd=c(2))
}

## CASE 8
## nothing is available
if(!"ssb"%in%avail.series & !"catch_landings"%in%avail.series & !"total"%in%avail.series)
  {
  plot(1, type="n", axes=FALSE,xlab="", ylab="")
title(my.stock,cex=0.75)
legend("center", legend="No SSB, TB or catch \n available", bty="n", cex=1.1)
}


} ## end loop over assessments

dev.off()

#######
## beanplot of SSB/SSBmsy for different management bodies
#######
## first, get assessment-derived BRPs
qu <- paste("select 'pepper' as fromassessment, m.mgmt, b.assessid, tvr.bioid, tvr.biovalue, tvr.tsid, tvr.tsvalue, tvr.tsyear, tvr.tstobrpratio as ratio from (select assessid, max(tsyear) as maxyr from srdb.tsrelative_explicit_view where bioid like 'SSBmsy%' group by assessid) as b, srdb.assessment aa, srdb.tsrelative_explicit_view tvr, srdb.management m, srdb.assessor a where aa.assessorid=a.assessorid and a.mgmt=m.mgmt and aa.assessid = tvr.assessid and b.assessid = tvr.assessid and tvr.tsyear=b.maxyr and bioid like 'SSBmsy%' order by mgmt",sep="")

bean.dat <- sqlQuery(chan,qu,stringsAsFactors=FALSE)


## mean value for each management body
bean.mean<-tapply(log(bean.dat$ratio),bean.dat$mgmt,mean)
## order by mean value
bean.new <- data.frame(mgmt=names(bean.mean)[order(bean.mean)],norder=seq(1:length(bean.mean)))
## add the rank to the data frame
bean.merged <- merge(bean.dat,bean.new,by="mgmt")


## second, get ratios from Schaefer models
qu <- paste("select 'salt' as fromassessment,  m.mgmt, b.assessid, 'Schaefer-derived Bmsy' as bioid, sp.bmsy as biovalue, 'TB-' || tsu.total_unit as tsid, tsv.total as tsvalue, b.tsyear, tsv.total/sp.bmsy as ratio from srdb.spfits_schaefer sp, srdb.timeseries_values_view tsv, srdb.timeseries_units_view tsu, (select assessid, max(tsyear) as tsyear from srdb.timeseries_values_view where total is not null group by assessid) b, srdb.management m, srdb.assessor a, srdb.assessment aa where tsv.assessid=tsu.assessid and a.assessorid=aa.assessorid and a.mgmt=m.mgmt and aa.assessid=b.assessid and b.assessid=tsv.assessid and b.tsyear=tsv.tsyear and b.assessid=sp.assessid order by mgmt",sep="")

bean.dat.sp <- sqlQuery(chan,qu,stringsAsFactors=FALSE)

##
bean.mean.sp<-tapply(log(bean.dat.sp$ratio),bean.dat.sp$mgmt,mean)
bean.new.sp <- data.frame(mgmt=names(bean.mean.sp)[order(bean.mean.sp)],norder=seq(1:length(bean.mean.sp)))

bean.merged.sp <- merge(bean.dat.sp,bean.new.sp,by="mgmt")


## third, merge the two

temp.all <- rbind(bean.merged, bean.merged.sp)
oo <- order(temp.all$assessid)
bean.merged.all <- temp.all[oo,]
##  and preferentially keep the assessment-derived BRP
oo<- unlist(tapply(bean.merged.all$assessid,bean.merged.all$assessid,order))
bfp <- bean.merged.all[oo==1,]

## remove management bodies with less than 5 stocks
num.a.mgmt <- table(bfp$mgmt)
mgmt.keep <- num.a.mgmt>=5

# again, a manual hack job here
bean.for.plot <- subset(bfp,mgmt!='CCSBT' & mgmt!='IATTC' & mgmt!='IOTC' & mgmt!='SPRFMO' & mgmt!='US State')

## order the management bodies based on their mean value for ratio
## mean value for each management body
rank.all <-tapply(log(bean.for.plot$ratio),bean.for.plot$mgmt,mean)
mgmt.rank <- data.frame(mgmt=names(rank.all)[order(rank.all)],norderall=seq(1:length(rank.all)))


## add the rank to the data frame
bean.for.plot <- merge(bean.for.plot,mgmt.rank,by="mgmt")

all.dat <- bean.for.plot
all.dat$rankall <- as.numeric(all.dat$norderall)
pepper.dat <- subset(all.dat,fromassessment=='pepper')
salt.dat <- subset(all.dat,fromassessment=='salt')


## manual hack job to add zeroes
##
miss.sp <- c(4,5,10)
ll.sp <- length(miss.sp)
missing.sp <- data.frame(mgmt=rep('blah',ll.sp),fromassessment=rep('salt',ll.sp),assessid=rep('blah',ll.sp),bioid=rep('blah',ll.sp),biovalue=rep(-99,ll.sp),tsid=rep('blah',ll.sp),tsvalue=rep(-99,ll.sp),tsyear=rep(-99,ll.sp),ratio=rep(1E06,ll.sp),norder=rep(-99,ll.sp),norderall=miss.sp,rankall=as.numeric(miss.sp))


miss.a <- c(1,2,3,7)
ll.a <- length(miss.a)
missing.a <- data.frame(mgmt=rep('blah',ll.a),fromassessment=rep('pepper',ll.a),assessid=rep('blah',ll.a),bioid=rep('blah',ll.a),biovalue=rep(-99,ll.a),tsid=rep('blah',ll.a),tsvalue=rep(-99,ll.a),tsyear=rep(-99,ll.a),ratio=rep(1E06,ll.a),norder=rep(-99,ll.a),norderall=miss.a,rankall=as.numeric(miss.a))

salt.dat <- rbind(salt.dat,missing.sp)
pepper.dat <- rbind(pepper.dat,missing.a)

my.ylim <- c(0.01,11)

pdf("bean-brp-3panel.pdf",width=11/1.6, height=11,title="Beanplots for RSC expert panel report")
par(mfrow=c(3,1))

par(mar=c(1,5,1,1),oma=c(1,1,1,1))

#beanplot(count ~ spray, data = InsectSprays,side = "second",col = list(c("#ffffff", "#00000080", "#00000080", "#5f5f5f")), border = list("#767676"), innerborder = "#767676", beanlinewd = 1.7, what = c(0, 1, 1, 1),method = "jitter", axes = F);axis(1);axis(2)

beanplot.panel1 <- beanplot(ratio~rankall,data=all.dat,horizontal=FALSE,xlab="",col = list(c("#ffffff", "#00000080", "#00000080", "#5f5f5f")), border = list("#767676"), innerborder = "#767676", beanlinewd = 1.7, what=c(0,1,1,1),kernel='rectangular',ylim=my.ylim,log='y',show.names=FALSE,bw=0.4,beanlines='mean',side = "second")#,side = "second"

         # col = c(gray(0.7),"white","black",gray(0.1)), show.names=FALSE,beanlines='mean',what=c(0,1,1,1),ylim=my.ylim,log='y',kernel="rectangular")
nn <- dim(all.dat)[1]
text(1,9.5,paste("all BRPs"," (n=",nn,")",sep=""),adj=c(0,0))
abline(h=1,col=grey(0.5),lty=1,lwd=0.75)
abline(v=c(2.5,4.5,6.5,8.5),lty=2,lwd=0.5,col=grey(0.5))


beanplot.panel2 <- beanplot(ratio~rankall,data=pepper.dat,horizontal=FALSE,xlab="",col = list(c("#ffffff", "#00000080", "#00000080", "#5f5f5f")), border = list("#767676"), innerborder = "#767676", beanlinewd = 1.7, what=c(0,1,1,1),kernel='rectangular',ylim=my.ylim,log='y',show.names=FALSE,bw=0.4,beanlines='mean',side = "second")#,side = "second"
#,horizontal=FALSE,xlab="",col = c(gray(0.7),"white","black",gray(0.1)), show.names=FALSE,beanlines='mean',what=c(0,1,1,1),ylim=my.ylim,log='y',kernel="rectangular")
nn <- dim(pepper.dat)[1] - ll.a
text(1,9.5,paste("BRPs from assessment"," (n=",nn,")",sep=""),adj=c(0,0))
abline(h=1,col=grey(0.5),lty=1,lwd=0.75)
abline(v=c(2.5,4.5,6.5,8.5),lty=2,lwd=0.5,col=grey(0.5))

mtext(side=2,c("B/Bmsy"),line=4,las=3)

par(mar=c(4,5,1,1),oma=c(1,1,1,1),new=TRUE)
beanplot.panel3 <- beanplot(ratio~rankall,data=salt.dat,horizontal=FALSE,xlab="",col = list(c("#ffffff", "#00000080", "#00000080", "#5f5f5f")), border = list("#767676"), innerborder = "#767676", beanlinewd = 1.7, what=c(0,1,1,1),kernel='rectangular',ylim=my.ylim,log='y',show.names=FALSE,bw=0.4,beanlines='mean',side = "second")#
#,horizontal=FALSE,xlab="",col = c(gray(0.7),"white","black",gray(0.1)), show.names=FALSE,beanlines='mean',what=c(0,1,1,1),ylim=my.ylim,log='y',kernel="rectangular")
nn <- dim(salt.dat)[1] - ll.sp
text(1,9.5,paste("BRPs from Schaefer model"," (n=",nn,")",sep=""),adj=c(0,0))
abline(h=1,col=grey(0.5),lty=1,lwd=0.75)
abline(v=c(2.5,4.5,6.5,8.5),lty=2,lwd=0.5,col=grey(0.5))

par(las=3)
mtext(mgmt.rank[1,1], side=1, outer = FALSE, line=1,at=1, cex=0.5)
mtext(mgmt.rank[2,1], side=1, outer = FALSE, line=1,at=2, cex=0.5)
mtext(mgmt.rank[3,1], side=1, outer = FALSE, line=1,at=3, cex=0.5)
mtext(mgmt.rank[4,1], side=1, outer = FALSE, line=1,at=4, cex=0.5)
mtext(mgmt.rank[5,1], side=1, outer = FALSE, line=1,at=5, cex=0.5)
mtext(mgmt.rank[6,1], side=1, outer = FALSE, line=1,at=6, cex=0.5)
mtext(mgmt.rank[7,1], side=1, outer = FALSE, line=1,at=7, cex=0.5)
mtext(mgmt.rank[8,1], side=1, outer = FALSE, line=1,at=8, cex=0.5)
mtext(mgmt.rank[9,1], side=1, outer = FALSE, line=1,at=9, cex=0.5)
mtext(mgmt.rank[10,1], side=1, outer = FALSE, line=1,at=10, cex=0.5)
mtext(mgmt.rank[11,1], side=1, outer = FALSE, line=1,at=11, cex=0.5)
mtext(mgmt.rank[12,1], side=1, outer = FALSE, line=1,at=12, cex=0.5)
mtext(mgmt.rank[13,1], side=1, outer = FALSE, line=1,at=13, cex=0.5)
mtext(mgmt.rank[14,1], side=1, outer = FALSE, line=1,at=14, cex=0.5)
mtext(mgmt.rank[15,1], side=1, outer = FALSE, line=1,at=15, cex=0.5)

par(las=1)
mtext(side=1,c("Management body"),line=4)
dev.off()

odbcClose(chan)



#par(mfrow=c(4,1))
#beanplot(ratio~rankall,data=all.dat,horizontal=FALSE,xlab="",col = c(gray(0.7),"white","black",gray(0.1)), show.names=FALSE,beanlines='mean',what=c(0,1,1,1),ylim=my.ylim,log='y',kernel="gaussian")

#beanplot(ratio~rankall,data=all.dat,horizontal=FALSE,xlab="",col = c(gray(0.7),"white","black",gray(0.1)), show.names=FALSE,beanlines='mean',what=c(0,1,1,1),ylim=my.ylim,log='y',kernel="triangular")

#beanplot(ratio~rankall,data=all.dat,horizontal=FALSE,xlab="",col = c(gray(0.7),"white","black",gray(0.1)), show.names=FALSE,beanlines='mean',what=c(0,1,1,1),ylim=my.ylim,log='y',kernel="rectangular")

#beanplot(ratio~rankall,data=all.dat,horizontal=FALSE,xlab="",col = c(gray(0.7),"white","black",gray(0.1)), show.names=FALSE,beanlines='mean',what=c(0,1,1,1),ylim=my.ylim,log='y',kernel="epanechnikov")

