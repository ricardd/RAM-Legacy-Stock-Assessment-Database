## comparison of reference points from assessments to those from Schaefer fits
## last modified Time-stamp: <2011-06-17 15:13:38 (srdbadmin)>
## Modification history:
## 2011-06-16: editing code to evaluate the changes of setting upper bound on K parameter to 2*max(TB) and 5*max(TB)

setwd("/home/srdbadmin/srdb/projects/fishandfisheries/R/first-review/")
require(xtable)

mtext.fun<-function(xstring,ystring,xline,yline){
  mtext(side=1, text=xstring, line=xline, cex=0.9)
  mtext(side=2, text=ystring, line=yline, cex=0.9, las=3)
}

## (select a.assessid from srdb.assessment a, srdb.assessmethod m where a.assessmethod=m.methodshort and m.category = 'Biomass dynamics model' and m.methodshort in ('ASPM','AAPM','ASPIC','BSPM'))

## this is a paste from the CJFAS short comm R file "CJFAS-shortcomm-BRP-1010.R"
require(RODBC)
chan <- odbcConnect(dsn="srdbcalo", case='postgresql',believeNRows=FALSE)

### bring back Bcurrent/Bmsy values
qu.brp.salt <- paste("
select tsv.assessid, a.maxyr, tsv.total, sp.bmsy, tsv.total/sp.bmsy as ratio from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.total is not null and tsv.catch_landings is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor) AND recorder != \'MYERS\')
",sep="")
brp.salt.dat <- sqlQuery(chan,qu.brp.salt)
nn <- dim(brp.salt.dat)[1]
salt <- data.frame(assessid=brp.salt.dat$assessid, currentyr=brp.salt.dat$maxyr, bratiocurrent=brp.salt.dat$ratio, type = rep("salt",nn), fromassessment = rep("no",nn))

