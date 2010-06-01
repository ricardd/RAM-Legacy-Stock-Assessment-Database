## get the data for figure 2 of the main manuscript
## CM
## Time-stamp: <2010-06-01 15:22:11 (srdbadmin)>

require(RODBC)
chan <- odbcConnect(dsn="srdbusercalo", case='postgresql',believeNRows=FALSE)

# as per original analysis, bring back the SSB timeseries

# REVISED ANALYSIS WITH BIOLOGICAL REFERENCE POINTS
# bring back SSB timeseries relative to SSBmsy (basically like the pepper but with a data point for each year)
pepper.ts.qu <- paste("select assessid,tsyear,tsid,tsvalue,bioid,biovalue,tstobrpratio as ratio, 'pepper' as type from srdb.tsrelative_explicit_view where bioid like 'SSBmsy%'", sep="")
pepper.ts.dat <- sqlQuery(chan, pepper.ts.qu)


# bring back TB timeseries relative to Bmsy (basically like the salt but with a data point for each year)

salt.ts.qu <- paste("select a.assessid, a.tsyear, a.tsid, a.total as tsvalue, b.bioid, b.bmsy as biovalue, a.total/b.bmsy as ratio, 'salt' as type from (select assessid, tsyear, 'TB' as tsid, total from srdb.timeseries_values_view) as a, (select assessid, bmsy, 'Bmsy' as bioid from srdb.spfits) as b where a.assessid=b.assessid and a.total is not null order by a.assessid, a.tsyear", sep="")
salt.ts.dat <- sqlQuery(chan, salt.ts.qu)


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

my.det <- sqlQuery(chan,det.qu)

ts.ratios.temp <- merge(merged.dat, my.det, "assessid")

# remove the assessments that are not in the "dat.1010" dataframe (i.e. remove assessments not fulfilling the 10 years before/after criterion)
keep.assessid <- data.frame(assessid = unique(dat.1010$assessid))
ts.ratios.dat <- merge(ts.ratios.temp, keep.assessid, "assessid", all.x=FALSE, all.y=TRUE)


#qu.ts<-"select * from srdb.timeseries_values_view"

#ts.dat <- sqlQuery(chan,qu.ts)

odbcClose(chan)

## write data to file for working with at GMIT
write.table(dat.1010, file="/home/srdbadmin/srdb/projects/baumhutchings/data/CJFAS-shortcomm-multispecies.csv", sep=",")
write.table(ts.ratios.dat, file="/home/srdbadmin/srdb/projects/baumhutchings/data/CJFAS-shortcomm-multispecies-BRPratios.csv", sep=",")



