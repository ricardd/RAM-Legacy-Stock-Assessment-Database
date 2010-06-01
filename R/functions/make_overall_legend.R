# make legend for sr document
# CM, Tue Oct 21 15:08:40 ADT 2008
# Time-stamp: <2008-10-21 15:47:41 (mintoc)>

pdf("/home/ricardd/linux_sync_folder/SQL/SQLpg/srDB/R/report_legend.pdf", height=6, width=8)
par(mfrow=c(2,2), mar=c(0,0,0,0), oma=c(0,0,0,0))
  # time series plot
  plot(1, type="n", axes=FALSE,xlab="", ylab="")
  legend("center", legend=c("Spawning stock biomass","F","Catch per unit effort"), lty=c(1,1,2),lwd=c(2,2,1),col=c(1,"red", 1),bty="n", cex=1.5)
  par(font=2);mtext(side=3, text="Time series", cex=1.2, line=-3);par(font=1)
  # stock-recruitment plot
  plot(1, type="n", axes=FALSE,xlab="", ylab="")
  legend("center", legend=c("Ricker","Beverton-Holt"), lty=c(1,2),lwd=c(1,1),col=c(1, 1),bty="n", cex=1.5)
  par(font=2);mtext(side=3, text="Stock-recruit", cex=1.2, line=-3);par(font=1)
  # phase-plane plot
  plot(1, type="n", axes=FALSE,xlab="", ylab="")
  f.legend.line.x<-seq(0.67,0.76, length=30)+.02
  f.legend.line.y<-rep(1.03, length(f.legend.line.x))
  legend.col<-red.palette(length(f.legend.line.x))
  arrows(x0=f.legend.line.x[-length(f.legend.line.x)],x1=f.legend.line.x[-1],y0=f.legend.line.y[-length(f.legend.line.x)],y1=f.legend.line.y[-1],col=legend.col,lwd=3,length=0)
  legend("center", legend=c("F-SSB trajectory\n(darker is later)","Labeled Reference points"), lty=c(1,2),lwd=c(0,1),col=c(0, 1),bty="n", cex=1.5, bg="transparent")
  par(font=2);mtext(side=3, text="SSB-F", cex=1.2, line=-3);par(font=1)
  # catches
  plot(1, type="n", axes=FALSE,xlab="", ylab="")
  legend("center", legend=c("Total landings","Total catch"), lty=c(4,5),lwd=c(1,1),col=c(1, 1),bty="n", cex=1.5)
  par(font=2);mtext(side=3, text="Catch/landings", cex=1.2, line=-3);par(font=1)
dev.off()
