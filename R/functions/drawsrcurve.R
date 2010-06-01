drawsrcurve <- function(ssb,pv,fun,log=FALSE,lty=1,lwd=1,n=100,scaleS=1,scaleR=1,xlim){
#   Draw a stock-recruitment curve.
#   Arguments:
#   ssb    : a spawning stock biomass vector.
#   pv     : a parameter vector
#   fun    : a stock-recruitment function (parameter vector version)
#   scaleS : scale to apply to the spawner quantity
#   scaleR : scale to apply to the recruitment
  s <- ssb[!is.na(ssb)]
  bot <- 0
  top <- max(s)
  if (log) {
    if (bot <= 0) bot <- 0.0001      # A small value
    logbot <- log10(bot)
    logtop <- log10(top)
    logvec <- seq(logbot, logtop, length = n)
    sran <- 10^logvec
  } else {   
    if (missing(xlim)) {
      sran <- seq(bot, top, length = n)
    } else { 
      sran <- seq(xlim[1],xlim[2],length=n)
    }        
  }          
  r <- fun(pv,sran)
  lines(sran*scaleS,r*scaleR,lty=lty,lwd=lwd)
} 
