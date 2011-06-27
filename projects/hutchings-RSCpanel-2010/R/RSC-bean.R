
require(RODBC)
require(beanplot)
chan<-odbcConnect(dsn='srdbcalo')

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

## on the first panel, i.e. all assessments
pdf("bean-brp-all.pdf",width=11, height=11/1.6,title="Beanplots for RSC expert panel report")
par(mar=c(5,5,1,1),oma=c(1,1,1,1))


beanplot.panel1 <- beanplot(ratio~rankall,data=all.dat,horizontal=FALSE,xlab="",col = list(c("#ffffff", "#00000080", "#00000080", "#5f5f5f")), border = list("#767676"), innerborder = "#767676", beanlinewd = 1.7, what=c(0,1,1,1),kernel='rectangular',ylim=my.ylim,log='y',show.names=FALSE,bw=0.4,beanlines='mean',side = "second")#,side = "second"

## rank.all and mgmt.rank are already available, but still need the value of mean(log(ratio)) for each mgmt
n.by.mgmt <- as.data.frame(table(all.dat$mgmt))
names(n.by.mgmt) <- c("mgmt","nn")
my.temp <- merge(n.by.mgmt, mgmt.rank, by="mgmt")
mgmt.mean <- data.frame(mgmt=unique(all.dat$mgmt), mean=tapply(log(all.dat$ratio), all.dat$mgmt, mean))
mgmt.mean.o <- merge(my.temp, mgmt.mean, by = "mgmt")
oo <- order(mgmt.mean.o$norderall)
mgmt.mean.oo <- mgmt.mean.o[oo,]

for (i in 1:dim(mgmt.mean.oo)[1]){
xx <- mgmt.mean.oo$norderall[i]+0.3
text(xx,exp(mgmt.mean.oo$mean[i])*1.15,paste("n=",mgmt.mean.oo$nn[i]),cex=0.6)
}

nn <- dim(all.dat)[1]
text(1,9.5,paste("all BRPs"," (n=",nn,")",sep=""),adj=c(0,0))
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

mtext(side=2,c("B/Bmsy"),line=4,las=3)

dev.off()

pdf("bean-brp-3panel.pdf",width=11/1.6, height=11,title="Beanplots for RSC expert panel report")
par(mfrow=c(3,1))

par(mar=c(1,5,1,1),oma=c(1,1,1,1))

#beanplot(count ~ spray, data = InsectSprays,side = "second",col = list(c("#ffffff", "#00000080", "#00000080", "#5f5f5f")), border = list("#767676"), innerborder = "#767676", beanlinewd = 1.7, what = c(0, 1, 1, 1),method = "jitter", axes = F);axis(1);axis(2)

beanplot.panel1 <- beanplot(ratio~rankall,data=all.dat,horizontal=FALSE,xlab="",col = list(c("#ffffff", "#00000080", "#00000080", "#5f5f5f")), border = list("#767676"), innerborder = "#767676", beanlinewd = 1.7, what=c(0,1,1,1),kernel='rectangular',ylim=my.ylim,log='y',show.names=FALSE,bw=0.4,beanlines='mean',side = "second")#,side = "second"

## rank.all and mgmt.rank are already available, but still need the value of mean(log(ratio)) for each mgmt
n.by.mgmt <- as.data.frame(table(all.dat$mgmt))
names(n.by.mgmt) <- c("mgmt","nn")
my.temp <- merge(n.by.mgmt, mgmt.rank, by="mgmt")
mgmt.mean <- data.frame(mgmt=unique(all.dat$mgmt), mean=tapply(log(all.dat$ratio), all.dat$mgmt, mean))
mgmt.mean.o <- merge(my.temp, mgmt.mean, by = "mgmt")
oo <- order(mgmt.mean.o$norderall)
mgmt.mean.oo <- mgmt.mean.o[oo,]

