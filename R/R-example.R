##
##
require(RODBC)
chan.local <- odbcConnect(dsn='srdbcalo')
odbcClose(chan.local)
