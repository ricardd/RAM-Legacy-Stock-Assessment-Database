# fit Beverton-Holt recruitment with gamma error term
# C.Minto, code modified from N.Barrowman
# date: Mon Sep 22 16:30:07 ADT 2008
# Time-stamp: <2008-10-16 11:26:33 (mintoc)>

srfbh <- function(a,K,S) {
# Stock recruitment function: Beverton-Holt
  return(a*S/(S/K + 1))  
}

srfbhpv <- function(pv,S) {
# Stock recruitment function (parameter vector version): Beverton-Holt
  return(srfbh(pv[1],pv[2],S))
}

gamnegloglik <- function(fitted,observed,nu) {
#   Gamma [gam] negative [neg] log likelihood [lik]
#   Arguments:
#   fitted   : fitted mean recruitment (assumed to be free of missing values)
#   observed : observed recruitment (assumed to be free of missing values)
#   nu       : gamma shape parameter
  len <- length(observed)
  result <- len*lgamma(nu) + nu*sum(log(fitted/(nu*observed))) + nu*sum(observed/fitted) + sum(log(observed))
  return(result)
}

ml.bhgam <- function(s,r,ip,nu=0.5,max.iter=200) {
 
  choice <- !is.na(r) & !is.na(s)
  r <- r[choice]
  s <- s[choice]
  assign(".Stock",s)       # Store in expression frame
  assign(".Recruit",r)     # Store in expression frame
  assign(".Evaluations",0) # Store in expression frame 
  ip <- c(ip,nu)
  logip <- log(ip)

  bh.nll <- function(x) {
    assign(".Evaluations",.Evaluations+1) # store in expression frame
    pv <- exp(x[1:2])
    nu <- exp(x[3])
    fitted <- srfbhpv(pv,.Stock)
    return(gamnegloglik(fitted,.Recruit,nu))
  }          
  nlmin.out <- optim(par=logip, fn=bh.nll,control=list(maxiter=max.iter), hessian=TRUE)
               
  alpha <- exp(nlmin.out$par[1])
  K <- exp(nlmin.out$par[2])
  nu <- exp(nlmin.out$par[3])
             
  fitted <- srfbhpv(c(alpha,K),.Stock)
  nll <- gamnegloglik(fitted,.Recruit,nu)
  se<-sqrt(diag(solve(nlmin.out$hessian)))
  return(list(pv=c(alpha,K),se=se,nu=nu,nll=nll,
    evaluations=.Evaluations,
    converged=nlmin.out$convergence, fitted=fitted))
}            
