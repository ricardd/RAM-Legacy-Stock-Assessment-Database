# template that Perl uses to run the plots for the QAQC
# Coilín Minto
# date: Thu Nov 27 14:47:59 AST 2008
# Time-stamp: <2011-02-25 15:28:03 (srdbadmin)>
# Modifification history
## 2010-02-17: some of the units names in the views changed, amended code to reflect that (some plots were not showing a y axis label on the exploitation plots) - DR
## 2010-03-15: changed line 41 sum(x to sum(as.numeric(x) because I was getting an integer overflow for recruitment timeseries for assessment AFWG-CAPENOR-1965-2007-MINTO - DR
## 2010-03-25: modified code to plot SSB and TB when their units are not the same, the reference points were not plotted on the right axis, fixed this, see NWFSC-BLUEROCKCAL-1916-2007-BRANCH for an example- DR
## 2011-02-11: I just noticed that the x axis for the timeseries plots do not necessarily share their "xlim", so if one timeseries, say CATCH, is longer than say F, they ended up being plotted on different scales. I changed to code so that "xlim" is set to a single value and used by all call to "plot".
# load necessaries
library("RODBC")
# what assessment
assessid<-"NEFSC-AMPL5YZ-1960-2008-OBRIEN"
#assessid<-"NEFSC-COD5Z-1960-2007-BAUM"
# assessid<-"DFO-PAC-HERRCC-1951-2007-COLLIE"
#assessid<-"IATTC-BIGEYEEPAC-1975-2007-JENSEN"
# assessid<-"NWFSC-BLUEROCKCAL-1916-2007-BRANCH"
# connect to the database
mychan<-odbcConnect(dsn="srdbusercalo") # note how the DSN is used here
#sqlTables(mychan)

# bring back the data
#~~~~~~~~~~ timeseries data ~~~~~~~~~~~~
# write the query
ts.val.query<-paste("select * from srdb.timeseries_values_view where assessid=\'",assessid,"\'", sep="")
# retrieve these data
ts.val.df<-sqlQuery(mychan,ts.val.query)
#~~~~~~~~~~ timeseries units ~~~~~~~~~~~~
ts.units.query<-paste("select * from srdb.timeseries_units_view where assessid=\'",assessid,"\'", sep="")
ts.units.df<-sqlQuery(mychan,ts.units.query)

# ~~~~~~~~~~ reference point values ~~~~~~~~~~~
ref.vals.query<-paste("select * from srdb.reference_point_values_view where assessid=\'",assessid,"\'", sep="")
ref.vals.df<-sqlQuery(mychan,ref.vals.query)

# ~~~~~~~~~~ reference point units ~~~~~~~~~~~
ref.units.query<-paste("select * from srdb.reference_point_units_view where assessid=\'",assessid,"\'", sep="")
ref.units.df<-sqlQuery(mychan,ref.units.query)


# close the connection at the end of a session or after retrieval 
odbcClose(mychan)

# what series are available
sum.dat.rows<-apply(ts.val.df[,4:length(ts.val.df[1,])],2,FUN=function(x){sum(as.numeric(x), na.rm=TRUE)})
sum.dat.rows[sum.dat.rows>0]
avail.series<-names(sum.dat.rows[sum.dat.rows>0])
# the plot
#pdf("./test.pdf")
#pdf(paste("/home/srdbadmin/SQLpg/srdb/trunk/tex/figures/plot-",assessid,".pdf", sep=""), width=9, height=9)
pdf(paste("/home/srdbadmin/srdb/tex/figures/plot-",assessid,".pdf", sep=""), width=9, height=9)
# layout of the plot
par( oma=c(2,1,1,0))
layout.mat<-matrix(c(1,2,3,4), 2, 2, byrow = TRUE)
layout(layout.mat)
par(mar=c(3,3,3,1))

##~~~~~~~~~~~~~ biomass plot ~~~~~~~~~~~~~~~~
# year limits for the different plots
year.lim.bioplot<-range(ts.val.df$tsyear[!is.na(ts.val.df$ssb)|!is.na(ts.val.df$total)], na.rm=TRUE)


