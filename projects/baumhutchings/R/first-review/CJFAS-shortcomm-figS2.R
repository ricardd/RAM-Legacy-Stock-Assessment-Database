## for revised manuscript
## Time-stamp: <2010-05-21 22:09:16 (srdbadmin)>

## plot the values of the estimates against each other
## CM
## date:
## Timestamp: <Last modified: 17 FEBRUARY 2010  (srdbadmin)>

mtext.fun<-function(xstring,ystring,xline,yline){
  mtext(side=1, text=xstring, line=xline, cex=0.9)
  mtext(side=2, text=ystring, line=yline, cex=0.9, las=3)
}


pdf("CBD-Supp-fig2.pdf", height=8, width=6, title="CJFAS CBD Short Comm. Figure S2")
par(mfrow=c(3,2), mar=c(4,4,0,1), oma=c(0,0,2,2), las=1)
plot(par.estimates.1010$m.slope.before, par.estimates.1010$mcont.slope.before, xlab="", ylab="", pch=1, cex=0.6, col=grey(0.5)); abline(c(0,1),lwd=0.7); abline(h=0, lwd=0.5, col=grey(0.5)); abline(v=0, lwd=0.5, col=grey(0.5))
mtext.fun(xstring="Discontinuous pre-1992",ystring="Continuous pre-1992",xline=2.5,yline=2.5)
plot(par.estimates.1010$m.slope.after, par.estimates.1010$mcont.slope.after, xlab="", ylab="", pch=1, cex=0.6, col=grey(0.5)); abline(c(0,1)); abline(h=0, lwd=0.5, col=grey(0.5)); abline(v=0, lwd=0.5, col=grey(0.5))
mtext.fun(xstring="Discontinuous post-1992",ystring="Continuous post-1992",xline=2.5,yline=2.5)
plot(par.estimates.1010$m.slope.before, par.estimates.1010$mss.slope.before, xlab="", ylab="", pch=1, cex=0.6, col=grey(0.5)); abline(c(0,1)); abline(h=0, lwd=0.5, col=grey(0.5)); abline(v=0, lwd=0.5, col=grey(0.5))
mtext.fun(xstring="Discontinuous pre-1992",ystring="Drift pre-1992",xline=2.5,yline=2.5)
plot(par.estimates.1010$m.slope.after, par.estimates.1010$mss.slope.after, xlab="", ylab="", pch=1, cex=0.6, col=grey(0.5)); abline(c(0,1)); abline(h=0, lwd=0.5, col=grey(0.5)); abline(v=0, lwd=0.5, col=grey(0.5))
mtext.fun(xstring="Discontinuous post-1992",ystring="Drift post-1992",xline=2.5,yline=2.5)
plot(par.estimates.1010$mcont.slope.before, par.estimates.1010$mss.slope.before, xlab="", ylab="", pch=1, cex=0.6, col=grey(0.5)); abline(c(0,1)); abline(h=0, lwd=0.5, col=grey(0.5)); abline(v=0, lwd=0.5, col=grey(0.5))
mtext.fun(xstring="Continuous pre-1992",ystring="Drift pre-1992",xline=2.5,yline=2.5)
plot(par.estimates.1010$mcont.slope.after, par.estimates.1010$mss.slope.after, xlab="", ylab="", pch=1, cex=0.6, col=grey(0.5)); abline(c(0,1)); abline(h=0, lwd=0.5, col=grey(0.5)); abline(v=0, lwd=0.5, col=grey(0.5))
mtext.fun(xstring="Continuous post-1992",ystring="Drift post-1992",xline=2.5,yline=2.5)
dev.off()

