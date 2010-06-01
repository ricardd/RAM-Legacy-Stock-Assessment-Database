stockrecruitment.plot<-function(ssb.bool,r.bool, dat=data.back){
    if(ssb.bool&r.bool){
      plot(dat$SSB, dat$R, pch=21,bg=grey(.7), xlab="",ylab="", ylim=c(0,max(dat$R, na.rm=TRUE)), xlim=c(0,max(dat$SSB, na.rm=TRUE)))
      mtext(side=1,text=paste(ssb.label[,1]," (",ssb.label[,2],")", sep=""), line=2, cex=1.1)
      mtext(side=2,text=paste(r.label[,1]," (",r.label[,2],")", sep=""), line=2, cex=1.1)
      try({ # try finishes on line 137
        # fit Ricker with gamma error using maximum likelihood
        # get starting values from nls
        Ricker.model.nls <- nls(R ~ exp(1)^(p2/p1) * (SSB)*exp(-(SSB)/p1), data=dat, start=c(p1=158900,p2=115000))
        Ricker.model.gam<-ml.rkgam(s=dat$SSB,r=dat$R,ip=c(exp(1)^(coef(Ricker.model.nls)[2]/coef(Ricker.model.nls)[1]),1/coef(Ricker.model.nls)[1]),nu=0.5,max.iter=200)
        # draw the curve in
        drawsrcurve(dat$SSB, pv=Ricker.model.gam$pv, fun=srfrkpv)
        
        #fit Beverton-Holt
        BH.model.nls <- nls(R ~ (alpha * SSB)/ (1 + (beta * SSB)), data=dat, start=c(alpha=2, beta=1E-05))
        BH.model.gam <- ml.bhgam(s=dat$SSB,r=dat$R,ip=c(coef(BH.model.nls)[1],1/coef(BH.model.nls)[2]),nu=0.5,max.iter=200)
        drawsrcurve(dat$SSB, pv=BH.model.gam$pv, fun=srfbhpv, lty=2)
      }, silent=TRUE)
    }else{plot(1, type="n",xlab="", ylab="", axes=FALSE)}
  }

