# R code to generate the stDB summary report for NCEAS working group
# Started: 2008-10-15 from earlier work
# Last modified: Time-stamp: <2008-10-27 17:07:52 (mintoc)>
# 
#
require(RODBC)
require(MASS)

# connect to srDB
chan <- odbcConnect(dsn="srDBcalo", uid = "ricardd", pwd="ricardd", case='postgresql',believeNRows=FALSE)

# load functions
pathnames <- list.files(pattern="[.]R$", path="/home/ricardd/linux_sync_folder/SQL/SQLpg/srDB/R/functions", full.names=TRUE);
sapply(pathnames, FUN=source)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# what metrics are available for each assessment id?
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# a query to return the time series metrics for each assessment id
qu <- paste("
(select a.assessid, (CASE WHEN tscategory='SPAWNING STOCK BIOMASS or CPUE' THEN tsid ELSE NULL END) as SSB, (CASE WHEN tscategory like 'RECRUITS%' THEN tsid ELSE NULL END) as R, (CASE WHEN tscategory='FISHING MORTALITY' THEN tsid ELSE NULL END) as F, (CASE WHEN tscategory='CATCH or LANDINGS' THEN tsid ELSE NULL END) as C from (select aa.assessid, bb.tscategory, aa.tsid from srdb.timeseries aa, srdb.tsmetrics bb WHERE aa.tsid=bb.tsunique GROUP BY aa.assessid, bb.tscategory, aa.tsid) as a)
", sep="")
tt <- sqlQuery(chan,qu)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# List to apply a query over
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# need to build a list with the metrics of interest by assess id
# has to accomodates multiple entrys if present

list.metrics.func<-function(assessid){
# return a list with each set of metrics to be plotted
print(assessid)
metrics.df<-tt[tt$assessid==assessid,]
metrics.vec<-metrics.df[,2:5][!is.na(metrics.df[,2:5])]
# are there multiple time series?
is.multiple<-sum(grep("-[0-3]-",metrics.vec))>0
if(is.multiple){
# how many series?
series.number<-max(which(sapply(seq(1,10), function(x){sum(grep(paste("-",x,"-", sep=""),metrics.vec))})>0))
assess.list<-list()
for(i in 1:series.number){
assess.list[[i]]<-metrics.vec[grep(paste("-",i,"-", sep=""),metrics.vec)]
if(sum(grep("[A-Z]-[A-Z]",metrics.vec))>0){assess.list[[i]]<-c(assess.list[[i]],metrics.vec[grep("[A-Z]-[A-Z]",metrics.vec)])}
}
names(assess.list)[1:series.number]<-as.character(assessid)
return(assess.list)}else{
assess.list<-list()
assess.list[[1]]<-metrics.vec
names(assess.list)<-assessid
return(assess.list)
}}

# apply over the assessment ids
assessid.vec<-unique(tt$assessid)
all.metrics.list<-sapply(seq(1:length(assessid.vec)),function(x){list.metrics.func(assessid.vec[x])})
# remove the additional layer of listing
all.metrics.list<-unlist(all.metrics.list[1:length(assessid.vec)], recursive=FALSE)
# need to now call the function for each entry in this list

# check the names
system("rm /home/ricardd/linux_sync_folder/SQL/SQLpg/srDB/R/figures/*.pdf")
for(i in 1:length(all.metrics.list)){
try(srview.fct(i,pdf=TRUE), silent=TRUE)
try(dev.off(), silent=TRUE)
}

odbcClose(chan)


