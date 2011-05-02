library(RODBC)
library(KernSmooth)

# define as a function
fried.egg.fct <- function(grouping.type, grouping.criterion, sql.label, xlabel, ylabel, legendlabel, plot.true) {
gtype <- grouping.type
gcrit <- grouping.criterion
if(gtype == "all"){
  
## BIOMASS RATIOS

## Schaefer-derived SSBmsy reference points (i.e. salt)
## salt data for biomass
  tb.salt.qu <- paste("
select tsv.assessid, a.maxyr, tsv.total as numerator, sp.bmsy as denominator, tsv.total/sp.bmsy as ratio, 'no' as btype from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.total is not null and tsv.catch_landings is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor) AND recorder != \'MYERS\')
", sep="")
  tb.salt <- sqlQuery(chan,tb.salt.qu, stringsAsFactors=FALSE)

## assessment-derived MSY reference points (i.e. pepper)
## maximum year for which there is both SSB/TB and F
  
  ssb.pepper.qu <- paste("
select a.assessid, a.maxyr, a.biovalue as numerator, v.tsvalue as denominator, v.tsvalue/cast(a.biovalue as numeric) as ratio, 'yes' as btype  from (select assessid, max(tsyear) as maxyr, biovalue from srdb.tsrelative_explicit_view where bioid like \'%Bmsy%\'  and assessid in (select assessid from srdb.assessment where recorder != \'MYERS\') group by assessid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and v.bioid like \'%Bmsy%\';
", sep="")
ssb.pepper <- sqlQuery(chan,ssb.pepper.qu, stringsAsFactors=FALSE)

## merge the biomass ratios
  temp.b.dat <- rbind(ssb.pepper,tb.salt)
  
## keep the pepper preferentially
## first, sort by assessid
  temp.bdat.ord <- temp.b.dat[order(temp.b.dat$assessid),]
  oo<- unlist(tapply(temp.bdat.ord$assessid,temp.bdat.ord$assessid,order))
  crosshair.b.dat <- temp.bdat.ord[oo==1,]
  
  
## EXPLOITATION RATIOS
 
## Schaefer-derived Fmsy reference points (i.e. salt)
## salt data for exploitation rate
  f.salt.qu <- paste("
select tsv.assessid, a.maxyr, (tsv.catch_landings/tsv.total) as u, sp.fmsy, (tsv.catch_landings/tsv.total)/sp.fmsy as ratio, 'no' as utype from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.catch_landings is not null and tsv.total is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor) and recorder != \'MYERS\')
", sep="")
  f.salt <- sqlQuery(chan,f.salt.qu, stringsAsFactors=FALSE)

## assessment-derived MSY reference points (i.e. pepper)  
#    salt.merged <- merge(tb.salt, f.salt, "assessid")
#nn <- dim(salt.merged)[1]
#  salt <- data.frame(assessid = salt.merged$assessid, currentyr = salt.merged$maxyr.x, b.ratio = salt.merged$ratio.x, u.ratio = salt.merged$ratio.y, type = rep("salt",nn), fromassessment = rep("no",nn))
  f.pepper.qu <- paste("
  select a.assessid, a.maxyr, a.biovalue as u, v.tsvalue as fmsy, (case when v.tsvalue=0 then 0 else v.tsvalue/cast(a.biovalue as numeric) end) as ratio, 'yes' as utype  from (select assessid, max(tsyear) as maxyr, biovalue from srdb.tsrelative_explicit_view where (bioid like \'Fmsy%\' or bioid like \'Umsy%\')  and assessid in (select assessid from srdb.assessment where recorder != \'MYERS\') group by assessid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and (v.bioid like \'Fmsy%\' or v.bioid like \'Umsy%\')
  ", sep="")
f.pepper <- sqlQuery(chan, f.pepper.qu, stringsAsFactors=FALSE)

# merge the exploitation ratios
  temp.u.dat <- rbind(f.pepper, f.salt)

  ## keep the pepper preferentially
## first, sort by assessid
  temp.udat.ord <- temp.u.dat[order(temp.u.dat$assessid),]
  oo<- unlist(tapply(temp.udat.ord$assessid,temp.udat.ord$assessid,order))
  crosshair.u.dat <- temp.udat.ord[oo==1,]

  
## merge the salt and pepper
##
#
crosshair.dat <- merge(crosshair.b.dat, crosshair.u.dat, "assessid")  

  ## REF:SQL:NUMASSESSFRIEDEGG
  nn <- dim(crosshair.dat)[1]
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMASSESSFRIEDEGG'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMASSESSFRIEDEGG',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

    ## REF:SQL:PERCENTASSESSFRIEDEGG
  tot.n <- sqlQuery(chan,"SELECT COUNT(*) from srdb.assessment where assess=1 and recorder !='MYERS'")
  nn <- dim(crosshair.dat)[1] / tot.n * 100
  nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSFRIEDEGG'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSFRIEDEGG',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

  
  
  ## REF:SQL:NUMASSESSBIOASSESSREF
  nn <- dim(subset(crosshair.dat, btype == "yes"))[1]
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMASSESSBIOASSESSREF'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMASSESSBIOASSESSREF',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

    ## REF:SQL:NUMASSESSEXPLOITASSESSREF
  nn <- dim(subset(crosshair.dat, utype == "yes"))[1]
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMASSESSEXPLOITASSESSREF'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMASSESSEXPLOITASSESSREF',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

    ## REF:SQL:NUMASSESSBIOSCHAEFERREF
  nn <- dim(subset(crosshair.dat, btype == "no"))[1]
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMASSESSBIOSCHAEFERREF'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMASSESSBIOSCHAEFERREF',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

    ## REF:SQL:NUMASSESSEXPLOITSCHAEFERREF
  nn <- dim(subset(crosshair.dat, utype == "no"))[1]
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMASSESSEXPLOITSCHAEFERREF'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMASSESSEXPLOITSCHAEFERREF',",nn,")",sep="" )
sqlQuery(chan,insert.qu)
  
  ## percentage of stocks below Bmsy
##  REF:SQL:PERCENTASSESSMENTSBELOWBMSY
  nn <- dim(subset(crosshair.dat, ratio.x < 1))[1]/dim(crosshair.dat)[1] * 100
  nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSMENTSBELOWBMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSMENTSBELOWBMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

  ## of those below Bmsy, what percentage are below Umsy?
  nn <- dim(subset(crosshair.dat, ratio.x < 1 & ratio.y < 1))[1]/dim(subset(crosshair.dat, ratio.x < 1))[1] * 100
  nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSBELOWBMSYANDBELOWFMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSBELOWBMSYANDBELOWFMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

    ## of those below Bmsy, what percentage are above Umsy?
  nn <- dim(subset(crosshair.dat, ratio.x < 1 & ratio.y > 1))[1]/dim(subset(crosshair.dat, ratio.x < 1))[1] * 100
  nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSBELOWBMSYANDABOVEFMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSBELOWBMSYANDABOVEFMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

  ## percentage of stocks above Bmsy
    nn <- dim(subset(crosshair.dat, ratio.x > 1))[1]/dim(crosshair.dat)[1] * 100
  nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSMENTSABOVEBMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSMENTSABOVEBMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)
  ## of those above Bmsy, what percentage are below Umsy?
  nn <- dim(subset(crosshair.dat, ratio.x > 1 & ratio.y < 1))[1]/dim(subset(crosshair.dat, ratio.x > 1))[1] * 100
  nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSABOVEBMSYANDBELOWFMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSABOVEBMSYANDBELOWFMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

  
  ## percentage of stocks above Umsy
  nn <- dim(subset(crosshair.dat, ratio.y > 1))[1]/dim(crosshair.dat)[1] * 100
  nn <- round(nn,0)
  delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSMENTSABOVEFMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSMENTSABOVEFMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

    nn <- dim(subset(crosshair.dat, ratio.y < 1))[1]/dim(crosshair.dat)[1] * 100
  nn <- round(nn,0)
  delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSMENTSBELOWFMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSMENTSBELOWFMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

  ## fried egg contour plot

# BANDWIDTH FOR SMOOTHER
# References in Scott 1992 and Bowman and Azzalini 1997
d<-2 # the bandwidth dimension
bmsy.bw<-sqrt(var(crosshair.dat[,5]))*(4/((d+2)*length(crosshair.dat[,5])))^(1/(d+4))
umsy.bw<-sqrt(var(crosshair.dat[,10]))*(4/((d+2)*length(crosshair.dat[,10])))^(1/(d+4))

kernel.dens <- bkde2D(crosshair.dat[,c(5,10)], bandwidth=c(bmsy.bw,umsy.bw), range.x=list(c(0,2.01),c(0,2.01)))  
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
#  crosshair.for.table <- data.frame(mgmt=crosshair.for.table.temp$mgmt, stock=crosshair.for.table.temp$stocklong.y ,scientificname=crosshair.for.table.temp$scientificname.y, assessmethod=crosshair.for.table.temp$category, timespan=crosshair.for.table.temp$timespan.y, currentyear=crosshair.for.table.temp$maxyr.x, Bratio=crosshair.for.table.temp$ratio.x, bfromassessment=crosshair.for.table.temp$btype, Uratio=crosshair.for.table.temp$ratio.y, ufromassessment=crosshair.for.table.temp$utype, ref=crosshair.for.table.temp$ref)

 crosshair.for.table <- data.frame(mgmt=crosshair.for.table.temp$mgmt, stock=crosshair.for.table.temp$stocklong.y ,scientificname=crosshair.for.table.temp$scientificname.y, assessmethod=crosshair.for.table.temp$category, timespan=crosshair.for.table.temp$timespan.y, currentyear=crosshair.for.table.temp$maxyr.x, Bratio=crosshair.for.table.temp$ratio.x, bfromassessment=crosshair.for.table.temp$btype, Uratio=crosshair.for.table.temp$ratio.y, ufromassessment=crosshair.for.table.temp$utype) # , ref=crosshair.for.table.temp$ref)

crosshair.for.table.withref <- data.frame(mgmt=crosshair.for.table.temp$mgmt, stock=crosshair.for.table.temp$stocklong.y ,scientificname=crosshair.for.table.temp$scientificname.y, assessmethod=crosshair.for.table.temp$category, timespan=crosshair.for.table.temp$timespan.y, currentyear=crosshair.for.table.temp$maxyr.x, Bratio=crosshair.for.table.temp$ratio.x, bfromassessment=crosshair.for.table.temp$btype, Uratio=crosshair.for.table.temp$ratio.y, ufromassessment=crosshair.for.table.temp$utype, ref=crosshair.for.table.temp$ref)

  crosshair.for.table$scientificname <- paste("\\textit{",crosshair.for.table$scientificname,"}",sep="")
  crosshair.for.table <- crosshair.for.table[order(crosshair.for.table$mgmt,crosshair.for.table$scientificname),]


   crosshair.for.table.withref$scientificname <- paste("\\textit{",crosshair.for.table.withref$scientificname,"}",sep="")
  crosshair.for.table.withref <- crosshair.for.table.withref[order(crosshair.for.table.withref$mgmt,crosshair.for.table.withref$scientificname),]


  write.table(crosshair.for.table, "crosshair-table.dat")
  write.csv(crosshair.for.table, "crosshair-table.csv")

  write.table(crosshair.for.table.withref, "crosshair-table-withref.dat")
  write.csv(crosshair.for.table.withref, "crosshair-table-withref.csv")

my.caption <- c("Summary of population-dynamics model based assessments in the RAM Legacy database, including the management body (acronyms from Table 1), assessment method, timespan of their longest time series data, estimated ratios of current biomass to the biomass at MSY and current harvest rate to the harvest rate that results in MSY. Estimated ratios were preferentially obtained directly from the assessment document or derived from surplus production models. When both SSBmsy and Bmsy reference points were available, SSB was chosen preferentially.")

  my.table.S2 <- xtable(crosshair.for.table, caption=my.caption, label=c("tab:crosshair"), digits=2, align="cp{1.8cm}p{3.5cm}p{3.5cm}p{3cm}cccp{0.9cm}cp{0.9cm}")
  my.table.S2.withref <- xtable(crosshair.for.table.withref, caption=my.caption, label=c("tab:crosshair"), digits=2, align="cp{1.8cm}p{3.5cm}p{3.5cm}p{3cm}cccp{0.9cm}cp{0.9cm}c")

## Table S1
  print(my.table.S2, type="latex", file="../../tex/first-review/Table-S1.tex", include.rownames=FALSE, floating=FALSE, tabular.environment="longtable", caption.placement="bottom", sanitize.text.function=I)

## Table S1 with BibTex \ref
  print(my.table.S2.withref, type="latex", file="../../tex/first-review/Table-S1-withref.tex", include.rownames=FALSE, floating=FALSE, tabular.environment="longtable", caption.placement="bottom", sanitize.text.function=I)

## html table to use in Word
  crosshair.for.table.withref$scientificname <- paste(crosshair.for.table.withref$scientificname,sep="")
  my.table.S2 <- xtable(crosshair.for.table, caption=my.caption, label=c("tab:crosshair"), digits=2, align="cp{1.8cm}p{3.5cm}p{3.5cm}p{3cm}cccp{0.9cm}cp{0.9cm}")
 print(my.table.S2, type="html", file="../../tex/first-review/Table-S1.html", include.rownames=FALSE, floating=FALSE, tabular.environment="longtable", caption.placement="bottom", sanitize.text.function=I)
 
  crosshair.dat$ratio.x[crosshair.dat$ratio.x>2] <- 2
  crosshair.dat$ratio.y[crosshair.dat$ratio.y>2] <- 2

##  contour(kernel.dens$x1, kernel.dens$x2, kernel.dens$fhat, nlevels=40, levels=palettetable.egg)

## for single plot  
##  par(mar=c(5.1, 5.1, 4.1, 2.1))

#  if(xlabel) {my.xlab <- expression(SSB[curr]/SSB[MSY])} else {my.xlab <- ""}
  if(xlabel) {my.xlab <- expression(B[curr]/B[MSY])} else {my.xlab <- ""}
  if(ylabel) {my.ylab <- expression(U[curr]/U[MSY])} else {my.ylab <- ""}

  image(kernel.dens$x1, kernel.dens$x2, kernel.dens$fhat, col=palettetable.egg(length(kernel.dens$x1)), xlab = my.xlab, ylab = my.ylab, xlim=c(-0.05,2.05), ylim=c(-0.05,2.05), cex.lab=1.3)
contour(kernel.dens$x1, kernel.dens$x2, kernel.dens$fhat,drawlabels=FALSE,nlevels=3,add=TRUE,col=grey(0.4),lwd=0.7)
abline(h=1, lty=2, lwd=1.2); abline(v=1, lty=2, lwd=1.2)
points(crosshair.dat[,5], crosshair.dat[,10], col=1, cex=.7, pch=ifelse((crosshair.dat$btype=="no" | crosshair.dat$utype=="no"),21,19), bg="white")

  n.assessid <- dim(crosshair.dat)[1]
  mtext(side=3, paste("all assessments", " (n=", n.assessid, ")", sep=""), line=2)

}
else if(gtype == "mgmt"){

## BIOMASS RATIOS

## Schaefer-derived SSBmsy reference points (i.e. salt)
## salt data for biomass
  tb.salt.qu <- paste("
select tsv.assessid, a.maxyr, tsv.total as numerator, sp.bmsy as denominator, tsv.total/sp.bmsy as ratio, 'no' as btype from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.total is not null and tsv.catch_landings is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor where mgmt IN ",gcrit,") AND recorder != \'MYERS\')
", sep="")
  tb.salt <- sqlQuery(chan,tb.salt.qu, stringsAsFactors=FALSE)

## assessment-derived MSY reference points (i.e. pepper)
## maximum year for which there is both SSB/TB and F
  
  ssb.pepper.qu <- paste("
select a.assessid, a.maxyr, a.biovalue as numerator, v.tsvalue as denominator, v.tsvalue/cast(a.biovalue as numeric) as ratio, 'yes' as btype  from (select assessid, max(tsyear) as maxyr, biovalue from srdb.tsrelative_explicit_view where bioid like \'%Bmsy%\'  and assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor where mgmt IN ",gcrit, ") and recorder != \'MYERS\') group by assessid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and v.bioid like \'%Bmsy%\';
", sep="")
ssb.pepper <- sqlQuery(chan,ssb.pepper.qu, stringsAsFactors=FALSE)

## merge the biomass ratios
  temp.b.dat <- rbind(ssb.pepper,tb.salt)
  
## keep the pepper preferentially
## first, sort by assessid
  temp.bdat.ord <- temp.b.dat[order(temp.b.dat$assessid),]
  oo<- unlist(tapply(temp.bdat.ord$assessid,temp.bdat.ord$assessid,order))
  crosshair.b.dat <- temp.bdat.ord[oo==1,]
  
  
## EXPLOITATION RATIOS
 
## Schaefer-derived Fmsy reference points (i.e. salt)
## salt data for exploitation rate
  f.salt.qu <- paste("
select tsv.assessid, a.maxyr, (tsv.catch_landings/tsv.total) as u, sp.fmsy, (tsv.catch_landings/tsv.total)/sp.fmsy as ratio, 'no' as utype from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.catch_landings is not null and tsv.total is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor where mgmt IN ",gcrit,") and recorder != \'MYERS\')
", sep="")
  f.salt <- sqlQuery(chan,f.salt.qu, stringsAsFactors=FALSE)

## assessment-derived MSY reference points (i.e. pepper)  

  f.pepper.qu <- paste("
  select a.assessid, a.maxyr, a.biovalue as u, v.tsvalue as fmsy, (case when v.tsvalue=0 then 0 else v.tsvalue/cast(a.biovalue as numeric) end) as ratio, 'yes' as utype  from (select assessid, max(tsyear) as maxyr, biovalue from srdb.tsrelative_explicit_view where (bioid like \'Fmsy%\' or bioid like \'Umsy%\')  and assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor where mgmt IN ",gcrit, ") and recorder != \'MYERS\') group by assessid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and (v.bioid like \'Fmsy%\' or v.bioid like \'Umsy%\')
  ", sep="")
f.pepper <- sqlQuery(chan, f.pepper.qu, stringsAsFactors=FALSE)

# merge the exploitation ratios
  temp.u.dat <- rbind(f.pepper, f.salt)

  ## keep the pepper preferentially
## first, sort by assessid
  temp.udat.ord <- temp.u.dat[order(temp.u.dat$assessid),]
  oo<- unlist(tapply(temp.udat.ord$assessid,temp.udat.ord$assessid,order))
  crosshair.u.dat <- temp.udat.ord[oo==1,]

  
## merge the salt and pepper
##
#
crosshair.dat <- merge(crosshair.b.dat, crosshair.u.dat, "assessid")  

## TOTAL NUMBER FOR THIS MANAGEMENT BODY
  nn <- dim(crosshair.dat)[1]
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMASSESSFRIEDTOTAL",sql.label,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMASSESSFRIEDTOTAL",sql.label,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

## BELOW Bmsy
nn <- dim(subset(crosshair.dat, ratio.x < 1))[1]/dim(crosshair.dat)[1] * 100
nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSFRIEDBELOWBMSY",sql.label,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSFRIEDBELOWBMSY",sql.label,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)
nn <- dim(subset(crosshair.dat, ratio.x < 1))[1]
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMASSESSFRIEDBELOWBMSY",sql.label,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMASSESSFRIEDBELOWBMSY",sql.label,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)
## of those BELOW Bmsy, percentage above Fmsy
nn <- dim(subset(crosshair.dat, ratio.x < 1 & ratio.y>1))[1]/dim(subset(crosshair.dat, ratio.x < 1))[1] * 100
nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSFRIEDBELBMSYANDABOVEFMSY",sql.label,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSFRIEDBELBMSYANDABOVEFMSY",sql.label,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)
## of those BELOW Bmsy, percentage below Fmsy
nn <- dim(subset(crosshair.dat, ratio.x < 1 & ratio.y<1))[1]/dim(subset(crosshair.dat, ratio.x < 1))[1] * 100
nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSFRIEDBELBMSYANDBELOWFMSY",sql.label,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSFRIEDBELBMSYANDBELOWFMSY",sql.label,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

## BELOW Fmsy
  nn <- dim(subset(crosshair.dat, ratio.y < 1))[1]
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMASSESSFRIEDBELOWFMSY",sql.label,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMASSESSFRIEDBELOWFMSY",sql.label,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

  nn <- dim(subset(crosshair.dat, ratio.y < 1))[1]/dim(crosshair.dat)[1] * 100
nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSFRIEDBELOWFMSY",sql.label,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSFRIEDBELOWFMSY",sql.label,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

## ABOVE Bmsy
  nn <- dim(subset(crosshair.dat, ratio.x > 1))[1]/dim(crosshair.dat)[1] * 100
nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSFRIEDABOVEBMSY",sql.label,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSFRIEDABOVEBMSY",sql.label,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)
## ABOVE Fmsy
  nn <- dim(subset(crosshair.dat, ratio.y > 1))[1]/dim(crosshair.dat)[1] * 100
nn <- round(nn,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTASSESSFRIEDABOVEFMSY",sql.label,"'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTASSESSFRIEDABOVEFMSY",sql.label,"',",nn,")",sep="" )
sqlQuery(chan,insert.qu)



d<-2 # the bandwidth dimension
bmsy.bw<-sqrt(var(crosshair.dat[,5]))*(4/((d+2)*length(crosshair.dat[,5])))^(1/(d+4))
umsy.bw<-sqrt(var(crosshair.dat[,10]))*(4/((d+2)*length(crosshair.dat[,10])))^(1/(d+4))

kernel.dens <- bkde2D(crosshair.dat[,c(5,10)], bandwidth=c(bmsy.bw,umsy.bw), range.x=list(c(0,2.01),c(0,2.01)))  

palettetable.egg<-colorRampPalette(c("#BFEFFF","white","white", "yellow","#FFC125"))

  crosshair.dat$ratio.x[crosshair.dat$ratio.x>2] <- 2
  crosshair.dat$ratio.y[crosshair.dat$ratio.y>2] <- 2

if (plot.true == "TRUE"){
  image(kernel.dens$x1, kernel.dens$x2, kernel.dens$fhat, col=palettetable.egg(length(kernel.dens$x1)), xlab = "", ylab = "", xlim=c(-0.05,2.05), ylim=c(-0.05,2.05), cex.lab=1.3)
contour(kernel.dens$x1, kernel.dens$x2, kernel.dens$fhat,drawlabels=FALSE,nlevels=3,add=TRUE,col=grey(0.4),lwd=0.7)
abline(h=1, lty=2, lwd=1.2); abline(v=1, lty=2, lwd=1.2)
points(crosshair.dat[,5], crosshair.dat[,10], col=1, cex=.7, pch=ifelse((crosshair.dat$btype=="no" | crosshair.dat$utype=="no"),21,19), bg="white")

ifelse(xlabel, axis(side=1, labels=TRUE), axis(side=1, labels=FALSE))
ifelse(ylabel, axis(side=2, labels=TRUE), axis(side=2, labels=FALSE))

  n.assessid <- dim(crosshair.dat)[1]

  my.label <- paste(legendlabel, " (n=", n.assessid, ")", sep="")
legend("topright",my.label)
}
  } # end if(gtype == "mgmt")

## other groupings criteria
if(gtype == "taxo"){
## BIOMASS RATIOS

## Schaefer-derived SSBmsy reference points (i.e. salt)
## salt data for biomass
  tb.salt.qu <- paste("
select tsv.assessid, a.maxyr, tsv.total as numerator, sp.bmsy as denominator, tsv.total/sp.bmsy as ratio, 'no' as btype from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.total is not null and tsv.catch_landings is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where", gcrit, ")) AND recorder != \'MYERS\')
", sep="")
  tb.salt <- sqlQuery(chan,tb.salt.qu, stringsAsFactors=FALSE)

## assessment-derived MSY reference points (i.e. pepper)
## maximum year for which there is both SSB/TB and F
  
  ssb.pepper.qu <- paste("
select a.assessid, a.maxyr, a.biovalue as numerator, v.tsvalue as denominator, v.tsvalue/cast(a.biovalue as numeric) as ratio, 'yes' as btype  from (select assessid, max(tsyear) as maxyr, biovalue from srdb.tsrelative_explicit_view where bioid like \'%Bmsy%\'  and assessid in (select assessid from srdb.assessment where stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where", gcrit, ")) AND recorder != \'MYERS\') group by assessid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and v.bioid like \'%Bmsy%\';
", sep="")
ssb.pepper <- sqlQuery(chan,ssb.pepper.qu, stringsAsFactors=FALSE)

## merge the biomass ratios
  temp.b.dat <- rbind(ssb.pepper,tb.salt)
  
## keep the pepper preferentially
## first, sort by assessid
  temp.bdat.ord <- temp.b.dat[order(temp.b.dat$assessid),]
  oo<- unlist(tapply(temp.bdat.ord$assessid,temp.bdat.ord$assessid,order))
  crosshair.b.dat <- temp.bdat.ord[oo==1,]
  
  
## EXPLOITATION RATIOS
 
## Schaefer-derived Fmsy reference points (i.e. salt)
## salt data for exploitation rate
  f.salt.qu <- paste("
select tsv.assessid, a.maxyr, (tsv.catch_landings/tsv.total) as u, sp.fmsy, (tsv.catch_landings/tsv.total)/sp.fmsy as ratio, 'no' as utype from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.catch_landings is not null and tsv.total is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where", gcrit, ")) AND recorder != \'MYERS\')
", sep="")
  f.salt <- sqlQuery(chan,f.salt.qu, stringsAsFactors=FALSE)

## assessment-derived MSY reference points (i.e. pepper)  

  f.pepper.qu <- paste("
  select a.assessid, a.maxyr, a.biovalue as u, v.tsvalue as fmsy, (case when v.tsvalue=0 then 0 else v.tsvalue/cast(a.biovalue as numeric) end) as ratio, 'yes' as utype  from (select assessid, max(tsyear) as maxyr, biovalue from srdb.tsrelative_explicit_view where (bioid like \'Fmsy%\' or bioid like \'Umsy%\')  and assessid in (select assessid from srdb.assessment where stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where", gcrit, ")) AND recorder != \'MYERS\') group by assessid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and (v.bioid like \'Fmsy%\' or v.bioid like \'Umsy%\')
  ", sep="")
f.pepper <- sqlQuery(chan, f.pepper.qu, stringsAsFactors=FALSE)

# merge the exploitation ratios
  temp.u.dat <- rbind(f.pepper, f.salt)

  ## keep the pepper preferentially
## first, sort by assessid
  temp.udat.ord <- temp.u.dat[order(temp.u.dat$assessid),]
  oo<- unlist(tapply(temp.udat.ord$assessid,temp.udat.ord$assessid,order))
  crosshair.u.dat <- temp.udat.ord[oo==1,]

## merge the salt and pepper
##
#
crosshair.dat <- merge(crosshair.b.dat, crosshair.u.dat, "assessid")  

d<-2 # the bandwidth dimension
bmsy.bw<-sqrt(var(crosshair.dat[,5]))*(4/((d+2)*length(crosshair.dat[,5])))^(1/(d+4))
umsy.bw<-sqrt(var(crosshair.dat[,10]))*(4/((d+2)*length(crosshair.dat[,10])))^(1/(d+4))

kernel.dens <- bkde2D(crosshair.dat[,c(5,10)], bandwidth=c(bmsy.bw,umsy.bw), range.x=list(c(0,2.01),c(0,2.01)))  

palettetable.egg<-colorRampPalette(c("#BFEFFF","white","white", "yellow","#FFC125"))

  crosshair.dat$ratio.x[crosshair.dat$ratio.x>2] <- 2
  crosshair.dat$ratio.y[crosshair.dat$ratio.y>2] <- 2

if (plot.true == "TRUE"){
  image(kernel.dens$x1, kernel.dens$x2, kernel.dens$fhat, col=palettetable.egg(length(kernel.dens$x1)), xlab = "", ylab = "", xlim=c(-0.05,2.05), ylim=c(-0.05,2.05), cex.lab=1.3)
contour(kernel.dens$x1, kernel.dens$x2, kernel.dens$fhat,drawlabels=FALSE,nlevels=3,add=TRUE,col=grey(0.4),lwd=0.7)
abline(h=1, lty=2, lwd=1.2); abline(v=1, lty=2, lwd=1.2)
points(crosshair.dat[,5], crosshair.dat[,10], col=1, cex=.7, pch=ifelse((crosshair.dat$btype=="no" | crosshair.dat$utype=="no"),21,19), bg="white")

ifelse(xlabel, axis(side=1, labels=TRUE), axis(side=1, labels=FALSE))
ifelse(ylabel, axis(side=2, labels=TRUE), axis(side=2, labels=FALSE))

  n.assessid <- dim(crosshair.dat)[1]

  my.label <- paste(legendlabel, " (n=", n.assessid, ")", sep="")
legend("topright",my.label)
}


}## end if gtype == "taxo"

if(gtype == "stock"){

## BIOMASS RATIOS

## Schaefer-derived SSBmsy reference points (i.e. salt)
## salt data for biomass
  tb.salt.qu <- paste("
select tsv.assessid, a.maxyr, tsv.total as numerator, sp.bmsy as denominator, tsv.total/sp.bmsy as ratio, 'no' as btype from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.total is not null and tsv.catch_landings is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where stockid in ", gcrit, " AND recorder != \'MYERS\')
", sep="")
  tb.salt <- sqlQuery(chan,tb.salt.qu, stringsAsFactors=FALSE)

## assessment-derived MSY reference points (i.e. pepper)
## maximum year for which there is both SSB/TB and F
  
  ssb.pepper.qu <- paste("
select a.assessid, a.maxyr, a.biovalue as numerator, v.tsvalue as denominator, v.tsvalue/cast(a.biovalue as numeric) as ratio, 'yes' as btype  from (select assessid, max(tsyear) as maxyr, biovalue from srdb.tsrelative_explicit_view where bioid like \'%Bmsy%\'  and assessid in (select assessid from srdb.assessment where stockid in ",gcrit, " AND recorder != \'MYERS\') group by assessid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and v.bioid like \'%Bmsy%\';
", sep="")
ssb.pepper <- sqlQuery(chan,ssb.pepper.qu, stringsAsFactors=FALSE)

## merge the biomass ratios
  temp.b.dat <- rbind(ssb.pepper,tb.salt)
  
## keep the pepper preferentially
## first, sort by assessid
  temp.bdat.ord <- temp.b.dat[order(temp.b.dat$assessid),]
  oo<- unlist(tapply(temp.bdat.ord$assessid,temp.bdat.ord$assessid,order))
  crosshair.b.dat <- temp.bdat.ord[oo==1,]
  
  
## EXPLOITATION RATIOS
 
## Schaefer-derived Fmsy reference points (i.e. salt)
## salt data for exploitation rate
  f.salt.qu <- paste("
select tsv.assessid, a.maxyr, (tsv.catch_landings/tsv.total) as u, sp.fmsy, (tsv.catch_landings/tsv.total)/sp.fmsy as ratio, 'no' as utype from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.catch_landings is not null and tsv.total is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where stockid in ", gcrit, " AND recorder != \'MYERS\')
", sep="")
  f.salt <- sqlQuery(chan,f.salt.qu, stringsAsFactors=FALSE)

## assessment-derived MSY reference points (i.e. pepper)  

  f.pepper.qu <- paste("
  select a.assessid, a.maxyr, a.biovalue as u, v.tsvalue as fmsy, (case when v.tsvalue=0 then 0 else v.tsvalue/cast(a.biovalue as numeric) end) as ratio, 'yes' as utype  from (select assessid, max(tsyear) as maxyr, biovalue from srdb.tsrelative_explicit_view where (bioid like \'Fmsy%\' or bioid like \'Umsy%\')  and assessid in (select assessid from srdb.assessment where stockid in ", gcrit, " AND recorder != \'MYERS\') group by assessid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and (v.bioid like \'Fmsy%\' or v.bioid like \'Umsy%\')
  ", sep="")
f.pepper <- sqlQuery(chan, f.pepper.qu, stringsAsFactors=FALSE)

# merge the exploitation ratios
  temp.u.dat <- rbind(f.pepper, f.salt)

  ## keep the pepper preferentially
## first, sort by assessid
  temp.udat.ord <- temp.u.dat[order(temp.u.dat$assessid),]
  oo<- unlist(tapply(temp.udat.ord$assessid,temp.udat.ord$assessid,order))
  crosshair.u.dat <- temp.udat.ord[oo==1,]

## merge the salt and pepper
##
#
crosshair.dat <- merge(crosshair.b.dat, crosshair.u.dat, "assessid")  

d<-2 # the bandwidth dimension
bmsy.bw<-sqrt(var(crosshair.dat[,5]))*(4/((d+2)*length(crosshair.dat[,5])))^(1/(d+4))
umsy.bw<-sqrt(var(crosshair.dat[,10]))*(4/((d+2)*length(crosshair.dat[,10])))^(1/(d+4))

kernel.dens <- bkde2D(crosshair.dat[,c(5,10)], bandwidth=c(bmsy.bw,umsy.bw), range.x=list(c(0,2.01),c(0,2.01)))  

palettetable.egg<-colorRampPalette(c("#BFEFFF","white","white", "yellow","#FFC125"))

  crosshair.dat$ratio.x[crosshair.dat$ratio.x>2] <- 2
  crosshair.dat$ratio.y[crosshair.dat$ratio.y>2] <- 2

if (plot.true == "TRUE"){
  image(kernel.dens$x1, kernel.dens$x2, kernel.dens$fhat, col=palettetable.egg(length(kernel.dens$x1)), xlab = "", ylab = "", xlim=c(-0.05,2.05), ylim=c(-0.05,2.05), cex.lab=1.3)
contour(kernel.dens$x1, kernel.dens$x2, kernel.dens$fhat,drawlabels=FALSE,nlevels=3,add=TRUE,col=grey(0.4),lwd=0.7)
abline(h=1, lty=2, lwd=1.2); abline(v=1, lty=2, lwd=1.2)
points(crosshair.dat[,5], crosshair.dat[,10], col=1, cex=.7, pch=ifelse((crosshair.dat$btype=="no" | crosshair.dat$utype=="no"),21,19), bg="white")

ifelse(xlabel, axis(side=1, labels=TRUE), axis(side=1, labels=FALSE))
ifelse(ylabel, axis(side=2, labels=TRUE), axis(side=2, labels=FALSE))

  n.assessid <- dim(crosshair.dat)[1]

  my.label <- paste(legendlabel, " (n=", n.assessid, ")", sep="")
legend("topright",my.label)
}



}## end if gtype == "stock"

} ## end function fried.egg.fct

