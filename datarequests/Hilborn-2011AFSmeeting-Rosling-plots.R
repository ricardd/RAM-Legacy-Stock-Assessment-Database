## generating a few data files for Ray Hilborn
## - these data are to be used for the Rosling charts that Ray wants to present at the AFS meeting
## Last modified Time-stamp: <2011-09-02 14:00:03 (srdbadmin)>

setwd("/home/srdbadmin/srdb/datarequests")

require(RODBC)

chan <- odbcConnect(dsn='srdbusercalo')

## SSB pepper
qu <- paste("SELECT s.stockid, tv.* from srdb.tsrelative_explicit_view tv, srdb.assessment a, srdb.stock s where a.mostrecent = 'yes' and a.assessid=tv.assessid and a.stockid = s.stockid and tv.assessid in (select distinct assessid from srdb.brptots where bioid like '%Bmsy%') and bioid like '%Bmsy%' order by assessid, bioid, tsyear"
            ,sep="")
ssb.msy.pepper <- sqlQuery(chan,qu)
ssb.msy.pepper$type <- "assessment"

## F pepper
qu <- paste("SELECT s.stockid, tv.* from srdb.tsrelative_explicit_view tv, srdb.assessment a, srdb.stock s where a.mostrecent = 'yes' and a.assessid=tv.assessid and a.stockid = s.stockid and tv.assessid in (select distinct assessid from srdb.brptots where bioid like 'Fmsy%' or bioid like 'Umsy%') and (bioid like 'Fmsy%' or bioid like 'Umsy%') order by assessid, bioid, tsyear"
            ,sep="")
f.msy.pepper <- sqlQuery(chan,qu)
f.msy.pepper$type <- "assessment"

## TB salt
qu <- paste("select s.stockid, a.assessid, tsv.tsyear, 'TB-' || tsu.total_unit as tsid, tsv.total as tsvalue, 'Bmsy' as bioid, aa.bmsy as biovalue, tsv.total/aa.bmsy as tstobrpratio from srdb.assessment a, srdb.stock s, srdb.timeseries_values_view tsv, srdb.timeseries_units_view tsu, (select assessid, bmsy from srdb.spfits) as aa where tsv.assessid=tsu.assessid and a.assessid = aa.assessid and aa.assessid=tsv.assessid and a.stockid=s.stockid and tsv.total is not null and a.assessid not in (select distinct assessid from srdb.brptots where bioid like '%Bmsy%') order by a.assessid, tsv.tsyear"
            ,sep="")
tb.msy.salt <- sqlQuery(chan,qu)
tb.msy.salt$type <- "Schaefer"

## U salt
qu <- paste("select s.stockid, a.assessid, tsv.tsyear, 'U-' as tsid, tsv.catch_landings/tsv.total as tsvalue, 'Umsy' as bioid, aa.fmsy as biovalue, (tsv.catch_landings/tsv.total)/aa.fmsy as tstobrpratio from srdb.assessment a, srdb.stock s, srdb.timeseries_values_view tsv, srdb.timeseries_units_view tsu, (select assessid, fmsy from srdb.spfits) as aa where tsv.assessid=tsu.assessid and a.assessid = aa.assessid and aa.assessid=tsv.assessid and a.stockid=s.stockid and tsv.catch_landings > 0 and tsv.total is not null and a.assessid not in (select distinct assessid from srdb.brptots where bioid like 'Fmsy%' or bioid like 'Umsy%') order by a.assessid, tsv.tsyear"
            ,sep="")
u.msy.salt <- sqlQuery(chan,qu)
u.msy.salt$type <- "Schaefer"

## merge into a single data frame preferentially keeping the pepper over the salt and allowing for mix-and-match
biomass.merged <- rbind(ssb.msy.pepper, tb.msy.salt)
biomass.merged <- biomass.merged[order(biomass.merged$assessid, biomass.merged$tsyear),]

## rbind the exploitation reference points
exploitation.merged <- rbind(f.msy.pepper, u.msy.salt)
exploitation.merged <- exploitation.merged[order(exploitation.merged$assessid, exploitation.merged$tsyear),]

## merged the biomass and exploitation
all.merged <- merge(biomass.merged, exploitation.merged,c("assessid", "tsyear"))

# keep only the necessary columns, make a neat data frame
all.df <- data.frame(assessid=all.merged$assessid, stockid=all.merged$stockid.x, tsyear=all.merged$tsyear, bvalue=all.merged$tsvalue.x, bmsyvalue=all.merged$biovalue.x, bratio=all.merged$tstobrpratio.x, btype=all.merged$type.x, uvalue=all.merged$tsvalue.y, umsyvalue=all.merged$biovalue.y, uratio=all.merged$tstobrpratio.y, utype=all.merged$type.y)

## bring in the available catch data
qu.cat <- paste("
select a.assessid, tsv.tsyear, tsv.catch_landings, tsu.catch_landings_unit from srdb.assessment a, srdb.timeseries_values_view tsv, srdb.timeseries_units_view tsu where a.assessid=tsv.assessid and tsv.assessid=tsu.assessid and a.mostrecent='yes' and a.assess=1 and tsv.catch_landings is not null
",sep="")

my.cat <- sqlQuery(chan,qu.cat)

ray.df <- merge(all.df, my.cat, c("assessid","tsyear"), all.x=TRUE)

## bring in the stock details
qu.det <- paste("
select a.assessid, s.stockid, s.stocklong, t.scientificname, lr.lme_name from srdb.assessment a, srdb.stock s, srdb.taxonomy t, srdb.lmerefs lr, srdb.lmetostocks ls where a.stockid=s.stockid and s.tsn = t.tsn and s.stockid = ls.stockid and lr.lme_number=ls.lme_number and ls.stocktolmerelation ='primary' and a.mostrecent='yes' and a.assess=1
",sep="")

my.det <- sqlQuery(chan,qu.det)

write.csv(my.det, "Hilborn-2011AFS-stockdetails.csv", row.names=FALSE)
write.csv(ray.df, "Hilborn-2011AFS-timeseries.csv", row.names=FALSE)

odbcClose(chan)