if("ssb"%in%avail.series & "total"%in%avail.series){ ## we have both SSB and TB
  if(as.character(ts.units.df$ssb_unit)==as.character(ts.units.df$total_unit)){ ## units are the same for SSB and TB
max.bioplot<-max(c(ts.val.df$ssb[!is.na(ts.val.df$ssb)], ts.val.df$total[!is.na(ts.val.df$total)]))  
with(ts.val.df, plot(tsyear, ssb, xlab="", ylab="", type='l', lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim.bioplot, ylim=c(0,max.bioplot)))
mtext(side=1,text="Year", line=2, cex=1.1)
mtext(side=2,text=paste("Biomass"," (",ts.units.df$ssb_unit,")", sep=""), line=2, cex=1.1)
with(ts.val.df, lines(tsyear, total,lty=2, lwd=1.5))

abline(h=c(ref.vals.df$blim,ref.vals.df$ssblim,ref.vals.df$ssbpa,ref.vals.df$bmsy, ref.vals.df$ssbmsy), lty=6)
x.coord<-with(ts.val.df[!is.na(ts.val.df$ssb)|!is.na(ts.val.df$total),], min(tsyear, na.rm=TRUE))
blim.coord<-try(ref.vals.df$blim+0.3*ref.vals.df$blim, silent=TRUE)
ssblim.coord<-try(ref.vals.df$ssblim+0.3*ref.vals.df$ssblim, silent=TRUE)
ssbpa.coord<-try(ref.vals.df$ssbpa+0.3*ref.vals.df$ssbpa, silent=TRUE)
bmsy.coord<-try(ref.vals.df$bmsy+0.3*ref.vals.df$bmsy, silent=TRUE)
ssbmsy.coord<-try(ref.vals.df$ssbmsy+0.2*ref.vals.df$ssbmsy, silent=TRUE)
try(text(x.coord+2, blim.coord, label="Blim"), silent=TRUE)
try(text(x.coord+2, bmsy.coord, label="Bmsy"), silent=TRUE)
try(text(x.coord+2, ssbmsy.coord, label="SSBmsy"), silent=TRUE)
try(text(x.coord+2, ssblim.coord, label="SSBlim"), silent=TRUE)
try(text(x.coord+2, ssbpa.coord, label="SSBpa"), silent=TRUE)

}else{ ## units are different for SSB and TB
  par(mar=c(3,3,3,4))
  max.ssb<-max(ts.val.df$ssb[!is.na(ts.val.df$ssb)])
  max.total<-max(ts.val.df$total[!is.na(ts.val.df$total)])  
  with(ts.val.df, plot(tsyear, ssb, xlab="", ylab="", type='l', lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim.bioplot, ylim=c(0,max.ssb)))
  mtext(side=1,text="Year", line=2, cex=1.1)
  mtext(side=2,text=paste("Spawning stock biomass"," (",ts.units.df$ssb_unit,")", sep=""), line=2, cex=1.1)

  abline(h=c(ref.vals.df$ssblim,ref.vals.df$ssbpa,ref.vals.df$ssbmsy), lty=6)
x.coord<-with(ts.val.df[!is.na(ts.val.df$ssb)|!is.na(ts.val.df$total),], min(tsyear, na.rm=TRUE))
ssblim.coord<-try(ref.vals.df$ssblim+0.3*ref.vals.df$ssblim, silent=TRUE)
ssbpa.coord<-try(ref.vals.df$ssbpa+0.3*ref.vals.df$ssbpa, silent=TRUE)
ssbmsy.coord<-try(ref.vals.df$ssbmsy+0.2*ref.vals.df$ssbmsy, silent=TRUE)
try(text(x.coord+2, ssbmsy.coord, label="SSBmsy"), silent=TRUE)
try(text(x.coord+2, ssblim.coord, label="SSBlim"), silent=TRUE)
try(text(x.coord+2, ssbpa.coord, label="SSBpa"), silent=TRUE)

  par(new=TRUE)

  
  with(ts.val.df, plot(tsyear, total, xlab="", ylab="", type='l', lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim.bioplot, ylim=c(0,max.total), lty=2, xaxt="n", yaxt="n"))
  axis(side=4)
  mtext(side=4,text=paste("Total biomass"," (",ts.units.df$total_unit,")", sep=""), line=2, cex=1.1)

  abline(h=c(ref.vals.df$blim,ref.vals.df$bmsy), lty=6)
x.coord<-with(ts.val.df[!is.na(ts.val.df$ssb)|!is.na(ts.val.df$total),], min(tsyear, na.rm=TRUE))
blim.coord<-try(ref.vals.df$blim+0.3*ref.vals.df$blim, silent=TRUE)
bmsy.coord<-try(ref.vals.df$bmsy+0.3*ref.vals.df$bmsy, silent=TRUE)
try(text(x.coord+2, blim.coord, label="Blim"), silent=TRUE)
try(text(x.coord+2, bmsy.coord, label="Bmsy"), silent=TRUE)
}

  
mtext(side=1,text="Year", line=2, cex=1.1)
legend("topright", legend=c("SSB","Total biomass"), lty=c(1,2), lwd=c(1.5,1.5), bty="n", cex=1.2, horiz=FALSE)
}
if("ssb"%in%avail.series & !"total"%in% avail.series){  ## we have SSB only
max.bioplot<-max(c(ts.val.df$ssb[!is.na(ts.val.df$ssb)], ts.val.df$total[!is.na(ts.val.df$total)]))
  with(ts.val.df, plot(tsyear, ssb, xlab="", ylab="", type='l', lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim.bioplot, ylim=c(0,max.bioplot)))
mtext(side=1,text="Year", line=2, cex=1.1)
mtext(side=2,text=paste("Biomass"," (",ts.units.df$ssb_unit,")", sep=""), line=2, cex=1.1)
legend("topright", legend=c("SSB"), lty=c(1), lwd=c(2), bty="n", cex=1.2, horiz=FALSE)
abline(h=c(ref.vals.df$blim,ref.vals.df$ssblim,ref.vals.df$ssbpa,ref.vals.df$bmsy, ref.vals.df$ssbmsy), lty=6)
x.coord<-with(ts.val.df[!is.na(ts.val.df$ssb)|!is.na(ts.val.df$total),], min(tsyear, na.rm=TRUE))
blim.coord<-try(ref.vals.df$blim+0.3*ref.vals.df$blim, silent=TRUE)
ssblim.coord<-try(ref.vals.df$ssblim+0.3*ref.vals.df$ssblim, silent=TRUE)
ssbpa.coord<-try(ref.vals.df$ssbpa+0.3*ref.vals.df$ssbpa, silent=TRUE)
bmsy.coord<-try(ref.vals.df$bmsy+0.3*ref.vals.df$bmsy, silent=TRUE)
ssbmsy.coord<-try(ref.vals.df$ssbmsy+0.2*ref.vals.df$ssbmsy, silent=TRUE)
try(text(x.coord+2, blim.coord, label="Blim"), silent=TRUE)
try(text(x.coord+2, bmsy.coord, label="Bmsy"), silent=TRUE)
try(text(x.coord+2, ssbmsy.coord, label="SSBmsy"), silent=TRUE)
try(text(x.coord+2, ssblim.coord, label="SSBlim"), silent=TRUE)
try(text(x.coord+2, ssbpa.coord, label="SSBpa"), silent=TRUE)

}
if(!"ssb"%in%avail.series & "total"%in% avail.series){ ## we have TB only
max.bioplot<-max(c(ts.val.df$ssb[!is.na(ts.val.df$ssb)], ts.val.df$total[!is.na(ts.val.df$total)]))
  with(ts.val.df, plot(tsyear, total, xlab="", ylab="", type='l', lwd=1.5, lty=2, cex.lab=1.2, bty="l", xlim=year.lim.bioplot, ylim=c(0,max.bioplot)))
mtext(side=1,text="Year", line=2, cex=1.1)
mtext(side=2,text=paste("Total biomass"," (",ts.units.df$total_unit,")", sep=""), line=2, cex=1.1)
legend("topright", legend=c("Total biomass"), lty=c(2), lwd=c(1.5,1.5), bty="n", cex=1.2, horiz=FALSE)
abline(h=c(ref.vals.df$blim,ref.vals.df$ssblim,ref.vals.df$ssbpa,ref.vals.df$bmsy, ref.vals.df$ssbmsy), lty=6)
x.coord<-with(ts.val.df[!is.na(ts.val.df$ssb)|!is.na(ts.val.df$total),], min(tsyear, na.rm=TRUE))
blim.coord<-try(ref.vals.df$blim+0.3*ref.vals.df$blim, silent=TRUE)
ssblim.coord<-try(ref.vals.df$ssblim+0.3*ref.vals.df$ssblim, silent=TRUE)
ssbpa.coord<-try(ref.vals.df$ssbpa+0.3*ref.vals.df$ssbpa, silent=TRUE)
bmsy.coord<-try(ref.vals.df$bmsy+0.3*ref.vals.df$bmsy, silent=TRUE)
ssbmsy.coord<-try(ref.vals.df$ssbmsy+0.2*ref.vals.df$ssbmsy, silent=TRUE)
try(text(x.coord+2, blim.coord, label="Blim"), silent=TRUE)
try(text(x.coord+2, bmsy.coord, label="Bmsy"), silent=TRUE)
try(text(x.coord+2, ssbmsy.coord, label="SSBmsy"), silent=TRUE)
try(text(x.coord+2, ssblim.coord, label="SSBlim"), silent=TRUE)
try(text(x.coord+2, ssbpa.coord, label="SSBpa"), silent=TRUE)

}

