# srview for srDB, first pass
# Started: 2008-07-22
#
# Time-stamp: <2008-10-17 15:12:16 (mintoc)>
#
# Modification history
# 2008-10-08: defining a function that accepts a stock name and the correct R, SSB and F series for plotting and model fitting
# 2008-10-15 18:33:14: ammendments to accept the output from all.metrics.list defined in srview-NCEAS-calls.R
# 2008-10-17 11:49:20 can output to pdf file

srview.fct <- function(assess.index, pdf=FALSE) {
  # needs libraries RODBC, MASS 
  # assess.index is the index of all.metrics.list
  # call is in /home/ricardd/linux_sync_folder/SQL/SQLpg/srDB/R/calls
  # note the generation of all.metrics.list for available variables
  # turn on pdf to output in that format
  assess.details<-all.metrics.list[assess.index]
  assess.id <- names(assess.details)
  print(assess.id)
  metric.names<-as.character(unlist(assess.details)) # for to run some boolean on
  #get the taxonomic details
  qu <- paste("select st.scientificname, st.commonname, st.areaID, st.stocklong from srdb.assessment aa, srdb.stock st where aa.stockid=st.stockid and assessid = '", assess.id, "'", sep="")
  details <- sqlQuery(chan, qu, errors= TRUE)
  #remove pre-defined variables
  options(warn=-1) # suppress remove warnings
  rm("tl.data", "ssb.data", "r.data", "f.data","tc.data","cpue.data","data.back", "f.ref","b.ref")
  rm("tl.bool", "ssb.bool", "r.bool", "f.bool","tc.bool", "cpue.bool","fref.bool", "bref.bool")
  rm("tl.label", "ssb.label", "r.label", "f.label","tc.label", "cpue.label")
  options(warn=0) # return any further warnings
  #boolean based queries
  ssb.bool <- sum(grep("SSB-[^S]",metric.names))>0 # [^S] for the STDEV ssb estimates
  r.bool <- sum(grep("R",metric.names))>0
  f.bool <- sum(grep("F",metric.names))>0
  tc.bool <- sum(grep("TC",metric.names))>0
  tl.bool <- sum(grep("TL",metric.names))>0
  cpue.bool<- sum(grep("CPUE",metric.names))>0
  
  # get the data, where it exists
  if(ssb.bool){
    ssb<-metric.names[grep("SSB-[^S]", metric.names)]
    qu <- paste("SELECT * from srdb.timeseries where assessid=",
                "'",assess.id,"' AND tsid=","'",ssb,"'", sep="")
    ssb.data <- sqlQuery(chan,qu)
    label.qu<-paste("SELECT distinct tsshort, tsunitslong, ts.tsid from (SELECT * from srdb.timeseries where assessid=","'",assess.id,"'", " AND tsid=","'",ssb,"')", " as ts, srdb.tsmetrics as met where ts.tsid=met.tsunique",sep="")
    ssb.label<-sqlQuery(chan,label.qu)
    assign("ssb.label", ssb.label, env = .GlobalEnv)
    # any biomass reference points available?
    bref.qu<-paste("SELECT pars.bioid, pars.biovalue from srdb.bioparams as pars, (select biounique from srdb.biometrics where subcategory='REFERENCE POINTS ETC.' AND biounique like 'B%') as ref where pars.assessid=","'",assess.id,"'", "and ref.biounique=pars.bioid", sep="")
    b.ref<-sqlQuery(chan,bref.qu, as.is=TRUE)
    assign("b.ref", b.ref,env=.GlobalEnv)
    bref.bool<-length(b.ref[,1])>0
    assign("bref.bool", bref.bool,env=.GlobalEnv)
  }
  if(cpue.bool){
    cpue<-metric.names[grep("CPUE", metric.names)]
    qu <- paste("SELECT * from srdb.timeseries where assessid=",
                "'",assess.id,"' AND tsid=","'",cpue,"'", sep="")
    cpue.data <- sqlQuery(chan,qu)
    if((sum(cpue.data$tsvalue, na.rm=TRUE)==0)){rm("cpue.data");cpue.bool=FALSE}
    label.qu<-paste("SELECT distinct tsshort, tsunitslong, ts.tsid from (SELECT * from srdb.timeseries where assessid=","'",assess.id,"'", " AND tsid=","'",cpue,"')", " as ts, srdb.tsmetrics as met where ts.tsid=met.tsunique",sep="")
    cpue.label<-sqlQuery(chan,label.qu)
    assign("cpue.label", cpue.label, env = .GlobalEnv)
  }
  if(r.bool){
    r<-metric.names[grep("R", metric.names)]
    qu <- paste("SELECT * from srdb.timeseries where assessid=",
                "'",assess.id,"' AND tsid=","'",r,"'", sep="")
    r.data <- sqlQuery(chan,qu)
    label.qu<-paste("SELECT distinct tsshort, tsunitslong, ts.tsid from (SELECT * from srdb.timeseries where assessid=","'",assess.id,"'", " AND tsid=","'",r,"')", " as ts, srdb.tsmetrics as met where ts.tsid=met.tsunique",sep="")
    r.label<-sqlQuery(chan,label.qu)
    assign("r.label", r.label, env = .GlobalEnv)
  }
  if(f.bool){
    f<-metric.names[grep("F", metric.names)]
    qu <- paste("SELECT * from srdb.timeseries where assessid=",
                "'",assess.id,"' AND tsid=","'",f,"'", sep="")
    f.data <- sqlQuery(chan,qu)
    label.qu<-paste("SELECT distinct tsshort, tsunitslong, ts.tsid from (SELECT * from srdb.timeseries where assessid=","'",assess.id,"'", " AND tsid=","'",f,"')", " as ts, srdb.tsmetrics as met where ts.tsid=met.tsunique",sep="")
    f.label<-sqlQuery(chan,label.qu, as.is=TRUE)
    assign("f.label", f.label, env = .GlobalEnv)
    # any F reference points available?
    fref.qu<-paste("SELECT pars.bioid, pars.biovalue from srdb.bioparams as pars, (select biounique from srdb.biometrics where subcategory='REFERENCE POINTS ETC.' AND biounique like 'F%') as ref where pars.assessid=","'",assess.id,"'", "and ref.biounique=pars.bioid", sep="")
    f.ref<-sqlQuery(chan,fref.qu, as.is=TRUE)
    assign("f.ref", f.ref,env=.GlobalEnv)
    fref.bool<-length(f.ref[,1])>0
    assign("fref.bool", fref.bool,env=.GlobalEnv)
  }
  if(tc.bool){
    tc<-metric.names[grep("TC", metric.names)]
    qu <- paste("SELECT * from srdb.timeseries where assessid=",
                "'",assess.id,"' AND tsid=","'",tc,"'", sep="")
    tc.data <- sqlQuery(chan,qu)
    label.qu<-paste("SELECT distinct tsshort, tsunitslong, ts.tsid from (SELECT * from srdb.timeseries where assessid=","'",assess.id,"'", " AND tsid=","'",tc,"')", " as ts, srdb.tsmetrics as met where ts.tsid=met.tsunique",sep="")
    tc.label<-sqlQuery(chan,label.qu)
    assign("tc.label", tc.label, env = .GlobalEnv)
  }
  if(tl.bool){
    tl<-metric.names[grep("TL", metric.names)]
    qu <- paste("SELECT * from srdb.timeseries where assessid=",
                "'",assess.id,"' AND tsid=","'",tl,"'", sep="")
    tl.data <- sqlQuery(chan,qu)
    label.qu<-paste("SELECT distinct tsshort, tsunitslong, ts.tsid from (SELECT * from srdb.timeseries where assessid=","'",assess.id,"'", " AND tsid=","'",tl,"')", " as ts, srdb.tsmetrics as met where ts.tsid=met.tsunique",sep="")
    tl.label<-sqlQuery(chan,label.qu)
    assign("tl.label", tl.label, env = .GlobalEnv)
  }

  YR<-if(ssb.bool){ssb.data$tsyear}else{if(r.bool){r.data$tsyear}else{if(f.bool){f.data$tsyear}else{if(tc.bool){tc.data$tsyear}else{if(tl.bool){tl.data$tsyear}else{NULL}}}}}
  # create the dataframe
  data.back <- data.frame(ID=assess.id, YR=YR, SSB=if(ssb.bool){ssb.data$tsvalue}else{NA}, R=if(r.bool){r.data$tsvalue}else{NA}, F=if(f.bool){f.data$tsvalue}else{NA},TC=if(tc.bool){tc.data$tsvalue}else{NA},TL=if(tl.bool){tl.data$tsvalue}else{NA}, CPUE=if(cpue.bool){cpue.data$tsvalue}else{NA})
  
  # plot the data
  # functions are in /home/ricardd/linux_sync_folder/SQL/SQLpg/srDB/R/functions
  if(pdf){
    # write to table what pdf available for report
    sqlSave(chan, data.frame(assessid=assess.id,pdf=paste(assess.id,".pdf", sep="")), tablename = "nceasplots", append=TRUE)
    
    pdf(paste("/home/ricardd/linux_sync_folder/SQL/SQLpg/srDB/R/figures/",assess.id,".pdf", sep=""), width=10, height=10)
  }
  par(mfrow=c(2,2), mar=c(3,3,3,3), oma=c(2,1,1,0))
  # time series plot
  timeseries.plot(ssb.bool=ssb.bool,f.bool=f.bool,cpue.bool=cpue.bool, dat=data.back)
  par(font=2);mtext(side=3, text="Time series", cex=1.2, line=.5);par(font=1)
  # stock-recruitment plot
  stockrecruitment.plot(ssb.bool=ssb.bool,r.bool=r.bool, dat=data.back)
  par(font=2);mtext(side=3, text="Stock-recruit", cex=1.2, line=.5);par(font=1)
  # phase-plane plot
  F.vs.SSB(ssb.bool=ssb.bool,f.bool=f.bool,lwd=2,arrow.len=.1, dat=data.back)
  par(font=2);mtext(side=3, text="SSB-F", cex=1.2, line=.5);par(font=1)
  # catches
  catches.plot(tl.bool=tl.bool,tc.bool=tc.bool, dat=data.back)
  par(font=2);mtext(side=3, text="Catch/landings", cex=1.2, line=.5);par(font=1)

  #text in margins
  
  plot.title<-bquote(italic(.(as.character(details$scientificname))):~.(as.character(details$stocklong)))
  mtext(plot.title, side=3, outer=TRUE, line=-1, cex=1.1)
  mtext(assess.id, side=1, outer=TRUE, line=.3, cex=0.8)
  if(pdf){dev.off()}

# need to work on this
# gather parameter estimates, LL and AIC
#l1 <- paste("","LL","AIC",sep="\t")
#l2 <- paste("Ricker", round(logLik(Ricker.model), 3), round(AIC(Ricker.model),3),sep="\t")
#l3 <- paste("Beverton-Holt", round(logLik(BH.model),3),round(AIC(BH.model),3),sep="\t")
#plot(1,type='n',xlab="",ylab="",axes=FALSE,xlim=c(0,2),ylim=c(0,2))
#ll <- c(l1,l2,l3)
#legend(0.5, 0.5, bty='n',legend=ll)

# return(data.back)
} # end function srview.fct
