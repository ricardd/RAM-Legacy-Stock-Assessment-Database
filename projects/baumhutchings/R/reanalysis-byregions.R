# pre- and post-1992 slope analysis by geographical regions
# last modified Time-stamp: <2009-08-20 09:58:36 (ricardd)>
#
#
require(RODBC)
chan <- odbcConnect(dsn="srdbusercalo", case='postgresql',believeNRows=FALSE)

# tsn and associated taxonomic classification
qu.taxo <- paste("
(select s.stockid, tt.taxocategory from (select tsn, (CASE WHEN family = \'Gadidae\' THEN \'Gadidae\' ELSE (CASE WHEN ordername = \'Pleuronectiformes\' THEN \'Pleuronectiformes\' ELSE (CASE WHEN ((family in (\'Clupeidae\',\'Scombridae\',\'Engraulidae\')) OR (genus = \'Trachurus\')) THEN \'Pelagic\' ELSE (CASE WHEN classname = \'Chondrichthyes\' THEN \'Shark/Skate\' ELSE \'Other demersal\' END) END) END) END) as taxocategory from srdb.taxonomy where classname in (\'Actinopterygii\',\'Chondrichthyes\')) as tt, srdb.stock s where s.tsn=tt.tsn) as tt
", sep="")

# stockid and associated geographical region
qu.geo <- paste("
(select stockid, max(geoarea) as geo from (select stockid, (CASE WHEN lme_number in (7,8,9,18) THEN \'NWAtl\' ELSE (CASE WHEN lme_number in (19,20,21,22,23,24,25,59,60) THEN \'NEAtl\' ELSE (CASE WHEN lme_number in (1,2,3) THEN \'NEPac\' ELSE (CASE WHEN lme_number in (5,6,12) THEN \'NorthMidAtl\' ELSE (CASE WHEN lme_number in (14,15,16,17) THEN \'SWAtl\' ELSE (CASE WHEN lme_number in (39,40,41,42,43,44,45,46) THEN \'Aust-NZ\' ELSE (CASE WHEN lme_number in (29,30) THEN \'SAfr\' ELSE (CASE WHEN lme_number <0 THEN \'HighSeas\' ELSE (CASE WHEN lme_number = 26 THEN \'Med\' ELSE (CASE WHEN lme_number = 62 THEN \'BlackSea\' ELSE NULL END) END) END) END) END) END) END) END) END) END ) as geoarea from srdb.lmetostocks) as a group by stockid) as gg
",sep="")

# SSB time-series
qu.ts <- paste ("
(select aa.stockid, v.assessid, v.tsyear, v.ssb from srdb.timeseries_values_view v, srdb.assessment aa where aa.assessid=v.assessid AND v.assessid in (select assessid from (select assessid, max(tsyear) - min(tsyear) as nyears from srdb.timeseries_values_view where ssb is not null and assessid in (select assessid from srdb.assessment where recorder != \'MYERS\' and stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where classname in (\'Actinopterygii\',\'Chondrichthyes\')))) group by assessid) as a where nyears>=25) and ssb is not null) as ts
", sep="")

# now bring back the SSB time-series data along with the taxonomic classification and geographical region
qu.main <- paste("
SELECT
tt.taxocategory,
gg.geo,
ts.stockid, ts.assessid, ts.tsyear, ts.ssb
FROM", qu.taxo, ",", qu.geo, ",", qu.ts,
"WHERE
tt.stockid=ts.stockid AND
gg.stockid=ts.stockid
",sep=" ")

dat <- sqlQuery(chan,qu.main)

############################################################
# analysis by region
dat.neatl <- subset(dat, geo=="NEAtl")
dat.nwatl <- subset(dat, geo=="NWAtl")
dat.nepac <- subset(dat, geo=="NEPac")
dat.northmidatl <- subset(dat, geo=="NorthMidAtl")
dat.safr <- subset(dat, geo=="SAfr")
dat.austnz <- subset(dat, geo=="Aust-NZ")

cutoff<-1992

############################################################
# NEAtl
a <- unique(dat.neatl$assessid)
s <- unique(dat.neatl$stockid)
n <- length(a)
par.estimates <- data.frame(geo = rep(0,n), taxo = rep(0,n), stockid = rep(0,n),assessid = rep(0,n), m.slope.before = rep(0,n), m.slope.after = rep(0,n), mcont.slope.before = rep(0,n), mcont.slope.after = rep(0,n), m.diff=rep(0,n), mcont.diff=rep(0,n), model.diff=rep(0,n))
############################################################
for(i in 1:n) {
print(i)
t <- subset(dat.neatl, assessid == a[i])
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
}

par.estimates$positive.m <- ifelse(par.estimates$m.slope.after>=0,1,0)
par.estimates$positive.mcont <- ifelse(par.estimates$mcont.slope.after>=0,1,0)
############################################################


pdf("NEAtl.pdf", height=12, width=12/1.6)
############################################################
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
mtext(text="NEAtl - Model with NO continuity constraints", side=3, outer=TRUE, line=1)
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
legend("topleft", pch=c(2,17,17), col=c(1,1,"red"), legend=c("Pre-1992 slope","Post-1992 slope","Difference in slope"))

neg.m <- subset(par.estimates, positive.m==0)
or.m <- order(neg.m$m.slope.before)
or.diff.m<-order(neg.m$m.diff)
y <- neg.m$stockid[or.diff.m]
x.m.diff<-neg.m$m.diff[or.diff.m]
x.m.pre <- neg.m$m.slope.before[or.diff.m]
x.m.post <- neg.m$m.slope.after[or.diff.m]
y.index<-seq(1, length(neg.m[,1]))
## difference
plot(x.m.diff, y.index, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", xlim=range(par.estimates[,4:9]))
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
############################################################

par(mfrow=c(2,1), mar=c(0,0,0,0), oma=c(5,7,4,3))
## positive post-1992 model 1
pos.mcont <- subset(par.estimates, positive.mcont==1)
or.mcont <- order(pos.mcont$mcont.slope.before)
or.diff.mcont<-order(pos.mcont$mcont.diff)
y <- pos.mcont$stockid[or.diff.mcont]
x.mcont.diff<-pos.mcont$mcont.diff[or.diff.mcont]
x.mcont.pre <- pos.mcont$mcont.slope.before[or.diff.mcont]
x.mcont.post <- pos.mcont$mcont.slope.after[or.diff.mcont]
y.index<-seq(1, length(pos.mcont[,1]))
#par(mar=c(4,8,2,2))
## difference
plot(x.mcont.diff, y.index, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", xlim=range(par.estimates[,4:9]), xaxt="n")
par(font=2)
mtext(text="NEAtl - Model WITH continuity constraints", side=3, outer=TRUE, line=1)
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
legend("topleft", pch=c(2,17,17), col=c(1,1,"red"), legend=c("Pre-1992 slope","Post-1992 slope","Difference in slope"))

## negative post: model 1
neg.mcont <- subset(par.estimates, positive.mcont==0)
or.mcont <- order(neg.mcont$mcont.slope.before)
or.diff.mcont<-order(neg.mcont$mcont.diff)
y <- neg.mcont$stockid[or.diff.mcont]
x.mcont.diff<-neg.mcont$mcont.diff[or.diff.mcont]
x.mcont.pre <- neg.mcont$mcont.slope.before[or.diff.mcont]
x.mcont.post <- neg.mcont$mcont.slope.after[or.diff.mcont]
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
axis(side=2, at=y.index, labels=neg.mcont$stockid[or.diff.mcont], cex.axis=0.6)
mtext(text="Temporal abundance slope", side=1, outer=TRUE, line=2)
par(las=0)
mtext(text="Post-1992 slope negative", side=4, outer=FALSE, line=0)
par(las=1)

dev.off()



############################################################
# NWAtl
a <- unique(dat.nwatl$assessid)
s <- unique(dat.nwatl$stockid)
n <- length(a)
par.estimates <- data.frame(stockid = rep(0,n),assessid = rep(0,n), m.slope.before = rep(0,n), m.slope.after = rep(0,n), mcont.slope.before = rep(0,n), mcont.slope.after = rep(0,n), m.diff=rep(0,n), mcont.diff=rep(0,n), model.diff=rep(0,n))
############################################################
for(i in 1:n) {
print(i)
t <- subset(dat.nwatl, assessid == a[i])
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
}

par.estimates$positive.m <- ifelse(par.estimates$m.slope.after>=0,1,0)
par.estimates$positive.mcont <- ifelse(par.estimates$mcont.slope.after>=0,1,0)
############################################################


pdf("NWAtl.pdf", height=12, width=12/1.6)
############################################################
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
mtext(text="NWAtl - Model with NO continuity constraints", side=3, outer=TRUE, line=1)
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
legend("topleft", pch=c(2,17,17), col=c(1,1,"red"), legend=c("Pre-1992 slope","Post-1992 slope","Difference in slope"))

neg.m <- subset(par.estimates, positive.m==0)
or.m <- order(neg.m$m.slope.before)
or.diff.m<-order(neg.m$m.diff)
y <- neg.m$stockid[or.diff.m]
x.m.diff<-neg.m$m.diff[or.diff.m]
x.m.pre <- neg.m$m.slope.before[or.diff.m]
x.m.post <- neg.m$m.slope.after[or.diff.m]
y.index<-seq(1, length(neg.m[,1]))
## difference
plot(x.m.diff, y.index, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", xlim=range(par.estimates[,4:9]))
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
############################################################

par(mfrow=c(2,1), mar=c(0,0,0,0), oma=c(5,7,4,3))
## positive post-1992 model 1
pos.mcont <- subset(par.estimates, positive.mcont==1)
or.mcont <- order(pos.mcont$mcont.slope.before)
or.diff.mcont<-order(pos.mcont$mcont.diff)
y <- pos.mcont$stockid[or.diff.mcont]
x.mcont.diff<-pos.mcont$mcont.diff[or.diff.mcont]
x.mcont.pre <- pos.mcont$mcont.slope.before[or.diff.mcont]
x.mcont.post <- pos.mcont$mcont.slope.after[or.diff.mcont]
y.index<-seq(1, length(pos.mcont[,1]))
#par(mar=c(4,8,2,2))
## difference
plot(x.mcont.diff, y.index, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", xlim=range(par.estimates[,4:9]), xaxt="n")
par(font=2)
mtext(text="NWAtl - Model WITH continuity constraints", side=3, outer=TRUE, line=1)
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
legend("topleft", pch=c(2,17,17), col=c(1,1,"red"), legend=c("Pre-1992 slope","Post-1992 slope","Difference in slope"))

## negative post: model 1
neg.mcont <- subset(par.estimates, positive.mcont==0)
or.mcont <- order(neg.mcont$mcont.slope.before)
or.diff.mcont<-order(neg.mcont$mcont.diff)
y <- neg.mcont$stockid[or.diff.mcont]
x.mcont.diff<-neg.mcont$mcont.diff[or.diff.mcont]
x.mcont.pre <- neg.mcont$mcont.slope.before[or.diff.mcont]
x.mcont.post <- neg.mcont$mcont.slope.after[or.diff.mcont]
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
axis(side=2, at=y.index, labels=neg.mcont$stockid[or.diff.mcont], cex.axis=0.6)
mtext(text="Temporal abundance slope", side=1, outer=TRUE, line=2)
par(las=0)
mtext(text="Post-1992 slope negative", side=4, outer=FALSE, line=0)
par(las=1)

dev.off()



############################################################
# NEPac
a <- unique(dat.nepac$assessid)
s <- unique(dat.nepac$stockid)
n <- length(a)
par.estimates <- data.frame(stockid = rep(0,n),assessid = rep(0,n), m.slope.before = rep(0,n), m.slope.after = rep(0,n), mcont.slope.before = rep(0,n), mcont.slope.after = rep(0,n), m.diff=rep(0,n), mcont.diff=rep(0,n), model.diff=rep(0,n))
############################################################
for(i in 1:n) {
print(i)
t <- subset(dat.nepac, assessid == a[i])
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
}

par.estimates$positive.m <- ifelse(par.estimates$m.slope.after>=0,1,0)
par.estimates$positive.mcont <- ifelse(par.estimates$mcont.slope.after>=0,1,0)
############################################################


pdf("NEPac.pdf", height=12, width=12/1.6)
############################################################
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
mtext(text="NEPac - Model with NO continuity constraints", side=3, outer=TRUE, line=1)
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
legend("topleft", pch=c(2,17,17), col=c(1,1,"red"), legend=c("Pre-1992 slope","Post-1992 slope","Difference in slope"))

neg.m <- subset(par.estimates, positive.m==0)
or.m <- order(neg.m$m.slope.before)
or.diff.m<-order(neg.m$m.diff)
y <- neg.m$stockid[or.diff.m]
x.m.diff<-neg.m$m.diff[or.diff.m]
x.m.pre <- neg.m$m.slope.before[or.diff.m]
x.m.post <- neg.m$m.slope.after[or.diff.m]
y.index<-seq(1, length(neg.m[,1]))
## difference
plot(x.m.diff, y.index, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", xlim=range(par.estimates[,4:9]))
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
############################################################

par(mfrow=c(2,1), mar=c(0,0,0,0), oma=c(5,7,4,3))
## positive post-1992 model 1
pos.mcont <- subset(par.estimates, positive.mcont==1)
or.mcont <- order(pos.mcont$mcont.slope.before)
or.diff.mcont<-order(pos.mcont$mcont.diff)
y <- pos.mcont$stockid[or.diff.mcont]
x.mcont.diff<-pos.mcont$mcont.diff[or.diff.mcont]
x.mcont.pre <- pos.mcont$mcont.slope.before[or.diff.mcont]
x.mcont.post <- pos.mcont$mcont.slope.after[or.diff.mcont]
y.index<-seq(1, length(pos.mcont[,1]))
#par(mar=c(4,8,2,2))
## difference
plot(x.mcont.diff, y.index, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", xlim=range(par.estimates[,4:9]), xaxt="n")
par(font=2)
mtext(text="NEPac - Model WITH continuity constraints", side=3, outer=TRUE, line=1)
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
legend("topleft", pch=c(2,17,17), col=c(1,1,"red"), legend=c("Pre-1992 slope","Post-1992 slope","Difference in slope"))

## negative post: model 1
neg.mcont <- subset(par.estimates, positive.mcont==0)
or.mcont <- order(neg.mcont$mcont.slope.before)
or.diff.mcont<-order(neg.mcont$mcont.diff)
y <- neg.mcont$stockid[or.diff.mcont]
x.mcont.diff<-neg.mcont$mcont.diff[or.diff.mcont]
x.mcont.pre <- neg.mcont$mcont.slope.before[or.diff.mcont]
x.mcont.post <- neg.mcont$mcont.slope.after[or.diff.mcont]
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
axis(side=2, at=y.index, labels=neg.mcont$stockid[or.diff.mcont], cex.axis=0.6)
mtext(text="Temporal abundance slope", side=1, outer=TRUE, line=2)
par(las=0)
mtext(text="Post-1992 slope negative", side=4, outer=FALSE, line=0)
par(las=1)

dev.off()



############################################################
# MidNorthAtl
a <- unique(dat.northmidatl$assessid)
s <- unique(dat.northmidatl$stockid)
n <- length(a)
par.estimates <- data.frame(stockid = rep(0,n),assessid = rep(0,n), m.slope.before = rep(0,n), m.slope.after = rep(0,n), mcont.slope.before = rep(0,n), mcont.slope.after = rep(0,n), m.diff=rep(0,n), mcont.diff=rep(0,n), model.diff=rep(0,n))
############################################################
for(i in 1:n) {
print(i)
t <- subset(dat.northmidatl, assessid == a[i])
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
}

par.estimates$positive.m <- ifelse(par.estimates$m.slope.after>=0,1,0)
par.estimates$positive.mcont <- ifelse(par.estimates$mcont.slope.after>=0,1,0)
############################################################


pdf("NorthMidAtl.pdf", height=12, width=12/1.6)
############################################################
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
mtext(text="NEPac - Model with NO continuity constraints", side=3, outer=TRUE, line=1)
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
legend("topleft", pch=c(2,17,17), col=c(1,1,"red"), legend=c("Pre-1992 slope","Post-1992 slope","Difference in slope"))

neg.m <- subset(par.estimates, positive.m==0)
or.m <- order(neg.m$m.slope.before)
or.diff.m<-order(neg.m$m.diff)
y <- neg.m$stockid[or.diff.m]
x.m.diff<-neg.m$m.diff[or.diff.m]
x.m.pre <- neg.m$m.slope.before[or.diff.m]
x.m.post <- neg.m$m.slope.after[or.diff.m]
y.index<-seq(1, length(neg.m[,1]))
## difference
plot(x.m.diff, y.index, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", xlim=range(par.estimates[,4:9]))
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
############################################################

par(mfrow=c(2,1), mar=c(0,0,0,0), oma=c(5,7,4,3))
## positive post-1992 model 1
pos.mcont <- subset(par.estimates, positive.mcont==1)
or.mcont <- order(pos.mcont$mcont.slope.before)
or.diff.mcont<-order(pos.mcont$mcont.diff)
y <- pos.mcont$stockid[or.diff.mcont]
x.mcont.diff<-pos.mcont$mcont.diff[or.diff.mcont]
x.mcont.pre <- pos.mcont$mcont.slope.before[or.diff.mcont]
x.mcont.post <- pos.mcont$mcont.slope.after[or.diff.mcont]
y.index<-seq(1, length(pos.mcont[,1]))
#par(mar=c(4,8,2,2))
## difference
plot(x.mcont.diff, y.index, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", xlim=range(par.estimates[,4:9]), xaxt="n")
par(font=2)
mtext(text="NEPac - Model WITH continuity constraints", side=3, outer=TRUE, line=1)
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
legend("topleft", pch=c(2,17,17), col=c(1,1,"red"), legend=c("Pre-1992 slope","Post-1992 slope","Difference in slope"))

## negative post: model 1
neg.mcont <- subset(par.estimates, positive.mcont==0)
or.mcont <- order(neg.mcont$mcont.slope.before)
or.diff.mcont<-order(neg.mcont$mcont.diff)
y <- neg.mcont$stockid[or.diff.mcont]
x.mcont.diff<-neg.mcont$mcont.diff[or.diff.mcont]
x.mcont.pre <- neg.mcont$mcont.slope.before[or.diff.mcont]
x.mcont.post <- neg.mcont$mcont.slope.after[or.diff.mcont]
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
axis(side=2, at=y.index, labels=neg.mcont$stockid[or.diff.mcont], cex.axis=0.6)
mtext(text="Temporal abundance slope", side=1, outer=TRUE, line=2)
par(las=0)
mtext(text="Post-1992 slope negative", side=4, outer=FALSE, line=0)
par(las=1)

dev.off()


odbcClose(chan)


## do the same thing but split panels with positive and negative slope BEFORE 1992, not post-1992
