F.vs.SSB <- function(ssb.bool,f.bool,lwd=2,arrow.len=0, dat=data.back) {
  # Trevor Branch's code to plot F versus SSB 
  if(ssb.bool&f.bool){
    SSB <- dat$SSB
    ExplRate <- dat$F
    excl <- is.na(SSB) | is.na(ExplRate)
    SSB <- SSB[!excl]
    ExplRate <- ExplRate[!excl]
    if (length(SSB) > 0) {
      nrec <- length(SSB)
      red.palette<-colorRampPalette(c("yellow", "orange", "red"))
      plot.colors <- red.palette(nrec)#topo.colors(nrec)
      #plot.colors <- rainbow(nrec)
      xlim <- c(0,1.05*max(SSB,na.rm=T))
      ylim <- c(0,1.1*max(ExplRate,na.rm=T))
      #clunky way of plotting nothing but getting xlim and ylim correct for arrows
      plot(SSB,ExplRate,type="l",xlim=xlim,ylim=ylim,lty=1,lwd=2, xlab="", ylab="")
      par(new=T)
      arrows(x0=SSB[-nrec],x1=SSB[-1],y0=ExplRate[-nrec],y1=ExplRate[-1],col=plot.colors,lwd=lwd,length=arrow.len)
      par(new=T)
      plot(SSB[1],ExplRate[1],type="p",cex=2,pch=21,col="black",bg="white",yaxs="r",axes=FALSE,xlab="",ylab="",xlim=xlim,ylim=ylim)
      par(new=T)
      plot(SSB[nrec],ExplRate[nrec],type="p",cex=2,pch=21,col="black",bg="black",xlim=xlim,ylim=ylim,xaxs="i",yaxs="r",axes=FALSE,xlab="",ylab="")
      box()
      mtext(side=1,paste(ssb.label[,1]," (",ssb.label[,2],")", sep=""),line=2,cex=1.2)
      mtext(side=2,paste(f.label[,1]),line=2,cex=1.2)
      # add in reference points, if they are stored
      if(bref.bool){abline(v=as.numeric(b.ref[,2]), lty=2)
                  text(x=as.numeric(b.ref[,2]), y=.75*max(F), labels=as.character(b.ref[,1]))}
      if(fref.bool){abline(h=as.numeric(f.ref[,2]), lty=2)
                   text(y=as.numeric(f.ref[,2]), x=.75*max(SSB), labels=as.character(f.ref[,1]))}
    }}else(plot(1, type="n",xlab="", ylab="", axes=FALSE))
}