for (i in 1:dim(mgmt.mean.oo)[1]){
xx <- mgmt.mean.oo$norderall[i]+0.3
text(xx,exp(mgmt.mean.oo$mean[i])*1.15,paste("n=",mgmt.mean.oo$nn[i]),cex=0.6)
}

nn <- dim(all.dat)[1]
text(1,9.5,paste("all BRPs"," (n=",nn,")",sep=""),adj=c(0,0))
abline(h=1,col=grey(0.5),lty=1,lwd=0.75)
abline(v=c(2.5,4.5,6.5,8.5),lty=2,lwd=0.5,col=grey(0.5))


beanplot.panel2 <- beanplot(ratio~rankall,data=pepper.dat,horizontal=FALSE,xlab="",col = list(c("#ffffff", "#00000080", "#00000080", "#5f5f5f")), border = list("#767676"), innerborder = "#767676", beanlinewd = 1.7, what=c(0,1,1,1),kernel='rectangular',ylim=my.ylim,log='y',show.names=FALSE,bw=0.4,beanlines='mean',side = "second")

## rank.all and mgmt.rank are already available, but still need the value of mean(log(ratio)) for each mgmt
n.by.mgmt <- as.data.frame(table(pepper.dat$mgmt))
names(n.by.mgmt) <- c("mgmt","nn")
my.temp <- merge(n.by.mgmt, mgmt.rank, by="mgmt")
my.tt <- tapply(log(pepper.dat$ratio), pepper.dat$mgmt, mean)
mgmt.mean <- data.frame(mgmt=names(my.tt), mean=my.tt)
mgmt.mean.o <- merge(my.temp, mgmt.mean, by = "mgmt")
oo <- order(mgmt.mean.o$norderall)
mgmt.mean.oo <- mgmt.mean.o[oo,]

for (i in 1:dim(mgmt.mean.oo)[1]){
xx <- mgmt.mean.oo$norderall[i]+0.3
text(xx,exp(mgmt.mean.oo$mean[i])*1.15,paste("n=",mgmt.mean.oo$nn[i]),cex=0.6)
}

nn <- dim(pepper.dat)[1] - ll.a
text(1,9.5,paste("BRPs from assessment"," (n=",nn,")",sep=""),adj=c(0,0))
abline(h=1,col=grey(0.5),lty=1,lwd=0.75)
abline(v=c(2.5,4.5,6.5,8.5),lty=2,lwd=0.5,col=grey(0.5))

mtext(side=2,c("B/Bmsy"),line=4,las=3)

par(mar=c(4,5,1,1),oma=c(1,1,1,1),new=TRUE)
beanplot.panel3 <- beanplot(ratio~rankall,data=salt.dat,horizontal=FALSE,xlab="",col = list(c("#ffffff", "#00000080", "#00000080", "#5f5f5f")), border = list("#767676"), innerborder = "#767676", beanlinewd = 1.7, what=c(0,1,1,1),kernel='rectangular',ylim=my.ylim,log='y',show.names=FALSE,bw=0.4,beanlines='mean',side = "second")#

## rank.all and mgmt.rank are already available, but still need the value of mean(log(ratio)) for each mgmt
n.by.mgmt <- as.data.frame(table(salt.dat$mgmt))
names(n.by.mgmt) <- c("mgmt","nn")
my.temp <- merge(n.by.mgmt, mgmt.rank, by="mgmt")
my.tt <- tapply(log(salt.dat$ratio), salt.dat$mgmt, mean)
mgmt.mean <- data.frame(mgmt=names(my.tt), mean=my.tt)
mgmt.mean.o <- merge(my.temp, mgmt.mean, by = "mgmt")
oo <- order(mgmt.mean.o$norderall)
mgmt.mean.oo <- mgmt.mean.o[oo,]

for (i in 1:dim(mgmt.mean.oo)[1]){
xx <- mgmt.mean.oo$norderall[i]+0.3
text(xx,exp(mgmt.mean.oo$mean[i])*1.15,paste("n=",mgmt.mean.oo$nn[i]),cex=0.6)
}

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
