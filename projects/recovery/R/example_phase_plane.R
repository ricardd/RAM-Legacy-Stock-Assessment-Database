# an example phase-plane plot
# CM
# date: Wed Dec 10 09:52:40 AST 2008

# open a channel to the database
library("RODBC")
mychan<-odbcConnect(dsn="srdbusercalo") # note how the DSN is used here
my.qu<-paste("select * from srdb.timeseries_values_view where assessid='NEFSC-COD5Z-1960-2007-BAUM'")
my.dat<-sqlQuery(mychan, my.qu)
names(my.dat)
my.ref.qu<-paste("select * from srdb.reference_point_values_view where assessid='NEFSC-COD5Z-1960-2007-BAUM'")
my.ref.dat<-sqlQuery(mychan, my.ref.qu)

source("/home/srdbadmin/SQLpg/srDB/projects/recovery/phase_plane/R/functions/FvsB_func.R")
bitmap("./COD5z_phase_plane.png", width=7,height=7, type="png256", res=800,units="in", pointsize=12)
with(my.dat,F.vs.B.scaled2(B=ssb,"F"=f, Bref=my.ref.dat$ssbmsy, Fref=1, lwd=2, arrow.len=0))
abline(v=1, lty=2, lwd=1.5)
dev.off()
