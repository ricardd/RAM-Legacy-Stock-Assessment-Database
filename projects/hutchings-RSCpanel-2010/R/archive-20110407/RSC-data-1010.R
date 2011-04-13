# revised R code to address the reviewers' comments for CJFAS CBD short communication
# last modifieds Time-stamp: <2011-04-07 11:17:53 (srdbadmin)>

#
#rm(list=ls())
require(xtable)
require(RODBC)
source("./get_admb_results.R")

chan <- odbcConnect(dsn="srdbusercalo", case='postgresql',believeNRows=FALSE)

# tsn and associated taxonomic classification
qu.taxo <- paste("
(select s.stockid, tt.taxocategory from (select tsn, (CASE WHEN family = \'Gadidae\' THEN \'Gadidae\' ELSE (CASE WHEN ordername = \'Pleuronectiformes\' THEN \'Pleuronectiformes\' ELSE (CASE WHEN ((family in (\'Clupeidae\',\'Scombridae\',\'Engraulidae\')) OR (genus IN (\'Trachurus\',\'Mallotus\')) OR (scientificname IN (\'Arripis trutta\',\'Micromesistius australis\',\'Xiphias gladius\',\'Micromesistius poutassou\',\'Pomatomus saltatrix \'))) THEN \'Pelagic\' ELSE (CASE WHEN classname = \'Chondrichthyes\' THEN \'Shark/Skate\' ELSE \'Other demersal\' END) END) END) END) as taxocategory from srdb.taxonomy where classname in (\'Actinopterygii\',\'Chondrichthyes\')) as tt, srdb.stock s where s.tsn=tt.tsn) as tt
", sep="")

# stockid and associated geographical region
qu.geo <- paste("
(select stockid, min(geoarea) as geo from (select stockid, (CASE WHEN lme_number in (7,8,9,18) THEN \'NWAtl\' ELSE (CASE WHEN lme_number in (19,20,21,22,23,24,25,59,60) THEN \'NEAtl\' ELSE (CASE WHEN lme_number in (1,2,3) THEN \'NEPac\' ELSE (CASE WHEN lme_number in (5,6,12) THEN \'NorthMidAtl\' ELSE (CASE WHEN lme_number in (14,15,16,17) THEN \'SWAtl\' ELSE (CASE WHEN lme_number in (39,40,41,42,43,44,45,46) THEN \'Aust-NZ\' ELSE (CASE WHEN lme_number in (29,30) THEN \'SAfr\' ELSE (CASE WHEN lme_number <0 THEN \'HighSeas\' ELSE (CASE WHEN lme_number = 26 THEN \'Med\' ELSE (CASE WHEN lme_number = 62 THEN \'BlackSea\' ELSE (CASE WHEN lme_number = 13 THEN \'SEPac\'ELSE NULL END) END) END) END) END) END) END) END) END) END) END ) as geoarea from srdb.lmetostocks) as a group by stockid) as gg
",sep="")

# SSB time-series
#qu.ts <- paste ("
#(select aa.stockid, v.assessid, v.tsyear, v.ssb from srdb.timeseries_values_view v, srdb.assessment aa where aa.assessid=v.assessid AND v.assessid in (select assessid from (select assessid, max(tsyear) - min(tsyear) as nyears from srdb.timeseries_values_view where ssb is not null and assessid in (select assessid from srdb.assessment where recorder != \'MYERS\' and stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where classname in (\'Actinopterygii\',\'Chondrichthyes\')))) group by assessid) as aa where nyears>=25) and ssb is not null) as ts
#", sep="")

## following subquery makes sure 1978 is included -CM 27/08/09, Dan please check

## included total biomass too CM , May 23rd

##qu.ts <- paste ("
##(select aa.stockid, v.assessid, v.tsyear, v.ssb from srdb.timeseries_values_view v, srdb.assessment aa where aa.assessid=v.assessid AND v.assessid in (select aa.assessid from (select assessid, max(tsyear) - min(tsyear) as nyears, min(tsyear) as minyear, 1992-min(tsyear) as nyearspre1992, max(tsyear)-1992 as nyearspost1992 from srdb.timeseries_values_view where ssb is not null and assessid in (select assessid from srdb.assessment where recorder != \'MYERS\' and stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where classname in (\'Actinopterygii\',\'Chondrichthyes\')))) group by assessid) as aa where nyearspre1992>=10 and nyearspost1992>=10) and ssb is not null) as ts
##", sep="")

#qu.ts <- paste ("
#(select aa.stockid, v.assessid, v.tsyear, v.ssb, v.total from srdb.timeseries_values_view v, srdb.assessment aa where aa.assessid=v.assessid AND v.assessid in (select aa.assessid from (select assessid, max(tsyear) - min(tsyear) as nyears, min(tsyear) as minyear, 1992-min(tsyear) as nyearspre1992, max(tsyear)-1992 as nyearspost1992 from srdb.timeseries_values_view where ssb is not null and assessid in (select assessid from srdb.assessment where recorder != \'MYERS\' and stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where classname in (\'Actinopterygii\',\'Chondrichthyes\')))) group by assessid) as aa where nyearspre1992>=10 and nyearspost1992>=10) and ssb is not null) as ts
#", sep="")

qu.ts <- paste ("
(select aa.stockid, v.assessid, v.tsyear, v.ssb, v.total, v.f, v.catch_landings from srdb.timeseries_values_view v, srdb.assessment aa where aa.assessid=v.assessid AND v.assessid in (select aa.assessid from (select assessid, max(tsyear) - min(tsyear) as nyears, min(tsyear) as minyear, 1992-min(tsyear) as nyearspre1992, max(tsyear)-1992 as nyearspost1992 from srdb.timeseries_values_view where ssb is not null and assessid in (select assessid from srdb.assessment where recorder != \'MYERS\' and stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where classname in (\'Actinopterygii\',\'Chondrichthyes\')))) group by assessid) as aa where nyearspre1992>=10 and nyearspost1992>=10) and ssb is not null) as ts
", sep="")

# now bring back the SSB time-series data along with the taxonomic classification and geographical region
qu.main <- paste("
SELECT
tt.taxocategory,
gg.geo,
ts.stockid, aa.areaname, ss.stocklong, ta.commonname1, ta.scientificname, ts.assessid, ts.tsyear, ts.ssb, ts.total, ts.f, ts.catch_landings 
FROM", qu.taxo, ",", qu.geo, ",", qu.ts, ",srdb.stock ss, srdb.taxonomy ta, srdb.area aa ",
"WHERE
aa.areaid=ss.areaid AND
ss.tsn=ta.tsn AND
tt.stockid=ts.stockid AND
gg.stockid=ts.stockid AND
ss.stockid=ts.stockid
ORDER BY ss.stockid, ts.tsyear
",sep=" ")

dat.1010 <- sqlQuery(chan,qu.main)

cutoff <- 1992
a <- unique(dat.1010$assessid)
#s <- unique(dat$stockid)
n <- length(a)


#qu.brp <- paste("
#select 
#",sep="")

#dat.brp <- sqlQuery(chan,qu.brp)


# print-friendly list of stocks by geographic region for supplementary materials
oo <- order(dat.1010$geo, dat.1010$stockid) #oo <- order(dat.1010$scientificname, dat.1010$stockid)
stocklist.1010 <- unique(data.frame(area=as.character(dat.1010$geo[oo]), stockid=as.character(dat.1010$stockid[oo]), areaname=as.character(dat.1010$areaname[oo]), commonname=as.character(dat.1010$commonname1[oo]), scientificname=as.character(dat.1010$scientificname[oo]), taxocategory=as.character(dat.1010$taxocategory[oo])))

write.table(file="RSC-stocklist-1010.csv",stocklist.1010,sep=",", row.names=FALSE)


### NOW BRING BACK THE RATIOS
#### FIRST FOR SSB
# as per original analysis, bring back the SSB timeseries

# REVISED ANALYSIS WITH BIOLOGICAL REFERENCE POINTS
# bring back SSB timeseries relative to SSBmsy (basically like the pepper but with a data point for each year)
pepper.ts.qu <- paste("
select
assessid,
tsyear,
tsid,
tsvalue,
bioid,
biovalue,
tstobrpratio as ratio,
'pepper' as type
from
srdb.tsrelative_explicit_view
where
bioid like 'SSBmsy%'
order by
assessid, tsyear",
                      sep="")

pepper.ts.dat <- sqlQuery(chan, pepper.ts.qu, stringsAsFactors=FALSE)


# bring back TB timeseries relative to Bmsy (basically like the salt but with a data point for each year)

salt.ts.qu <- paste("
select
a.assessid,
a.tsyear,
a.tsid,
a.total as tsvalue,
b.bioid,
b.bmsy as biovalue,
a.total/b.bmsy as ratio,
'salt' as type
from
(select assessid, tsyear, 'TB' as tsid, total from srdb.timeseries_values_view) as a,
(select assessid, bmsy, 'Bmsy' as bioid from srdb.spfits) as b
where
a.assessid not in (select distinct assessid from srdb.tsrelative_explicit_view where bioid like 'SSBmsy%') AND
a.assessid=b.assessid and
a.total is not null
order by
a.assessid, a.tsyear",
sep="")

salt.ts.dat <- sqlQuery(chan, salt.ts.qu, stringsAsFactors=FALSE)


# now preferentially keep the pepper
merged.temp <- rbind(pepper.ts.dat, salt.ts.dat)
merged.ordered <- merged.temp[order(merged.temp$assessid,merged.temp$tsyear),]

oo <- unlist(tapply(merged.ordered$assessid, paste(merged.ordered$assessid, merged.ordered$tsyear, sep="."), order))
merged.dat <- merged.ordered[oo==1, ]

# add necessary columns to the data frame
# geo, assessid, stockid, taxocategory, year, tsid (total or ssb), tsvalue, brp_id (pepper or salt), brp_value, bratio
# where tsvalue is not null in 1978 and 2007. There is redundancy there as bratio=tsvalue/brp_value.

det.qu <- paste("SELECT gg.geo, a.assessid, a.stockid, tt.taxocategory
FROM", qu.taxo, ",", qu.geo, ", srdb.assessment a ",
                "WHERE
a.stockid = gg.stockid and gg.stockid=tt.stockid
ORDER BY a.stockid", sep="")

my.det <- sqlQuery(chan,det.qu, stringsAsFactors=FALSE)

ts.ratios.temp <- merge(merged.dat, my.det, "assessid")

# remove the assessments that are not in the "dat.1010" dataframe (i.e. remove assessments not fulfilling the 10 years before/after criterion)
keep.assessid <- data.frame(assessid = unique(dat.1010$assessid))
ts.ratios.dat <- merge(ts.ratios.temp, keep.assessid, "assessid", all.x=FALSE, all.y=TRUE)

## write data to file 
write.table(dat.1010, file="/home/srdbadmin/srdb/projects/hutchings-RSCpanel-2010/R/CJFAS-shortcomm-multispecies.csv", sep=",")
write.table(ts.ratios.dat, file="/home/srdbadmin/srdb/projects/hutchings-RSCpanel-2010/R/CJFAS-shortcomm-multispecies-BRPratios.csv", sep=",")

### SSB ratios done

### NOW DO the F RATIOS
### 
# bring back F timeseries relative to Fmsy (basically like the pepper but with a data point for each year)
pepper.ts.qu <- paste("
select
assessid,
tsyear,
tsid,
tsvalue,
bioid,
biovalue,
tstobrpratio as ratio,
'pepper' as type
from
srdb.tsrelative_explicit_view
where
bioid like 'Fmsy%'
order by
assessid, tsyear",
                      sep="")

pepper.ts.dat <- sqlQuery(chan, pepper.ts.qu, stringsAsFactors=FALSE)


# bring back catch timeseries relative to Fmsy (basically like the salt but with a data point for each year)

salt.ts.qu <- paste("
select
a.assessid,
a.tsyear,
a.tsid,
a.f as tsvalue,
b.bioid,
b.fmsy as biovalue,
a.f/b.fmsy as ratio,
'salt' as type
from
(select assessid, tsyear, 'F' as tsid, catch_landings/total as f from srdb.timeseries_values_view where catch_landings/total is not null) as a,
(select assessid, fmsy, 'Fmsy' as bioid from srdb.spfits) as b
where
a.assessid not in (select distinct assessid from srdb.tsrelative_explicit_view where bioid like 'Fmsy%') AND
a.assessid=b.assessid 
order by
a.assessid, a.tsyear",
sep="")

salt.ts.dat <- sqlQuery(chan, salt.ts.qu, stringsAsFactors=FALSE)


# now preferentially keep the pepper
merged.temp <- rbind(pepper.ts.dat, salt.ts.dat)
merged.ordered <- merged.temp[order(merged.temp$assessid,merged.temp$tsyear),]

oo <- unlist(tapply(merged.ordered$assessid, paste(merged.ordered$assessid, merged.ordered$tsyear, sep="."), order))
merged.dat <- merged.ordered[oo==1, ]

# add necessary columns to the data frame
# geo, assessid, stockid, taxocategory, year, tsid (total or ssb), tsvalue, brp_id (pepper or salt), brp_value, bratio
# where tsvalue is not null in 1978 and 2007. There is redundancy there as bratio=tsvalue/brp_value.

det.qu <- paste("SELECT gg.geo, a.assessid, a.stockid, tt.taxocategory
FROM", qu.taxo, ",", qu.geo, ", srdb.assessment a ",
                "WHERE
a.stockid = gg.stockid and gg.stockid=tt.stockid
ORDER BY a.stockid", sep="")

my.det <- sqlQuery(chan,det.qu, stringsAsFactors=FALSE)

ts.ratios.temp <- merge(merged.dat, my.det, "assessid")

# remove the assessments that are not in the "dat.1010" dataframe (i.e. remove assessments not fulfilling the 10 years before/after criterion)
keep.assessid <- data.frame(assessid = unique(dat.1010$assessid))
ts.f.ratios.dat <- merge(ts.ratios.temp, keep.assessid, "assessid", all.x=FALSE, all.y=FALSE)

## write data to file 
write.table(ts.f.ratios.dat, file="/home/srdbadmin/srdb/projects/hutchings-RSCpanel-2010/R/CJFAS-shortcomm-multispecies-BRP-fratios.csv", sep=",")


odbcClose(chan)
save.image()
