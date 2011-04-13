## function to perform multi-stock trend analyses

##function to return the mixed effects index
get.mixed.index<-function(metric, region, category, min.year=1970, brp=TRUE){
## argument specified
# metric - biomass or exploitation
# region - geographic
# category - taxonomic
# min.year
# brp - logical, FALSE means scaled to the mean, TRUE means ratio relative to MSY value
## the data frames from "RSC-data.R" are used here
  
## case 1, SSB/SSBmsy
  if(brp & metric=="biomass") {fct.dat <- brp.ratios.ssb}
  
## case 2, SSB/meanSSB
  if(!brp & metric=="biomass") {
    fct.dat <- ts.ssb
    assessids<-unique(fct.dat$assessid)
    scale.logmean<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
      return(c(as.character(assessids[x]),mean(log(fct.dat$ssb[fct.dat$assessid==assessids[x]]), na.rm=TRUE)))
    })), stringsAsFactors=FALSE)
    scale.logmean[,2]<-as.numeric(scale.logmean[,2])
    fct.dat$response<-sapply(seq(1, length(fct.dat$ssb)), function(x){
      log(fct.dat$ssb[x])- scale.logmean[scale.logmean[,1]==fct.dat$assessid[x],2]})
  }
  
## case 3, F/Fmsy
  if(brp & metric=="exploitation") {fct.dat <- brp.ratios.f}
  
## case 4, F/meanF
  if(!brp & metric=="exploitation") {fct.dat <- ts.f}

  
  ## take the appropriate data subset based on the region and the taxonomic category
  if(region=="All" & category=="All"){
    my.dat<-subset(fct.dat, tsyear>=min.year)
  }else{
    if(region=="All"& category=="Pelagic"){
      my.dat<-subset(fct.dat, taxocategory==category & tsyear>=min.year)
    }else{
      if(region=="All"& category!="Pelagic"){
        my.dat<-subset(fct.dat, taxocategory!="Pelagic" & tsyear>=min.year)
      }else{
        if(region!="All"& category=="Pelagic"){
          my.dat<-subset(fct.dat,geo==region & taxocategory==category & tsyear>=min.year)
        }else{
          if(region!="All"& category!="Pelagic"){
            my.dat<-subset(fct.dat,geo==region & taxocategory!="Pelagic" & tsyear>=min.year)
          }
        }
      }
    }
  }
  
## my.dat now has the appropriate data for going ahead with model fitting

      mixed.fit<-lme(response~-1+as.factor(tsyear), data=t[t$tsyear%in%years,], random=~1|assessid,  correlation = corCAR1(form = ~tsyear), na.action=na.omit)
 
  
} ## end function "get.mixed.index"

plot.poly.base.func<-function(region, category, ylim, xlim=c(1970,2010), yaxt="n", xaxt="n", brp=TRUE){
}
