## plot the fits to each stock
## CM, DR
## date:
## Time-stamp: <Last modified: 14 JANUARY   (srdbadmin)>
rm(list=ls())
pdf("ts-new.pdf")
#xyplot(ssb~tsyear | assessid, data=my.data)
for(i in 1:n) {
print(i)
temp <- subset(dat, assessid == a[i])
c<-which(temp$tsyear==cutoff)
temp$post <- floor(temp$tsyear/(cutoff+1))
temp$yr <- temp$tsyear - min(temp$tsyear) + 1
m <- lm(log(ssb) ~ yr + post + post:yr, data=temp)
mcont <- lm(log(ssb) ~ yr +post:I(yr-c), data=temp)

s <- unique(temp$stockid)
par.estimates$stockid[i] <- as.character(s)
par.estimates$assessid[i] <- as.character(a[i])
par.estimates$m.slope.before[i] <- m$coef[2]
par.estimates$m.slope.after[i] <- m$coef[2] + m$coef[4]
par.estimates$mcont.slope.before[i] <- mcont$coef[2]
par.estimates$mcont.slope.after[i] <- mcont$coef[2] + mcont$coef[3]
par.estimates$m.diff[i] <- m$coef[4]
par.estimates$mcont.diff[i] <- mcont$coef[3]
par.estimates$model.diff[i] <- par.estimates$m.diff[i]-par.estimates$mcont.diff[i]

## admb state space fit
my.dat.path<-"/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/localleveltrend/localleveltrend.dat"
cat("# Number of obs \n", dim(temp)[1], "\n",file = my.dat.path, append=FALSE)
cat("# Cut off \n", cutoff, "\n",file = my.dat.path, append=TRUE)
cat("# years \n", temp$tsyear, "\n",file = my.dat.path, append=TRUE)
cat("# Observations \n", log(temp$ssb), "\n",file = my.dat.path, append=TRUE)

system("cd /home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/localleveltrend; rm localleveltrend.std; ./localleveltrend ")
##system("cd /home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/processerroronly; rm processerroronly.std; ./processerroronly ", show.output.on.console =FALSE)

if(file.exists("/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/localleveltrend/localleveltrend.std")){
  admb.fit<-get.admb.results("/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/localleveltrend/","localleveltrend")
  state.hat<-admb.fit$value[admb.fit$name=="state"]
  par.estimates$mss.slope.before[i]<-admb.fit$value[admb.fit$name=="slope_pre"]
  par.estimates$mss.slope.after[i]<-admb.fit$value[admb.fit$name=="slope_post"]
  par.estimates$mss.slope.diff[i]<-par.estimates$mss.slope.before[i]-par.estimates$mss.slope.after[i]
}else{
  par.estimates$mss.slope.before[i]<-NA
  par.estimates$mss.slope.after[i]<-NA
  par.estimates$mss.slope.diff[i]<-NA
  state.hat<-rep(NA,dim(temp)[1])
}

## admb.fit2<-get.admb.results("/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/processerroronly/", "processerroronly")
## state.hat2<-admb.fit2$value[admb.fit2$name=="predstate"]
## plot(state.hat) 
## lines(state.hat2, lty=2)

par(mfrow=c(2,1))
with(temp, plot(yr,log(ssb),pch=8,lty=2,type='b'))
title(a[i])
#lines(predict(m))
lines(temp$yr[temp$post==0],predict(m,temp[temp$post==0,]),lty=1,col='blue',lwd=2)
lines(temp$yr[temp$post==1],predict(m,temp[temp$post==1,]),lty=1,col='blue',lwd=2)
lines(predict(mcont), lty=2, col="red", lwd=3)
lines(temp$yr,state.hat, col="seagreen", lwd=3)
abline(v=c, lty=2)
plot(m$residuals, ylim=range(c(m$residuals, mcont$residuals)),col='blue')
points(mcont$residuals, col="red")
points(log(temp$ssb)-state.hat, col="seagreen")
abline(h=0,v=c, lty=2)
}
dev.off()
