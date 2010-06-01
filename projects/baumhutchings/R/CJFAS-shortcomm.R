# R code associated with CJFAS short communication (Hutching, Minto, Ricard and Baum)
# DR CM Started 2010-01-12
# Last modified Time-stamp: <Last modified: 7 FEBRUARY 2010  (srdbadmin)>
#
# file "CJFAS-shortcomm-data.R" has the data loading and the model fitting steps

# how many stocks fulfill the criteria?
dim(par.estimates)[1]

## how many stocks have a negative pre-1992 slope (model without continuity constraint)?
dim(par.estimates[par.estimates$m.slope.before<0,])[1]
## of these, how many have a positive deltaslope (i.e.easing of rate of decline)
dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff>0,])[1]



## how many stocks have a negative pre-1992 slope (model with continuity constraint)?
dim(par.estimates[par.estimates$mcont.slope.before<0,])[1]


## gather the info in a data frame
table.compare.models <- data.frame(model.name=rep("blah",3), n.stocks.pre.negative=rep(0,3), n.stocks.delta.positive=rep(0,3), percent.delta.positive=rep(0,3), n.stocks.post.positive=rep(0,3),stringsAsFactors=FALSE)

n <- dim(par.estimates[par.estimates$m.slope.before<0,])[1]
nn <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff>0,])[1]
nnn <- round(100*nn/n,2)
nnnn <- dim(par.estimates[par.estimates$m.slope.after>0 & par.estimates$m.slope.before<0,])[1]
table.compare.models[1,] <- c("No continuity constraint",n,nn,nnn,nnnn)

dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='NWAtl' & par.estimates$m.diff>0,])[1]/dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='NWAtl',])[1]

dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.slope.after<0 & par.estimates$geo=='NWAtl' & par.estimates$m.diff>0,])[1]/dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='NWAtl',])[1]


dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='NEAtl' & par.estimates$m.diff>0,])[1]/dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='NEAtl',])[1]

dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='NorthMidAtl' & par.estimates$m.diff>0,])[1]/dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='NorthMidAtl',])[1]

dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='NEPac' & par.estimates$m.diff>0,])[1]/dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='NEPac',])[1]

dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='Aust-NZ' & par.estimates$m.diff>0,])[1]/dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='Aust-NZ',])[1]


dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='SAfr' & par.estimates$m.diff>0,])[1]/dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='SAfr',])[1]



table.results <- data.frame(region=rep('blah',7), n.stocks.pre.negative=rep(-99,7), n.stocks.diff.positive=rep(-99,7), n.stocks.post.negative=rep(-99,7), n.stocks.diff.negative=rep(-99,7), stringsAsFactors=FALSE)

n.pre.negative <- dim(par.estimates[par.estimates$m.slope.before<0,])[1]
n.diff.positive <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff>0,])[1]
n.post.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff>0 & par.estimates$m.slope.after<0,])[1]
n.diff.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff<0,])[1]

table.results[1,1] <- "All"
table.results[1,2] <- n.pre.negative
table.results[1,3] <- n.diff.positive
table.results[1,4] <- n.post.negative
table.results[1,5] <- n.diff.negative

n.pre.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='NWAtl',])[1]
n.diff.positive <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff>0 & par.estimates$geo=='NWAtl',])[1]
n.post.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff>0 & par.estimates$m.slope.after<0 & par.estimates$geo=='NWAtl',])[1]
n.diff.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff<0 & par.estimates$geo=='NWAtl',])[1]

table.results[2,1] <- "NWAtl"
table.results[2,2] <- n.pre.negative
table.results[2,3] <- n.diff.positive
table.results[2,4] <- n.post.negative
table.results[2,5] <- n.diff.negative

n.pre.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='NEAtl',])[1]
n.diff.positive <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff>0 & par.estimates$geo=='NEAtl',])[1]
n.post.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff>0 & par.estimates$m.slope.after<0 & par.estimates$geo=='NEAtl',])[1]
n.diff.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff<0 & par.estimates$geo=='NEAtl',])[1]

