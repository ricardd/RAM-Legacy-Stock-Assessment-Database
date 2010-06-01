# renee-plots.R
# plots for time-truncation project
# Time-stamp: <2009-03-20 14:38:33 (ricardd)>

require(RODBC)

chan <- odbcConnect(dsn="srdbusercalo", uid = "srdbuser", pwd="srd6us3r!", case='postgresql',believeNRows=FALSE)
my.query <- paste ("select * from srdb.tstruncation_summary")
my.tssummary <- sqlQuery(chan, my.query)

my.query <- paste ("select * from srdb.tstruncation_ssbseries")
my.tsdata <- sqlQuery(chan, my.query)

odbcClose(chan)

my.stockids <- unique(my.tsdata$stockid)
### Separate the my.tsdata data frame into 2, those stocks in which the new SSB tsdata start earlier (new.first)
### and those in which the myers SSB tsdata start earlier (myers.first)
myers.first <- data.frame(stockid=NA, tsyear=NA, ssbmyers=NA, ssbnew=NA)  #define the data frame myers.first
new.first <- data.frame(stockid=NA, tsyear=NA, ssbmyers=NA, ssbnew=NA)    #define the data frame new.first 

for(i in 1:length(my.stockids))
  {
  my.stock.data <-  subset(my.tsdata,stockid %in% my.stockids[i])
  ifelse(my.stock.data$tsyear[which(!is.na(my.stock.data$ssbmyers))[1]] < my.stock.data$tsyear[which(!is.na(my.stock.data$ssbnew))[1]],  myers.first <- rbind(myers.first,my.stock.data), new.first <- rbind(new.first,my.stock.data))
  }
 new.first <- new.first[-1,]
 myers.first <- myers.first[-1,]
dim(new.first) #check that it worked i.e. # rows in new.first + myers.first = # rows in ts.data
 dim(myers.first)

#### Now split the myers.first data frame by taxa:
my.myersids <- unique(myers.first$stockid)
myers.cod.first <- subset(myers.first, substr(stockid,1,3)=="COD")
myers.had.first <- subset(myers.first, substr(stockid,1,3)=="HAD")
myers.her.first <- subset(myers.first, substr(stockid,1,3)=="HER")
myers.other.first <- subset(myers.first, substr(stockid,1,3)!="COD" & substr(stockid,1,3)!="HAD" & substr(stockid,1,3)!="HER")

##Plot the truncated COD stocks:
myers.codids <- unique(myers.cod.first$stockid)
par(mfrow=c(1,3))
for(i in 1:length(myers.codids))
{
  myers.cod.data <- subset(myers.cod.first, stockid == myers.codids[i])
  tt <- c(myers.cod.data$ssbmyers[!is.na(myers.cod.data$ssbmyers)],myers.cod.data$ssbnew[!is.na(myers.cod.data$ssbnew)])
  my.ylim <- c(min(tt)*0.5,max(tt)*1.1)
  plot(myers.cod.data$tsyear, myers.cod.data$ssbnew, col='red',type='b', xlab="year", ylab="SSB", ylim = my.ylim)
  lines(myers.cod.data$tsyear, myers.cod.data$ssbmyers, col='blue',type='b')
  title(myers.codids[i])
  legend("topleft",legend = c("New","Myers"),lty=c(1,1),pch=c(1,1), col=c('red','blue'))
}  

##Plot the truncated HAD stocks:
myers.hadids <- unique(myers.had.first$stockid)
par(mfrow=c(1,3))
for(i in 1:length(myers.hadids))
{
  myers.had.data <- subset(myers.had.first, stockid == myers.hadids[i])
  tt <- c(myers.had.data$ssbmyers[!is.na(myers.had.data$ssbmyers)],myers.had.data$ssbnew[!is.na(myers.had.data$ssbnew)])
  my.ylim <- c(min(tt)*0.5,max(tt)*1.1)
  plot(myers.had.data$tsyear, myers.had.data$ssbnew, col='red',type='b', xlab="year", ylab="SSB", ylim = my.ylim)
  lines(myers.had.data$tsyear, myers.had.data$ssbmyers, col='blue',type='b')
  title(myers.hadids[i])
  legend("topleft",legend = c("New","Myers"),lty=c(1,1),pch=c(1,1), col=c('red','blue'))
}  

##Plot the truncated HER stocks:
myers.herids <- unique(myers.her.first$stockid)
par(mfrow=c(1,3))
for(i in 1:length(myers.herids))
{
  myers.her.data <- subset(myers.her.first, stockid == myers.herids[i])
  tt <- c(myers.her.data$ssbmyers[!is.na(myers.her.data$ssbmyers)],myers.her.data$ssbnew[!is.na(myers.her.data$ssbnew)])
  my.ylim <- c(min(tt)*0.5,max(tt)*1.1)
  plot(myers.her.data$tsyear, myers.her.data$ssbnew, col='red',type='b', xlab="year", ylab="SSB", ylim = my.ylim)
  lines(myers.her.data$tsyear, myers.her.data$ssbmyers, col='blue',type='b')
  title(myers.herids[i])
  legend("topleft",legend = c("New","Myers"),lty=c(1,1),pch=c(1,1), col=c('red','blue'))
}  

##Plot the truncated OTHER stocks:
myers.otherids <- unique(myers.other.first$stockid)
par(mfrow=c(1,3))
for(i in 1:length(myers.otherids))
{
  myers.other.data <- subset(myers.other.first, stockid == myers.otherids[i])
  tt <- c(myers.other.data$ssbmyers[!is.na(myers.other.data$ssbmyers)],myers.other.data$ssbnew[!is.na(myers.other.data$ssbnew)])
  my.ylim <- c(min(tt)*0.5,max(tt)*1.1)
  plot(myers.other.data$tsyear, myers.other.data$ssbnew, col='red',type='b', xlab="year", ylab="SSB", ylim = my.ylim)
  lines(myers.other.data$tsyear, myers.other.data$ssbmyers, col='blue',type='b')
  title(myers.otherids[i])
  legend("topleft",legend = c("New","Myers"),lty=c(1,1),pch=c(1,1), col=c('red','blue'))
}  


