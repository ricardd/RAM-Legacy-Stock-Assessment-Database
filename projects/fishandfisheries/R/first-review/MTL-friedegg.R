##
## Julia suggests: Another way to split out the fried egg plots, which I think many readers will be interested in, is by trophic level (e.g. we could break trophic level into categories by every 0.5 e.g. 2-2.5, 2.5-3.0, 3.0-3.5 etc).
setwd("/home/srdbadmin/srdb/projects/fishandfisheries/R/first-review/")
source("friedegg-fct.R")

require(RODBC)
chan <- odbcConnect(dsn='srdbcalo')

## MTLs
qu <- paste("select s.stockid, t.scientificname, m.mytltl from srdb.fishbasemtl m, srdb.taxonomy t, srdb.stock s where t.scientificname=m.mytlscientificname and t.tsn=s.tsn", sep="")
my.mtl <- sqlQuery(chan,qu)

my.mtl$MTLgroup <- ifelse(my.mtl$mytltl>=4.5,"MTL>=4.5",ifelse(my.mtl$mytltl>=4,"4.0<=MTL<4.5",ifelse(my.mtl$mytltl>=3.5,"3.5<=MTL<4.0",ifelse(my.mtl$mytltl>=3.0,"3.0<=MTL<3.5",ifelse(my.mtl$mytltl>=2.5,"2.5<=MTL<3.0",ifelse(my.mtl$mytltl>=2.0,"2.0<=MTL<2.5","MTL<2"))))))


# plots
pdf("friedegg-MTLs.pdf", width=11/1.6, height=11)
par(mar=c(4,4,1,1),oma=c(4,4,1,1),mfrow=c(3,2))

## stocks with MTL between 2.0 and 2.5
ss.mtl <- subset(my.mtl, MTLgroup=="2.0<=MTL<2.5")$stockid
my.ss <- paste("(", capture.output(cat(paste("'",as.character(ss.mtl),"'",sep=""), sep=",")), ")", sep="")
fried.egg.fct("stock",my.ss,"2MTL25","FALSE","TRUE","2.0<=MTL<2.5","TRUE")

## stocks with MTL between 2.5 and 3.0
ss.mtl <- subset(my.mtl, MTLgroup=="2.5<=MTL<3.0")$stockid
my.ss <- paste("(", capture.output(cat(paste("'",as.character(ss.mtl),"'",sep=""), sep=",")), ")", sep="")
fried.egg.fct("stock",my.ss,"25MTL3","FALSE","TRUE","2.5<=MTL<3.0","TRUE")

## stocks with MTL between 3.0 and 3.5
ss.mtl <- subset(my.mtl, MTLgroup=="3.0<=MTL<3.5")$stockid
my.ss <- paste("(", capture.output(cat(paste("'",as.character(ss.mtl),"'",sep=""), sep=",")), ")", sep="")
fried.egg.fct("stock",my.ss,"3MTL35","FALSE","TRUE","3.0<=MTL<3.5","TRUE")

## stocks with MTL between 3.5 and 4.0
ss.mtl <- subset(my.mtl, MTLgroup=="3.5<=MTL<4.0")$stockid
my.ss <- paste("(", capture.output(cat(paste("'",as.character(ss.mtl),"'",sep=""), sep=",")), ")", sep="")
fried.egg.fct("stock",my.ss,"35MTL4","FALSE","TRUE","3.5<=MTL<4.0","TRUE")

## stocks with MTL between 4.0 and 4.5
ss.mtl <- subset(my.mtl, MTLgroup=="4.0<=MTL<4.5")$stockid
my.ss <- paste("(", capture.output(cat(paste("'",as.character(ss.mtl),"'",sep=""), sep=",")), ")", sep="")
fried.egg.fct("stock",my.ss,"4MTL45","FALSE","TRUE","4.0<=MTL<4.5","TRUE")

## stocks with MTL above 4.5
ss.mtl <- subset(my.mtl, MTLgroup=="MTL>=4.5")$stockid
my.ss <- paste("(", capture.output(cat(paste("'",as.character(ss.mtl),"'",sep=""), sep=",")), ")", sep="")
fried.egg.fct("stock",my.ss,"MTL45MORE","FALSE","TRUE","MTL>=4.5","TRUE")

dev.off()

odbcClose(chan)
