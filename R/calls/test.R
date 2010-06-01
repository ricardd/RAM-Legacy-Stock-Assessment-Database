require(RODBC)
require(MASS)

# connect to srDB
chan <- odbcConnect(dsn="srDBcalo", uid = "ricardd", pwd="ricardd", case='postgresql',believeNRows=FALSE)

test.qu<-paste("select * from srdb.timeseries limit 100;")
test.dat<-sqlQuery(chan,test.qu)
