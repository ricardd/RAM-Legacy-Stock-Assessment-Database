# sr-view-fct.R
# R function to create a sr-view summary page for a given stock
#

require(RODBC)

sr.view.fct <- function(a.id) {
# get time-series data
chan <- odbcConnect(dsn="srDBcalo", uid = "ricardd", pwd="ricardd", case='postgresql',believeNRows=FALSE)
qu <- paste("select ts.assessid, ts.tsid, ts.tsyear, ts.tsvalue from srdb.timeseries ts where ts.assessid = '", a.id, "'", sep="")

res <- sqlQuery(chan, qu, errors= TRUE)

qu <- paste("select st.scientificname, st.commonname, st.areaID, st.stocklong from srdb.assessment aa, srdb.stock st where aa.stockid=st.stockid and assessid = '", a.id, "'", sep="")
details <- sqlQuery(chan, qu, errors= TRUE)

# get biometrics data  
qu <- paste("select bioid, biovalue from srdb.bioparams where assessid = '", a.id, "'", sep="")

bio <- sqlQuery(chan, qu, errors= TRUE)
#print(bio)

bio2 <- bio
b.lim <- bio[bio$bioid=="Blim-MT",]
b.pa <- bio[bio$bioid=="Bpa-MT",]
as.numeric(levels(bio[,2])[as.numeric(bio[bio$bioid=="Bpa-MT",])[2]])

odbcClose(chan)

tt <- subset(res, tsid=="YEAR-yr")$tsyear

yy1 <- subset(res, tsid==("SSB-MT"))$tsvalue
yy2 <- subset(res, tsid=="F-1/T")$tsvalue
yy3 <- subset(res, tsid=="R-E03")$tsvalue

par(mfrow=c(3,2))
par(mar=c(3,4,2,2))

plot(tt,yy1,type='b', xlab="year",ylab="SSB", pch=19, lty=1, col='black')
abline(h=b.lim[2][1], col='red', lty=2)
abline(h=b.pa[2][1], col='blue', lty=2)


plot(tt,yy2,type='b', xlab="year",ylab="F", pch=4, lty=2, col='black')


y5.ssb <- yy1[tt%%5==0]
y5.f <- yy2[tt%%5==0]
y5.r <- yy3[tt%%5==0]

y5.txt <- tt[tt%%5==0]

plot(yy1,yy3,type='b',xlab="SSB",ylab="R", pch=4, lty=2)
points(y5.ssb,y5.r,pch=19)
text(y5.ssb,y5.r,y5.txt, pos=4) #, cex=1.5)
plot(yy1,yy2,type='b',xlab="SSB",ylab="F", pch=4, lty=2)
points(y5.ssb,y5.f,pch=19)
text(y5.ssb,y5.f,y5.txt, pos=4) #, cex=1.5)


# text in margins
mtext(details$stocklong, side=3, outer=TRUE, line=-2)

mtext(a.id, side=1, outer=TRUE, line=-1)
mtext(details$scientificname, side=1, outer=TRUE, line=-2)

# ccf
#ccf(yy1,yy2)

  
# generate plots
# recruits vs. ssb

} # end function sr.view.fct


