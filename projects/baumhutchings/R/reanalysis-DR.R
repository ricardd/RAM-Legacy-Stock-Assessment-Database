# reanalysis.R
# a first pass at redoing analyses from Baum and Hutchings Proceedings of the Royal Society paper
# Daniel Ricard
# Last modified Time-stamp: <2009-08-18 10:46:45 (ricardd)>
# Modification history:
#
require(RODBC)
require(lattice)

# simulated data
cutoff <- 1992
pre.yrs <- seq(1950,cutoff)
post.yrs <- seq(cutoff+1,2009)
yrs <- c(pre.yrs, post.yrs)
pre.1 <- -0.05
post.1 <- -0.05
pre.2 <- 0.01
post.2 <- 0.01
pre.3 <- -0.05
post.3 <- 0.1
pre.4 <- -0.05
post.4 <- 0
pre.5 <- 0
post.5 <- 0
b0 <- 1E06

my.pre.sim.data <- data.frame(yrs=pre.yrs,
                              sim1 = (log(b0) + (pre.1*(pre.yrs-min(pre.yrs)))),
                              sim2 = (log(b0) + (pre.2*(pre.yrs-min(pre.yrs)))),
                              sim3 = (log(b0) + (pre.3*(pre.yrs-min(pre.yrs)))),
                              sim4 = (log(b0) + (pre.4*(pre.yrs-min(pre.yrs)))),
                              sim5 = (log(b0) + (pre.5*(pre.yrs-min(pre.yrs))))
                              )

last <- length(my.pre.sim.data$sim1)

my.post.sim.data <- data.frame(yrs=post.yrs,
                              sim1 = (my.pre.sim.data$sim1[last] + (post.1*(post.yrs-cutoff))),
                              sim2 = (my.pre.sim.data$sim2[last] + (post.2*(post.yrs-cutoff))),
                              sim3 = (my.pre.sim.data$sim3[last] + (post.3*(post.yrs-cutoff))),
                              sim4 = (my.pre.sim.data$sim4[last] + (post.4*(post.yrs-cutoff))),
                              sim5 = (my.pre.sim.data$sim5[last] + (post.5*(post.yrs-cutoff)))
                              )

my.sim.data <- rbind(my.pre.sim.data,my.post.sim.data)
my.sim.data$post <- floor(yrs/(cutoff+1))
my.sim.data$yr <- my.sim.data$yrs - min(my.sim.data$yrs) + 1

m1 <- lm(sim1~yr + post + post:yr, my.sim.data)
m2 <- lm(sim2~yr + post + post:yr, my.sim.data)
m3 <- lm(sim3~yr + post + post:yr, my.sim.data)
m4 <- lm(sim4~yr + post + post:yr, my.sim.data)
m5 <- lm(sim5~yr + post + post:yr, my.sim.data)

pdf("sim.pdf")
par(mfrow=c(2,3))
plot(my.sim.data$yr, exp(my.sim.data$sim1), log='y', ylim=c(20000, 2E06), xlab="Year", ylab="log(B)")
title("Scenario 1")
lines(exp(predict(m1)), col='red', type='l')
plot(my.sim.data$yr, exp(my.sim.data$sim2), log='y', ylim=c(20000, 2E06), xlab="Year", ylab="log(B)")
title("Scenario 2")
lines(exp(predict(m2)), col='red', type='l')
plot(my.sim.data$yr, exp(my.sim.data$sim3), log='y', ylim=c(20000, 2E06), xlab="Year", ylab="log(B)")
title("Scenario 3")
lines(exp(predict(m3)), col='red', type='l')
plot(my.sim.data$yr, exp(my.sim.data$sim4), log='y', ylim=c(20000, 2E06), xlab="Year", ylab="log(B)")
title("Scenario 4")
lines(exp(predict(m4)), col='red', type='l')
plot(my.sim.data$yr, exp(my.sim.data$sim5), log='y', ylim=c(20000, 2E06), xlab="Year", ylab="log(B)")
title("Scenario 5")
lines(exp(predict(m5)), col='red', type='l')
dev.off()

# now use real data
# connect to srdb
chan <- odbcConnect(dsn="srdbusercalo", case='postgresql',believeNRows=FALSE)

# assessid and ssb where there is more than 25 years of data

my.query <- paste ("select assessid, tsyear, ssb from srdb.timeseries_values_view where assessid in (select assessid from (select assessid, max(tsyear) - min(tsyear) as nyears from srdb.timeseries_values_view where ssb is not null and assessid in (select assessid from srdb.qaqc where qaqc is true) group by assessid) as a where nyears >= 25) and ssb is not null")
my.data <- sqlQuery(chan, my.query)
a <- unique(my.data$assessid)
n <- length(a)

pdf("ts.pdf")
#xyplot(ssb~tsyear | assessid, data=my.data)
for(i in 1:n) {
t <- subset(my.data, assessid == a[i])

t$post <- floor(t$tsyear/(cutoff+1))
t$yr <- t$tsyear - min(t$tsyear) + 1
m <- lm(log(ssb) ~ yr + post + post:yr, t)

c <- min(t$yr[t$post==1])
plot(t$yr, t$ssb, type='b', log='y')
title(a[i])
abline(v=c)
lines(exp(predict(m)), col='red', type='p')
}
dev.off()


# alternative model that fulfills the continuity constraint
pdf("ts-continuity.pdf")
#xyplot(ssb~tsyear | assessid, data=my.data)
for(i in 1:n) {
t <- subset(my.data, assessid == a[i])

t$post <- floor(t$tsyear/(cutoff+1))
t$yr <- t$tsyear - min(t$tsyear) + 1
c <- min(t$yr[t$post==1])
m <- lm(log(ssb) ~ yr + post *I(yr-c), t)

plot(t$yr, t$ssb, type='b', log='y')
title(a[i])
abline(v=c)
lines(exp(predict(m)), col='red', type='p')
}
dev.off()

# now see how the cutoff year influences the model fit
my.id <- "\'WGNSSK-POLLNS-VI-IIIa-1964-2006-MINTO\'"
qu <- paste("select assessid, tsyear, ssb from srdb.timeseries_values_view where assessid=",my.id,sep="")
d <- sqlQuery(chan,qu)
d$post <- floor(d$tsyear/(cutoff+1))
d$yr <- d$tsyear - min(d$tsyear) + 1


l <- (max(d$tsyear)-5) - (min(d$tsyear)+10) + 1

r <- data.frame(cut = rep(0,l), aic = rep(0,l), deviance = rep(0,l))
low <- min(d$tsyear)+10
high <- max(d$tsyear)-5
for (i in low:high) {
  ix <- i - low + 1
  cutoff <- i
  d$post <- floor(d$tsyear/(cutoff+1))
  m <- glm(ssb ~ yr + post + post:yr, data=d, family=gaussian(log))
  r$cut[ix] <- i
  r$aic[ix] <- m$aic
  r$deviance[ix] <- m$deviance
}

pdf("pollock.pdf")
par(mfrow=c(2,1))
plot(d$tsyear, d$ssb, type='b', log='y')
title(my.id)

plot(r$cut,r$aic, type='b')
dev.off()

#plot(r$cut,r$deviance, type='b')

odbcClose(chan)
