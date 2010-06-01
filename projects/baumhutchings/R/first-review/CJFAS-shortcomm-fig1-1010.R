# revised R code to address the reviewers' comments for CJFAS CBD short communication
# last modifieds Time-stamp: <2010-05-13 12:31:23 (srdbadmin)>

## Figure 1 for CJFAS Short Comm. paper
## DR, CM
## Time-stamp: <2010-05-12 15:57:47 (srdbadmin)>

plot.CJFASfig1 <- function(est,mod,ord,gro,g,let,offset){
d<-subset(est,geo==g)

# split the data into 2 groups
gr <- paste(mod,".",gro,sep="")
top.panel.data <- subset(d, eval(parse(text=gr)))

ifelse(length(top.panel.data[,1])==0,nodata(),
{
# order data
oo<-paste(mod,".",ord,sep="")
oor<-order(top.panel.data[,oo])

y <- top.panel.data$stockid[oor]
x.mcont.diff <- top.panel.data$mcont.diff[oor]
x.mcont.pre <- top.panel.data$mcont.slope.before[oor]
x.mcont.post <- top.panel.data$mcont.slope.after[oor]
y.idx <- seq(1, length(top.panel.data[,1]))

print(c(g, length(y.idx)))

##plot(x.mcont.diff, y.idx, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", ylim=c(range(y.idx)[1],range(y.idx)[2]), xlim=range(d[,5:11]), xaxt="n")
plot(x.mcont.diff, y.idx, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", ylim=c(range(y.idx)[1],range(y.idx)[2]), xlim=range(top.panel.data[,5:11]), xaxt="n")
axis(side=1)
#title(let)
#mtext(side=3,let,cex=1.5)

##mtext(at=c(range(d[,5:11])[1]+offset,range(y.idx)[2]+1),let,cex=1.5)
#mtext(at=c(range(top.panel.data[,5:11])[1]+offset,range(y.idx)[2]+1),let,cex=1.5)
mtext(at=c(range(top.panel.data[,5:11])[1]+offset,range(y.idx)[2]+1),paste("(",let,")"),cex=0.75)
par(font=1)
points(x.mcont.pre, y.idx, pch=2)
points(x.mcont.post, y.idx, pch=17)


abline(v=0, lty=2)
par(las=1)
axis(side=2, at=y.idx, labels=y, cex.axis=0.5)
#legend("bottomright", pch=c(2,17,17), col=c(1,1,"red"), legend=c("Pre-1992 slope","Post-1992 slope","Difference in slope"))
}
)
} # end of function plot.CJFASfig1


pdf("CJFAS-shortcomm-fig1-1010_v2.pdf")

par(mfrow=c(3,2))
par(mar=c(2,5,2,2), oma=c(3,6,4,3))
plot.CJFASfig1(par.estimates.1010, "mcont", "diff", "pre.positive==0","NWAtl","a",0.03) # 
plot.CJFASfig1(par.estimates.1010, "mcont", "diff", "pre.positive==0","NEAtl","b",0.02) #
plot.CJFASfig1(par.estimates.1010, "mcont", "diff", "pre.positive==0","NorthMidAtl","c",0.02) #
mtext("stock ID",side=2,line=1.5, outer=TRUE,cex=0.75)
plot.CJFASfig1(par.estimates.1010, "mcont", "diff", "pre.positive==0","NEPac","d",0.02) #
plot.CJFASfig1(par.estimates.1010, "mcont", "diff", "pre.positive==0","Aust-NZ","e",0.02) #
plot.CJFASfig1(par.estimates.1010, "mcont", "diff", "pre.positive==0","HighSeas","f",0.012) #
mtext("parameter value",side=1,line=1,outer=TRUE,cex=0.75)
dev.off()

