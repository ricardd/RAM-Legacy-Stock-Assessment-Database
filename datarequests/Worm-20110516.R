##
##
require(RODBC)
qu <- paste("
SELECT * FROM srdb.timeseries_values_view
where assessid in
(select assessid from srdb.assessment where stockid in 
(SELECT stockid from srdb.lmetostocks where lme_number in (3, 7) and stocktolmerelation = 'primary'))
",sep="")

chan <- odbcConnect(dsn='srdbcalo')
boris.dat <- sqlQuery(chan,qu)

qu <- paste("select a.assessid, s.stocklong, t.scientificname, lr.lme_name
FROM
srdb.assessment a, srdb.stock s, srdb.taxonomy t, srdb.lmerefs lr, srdb.lmetostocks ls
where a.stockid = s.stockid and s.tsn=t.tsn and ls.lme_number=lr.lme_number and ls.stocktolmerelation='primary' and ls.stockid=s.stockid
",sep="")

details <- sqlQuery(chan,qu)

boris.final <- merge(boris.dat, details, "assessid")
write.csv(boris.final,"Worm-20110517.csv", row.names=FALSE)

odbcClose(chan)