## reference points
#if("ssb"%in%avail.series | "total"%in% avail.series){
#abline(h=c(ref.vals.df$blim,ref.vals.df$ssblim,ref.vals.df$ssbpa,ref.vals.df$bmsy, ref.vals.df$ssbmsy), lty=6)
#x.coord<-with(ts.val.df[!is.na(ts.val.df$ssb)|!is.na(ts.val.df$total),], min(tsyear, na.rm=TRUE))
#blim.coord<-try(ref.vals.df$blim+0.3*ref.vals.df$blim, silent=TRUE)
#ssblim.coord<-try(ref.vals.df$ssblim+0.3*ref.vals.df$ssblim, silent=TRUE)
#ssbpa.coord<-try(ref.vals.df$ssbpa+0.3*ref.vals.df$ssbpa, silent=TRUE)
#bmsy.coord<-try(ref.vals.df$bmsy+0.3*ref.vals.df$bmsy, silent=TRUE)
#ssbmsy.coord<-try(ref.vals.df$ssbmsy+0.2*ref.vals.df$ssbmsy, silent=TRUE)
#try(text(x.coord+2, blim.coord, label="Blim"), silent=TRUE)
#try(text(x.coord+2, bmsy.coord, label="Bmsy"), silent=TRUE)
#try(text(x.coord+2, ssbmsy.coord, label="SSBmsy"), silent=TRUE)
#try(text(x.coord+2, ssblim.coord, label="SSBlim"), silent=TRUE)
#try(text(x.coord+2, ssbpa.coord, label="SSBpa"), silent=TRUE)
#}
if(!"ssb"%in%avail.series & !"total"%in% avail.series){
plot(1, type="n", axes=FALSE,xlab="", ylab="")
legend("center", legend="No biomass data \n available", bty="n", cex=1.1)
}


