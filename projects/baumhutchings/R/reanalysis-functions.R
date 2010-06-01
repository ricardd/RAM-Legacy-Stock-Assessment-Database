# 
#
# Last modified Time-stamp: <2009-08-21 11:26:46 (ricardd)>

# first, source("reanalysis-models.R"), so that the data frame "par.estimates" is fresh

# now create a function so that area-specific plots can be produced


nodata<-function(){
plot(0,0,xlab="",ylab="",axes=FALSE,type='n')
text(0,0,"No data available",cex=2)
}

plot.geo <- function(est,ord,gro,g) {
  
filename<-paste(g,"-",gro,".pdf",sep="")
  pdf(filename, height=12, width=12/1.6)
  # keep only region data
d<-subset(est,geo==g)

par(mfrow=c(2,1), mar=c(0,0,0,0), oma=c(5,7,4,3))


# plot non-continuous model
# split the data into 2 groups
gr <- paste("m.",gro,sep="")
top.panel.data <- subset(d, eval(parse(text=gr)))

gr2 <- substring(gro,1,nchar(gro)-1)
gr2 <- ifelse(substring(gro,nchar(gro),nchar(gro))==0, paste("m.",gr2,"1",sep=""),paste("m.",gr2,"0",sep=""))
bottom.panel.data <- subset(d, eval(parse(text=gr2)))

########################
# TOP PANEL
# if no data
ifelse(length(top.panel.data[,1])==0,nodata(),
{
# order data
oo<-paste("m.",ord,sep="")
oor<-order(top.panel.data[,oo])

y <- top.panel.data$stockid[oor]
x.m.diff <- top.panel.data$m.diff[oor]
x.m.pre <- top.panel.data$m.slope.before[oor]
x.m.post <- top.panel.data$m.slope.after[oor]
y.idx <- seq(1, length(top.panel.data[,1]))

plot(x.m.diff, y.idx, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", xlim=range(d[,5:11]), xaxt="n")
par(font=2)
te<-paste(g,"Model with NO continuity constraints",sep=" - ")
mtext(text=te, side=3, outer=TRUE, line=1)
par(font=1)
## values
points(x.m.pre, y.idx, pch=2)
points(x.m.post, y.idx, pch=17)
abline(v=0, lty=2)
par(las=1)

axis(side=2, at=y.idx, labels=y, cex.axis=0.6)
par(las=0)
mtext(text=gro, side=4, outer=FALSE, line=0)
par(las=1)
legend("bottomright", pch=c(2,17,17), col=c(1,1,"red"), legend=c("Pre-1992 slope","Post-1992 slope","Difference in slope"))
}) # end ifelse

########################
# BOTTOM PANEL
# if no data
ifelse(length(bottom.panel.data[,1])==0,nodata(),
{
# order data
oo<-paste("m.",ord,sep="")
oor<-order(bottom.panel.data[,oo])

y <- bottom.panel.data$stockid[oor]
x.m.diff <- bottom.panel.data$m.diff[oor]
x.m.pre <- bottom.panel.data$m.slope.before[oor]
x.m.post <- bottom.panel.data$m.slope.after[oor]
y.idx <- seq(1, length(bottom.panel.data[,1]))

plot(x.m.diff, y.idx, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", xlim=range(d[,5:11]), xaxt="n")
par(font=1)
## values
points(x.m.pre, y.idx, pch=2)
points(x.m.post, y.idx, pch=17)
abline(v=0, lty=2)
par(las=1)

axis(side=2, at=y.idx, labels=y, cex.axis=0.6)
#mtext(text='Temporal abundance slope', side=1, outer=TRUE, line=2)
}) # end ifelse
########################


# plot continuous model
gr <- paste("mcont.",gro,sep="")
top.panel.data <- subset(d, eval(parse(text=gr)))

gr2 <- substring(gro,1,nchar(gro)-1) 
gr2 <- ifelse(substring(gro,nchar(gro),nchar(gro))==0, paste("mcont.",gr2,"1",sep=""),paste("mcont.",gr2,"0",sep=""))
bottom.panel.data <- subset(d, eval(parse(text=gr2)))

########################
# TOP PANEL
# order data
ifelse(length(top.panel.data[,1])==0,nodata(),
{
oo<-paste("mcont.",ord,sep="")
oor<-order(top.panel.data[,oo])

y <- top.panel.data$stockid[oor]
x.m.diff <- top.panel.data$mcont.diff[oor]
x.m.pre <- top.panel.data$mcont.slope.before[oor]
x.m.post <- top.panel.data$mcont.slope.after[oor]
y.idx <- seq(1, length(top.panel.data[,1]))

plot(x.m.diff, y.idx, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", xlim=range(d[,5:11]), xaxt="n")
par(font=2)
te<-paste(g,"Model WITH continuity constraints",sep=" - ")
mtext(text=te, side=3, outer=TRUE, line=1)
par(font=1)
## values
points(x.m.pre, y.idx, pch=2)
points(x.m.post, y.idx, pch=17)
abline(v=0, lty=2)
par(las=1)

axis(side=2, at=y.idx, labels=y, cex.axis=0.6)
par(las=0)
mtext(text=gro, side=4, outer=FALSE, line=0)
par(las=1)
legend("bottomright", pch=c(2,17,17), col=c(1,1,"red"), legend=c("Pre-1992 slope","Post-1992 slope","Difference in slope"))
})

########################
# BOTTOM PANEL
# order data
ifelse(length(bottom.panel.data[,1])==0,nodata(),
{
oo<-paste("mcont.",ord,sep="")
oor<-order(bottom.panel.data[,oo])

y <- bottom.panel.data$stockid[oor]
x.m.diff <- bottom.panel.data$mcont.diff[oor]
x.m.pre <- bottom.panel.data$mcont.slope.before[oor]
x.m.post <- bottom.panel.data$mcont.slope.after[oor]
y.idx <- seq(1, length(bottom.panel.data[,1]))

plot(x.m.diff, y.idx, pch=17, xlab="", ylab="", bty="L", yaxt="n", col="red", xlim=range(d[,5:11]), xaxt="n")
par(font=1)
## values
points(x.m.pre, y.idx, pch=2)
points(x.m.post, y.idx, pch=17)
abline(v=0, lty=2)
par(las=1)

axis(side=2, at=y.idx, labels=y, cex.axis=0.6)
#par(las=0)
#mtext(text=gro, side=4, outer=FALSE, line=0)
par(las=1)
#mtext(text="Temporal abundance slope", side=1, outer=TRUE, line=2)
})
########################

dev.off()
} # end function


# plot NWAtl data, grouped by post-1992 positive and negative slopes, each panel order by difference in slopes, etc

plot.geo(par.estimates, "diff", "post.positive==1","NWAtl") # 
plot.geo(par.estimates, "diff", "post.positive==1","NEAtl") #
plot.geo(par.estimates, "diff", "post.positive==1","NEPac") # 
plot.geo(par.estimates, "diff", "post.positive==1","Aust-NZ")
#plot.geo(par.estimates, "diff", "post.positive==1","NorthMidAtl") # 
#plot.geo(par.estimates, "diff", "post.positive==1","SAfr")

plot.geo(par.estimates, "diff", "pre.positive==0","NWAtl") # 
plot.geo(par.estimates, "diff", "pre.positive==0","NEAtl") #
plot.geo(par.estimates, "diff", "pre.positive==0","NEPac") # 
plot.geo(par.estimates, "diff", "pre.positive==0","NorthMidAtl") # 
plot.geo(par.estimates, "diff", "pre.positive==0","Aust-NZ") # 
#plot.geo(par.estimates, "diff", "pre.positive==0","SAfr")
