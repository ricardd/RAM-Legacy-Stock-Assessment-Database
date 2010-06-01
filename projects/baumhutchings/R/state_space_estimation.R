##-------------------------------------------
## Fit the biomass series with a slope before
## and a slope after
## CM, DR
## date: Tue Jan 12 09:35:09 AST 2010
## Time-stamp: <Last modified: 12 JANUARY 2010  (mintoc)>
##-------------------------------------------

my.dat<-subset(dat,assessid=="DFO-QUE-COD3Pn4RS-1964-2007-PREFONTAINE")
cutoff <- 1992

my.dat.path<-"/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/localleveltrend/localleveltrend.dat"
cat("# Number of obs \n", dim(my.dat)[1], "\n",file = my.dat.path, append=FALSE)
cat("# Cut off \n", cutoff, "\n",file = my.dat.path, append=TRUE)
cat("# years \n", my.dat$tsyear, "\n",file = my.dat.path, append=TRUE)
cat("# Observations \n", log(my.dat$ssb), "\n",file = my.dat.path, append=TRUE)

source("./functions/get_admb_results.R")
admb.fit<-get.admb.results("/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/localleveltrend/","localleveltrend")
state.hat<-admb.fit$value[admb.fit$name=="state"]
pre.slope.hat<-admb.fit$value[admb.fit$name=="slope_pre"]
post.slope.hat<-pre.slope.hat+admb.fit$value[admb.fit$name=="delta_slope_post"]

with(my.dat,plot(tsyear,log(ssb), type = 'l', col = "seagreen"))
lines(my.dat$tsyear,state.hat, col = "brown", type="l")
legend("top", legend=c(paste("Pre slope:",pre.slope.hat),paste("Post slope:",post.slope.hat)), horiz=TRUE, bty="n")
legend("bottomright", legend=c("Observed", "Estimated state"), lty=c(1,1), col=c("seagreen","brown"), bty="n")
abline(v=cutoff, lty=2)





##---------
## sandbox
##---------
## generate some data
obs.sd<-0.2
proc.sd<-0.2
T<-50
cut.off<-25
X<-rep(NA,T)
X[1]<-10
slope.pre<--0.1
delta.slope.post<-0.2
for(i in 2:T){
  print(i)
  if(i<=cut.off){
    X[i]<-rnorm(1, mean=X[i-1]+slope.pre, sd=proc.sd)
  }
  if(i>cut.off){
    X[i]<-rnorm(1, mean=X[i-1]+(slope.pre+delta.slope.post), sd=proc.sd)
  }
}
y<-rnorm(T, mean=X, sd=obs.sd)
plot(X, type = 'l', col = "seagreen")
points(y, col = "seagreen")

## output the data to ADMB
my.dat.path<-"/Users/mintoc/docs/analyses/sr/projects/baumhutchings/admb/localleveltrend/localleveltrend.dat"
cat("# Number of obs \n", T, "\n",file = my.dat.path, append=FALSE)
cat("# Cut off \n", cut.off, "\n",file = my.dat.path, append=TRUE)
cat("# years \n", seq(1,T), "\n",file = my.dat.path, append=TRUE)
cat("# Observations \n", c(y), "\n",file = my.dat.path, append=TRUE)


## read in ADMB results
source("./functions/get_admb_results.R")
admb.fit<-get.admb.results("/Users/mintoc/docs/analyses/sr/projects/baumhutchings/admb/localleveltrend/","localleveltrend")
state.hat<-admb.fit$value[admb.fit$name=="state"]
pre.slope.hat<-admb.fit$value[admb.fit$name=="slope_pre"]
post.slope.hat<-pre.slope.hat+admb.fit$value[admb.fit$name=="delta_slope_post"]

plot(y, type = 'l', col = "seagreen")
points(state.hat, col = "brown", type="l")
legend("top", legend=c(paste("Pre slope:",pre.slope.hat),paste("Post slope:",post.slope.hat)), horiz=TRUE, bty="n")
legend("bottomright", legend=c("Observed", "Estimated state"), lty=c(1,1), col=c("seagreen","brown"), bty="n")
abline(v=cut.off, lty=2)

