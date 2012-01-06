##
##
require(RODBC)
chan.local <- odbcConnect(dsn='srdbcalo')


my.qu <- paste("select assessid from srdb.assessment where assessmethod in (select methodshort from srdb.assessmethod where category = 'VPA')", sep="")

my.aa <- sqlQuery(chan.local,my.qu)


pdf("temp-plots.pdf")
for(i in 1:dim(my.aa)[1]){
print(i)
qu <- paste("select * from srdb.timeseries_values_view where assessid = '",my.aa[i,],"'", sep="")
dd <- sqlQuery(chan.local,qu)
plot(ssb~tsyear, data=dd)
}
    dev.off()
    
odbcClose(chan.local)

