##
## fried eggs by LME
setwd("/home/srdbadmin/srdb/projects/fishandfisheries/R/first-review/")
source("friedegg-fct.R")

require(RODBC)
chan <- odbcConnect(dsn='srdbcalo')

pdf("friedegg-LMEs.pdf", width=11/1.6, height=11)
par(mar=c(4,4,1,1),oma=c(4,4,1,1),mfrow=c(4,2))

## Northeast U.S. Continental Shelf
qu <- paste("SELECT stockid from srdb.lmetostocks where stocktolmerelation='primary' and lme_number=7",sep="")
stocks.neus <- sqlQuery(chan,qu,stringsAsFactors=FALSE)
my.ss <- paste("(", capture.output(cat(paste("'",as.character(stocks.neus$stockid),"'",sep=""), sep=",")), ")", sep="")
fried.egg.fct("stock", my.ss,"seus","FALSE","TRUE","Northeast U.S. Continental Shelf","TRUE")

## California current
qu <- paste("SELECT stockid from srdb.lmetostocks where stocktolmerelation='primary' and lme_number=3",sep="")
stocks.calicurr <- sqlQuery(chan,qu,stringsAsFactors=FALSE)
my.ss <- paste("(", capture.output(cat(paste("'",as.character(stocks.calicurr$stockid),"'",sep=""), sep=",")), ")", sep="")
fried.egg.fct("stock", my.ss,"CaliCurr","FALSE","TRUE","California current","TRUE")

## Gulf of Alaska
qu <- paste("SELECT stockid from srdb.lmetostocks where stocktolmerelation='primary' and lme_number=2",sep="")
stocks.goa <- sqlQuery(chan,qu,stringsAsFactors=FALSE)
my.ss <- paste("(", capture.output(cat(paste("'",as.character(stocks.goa$stockid),"'",sep=""), sep=",")), ")", sep="")
fried.egg.fct("stock", my.ss,"GoA","FALSE","TRUE","Gulf of Alaska","TRUE")

## New Zealand Shelf
qu <- paste("SELECT stockid from srdb.lmetostocks where stocktolmerelation='primary' and lme_number=46",sep="")
stocks.nzs <- sqlQuery(chan,qu,stringsAsFactors=FALSE)
my.ss <- paste("(", capture.output(cat(paste("'",as.character(stocks.nzs$stockid),"'",sep=""), sep=",")), ")", sep="")
fried.egg.fct("stock", my.ss,"NZS","FALSE","TRUE","New Zealand Shelf","TRUE")

## Celtic-Biscay Shelf
qu <- paste("SELECT stockid from srdb.lmetostocks where stocktolmerelation='primary' and lme_number=24",sep="")
stocks.cbs <- sqlQuery(chan,qu,stringsAsFactors=FALSE)
my.ss <- paste("(", capture.output(cat(paste("'",as.character(stocks.cbs$stockid),"'",sep=""), sep=",")), ")", sep="")
fried.egg.fct("stock", my.ss,"CBS","FALSE","TRUE","Celtic-Biscay Shelf","TRUE")


## East Bering Sea
qu <- paste("SELECT stockid from srdb.lmetostocks where stocktolmerelation='primary' and lme_number=1",sep="")
stocks.ebs <- sqlQuery(chan,qu,stringsAsFactors=FALSE)
my.ss <- paste("(", capture.output(cat(paste("'",as.character(stocks.ebs$stockid),"'",sep=""), sep=",")), ")", sep="")
fried.egg.fct("stock", my.ss,"EBS","FALSE","TRUE","East Bering Sea","TRUE")

## Southeast U.S. Continental Shelf
qu <- paste("SELECT stockid from srdb.lmetostocks where stocktolmerelation='primary' and lme_number=6",sep="")
stocks.seus <- sqlQuery(chan,qu,stringsAsFactors=FALSE)
my.ss <- paste("(", capture.output(cat(paste("'",as.character(stocks.seus$stockid),"'",sep=""), sep=",")), ")", sep="")
fried.egg.fct("stock", my.ss,"seus","FALSE","TRUE","Southeast U.S. Continental Shelf","TRUE")

dev.off()

odbcClose(chan)
