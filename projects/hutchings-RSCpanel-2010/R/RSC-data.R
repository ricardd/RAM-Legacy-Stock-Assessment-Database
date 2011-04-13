## data load for Jeff Hutching's Royal Society of Canada panel
## details of plots to be produced can be found in RSC-main.R
## Daniel Ricard: started 2011-04-07
## Last modified Time-stamp: <2011-04-11 11:08:36 (srdbadmin)>
## Modification history:
##
require(RODBC)
chan<-odbcConnect(dsn='srdbcalo')

# tsn and associated taxonomic classification
qu.taxo <- paste("
(select s.stockid, tt.taxocategory from (select tsn, (CASE WHEN family = \'Gadidae\' THEN \'Gadidae\' ELSE (CASE WHEN ordername = \'Pleuronectiformes\' THEN \'Pleuronectiformes\' ELSE (CASE WHEN ((family in (\'Clupeidae\',\'Scombridae\',\'Engraulidae\')) OR (genus IN (\'Trachurus\',\'Mallotus\')) OR (scientificname IN (\'Arripis trutta\',\'Micromesistius australis\',\'Xiphias gladius\',\'Micromesistius poutassou\',\'Pomatomus saltatrix \'))) THEN \'Pelagic\' ELSE (CASE WHEN classname = \'Chondrichthyes\' THEN \'Shark/Skate\' ELSE \'Other demersal\' END) END) END) END) as taxocategory from srdb.taxonomy where classname in (\'Actinopterygii\',\'Chondrichthyes\')) as tt, srdb.stock s where s.tsn=tt.tsn) as tt
", sep="")

# stockid and associated geographical region
qu.geo <- paste("
(select stockid, min(geoarea) as geo from (select stockid, (CASE WHEN lme_number in (7,8,9,18) THEN \'NWAtl\' ELSE (CASE WHEN lme_number in (19,20,21,22,23,24,25,59,60) THEN \'NEAtl\' ELSE (CASE WHEN lme_number in (1,2,3) THEN \'NEPac\' ELSE (CASE WHEN lme_number in (5,6,12) THEN \'NorthMidAtl\' ELSE (CASE WHEN lme_number in (14,15,16,17) THEN \'SWAtl\' ELSE (CASE WHEN lme_number in (39,40,41,42,43,44,45,46) THEN \'Aust-NZ\' ELSE (CASE WHEN lme_number in (29,30) THEN \'SAfr\' ELSE (CASE WHEN lme_number <0 THEN \'HighSeas\' ELSE (CASE WHEN lme_number = 26 THEN \'Med\' ELSE (CASE WHEN lme_number = 62 THEN \'BlackSea\' ELSE (CASE WHEN lme_number = 13 THEN \'SEPac\'ELSE NULL END) END) END) END) END) END) END) END) END) END) END ) as geoarea from srdb.lmetostocks) as a group by stockid) as gg
",sep="")

############################################
## biomass ratios
## 
## data frame with SSB
qu.ts <- paste ("
(select aa.stockid, v.assessid, v.tsyear, v.ssb, v.total from srdb.timeseries_values_view v, srdb.assessment aa where aa.assessid=v.assessid AND v.assessid in (select aa.assessid from (select assessid, max(tsyear) - min(tsyear) as nyears, min(tsyear) as minyear, 1992-min(tsyear) as nyearspre1992, max(tsyear)-1992 as nyearspost1992 from srdb.timeseries_values_view where ssb is not null and assessid in (select assessid from srdb.assessment where recorder != \'MYERS\' and stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where classname in (\'Actinopterygii\',\'Chondrichthyes\')))) group by assessid) as aa where nyearspre1992>=10 and nyearspost1992>=10) and ssb is not null) as ts
", sep="")

# now bring back the SSB time-series data along with the taxonomic classification and geographical region
qu.ssb.ts <- paste("
SELECT
tt.taxocategory,
gg.geo,
ts.stockid, aa.areaname, ss.stocklong, ta.commonname1, ta.scientificname, ts.assessid, ts.tsyear, ts.ssb, ts.total 
FROM", qu.taxo, ",", qu.geo, ",", qu.ts, ",srdb.stock ss, srdb.taxonomy ta, srdb.area aa ",
"WHERE
aa.areaid=ss.areaid AND
ss.tsn=ta.tsn AND
tt.stockid=ts.stockid AND
gg.stockid=ts.stockid AND
ss.stockid=ts.stockid
ORDER BY ss.stockid, ts.tsyear
",sep=" ")

ts.ssb <- sqlQuery(chan, qu.ssb.ts)
## keep only stocks of canadian relevance by merging the data frame with ""

## data frame with ratios relative to SSBmsy
brp.ratios.ssb <- sqlQuery(chan, qu.ssb.ratios)


############################################
## exploitation ratios
##
## data frame with F
qu.ts <- paste ("
(select aa.stockid, v.assessid, v.tsyear, v.f, v.catch_landings from srdb.timeseries_values_view v, srdb.assessment aa where aa.assessid=v.assessid AND v.assessid in (select aa.assessid from (select assessid, max(tsyear) - min(tsyear) as nyears, min(tsyear) as minyear, 1992-min(tsyear) as nyearspre1992, max(tsyear)-1992 as nyearspost1992 from srdb.timeseries_values_view where assessid in (select assessid from srdb.assessment where recorder != \'MYERS\' and stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where classname in (\'Actinopterygii\',\'Chondrichthyes\')))) group by assessid) as aa where nyearspre1992>=10 and nyearspost1992>=10) and ssb is not null) as ts
", sep="")

# now bring back the F time-series data along with the taxonomic classification and geographical region
qu.f.ts <- paste("
SELECT
tt.taxocategory,
gg.geo,
ts.stockid, aa.areaname, ss.stocklong, ta.commonname1, ta.scientificname, ts.assessid, ts.tsyear, ts.f, ts.catch_landings
FROM", qu.taxo, ",", qu.geo, ",", qu.ts, ",srdb.stock ss, srdb.taxonomy ta, srdb.area aa ",
"WHERE
aa.areaid=ss.areaid AND
ss.tsn=ta.tsn AND
tt.stockid=ts.stockid AND
gg.stockid=ts.stockid AND
ss.stockid=ts.stockid
ORDER BY ss.stockid, ts.tsyear
",sep=" ")

ts.f <- sqlQuery(chan, qu.f.ts)


## data frame with ratios relative to Fmsy
brp.ratios.f <- sqlQuery(chan, qu.f.ratios)

odbcClose(chan)
