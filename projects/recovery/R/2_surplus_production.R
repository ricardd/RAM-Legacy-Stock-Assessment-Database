# analyse sr data from a surplus production perspective
# Cóilín Minto
# date: Wed Dec 17 12:44:44 AST 2008
# Time-stamp: <2008-12-23 17:20:12 (mintoc)>
# set up the Schaefer model

r<-.3
k<-100
n.series<-50
time<-seq(1,n.series)
# biomass vectors
true.biomass<-NULL
obs.biomass<-NULL
catch<-NULL
exploit.rate<-c(seq(0.1,0.2, length=n.series/2),
                rev(seq(0.1,0.2, length=n.series/2)))
sd.norm<-10
true.biomass[1]<-100
obs.biomass[1]<-rnorm(1, mean=true.biomass[1], sd=sd.norm)
# generate some data
for(t in 1:(n.series-1)){
  # need to seperate the process error from the dynamics
  # i.e. generate the prediction, then add the noise
  # use the prediction in the next year (rather than observation)
  catch[t]<-exploit.rate[t]*true.biomass[t]
  #mean.B.lnorm<-log(B[t]+r*B[t]*(1-B[t]/k)-C[t])
  #B[t+1]<-rlnorm(1, meanlog=mean.B.lnorm, sdlog=sd.log)
  true.biomass[t+1]<-true.biomass[t]+r*true.biomass[t]*(1-true.biomass[t]/k)-catch[t]
  obs.biomass[t+1]<-rnorm(1, mean=true.biomass[t+1], sd=sd.norm)
}

plot(time, obs.biomass, ylim=c(0,1.1*max(obs.biomass)), type="b", bty="n", pch=19, col=grey(0.6))
lines(time, true.biomass, lwd=2, col="green")

catch<-c(catch, NA) # no catch in final year here
bio.dyn.df<-data.frame(bt=obs.biomass,bt1=c(obs.biomass[-1],NA),ct=catch)

# glm fit
# check this
glm.bio.dyn.fit<-with(bio.dyn.df, glm(I(bt1/bt)~bt, offset=(1 - ct/bt), family=gaussian(link="identity")))
glm.r.hat<-coef(glm.bio.dyn.fit)[1]
glm.k.hat<-glm.r.hat/(-coef(glm.bio.dyn.fit)[2])

glm.pred.b<-NULL
glm.pred.b[1]<-mean(B[1]) # what should you do for the first value?

for(t in 1:(n.series-1)){
   glm.pred.b[t+1]<-glm.pred.b[t]+glm.r.hat*glm.pred.b[t]*(1-glm.pred.b[t]/glm.k.hat)-catch[t]
}
lines(time,glm.pred.b, type="l", lwd=2, col="red")

# nls fit
nls.bio.dyn.fit<-nls(I(bt1/bt)~r-r/k*bt-(ct/bt-1), data=bio.dyn.df, start=list(r=1, k=50), trace=TRUE, control=list(maxiter=1000))
nls.bio.dyn.fit<-nls(bt1~bt+r*bt*(1-bt/k)-ct, data=bio.dyn.df, start=list(r=1, k=50), trace=TRUE, control=list(maxiter=1000))
nls.r.hat<-coef(nls.bio.dyn.fit)[1]
nls.k.hat<-coef(nls.bio.dyn.fit)[2]
# estimates for both r and k are poor here?
nls.pred.b<-NULL
nls.pred.b[1]<-B[1]

for(t in 1:(n.series-1)){
   nls.pred.b[t+1]<-nls.pred.b[t]+nls.r.hat*nls.pred.b[t]*(1-nls.pred.b[t]/nls.k.hat)-catch[t]
}
lines(time,nls.pred.b, type="l", lwd=2, col="blue")
# nls fit tracks closer to the true than glm fit for normal error structure

plot(acf(resid(nls.bio.dyn.fit))) # significant correlation in residuals at 1 lag
plot(acf(resid(glm.bio.dyn.fit)))



# sandbox code ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
exp(coef(glm.bio.dyn.fit)[1]+var(glm.bio.dyn.fit$residuals)/2)

actual.b<-NULL
actual.b[1]<-B[1]
for(t in 1:(n.series-1)){
   actual.b[t+1]<-actual.b[t]+r*actual.b[t]*(1-actual.b[t]/k)-catch[t]
}
lines(time,actual.b, type="l", lwd=2, col="turquoise")