#Renee to fill in code for HER and OTHER stocks -and can do similar thing for all of the stocks in which the new time series extends back further than in the myers assessments

###Lengthened stocks

for(i in 1:length(my.stockids))
  {
  my.stock.data <-  subset(my.tsdata,stockid %in% my.stockids[i])
  ifelse(my.stock.data$tsyear[which(!is.na(my.stock.data$ssbmyers))[1]] < my.stock.data$tsyear[which(!is.na(my.stock.data$ssbnew))[1]],  myers.first <- rbind(myers.first,my.stock.data), new.first <- rbind(new.first,my.stock.data))
  }
 new.first <- new.first[-1,]
 myers.first <- myers.first[-1,]
dim(new.first) #check that it worked i.e. # rows in new.first + myers.first = # rows in ts.data
 dim(myers.first)
 
 my.newids <- unique(new.first$stockid)
 new.cod.first <- subset(new.first, substr(stockid,1,3)=="COD")
 new.had.first <- subset(new.first, substr(stockid,1,3)=="HAD")
 new.her.first <- subset(new.first, substr(stockid,1,3)=="HER")
 new.other.first <- subset(new.first, substr(stockid,1,3)!="COD" & substr(stockid,1,3)!="HAD" & substr(stockid,1,3)!="HER")
 
##Plot the lengthened COD stocks:
new.codids <- unique(new.cod.first$stockid)
par(mfrow=c(1,3))
for(i in 1:length(new.codids))
{
  new.cod.data <- subset(new.cod.first, stockid == new.codids[i])
  tt <- c(new.cod.data$ssbmyers[!is.na(new.cod.data$ssbmyers)],new.cod.data$ssbnew[!is.na(new.cod.data$ssbnew)])
  my.ylim <- c(min(tt)*0.5,max(tt)*1.1)
  plot(new.cod.data$tsyear, new.cod.data$ssbnew, col='red',type='b', xlab="year", ylab="SSB", ylim = my.ylim)
  lines(new.cod.data$tsyear, new.cod.data$ssbmyers, col='blue',type='b')
  title(new.codids[i])
  legend("topleft",legend = c("New","Myers"),lty=c(1,1),pch=c(1,1), col=c('red','blue'))
}  

##Plot the lengthened HAD stocks:
new.hadids <- unique(new.had.first$stockid)
par(mfrow=c(1,3))
for(i in 1:length(new.hadids))
{
  new.had.data <- subset(new.had.first, stockid == new.hadids[i])
  tt <- c(new.had.data$ssbmyers[!is.na(new.had.data$ssbmyers)],new.had.data$ssbnew[!is.na(new.had.data$ssbnew)])
  my.ylim <- c(min(tt)*0.5,max(tt)*1.1)
  plot(new.had.data$tsyear, new.had.data$ssbnew, col='red',type='b', xlab="year", ylab="SSB", ylim = my.ylim)
  lines(new.had.data$tsyear, new.had.data$ssbmyers, col='blue',type='b')
  title(new.hadids[i])
  legend("topleft",legend = c("New","Myers"),lty=c(1,1),pch=c(1,1), col=c('red','blue'))
}  

##Plot the lengthened HER stocks:
new.herids <- unique(new.her.first$stockid)
par(mfrow=c(1,3))
for(i in 1:length(new.herids))
{
  new.her.data <- subset(new.her.first, stockid == new.herids[i])
  tt <- c(new.her.data$ssbmyers[!is.na(new.her.data$ssbmyers)],new.her.data$ssbnew[!is.na(new.her.data$ssbnew)])
  my.ylim <- c(min(tt)*0.5,max(tt)*1.1)
  plot(new.her.data$tsyear, new.her.data$ssbnew, col='red',type='b', xlab="year", ylab="SSB", ylim = my.ylim)
  lines(new.her.data$tsyear, new.her.data$ssbmyers, col='blue',type='b')
  title(new.herids[i])
  legend("topleft",legend = c("New","Myers"),lty=c(1,1),pch=c(1,1), col=c('red','blue'))
}  

##Plot the lengthened OTHER stocks:

pdf("others-lengthened.pdf")
new.otherids <- unique(new.other.first$stockid)
par(mfrow=c(2,2))
for(i in 1:length(new.otherids))
{
  new.other.data <- subset(new.other.first, stockid == new.otherids[i])
  tt <- c(new.other.data$ssbmyers[!is.na(new.other.data$ssbmyers)],new.other.data$ssbnew[!is.na(new.other.data$ssbnew)])
  my.ylim <- c(min(tt)*0.5,max(tt)*1.1)
  plot(new.other.data$tsyear, new.other.data$ssbnew, col='red',type='b', xlab="year", ylab="SSB", ylim = my.ylim)
  lines(new.other.data$tsyear, new.other.data$ssbmyers, col='blue',type='b')
  title(new.otherids[i])
  legend("topleft",legend = c("New","Myers"),lty=c(1,1),pch=c(1,1), col=c('red','blue'))
}  
dev.off()

############################################


my.stockids <- unique(my.tsdata$stockid)
pdf("all-plots.pdf")}
par(mfrow=c(1,3))

for(i in 1:length(my.stockids)) {

my.file <- paste(my.stockids[i],".pdf",sep="")    #pdf(my.file)

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
