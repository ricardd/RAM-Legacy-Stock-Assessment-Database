## fit surplus production model to srdb data and stored the results into a new table
## Daniel Ricard started 2010-03-12 from earlier work from Olaf and Coilin
## Last modified Time-stamp: <2011-01-19 13:26:36 (srdbadmin)>
## 2010-11-30: modified to use the Fox model
require(RODBC)
require(gplots)

source("get_admb_results.R")

chan <- odbcConnect(dsn="srdbcalo")
## data with TB and TC in MT
qu <- paste("
select a.stockid, v.assessid, v.total as b, v.catch_landings as c from srdb.newtimeseries_values_view v, srdb.timeseries_units_view u, srdb.assessment a where a.assessid=v.assessid and v.assessid=u.assessid and u.total_unit = 'MT' and u.catch_landings_unit = 'MT'
", sep="")

sp.data <- sqlQuery(chan,qu)

my.assessid <- unique(sp.data$assessid)
my.stockid <- unique(sp.data$stockid)
n<-length(my.assessid)
sp.fit <- data.frame(assessid=my.assessid, lnK=rep(-99,n), K=rep(-99,n), lnMSY=rep(-99,n), MSY=rep(-99,n), BMSY=rep(-99,n), FMSY=rep(-99,n), qualityflag=rep(-99,n))

pdf("spfits_FOX-all.pdf", width=8, height=10, title="All Fox fits")
par(mfrow=c(5,4),mar=c(1,1,1,1), oma=c(3.5,3,0,0))

for (i in 1:n) {
print(i)
print(my.assessid[i])

  temp.dat <- na.omit(subset(sp.data, assessid == my.assessid[i]))

max.b <- max(temp.dat$b)
try(print(log(2*max.b)))


## write ADMB-compatible data file
  my.dat.path<-"/home/srdbadmin/srdb/ADMB/fox.dat"
  cat("# Number of obs \n",dim(temp.dat)[1], "\n",file = my.dat.path, append=FALSE)
  cat("# Bound on K - ln(X*max(biomass)) \n", log(2*max.b), "\n",file = my.dat.path, append=TRUE)
#  cat("# Bound on K - ln(X*max(biomass)) \n", 25, "\n",file = my.dat.path, append=TRUE)
  cat("# observed X values \t observed Y values \n", file = my.dat.path, append=TRUE)
  write.table(cbind(temp.dat$c,temp.dat$b), file=my.dat.path, append = TRUE, col.names=FALSE,row.names=FALSE)
## call to ADMB
  system("cd /home/srdbadmin/srdb/ADMB; rm fox.std; ./fox")

## did the model converge?
conv <- length(system("ls /home/srdbadmin/srdb/ADMB/fox.std", intern=TRUE))
if(conv) {
## read in parameter estimates from ADMB output
admb.fit <- get.admb.results("/home/srdbadmin/srdb/ADMB/","fox")
admb.rep<-readLines("/home/srdbadmin/srdb/ADMB/fox.rep")



sp.fit$assessid[i]<-my.assessid[i]
sp.fit$lnK[i] <- admb.fit[1,3]
sp.fit$K[i] <- exp(sp.fit$lnK[i])
sp.fit$lnMSY[i] <- admb.fit[2,3]
sp.fit$MSY[i] <- exp(sp.fit$lnMSY[i])
sp.fit$BMSY[i] <- as.numeric(strsplit(admb.rep, split="\t")[[1]])[1]
sp.fit$FMSY[i] <- as.numeric(strsplit(admb.rep, split="\t")[[1]])[2]
if(sp.fit$lnK[i] < 0) sp.fit$qualityflag[i] <- -8 else sp.fit$qualityflag[i] <- 1

## did a parameter estimate reach the upper bound of 2*log(K)?
##if(log(2*max.b) == sp.fit$lnK[i]) { sp.fit$qualityflag[i] <- -8} ## OLAF ADVISED AGAINST THIS since the upper bound may provide a reasonable fit

##plot(na.omit(as.numeric(strsplit(admb.rep, split=" ")[[2]])))

## generate surplus production vs. total biomass plot as per Olaf's
tb<-na.omit(as.numeric(strsplit(admb.rep, split=" ")[[2]]))
ll<-length(tb)
tb<-tb[1:ll-1] # get rid of last biomass data point
sp.obs<-na.omit(as.numeric(strsplit(admb.rep, split=" ")[[3]]))
sp.pred<-na.omit(as.numeric(strsplit(admb.rep, split=" ")[[4]]))

plot.colors <- colorRampPalette(c("blue","red"), space="Lab")(ll) ## rich.colors(ll)
plot(tb,sp.obs,type='p',col=plot.colors,xlab="Total Biomass",ylab="Surplus Production")
lines(tb,sp.obs,col=grey(0.5),lwd=0.5)

# generate the predicted surplus production over a regularly spaced grid
mi <- min(tb)
ma <- max(tb)
ss <- (ma-mi)/100
reg.grid <- seq(mi,ma,ss)

pp <- (4*sp.fit$MSY[i]*reg.grid) / sp.fit$K[i]-(4*sp.fit$MSY[i])*(reg.grid/sp.fit$K[i])^2

## lines(tb[order(tb)],sp.pred[order(tb)],type='l',col="black")
lines(reg.grid,pp,type='l',col="black",lwd=1.5)

legend("topleft", legend=my.stockid[i], bty="n")
} # end if
else {
sp.fit$assessid[i]<-my.assessid[i]
sp.fit$lnK[i] <- -8
sp.fit$K[i] <- -8
sp.fit$lnMSY[i] <- -8
sp.fit$MSY[i] <- -8
sp.fit$BMSY[i] <- -8
sp.fit$FMSY[i] <- -8
sp.fit$qualityflag[i] <- -8

} # end else


}

dev.off()
# send the fitted parameter values, SSBmsy and MSY back to srdb
sqlSave(chan, sp.fit, tablename="srdb.spfits_FOX",safer=FALSE)


## NOTE: inclusion and removal of assessid for SP fits is now handled in the SQL call
system("psql srdb -f fox-inclusion.sql")

## delete entries that have not converged
##qu <- "DELETE FROM srdb.spfits_FOX where qualityflag=-8"
##sqlQuery(chan,qu)

## insert a comment on the table
qu <- "COMMENT ON TABLE srdb.spfits_FOX IS 'This table stores the parameter estimates from the Fox surplus production model ran against the catch and total biomass timeseries.'"
sqlQuery(chan,qu)

##########################################
## now generate another pdf document that only contains the surplus production fits that are satisfactory
## the contents of the table srdb.spfits_schaefer now only has the assessid identified by Olaf as accepted, so use those only for the pdf document


## data with TB and TC in MT
qu <- paste("
select a.stockid, v.assessid, v.total as b, v.catch_landings as c from srdb.newtimeseries_values_view v, srdb.timeseries_units_view u, srdb.assessment a where a.assessid=v.assessid and v.assessid=u.assessid and u.total_unit = 'MT' and u.catch_landings_unit = 'MT' and a.assessid in (select assessid from srdb.spfits_fox)
", sep="")

sp.data.cleaned <- sqlQuery(chan,qu)

my.assessid <- unique(sp.data.cleaned$assessid)
my.stockid <- unique(sp.data.cleaned$stockid)
n<-length(my.assessid)

qu <- paste("select * from srdb.spfits_fox") ## bring back parameter estimates from srdb.spfits_schaefer
sp.fit.srdb <- sqlQuery(chan,qu)

pdf("spfits-Fox-MANUALLY-CLEANED.pdf", width=8, height=10, title="Fox fits manually cleaned")
par(mfrow=c(5,4),mar=c(1,1,1,1), oma=c(3.5,3,0,0))


for (i in 1:n) {
print(i)
print(my.assessid[i])

  temp.dat <- na.omit(subset(sp.data.cleaned, assessid == my.assessid[i]))

max.b <- max(temp.dat$b)

## generate surplus production vs. total biomass plot as per Olaf's
## use the paramter estimates available in srdb.spfits_schaefer to produce the plot
tb<-temp.dat$b

tc<-temp.dat$c
ll<-length(tc)
tc<-tc[1:ll-1] # get rid of last catch data point
#
#sp.obs <- # compute surplus production
sp.obs<-diff(tb)+tc

ll<-length(tb)
tb<-tb[1:ll-1] # get rid of last catch data point

plot.colors <- colorRampPalette(c("blue","red"), space="Lab")(ll) ## rich.colors(ll)
plot(tb,sp.obs,type='p',col=plot.colors,xlab="Total Biomass",ylab="Surplus Production")
lines(tb,sp.obs,col=grey(0.5),lwd=0.5)

# generate the predicted surplus production over a regularly spaced grid
mi <- min(tb)
ma <- max(tb)
ss <- (ma-mi)/100
reg.grid <- seq(mi,ma,ss)

pp <- (4*sp.fit.srdb$msy[i]*reg.grid) / sp.fit.srdb$k[i]-(4*sp.fit.srdb$msy[i])*(reg.grid/sp.fit.srdb$k[i])^2

## lines(tb[order(tb)],sp.pred[order(tb)],type='l',col="black")
lines(reg.grid,pp,type='l',col="black",lwd=1.5)

legend("topleft", legend=my.stockid[i], bty="n")
}

dev.off()

odbcClose(chan)
