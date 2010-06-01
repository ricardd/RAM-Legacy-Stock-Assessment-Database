## functions required by CJFAS-shortcomm-fig2.R
## CM
## date: Mon May 24 13:46:40 IST 2010
## Time-stamp: <2010-05-31 15:19:17 (srdbadmin)>


##------------------
## Model fitting
##------------------
## function to return the mixed effects index

get.mixed.index<-function(region, category, min.year=1970, brp=TRUE){
  ## returns year and estimated fixed effects index
  ## category is 'Pelagic' all else gets lumped as demersals
  ## all.stocks.present is turned on if we want to analyze only years for which all stocks are present
  ## if 'brp' TRUE analyse ssb/ssbmsy and tb/tbmsy trends, else analyse ssb trends
  if(brp){
    dat<-brp.ratio.dat2
  }else{
    dat<-ts.dat2
  }
  ##
  if(region=="All" & category=="All"){
    t<-subset(dat, tsyear>=min.year)
  }else{
    if(region=="All"& category=="Pelagic"){
      t<-subset(dat, taxocategory==category & tsyear>=min.year)
    }else{
      if(region=="All"& category!="Pelagic"){
        t<-subset(dat, taxocategory!="Pelagic" & tsyear>=min.year)
      }else{
        if(region!="All"& category=="Pelagic"){
          t<-subset(dat,geo==region & taxocategory==category & tsyear>=min.year)
        }else{
          if(region!="All"& category!="Pelagic"){
            t<-subset(dat,geo==region & taxocategory!="Pelagic" & tsyear>=min.year)
          }
        }
      }
    }
  }
  ## make sure no NA's in t and only one series per stock
  if(brp){
    ## for stock with two ratios - pick SSB preferentially (make TB values NA's)
    brp.assessid<-unique(t$assessid)
    n.ratios<-as.numeric(unlist(lapply(sapply(brp.assessid, function(x){unique(t$tsid[t$assessid==x])}),length)))
    for(i in brp.assessid[n.ratios>1]){
      ##print(i)
      t$lnratio[t$tsid=="TB" & t$assessid==i]<-NA
    }
    t<-t[!is.na(t$lnratio),]
  }else{
    t<-t[!is.na(t$ssb),]
  } 
  ##if(length(t[,1])<1){stop("No data in this region-category combination")}
  if(length(t[,1])<1){return(c("No data in this region-category combination"))}else{
  ##stocks<-unique(t$stockid)
  assessids<-unique(t$assessid)
  ## SCALING
  ## mean on log scale values
  if(!brp){
    scale.logmean<- data.frame(t(sapply(seq(1,length(assessids)), function(x){
      return(c(as.character(assessids[x]),mean(log(t$ssb[t$assessid==assessids[x]]), na.rm=TRUE)))
    })), stringsAsFactors=FALSE)
    scale.logmean[,2]<-as.numeric(scale.logmean[,2])
    t$logssb.mean.scaled<-sapply(seq(1, length(t$ssb)), function(x){
      log(t$ssb[x])- scale.logmean[scale.logmean[,1]==t$assessid[x],2]})
  }
  ## following only if 'all.stocks.present' included in function arguments
  ## only includes stocks where 1970 present
  ##   if(all.stocks.present){
  ##     ## which years are fully present
  ##     years1<-unique(t$tsyear)[order(unique(t$tsyear))]
  ##     num.assess.by.year<-sapply(seq(1, length(years1)), function(x){length(t$assessid[t$tsyear==years1[x]&!is.na(t$ssb)])})
  ##     n.total.assess<-length(unique(t$assessid))
  ##     years.index <-as.logical(ifelse(num.assess.by.year==n.total.assess,1,0))
  ##     years<-years1[years.index]
  ##   }else{
  years<-unique(t$tsyear)[order(unique(t$tsyear))]
  ##}
  ## FITS
  if(length(assessids)>=2){
    ## ar1 fit
    if(brp){
      mixed.fit<-lme(lnratio~-1+as.factor(tsyear), data=t[t$tsyear%in%years,], random=~1|assessid,  correlation = corCAR1(form = ~tsyear), na.action=na.omit)
    }else{
      mixed.fit<-lme(logssb.mean.scaled~-1+as.factor(tsyear), data=t[t$tsyear%in%years,], random=~1|assessid,  correlation = corCAR1(form = ~tsyear), na.action=na.omit)
    }
    ## conversion to antilog scale for percentage changes
    var.random.effects<-as.numeric(getVarCov(mixed.fit))
    var.residuals<-mixed.fit$sigma
    ## Coilin to check this: currently give two antilog indices, with and without the bias correction, looks correct
    antilog.index<-exp(fixef(mixed.fit))    
    antilog.index.1<-exp(fixef(mixed.fit)+(var.random.effects+var.residuals)/2) ## see supp. info. for Worm et al (2009)
  }
      if(length(assessids)>=2){
        upr<-fixef(mixed.fit)+1.96*sqrt(diag(summary(mixed.fit)$varFix))
        lwr<-fixef(mixed.fit)-1.96*sqrt(diag(summary(mixed.fit)$varFix))
        return(data.frame(years, region, category, n=length(assessids), index=fixef(mixed.fit), upr=upr,lwr=lwr, antilog.index, antilog.index.1))
      }else{
        if(length(assessids)==1){
          if(brp){
            return(data.frame(years=t$tsyear[order(t$tsyear)], region, category, n=length(assessids), index=t$lnratio[order(t$tsyear)], upr=NA,lwr=NA, antilog.index=t$ratio[order(t$tsyear)], antilog.index.1=NA))
          }else{
            return(data.frame(years=t$tsyear[order(t$tsyear)], region, category, n=length(assessids), index=t$logssb.mean.scaled[order(t$tsyear)], upr=NA,lwr=NA, antilog.index=exp(t$logssb.mean.scaled[order(t$tsyear)]), antilog.index.1=NA))
          }
        }
      }
}
}

