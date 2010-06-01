catches.plot<-function(tl.bool,tc.bool, dat=data.back){
  # plot the landings and catch data
  if(tl.bool&tc.bool){
    # plot total landings
    plot(dat$YR, dat$TL, type="l", xlab="", ylab="", lty=4, cex.lab=1.2)
    mtext(side=1,text="Year", line=2, cex=1.1)
    mtext(side=2,text=paste(tl.label[,1]," (",tl.label[,2],")", sep=""), line=2, cex=1.1)
    # plot total catch
    par(new=TRUE)
    plot(dat$YR, dat$TC, type="l",yaxt="n", xaxt="n", lty=5, cex.lab=1.2)
    axis(side=4)
    mtext(side=4, text=paste(tc.label[,1]," (",tc.label[,2],")", sep=""), line=2)
  }else{
    if(tl.bool){
      plot(dat$YR, dat$TL, type="l", xlab="", ylab="", lty=4, cex.lab=1.2)
      mtext(side=1,text="Year", line=2, cex=1.1)
      mtext(side=2,text=paste(tl.label[,1]," (",tl.label[,2],")", sep=""), line=2, cex=1.1)
    }else{
      if(tc.bool){plot(dat$YR, dat$TC, type="l", xlab="", ylab="", lty=5, cex.lab=1.2)
                  mtext(side=1,text="Year", line=2, cex=1.1)
                  mtext(side=2,text=paste(tc.label[,1]," (",tc.label[,2],")", sep=""), line=2, cex=1.1)
                }else{
                  plot(1, type="n",xlab="", ylab="", axes=FALSE)
                }
    }
  }
}
