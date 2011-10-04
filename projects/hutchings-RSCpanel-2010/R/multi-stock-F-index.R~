## for Jeff's RSC report, a multi-stock F-based index
##
## Daniel Ricard, started 2011-09-22
## Last modified Time-stamp: <2011-09-29 12:24:26 (srdbadmin)>
require(RODBC)
require(nlme)

setwd("/home/srdbadmin/srdb/projects/hutchings-RSCpanel-2010/R")

chan <- odbcConnect(dsn='srdbusercalo')



## F/U timeseries for all stocks in srdb that have assessment-derived F/Umsy reference points
qu <- paste("SELECT s.stockid, tv.* from srdb.tsrelative_explicit_view tv, srdb.assessment a, srdb.stock s where a.mostrecent = 'yes' and a.assessid=tv.assessid and a.stockid = s.stockid and tv.assessid in (select distinct assessid from srdb.brptots where bioid like 'Fmsy%') and bioid like 'Fmsy%' order by assessid, bioid, tsyear"
            ,sep="")
f.msy.pepper <- sqlQuery(chan,qu)


## U timeseries derived from Schaefer model fits
qu <- paste("select s.stockid, a.assessid, tsv.tsyear, 'U' as tsid, tsv.catch_landings/tsv.total as tsvalue, 'Umsy' as bioid, aa.fmsy as biovalue, (tsv.catch_landings/tsv.total)/aa.fmsy as tstobrpratio from srdb.assessment a, srdb.stock s, srdb.timeseries_values_view tsv, srdb.timeseries_units_view tsu, (select assessid, fmsy from srdb.spfits) as aa where tsv.assessid=tsu.assessid and a.assessid = aa.assessid and aa.assessid=tsv.assessid and a.stockid=s.stockid and tsv.total is not null and tsv.catch_landings is not null and a.assessid not in (select distinct assessid from srdb.brptots where bioid like 'Fmsy%') order by a.assessid, tsv.tsyear"
            ,sep="")
f.msy.salt <- sqlQuery(chan,qu)

## merge the salt and pepper
f.msy.both <- rbind(f.msy.pepper, f.msy.salt)

## restrict to stock of Canadian interest
my.assessments <- strsplit(system("psql srdb -f ../SQL/Canada-stocks.sql -A -t", intern=TRUE, ignore.stdout=FALSE, ignore.stderr=TRUE, wait=FALSE),"[|]")

## associate each with a taxonomic classification
qu.taxo <- paste("
(select s.stockid, tt.taxocategory from (select tsn, (CASE WHEN family = \'Gadidae\' THEN \'Gadidae\' ELSE (CASE WHEN ordername = \'Pleuronectiformes\' THEN \'Pleuronectiformes\' ELSE (CASE WHEN ((family in (\'Clupeidae\',\'Scombridae\',\'Engraulidae\')) OR (genus IN (\'Trachurus\',\'Mallotus\')) OR (scientificname IN (\'Arripis trutta\',\'Micromesistius australis\',\'Xiphias gladius\',\'Micromesistius poutassou\',\'Pomatomus saltatrix \'))) THEN \'Pelagic\' ELSE (CASE WHEN classname = \'Chondrichthyes\' THEN \'Shark/Skate\' ELSE \'Other demersal\' END) END) END) END) as taxocategory from srdb.taxonomy where classname in (\'Actinopterygii\',\'Chondrichthyes\')) as tt, srdb.stock s where s.tsn=tt.tsn) as tt
", sep="")
taxo.classification <- sqlQuery(chan,paste("select * from ",qu.taxo))

# turn into a data frame
tt.dat <- as.data.frame(matrix(unlist(my.assessments),ncol=length(my.assessments[[1]]),byrow=TRUE))
names(tt.dat) <- c("assessid","rec","stockid","stock","comname","area","sciname","years","assessor","mgmt","LME")

f.msy.canada <- merge(f.msy.both, tt.dat, by="assessid")
f.msy.canada <- merge(f.msy.canada, taxo.classification, by.x="stockid.x", by.y="stockid")

in.dat <- f.msy.canada
  xl <- range(in.dat$tsyear)
yl <- c(log(0.005),log(5))


## actual plot
pdf("RSC-Hutchings-multiF-plot.pdf", height=11, width=11*1.6)
plot(0,0,xlim=xl, ylim=yl,xlab="",ylab="", axes=FALSE)
axis(side=1, at=seq(1880,2000,20),cex=0.8)
axis(side=2, at=c(log(0.01),log(0.1),log(0.5),log(1),log(5),log(10)), labels=c(0.01,0.1,0.5,1.0,5,10),cex=0.8)
mtext(expression(U[curr]/U[MSY]), side=2, line=1, outer=TRUE, cex=1)

mtext("Year", side=1, line=1, outer=TRUE, cex=1)


## model fit not working
## I have to remove values of zero for the ratios otherwise the log won't work
mixed.fit <- lme(log(tstobrpratio)~-1+as.factor(tsyear), data=subset(f.msy.canada,tstobrpratio!=0), random=~1|stockid.x, correlation=corCAR1(form=~tsyear), na.action=na.omit)

    ## plot fixed effects shaded area for 95% confidence
  upr <- fixed.effects(mixed.fit) + 1.96*sqrt(diag(summary(mixed.fit)$varFix))
  lwr <- fixed.effects(mixed.fit) - 1.96*sqrt(diag(summary(mixed.fit)$varFix))
  my.yy <- sort(unique(in.dat$tsyear))

  polygon(c(my.yy,rev(my.yy)), c(lwr,rev(upr)), col=grey(0.8), border=NA)

  my.yy <- sort(unique(in.dat$tsyear))
  lines(my.yy, fixed.effects(mixed.fit), col='black', lty=1, lwd=2)

  
my.aa <- unique(in.dat$assessid)
aa <- length(my.aa)
for (i in 1:aa) {
  print(my.aa[i])
t.dat <- subset(in.dat, assessid == my.aa[i])
  tt.dat <- t.dat[order(t.dat$tsyear),]
  
lines(tt.dat$tsyear,log(tt.dat$tstobrpratio), col=ifelse(tt.dat$taxocategory=='Pelagic','blue','red'), lwd=ifelse(tt.dat$taxocategory=='Pelagic',0.1,0.05))
points(tt.dat$tsyear,log(tt.dat$tstobrpratio), col=ifelse(tt.dat$taxocategory=='Pelagic','blue','red'), cex=ifelse(tt.dat$taxocategory=='Pelagic',0.1,0.05))
}

plot.label <- "stocks of Canadian interest"
  legend('bottomleft', paste(plot.label," (n=",aa,")",sep=""))
legend("topleft", c("Pelagics", "Demersal"), col=c("blue","red"),pch=c(19,19), lty=c(1,1))


abline(h=log(1), lt=2, lwd=0.6)
abline(h=log(5), lt=2, lwd=0.3)
abline(h=log(0.5), lt=2, lwd=0.3)
abline(h=log(0.1), lt=2, lwd=0.3)
abline(h=log(0.01), lt=2, lwd=0.3)

dev.off()

odbcClose(chan)
