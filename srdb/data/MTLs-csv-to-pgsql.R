require(RODBC)
my.tl <- read.csv("BRANCH-Assessment-TLs-v4.csv", header=TRUE)
chan <- odbcConnect(dsn="srdbcalo")
tt <- data.frame(my.tl$scientificname, my.tl$TL, my.tl$Lmax, my.tl$DemersalPelagic)
sqlSave(chan, tt, tablename = "srdb.fishbasemtl", rownames=FALSE, safer=FALSE)

## link scientificname to srdb.taxonomy
qu <- paste("ALTER TABLE srdb.fishbasemtl add constraint scifk FOREIGN KEY (mytlscientificname) REFERENCES srdb.taxonomy (scientificname) MATCH FULL",sep="")
sqlQuery(chan,qu)
odbcClose(chan)