# recruitment ~~~~~~~~~~~~~~~~~~
if("r"%in%avail.series){
year.lim.r<-range(ts.val.df$tsyear[!is.na(ts.val.df$r)], na.rm=TRUE)
max.r<-max(ts.val.df$r[!is.na(ts.val.df$r)])}

if("r"%in%avail.series){ 
with(ts.val.df, plot(tsyear, r, xlab="", ylab="", type='l', lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim.r, ylim=c(0,max.r)))
mtext(side=1,text="Year", line=2, cex=1.1)
mtext(side=2,text=paste("Recruits"," (",ts.units.df$r_unit,")", sep=""), line=2, cex=1.1)
mtext(side=1,text="Year", line=2, cex=1.1)
}
if(!"r"%in%avail.series){
plot(1, type="n", axes=FALSE,xlab="", ylab="")
legend("center", legend="No recruitment \n data available", bty="n", cex=1.1)
}

# exploitation ~~~~~~~~~~~~~~~~~
# plot limits
if("catch_landings"%in%avail.series){
year.lim.catch.landings<-range(ts.val.df$tsyear[!is.na(ts.val.df$catch_landings)], na.rm=TRUE)
max.catch.landings<-max(ts.val.df$catch_landings[!is.na(ts.val.df$catch_landings)])}
if("cpue"%in%avail.series){
year.lim.cpue<-range(ts.val.df$tsyear[!is.na(ts.val.df$cpue)], na.rm=TRUE)
max.cpue<-max(ts.val.df$cpue[!is.na(ts.val.df$cpue)])}
if("f"%in%avail.series){
year.lim.f<-range(ts.val.df$tsyear[!is.na(ts.val.df$f)], na.rm=TRUE)
max.f<-max(ts.val.df$f[!is.na(ts.val.df$f)])}

  
## plots
# catch, cpue, f
if("catch_landings"%in%avail.series & "cpue"%in%avail.series & "f"%in%avail.series ){
## overall xlim
year.lim <- range(c(year.lim.catch.landings, year.lim.cpue, year.lim.f))
  par(mar=c(3,3,3,5))
  with(ts.val.df, plot(tsyear, catch_landings, xlab="", ylab="", type='l', lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim, ylim=c(0,max.catch.landings)))
  mtext(side=1,text="Year", line=2, cex=1.1)
  mtext(side=2,text=paste("Total catch/ landings"," (",ts.units.df[,"catch_landings_unit"],")", sep=""), line=2, cex=1.1)
  par(new=TRUE)
  with(ts.val.df, plot(tsyear, cpue, xlab="", ylab="", type='l', lty=2,lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim, ylim=c(0,max.cpue)))
axis(side=4)
  axis(side=4)
  mtext(side=4,text="CPUE", line=1.8, cex=1.0)
  par(new=TRUE)
  with(ts.val.df, plot(tsyear, f, xlab="", ylab="", type='l', lty=4,lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim, ylim=c(0,max.f), axes=FALSE))
  axis(side=4, line=3)
  mtext(side=4,text="F", line=5, cex=1.0)
legend("topright", legend=c("Total catch/\nlandings","CPUE", "F"), lty=c(1,2,4), lwd=c(2,2,2), bty="n", cex=1.2, horiz=FALSE)
}
# catch, cpue
if("catch_landings"%in%avail.series & "cpue"%in%avail.series & !"f"%in%avail.series ){
## overall xlim
year.lim <- range(c(year.lim.catch.landings, year.lim.cpue))
  par(mar=c(3,3,3,4))
  with(ts.val.df, plot(tsyear, catch_landings, xlab="", ylab="", type='l', lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim, ylim=c(0,max.catch.landings)))
  mtext(side=1,text="Year", line=2, cex=1.1)
  mtext(side=2,text=paste("Total catch/ landings"," (",ts.units.df[,"catch_landings_unit"],")", sep=""), line=2, cex=1.1)
  par(new=TRUE)
  with(ts.val.df, plot(tsyear, cpue, xlab="", ylab="", type='l', lty=2,lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim, ylim=c(0,max.cpue)))
axis(side=4)
  axis(side=4)
  mtext(side=4,text="CPUE", line=1.8, cex=1.0)
  legend("topright", legend=c("Total catch/\nlandings","CPUE"), lty=c(1,2), lwd=c(1.5,1.5), bty="n", cex=1.2, horiz=FALSE)
}
# catch, f
if("catch_landings"%in%avail.series & !"cpue"%in%avail.series & "f"%in%avail.series ){
  ## overall xlim
year.lim <- range(c(year.lim.catch.landings, year.lim.f))

  par(mar=c(3,3,3,4))
  with(ts.val.df, plot(tsyear, catch_landings, xlab="", ylab="", type='l', lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim, ylim=c(0,max.catch.landings)))
  mtext(side=1,text="Year", line=2, cex=1.1)
  mtext(side=2,text=paste("Total catch/ landings"," (",ts.units.df[,"catch_landings_unit"],")", sep=""), line=2, cex=1.1)
  par(new=TRUE)
  with(ts.val.df, plot(tsyear, f, xlab="", ylab="", type='l', lty=4,lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim, ylim=c(0,max.f), axes=FALSE))
  axis(side=4)
  mtext(side=4,text="F", line=2.5, cex=1.0)
legend("topright", legend=c("Total catch/\nlandings", "F"), lty=c(1,4), lwd=c(1.5,1.5), bty="n", cex=1.2, horiz=FALSE)
}
# cpue, f

