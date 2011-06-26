##
## Julia suggests: Another way to split out the fried egg plots, which I think many readers will be interested in, is by trophic level (e.g. we could break trophic level into categories by every 0.5 e.g. 2-2.5, 2.5-3.0, 3.0-3.5 etc).
setwd("/home/srdbadmin/srdb/projects/fishandfisheries/R/first-review/")
source("friedegg-fct.R")

require(RODBC)
chan <- odbcConnect(dsn='srdbcalo')

## MTLs
qu <- paste("select s.stockid, t.scientificname, m.mytltl from srdb.fishbasemtl m, srdb.taxonomy t, srdb.stock s where t.scientificname=m.mytlscientificname and t.tsn=s.tsn", sep="")
my.mtl <- sqlQuery(chan,qu)

##my.mtl$MTLgroup <- ifelse(my.mtl$mytltl>=4.5,"MTL>=4.5",ifelse(my.mtl$mytltl>=4,"4.0<=MTL<4.5",ifelse(my.mtl$mytltl>=3.5,"3.5<=MTL<4.0",ifelse(my.mtl$mytltl>=3.0,"3.0<=MTL<3.5",ifelse(my.mtl$mytltl>=2.5,"2.5<=MTL<3.0",ifelse(my.mtl$mytltl>=2.0,"2.0<=MTL<2.5","MTL<2"))))))

my.mtl$MTLgroup <- ifelse(my.mtl$mytltl>=4,"MTL>=4.0",ifelse(my.mtl$mytltl>=3,"3.0<=MTL<4.0",ifelse(my.mtl$mytltl>=2,"2.0<=MTL<3.0","MTL<2")))


# plots
pdf("friedegg-MTLs.pdf", width=11, height=11/1.85)
par(mar=c(4,4,1,2),oma=c(4,4,1,2),mfrow=c(1,3))

## stocks with MTL between 2.0 and 3.0
ss.mtl <- subset(my.mtl, MTLgroup=="2.0<=MTL<3.0")$stockid
my.ss <- paste("(", capture.output(cat(paste("'",as.character(ss.mtl),"'",sep=""), sep=",")), ")", sep="")
#fried.egg.fct("stock",my.ss,"2MTL3","FALSE","TRUE","2.0<=MTL<3.0","TRUE")
fried.egg.fct("stock",my.ss,"2MTL3","TRUE","TRUE","a)","TRUE")

mtext(expression(U[curr]/U[MSY]), side=2, line=1, outer=TRUE, cex=0.75)

## stocks with MTL between 3.0 and 4.0
ss.mtl <- subset(my.mtl, MTLgroup=="3.0<=MTL<4.0")$stockid
my.ss <- paste("(", capture.output(cat(paste("'",as.character(ss.mtl),"'",sep=""), sep=",")), ")", sep="")
#fried.egg.fct("stock",my.ss,"3MTL4","FALSE","TRUE","3.0<=MTL<4.0","TRUE")
fried.egg.fct("stock",my.ss,"3MTL4","TRUE","FALSE","b)","TRUE")


mtext(expression(B[curr]/B[MSY]), side=1, line=1, outer=TRUE, cex=0.75)

## stocks with MTL over 4.0
ss.mtl <- subset(my.mtl, MTLgroup=="MTL>=4.0")$stockid
my.ss <- paste("(", capture.output(cat(paste("'",as.character(ss.mtl),"'",sep=""), sep=",")), ")", sep="")
#fried.egg.fct("stock",my.ss,"MTL4plus","FALSE","TRUE","MTL>=4.0","TRUE")
fried.egg.fct("stock",my.ss,"MTL4plus","TRUE","FALSE","c)","TRUE")
axis(side=4,labels=TRUE)
mtext(expression(U[curr]/U[MSY]), side=4, line=1, outer=TRUE, cex=0.75)

dev.off()

odbcClose(chan)
