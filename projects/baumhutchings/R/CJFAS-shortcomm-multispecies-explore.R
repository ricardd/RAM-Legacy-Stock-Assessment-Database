##-----------------------------------------------------------
## CM
## code to explore the changes in the indices
## we subtract off the mean on the log scale,
## how much can this affect the percentage declines
## date: Tue Feb  9 08:05:59 AST 2010
## Time-stamp: <Last modified: 9 FEBRUARY 2010  (srdbadmin)>
##-----------------------------------------------------------

temp.dat<-subset(dat, stockid=="TIGERFLATSE")
## change from the first five years to the last five
temp.n<-dim(temp.dat)[1]
mean(temp.dat$ssb[(temp.n-4):temp.n])/mean(temp.dat$ssb[1:5])

## now de-mean
temp.dat$index<-log(temp.dat$ssb)-mean(log(temp.dat$ssb))
temp.dat$expindex<-exp(temp.dat$index)

par(mfrow=c(3,1), mar=c(2,2,2,2))
with(temp.dat,plot(tsyear,ssb, type="l"))
with(temp.dat,plot(tsyear,index, type="l"))
with(temp.dat,plot(tsyear,expindex, type="l"))

mean(temp.dat$expindex[(temp.n-4):temp.n])/mean(temp.dat$expindex[1:5])

## which is the same as on the original scale

