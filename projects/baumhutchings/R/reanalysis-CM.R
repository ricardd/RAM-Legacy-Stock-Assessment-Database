# 
# last modified Time-stamp: <2009-08-20 15:32:47 (ricardd)>
#

require(RODBC)
chan <- odbcConnect(dsn="srdbusercalo", case='postgresql',believeNRows=FALSE)

qu <- paste ("
select aa.stockid, v.assessid, v.tsyear, v.ssb from srdb.timeseries_values_view v, srdb.assessment aa where aa.assessid=v.assessid AND v.assessid in (select assessid from (select assessid, max(tsyear) - min(tsyear) as nyears from srdb.timeseries_values_view where ssb is not null and assessid in (select assessid from srdb.assessment where recorder != \'MYERS\' and stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where classname in (\'Actinopterygii\',\'Chondrichthyes\')))) group by assessid) as a where nyears>=25) and ssb is not null
", sep="")

dat <- sqlQuery(chan,qu)

a <- unique(dat$assessid)
s <- unique(dat$stockid)
n <- length(a)

par.estimates <- data.frame(stockid = rep(0,n),assessid = rep(0,n), m.slope.before = rep(0,n), m.slope.after = rep(0,n), mcont.slope.before = rep(0,n), mcont.slope.after = rep(0,n), m.diff=rep(0,n), mcont.diff=rep(0,n), model.diff=rep(0,n))

cutoff<-1992

pdf("ts-new.pdf")
#xyplot(ssb~tsyear | assessid, data=my.data)
for(i in 1:n) {
print(i)
t <- subset(dat, assessid == a[i])
c<-which(t$tsyear==cutoff)
t$post <- floor(t$tsyear/(cutoff+1))
t$yr <- t$tsyear - min(t$tsyear) + 1
m <- lm(log(ssb) ~ yr + post + post:yr, t)
mcont <- lm(log(ssb) ~ yr +post:I(yr-c), t)

par.estimates$stockid[i] <- as.character(s[i])
par.estimates$assessid[i] <- as.character(a[i])
par.estimates$m.slope.before[i] <- m$coef[2]
par.estimates$m.slope.after[i] <- m$coef[2] + m$coef[4]
par.estimates$mcont.slope.before[i] <- mcont$coef[2]
par.estimates$mcont.slope.after[i] <- mcont$coef[2] + mcont$coef[3]
par.estimates$m.diff[i] <- m$coef[4]
par.estimates$mcont.diff[i] <- mcont$coef[3]
par.estimates$model.diff[i] <- par.estimates$m.diff[i]-par.estimates$mcont.diff[i]

par(mfrow=c(2,1))
with(t, plot(yr,log(ssb),pch=8,lty=2,type='b'))
title(a[i])
#lines(predict(m))
lines(t$yr[t$post==0],predict(m,t[t$post==0,]),lty=1,col='blue',lwd=2)
lines(t$yr[t$post==1],predict(m,t[t$post==1,]),lty=1,col='blue',lwd=2)
lines(predict(mcont), lty=2, col="red", lwd=3)
abline(v=c, lty=2)
plot(m$residuals, ylim=range(c(m$residuals, mcont$residuals)),col='blue')
points(mcont$residuals, col="red")
abline(h=0,v=c, lty=2)
}
dev.off()

# now plot the slope values before and after
# now split the results between the stocks whose "after" slope is positive and those where it is negative
par.estimates$positive.m <- ifelse(par.estimates$m.slope.after>=0,1,0)
par.estimates$positive.mcont <- ifelse(par.estimates$mcont.slope.after>=0,1,0)


#pdf("./model1slopes.pdf", paper="letter")
pdf("./model1slopes.pdf", height=12, width=12/1.6)
par(mfrow=c(2,1), mar=c(0,0,0,0), oma=c(5,7,4,3))
## positive post-1992 model 1
pos.m <- subset(par.estimates, positive.m==1)
or.m <- order(pos.m$m.slope.before)
or.diff.m<-order(pos.m$m.diff)
y <- pos.m$stockid[or.diff.m]
x.m.diff<-pos.m$m.diff[or.diff.m]
x.m.pre <- pos.m$m.slope.before[or.diff.m]
x.m.post <- pos.m$m.slope.after[or.diff.m]
y.index<-seq(1, length(pos.m[,1]))
#par(mar=c(4,8,2,2))
## difference
plot(x.m.diff, y.index, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", xlim=range(par.estimates[,4:9]), xaxt="n")
par(font=2)
mtext(text="Model with NO continuity constraints", side=3, outer=TRUE, line=1)
par(font=1)
## values
points(x.m.pre, y.index, pch=2)
points(x.m.post, y.index, pch=17)
abline(v=0, lty=2)
par(las=1)
axis(side=2, at=y.index, labels=pos.m$stockid[or.diff.m], cex.axis=0.6)
par(las=0)
mtext(text="Post-1992 slope positive", side=4, outer=FALSE, line=0)
par(las=1)
legend("bottomright", pch=c(2,17,17), col=c(1,1,"red"), legend=c("Pre-1992 slope","Post-1992 slope","Difference in slope"))

## negative post: model 1
neg.m <- subset(par.estimates, positive.m==0)
or.m <- order(neg.m$m.slope.before)
or.diff.m<-order(neg.m$m.diff)
y <- neg.m$stockid[or.diff.m]
x.m.diff<-neg.m$m.diff[or.diff.m]
x.m.pre <- neg.m$m.slope.before[or.diff.m]
x.m.post <- neg.m$m.slope.after[or.diff.m]
y.index<-seq(1, length(neg.m[,1]))
#par(mar=c(4,8,2,2))
## difference
plot(x.m.diff, y.index, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", xlim=range(par.estimates[,4:9]))
#title("model with NO continuity constraints")
## values
points(x.m.pre, y.index, pch=2)
points(x.m.post, y.index, pch=17)
abline(v=0, lty=2)
par(las=1)
axis(side=2, at=y.index, labels=neg.m$stockid[or.diff.m], cex.axis=0.6)
mtext(text="Temporal abundance slope", side=1, outer=TRUE, line=2)
par(las=0)
mtext(text="Post-1992 slope negative", side=4, outer=FALSE, line=0)
par(las=1)
dev.off()

##--------------------------
## WITH CONTINUITY
##--------------------------
pdf("./model2slopes.pdf", height=12, width=12/1.6)
par(mfrow=c(2,1), mar=c(0,0,0,0), oma=c(5,7,4,3))
## positive post-1992 model 1
poos.mcont <- subset(par.estimates, positive.mcont==1)
or.mcont <- order(pos.mcont$m.slope.before)
or.diff.mcont<-order(pos.mcont$m.diff)
y <- pos.mcont$stockid[or.diff.mcont]
x.mcont.diff<-pos.mcont$m.diff[or.diff.mcont]
x.mcont.pre <- pos.mcont$m.slope.before[or.diff.mcont]
x.mcont.post <- pos.mcont$m.slope.after[or.diff.mcont]
y.index<-seq(1, length(pos.mcont[,1]))
#par(mar=c(4,8,2,2))
## difference
plot(x.mcont.diff, y.index, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", xlim=range(par.estimates[,4:9]), xaxt="n")
par(font=2)
mtext(text="Model WITH continuity constraints", side=3, outer=TRUE, line=1)
par(font=1)
## values
points(x.mcont.pre, y.index, pch=2)
points(x.mcont.post, y.index, pch=17)
abline(v=0, lty=2)
par(las=1)
axis(side=2, at=y.index, labels=pos.mcont$stockid[or.diff.mcont], cex.axis=0.6)
par(las=0)
mtext(text="Post-1992 slope positive", side=4, outer=FALSE, line=0)
par(las=1)
legend("bottomright", pch=c(2,17,17), col=c(1,1,"red"), legend=c("Pre-1992 slope","Post-1992 slope","Difference in slope"))

## negative post: model 1
neg.mcont <- subset(par.estimates, positive.mcont==0)
or.mcont <- order(neg.mcont$m.slope.before)
or.diff.mcont<-order(neg.mcont$m.diff)
y <- neg.mcont$stockid[or.diff.mcont]
x.mcont.diff<-neg.mcont$m.diff[or.diff.mcont]
x.mcont.pre <- neg.mcont$m.slope.before[or.diff.mcont]
x.mcont.post <- neg.mcont$m.slope.after[or.diff.mcont]
y.index<-seq(1, length(neg.mcont[,1]))
#par(mar=c(4,8,2,2))
## difference
plot(x.mcont.diff, y.index, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", xlim=range(par.estimates[,4:9]))
#title("model with NO continuity constraints")
## values
points(x.mcont.pre, y.index, pch=2)
points(x.mcont.post, y.index, pch=17)
abline(v=0, lty=2)
par(las=1)
axis(side=2, at=y.index, labels=neg.mcont$stockid[or.diff.mcont], cex.axis=0.3)
mtext(text="Temporal abundance slope", side=1, outer=TRUE, line=2)
par(las=0)
mtext(text="Post-1992 slope negative", side=4, outer=FALSE, line=0)
par(las=1)
dev.off()






pdf("slopes.pdf")

#x11()
## discontinuous model
or.m <- order(par.estimates$m.slope.before)
or.diff.m<-order(par.estimates$m.diff)
y <- par.estimates$stockid[or.diff.m]
x.m.diff<-par.estimates$m.diff[or.diff.m]
x.m.pre <- par.estimates$m.slope.before[or.diff.m]
x.m.post <- par.estimates$m.slope.after[or.diff.m]
y.index<-seq(1, length(par.estimates[,1]))
par(mar=c(4,8,2,2))
## difference
plot(x.m.diff, y.index, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red")
title("model with NO continuity constraints")
## values
points(x.m.pre, y.index, pch=2)
points(x.m.post, y.index, pch=17)
abline(v=0, lty=2)
par(las=1)
axis(side=2, at=y.index, labels=par.estimates$stockid[or.diff.m], cex.lab=0.1)


#x11()
## continuous model
or.mcont <- order(par.estimates$mcont.slope.before)
or.diff.mcont<-order(par.estimates$mcont.diff)
y <- par.estimates$stockid[or.diff.mcont]
x.mcont.diff<-par.estimates$mcont.diff[or.diff.mcont]
x.mcont.pre <- par.estimates$mcont.slope.before[or.diff.mcont]
x.mcont.post <- par.estimates$mcont.slope.after[or.diff.mcont]
y.index<-seq(1, length(par.estimates[,1]))
par(mar=c(4,8,2,2))
## difference
plot(x.mcont.diff, y.index, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red")
title("model with continuity constraints")
## values
points(x.mcont.pre, y.index, pch=2) #, xlab="", ylab="", bty="L", yaxt="n)
points(x.mcont.post, y.index, pch=17)
abline(v=0, lty=2)
par(las=1)
axis(side=2, at=y.index, labels=par.estimates$stockid[or.diff.mcont], cex.lab=0.1)

dev.off()





odbcClose(chan)


##---------------
## sandbox
##---------------

my.id <- "\'WGNSSK-PLAICNS-1956-2006-MINTO\'"
qu <- paste("select assessid, tsyear, ssb from srdb.timeseries_values_view where assessid=",my.id, " and ssb is not null", sep="")
d <- sqlQuery(chan,qu)
d$post <- floor(d$tsyear/(cutoff+1))
d$yr <- d$tsyear - min(d$tsyear) + 1

c<-which(d$tsyear==cutoff)

m<-lm(log(ssb)~post+yr+post:yr, d)
mcont<-lm(log(ssb)~yr+post:I(yr-c), d)

with(d, plot(yr,log(ssb)))
lines(predict(m))
lines(predict(mcont), lty=2, col="red", lwd=3)


## taxonomic categories
## select tsn, commonname1, scientificname, (CASE WHEN family = 'Gadidae' THEN 'Gadidae' ELSE (CASE WHEN ordername = 'Pleuronectiformes' THEN 'Pleuronectiformes' ELSE (CASE WHEN ((family in ('Clupeidae','Scombridae','Engraulidae')) OR (genus = 'Trachurus')) THEN 'Pelagic' ELSE (CASE WHEN classname = 'Chondrichthyes' THEN 'Shark/Skate' ELSE 'Other demersal' END) END) END) END) from srdb.taxonomy where classname in ('Actinopterygii','Chondrichthyes');

## geographic areas
# select stockid, max(geoarea) from (  select stockid, (CASE WHEN lme_number in (7,8,9,18) THEN 'NWAtl' ELSE (CASE WHEN lme_number in (19,20,21,22,23,24,25,59,60) THEN 'NEAtl' ELSE (CASE WHEN lme_number in (1,2,3) THEN 'NEPac' ELSE (CASE WHEN lme_number in (5,6,12) THEN 'NorthMidAtl' ELSE (CASE WHEN lme_number in (14,15,16,17) THEN 'SWAtl' ELSE (CASE WHEN lme_number in (39,40,41,42,43,44,45,46) THEN 'Aust-NZ' ELSE (CASE WHEN lme_number in (29,30) THEN 'SAfr' ELSE (CASE WHEN lme_number <0 THEN 'HighSeas' ELSE (CASE WHEN lme_number = 26 THEN 'Med' ELSE (CASE WHEN lme_number = 62 THEN 'BlackSea' ELSE NULL END) END) END) END) END) END) END) END) END) END ) as geoarea from srdb.lmetostocks) as a group by stockid;

## assessid proxy for labels
