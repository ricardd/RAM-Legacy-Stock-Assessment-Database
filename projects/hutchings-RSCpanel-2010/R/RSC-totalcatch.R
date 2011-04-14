##
## last modified Time-stamp: <2011-04-14 11:58:00 (srdbadmin)>
##
require(RODBC)

chan<-odbcConnect(dsn='srdbcalo')

## the following objects should be available here,
## tt.dat, which lists the stocks of interest
##
## KEEP ONLY STOCKS FROM DFO and NAFO (as per Jeff's email 2011-04-14)
aa <- tt.dat$assessid[tt.dat$mgmt=='DFO' | tt.dat$mgmt=='NAFO']
my.aa <- capture.output(cat(paste("'",as.character(aa),"'",sep=""), sep=","))   
qu <- paste(
#            "SELECT v.tsyear, sum(v.catch_landings)  FROM srdb.timeseries_values_view v, srdb.timeseries_units_view u where u.catch_landings_unit = 'MT' and u.assessid=v.assessid and v.assessid in (",
                        "SELECT v.assessid, v.tsyear, v.catch_landings as catch  FROM srdb.timeseries_values_view v, srdb.timeseries_units_view u where u.catch_landings_unit = 'MT' and u.assessid=v.assessid and v.assessid in (",
 
            my.aa,") ",
            sep="")

my.mt.catch <- sqlQuery(chan,qu)
my.tt <- subset(my.mt.catch, !is.na(catch))

