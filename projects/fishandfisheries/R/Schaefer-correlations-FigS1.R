##
##
mtext.fun<-function(xstring,ystring,xline,yline){
  mtext(side=1, text=xstring, line=xline, cex=0.9)
  mtext(side=2, text=ystring, line=yline, cex=0.9, las=3)
}

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



pdf("Schaefer-correlations.pdf", width=6,height=6*1.3,title="Fish and Fisheries srdb Figure S1")
par(mfrow=c(2,1), mar=c(4,4,1,1), oma=c(1,1,1,1))

my.range<- c(0.001,range(c(salt.and.pepper$bratiocurrent.x, salt.and.pepper$bratiocurrent.y))[2]*1.02)
plot(salt.and.pepper$bratiocurrent.x, salt.and.pepper$bratiocurrent.y, xlab="", ylab="", pch=1, cex=0.6, col=grey(0.5), xlim=my.range,ylim=my.range)
abline(c(0,1),lwd=0.7)
mtext.fun(xstring="assessment B/Bmsy",ystring="Schaefer-derived B/Bmsy",xline=2.5,yline=2.5)

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

dev.off()
odbcClose(chan)
