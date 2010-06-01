# a function to simulate and plot F-Biomass data from Schaefer model
# CM
# date: Wed Nov 12 10:39:21 AST 2008
# Time-stamp: <2008-12-06 13:16:17 (mintoc)>

# source("/home/ricardd/linux_sync_folder/SQL/SQLpg/srDB/projects/recovery/phase_plane/R/functions/FvsB_func.R")

schaefer.sim.func<-function(r, k, f.max, n.years, cycles){
  # make sure F.vs.B.scaled function is loaded in workspace
  # r is growth rate
  # k is carrying capacity
  # f.max is the maximum fishing mortality
  # n.years is timeseries length
  # cycles is how many times f goes up and down

  # fishing mortality vector
  f.vec<- NULL
  # biomass vector
  b.vec<-NULL

  # time
  years<-seq(1,n.years)

  # initialize vectors
  # for fishing mortality, goal is to provide up/down scenario, here sine wave used
  # could use other functions such as quadratic
  # the period is 2*pi/angular_frequency
  # to get one up down over 50 years have a cycle per 100 year period
  angular.freq<-cycles*2*pi/(n.years)
  amplitude<-f.max/2 
  f.vec<-amplitude*sin(angular.freq*years)+amplitude # +.5 for positive
  # plot(years,f.vec)
  # dynamics according discrete Schaefer, deterministic for now
  # see Hilborn and Walters (1992) third edition (2001), chapter 8
  # "Biomass Dynamic Models"
  b.vec[1]<-k # change and look at the dynamics
  # note F enters as F*biomass
  for(i in 2:n.years){
    b.vec[i]<-b.vec[i-1]+r*b.vec[i-1]*(1-b.vec[i-1]/k)-f.vec[i-1]*b.vec[i-1]
  }
  # reference points
  # by definition
  bmsy<-r*k/4
  fmsy<-r/2

  # plot the timeseries
  par(mfrow=c(2,1), mar=c(4,4,1,4))
  plot(seq(1:n.years), b.vec, type="l", col="blue", lwd=1.5, xlab="Time (years)", ylab="Biomass", bty="l", ylim=c(0, 1.1*max(b.vec, na.rm=TRUE)))
  # add reference point
  abline(h=bmsy, lwd=1.5, col="blue", lty=2)
  par(new=TRUE)
  plot(seq(1:n.years), f.vec, type="l", col="red", lwd=1.5, axes=FALSE, xlab="", ylab="", ylim=c(0, 1.1*max(f.vec)))
  axis(side=4)
  # add reference point
  abline(h=fmsy, lwd=1.5, col="red", lty=2)
  mtext(side=4, text="Fishing mortality", line=2)
  legend("topright", legend=c("F", "Biomass", "Fmsy", "Bmsy"), lty=c(1,1,2,2), col=c("red","blue","red","blue"), lwd=c(1.5,1.5,1.5,1.5), bty="n", horiz=TRUE)
  # plot the phase-plane
  F.vs.B.scaled(B=b.vec,"F"=f.vec, Bref=bmsy, Fref=fmsy, lwd=2, arrow.len=0)
  # add in 1:1 lines
  abline(h=1,v=1, lty=2, lwd=1.5)
}

# a call and plot
pdf("/home/srdbadmin/SQLpg/srDB/projects/recovery/phase_plane/tex/figures/1_simulated_f_b.pdf", height=7, width=9)
schaefer.sim.func(r=0.6,k=1000,f.max=0.8, n.years=50,cycles=2)
dev.off()
