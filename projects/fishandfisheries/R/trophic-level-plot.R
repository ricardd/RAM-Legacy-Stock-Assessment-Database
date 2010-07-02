##
##
## Last modified Time-stamp: <2010-06-30 15:11:44 (srdbadmin)>
##
setwd("/home/srdbadmin/srdb/projects/fishandfisheries/R")

require(beanplot)
require(RODBC)

tl.data.pinsky <- read.csv("lh2010-06-24.csv", header=TRUE)
tl.data.pinsky$scientificname <- tl.data.pinsky$spp

tl.data <- read.csv("BRANCH-Assessment-TLs-v4.csv", header=TRUE)
chan<- odbcConnect(dsn="srdbcalo")
## sqlSave(chan, tl.data, tablename="srdb.trophiclevel",safer=FALSE)

qu <- paste("select a.assessid, t.scientificname from srdb.assessment a, srdb.stock s, srdb.taxonomy t where a.stockid=s.stockid and s.tsn=t.tsn and a.recorder != 'MYERS' and a.assess=1")
sci.names <- sqlQuery(chan, qu)

crosshair.tl <- read.table("crosshair.dat")


crosshair.tl$quadrant[crosshair.tl$b.ratio<1 & crosshair.tl$u.ratio>1] <- 1
crosshair.tl$quadrant[crosshair.tl$b.ratio>1 & crosshair.tl$u.ratio>1] <- 2
crosshair.tl$quadrant[crosshair.tl$b.ratio<1 & crosshair.tl$u.ratio<1] <- 3
crosshair.tl$quadrant[crosshair.tl$b.ratio>1 & crosshair.tl$u.ratio<1] <- 4

crosshair.m <- merge(crosshair.tl, sci.names, "assessid")
crosshair.merged <- merge(crosshair.m, tl.data, "scientificname")

crosshair.merged.pinsky <- merge(crosshair.m, tl.data.pinsky, "scientificname")


nn <- range(crosshair.merged$TL)[1]

delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:MINTL'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:MINTL',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

nn <- range(crosshair.merged$TL)[2]
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:MAXTL'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:MAXTL',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

nn <- mean(crosshair.merged$TL)
  nn <- round(nn,2)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:MEANTL'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:MEANTL',",nn,")",sep="" )
sqlQuery(chan,insert.qu)


nn<- dim(crosshair.merged)[[1]]
## crosshair.tl$TL <- rnorm(nn, 4,0.7) ## NEED FISHBASE DATA HERE

odbcClose(chan)


n1 <- dim(crosshair.merged[crosshair.merged$quadrant==1,])[1]
n2 <- dim(crosshair.merged[crosshair.merged$quadrant==2,])[1]
n3 <- dim(crosshair.merged[crosshair.merged$quadrant==3,])[1]
n4 <- dim(crosshair.merged[crosshair.merged$quadrant==4,])[1]


pdf("TL-quadrant-srdb.pdf", width=8, height=10)
#beanplot(TL~quadrant,data=crosshair.merged,horizontal=FALSE,xlab="",ylab="Mean trophic level",col = c(gray(0.7),"white","black",gray(0.1)), show.names=FALSE)

boxplot(TL~quadrant,data=crosshair.merged,xlab="",ylab="Mean trophic level", varwidth=TRUE, names=FALSE)

par(las=1)
mtext(bquote(italic("Below Bmsy")), side=1, outer = FALSE, line=1,at=1)
mtext(bquote(italic("Above Umsy")), side=1, outer = FALSE, line=2,at=1)
mtext(paste("n=",n1,sep=""), side=1, outer = FALSE, line=3,at=1)

mtext(bquote(italic("Above Bmsy")), side=1, outer = FALSE, line=1,at=2)
mtext(bquote(italic("Above Umsy")), side=1, outer = FALSE, line=2,at=2)
mtext(paste("n=",n2,sep=""), side=1, outer = FALSE, line=3,at=2)

mtext(bquote(italic("Below Bmsy")), side=1, outer = FALSE, line=1,at=3)
mtext(bquote(italic("Below Umsy")), side=1, outer = FALSE, line=2,at=3)
mtext(paste("n=",n3,sep=""), side=1, outer = FALSE, line=3,at=3)

mtext(bquote(italic("Above Bmsy")), side=1, outer = FALSE, line=1,at=4)
mtext(bquote(italic("Below Umsy")), side=1, outer = FALSE, line=2,at=4)
mtext(paste("n=",n4,sep=""), side=1, outer = FALSE, line=3,at=4)
dev.off()



topright <- data.frame(type=rep("topright",50), value = rnorm(50,3,0.7))
topleft <- data.frame(type=rep("topleft",50), value = rnorm(50,4,0.7))
bottomright <- data.frame(type=rep("bottomright",50), value = rnorm(50,4,0.9))
bottomleft <- data.frame(type=rep("bottomleft",50), value = rnorm(50,4.2,0.5))

for.bean <- rbind(topright,topleft,bottomright,bottomleft)
pdf("TL-quadrant.pdf", width=8, height=10)
beanplot(value~type,data=for.bean,horizontal=FALSE,xlab="",ylab="Mean trophic level",col = c(gray(0.7),"white","black",gray(0.1)), show.names=FALSE)
par(las=1)
mtext(bquote(italic("Above Bmsy")), side=1, outer = FALSE, line=1,at=1)
mtext(bquote(italic("Above Umsy")), side=1, outer = FALSE, line=2,at=1)

mtext(bquote(italic("Below Bmsy")), side=1, outer = FALSE, line=1,at=2)
mtext(bquote(italic("Above Umsy")), side=1, outer = FALSE, line=2,at=2)

mtext(bquote(italic("Above Bmsy")), side=1, outer = FALSE, line=1,at=3)
mtext(bquote(italic("Below Umsy")), side=1, outer = FALSE, line=2,at=3)

mtext(bquote(italic("Below Bmsy")), side=1, outer = FALSE, line=1,at=4)
mtext(bquote(italic("Below Umsy")), side=1, outer = FALSE, line=2,at=4)

dev.off()


below <- data.frame(type=rep("below",50), value = rnorm(50,4,0.7))
above <- data.frame(type=rep("above",50), value = rnorm(50,3,0.9))

for.bean <- rbind(below,above)

pdf("TL.pdf", width=8, height=10)
beanplot(value~type,data=for.bean,horizontal=FALSE,xlab="",ylab="Mean trophic level",col = c(gray(0.7),"white","black",gray(0.1)), show.names=FALSE)
par(las=1)
mtext(bquote(italic("Below MSY")), side=1, outer = FALSE, line=1,at=1)
mtext(bquote(italic("Above MSY")), side=1, outer = FALSE, line=1,at=2)
dev.off()
