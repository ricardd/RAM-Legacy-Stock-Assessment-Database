#
#
source("srDB-function-example.R")
data.1 <- query.timeseries("AFSC-PCODGOA-1977-2007-BAUM")


xx <- subset(data.1, tsid=="YEAR-yr")$tsyear
yy1 <- subset(data.1, tsid=="SSB-MT")$tsvalue

plot(xx, yy1, type='b')

data.2 <- query.timeseries("AFWG-CODNEAR-1943-2006-MINTO")
data.3 <- query.timeseries("NAFO-SC-AMPL3M-YEAR-2005-BAUM")

xx <- subset(data.3, tsid=="YEAR-yr")$tsyear
yy1 <- subset(data.3, tsid=="SSB-MT")$tsvalue
yy2 <- subset(data.3, tsid=="F-1/T")$tsvalue
yy3 <- subset(data.3, tsid=="R-E03")$tsvalue

plot(xx,yy1,type='b')
plot(yy1,yy3,type='b',xlab="SSB",ylab="R")
plot(yy1,yy2,type='b',xlab="SSB",ylab="F")