##-------------------
## Plotting routines
##-------------------

## set up the plotting area for a region
plot.poly.base.func<-function(region, category, ylim, xlim=c(1970,2010), yaxt="n", xaxt="n", brp=TRUE){
  plot(NA, xlim=xlim, ylim=ylim, xlab="", ylab="", xaxt=xaxt, yaxt="n", cex.axis=1.2)
  if(yaxt=="s"){axis(side=2,at=pretty(ylim),cex.axis=1.2)}
  if(region=="All" & category=="All"){
    if(brp){
      mixed.model<-brp.all.mixed.list
    }else{
      mixed.model<-orig.all.mixed.list
    }
    n<-try(unique(mixed.model[["All"]]$n), silent=TRUE)
  }else{
    if(region=="All" & category=="Both"){
    if(brp){      
      pel.n<-try(unique(brp.all.mixed.list[["Pelagic"]]$n), silent=TRUE)
      dem.n<-try(unique(brp.all.mixed.list[["Demersal"]]$n), silent=TRUE)
    }else{
      pel.n<-try(unique(orig.all.mixed.list[["Pelagic"]]$n), silent=TRUE)
      dem.n<-try(unique(orig.all.mixed.list[["Demersal"]]$n), silent=TRUE)
    }      
    }else{
      if(brp){
        pel.n<-try(unique(brp.pelagic.mixed.list[[region]]$n), silent=TRUE)
        dem.n<-try(unique(brp.demersal.mixed.list[[region]]$n), silent=TRUE)
      }else{
        pel.n<-try(unique(orig.pelagic.mixed.list[[region]]$n), silent=TRUE)
        dem.n<-try(unique(orig.demersal.mixed.list[[region]]$n), silent=TRUE)
      }
    }
  }
  if(region=="All" & category=="All"){
    legend("topright", legend=paste("N=", n, sep=""), col=c("#7570B3"), lty=c(1,1) ,lwd=1.5, bty="n")
  }else{
    legend("topright", legend=c(paste("N=", ifelse(is.numeric(pel.n), pel.n,0), sep=""), paste("N=", ifelse(is.numeric(dem.n), dem.n,0), sep="")), col=c("#D95F02","#1B9E77"), lty=c(1,1) ,lwd=1.5, bty="n")
  }
  legend.text<-if(region=="All" & category=="All"){"(a)"}else{
      if(region=="All" & category=="Both"){"(b)"}else{
        if(region=="NWAtl"){"(c)"}else{
          if(region=="NEAtl"){"(d)"}else{
            if(region=="NorthMidAtl"){"(e)"}else{
              if(region=="NEPac"){"(f)"}else{
                if(region=="Aust-NZ"){"(g)"}else{
                  if(region=="HighSeas"){"(h)"}
                }
              }
            }
          }
        }
      }
    }
  par(font=2)
  ##legend("topleft", legend=legend.text, bty="n", cex=1.3, inset=-0.05, adj=c(1,0))
  legend("topleft", legend=legend.text, bty="n", cex=1.2, inset=0.05, adj=c(2,0))
  par(font=1)
}


