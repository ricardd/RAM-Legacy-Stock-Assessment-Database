# timeseries plot of assessments entered
# DR, CM

library("RODBC")
# open a channel to the database
mychan<-odbcConnect(dsn="srdbusercalo") # note how the DSN is used here

my.qu<-paste("select count(*), dateloaded from srdb.assessment where recorder != 'MYERS' group by dateloaded order by dateloaded;")
datfile<-sqlQuery(mychan, my.qu)
datfile$number<-cumsum(datfile$count)
names(datfile)<-c("count","date", "number")
datfile<-rbind(datfile,c(NA,NA,NA))
datfile$number[length(datfile[,1])]<-datfile$number[length(datfile[,1])-1]
datfile$date[length(datfile[,1])]<-Sys.time()
#datfile$date[length(datfile[,1])]<-"2009-07-01"

#bitmap("./figures/timeseries_assess_bydateloaded.png", width=7,height=7, type="png256", res=800,units="in", pointsize=12)
pdf("./figures/timeseries_assess_bydateloaded.pdf", width=7,height=7)
with(datfile, plot(date,number, type="l", bty="l", xlab="Time", ylab="Cumulative number of assessments", ylim=c(0,350), cex.lab=1.1, cex.axis=1.1, lwd=2, xaxt="n"))
abline(h=c(100,200,300), lty=2, lwd=0.75, col=grey(0.4))
#legend("topleft", bty="n", cex=1.2, legend="Version 1.0 goal")
#legend(datfile$date[1],205, bty="n", cex=1.2, legend="Version 1.0 goal")

axis.dates<-unique(format(datfile$date, "%b-%Y"))

axis.dates.at<-as.Date(paste("1-",axis.dates, sep=""),format="%d-%b-%Y")
axis(side=1, at=axis.dates.at, labels=axis.dates)
dev.off()

odbcClose(mychan)