table.results[3,1] <- "NEAtl"
table.results[3,2] <- n.pre.negative
table.results[3,3] <- n.diff.positive
table.results[3,4] <- n.post.negative
table.results[3,5] <- n.diff.negative

n.pre.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='NorthMidAtl',])[1]
n.diff.positive <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff>0 & par.estimates$geo=='NorthMidAtl',])[1]
n.post.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff>0 & par.estimates$m.slope.after<0 & par.estimates$geo=='NorthMidAtl',])[1]
n.diff.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff<0 & par.estimates$geo=='NorthMidAtl',])[1]

table.results[4,1] <- "NorthMidAtl"
table.results[4,2] <- n.pre.negative
table.results[4,3] <- n.diff.positive
table.results[4,4] <- n.post.negative
table.results[4,5] <- n.diff.negative

n.pre.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='NEPac',])[1]
n.diff.positive <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff>0 & par.estimates$geo=='NEPac',])[1]
n.post.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff>0 & par.estimates$m.slope.after<0 & par.estimates$geo=='NEPac',])[1]
n.diff.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff<0 & par.estimates$geo=='NEPac',])[1]

table.results[5,1] <- "NEPac"
table.results[5,2] <- n.pre.negative
table.results[5,3] <- n.diff.positive
table.results[5,4] <- n.post.negative
table.results[5,5] <- n.diff.negative

n.pre.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='Aust-NZ',])[1]
n.diff.positive <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff>0 & par.estimates$geo=='Aust-NZ',])[1]
n.post.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff>0 & par.estimates$m.slope.after<0 & par.estimates$geo=='Aust-NZ',])[1]
n.diff.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff<0 & par.estimates$geo=='Aust-NZ',])[1]

table.results[6,1] <- "Aust-NZ"
table.results[6,2] <- n.pre.negative
table.results[6,3] <- n.diff.positive
table.results[6,4] <- n.post.negative
table.results[6,5] <- n.diff.negative

n.pre.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$geo=='SAfr',])[1]
n.diff.positive <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff>0 & par.estimates$geo=='SAfr',])[1]
n.post.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff>0 & par.estimates$m.slope.after<0 & par.estimates$geo=='SAfr',])[1]
n.diff.negative <- dim(par.estimates[par.estimates$m.slope.before<0 & par.estimates$m.diff<0 & par.estimates$geo=='SAfr',])[1]

table.results[7,1] <- "SAfr"
table.results[7,2] <- n.pre.negative
table.results[7,3] <- n.diff.positive
table.results[7,4] <- n.post.negative
table.results[7,5] <- n.diff.negative

cbind(table.results$region, table.results$n.stocks.post.negative, table.results$n.stocks.diff.positive)


n <- dim(par.estimates[par.estimates$mcont.slope.before<0,])[1]
nn <- dim(par.estimates[par.estimates$mcont.slope.before<0 & par.estimates$mcont.diff>0,])[1]
nnn <- round(100*nn/n,2)
nnnn <- dim(par.estimates[par.estimates$mcont.slope.after>0 & par.estimates$mcont.slope.before<0,])[1]
table.compare.models[2,] <- c("Continuity constraint",n,nn,nnn,nnnn)

## notice the NA removals below
n <- dim(par.estimates[par.estimates$mss.slope.before<0&!is.na(par.estimates$mss.slope.before),])[1]
nn <- dim(par.estimates[par.estimates$mss.slope.before<0 & par.estimates$mss.slope.diff>0&!is.na(par.estimates$mss.slope.before)&!is.na(par.estimates$mss.slope.diff),])[1]
nnn <- round(100*nn/n,2)
nnnn <- dim(par.estimates[par.estimates$mss.slope.after>0 & par.estimates$mss.slope.before<0,])[1]

table.compare.models[3,] <- c("Kalman filter",n,nn,nnn,nnnn)

(table.compare.models)

