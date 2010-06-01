timeseries.plot <-function(ssb.bool,f.bool,cpue.bool, dat=data.back){
  # plots timeseries data for NCEAS project
  if(ssb.bool){
    plot(dat$YR, dat$SSB, xlab="", ylab="", type='l', lwd=2, cex.lab=1.2)
    mtext(side=1,text="Year", line=2, cex=1.1)
    mtext(side=2,text=paste(ssb.label[,1]," (",ssb.label[,2],")", sep=""), line=2, cex=1.1)
    if(f.bool){
      par(new=TRUE)
      plot(dat$YR, dat$F, type='l', lwd=2, lty=1, col='red', axes=FALSE, xlab="", ylab="")
      axis(side=4)
      mtext(side=4,text=paste(f.label[,1]), line=2, cex=1.1)
    }
    if(cpue.bool){
      par(new=TRUE)
      plot(dat$YR, dat$CPUE, type='l', lwd=1, lty=2, axes=FALSE, xlab="", ylab="")
    }
  }else{
    if(cpue.bool){
      plot(dat$YR, dat$CPUE, xlab="", ylab="", type='l', lwd=2, lty=2, cex.lab=1.2)
      mtext(side=1,text="Year", line=2, cex=1.1)
      mtext(side=2,text=paste(cpue.label[,1]," (",cpue.label[,2],")", sep=""), line=2, cex=1.1)
      if(f.bool){
        par(new=TRUE)
        plot(dat$YR, dat$F, type='l', lwd=2, lty=1, col='red', axes=FALSE, xlab="", ylab="")
        axis(side=4)
        mtext(side=4,text=paste(f.label[,1]), line=2, cex=1.1)
      }
    }else{
      if(f.bool){plot(dat$YR, dat$F, type='l', lwd=2, lty=1, col='red', xlab="", ylab="")
               mtext(side=1,text="Year", line=2, cex=1.1)
               mtext(side=2,text=paste(f.label[,1]), line=2, cex=1.1)
               }else{
        plot(1, type="n",xlab="", ylab="", axes=FALSE)
      }
    }
  }
}
