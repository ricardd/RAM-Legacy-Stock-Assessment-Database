

require(RODBC)
require(MASS)
# connect to the srDB
chan <- odbcConnect(dsn="srdbusercalo", uid = "srdbuser", pwd="srd6us3r!", case='postgresql',believeNRows=FALSE)

pdf("myplot.pdf")
x <- rnorm(100,5,2)
y <- rnorm(100,10,4)
plot(x,y)
dev.off()

odbcClose(chan)