## attach the taxonomic and geographic info associated with each stock
# tsn and associated taxonomic classification
qu.taxo <- paste("
(select s.stockid, tt.taxocategory from (select tsn, (CASE WHEN family = \'Gadidae\' THEN \'Gadidae\' ELSE (CASE WHEN ordername = \'Pleuronectiformes\' THEN \'Pleuronectiformes\' ELSE (CASE WHEN ((family in (\'Clupeidae\',\'Scombridae\',\'Engraulidae\')) OR (genus IN (\'Trachurus\',\'Mallotus\')) OR (scientificname IN (\'Arripis trutta\',\'Micromesistius australis\',\'Xiphias gladius\',\'Micromesistius poutassou\',\'Pomatomus saltatrix \'))) THEN \'Pelagic\' ELSE (CASE WHEN classname = \'Chondrichthyes\' THEN \'Shark/Skate\' ELSE \'Other demersal\' END) END) END) END) as taxocategory from srdb.taxonomy where classname in (\'Actinopterygii\',\'Chondrichthyes\')) as tt, srdb.stock s where s.tsn=tt.tsn) 
", sep="")
my.taxo <- sqlQuery(chan,qu.taxo)

qu.geo <- paste("
(select stockid, min(geoarea) as geo from (select stockid, (CASE WHEN lme_number in (7,8,9,18) THEN \'NWAtl\' ELSE (CASE WHEN lme_number in (19,20,21,22,23,24,25,59,60) THEN \'NEAtl\' ELSE (CASE WHEN lme_number in (1,2,3) THEN \'NEPac\' ELSE (CASE WHEN lme_number in (5,6,12) THEN \'NorthMidAtl\' ELSE (CASE WHEN lme_number in (14,15,16,17) THEN \'SWAtl\' ELSE (CASE WHEN lme_number in (39,40,41,42,43,44,45,46) THEN \'Aust-NZ\' ELSE (CASE WHEN lme_number in (29,30) THEN \'SAfr\' ELSE (CASE WHEN lme_number <0 THEN \'HighSeas\' ELSE (CASE WHEN lme_number = 26 THEN \'Med\' ELSE (CASE WHEN lme_number = 62 THEN \'BlackSea\' ELSE (CASE WHEN lme_number = 13 THEN \'SEPac\'ELSE NULL END) END) END) END) END) END) END) END) END) END) END ) as geoarea from srdb.lmetostocks) as a group by stockid)
",sep="")
my.geo <- sqlQuery(chan,qu.geo)

#my.tt$stockid <- strsplit(as.character(my.tt$assessid),"-")[[1]][2]

my.mt.catch.det <- merge(merge(merge(my.tt, tt.dat, "assessid"),my.taxo,"stockid"),my.geo,"stockid")

my.years <- seq(1970,2004)
ll <-length(my.years)
tt<- rep(-999,ll)
my.df.totals <- data.frame(year=my.years, total=tt, pelagic=tt, demersal=tt, pac.total=tt, pac.pelagic=tt, pac.demersal=tt, atl.total=tt, atl.pelagic=tt, atl.demersal=tt)

my.pel <- subset(my.mt.catch.det, taxocategory=='Pelagic' & tsyear >= range(my.years)[1] & tsyear <= range(my.years)[2])
my.dem <- subset(my.mt.catch.det, taxocategory!='Pelagic' & tsyear >= range(my.years)[1] & tsyear <= range(my.years)[2])

n.d <- length(unique(my.dem$assessid))
n.p <- length(unique(my.pel$assessid))
n.a <- n.d + n.p

#my.pel.atl <- subset(my.mt.catch.det, taxocategory=='Pelagic' & geo == 'NWAtl' & tsyear >= range(my.years)[1] & tsyear <= range(my.years)[2])
my.pel.pac <- subset(my.mt.catch.det, taxocategory=='Pelagic' & geo == 'NEPac' & tsyear >= range(my.years)[1] & tsyear <= range(my.years)[2])
my.dem.atl <- subset(my.mt.catch.det, taxocategory!='Pelagic' & geo == 'NWAtl' & tsyear >= range(my.years)[1] & tsyear <= range(my.years)[2])
my.dem.pac <- subset(my.mt.catch.det, taxocategory!='Pelagic' & geo == 'NEPac' & tsyear >= range(my.years)[1] & tsyear <= range(my.years)[2])


my.df.totals$pelagic <- tapply(my.pel$catch, my.pel$tsyear, sum)
my.df.totals$demersal <- tapply(my.dem$catch, my.dem$tsyear, sum)
my.df.totals$total <- my.df.totals$pelagic + my.df.totals$demersal

my.df.totals$pac.pelagic <- tapply(my.pel.pac$catch, my.pel.pac$tsyear, sum)
my.df.totals$pac.demersal <- tapply(my.dem.pac$catch, my.dem.pac$tsyear, sum)
my.df.totals$pac.total <- my.df.totals$pac.pelagic + my.df.totals$pac.demersal

#my.df.totals$atl.pelagic <- tapply(my.pel.atl$catch, my.pel.atl$tsyear, sum) ## NO DATA HERE
my.df.totals$atl.demersal <- tapply(my.dem.atl$catch, my.dem.atl$tsyear, sum)
#my.df.totals$atl.total <- my.df.totals$atl.pelagic + my.df.totals$atl.demersal
my.df.totals$atl.total <- my.df.totals$atl.demersal

pdf("total-catch.pdf", height=11, width =11/1.6, title="Total catch in MT for RSC panel report")
par(mfrow=c(3,1), oma=c(3,4,2,1), mar=c(3,4,2,1))

plot(total~year,data=my.df.totals,type='b',col='black',ylim=c(0,range(my.df.totals$total)[2]),pch=19,ylab="MT")
title("All")
lines(pelagic~year,data=my.df.totals,type='b',col='blue',pch=19)
lines(demersal~year,data=my.df.totals,type='b',col='red',pch=19)
aa <- paste("All (n=",n.a,")")
dd <- paste("Demersal (n=",n.d,")")
pp <- paste("Pelagic (n=",n.p,")")
legend('topright',c(aa,dd,pp),col=c("black","red","blue"),lty=1,pch=19)

plot(pac.total~year,data=my.df.totals,type='b',col='black',ylim=c(0,range(my.df.totals$total)[2]),pch=19,ylab="MT")
title("Pacific")
lines(pac.pelagic~year,data=my.df.totals,type='b',col='blue',pch=19)
lines(pac.demersal~year,data=my.df.totals,type='b',col='red',pch=19)

plot(atl.total~year,data=my.df.totals,type='b',col='black',ylim=c(0,range(my.df.totals$total)[2]),pch=19,ylab="MT")
title("Atlantic")
#lines(atl.pelagic~year,data=my.df.totals,type='b',col='blue',pch=19)
lines(atl.demersal~year,data=my.df.totals,type='b',col='red',pch=19)

dev.off()
odbcClose(chan)
