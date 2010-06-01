## plot the values of the estimates against each other
## CM
## date:
## Time-stamp: <Last modified: 16 FEBRUARY 2010  (srdbadmin)>

mtext.fun<-function(xstring,ystring,xline,yline){
  mtext(side=1, text=xstring, line=xline, cex=1.2)
  mtext(side=2, text=ystring, line=yline, cex=1.2)
}

##pdf("measureonly-compare-plot.pdf", height=8, width=6)
pdf("CBD-method-comparison-plot.pdf", height=8, width=6)
par(mfrow=c(3,2), mar=c(4,4,0,0), oma=c(0,0,2,2))
plot(par.estimates$m.slope.before, par.estimates$mcont.slope.before, xlab="", ylab=""); abline(c(0,1))
mtext.fun(xstring="Discontinuous pre-1992",ystring="Continuous pre-1992",xline=2.5,yline=2)
plot(par.estimates$m.slope.after, par.estimates$mcont.slope.after, xlab="", ylab=""); abline(c(0,1))
mtext.fun(xstring="Discontinuous post-1992",ystring="Continuous post-1992",xline=2.5,yline=2)
plot(par.estimates$m.slope.before, par.estimates$mss.slope.before, xlab="", ylab=""); abline(c(0,1))
mtext.fun(xstring="Discontinuous pre-1992",ystring="State space pre-1992",xline=2.5,yline=2)
plot(par.estimates$m.slope.after, par.estimates$mss.slope.after, xlab="", ylab=""); abline(c(0,1))
mtext.fun(xstring="Discontinuous post-1992",ystring="State space post-1992",xline=2.5,yline=2)
plot(par.estimates$mcont.slope.before, par.estimates$mss.slope.before, xlab="", ylab=""); abline(c(0,1))
mtext.fun(xstring="Continuous pre-1992",ystring="State space pre-1992",xline=2.5,yline=2)
plot(par.estimates$mcont.slope.after, par.estimates$mss.slope.after, xlab="", ylab=""); abline(c(0,1))
mtext.fun(xstring="Continuous post-1992",ystring="State space post-1992",xline=2.5,yline=2)
dev.off()

##system("xpdf measureonly-compare-plot.pdf")
system("xpdf CBD-method-comparison-plot.pdf")

pdf("CBD-method-comparison-plot-1010.pdf", height=8, width=6)
par(mfrow=c(3,2), mar=c(4,4,0,0), oma=c(0,0,2,2))
plot(par.estimates.1010$m.slope.before, par.estimates.1010$mcont.slope.before, xlab="", ylab=""); abline(c(0,1))
mtext.fun(xstring="Discontinuous pre-1992",ystring="Continuous pre-1992",xline=2.5,yline=2)
plot(par.estimates.1010$m.slope.after, par.estimates.1010$mcont.slope.after, xlab="", ylab=""); abline(c(0,1))
mtext.fun(xstring="Discontinuous post-1992",ystring="Continuous post-1992",xline=2.5,yline=2)
plot(par.estimates.1010$m.slope.before, par.estimates.1010$mss.slope.before, xlab="", ylab=""); abline(c(0,1))
mtext.fun(xstring="Discontinuous pre-1992",ystring="State space pre-1992",xline=2.5,yline=2)
plot(par.estimates.1010$m.slope.after, par.estimates.1010$mss.slope.after, xlab="", ylab=""); abline(c(0,1))
mtext.fun(xstring="Discontinuous post-1992",ystring="State space post-1992",xline=2.5,yline=2)
plot(par.estimates.1010$mcont.slope.before, par.estimates.1010$mss.slope.before, xlab="", ylab=""); abline(c(0,1))
mtext.fun(xstring="Continuous pre-1992",ystring="State space pre-1992",xline=2.5,yline=2)
plot(par.estimates.1010$mcont.slope.after, par.estimates.1010$mss.slope.after, xlab="", ylab=""); abline(c(0,1))
mtext.fun(xstring="Continuous post-1992",ystring="State space post-1992",xline=2.5,yline=2)
dev.off()

system("okular CBD-method-comparison-plot-1010.pdf")