if(!"catch_landings"%in%avail.series & "cpue"%in%avail.series & "f"%in%avail.series ){
    ## overall xlim
year.lim <- range(c(year.lim.cpue, year.lim.f))

  par(mar=c(3,3,3,4))
  with(ts.val.df, plot(tsyear, cpue, xlab="", ylab="", type='l', lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim, ylim=c(0,max.cpue)))
  mtext(side=1,text="Year", line=2, cex=1.1)
  mtext(side=2,text=paste("CPUE"," (",ts.units.df[,"cpue_unit"],")", sep=""), line=2, cex=1.1)
  par(new=TRUE)
  with(ts.val.df, plot(tsyear, f, xlab="", ylab="", type='l', lty=4,lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim, ylim=c(0,max.f), axes=FALSE))
  axis(side=4)
  mtext(side=4,text="F", line=2.5, cex=1.0)
legend("topright", legend=c("Total catch/\nlandings","CPUE", "F"), lty=c(1,2,4), lwd=c(2,2,2), bty="n", cex=1.2, horiz=FALSE)
}

# catch alone
if("catch_landings"%in%avail.series & !"cpue"%in%avail.series & !"f"%in%avail.series ){
  par(mar=c(3,3,3,2))
  with(ts.val.df, plot(tsyear, catch_landings, xlab="", ylab="", type='l', lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim.catch.landings, ylim=c(0,max.catch.landings)))
  mtext(side=1,text="Year", line=2, cex=1.1)
  mtext(side=2,text=paste("Total catch/ landings"," (",ts.units.df[,"catch_landings_unit"],")", sep=""), line=2, cex=1.1)
}

