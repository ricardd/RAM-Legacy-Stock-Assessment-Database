#
#
#
rm(list=ls())
require(RODBC)
source("./functions/get_admb_results.R")

chan <- odbcConnect(dsn="srdbusercalo", case='postgresql',believeNRows=FALSE)

# tsn and associated taxonomic classification
qu.taxo <- paste("
(select s.stockid, tt.taxocategory from (select tsn, (CASE WHEN family = \'Gadidae\' THEN \'Gadidae\' ELSE (CASE WHEN ordername = \'Pleuronectiformes\' THEN \'Pleuronectiformes\' ELSE (CASE WHEN ((family in (\'Clupeidae\',\'Scombridae\',\'Engraulidae\')) OR (genus IN (\'Trachurus\',\'Mallotus\'))) THEN \'Pelagic\' ELSE (CASE WHEN classname = \'Chondrichthyes\' THEN \'Shark/Skate\' ELSE \'Other demersal\' END) END) END) END) as taxocategory from srdb.taxonomy where classname in (\'Actinopterygii\',\'Chondrichthyes\')) as tt, srdb.stock s where s.tsn=tt.tsn) as tt
", sep="")

# stockid and associated geographical region
qu.geo <- paste("
(select stockid, max(geoarea) as geo from (select stockid, (CASE WHEN lme_number in (7,8,9,18) THEN \'NWAtl\' ELSE (CASE WHEN lme_number in (19,20,21,22,23,24,25,59,60) THEN \'NEAtl\' ELSE (CASE WHEN lme_number in (1,2,3) THEN \'NEPac\' ELSE (CASE WHEN lme_number in (5,6,12) THEN \'NorthMidAtl\' ELSE (CASE WHEN lme_number in (14,15,16,17) THEN \'SWAtl\' ELSE (CASE WHEN lme_number in (39,40,41,42,43,44,45,46) THEN \'Aust-NZ\' ELSE (CASE WHEN lme_number in (29,30) THEN \'SAfr\' ELSE (CASE WHEN lme_number <0 THEN \'HighSeas\' ELSE (CASE WHEN lme_number = 26 THEN \'Med\' ELSE (CASE WHEN lme_number = 62 THEN \'BlackSea\' ELSE NULL END) END) END) END) END) END) END) END) END) END ) as geoarea from srdb.lmetostocks) as a group by stockid) as gg
",sep="")

# SSB time-series
#qu.ts <- paste ("
#(select aa.stockid, v.assessid, v.tsyear, v.ssb from srdb.timeseries_values_view v, srdb.assessment aa where aa.assessid=v.assessid AND v.assessid in (select assessid from (select assessid, max(tsyear) - min(tsyear) as nyears from srdb.timeseries_values_view where ssb is not null and assessid in (select assessid from srdb.assessment where recorder != \'MYERS\' and stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where classname in (\'Actinopterygii\',\'Chondrichthyes\')))) group by assessid) as aa where nyears>=25) and ssb is not null) as ts
#", sep="")

## following subquery makes sure 1978 is included -CM 27/08/09, Dan please check

qu.ts <- paste ("
(select aa.stockid, v.assessid, v.tsyear, v.ssb from srdb.timeseries_values_view v, srdb.assessment aa where aa.assessid=v.assessid AND v.assessid in (select aa.assessid from (select assessid, max(tsyear) - min(tsyear) as nyears, min(tsyear) as minyear from srdb.timeseries_values_view where ssb is not null and assessid in (select assessid from srdb.assessment where recorder != \'MYERS\' and stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where classname in (\'Actinopterygii\',\'Chondrichthyes\')))) group by assessid) as aa where nyears>=25 and minyear<=1978) and ssb is not null) as ts
", sep="")

# now bring back the SSB time-series data along with the taxonomic classification and geographical region
qu.main <- paste("
SELECT
tt.taxocategory,
gg.geo,
ts.stockid, ts.assessid, ts.tsyear, ts.ssb
FROM", qu.taxo, ",", qu.geo, ",", qu.ts,
"WHERE
tt.stockid=ts.stockid AND
gg.stockid=ts.stockid
",sep=" ")

dat <- sqlQuery(chan,qu.main)
cutoff <- 1992
a <- unique(dat$assessid)
#s <- unique(dat$stockid)
n <- length(a)
par.estimates <- data.frame(geo = rep(0,n), taxo = rep(0,n), stockid = rep(0,n),assessid = rep(0,n), m.slope.before = rep(0,n), m.slope.after = rep(0,n), mcont.slope.before = rep(0,n), mcont.slope.after = rep(0,n), m.diff=rep(0,n), mcont.diff=rep(0,n), model.diff=rep(0,n), logprepostratio=rep(0,n), mss.slope.before=rep(0,n), mss.slope.after=rep(0,n), mss.diff=rep(0,n))

for(i in 1:n) {
print(i)
#print(unique(t$geo))
#print(unique(t$taxocategory))
temp <- subset(dat, assessid == a[i])
c<-which(temp$tsyear==cutoff)
## CM
##temp$post <- floor(temp$tsyear/(cutoff+1))
temp$post <- as.numeric(temp$tsyear>cutoff)
temp$yr <- temp$tsyear - min(temp$tsyear) + 1

m <- lm(log(ssb) ~ yr + post + post:yr, data=temp)
mcont <- lm(log(ssb) ~ yr + post:I(yr-c), data=temp)
## output the data to admb folder
##my.dat.path<-"/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/localleveltrend/localleveltrend.dat"
my.dat.path<-"/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/processerroronly/processerroronly.dat"
##my.dat.path<-"/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/measureerroronly/measureerroronly.dat"

cat("# Number of obs \n", dim(temp)[1], "\n",file = my.dat.path, append=FALSE)
cat("# section 1 length \n", which(temp$tsyear==cutoff), "\n",file = my.dat.path, append=TRUE)
cat("# section 2 length \n", (dim(temp)[1]-which(temp$tsyear==cutoff)), "\n",file = my.dat.path, append=TRUE)
cat("# cutoff \n", cutoff, "\n",file = my.dat.path, append=TRUE)
cat("# years \n", temp$tsyear, "\n",file = my.dat.path, append=TRUE)
cat("# Observations \n", log(temp$ssb), "\n",file = my.dat.path, append=TRUE)

## cat("# Number of obs \n", dim(temp)[1], "\n",file = my.dat.path, append=FALSE)
## cat("# Cut off \n", cutoff, "\n",file = my.dat.path, append=TRUE)
## cat("# years \n", temp$tsyear, "\n",file = my.dat.path, append=TRUE)
## cat("# Observations \n", log(temp$ssb), "\n",file = my.dat.path, append=TRUE)

##system("cd /home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/localleveltrend; rm localleveltrend.std; ./localleveltrend")
system("cd /home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/processerroronly; rm processerroronly.std; ./processerroronly ")
##system("cd /home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/measureerroronly; rm measureerroronly.std; ./measureerroronly")

##if(file.exists("/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/localleveltrend/localleveltrend.std")){
if(file.exists("/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/processerroronly/processerroronly.std")){
##if(file.exists("/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/measureerroronly/measureerroronly.std")){
  ##admb.fit<-get.admb.results("/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/measureerroronly/","measureerroronly")
  admb.fit<-get.admb.results("/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/processerroronly/","processerroronly")
  ##admb.fit<-get.admb.results("/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/admb/localleveltrend/","localleveltrend")
  ##state.hat<-admb.fit$value[admb.fit$name=="state"]
  par.estimates$mss.slope.before[i]<-admb.fit$value[admb.fit$name=="slope_pre"]
  par.estimates$mss.slope.after[i]<-admb.fit$value[admb.fit$name=="slope_post"]
  par.estimates$mss.slope.diff[i]<-par.estimates$mss.slope.before[i]-par.estimates$mss.slope.after[i]
}else{
  par.estimates$mss.slope.before[i]<-NA
  par.estimates$mss.slope.after[i]<-NA
  par.estimates$mss.slope.diff[i]<-NA
}

# log(biomass) 10 years before and after cutoff date
before <- subset(temp, ((tsyear <= cutoff)&(tsyear > cutoff-10)) )
after <- subset(temp, ((tsyear > cutoff)&(tsyear <= cutoff+10)) )

# log of the after/before ratio 
par.estimates$logpostpreratio[i] <- log(mean(after$ssb)/mean(before$ssb))

# non-linear model to estimate cutoff year
# NOT TESTED !!!
#my.I <- function(c,yr){
#return(ifelse(yr<c,0,1))
#}

#nls(log(ssb) ~ B0 + B1*yr + B2*post:my.I(yr-c), start=c(B0=,B1=,B2=,c=1992) )
# NOT TESTED !!!

s <- unique(temp$stockid)

par.estimates$stockid[i] <- as.character(s)
par.estimates$assessid[i] <- as.character(a[i])
par.estimates$m.slope.before[i] <- m$coef[2]
par.estimates$m.slope.after[i] <- m$coef[2] + m$coef[4]
par.estimates$mcont.slope.before[i] <- mcont$coef[2]
par.estimates$mcont.slope.after[i] <- mcont$coef[2] + mcont$coef[3]
par.estimates$m.diff[i] <- m$coef[4]
par.estimates$mcont.diff[i] <- mcont$coef[3]
par.estimates$model.diff[i] <- par.estimates$m.diff[i]-par.estimates$mcont.diff[i]


par.estimates$geo[i] <- as.character(unique(temp$geo))
par.estimates$taxo[i] <- as.character(unique(temp$taxocategory))
}

par.estimates$m.pre.positive <- ifelse(par.estimates$m.slope.before>=0,1,0)
par.estimates$mcont.pre.positive <- ifelse(par.estimates$mcont.slope.before>=0,1,0)
par.estimates$m.post.positive <- ifelse(par.estimates$m.slope.after>=0,1,0)
par.estimates$mcont.post.positive <- ifelse(par.estimates$mcont.slope.after>=0,1,0)

odbcClose(chan)

q("yes")

