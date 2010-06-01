# srview for srDB, first pass
# Started: 2008-07-22
#
# Time-stamp: <2008-10-09 11:12:16 (ricardd)>
#
# Modification history
# 2008-10-08: defining a function that accepts a stock name and the correct R, SSB and F series for plotting and model fitting

require(RODBC)
require(MASS)

# connect to srDB
chan <- odbcConnect(dsn="srDBcalo", uid = "ricardd", pwd="ricardd", case='postgresql',believeNRows=FALSE)

# example with a chosen stock
my.stock <- "AFWG-CODNEAR-1943-2006-MINTO"
#my.stock <- "NMFS-BLACKROCKSPCOAST-2007-FOGARTY"

# what time-series are defined for this stock?
qu <- paste("select distinct bb.tscategory, aa.tsid from srdb.timeseries aa, srdb.tsmetrics bb WHERE aa.tsid=bb.tsunique and aa.assessid=",
 "'",my.stock,"'",
               sep="")
my.tsmetrics <- sqlQuery(chan,qu)

# what biometrics are defined for this stock?
qu <- paste("select distinct bb.category, bb.subcategory, aa.bioid from srdb.bioparams aa, srdb.biometrics bb WHERE aa.bioid=bb.biounique and aa.assessid=",
 "'",my.stock,"'",
               sep="")
my.biometrics <- sqlQuery(chan,qu)


# get all time-series data
qu <- paste("
SELECT * from srdb.timeseries where assessid=",
 "'",my.stock,"'",
            sep="")
my.tsdata <- sqlQuery(chan,qu)

# get all biometrics data
qu <- paste("
SELECT * from srdb.bioparams where assessid=",
 "'",my.stock,"'",
            sep="")
my.biodata <- sqlQuery(chan,qu)

odbcClose(chan)

####################################
# same thing in a function
assess.id <- my.stock
ssb <- "SSB-1-MT"
r <- "R-1-E00"
f <- "F-1-1/T"

srview.fct <- function(assess.id, ssb, r, f) {
qu <- paste("select st.scientificname, st.commonname, st.areaID, st.stocklong from srdb.assessment aa, srdb.stock st where aa.stockid=st.stockid and assessid = '", assess.id, "'", sep="")
details <- sqlQuery(chan, qu, errors= TRUE)

qu <- paste("
SELECT * from srdb.timeseries where assessid=",
"'",assess.id,"' AND tsid=","'",ssb,"'", sep="")
ssb.data <- sqlQuery(chan,qu)

qu <- paste("
SELECT * from srdb.timeseries where assessid=",
"'",assess.id,"' AND tsid=","'",r,"'", sep="")
r.data <- sqlQuery(chan,qu)

qu <- paste("
SELECT * from srdb.timeseries where assessid=",
"'",assess.id,"' AND tsid=","'",f,"'", sep="")
f.data <- sqlQuery(chan,qu)


data.back <- data.frame(ID=ssb.data$assessid, YR=ssb.data$tsyear, SSB=ssb.data$tsvalue, R=r.data$tsvalue, F=f.data$tsvalue)

# plot SSB, F, and R over the time span of the data
par(mfrow=c(3,2))
plot(data.back$YR, data.back$SSB, xlab="Year", ylab="SSB", type='l', lwd=2)
par(new=TRUE)
plot(data.back$YR, data.back$R, type='l', lwd=1, lty=2, axes=FALSE, xlab="", ylab="")
par(new=TRUE)
plot(data.back$YR, data.back$F, type='l', lwd=2, lty=1, col='red', axes=FALSE, xlab="", ylab="")
axis(side=4)

plot(data.back$SSB, data.back$R, pch=10, xlab="SSB",ylab="R", ylim=c(0,max(data.back$R, na.rm=TRUE)), xlim=c(0,max(data.back$SSB, na.rm=TRUE)))

# text in margins
mtext(details$stocklong, side=3, outer=TRUE, line=-2)

mtext(assess.id, side=1, outer=TRUE, line=-1)
mtext(details$scientificname, side=1, outer=TRUE, line=-2)


# fit Ricker
Ricker.model <- nls(R ~ exp(1)^(p2/p1) * (SSB)*exp(-(SSB)/p1), data=data.back, start=c(p1=158900,p2=115000))
t <- subset(data.back, (!is.na(SSB)) & (!is.na(R)))
tt <- predict(Ricker.model, t$SSB)

lines(t$SSB, tt, type='l', lwd=1, lty=1)

# fit BH
BH.model <- nls(R ~ (alpha * SSB)/ (1 + (beta * SSB)), data=data.back, start=c(alpha=2, beta=1E-05))
tt <- predict(BH.model, t$SSB)
lines(t$SSB, tt, type='l', lwd=2, lty=2)


# fit Ricker w/ depensation
Ricker.depensation.model <- nls(R ~ exp(1)^(p2/p1) * (SSB-p3)*exp(-(SSB-p3)/p1), data=data.back, start=c(p1=158900,p2=115000.6,p3=100), na.action=na.omit)

# fit BH w/ depensation

# plot SSB vs. F
plot(data.back$F, data.back$SSB, pch=10, xlab="F",ylab="SSB")

# gather parameter estimates, LL and AIC
l1 <- paste("","LL","AIC",sep="\t")
l2 <- paste("Ricker", round(logLik(Ricker.model), 3), round(AIC(Ricker.model),3),sep="\t")
l3 <- paste("Beverton-Holt", round(logLik(BH.model),3),round(AIC(BH.model),3),sep="\t")
plot(1,type='n',xlab="",ylab="",axes=FALSE,xlim=c(0,2),ylim=c(0,2))
ll <- c(l1,l2,l3)
legend(0.5, 0.5, bty='n',legend=ll)

# return(data.back)
} # end function srview.fct


###########################################################

# function calls
pdf("summary-report.pdf")
srview.fct("AFWG-CODNEAR-1943-2006-MINTO", "SSB-1-MT", "R-1-E00", "F-1-1/T")
srview.fct("AFWG-CODNEAR-1943-2006-MINTO", "SSB-2-MT", "R-2-E00", "F-2-1/T")
srview.fct("NWWG-CODFAPL-1959-2006-MINTO", "SSB-MT", "R-E03", "F-1/T")
srview.fct("AFWG-CODCOASTNOR-1982-2006-MINTO", "SSB-MT", "R-E03", "F-1/T")
srview.fct("NWWG-CODICE-1952-2006-MINTO", "SSB-E03MT", "R-E06", "F-1/T")
srview.fct("WGNSSK-CODNS-1962-2007-MINTO", "SSB-MT", "R-E03", "F-1/T")
srview.fct("WGNSDS-CODVIa-1977-2006-MINTO", "SSB-E03MT", "R-E06", "F-1/T")
srview.fct("WGNSDS-CODIS-1968-2006-MINTO", "SSB-MT", "R-E03", "F-1/T")
srview.fct("WGBFAS-CODKAT-1970-2006-MINTO", "SSB-MT", "R-E03", "F-1/T")
srview.fct("DFO-SG-COD4T-1950-2007-HUTCHINGS", "SSB-MT", "R-E00", "F-1/T")
dev.off()








