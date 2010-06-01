# kgprecf0
# CM
# date: 12/12/2008
# Last-modified: <>
library(RODBC)
mychan<-odbcConnect(dsn="srdbusercalo")
my.qu<-paste("select MYERSstockid, a.assessid, r, ssb,tsyear, f from srdb.assessment as a, srdb.stock as b, srdb.timeseries_values_view as c where a.assessid=c.assessid and b.stockid=a.stockid")
my.ts.dat<-sqlQuery(mychan, my.qu)
my.names.vec<-unique(my.ts.dat$myersstockid)

rbar.df<-data.frame(stockid=NA, rbar=NA, ssbcurr=NA)
for(i in 1:length(my.names.vec)){
  print(i)
  dat<-my.ts.dat[my.ts.dat$myersstockid==my.names.vec[i] & !is.na(my.ts.dat$myersstockid),]
  high.r <- dat$r[dat$ssb>=quantile(dat$ssb, p=.75, na.rm=TRUE)]
  rbar<-mean(high.r[!is.na(high.r)])*1000 # recruits are in thousands
  ssbcurr<-dat$ssb[dat$tsyear==max(dat$tsyear)]
  my.name<-as.character(my.names.vec[i])
  rbar.df<-rbind(rbar.df, c(my.name, rbar, ssbcurr))
}

# read in the kgperrecf0 data
kgprecf0.df<-read.table("/home/srdbadmin/SQLpg/srDB/RAMdata/kgprecf0.dat", sep="@")
names(kgprecf0.df)<-c("name","kgprecf0")
kgprecf0.df$stockid<-  sapply(seq(1, length(kgprecf0.df[,1])), function(x){strsplit(as.character(kgprecf0.df[x,1]), ".doc")[[1]][1]})
b0.df<-merge(kgprecf0.df, rbar.df)
b0.df$b0<-as.numeric(levels(b0.df$kgprecf0)[as.numeric(b0.df$kgprecf0)])*as.numeric(b0.df$rbar)/1000 # /1000 for kg to tonnes

write.table(b0.df, file="./b0.dat", sep=",")
