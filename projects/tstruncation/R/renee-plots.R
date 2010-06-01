# renee-plots.R
# plots for time-truncation project
# Time-stamp: <2009-03-16 13:59:32 (ricardd)>

require(RODBC)

chan <- odbcConnect(dsn="srdbusercalo", uid = "srdbuser", pwd="srd6us3r!", case='postgresql',believeNRows=FALSE)


my.query <- paste ("select * from srdb.tstruncation_summary")

my.tssummary <- sqlQuery(chan, my.query)


my.query <- paste ("select * from srdb.tstruncation_ssbseries")

my.tsdata <- sqlQuery(chan, my.query)

odbcClose(chan)



my.stockids <- unique(my.tsdata$stockid)

pdf("all-plots.pdf")

for(i in 1:length(my.stockids)) {

my.file <- paste(my.stockids[i],".pdf",sep="")
#pdf(my.file)
my.stock.data <- subset(my.tsdata, stockid == my.stockids[i])

tt <- c(my.stock.data$ssbmyers[!is.na(my.stock.data$ssbmyers)],my.stock.data$ssbnew[!is.na(my.stock.data$ssbnew)])

my.ylim <- c(min(tt)*0.5,max(tt)*1.1)




plot(my.stock.data$tsyear, my.stock.data$ssbnew, col='red',type='b', xlab="year", ylab="SSB", ylim = my.ylim)
lines(my.stock.data$tsyear, my.stock.data$ssbmyers, col='blue',type='b')
title(my.stockids[i])
legend("topleft",legend = c("New","Myers"),lty=c(1,1),pch=c(1,1), col=c('red','blue'))
#dev.off()
}
dev.off()
