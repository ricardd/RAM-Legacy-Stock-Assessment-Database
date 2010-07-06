## fried-egg-plots.R
## produce multi-panel fried egg plots for Fish and Fisheries manuscript
## Daniel Ricard, started 2010-03-25
## Last modified: Time-stamp: <2010-07-06 12:07:57 (srdbadmin)>
setwd("/home/srdbadmin/srdb/projects/fishandfisheries/R")

require(RODBC)
require(KernSmooth)
#require(gregmisc)
require(xtable)

chan<- odbcConnect(dsn="srdbcalo")

# define as a function
fried.egg.fct <- function(grouping.type, grouping.criterion, xlabel, ylabel, legendlabel) {
gtype <- grouping.type
gcrit <- grouping.criterion
if(gtype == "all"){
  
# Schaefer-derived SSBmsy and Fmsy reference points (i.e. salt)
## salt data
  tb.salt.qu <- paste("
select tsv.assessid, a.maxyr, tsv.total, sp.bmsy, tsv.total/sp.bmsy as ratio from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.total is not null and tsv.catch_landings is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor) AND recorder != \'MYERS\')
", sep="")
  tb.salt <- sqlQuery(chan,tb.salt.qu, stringsAsFactors=FALSE)

  f.salt.qu <- paste("
select tsv.assessid, a.maxyr, (tsv.catch_landings/tsv.total) as u, sp.fmsy, (tsv.catch_landings/tsv.total)/sp.fmsy as ratio from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.catch_landings is not null and tsv.total is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor) and recorder != \'MYERS\')
", sep="")
  f.salt <- sqlQuery(chan,f.salt.qu, stringsAsFactors=FALSE)

    salt.merged <- merge(tb.salt, f.salt, "assessid")
nn <- dim(salt.merged)[1]
  salt <- data.frame(assessid = salt.merged$assessid, currentyr = salt.merged$maxyr.x, b.ratio = salt.merged$ratio.x, u.ratio = salt.merged$ratio.y, type = rep("salt",nn), fromassessment = rep("no",nn))

# assessment-derived MSY reference points (i.e. pepper)
## pepper data
  ## maximum year for which there is both SSB/TB and F
  
  ssb.pepper.qu <- paste("
select a.assessid, a.maxyr, a.biovalue, v.tsvalue, v.tsvalue/cast(a.biovalue as numeric) as ratio  from (select assessid, max(tsyear) as maxyr, biovalue from srdb.tsrelative_explicit_view where bioid like \'%Bmsy%\'  and assessid in (select assessid from srdb.assessment where recorder != \'MYERS\') group by assessid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and v.bioid like \'%Bmsy%\';
", sep="")
ssb.pepper <- sqlQuery(chan,ssb.pepper.qu, stringsAsFactors=FALSE)
  
  f.pepper.qu <- paste("
  select a.assessid, a.maxyr, a.biovalue, v.tsvalue, (case when v.tsvalue=0 then 0 else v.tsvalue/cast(a.biovalue as numeric) end) as ratio  from (select assessid, max(tsyear) as maxyr, biovalue from srdb.tsrelative_explicit_view where (bioid like \'Fmsy%\' or bioid like \'Umsy%\')  and assessid in (select assessid from srdb.assessment where recorder != \'MYERS\') group by assessid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and (v.bioid like \'Fmsy%\' or v.bioid like \'Umsy%\')
  ", sep="")
f.pepper <- sqlQuery(chan, f.pepper.qu, stringsAsFactors=FALSE)
## pepper

## only keep assessid where there exists both f and an ssb entries
  pepper.merged <- merge(ssb.pepper, f.pepper, "assessid")
nn <- dim(pepper.merged)[1]
  pepper <- data.frame(assessid = pepper.merged$assessid, currentyr =  pepper.merged$maxyr.x, b.ratio = pepper.merged$ratio.x, u.ratio = pepper.merged$ratio.y, type = rep("pepper",nn), fromassessment = rep("yes",nn))

  
## merge the salt and pepper without duplicating assessid, preferentially choosing the pepper over the salt for a given assessid
##
#
  
  temp.dat <- rbind(pepper,salt)

  ## before removing the unnecessary salt points, compare the Schaefer-derived and assessment-derived BRPs
  


  
  temp.dat.ord <- temp.dat[order(temp.dat$assessid),]
  oo<- unlist(tapply(temp.dat.ord$assessid,temp.dat.ord$assessid,order))
  crosshair.dat <- temp.dat.ord[oo==1,]

  
## REF:SQL:NUMASSESSFRIEDEGG
  nn <- dim(crosshair.dat)[1]
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMASSESSFRIEDEGG'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMASSESSFRIEDEGG',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

## REF:SQL:NUMASSESSBIOANDEXPLOITREF
  nn <- dim(subset(crosshair.dat, type == "pepper"))[1]
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMASSESSBIOANDEXPLOITREF'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMASSESSBIOANDEXPLOITREF',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

##  REF:SQL:NUMADDITIONALASSESSSCHAEFER
  nn <- dim(subset(crosshair.dat, type == "salt"))[1]
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMADDITIONALASSESSSCHAEFER'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMADDITIONALASSESSSCHAEFER',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

  ## compute statistics and store back into fishandfisheries.results
  ## percentage of stocks below Bmsy
##  REF:SQL:PERCENTASSESSMENTSBELOWBMSY
  nn <- dim(subset(crosshair.dat, b.ratio < 1))[1]/dim(crosshair.dat)[1] * 100
  nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSMENTSBELOWBMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSMENTSBELOWBMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

  ## of those below Bmsy, what percentage are below Umsy?
  nn <- dim(subset(crosshair.dat, b.ratio < 1 & u.ratio < 1))[1]/dim(subset(crosshair.dat, b.ratio < 1))[1] * 100
  nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSBELOWBMSYANDBELOWFMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSBELOWBMSYANDBELOWFMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

    ## of those below Bmsy, what percentage are above Umsy?
  nn <- dim(subset(crosshair.dat, b.ratio < 1 & u.ratio > 1))[1]/dim(subset(crosshair.dat, b.ratio < 1))[1] * 100
  nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSBELOWBMSYANDABOVEFMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSBELOWBMSYANDABOVEFMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

  ## percentage of stocks above Bmsy
    nn <- dim(subset(crosshair.dat, b.ratio > 1))[1]/dim(crosshair.dat)[1] * 100
  nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSMENTSABOVEBMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSMENTSABOVEBMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)
  ## of those above Bmsy, what percentage are below Umsy?
  nn <- dim(subset(crosshair.dat, b.ratio > 1 & u.ratio < 1))[1]/dim(subset(crosshair.dat, b.ratio > 1))[1] * 100
  nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSABOVEBMSYANDBELOWFMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSABOVEBMSYANDBELOWFMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

  
  ## percentage of stocks above Umsy
  nn <- dim(subset(crosshair.dat, u.ratio > 1))[1]/dim(crosshair.dat)[1] * 100
  nn <- round(nn,0)
  delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSMENTSABOVEFMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSMENTSABOVEFMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

    nn <- dim(subset(crosshair.dat, u.ratio < 1))[1]/dim(crosshair.dat)[1] * 100
  nn <- round(nn,0)
  delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSMENTSBELOWFMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSMENTSBELOWFMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

  
  ## fried egg contour plot

# BANDWIDTH FOR SMOOTHER
# References in Scott 1992 and Bowman and Azzalini 1997
d<-2 # the bandwidth dimension
bmsy.bw<-sqrt(var(crosshair.dat[,3]))*(4/((d+2)*length(crosshair.dat[,3])))^(1/(d+4))
umsy.bw<-sqrt(var(crosshair.dat[,4]))*(4/((d+2)*length(crosshair.dat[,4])))^(1/(d+4))

kernel.dens <- bkde2D(crosshair.dat[,c(3,4)], bandwidth=c(bmsy.bw,umsy.bw), range.x=list(c(0,2.01),c(0,2.01)))  
# please note the range restrictions at 2.01 to include the points that line up at the boundaries

# generate color palette 
palettetable.egg<-colorRampPalette(c("#BFEFFF","white","white", "yellow","#FFC125"))
#palettetable.egg<-colorRampPalette(c("white",grey(0.9),grey(0.8),grey(0.7),grey(0.6)))

    ## write a table with the data
write.table(crosshair.dat, "crosshair.dat")

  ## write a LaTeX table for the Supporting information
  qu <- paste("select a.assessid, t.scientificname, s.stocklong from srdb.assessment a, srdb.stock s, srdb.taxonomy t where a.stockid=s.stockid and s.tsn=t.tsn and a.recorder != 'MYERS' and a.assess=1")
sci.names <- sqlQuery(chan, qu)
  crosshair.for.table.t <- merge(crosshair.dat, sci.names, "assessid")

  ## timespan for each assessment
  qu <- paste("
select assessid, min(tsyear) || '-' || max(tsyear) as timespan from srdb.timeseries where assessid in (select assessid from srdb.assessment where assess=1 and recorder != 'MYERS') group by assessid
",sep="")
  timespan.dat <- sqlQuery(chan,qu)
  
  crosshair.for.table.tt <- merge(crosshair.for.table.t, timespan.dat, "assessid")

  ## get management body, assessment method and RIS ID for each assessid
  qu <- paste("
SELECT
a.assessid,
s.stocklong,
t.scientificname,
ts.timespan,
m.mgmt,
am.category,
r.risentry
FROM
srdb.management m,
srdb.assessor aa,
srdb.assessmethod am,
srdb.assessment a,
srdb.referencedoc r,
srdb.stock s,
srdb.taxonomy t,
(select assessid, min(tsyear) || '-' || max(tsyear) as timespan from srdb.timeseries group by assessid) as ts
WHERE
am.methodshort=a.assessmethod AND
r.assessid = a.assessid AND
ts.assessid=a.assessid AND
a.stockid = s.stockid AND
s.tsn = t.tsn AND
r.risfield='ID' AND 
a.assessorid = aa.assessorid AND 
m.mgmt = aa.mgmt AND
a.recorder != 'MYERS' AND
a.assess=1
GROUP BY 
r.risentry, 
a.assessid, s.stocklong, t.scientificname, ts.timespan, 
m.country,
m.managementauthority,
m.mgmt, am.category
ORDER BY 
m.country,
t.scientificname
",sep="")
mgmt.dat <- sqlQuery(chan, qu)

    crosshair.for.table.temp <- merge(crosshair.for.table.tt, mgmt.dat, "assessid", all.y=TRUE)
  crosshair.for.table.temp$ref <- paste("\\cite{", crosshair.for.table.temp$risentry, "}",sep="")
  
##  write.table(crosshair.for.table.temp, "crosshair-table.dat")
  crosshair.for.table <- data.frame(mgmt=crosshair.for.table.temp$mgmt, stock=crosshair.for.table.temp$stocklong.y ,scientificname=crosshair.for.table.temp$scientificname.y, assessmethod=crosshair.for.table.temp$category, timespan=crosshair.for.table.temp$timespan.y, currentyear=crosshair.for.table.temp$currentyr, Bratio=crosshair.for.table.temp$b.ratio ,Uratio=crosshair.for.table.temp$u.ratio , fromassessment=crosshair.for.table.temp$fromassessment, ref=crosshair.for.table.temp$ref)

  crosshair.for.table$scientificname <- paste("\\textit{",crosshair.for.table$scientificname,"}",sep="")
  crosshair.for.table <- crosshair.for.table[order(crosshair.for.table$mgmt,crosshair.for.table$scientificname),]

  write.table(crosshair.for.table, "crosshair-table.dat")
  write.csv(crosshair.for.table, "crosshair-table.csv")

my.caption <- c("Summary of population-dynamics model based assessments in the RAM Legacy database, including the management body (acronyms from Table 1), assessment method, timespan of their longest time series data, estimated ratios of current biomass to the biomass at MSY and current harvest rate to the harvest rate that results in MSY. Estimated ratios were preferentially obtained directly from the assessment document or derived from surplus production models. When both SSBmsy and Bmsy reference points were available, SSB was chosen preferentially.")

  my.table.S2 <- xtable(crosshair.for.table, caption=my.caption, label=c("tab:crosshair"), digits=2, align="cp{1.8cm}p{4cm}p{4cm}p{3.5cm}ccccp{1.5cm}c")
  print(my.table.S2, type="latex", file="../tex/Table-S1.tex", include.rownames=FALSE, floating=FALSE, tabular.environment="longtable", caption.placement="bottom", sanitize.text.function=I)
#  write.table(my.table.S2, "../tex/Table-S1.tex")
#  sink("../tex/Table-S1.tex")
#  my.table.S2
#  sink()

  crosshair.dat$b.ratio[crosshair.dat$b.ratio>2] <- 2
  crosshair.dat$u.ratio[crosshair.dat$u.ratio>2] <- 2

##  contour(kernel.dens$x1, kernel.dens$x2, kernel.dens$fhat, nlevels=40, levels=palettetable.egg)

## for single plot  
##  par(mar=c(5.1, 5.1, 4.1, 2.1))

#  if(xlabel) {my.xlab <- expression(SSB[curr]/SSB[MSY])} else {my.xlab <- ""}
  if(xlabel) {my.xlab <- expression(B[curr]/B[MSY])} else {my.xlab <- ""}
  if(ylabel) {my.ylab <- expression(U[curr]/U[MSY])} else {my.ylab <- ""}

  image(kernel.dens$x1, kernel.dens$x2, kernel.dens$fhat, col=palettetable.egg(length(kernel.dens$x1)), xlab = my.xlab, ylab = my.ylab, xlim=c(-0.05,2.05), ylim=c(-0.05,2.05), cex.lab=1.3)
contour(kernel.dens$x1, kernel.dens$x2, kernel.dens$fhat,drawlabels=FALSE,nlevels=3,add=TRUE,col=grey(0.4),lwd=0.7)
abline(h=1, lty=2, lwd=1.2); abline(v=1, lty=2, lwd=1.2)
points(crosshair.dat[,3], crosshair.dat[,4], col=1, cex=.7, pch=ifelse(crosshair.dat$type=="pepper",19,21), bg="white")

  n.assessid <- dim(crosshair.dat)[1]
  mtext(side=3, paste("all assessments", " (n=", n.assessid, ")", sep=""), line=2)


}
else if(gtype == "mgmt"){

# Schaefer-derived SSBmsy and Fmsy reference points (i.e. salt)
## salt data
  tb.salt.qu <- paste("
select tsv.assessid, a.maxyr, tsv.total, sp.bmsy, tsv.total/sp.bmsy as ratio from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.total is not null and tsv.catch_landings is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor where mgmt IN ",gcrit,") AND recorder != \'MYERS\')
", sep="")
  tb.salt <- sqlQuery(chan,tb.salt.qu, stringsAsFactors=FALSE)

# select tsv.assessid, a.maxyr, tsv.total, sp.bmsy, tsv.total/sp.bmsy as ratio from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.total is not null and tsv.catch_landings is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor where mgmt = \'",gcrit,"\') AND recorder != \'MYERS\')


## select tsv.assessid, tsv.tsyear as maxyr, tsv.total, sp.bmsy, tsv.total/sp.bmsy as ratio from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.total is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor where mgmt = \'",gcrit,"\')  and recorder != \'MYERS\')

  f.salt.qu <- paste("
select tsv.assessid, a.maxyr, (tsv.catch_landings/tsv.total) as u, sp.fmsy, (tsv.catch_landings/tsv.total)/sp.fmsy as ratio from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.catch_landings is not null and tsv.total is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor where mgmt IN ",gcrit,") and recorder != \'MYERS\')

", sep="")
  f.salt <- sqlQuery(chan,f.salt.qu, stringsAsFactors=FALSE)

# select tsv.assessid, a.maxyr, (tsv.catch_landings/tsv.total) as u, sp.fmsy, (tsv.catch_landings/tsv.total)/sp.fmsy as ratio from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.catch_landings is not null and tsv.total is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor where mgmt = \'",gcrit,"\') and recorder != \'MYERS\')

# select tsv.assessid, tsv.tsyear as maxyr, (tsv.catch_landings/tsv.total) as u, sp.fmsy, (tsv.catch_landings/tsv.total)/sp.fmsy as ratio from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and catch_landings is not null and total is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor where mgmt = \'",gcrit,"\') and recorder != \'MYERS\')

    salt.merged <- merge(tb.salt, f.salt, "assessid")
nn <- dim(salt.merged)[1]
  salt <- data.frame(assessid = salt.merged$assessid, currentyr = salt.merged$maxyr.x,  b.ratio = salt.merged$ratio.x, u.ratio = salt.merged$ratio.y, type = rep("salt",nn), fromassessment = rep("no",nn))

# assessment-derived MSY reference points (i.e. pepper)
  ## what is the "current year"? i.e. the maximum year for which we have both a B and an F
##  maxyr.qu <- paste("select assessid, max(tsyear) from srdb.tsrelative_explicit_view where bioid like '%msy') ,  sep="")
  
## pepper data
  ssb.pepper.qu <- paste("
select a.assessid, a.maxyr, a.biovalue, v.tsvalue, v.tsvalue/cast(a.biovalue as numeric) as ratio  from (select assessid, max(tsyear) as maxyr, biovalue from srdb.tsrelative_explicit_view where bioid like \'%Bmsy%\'  and assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor where mgmt IN ",gcrit, ") and recorder != \'MYERS\') group by assessid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and v.bioid like \'%Bmsy%\';
", sep="")
ssb.pepper <- sqlQuery(chan,ssb.pepper.qu, stringsAsFactors=FALSE)

#select a.assessid, a.maxyr, a.biovalue, v.tsvalue, v.tsvalue/cast(a.biovalue as numeric) as ratio  from (select assessid, max(tsyear) as maxyr, biovalue from srdb.tsrelative_explicit_view where bioid like \'%Bmsy%\'  and assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor where mgmt = \'",gcrit, "\') and recorder != \'MYERS\') group by assessid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and v.bioid like \'%Bmsy%\';

  f.pepper.qu <- paste("
  select a.assessid, a.maxyr, a.biovalue, v.tsvalue, (case when v.tsvalue=0 then 0 else v.tsvalue/cast(a.biovalue as numeric) end) as ratio  from (select assessid, max(tsyear) as maxyr, biovalue from srdb.tsrelative_explicit_view where (bioid like \'Fmsy%\' or bioid like \'Umsy%\')  and assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor where mgmt IN ", gcrit, ") and recorder != \'MYERS\') group by assessid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and (v.bioid like \'Fmsy%\' or v.bioid like \'Umsy%\')
  ", sep="")
f.pepper <- sqlQuery(chan, f.pepper.qu, stringsAsFactors=FALSE)
## pepper

#   select a.assessid, a.maxyr, a.biovalue, v.tsvalue, (case when v.tsvalue=0 then 0 else v.tsvalue/cast(a.biovalue as numeric) end) as ratio  from (select assessid, max(tsyear) as maxyr, biovalue from srdb.tsrelative_explicit_view where (bioid like \'Fmsy%\' or bioid like \'Umsy%\')  and assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor where mgmt = \'", gcrit, "\') and recorder != \'MYERS\') group by assessid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and (v.bioid like \'Fmsy%\' or v.bioid like \'Umsy%\')

## only keep assessid where there exists both f and an ssb entries
  pepper.merged <- merge(ssb.pepper, f.pepper, "assessid")
nn <- dim(pepper.merged)[1]
  pepper <- data.frame(assessid = pepper.merged$assessid, currentyr =  pepper.merged$maxyr.x, b.ratio = pepper.merged$ratio.x, u.ratio = pepper.merged$ratio.y, type = rep("pepper",nn), fromassessment = rep("yes",nn))

## merge the salt and pepper without duplicating assessid, preferentially choosing the pepper over the salt for a given assessid
##
#
  
  temp.dat <- rbind(pepper,salt)
  temp.dat.ord <- temp.dat[order(temp.dat$assessid),]
  oo<- unlist(tapply(temp.dat.ord$assessid,temp.dat.ord$assessid,order))
  crosshair.dat <- temp.dat.ord[oo==1,]
print(dim(crosshair.dat)[1])
print(unique(crosshair.dat$assessid))
  ## fried egg contour plot

## percent above and below Bmsy and Fmsy for management body
## TOTAL NUMBER FOR THIS MANAGEMENT BODY
  nn <- dim(crosshair.dat)[1]
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMASSESSFRIEDTOTAL",gcrit,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMASSESSFRIEDTOTAL",gcrit,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

## BELOW Bmsy
nn <- dim(subset(crosshair.dat, b.ratio < 1))[1]/dim(crosshair.dat)[1] * 100
nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSFRIEDBELOWBMSY",gcrit,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSFRIEDBELOWBMSY",gcrit,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)
nn <- dim(subset(crosshair.dat, b.ratio < 1))[1]
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMASSESSFRIEDBELOWBMSY",gcrit,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMASSESSFRIEDBELOWBMSY",gcrit,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)
## of those BELOW Bmsy, percentage above Fmsy
nn <- dim(subset(crosshair.dat, b.ratio < 1 & u.ratio>1))[1]/dim(subset(crosshair.dat, b.ratio < 1))[1] * 100
nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSFRIEDBELBMSYANDABOVEFMSY",gcrit,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSFRIEDBELBMSYANDABOVEFMSY",gcrit,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)
## of those BELOW Bmsy, percentage below Fmsy
nn <- dim(subset(crosshair.dat, b.ratio < 1 & u.ratio<1))[1]/dim(subset(crosshair.dat, b.ratio < 1))[1] * 100
nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSFRIEDBELBMSYANDBELOWFMSY",gcrit,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSFRIEDBELBMSYANDBELOWFMSY",gcrit,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

## BELOW Fmsy
  nn <- dim(subset(crosshair.dat, u.ratio < 1))[1]/dim(crosshair.dat)[1] * 100
nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSFRIEDBELOWFMSY",gcrit,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSFRIEDBELOWFMSY",gcrit,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

## ABOVE Bmsy
  nn <- dim(subset(crosshair.dat, b.ratio > 1))[1]/dim(crosshair.dat)[1] * 100
nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSFRIEDABOVEBMSY",gcrit,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSFRIEDABOVEBMSY",gcrit,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)
## ABOVE Fmsy
  nn <- dim(subset(crosshair.dat, u.ratio > 1))[1]/dim(crosshair.dat)[1] * 100
nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSFRIEDABOVEFMSY",gcrit,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSFRIEDABOVEFMSY",gcrit,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)


# BANDWIDTH FOR SMOOTHER
# References in Scott 1992 and Bowman and Azzalini 1997
d<-2 # the bandwidth dimension
bmsy.bw<-sqrt(var(crosshair.dat[,3]))*(4/((d+2)*length(crosshair.dat[,3])))^(1/(d+4))
umsy.bw<-sqrt(var(crosshair.dat[,4]))*(4/((d+2)*length(crosshair.dat[,4])))^(1/(d+4))
1
kernel.dens <- bkde2D(crosshair.dat[,c(3,4)], bandwidth=c(bmsy.bw,umsy.bw), range.x=list(c(0,2.01),c(0,2.01)))  
# please note the range restrictions at 2.01 to include the points that line up at the boundaries

# generate color palette 
palettetable.egg<-colorRampPalette(c("#BFEFFF","white","white", "yellow","#FFC125"))

#palettetable.egg<-colorRampPalette(c("white",grey(0.9),grey(0.8),grey(0.7),grey(0.6)))
  
  crosshair.dat$b.ratio[crosshair.dat$b.ratio>2] <- 2
  crosshair.dat$u.ratio[crosshair.dat$u.ratio>2] <- 2

##  contour(kernel.dens$x1, kernel.dens$x2, kernel.dens$fhat, nlevels=40, levels=palettetable.egg)

#    if(xlabel) {my.xlab <- expression(SSB[curr]/SSB[MSY])} else {my.xlab <- ""}
#  if(ylabel) {my.ylab <- expression(U[curr]/U[MSY])} else {my.ylab <- ""}

## axis(side=1, labels=FALSE)
image(kernel.dens$x1, kernel.dens$x2, kernel.dens$fhat, col=palettetable.egg(length(kernel.dens$x1)), xlab = "", ylab = "", xlim=c(-0.05,2.05), ylim=c(-0.05,2.05), cex.lab=1.3, axes=FALSE)
contour(kernel.dens$x1, kernel.dens$x2, kernel.dens$fhat,drawlabels=FALSE,nlevels=3,add=TRUE,col=grey(0.4),lwd=0.7)
abline(h=1, lty=2, lwd=1.2); abline(v=1, lty=2, lwd=1.2)
points(crosshair.dat[,3], crosshair.dat[,4], col=1, cex=.7, pch=ifelse(crosshair.dat$type=="pepper",19,21), bg="white")

ifelse(xlabel, axis(side=1, labels=TRUE), axis(side=1, labels=FALSE))
ifelse(ylabel, axis(side=2, labels=TRUE), axis(side=2, labels=FALSE))


  n.assessid <- dim(crosshair.dat)[1]
#  my.label <- paste(gcrit, " (n=", n.assessid, ")", sep="")
  my.label <- paste(legendlabel, " (n=", n.assessid, ")", sep="")
#  mtext(side=3, my.label, line=2)

  
legend("topright",my.label)
  ##  mtext(side=3, paste(gtype, "=", gcrit), line=2)
##  mtext(side=3, paste("n = ", n.assessid), line=1)
  } # end if


} ## end function fried.egg.fct



## now generate some PDF with plots

pdf("friedegg-by-mgmt.pdf", width=8, height=10)
multipanel <- "TRUE"
  if(multipanel){
    par(mar=c(2,2,1,1), oma=c(2,2,0,0))
}else{par(mar=c(5.1, 5.1, 4.1, 2.1))}

#par(mfrow=c(5,2))
par(mfrow=c(4,2))
fried.egg.fct("mgmt",c("('NMFS')"),"FALSE","TRUE","NMFS")
fried.egg.fct("mgmt",c("('ICES')"),"FALSE","FALSE","ICES")
fried.egg.fct("mgmt",c("('MFish')"),"FALSE","TRUE","MFish")
fried.egg.fct("mgmt",c("('DFO')"),"FALSE","FALSE","DFO")
fried.egg.fct("mgmt",c("('AFMA')"),"FALSE","TRUE","AFMA")
mtext(expression(U[curr]/U[MSY]), side=2, line=1, outer=TRUE, cex=0.75)
fried.egg.fct("mgmt",c("('DETMCM')"),"FALSE","FALSE","DETMCM")
#fried.egg.fct("mgmt","NAFO","FALSE","TRUE")
#fried.egg.fct("mgmt","ICCAT","FALSE","FALSE")
#fried.egg.fct("mgmt","CFP","TRUE","TRUE")
#fried.egg.fct("mgmt","WCPFC","TRUE","FALSE")
fried.egg.fct("mgmt",c("('NAFO','ICCAT')"),"TRUE","TRUE","Atlantic")
#fried.egg.fct("mgmt",c("('IATTC','IPHC','SPRFMO')"),"TRUE","FALSE","Pacific")
mtext(expression(B[curr]/B[MSY]), side=1, line=1, outer=TRUE, cex=0.75)

dev.off()

#
#



#fried.egg.fct("ocean","Atlantic","TRUE","TRUE")
#fried.egg.fct("ocean","Pacific","TRUE","TRUE")


## fried.egg.fct("assessor","NEFSC")
## fried.egg.fct("LME","Baltic Sea")

pdf("friedegg-single.pdf", width=8, height=10)
multipanel <- "FALSE"
  if(multipanel){
    par(mar=c(1,1,1,1), oma=c(3.5,3,0,0))
}else{par(mar=c(5.1, 5.1, 4.1, 2.1))}
fried.egg.fct("all","all","TRUE","TRUE","")
dev.off()


qu <- paste("
select mgmt, category, count(*) from (select mm.mgmt, (CASE when am.category in ('Integrated Analysis','Statistical catch at age model', 'Statistical catch at length model') THEN 'Statistical catch-at-age/length models' ELSE (CASE WHEN am.category='VPA' THEN 'Virtual Population Analyses' ELSE (CASE WHEN am.category='' THEN 'Biomass dynamics models' ELSE am.category END) END) END) as category from srdb.assessment aa, srdb.assessmethod am, srdb.assessor ass, srdb.management mm where aa.assessorid=ass.assessorid and ass.mgmt=mm.mgmt and aa.assessmethod=am.methodshort and aa.recorder != 'MYERS' and aa.assess=1) as a group by mgmt, category order by mgmt
", sep="")

methods.by.mgmt <- sqlQuery(chan,qu)

numerator <- subset(methods.by.mgmt, mgmt== 'AFMA' & category == 'Statistical catch-at-age/length models')$count
denominator <- sum(subset(methods.by.mgmt, mgmt== 'AFMA')$count)
nn<-round(numerator/denominator * 100, 0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTSCALAFMA'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTSCALAFMA',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

numerator <- subset(methods.by.mgmt, mgmt== 'MFish' & category == 'Statistical catch-at-age/length models')$count
denominator <- sum(subset(methods.by.mgmt, mgmt== 'MFish')$count)
nn<-round(numerator/denominator * 100, 0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTSCALMFISH'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTSCALMFISH',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

numerator <- subset(methods.by.mgmt, mgmt== 'NMFS' & category == 'Statistical catch-at-age/length models')$count
denominator <- sum(subset(methods.by.mgmt, mgmt== 'NMFS')$count)
nn<-round(numerator/denominator * 100, 0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTSCALNMFS'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTSCALNMFS',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

numerator <- subset(methods.by.mgmt, mgmt== 'ICES' & category == 'Virtual Population Analyses')$count
denominator <- sum(subset(methods.by.mgmt, mgmt== 'ICES')$count)
nn<-round(numerator/denominator * 100, 0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTVPAICES'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTVPAICES',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

numerator <- subset(methods.by.mgmt, mgmt== 'CFP' & category == 'Virtual Population Analyses')$count
denominator <- sum(subset(methods.by.mgmt, mgmt== 'CFP')$count)
nn<-round(numerator/denominator * 100, 0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTVPACFP'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTVPACFP',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

numerator <- subset(methods.by.mgmt, mgmt== 'DFO' & category == 'Virtual Population Analyses')$count
denominator <- sum(subset(methods.by.mgmt, mgmt== 'DFO')$count)
nn<-round(numerator/denominator * 100, 0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTVPADFO'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTVPADFO',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

odbcClose(chan)
save.image()