plot.poly.trend.func<-function(region, category, ylim,brp=TRUE){
  if(region=="All" & category=="All"){
    ## All stocks combined
    if(brp){
      try(with(brp.all.mixed.list[["All"]], lines(years, antilog.index, col="#7570B3", lwd=1.2)), silent=TRUE)
      try(with(brp.all.mixed.list[["All"]], polygon(c(years,rev(years)),exp(c(lwr,rev(upr))),col="#7570B340", border=NA)), silent=TRUE)
      ##axis(side=2,at=pretty(ylim),cex.axis=1.2)
    }else{
      try(with(orig.all.mixed.list[["All"]], lines(years, index, col="#7570B3", lwd=1.2)), silent=TRUE)
      try(with(orig.all.mixed.list[["All"]], polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#7570B340", border=NA)), silent=TRUE)
    }
    axis(side=2,at=c(0,1,2),cex.axis=1.2)
  }else{
    if(region=="All" & category=="Both"){
      if(brp){
         ## All Pelagic
         try(with(brp.all.mixed.list[["Pelagic"]], polygon(c(years,rev(years)),exp(c(lwr,rev(upr))),col="#D95F0240", border=NA)), silent=TRUE)
         try(with(brp.all.mixed.list[["Pelagic"]], lines(years, antilog.index, type="l", lwd=1.2, col="#D95F02")), silent=TRUE)
         ## All Demersal
         try(with(brp.all.mixed.list[["Demersal"]], polygon(c(years,rev(years)),exp(c(lwr,rev(upr))),col="#1B9E7740", border=NA)), silent=TRUE)
         try(with(brp.all.mixed.list[["Demersal"]], lines(years, antilog.index, lwd=1.2,col="#1B9E77")), silent=TRUE)
       }else{
         ## All Pelagic
         try(with(orig.all.mixed.list[["Pelagic"]], polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#D95F0240", border=NA)), silent=TRUE)
         try(with(orig.all.mixed.list[["Pelagic"]], lines(years, index, type="l", lwd=1.2, col="#D95F02")), silent=TRUE)
         ## All Demersal
         try(with(orig.all.mixed.list[["Demersal"]], polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#1B9E7740", border=NA)), silent=TRUE)
         try(with(orig.all.mixed.list[["Demersal"]], lines(years, index, lwd=1.2,col="#1B9E77")), silent=TRUE)
       }
    }else{
      if(region!="All" & category=="Pelagic"){
        if(brp){
          if(unique(brp.pelagic.mixed.list[[region]]$n)>1){
            try(with(brp.pelagic.mixed.list[[region]], polygon(c(years,rev(years)),exp(c(lwr,rev(upr))),col="#D95F0240", border=NA)), silent=TRUE)
            try(with(brp.pelagic.mixed.list[[region]], lines(years,antilog.index,col="#D95F02", lty=1, lwd=1.2)), silent=TRUE)
          }
        }else{
          if(unique(orig.pelagic.mixed.list[[region]]$n)>1){
            try(with(orig.pelagic.mixed.list[[region]], polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#D95F0240", border=NA)), silent=TRUE)
            try(with(orig.pelagic.mixed.list[[region]], lines(years,index,col="#D95F02", lty=1, lwd=1.2)), silent=TRUE)
          }
        }
      }else{
        if(region!="All" & category=="Demersal"){
          if(brp){
            if(unique(brp.demersal.mixed.list[[region]]$n)>1){
              try(with(brp.demersal.mixed.list[[region]], polygon(c(years,rev(years)),exp(c(lwr,rev(upr))),col="#1B9E7740", border=NA)), silent=TRUE)
              try(with(brp.demersal.mixed.list[[region]], lines(years,antilog.index,col="#1B9E77", lwd=1.2)), silent=TRUE)
            }
          }else{
            if(unique(orig.demersal.mixed.list[[region]]$n)>1){
              try(with(orig.demersal.mixed.list[[region]], polygon(c(years,rev(years)),c(lwr,rev(upr)),col="#1B9E7740", border=NA)), silent=TRUE)
              try(with(orig.demersal.mixed.list[[region]], lines(years,index,col="#1B9E77", lwd=1.2)), silent=TRUE)
            }
          }
        }
      }
    }
  }
}


##-------------------------------
## Summary statistics extraction
##-------------------------------

extract.percentage.change<-function(region, category, n.years, brp=TRUE){
  ## n.years is the number of years at the start and end
  ## from which to extract the percentage change
  ## brp logical to use ratio of biomass/reference_biomass or original method
  if(region=="All" & category=="All"){
    if(brp){
      dat.df<-brp.all.mixed.list[["All"]]
    }else{
      dat.df<-orig.all.mixed.list[["All"]]
    }
  }else{
    if(region=="All" & category=="Pelagic"){
      if(brp){
        dat.df<-brp.all.mixed.list[["Pelagic"]]
      }else{
        dat.df<-orig.all.mixed.list[["Pelagic"]]
      }
    }else{
      if(region=="All" & category=="Demersal"){
        if(brp){
          dat.df<-brp.all.mixed.list[["Demersal"]]
        }else{
          dat.df<-orig.all.mixed.list[["Demersal"]]
        }
      }else{
        if(region!="All" & category=="Pelagic"){
          if(brp){
            dat.df<-brp.pelagic.mixed.list[[region]]
          }else{
            dat.df<-orig.pelagic.mixed.list[[region]]
          }
        }else{
          if(region!="All" & category=="Demersal"){
            if(brp){
              dat.df<-brp.demersal.mixed.list[[region]]
            }else{
              dat.df<-orig.demersal.mixed.list[[region]]
            }
          }
        }
      }
    }
  }
  ## make sure there are data from that combination
  if(!is.character(dat.df)){
    ## first and last 5 year indices
    start.index<-dat.df$antilog.index[dat.df$years%in%seq(1970,1970+n.years-1)]
    end.index<-dat.df$antilog.index[dat.df$years%in%seq(2007,2007-n.years+1)]
    ##
    start.mean<-mean(start.index)
    end.mean<-mean(end.index)
    ##
    percent.change<-round(100*(1-end.mean/start.mean),2)
    return(c(region, category, unique(dat.df$n), round(start.mean,2), round(end.mean,2), percent.change))}else{
      return(c(region, category, NA, NA, NA, NA))}
}
