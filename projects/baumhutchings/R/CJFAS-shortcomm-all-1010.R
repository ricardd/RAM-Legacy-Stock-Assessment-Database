## fits and plots by stock
## DR, CM
## date:
## Time-stamp: <Last modified: 24 FEBRUARY 2010  (srdbadmin)>
## notes CM changed the plots to be multipanelled, this can be reversed by
## switching multipanel to FALSE

##------
## DATA
##------
source("CJFAS-shortcomm-data-1010.R")

## define the data frame
par.estimates.1010 <- data.frame(geo = rep(0,n), taxo = rep(0,n), stockid = rep(0,n),assessid = rep(0,n), m.slope.before = rep(0,n), m.slope.after = rep(0,n), mcont.slope.before = rep(0,n), mcont.slope.after = rep(0,n), m.diff=rep(0,n), mcont.diff=rep(0,n), model.diff=rep(0,n), mss.slope.before=rep(0,n), mss.slope.after=rep(0,n), mss.slope.diff=rep(0,n))

multipanel <-TRUE

## plots and populate the dataframe -simultaneously

if(multipanel){
  pdf("CBD-Supp-fig1_v1.pdf", width=8, height=10)
  par(mfrow=c(5,4),mar=c(1,1,1,1), oma=c(3.5,3,0,0))
}else{pdf("ts-CJFAS-1010.pdf")}

for(i in 1:n) {
print(i)
temp <- subset(dat.1010, assessid == a[i])
c<-which(temp$tsyear==cutoff)
#temp$post <- floor(temp$tsyear/(cutoff+1))
temp$post <- ifelse(temp$tsyear<cutoff, 0, 1)
  
temp$yr <- temp$tsyear - min(temp$tsyear) + 1

##-------
## FITS
##-------
m <- lm(log(ssb) ~ yr + post + post:yr, data=temp)
mcont <- lm(log(ssb) ~ yr + post:I(yr-c), data=temp)
s <- unique(temp$stockid)

par.estimates.1010$stockid[i] <- as.character(s)
par.estimates.1010$assessid[i] <- as.character(a[i])
par.estimates.1010$m.slope.before[i] <- m$coef[2]
par.estimates.1010$m.slope.after[i] <- m$coef[2] + m$coef[4]
par.estimates.1010$mcont.slope.before[i] <- mcont$coef[2]
par.estimates.1010$mcont.slope.after[i] <- mcont$coef[2] + mcont$coef[3]
par.estimates.1010$m.diff[i] <- m$coef[4]
par.estimates.1010$mcont.diff[i] <- mcont$coef[3]
par.estimates.1010$model.diff[i] <- par.estimates.1010$m.diff[i]-par.estimates.1010$mcont.diff[i]
par.estimates.1010$geo[i] <- as.character(unique(temp$geo))
par.estimates.1010$taxo[i] <- as.character(unique(temp$taxocategory))

## process error model
##  my.dat.path<-"/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/processerroronly/processerroronly.dat"
## kalman filter model
## For the straightforward kalman filter, need the data to be evenly spaced
## the test here makes sure they are
diff.is.1<-!1%in%as.numeric(unique(diff(temp$tsyear))>1)
if(diff.is.1){
  my.dat.path<-"/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/cbdkalman/cbdkalman.dat"
  cat("# Number of obs \n", dim(temp)[1], "\n",file = my.dat.path, append=FALSE)
  cat("# section 1 length \n", which(temp$tsyear==cutoff), "\n",file = my.dat.path, append=TRUE)
  cat("# section 2 length \n", (dim(temp)[1]-which(temp$tsyear==cutoff)), "\n",file = my.dat.path, append=TRUE)
  cat("# cutoff \n", cutoff, "\n",file = my.dat.path, append=TRUE)
  cat("# years \n", temp$tsyear, "\n",file = my.dat.path, append=TRUE)
  cat("# Observations \n", log(temp$ssb), "\n",file = my.dat.path, append=TRUE)
  system("cd /home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/cbdkalman; rm cbdkalman.std; ./cbdkalman ")
  if(file.exists("/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/cbdkalman/cbdkalman.std")){
    admb.fit<-get.admb.results("/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/cbdkalman/","cbdkalman")
    par.estimates.1010$mss.slope.before[i]<-admb.fit$value[admb.fit$name=="slope_pre"]
    par.estimates.1010$mss.slope.after[i]<-admb.fit$value[admb.fit$name=="slope_post"]
    par.estimates.1010$mss.slope.diff[i]<-par.estimates.1010$mss.slope.after[i]-par.estimates.1010$mss.slope.before[i]
    state.res<-readLines("/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/cbdkalman/cbdkalman.rep")
    ##state.hat<-admb.fit$value[admb.fit$name=="state"]
    state.hat<-as.numeric(strsplit(state.res[6], split=" ")[[1]])[-c(1,dim(temp)[1]+2)]
  }else{
    par.estimates.1010$mss.slope.before[i]<-NA
    par.estimates.1010$mss.slope.after[i]<-NA
    par.estimates.1010$mss.slope.diff[i]<-NA
    state.hat<-rep(NA, dim(temp)[1])
  }
}else{
  par.estimates.1010$mss.slope.before[i]<-NA
  par.estimates.1010$mss.slope.after[i]<-NA
  par.estimates.1010$mss.slope.diff[i]<-NA
  state.hat<-rep(NA, dim(temp)[1])
}


values <- subset(par.estimates.1010, assessid == a[i])
pre.values <- c(round(values$m.slope.before,3), round(values$mcont.slope.before,3), round(values$mss.slope.before,3))
post.values <- c(round(values$m.slope.after,3), round(values$mcont.slope.after,3), round(values$mss.slope.after,3))

if(!multipanel){par(mfrow=c(2,1),mar=c(1,5,1,2), oma=c(2,2,4,3),lab=c(5,3,7), cex=1)}

lower<- range(log(temp$ssb))[1]
upper<- range(log(temp$ssb))[2]*1.1
if(multipanel){
  with(temp, plot(tsyear,log(ssb),ylim=c(lower,upper), pch=19, col=grey(0.7), ylab='',xlab=''))
  legend("topleft", legend=unique(temp$stockid), bty="n")
  axis(side=1,labels=FALSE, tick=TRUE)
  lines(temp$tsyear[temp$post==0],predict(m,temp[temp$post==0,]),lty=2,col=1)
  lines(temp$tsyear[temp$post==1],predict(m,temp[temp$post==1,]),lty=2,col=1)
  lines(temp$tsyear, predict(mcont), lty=1, col=1)
  lines(temp$tsyear,state.hat, lty="222262")
  abline(v=cutoff, lty=2)
  if(((i/20)-floor(i/20))==0){
    mtext(side=1, line=1.5, text="Year", cex=1.2, outer=TRUE)
    mtext(side=2, line=1.25, text="ln(SSB) (Metric tonnes)", cex=1.2, outer=TRUE)
  }
}else{
  with(temp, plot(tsyear,log(ssb),ylim=c(lower,upper), pch=8,lty=2,type='b',xaxt='n', ylab='log(MT)'))
  mtext(a[i], side=3, outer=TRUE, cex=1.4)
  axis(side=1,labels=FALSE, tick=TRUE)
  lines(temp$tsyear[temp$post==0],predict(m,temp[temp$post==0,]),lty=1,col='blue',lwd=2)
  lines(temp$tsyear[temp$post==1],predict(m,temp[temp$post==1,]),lty=1,col='blue',lwd=2)
  lines(temp$tsyear, predict(mcont), lty=2, col="red", lwd=3)
  lines(temp$tsyear,state.hat, col="seagreen", lwd=3, lty=1)
  abline(v=cutoff, lty=2)
  legend('topleft', legend=pre.values, title='pre-1992 slope value', lty=c(1,2,1), col=c('blue','red','seagreen'), cex=0.5)
  legend('topright', legend=post.values, title='post-1992 slope value', lty=c(1,2,1), col=c('blue','red','seagreen'), cex=0.5)
  plot(temp$tsyear, m$residuals, ylim=range(c(m$residuals, mcont$residuals)),col='blue', xlab='Year', ylab='Residual', pch=20)
  points(temp$tsyear, mcont$residuals, col="red", pch=20)
  points(temp$tsyear, log(temp$ssb)-state.hat, col="seagreen", pch=20)
  abline(h=0,v=cutoff, lty=2)
}
}

