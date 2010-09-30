## BRANCH-SEP2010-review.R
## got an email from Trevor Branch asking for data, this is an ad hoc solution to giving him what he's after
## Daniel Ricard Started: 2010-09-22
## last modified Time-stamp: <2010-09-22 23:00:42 (srdbadmin)>
##
##
require(RODBC)

chan<-odbcConnect("srdbcalo")

qu <- paste("
SELECT
a.assessid,
a.stockid,
a.common_name,
a.LME,
a.year,
a.ssb,
a.ssb_unit,
a.recruitment,
a.recruitment_unit
FROM
(
SELECT
a.assessid,
a.stockid,
t.commonname1 as common_name,
lr.lme_name as LME,
vv.tsyear as year, 
vv.ssb as ssb,
vu.ssb_unit as ssb_unit,
vv.r as recruitment,
vu.r_unit as recruitment_unit
FROM
srdb.assessment a,
srdb.stock s,
srdb.taxonomy t,
srdb.lmetostocks ls,
srdb.lmerefs lr,
srdb.newtimeseries_values_view vv,
srdb.timeseries_units_view vu
WHERE
vv.assessid = vu.assessid AND
a.assessid = vv.assessid AND
a.stockid = s.stockid AND
s.tsn = t.tsn AND
s.stockid = ls.stockid AND
ls.stocktolmerelation = 'primary' AND
ls.lme_number=lr.lme_number 
 ) as a
order by
a.assessid,
a.year
", sep="")

trevor.dat.review <- sqlQuery(chan,qu)

write.csv(trevor.dat.review, "BRANCH-20100922-review.csv")
odbcClose(chan)