## from table with K upper bound at 5*max(TB)
qu.brp.salt.kbound5maxb <- paste("
select tsv.assessid, a.maxyr, tsv.total, sp.bmsy, tsv.total/sp.bmsy as ratio from srdb.spfits_schaefer_kbound5maxtb sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits_schaefer_kbound5maxtb s where s.assessid=tsv.assessid and tsv.total is not null and tsv.catch_landings is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor) AND recorder != \'MYERS\')
",sep="")
brp.salt.dat.kbound5maxb <- sqlQuery(chan,qu.brp.salt.kbound5maxb)
nn <- dim(brp.salt.dat.kbound5maxb)[1]
salt.kbound5maxb <- data.frame(assessid=brp.salt.dat.kbound5maxb$assessid, currentyr=brp.salt.dat.kbound5maxb$maxyr, bratiocurrent=brp.salt.dat.kbound5maxb$ratio, type = rep("salt",nn), fromassessment = rep("no",nn))

  qu.brp.pepper <- paste("
select l.assessid, aa.maxyr, aa.bioid, aa.biovalue, aa.tsvalue, aa.ratio from (select a.assessid, a.maxyr, a.biovalue, a.bioid, v.tsvalue, v.tsvalue/cast(a.biovalue as numeric) as ratio  from (select assessid, max(tsyear) as maxyr, bioid, biovalue from srdb.tsrelative_explicit_view where bioid like \'%Bmsy%\'  and assessid in (select assessid from srdb.assessment where recorder != \'MYERS\') group by assessid, bioid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and v.bioid like \'%Bmsy%\') aa, (select assessid, max(bioid) as bioid from srdb.tsrelative_explicit_view where bioid like \'%Bmsy%\' group by assessid) l where aa.assessid=l.assessid and aa.bioid=l.bioid
", sep="")
## select a.assessid, a.maxyr, a.biovalue, v.tsvalue, v.tsvalue/cast(a.biovalue as numeric) as ratio  from (select assessid, max(tsyear) as maxyr, biovalue from srdb.tsrelative_explicit_view where bioid like \'%Bmsy%\'  and assessid in (select assessid from srdb.assessment where recorder != \'MYERS\') group by assessid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and v.bioid like \'%Bmsy%\';
brp.pepper.dat <- sqlQuery(chan,qu.brp.pepper)

nn <- dim(brp.pepper.dat)[1]
pepper <- data.frame(assessid=brp.pepper.dat$assessid, currentyr=brp.pepper.dat$maxyr, bratiocurrent=brp.pepper.dat$ratio, type = rep("pepper",nn), fromassessment = rep("yes",nn))

  temp.dat <- rbind(pepper,salt)
  temp.dat.ord <- temp.dat[order(temp.dat$assessid),]
  oo<- unlist(tapply(temp.dat.ord$assessid,temp.dat.ord$assessid,order))
  crosshair.dat <- temp.dat.ord[oo==1,]

# for assessments that have both salt and pepper points, compute correlation between salt and pepper
salt.and.pepper <-  merge(pepper,salt,"assessid")
salt.kbound5maxb.and.pepper <-  merge(pepper,salt.kbound5maxb,"assessid")


# data frame to compute the contingency table of classification
b.for.comparison.table <- data.frame(assessid=salt.and.pepper$assessid, Bratio=salt.and.pepper$bratiocurrent.x, BratioSP=salt.and.pepper$bratiocurrent.y)
b.for.comparison.table$BratioCLASS <- ifelse(b.for.comparison.table$Bratio<1,"B/Bmsy < 1","B/Bmsy > 1")
b.for.comparison.table$BratioSPCLASS <- ifelse(b.for.comparison.table$BratioSP<1,"SP B/Bmsy < 1","SP B/Bmsy > 1")

b.table <- table(b.for.comparison.table$BratioCLASS, b.for.comparison.table$BratioSPCLASS)


corr.current <- cor(salt.and.pepper$bratiocurrent.x, salt.and.pepper$bratiocurrent.y)
nn <- length(salt.and.pepper$bratiocurrent.x)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMFORCORRBBMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMFORCORRBBMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

  
  nn <- corr.current
nn <- round(nn,2)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTCORRBBMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTCORRBBMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)



pdf("Schaefer-correlations.pdf", width=6,height=6*1.3,title="")
#par(mfrow=c(2,1), mar=c(4,4,1,1), oma=c(1,1,1,1))
par(mfrow=c(2,2), mar=c(4,4,1,1), oma=c(1,1,1,1))

nn <-dim(salt.and.pepper)[1]
my.range<- c(0.001,range(c(salt.and.pepper$bratiocurrent.x, salt.and.pepper$bratiocurrent.y))[2]*1.02)
plot(salt.and.pepper$bratiocurrent.x, salt.and.pepper$bratiocurrent.y, xlab="", ylab="", pch=1, cex=0.6, col=grey(0.5), xlim=my.range,ylim=my.range)
abline(c(0,1),lwd=0.7)
mtext.fun(xstring="assessment B/Bmsy",ystring="Schaefer-derived B/Bmsy",xline=2.5,yline=2.5)
title("K upper bound 2*max(TB)")

my.range<- c(0.001,range(c(salt.kbound5maxb.and.pepper$bratiocurrent.x, salt.kbound5maxb.and.pepper$bratiocurrent.y))[2]*1.02)
plot(salt.kbound5maxb.and.pepper$bratiocurrent.x, salt.kbound5maxb.and.pepper$bratiocurrent.y, xlab="", ylab="", pch=1, cex=0.6, col=grey(0.5), xlim=my.range,ylim=my.range)
abline(c(0,1),lwd=0.7)
mtext.fun(xstring="assessment B/Bmsy",ystring="Schaefer-derived B/Bmsy",xline=2.5,yline=2.5)
title("K upper bound 5*max(TB)")

#my.range<- range(c(salt.and.pepper$bratiocurrent.x, salt.and.pepper$bratiocurrent.y))
#plot(salt.and.pepper$bratiocurrent.x, salt.and.pepper$bratiocurrent.y, xlab="log assessment B/Bmsy", ylab="log Schaefer-derived B/Bmsy", pch=1, cex=0.6, col=grey(0.5), xlim=my.range,ylim=my.range, log="xy")
#abline(c(0,1),lwd=0.7)


#dev.off()


###################################
###################################
### bring back Fcurrent/Fmsy values
qu.brp.salt <- paste("
select tsv.assessid, a.maxyr, tsv.f, sp.fmsy, tsv.f/sp.fmsy as ratio from srdb.spfits sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits s where s.assessid=tsv.assessid and tsv.total is not null and tsv.catch_landings is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor) AND recorder != \'MYERS\')
",sep="")
brp.salt.dat <- na.omit(sqlQuery(chan,qu.brp.salt))
nn <- dim(brp.salt.dat)[1]
salt <- data.frame(assessid=brp.salt.dat$assessid, currentyr=brp.salt.dat$maxyr, fratiocurrent=brp.salt.dat$ratio, type = rep("salt",nn), fromassessment = rep("no",nn))

## from table with K upper bound at 5*max(TB)
qu.brp.salt.kbound5maxb <- paste("
select tsv.assessid, a.maxyr, tsv.f, sp.fmsy, tsv.f/sp.fmsy as ratio from srdb.spfits_schaefer_kbound5maxtb sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits_schaefer_kbound5maxtb s where s.assessid=tsv.assessid and tsv.total is not null and tsv.catch_landings is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor) AND recorder != \'MYERS\')
",sep="")
brp.salt.dat.kbound5maxb <- na.omit(sqlQuery(chan,qu.brp.salt))
nn <- dim(brp.salt.dat.kbound5maxb)[1]
salt.kbound5maxb <- data.frame(assessid=brp.salt.dat.kbound5maxb$assessid, currentyr=brp.salt.dat.kbound5maxb$maxyr, fratiocurrent=brp.salt.dat.kbound5maxb$ratio, type = rep("salt",nn), fromassessment = rep("no",nn))


qu.brp.pepper <- paste("
select l.assessid, aa.maxyr, aa.bioid, aa.biovalue, aa.tsvalue, aa.ratio from (select a.assessid, a.maxyr, a.biovalue, a.bioid, v.tsvalue, v.tsvalue/cast(a.biovalue as numeric) as ratio  from (select assessid, max(tsyear) as maxyr, bioid, biovalue from srdb.tsrelative_explicit_view where bioid like \'Fmsy%\'  and assessid in (select assessid from srdb.assessment where recorder != \'MYERS\') group by assessid, bioid, biovalue) as a, srdb.tsrelative_explicit_view v where a.assessid = v.assessid and v.tsyear=a.maxyr and v.biovalue=a.biovalue and v.bioid like \'Fmsy%\') aa, (select assessid, max(bioid) as bioid from srdb.tsrelative_explicit_view where bioid like \'Fmsy%\' group by assessid) l where aa.assessid=l.assessid and aa.bioid=l.bioid
", sep="")
brp.pepper.dat <- sqlQuery(chan,qu.brp.pepper)

nn <- dim(brp.pepper.dat)[1]
pepper <- data.frame(assessid=brp.pepper.dat$assessid, currentyr=brp.pepper.dat$maxyr, fratiocurrent=brp.pepper.dat$ratio, type = rep("pepper",nn), fromassessment = rep("yes",nn))

  temp.dat <- rbind(pepper,salt)
  temp.dat.ord <- temp.dat[order(temp.dat$assessid),]
  oo<- unlist(tapply(temp.dat.ord$assessid,temp.dat.ord$assessid,order))
  crosshair.dat <- temp.dat.ord[oo==1,]

# for assessments that have both salt and pepper points, compute correlation between salt and pepper
salt.and.pepper <-  merge(pepper,salt,"assessid")
salt.kbound5maxb.and.pepper <-  merge(pepper,salt.kbound5maxb,"assessid")

# remove the assessments that use a surplus production model 
qu <- paste("
select a.assessid from srdb.assessment a, srdb.assessmethod m where a.assessmethod=m.methodshort and m.category = 'Biomass dynamics model' and m.methodshort in ('ASPM','AAPM','ASPIC','BSPM')
",sep="")
assessid.to.exclude <- sqlQuery(chan, qu)


f.for.comparison.table <- data.frame(assessid=salt.and.pepper$assessid, Uratio=salt.and.pepper$fratiocurrent.x, UratioSP=salt.and.pepper$fratiocurrent.y)
f.for.comparison.table$UratioCLASS <- ifelse(f.for.comparison.table$Uratio<1,"U/Umsy < 1","U/Umsy > 1")
f.for.comparison.table$UratioSPCLASS <- ifelse(f.for.comparison.table$UratioSP<1,"SP U/Umsy < 1","SP U/Umsy > 1")

f.table <- table(f.for.comparison.table$UratioCLASS, f.for.comparison.table$UratioSPCLASS)


corr.current <- cor(salt.and.pepper$fratiocurrent.x, salt.and.pepper$fratiocurrent.y)
nn <- length(salt.and.pepper$fratiocurrent.x)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMFORCORRFFMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMFORCORRFFMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

  nn <- corr.current
nn <- round(nn,2)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTCORRFFMSY'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTCORRFFMSY',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

my.range<- c(0.001,range(c(salt.and.pepper$fratiocurrent.x, salt.and.pepper$fratiocurrent.y))[2]*1.02)
plot(salt.and.pepper$fratiocurrent.x, salt.and.pepper$fratiocurrent.y, xlab="", ylab="", pch=1, cex=0.6, col=grey(0.5), xlim=my.range,ylim=my.range)
abline(c(0,1),lwd=0.7)
mtext.fun(xstring="assessment U/Umsy",ystring="Schaefer-derived U/Umsy",xline=2.5,yline=2.5)

my.range<- c(0.001,range(c(salt.kbound5maxb.and.pepper$fratiocurrent.x, salt.kbound5maxb.and.pepper$fratiocurrent.y))[2]*1.02)
plot(salt.kbound5maxb.and.pepper$fratiocurrent.x, salt.kbound5maxb.and.pepper$fratiocurrent.y, xlab="", ylab="", pch=1, cex=0.6, col=grey(0.5), xlim=my.range,ylim=my.range)
abline(c(0,1),lwd=0.7)
mtext.fun(xstring="assessment U/Umsy",ystring="Schaefer-derived U/Umsy",xline=2.5,yline=2.5)

dev.off()

#print(b.table)
#print(f.table)

numerator <- dim(b.for.comparison.table[(b.for.comparison.table$Bratio < 1 & b.for.comparison.table$BratioSP < 1) | (b.for.comparison.table$Bratio > 1 & b.for.comparison.table$BratioSP > 1),])[1]
  nn<-numerator
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMCORRECTBCLASS'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMCORRECTBCLASS',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

denominator<- dim(b.for.comparison.table)[1]
nn <- denominator
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMBCLASS'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMBCLASS',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

nn <- round(100*numerator/denominator,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTCORRECTBCLASS'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTCORRECTBCLASS',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

numerator <- dim(f.for.comparison.table[(f.for.comparison.table$Uratio < 1 & f.for.comparison.table$UratioSP < 1) | (f.for.comparison.table$Uratio > 1 & f.for.comparison.table$UratioSP > 1),])[1]
  nn<-numerator
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMCORRECTUCLASS'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMCORRECTUCLASS',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

denominator<- dim(f.for.comparison.table)[1]
nn <- denominator
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMUCLASS'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMUCLASS',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

nn <- round(100*numerator/denominator,0)
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:PERCENTCORRECTUCLASS'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:PERCENTCORRECTUCLASS',",nn,")",sep="" )
sqlQuery(chan,insert.qu)

odbcClose(chan)


# Table S2 showing the contingency table for B and U
contingency.table <- rbind(f.table,b.table)
my.caption <- c("Contingency tables of stock status classification for biomass and exploitation reference points obtained from assessments and those derived from surplus production models. ")
my.table.contingency <- xtable(contingency.table, caption=my.caption, label=c("tab:contingency"), digits=2, align="ccc")
  print(my.table.contingency, type="latex", file="../../tex/first-review/Table-S2.tex", include.rownames=TRUE, floating=TRUE, caption.placement="bottom") #, sanitize.text.function=I)

  print(my.table.contingency, type="html", file="../../tex/first-review/Table-S2.html", include.rownames=TRUE, floating=TRUE, caption.placement="bottom") #, sanitize.text.function=I)

save.image()


## comparison of Schaefer fits when using different upper bounds for the K parameter
## this is basically the same as above but using the Schaefer results from the following tables:
# srdb.spfits_schaefer_kbound2maxtb
# srdb.spfits_schaefer_kbound5maxtb


pdf("Schaefer-correlations-Kbounds-comparison.pdf", width=6,height=6*1.3,title="")
par(mfrow=c(2,2))
dev.off()
