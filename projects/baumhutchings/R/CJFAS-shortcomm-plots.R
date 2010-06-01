
##-------
## FITS
##-------


pdf("ts-CJFAS.pdf")

for(i in 1:n) {
  print(i)
temp <- subset(dat, assessid == a[i])
c<-which(temp$tsyear==cutoff)
temp$post <- floor(temp$tsyear/(cutoff+1))
temp$yr <- temp$tsyear - min(temp$tsyear) + 1

##-------
## FITS
##-------

  
values <- subset(par.estimates, assessid == a[i])
pre.values <- c(round(values$m.slope.before,3), round(values$mcont.slope.before,3), round(values$mss.slope.before,3))
post.values <- c(round(values$m.slope.after,3), round(values$mcont.slope.after,3), round(values$mss.slope.after,3))
  
par(mfrow=c(2,1),mar=c(1,5,1,2), oma=c(2,2,4,3),lab=c(5,3,7), cex=1.2)

lower<- range(log(temp$ssb))[1]
upper<- range(log(temp$ssb))[2]*1.1
with(temp, plot(tsyear,log(ssb),ylim=c(lower,upper), pch=8,lty=2,type='b',xaxt='n', ylab='log(MT)')) 
mtext(a[i], side=3, outer=TRUE, cex=1.4)
axis(side=1,labels=FALSE, tick=TRUE)
lines(temp$tsyear[temp$post==0],predict(m,temp[temp$post==0,]),lty=1,col='blue',lwd=2)
lines(temp$tsyear[temp$post==1],predict(m,temp[temp$post==1,]),lty=1,col='blue',lwd=2)
lines(temp$tsyear, predict(mcont), lty=2, col="red", lwd=3)
lines(temp$tsyear,state.hat, col="seagreen", lwd=3, lty=1)
abline(v=cutoff, lty=2)
legend('topleft', legend=pre.values, title='pre-1992 slope value', lty=c(1,2,1), col=c('blue','red','seagreen'))
legend('topright', legend=post.values, title='post-1992 slope value', lty=c(1,2,1), col=c('blue','red','seagreen'))

plot(temp$tsyear, m$residuals, ylim=range(c(m$residuals, mcont$residuals)),col='blue', xlab='Year', ylab='Residual', pch=20)
points(temp$tsyear, mcont$residuals, col="red", pch=20)
points(temp$tsyear, log(temp$ssb)-state.hat, col="seagreen", pch=20)
abline(h=0,v=cutoff, lty=2)

}

dev.off()


