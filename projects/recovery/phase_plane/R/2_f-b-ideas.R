# to create the plots for /home/srdbadmin/SQLpg/srDB/projects/recovery/phase_plane/tex/phase_plane_analysis.tex
# CM
# date: Sat Dec  6 13:28:04 AST 2008
# Time-stamp: <2008-12-06 17:05:00 (mintoc)>

x<-c(1.5,1.5,0.5,0.5,1.5)
y<-c(0.5,1.5,1.5,0.5,0.5)

pdf("/home/srdbadmin/SQLpg/srDB/projects/recovery/phase_plane/tex/figures/2_pp_simplified.pdf", height=5, width=5)
par(mar=c(5.1, 5.1, 2.1, 2.1))
plot(x,y, xlim=c(0.25,1.75), ylim=c(0.25,1.75), bty="l", type="n", xlab="B/Bmsy", ylab="F/Fmsy", cex.lab=1.1, cex.axis=1.1)
index <- seq(length(x)-1)# one shorter than data
arrows(x[index], y[index], x[index+1], y[index+1], col= 1:4, lwd=1.5)
abline(v=1, h=1,lty=2)
legend("topright", legend="1", bty="n", cex=1.1, text.col=grey(0))
legend("topleft", legend="2", bty="n", cex=1.1, text.col=grey(0))
legend("bottomleft", legend="3", bty="n", cex=1.1, text.col=grey(0))
legend("bottomright", legend="4", bty="n", cex=1.1, text.col=grey(0))
dev.off()
