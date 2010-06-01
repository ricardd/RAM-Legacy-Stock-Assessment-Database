# plot the phase plane with time-dependent color
# original code by Trevor Branch
# modified by Coilin Minto
# date: Mon Nov 17 09:28:04 AST 2008
# Time-stamp: <2008-11-17 09:30:55 (mintoc)>

F.vs.B.scaled <- function(B,F,Bref,Fref,lwd=2,arrow.len=0) {
  # Trevor Branch's code to plot F versus B 
    ExplRate <- F
    excl <- is.na(B) | is.na(ExplRate)
    B <- B[!excl]/Bref
    ExplRate <- ExplRate[!excl]/Fref
    if (length(B) > 0) {
      nrec <- length(B)
      # generate a palette for plotting, could do this outside func.
      red.palette<-colorRampPalette(c("yellow", "orange", "red"))
      plot.colors <- red.palette(nrec)
      xlim <- c(0,1.05*max(B,na.rm=T))
      ylim <- c(0,1.1*max(ExplRate,na.rm=T))
      #clunky way of plotting nothing but getting xlim and ylim correct for arrows
      plot(B,ExplRate,type="n",lty=1,lwd=2, bty="l", xlab="B/Bmsy", ylab="F/Fmsy", xlim=c(0,1.1*max(B)), ylim=c(0,1.1*max(ExplRate)))
      par(new=T)
      arrows(x0=B[-nrec],x1=B[-1],y0=ExplRate[-nrec],y1=ExplRate[-1],col=plot.colors,lwd=lwd,length=arrow.len)
      # segments would also work, add arrow for last year
      arrows(x0=B[nrec-1],x1=B[nrec],y0=ExplRate[nrec-1],y1=ExplRate[nrec],col=plot.colors[nrec],lwd=lwd,length=.1)
    }
  }
