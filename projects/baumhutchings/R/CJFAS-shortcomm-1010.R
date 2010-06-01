# R code associated with CJFAS short communication (Hutching, Minto, Ricard and Baum)
# DR CM Started 2010-01-12
# Last modified Time-stamp: <Last modified: 26 FEBRUARY 2010  (srdbadmin)>
#
# file "CJFAS-shortcomm-data.R" has the data loading and the model fitting steps

# how many stocks fulfill the criteria?
dim(par.estimates.1010)[1]
## how many stocks have a negative pre-1992 slope (model without continuity constraint)?
dim(par.estimates.1010[par.estimates.1010$m.slope.before<0,])[1]
## of these, how many have a positive deltaslope (i.e.easing of rate of decline)
dim(par.estimates.1010[par.estimates.1010$m.slope.before<0 & par.estimates.1010$m.diff>0,])[1]
## how many stocks have a negative pre-1992 slope (model with continuity constraint)?
dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0,])[1]
## gather the info in a data frame

table.results.1010 <- data.frame(region=rep('blah',7), n.stocks.pre.negative=rep(-99,7), n.stocks.diff.positive=rep(-99,7), n.stocks.post.negative=rep(-99,7), n.stocks.diff.negative=rep(-99,7), stringsAsFactors=FALSE)

## notice the change to the mcont model here

n.pre.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0,])[1]
n.diff.positive <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff>0,])[1]
n.post.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff>0 & par.estimates.1010$mcont.slope.after<0,])[1]
n.diff.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff<0,])[1]

table.results.1010[1,1] <- "All"
table.results.1010[1,2] <- n.pre.negative
table.results.1010[1,3] <- n.diff.positive
table.results.1010[1,4] <- n.post.negative
table.results.1010[1,5] <- n.diff.negative

n.pre.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$geo=='NWAtl',])[1]
n.diff.positive <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff>0 & par.estimates.1010$geo=='NWAtl',])[1]
n.post.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff>0 & par.estimates.1010$mcont.slope.after<0 & par.estimates.1010$geo=='NWAtl',])[1]
n.diff.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff<0 & par.estimates.1010$geo=='NWAtl',])[1]

table.results.1010[2,1] <- "NWAtl"
table.results.1010[2,2] <- n.pre.negative
table.results.1010[2,3] <- n.diff.positive
table.results.1010[2,4] <- n.post.negative
table.results.1010[2,5] <- n.diff.negative

n.pre.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$geo=='NEAtl',])[1]
n.diff.positive <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff>0 & par.estimates.1010$geo=='NEAtl',])[1]
n.post.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff>0 & par.estimates.1010$mcont.slope.after<0 & par.estimates.1010$geo=='NEAtl',])[1]
n.diff.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff<0 & par.estimates.1010$geo=='NEAtl',])[1]

table.results.1010[3,1] <- "NEAtl"
table.results.1010[3,2] <- n.pre.negative
table.results.1010[3,3] <- n.diff.positive
table.results.1010[3,4] <- n.post.negative
table.results.1010[3,5] <- n.diff.negative

n.pre.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$geo=='NorthMidAtl',])[1]
n.diff.positive <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff>0 & par.estimates.1010$geo=='NorthMidAtl',])[1]
n.post.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff>0 & par.estimates.1010$mcont.slope.after<0 & par.estimates.1010$geo=='NorthMidAtl',])[1]
n.diff.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff<0 & par.estimates.1010$geo=='NorthMidAtl',])[1]

table.results.1010[4,1] <- "NorthMidAtl"
table.results.1010[4,2] <- n.pre.negative
table.results.1010[4,3] <- n.diff.positive
table.results.1010[4,4] <- n.post.negative
table.results.1010[4,5] <- n.diff.negative

n.pre.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$geo=='NEPac',])[1]
n.diff.positive <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff>0 & par.estimates.1010$geo=='NEPac',])[1]
n.post.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff>0 & par.estimates.1010$mcont.slope.after<0 & par.estimates.1010$geo=='NEPac',])[1]
n.diff.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff<0 & par.estimates.1010$geo=='NEPac',])[1]

