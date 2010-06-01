# fit Ricker recruitment with gamma error term
# C.Minto, code modified from N.Barrowman
# date: Mon Sep 22 14:56:48 ADT 2008
# Time-stamp: <2008-10-16 11:23:41 (mintoc)>

srfrk <- function(alpha,beta,S) {
# Stock Recruitment Function: Ricker
  return(alpha*S*exp(-(beta*S)))
}

srfrkpv <- function(pv,S) {
# Stock Recruitment Function (parameter vector version): Ricker
  return(srfrk(pv[1],pv[2],S))
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

ml.rkgam <- function(s,r,ip,nu=0.5,max.iter=200) {
  # s is adult spawning stock biomass
  # r is recruits (units vary)
  # ip are initial parameter estimates
  
  choice <- !is.na(r) & !is.na(s)
  r <- r[choice]
  s <- s[choice]
  assign(".Stock",s)       # Store in expression frame
  assign(".Recruit",r)     # Store in expression frame
  assign(".Evaluations",0) # Store in expression frame 
  ip <- c(ip,nu)
  logip <- log(ip)

  rk.nll <- function(x) {
    assign(".Evaluations",.Evaluations+1) # store in expression frame
    pv <- exp(x[1:2])
    nu <- exp(x[3])
    fitted <- srfrkpv(pv,.Stock)
    return(gamnegloglik(fitted,.Recruit,nu))
  }          
             
  # nlmin.out <- nlmin(rk.nll,logip,max.fcal=max.fcal,max.iter=max.iter)
  nlmin.out <- optim(par=logip, fn=rk.nll,control=list(maxiter=max.iter), hessian=TRUE)
             
  alpha <- exp(nlmin.out$par[1])
  beta <- exp(nlmin.out$par[2])
  nu <- exp(nlmin.out$par[3])
             
  fitted <- srfrkpv(c(alpha,beta),.Stock)
  nll <- gamnegloglik(fitted,.Recruit,nu)
  se<-sqrt(diag(solve(nlmin.out$hessian)))
  return(list(pv=c(alpha,beta),se=se,nu=nu,nll=nll,
    evaluations=.Evaluations,
    converged=nlmin.out$converged,conv.type=nlmin.out$conv.type, fitted=fitted))
}
