## request from Trevor Branch, July 14 2011
##
require(RODBC)
chan <- odbcConnect(dsn="srdbcalo")
qu <- paste("
select assessid, xlsfilename, '../pdf/' || pdffile as pdffile from srdb.assessment where stockid in (select stockid from srdb.stock where tsn in (select tsn from srdb.taxonomy where family in ('Scombridae', 'Xiphiidae', 'Istiophoridae'))) and mostrecent='yes' and assessid not like '%MACK%' order by assessid
", sep="")

branch.tunas <- sqlQuery(chan,qu)

## create an archive with the spreadsheet files, the pdfs and the list of stocks
branch.xls <- paste(capture.output(cat(paste(as.character(branch.tunas$xlsfilename),sep=""), sep=" ")), sep="")
branch.pdf <- paste(capture.output(cat(paste(as.character(branch.tunas$pdffile),sep=""), sep=" ")), sep="")

system("rm Branch-20110714-tunas.zip")
bash.cmd <- paste("zip Branch-20110714-tunas.zip", branch.xls, branch.pdf, sep=" ")
system(bash.cmd)

write.csv(branch.tunas, "Branch-20110714-tunas.csv", row.names=FALSE)
system("zip Branch-20110714-tunas.zip Branch-20110714-tunas.csv")
system("zip Branch-20110714-tunas.zip Branch-20110714-tunas.R")

odbcClose(chan)