table.results.1010[5,1] <- "NEPac"
table.results.1010[5,2] <- n.pre.negative
table.results.1010[5,3] <- n.diff.positive
table.results.1010[5,4] <- n.post.negative
table.results.1010[5,5] <- n.diff.negative

n.pre.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$geo=='Aust-NZ',])[1]
n.diff.positive <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff>0 & par.estimates.1010$geo=='Aust-NZ',])[1]
n.post.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff>0 & par.estimates.1010$mcont.slope.after<0 & par.estimates.1010$geo=='Aust-NZ',])[1]
n.diff.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff<0 & par.estimates.1010$geo=='Aust-NZ',])[1]

table.results.1010[6,1] <- "Aust-NZ"
table.results.1010[6,2] <- n.pre.negative
table.results.1010[6,3] <- n.diff.positive
table.results.1010[6,4] <- n.post.negative
table.results.1010[6,5] <- n.diff.negative

n.pre.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$geo=='HighSeas',])[1]
n.diff.positive <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff>0 & par.estimates.1010$geo=='HighSeas',])[1]
n.post.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff>0 & par.estimates.1010$mcont.slope.after<0 & par.estimates.1010$geo=='HighSeas',])[1]
n.diff.negative <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff<0 & par.estimates.1010$geo=='HighSeas',])[1]

table.results.1010[7,1] <- "HighSeas"
table.results.1010[7,2] <- n.pre.negative
table.results.1010[7,3] <- n.diff.positive
table.results.1010[7,4] <- n.post.negative
table.results.1010[7,5] <- n.diff.negative

## for number of stocks with rate of decline eased but still declining
dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff>0&par.estimates.1010$mcont.slope.after<0,])


cbind(table.results.1010$region, table.results.1010$n.stocks.post.negative, table.results.1010$n.stocks.diff.positive)



table.compare.models.1010 <- data.frame(model.name=rep("blah",3), n.stocks.pre.negative=rep(0,3), n.stocks.delta.positive=rep(0,3), percent.delta.positive=rep(0,3), n.stocks.post.positive=rep(0,3),stringsAsFactors=FALSE)

n <- dim(par.estimates.1010[par.estimates.1010$m.slope.before<0,])[1]
nn <- dim(par.estimates.1010[par.estimates.1010$m.slope.before<0 & par.estimates.1010$m.diff>0,])[1]
nnn <- round(100*nn/n,2)
nnnn <- dim(par.estimates.1010[par.estimates.1010$m.slope.after>0 & par.estimates.1010$m.slope.before<0,])[1]
table.compare.models.1010[1,] <- c("No continuity constraint",n,nn,nnn,nnnn)

n <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0,])[1]
nn <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.before<0 & par.estimates.1010$mcont.diff>0,])[1]
nnn <- round(100*nn/n,2)
nnnn <- dim(par.estimates.1010[par.estimates.1010$mcont.slope.after>0 & par.estimates.1010$mcont.slope.before<0,])[1]
table.compare.models.1010[2,] <- c("Continuity constraint",n,nn,nnn,nnnn)

## notice the NA removals below
n <- dim(par.estimates.1010[par.estimates.1010$mss.slope.before<0&!is.na(par.estimates.1010$mss.slope.before),])[1]
nn <- dim(par.estimates.1010[par.estimates.1010$mss.slope.before<0 & par.estimates.1010$mss.slope.diff>0&!is.na(par.estimates.1010$mss.slope.before)&!is.na(par.estimates.1010$mss.slope.diff),])[1]
nnn <- round(100*nn/n,2)
nnnn <- dim(par.estimates.1010[par.estimates.1010$mss.slope.after>0 & par.estimates.1010$mss.slope.before<0,])[1]

table.compare.models.1010[3,] <- c("Kalman filter",n,nn,nnn,nnnn)

(table.compare.models.1010)