par.estimates.1010$m.pre.positive <- ifelse(par.estimates.1010$m.slope.before>=0,1,0)
par.estimates.1010$mcont.pre.positive <- ifelse(par.estimates.1010$mcont.slope.before>=0,1,0)
par.estimates.1010$mss.pre.positive <- ifelse(par.estimates.1010$mss.slope.before>=0,1,0)
par.estimates.1010$m.post.positive <- ifelse(par.estimates.1010$m.slope.after>=0,1,0)
par.estimates.1010$mcont.post.positive <- ifelse(par.estimates.1010$mcont.slope.after>=0,1,0)
par.estimates.1010$mss.post.positive <- ifelse(par.estimates.1010$mss.slope.after>=0,1,0)
dev.off()

q("yes")

## sandbox

c<-which(temp$tsyear==cutoff)
post <- ifelse(temp$tsyear<cutoff, 0, 1)
b1<-par.estimates.1010$mcont.slope.before[par.estimates.1010$stockid=="WHITVIIek"]
b2<-par.estimates.1010$mcont.slope.after[par.estimates.1010$stockid=="WHITVIIek"]
a1<-coef(mcont)[1]
## note the second intercept
a2<-a1+c*(b1-b2)
pred<-(1-post)*(a1+b1*temp$yr)+post*(a2+b2*temp$yr)
with(temp, plot(yr,log(ssb)))
mcont <- lm(log(ssb) ~ yr + post:I(yr-c), data=temp)
lines(temp$yr,predict(mcont))
lines(year,pred, lty=2, lwd=2, col="purple")

## output example data to admb to check

my.dat.path<-"/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/hinge/hinge.dat"
cat("# Number of obs \n", dim(temp)[1], "\n",file = my.dat.path, append=FALSE)
cat("# cutoff \n", c, "\n",file = my.dat.path, append=TRUE)
cat("# years \n", temp$yr, "\n",file = my.dat.path, append=TRUE)
cat("# Observations \n", log(temp$ssb), "\n",file = my.dat.path, append=TRUE)