# cpue alone
if(!"catch_landings"%in%avail.series & "cpue"%in%avail.series & !"f"%in%avail.series ){
  par(mar=c(3,3,3,2))
  with(ts.val.df, plot(tsyear, cpue, xlab="", ylab="", type='l', lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim.cpue, ylim=c(0,max.cpue)))
  mtext(side=1,text="Year", line=2, cex=1.1)
  mtext(side=2,text=paste("CPUE"," (",ts.units.df[,"cpue_unit"],")", sep=""), line=2, cex=1.1)
}

# f alone
if(!"catch_landings"%in%avail.series & !"cpue"%in%avail.series & "f"%in%avail.series ){
  par(mar=c(3,3,3,2))
  with(ts.val.df, plot(tsyear, f, xlab="", ylab="", type='l', lwd=1.5, cex.lab=1.2, bty="l", xlim=year.lim.f, ylim=c(0,max.f)))
  mtext(side=1,text="Year", line=2, cex=1.1)
  mtext(side=2,text=paste("F"," (",ts.units.df[,"f_unit"],")", sep=""), line=2, cex=1.1)
}
# reference points
if("f"%in%avail.series){
abline(h=c(ref.vals.df$flim,ref.vals.df$fmsy), lty=6)
x.coord<-with(ts.val.df[!is.na(ts.val.df$ssb),], min(tsyear, na.rm=TRUE))
flim.coord<-try(ref.vals.df$flim+0.1*ref.vals.df$flim, silent=TRUE)
fmsy.coord<-try(ref.vals.df$fmsy+0.1*ref.vals.df$fmsy, silent=TRUE)
try(text(x.coord+2, flim.coord, label="Flim"), silent=TRUE)
try(text(x.coord+2, fmsy.coord, label="Fmsy"), silent=TRUE)
}

# none
if(!"catch_landings"%in%avail.series & !"cpue"%in% avail.series & !"f"%in% avail.series){
plot(1, type="n", axes=FALSE,xlab="", ylab="")
legend("center", legend="No exploitation \n data available", bty="n", cex=1.1)
}

# sr plot
if("r"%in%avail.series& "ssb"%in%avail.series){
max.r<-max(ts.val.df$r[!is.na(ts.val.df$r)])
max.ssb<-max(ts.val.df$s[!is.na(ts.val.df$s)])
}

if("r"%in%avail.series& "ssb"%in%avail.series){ 
  par(mar=c(3,3,3,2))
  with(ts.val.df, plot(ssb, r, xlab="", ylab="", pch=21, bg=grey(.7), cex.lab=1.2, bty="l", xlim=c(0, max.ssb), ylim=c(0,max.r)))
  mtext(side=1,text=paste("SSB"," (",ts.units.df$ssb_unit,")", sep=""), line=2, cex=1.1)
  mtext(side=2,text=paste("Recruits"," (",ts.units.df$r_unit,")", sep=""), line=2, cex=1.1)
}
if(!"r"%in%avail.series| !"ssb"%in%avail.series){
plot(1, type="n", axes=FALSE,xlab="", ylab="")
legend("center", legend="No SSB-recruit \n data available", bty="n", cex=1.1)
}
dev.off()
