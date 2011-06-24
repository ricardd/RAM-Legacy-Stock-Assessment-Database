## a script to generate Schaefer fits to stocks in srdb under 2 different upper bounds for the K parameter
## started 2011-06-16 from earlier work in /home/srdbadmin/srdb/R/surplus-production.R
## -> this code is to address a referee's request for the Fish and Fisheries paper
## last modified Time-stamp: <2011-06-23 21:27:47 (srdbadmin)>
##
## changing the bounds of the K parameter is done in the schaefer.dat file used by ADMB

## we will write the model fitting results to 2 separate tables on srdb:
# 1 "srdb.spfits_Schaefer_Kbound2maxTB" - the upper bound on K is set to 2 * max(TB)
# 2 "srdb.spfits_Schaefer_Kbound5maxTB" - the upper bound on K is set to 5 * max(TB)

require(RODBC)
require(xtable)

chan <- odbcConnect(dsn='srdbcalo') # this DSN uses srdbadmin login and has create tabl;e credentials on the srdb schema

source("get_admb_results.R")

## data with TB and TC in MT
qu <- paste("
select a.stockid, v.assessid, v.total as b, v.catch_landings as c from srdb.newtimeseries_values_view v, srdb.timeseries_units_view u, srdb.assessment a where a.assessid=v.assessid and v.assessid=u.assessid and u.total_unit = 'MT' and u.catch_landings_unit = 'MT'
", sep="")

sp.data <- sqlQuery(chan,qu)

my.assessid <- unique(sp.data$assessid)
my.stockid <- unique(sp.data$stockid)
n<-length(my.assessid)
sp.fit.kbound2tb <- data.frame(assessid=my.assessid, lnK=rep(-99,n), K=rep(-99,n), lnMSY=rep(-99,n), MSY=rep(-99,n), BMSY=rep(-99,n), FMSY=rep(-99,n), qualityflag=rep(-99,n))

sp.fit.kbound5tb <- data.frame(assessid=my.assessid, lnK=rep(-99,n), K=rep(-99,n), lnMSY=rep(-99,n), MSY=rep(-99,n), BMSY=rep(-99,n), FMSY=rep(-99,n), qualityflag=rep(-99,n))


#########################
################
######## start upper bound to 2*max(TB) here
for (i in 1:n) {
print(i)
print(my.assessid[i])

  temp.dat <- na.omit(subset(sp.data, assessid == my.assessid[i]))

max.b <- max(na.omit(temp.dat$b))
##try(print(log(2*max.b)))

## write ADMB-compatible data file
  my.dat.path<-"/home/srdbadmin/srdb/ADMB/schaefer.dat"
  cat("# Number of obs \n",dim(temp.dat)[1], "\n",file = my.dat.path, append=FALSE)

##################################
## upper and lower bounds on K
  cat("# Lower bound on K - 0 \n", 0, "\n",file = my.dat.path, append=TRUE)
  cat("# Upper bound on K - ln(X*max(biomass)) \n", log(2*max.b), "\n",file = my.dat.path, append=TRUE)
  cat("# observed X values \t observed Y values \n", file = my.dat.path, append=TRUE)
  write.table(cbind(temp.dat$c,temp.dat$b), file=my.dat.path, append = TRUE, col.names=FALSE,row.names=FALSE)

## call to ADMB
  system("cd /home/srdbadmin/srdb/ADMB; rm schaefer.std; ./schaefer", ignore.stdout = TRUE)

## did the model converge?
conv <- length(system("ls /home/srdbadmin/srdb/ADMB/schaefer.std", intern=TRUE))
print(conv)
if(conv) {
## read in parameter estimates from ADMB output
admb.fit <- get.admb.results("/home/srdbadmin/srdb/ADMB/","schaefer")
admb.rep<-readLines("/home/srdbadmin/srdb/ADMB/schaefer.rep")

sp.fit.kbound2tb$assessid[i]<-my.assessid[i]
sp.fit.kbound2tb$lnK[i] <- admb.fit[1,3]
sp.fit.kbound2tb$K[i] <- exp(sp.fit.kbound2tb$lnK[i])
sp.fit.kbound2tb$lnMSY[i] <- admb.fit[2,3]
sp.fit.kbound2tb$MSY[i] <- exp(sp.fit.kbound2tb$lnMSY[i])
sp.fit.kbound2tb$BMSY[i] <- as.numeric(strsplit(admb.rep, split="\t")[[1]])[1]
sp.fit.kbound2tb$FMSY[i] <- as.numeric(strsplit(admb.rep, split="\t")[[1]])[2]
if(sp.fit.kbound2tb$lnK[i] < 0) sp.fit.kbound2tb$qualityflag[i] <- -8 else sp.fit.kbound2tb$qualityflag[i] <- 1

## did a parameter estimate reach the upper bound of 2*log(K)?
##if(log(2*max.b) == sp.fit.kbound2tb$lnK[i]) { sp.fit.kbound2tb$qualityflag[i] <- -8} ## OLAF ADVISED AGAINST THIS since the upper bound may provide a reasonable fit

##plot(na.omit(as.numeric(strsplit(admb.rep, split=" ")[[2]])))

## generate surplus production vs. total biomass plot as per Olaf's
tb<-na.omit(as.numeric(strsplit(admb.rep, split=" ")[[2]]))
ll<-length(tb)
tb<-tb[1:ll-1] # get rid of last biomass data point
sp.obs<-na.omit(as.numeric(strsplit(admb.rep, split=" ")[[3]]))
sp.pred<-na.omit(as.numeric(strsplit(admb.rep, split=" ")[[4]]))


# generate the predicted surplus production over a regularly spaced grid
mi <- min(tb)
ma <- max(tb)
ss <- (ma-mi)/100
reg.grid <- seq(mi,ma,ss)

pp <- (4*sp.fit.kbound2tb$MSY[i]*reg.grid) / sp.fit.kbound2tb$K[i]-(4*sp.fit.kbound2tb$MSY[i])*(reg.grid/sp.fit.kbound2tb$K[i])^2

} # end if

else {
sp.fit.kbound2tb$assessid[i]<-my.assessid[i]
sp.fit.kbound2tb$lnK[i] <- -8
sp.fit.kbound2tb$K[i] <- -8
sp.fit.kbound2tb$lnMSY[i] <- -8
sp.fit.kbound2tb$MSY[i] <- -8
sp.fit.kbound2tb$BMSY[i] <- -8
sp.fit.kbound2tb$FMSY[i] <- -8
sp.fit.kbound2tb$qualityflag[i] <- -8

} # end else


}

# send the fitted parameter values, SSBmsy and MSY back to srdb in table srdb.spfits_schaefer
sqlSave(chan, sp.fit.kbound2tb, tablename="srdb.spfits_Schaefer_Kbound2maxTB_all",safer=FALSE)

## insert a comment on the table
qu <- "COMMENT ON TABLE srdb.spfits_Schaefer_Kbound2maxTB_all IS 'This table stores ALL the parameter estimates from the Schaefer surplus production model, including non-converging fits, ran against available catch and total biomass timeseries. The upper bound on the K parameter is set to 2 * max(TB)'"
sqlQuery(chan,qu)

######## end upper bound to 2*max(TB) here
################
#########################

#########################
################
######## start upper bound to 5*max(TB) here
for (i in 1:n) {
print(i)
print(my.assessid[i])

  temp.dat <- na.omit(subset(sp.data, assessid == my.assessid[i]))

max.b <- max(na.omit(temp.dat$b))
##try(print(log(2*max.b)))

## write ADMB-compatible data file
  my.dat.path<-"/home/srdbadmin/srdb/ADMB/schaefer.dat"
  cat("# Number of obs \n",dim(temp.dat)[1], "\n",file = my.dat.path, append=FALSE)

##################################
## upper and lower bounds on K
  cat("# Lower bound on K - 0 \n", 0, "\n",file = my.dat.path, append=TRUE)
  cat("# Upper bound on K - ln(X*max(biomass)) \n", log(5*max.b), "\n",file = my.dat.path, append=TRUE)
  cat("# observed X values \t observed Y values \n", file = my.dat.path, append=TRUE)
  write.table(cbind(temp.dat$c,temp.dat$b), file=my.dat.path, append = TRUE, col.names=FALSE,row.names=FALSE)

## call to ADMB
  system("cd /home/srdbadmin/srdb/ADMB; rm schaefer.std; ./schaefer", ignore.stdout = TRUE)

## did the model converge?
conv <- length(system("ls /home/srdbadmin/srdb/ADMB/schaefer.std", intern=TRUE))
print(conv)
if(conv) {
## read in parameter estimates from ADMB output
admb.fit <- get.admb.results("/home/srdbadmin/srdb/ADMB/","schaefer")
admb.rep<-readLines("/home/srdbadmin/srdb/ADMB/schaefer.rep")

sp.fit.kbound5tb$assessid[i]<-my.assessid[i]
sp.fit.kbound5tb$lnK[i] <- admb.fit[1,3]
sp.fit.kbound5tb$K[i] <- exp(sp.fit.kbound5tb$lnK[i])
sp.fit.kbound5tb$lnMSY[i] <- admb.fit[2,3]
sp.fit.kbound5tb$MSY[i] <- exp(sp.fit.kbound5tb$lnMSY[i])
sp.fit.kbound5tb$BMSY[i] <- as.numeric(strsplit(admb.rep, split="\t")[[1]])[1]
sp.fit.kbound5tb$FMSY[i] <- as.numeric(strsplit(admb.rep, split="\t")[[1]])[2]
if(sp.fit.kbound5tb$lnK[i] < 0) sp.fit.kbound5tb$qualityflag[i] <- -8 else sp.fit.kbound5tb$qualityflag[i] <- 1

## did a parameter estimate reach the upper bound of 2*log(K)?
##if(log(2*max.b) == sp.fit.kbound5tb$lnK[i]) { sp.fit.kbound5tb$qualityflag[i] <- -8} ## OLAF ADVISED AGAINST THIS since the upper bound may provide a reasonable fit

##plot(na.omit(as.numeric(strsplit(admb.rep, split=" ")[[2]])))

## generate surplus production vs. total biomass plot as per Olaf's
tb<-na.omit(as.numeric(strsplit(admb.rep, split=" ")[[2]]))
ll<-length(tb)
tb<-tb[1:ll-1] # get rid of last biomass data point
sp.obs<-na.omit(as.numeric(strsplit(admb.rep, split=" ")[[3]]))
sp.pred<-na.omit(as.numeric(strsplit(admb.rep, split=" ")[[4]]))


# generate the predicted surplus production over a regularly spaced grid
mi <- min(tb)
ma <- max(tb)
ss <- (ma-mi)/100
reg.grid <- seq(mi,ma,ss)

pp <- (4*sp.fit.kbound5tb$MSY[i]*reg.grid) / sp.fit.kbound5tb$K[i]-(4*sp.fit.kbound5tb$MSY[i])*(reg.grid/sp.fit.kbound5tb$K[i])^2

} # end if

else {
sp.fit.kbound5tb$assessid[i]<-my.assessid[i]
sp.fit.kbound5tb$lnK[i] <- -8
sp.fit.kbound5tb$K[i] <- -8
sp.fit.kbound5tb$lnMSY[i] <- -8
sp.fit.kbound5tb$MSY[i] <- -8
sp.fit.kbound5tb$BMSY[i] <- -8
sp.fit.kbound5tb$FMSY[i] <- -8
sp.fit.kbound5tb$qualityflag[i] <- -8

} # end else


}

# send the fitted parameter values, SSBmsy and MSY back to srdb in table srdb.spfits_schaefer
sqlSave(chan, sp.fit.kbound5tb, tablename="srdb.spfits_Schaefer_Kbound5maxTB_all",safer=FALSE)

## insert a comment on the table
qu <- "COMMENT ON TABLE srdb.spfits_Schaefer_Kbound5maxTB_all IS 'This table stores ALL the parameter estimates from the Schaefer surplus production model, including non-converging fits, ran against available catch and total biomass timeseries. The upper bound on the K parameter is set to 5 * max(TB)'"
sqlQuery(chan,qu)

######## end upper bound to 5*max(TB) here
################
#########################


############ NOW REMOVE THE ASSESSEMENTS THAT WERE NOT DEEMED "GOOD"
## NOTE: inclusion and removal of assessid for SP fits is now handled in the SQL call
system("psql srdb -f schaefer-inclusion-Kbounds.sql")



### now see what differences there are between the B/Bmsy and U/Umsy ratios when using the 2 different K bound options
## using spfits table with 2*max(TB) as upper bound for K
    tb.salt.kbounds2.qu <- paste("
select tsv.assessid, a.maxyr, tsv.total as numerator, sp.bmsy as denominator, tsv.total/sp.bmsy as ratio, 'no' as btype from srdb.spfits_schaefer_kbound2maxtb sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits_schaefer_kbound2maxtb s where s.assessid=tsv.assessid and tsv.total is not null and tsv.catch_landings is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor) AND recorder != \'MYERS\')
", sep="")
  tb.salt.kbounds2 <- sqlQuery(chan,tb.salt.kbounds2.qu, stringsAsFactors=FALSE)

## using spfits table with 2*max(TB) as upper bound for K
  f.salt.kbounds2.qu <- paste("
select tsv.assessid, a.maxyr, (tsv.catch_landings/tsv.total) as u, sp.fmsy, (tsv.catch_landings/tsv.total)/sp.fmsy as ratio, 'no' as utype from srdb.spfits_schaefer_kbound2maxtb sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits_schaefer_kbound2maxtb s where s.assessid=tsv.assessid and tsv.catch_landings is not null and tsv.total is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor) and recorder != \'MYERS\')
", sep="")
  f.salt.kbounds2 <- sqlQuery(chan,f.salt.kbounds2.qu, stringsAsFactors=FALSE)


## using spfits table with 5*max(TB) as upper bound for K
    tb.salt.kbounds5.qu <- paste("
select tsv.assessid, a.maxyr, tsv.total as numerator, sp.bmsy as denominator, tsv.total/sp.bmsy as ratio, 'no' as btype from srdb.spfits_schaefer_kbound5maxtb sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits_schaefer_kbound5maxtb s where s.assessid=tsv.assessid and tsv.total is not null and tsv.catch_landings is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor) AND recorder != \'MYERS\')
", sep="")
  tb.salt.kbounds5 <- sqlQuery(chan,tb.salt.kbounds5.qu, stringsAsFactors=FALSE)

## using spfits table with 5*max(TB) as upper bound for K
  f.salt.kbounds5.qu <- paste("
select tsv.assessid, a.maxyr, (tsv.catch_landings/tsv.total) as u, sp.fmsy, (tsv.catch_landings/tsv.total)/sp.fmsy as ratio, 'no' as utype from srdb.spfits_schaefer_kbound5maxtb sp, srdb.timeseries_values_view tsv, (select tsv.assessid, max(tsyear) as maxyr from srdb.timeseries_values_view tsv, srdb.spfits_schaefer_kbound5maxtb s where s.assessid=tsv.assessid and tsv.catch_landings is not null and tsv.total is not null group by tsv.assessid) as a where sp.assessid=tsv.assessid and a.assessid=tsv.assessid AND a.maxyr=tsv.tsyear and tsv.assessid in (select assessid from srdb.assessment where assessorid in (select assessorid from srdb.assessor) and recorder != \'MYERS\')
", sep="")
  f.salt.kbounds5 <- sqlQuery(chan,f.salt.kbounds5.qu, stringsAsFactors=FALSE)


tb.salt.merged <- merge(tb.salt.kbounds2,tb.salt.kbounds5,"assessid")
f.salt.merged <- merge(f.salt.kbounds2,f.salt.kbounds5,"assessid")

#dim()
tb.ratio.changed <- subset(tb.salt.merged, round(ratio.x,3) != round(ratio.y,3))
tb.ratio.changed$diff2to5 <- round(tb.ratio.changed$ratio.y,3) - round(tb.ratio.changed$ratio.x,3)
f.ratio.changed <- subset(f.salt.merged, round(ratio.x,3) != round(ratio.y,3))
f.ratio.changed$diff2to5 <- round(f.ratio.changed$ratio.y,3) - round(f.ratio.changed$ratio.x,3) 

##
cbind(tb.ratio.changed$assessid, tb.ratio.changed$diff2to5, round(tb.ratio.changed$ratio.x,3), round(tb.ratio.changed$ratio.y,3))
cbind(f.ratio.changed$assessid, round(f.ratio.changed$diff2to5,4), round(f.ratio.changed$ratio.x,3), round(f.ratio.changed$ratio.y,3))

dim(tb.ratio.changed)
dim(f.ratio.changed)

#hist(tb.ratio.changed$ratio.x-tb.ratio.changed$ratio.y)
## select assessid from srdb.spfits where assessid in (select assessid from srdb.assessment where assessmethod in (select methodshort from srdb.assessmethod where category = 'Biomass dynamics model'));


odbcClose(chan)

## see what assessid have different ratios


# similar table but to look at the differences in B/Bmsy and U/Umsy ratios when using the 2 different bounds on K
# crosshair.for.kbounds <- data.frame(mgmt=crosshair.for.table.temp$mgmt, country=crosshair.for.table.temp$country, stock=crosshair.for.table.temp$stocklong.y ,scientificname=crosshair.for.table.temp$scientificname.y, ordername=crosshair.for.table.temp$ordername, TL=crosshair.for.table.temp$tl, assessmethod=crosshair.for.table.temp$category, timespan=crosshair.for.table.temp$timespan.y, currentyear=crosshair.for.table.temp$maxyr.x, Bratio=ifelse(crosshair.for.table.temp$btype=="yes",round(crosshair.for.table.temp$ratio.x,2), paste(round(crosshair.for.table.temp$ratio.x,2),"*")), Uratio=ifelse(crosshair.for.table.temp$utype=="yes",round(crosshair.for.table.temp$ratio.y,2), paste(round(crosshair.for.table.temp$ratio.y,2),"*")))
#  my.table.kbounds <- xtable(crosshair.for.kbounds, caption=my.caption, label=c("tab:crosshair"), digits=2, align="p{1.5cm}p{1.5cm}p{1.5cm}p{3cm}p{3cm}p{2.5cm}p{0.9cm}p{1.4cm}p{0.9cm}p{0.9cm}p{0.9cm}p{1cm}")
#  print(my.table.kbounds, type="latex", file="../../tex/first-review/Table-kbounds.tex", include.rownames=FALSE, floating=FALSE, tabular.environment="longtable", caption.placement="bottom", sanitize.text.function=I)
