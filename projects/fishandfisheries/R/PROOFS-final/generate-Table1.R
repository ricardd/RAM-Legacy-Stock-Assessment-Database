setwd("/home/srdbadmin/srdb/projects/fishandfisheries/R/PROOFS-final")
require(RODBC)
require(xtable)

chan<- odbcConnect(dsn="srdbcalo")

qu <- paste("
SELECT
m.country,
CASE WHEN position(',' in m.managementauthority)=0 THEN m.managementauthority ELSE substring(m.managementauthority,0,position(',' in m.managementauthority)) END as authority,
m.mgmt,
count(*) as nassess
FROM
srdb.management m,
srdb.assessor aa,
srdb.assessment a
WHERE
a.assessorid = aa.assessorid AND
m.mgmt = aa.mgmt AND
a.recorder != 'MYERS' AND
a.assess=1 AND a.mostrecent = 'yes'
GROUP BY 
m.country,
m.managementauthority,
m.mgmt
ORDER BY
count(*) desc,
m.mgmt,
m.country
",sep="")

## CASE WHEN position(',' in m.managementauthority)=0 THEN m.managementauthority ELSE substring(m.managementauthority,0,position(',' in m.managementauthority)) END,

table1.data <- sqlQuery(chan,qu)


table1 <- xtable(table1.data, caption=c("Number of assessments included in the RAM Legacy database"), label=c("tab:mgmt"), align="cp{3cm}p{5cm}cc")
  print(table1, type="latex", file="../../tex/PROOFS-final/Table1.tex", include.rownames=FALSE, floating=TRUE, caption.placement="top")

  print(table1, type="html", file="../../tex/PROOFS-final/Table1.html", include.rownames=FALSE, floating=TRUE, caption.placement="top")

odbcClose(chan)

