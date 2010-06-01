require(RODBC)

chan <- odbcConnect("srdbcalo")

qu <- paste("
select assessid, tsyear, ssb
from srdb.timeseries_values_view
where assessid in (\'DFO-NFLD-COD3Ps-1959-2004-PREFONTAINE\',\'RAM-COD3Ps-1956-1993-MYERS\')
",sep="")

my.3ps.data <- sqlQuery(chan,qu)


odbcClose(chan)


ram.data <- subset(my.3ps.data, assessid == 'RAM-COD3Ps-1956-1993-MYERS')
prefontaine.data <- subset(my.3ps.data, assessid == 'DFO-NFLD-COD3Ps-1959-2004-PREFONTAINE')

plot.xlim <- range(c(ram.data$tsyear, prefontaine.data$tsyear))

plot.ylim <- range(c(ram.data$ssb, prefontaine.data$ssb), na.rm=TRUE)

plot(ram.data$tsyear, ram.data$ssb, xlim=plot.xlim, ylim = plot.ylim, type='b')
points(prefontaine.data$tsyear, prefontaine.data$ssb,type='b')
