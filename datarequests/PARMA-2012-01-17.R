## data request from Ana Parma
## - generate a list of stocks and associated info
## Last modified Time-stamp: <2012-01-17 14:18:52 (srdbadmin)>
##
## email:
#1) I just joined the steering committee of the ICES Strategic Initiative
#for Stock Assessment Methods (SISAM) chaired by
#Steve Cadrin and Mark Dickey-Collas. The goal of SISAM is to review
#available assessment methods and provide guidance on best assessment
#practices. As a first step the group thought it would be of interest to
#have a sense of frequency of use of different category of methods in
#different regions. We thought about the RAM database to give us a start on
#stocks, regions, methods used and contacts.
#My question to you is: how difficult would it be to do a query on the
#complete list of stocks available in the database, with the following
#fields for each:

#Scintific name

#Common name

#recorder

#date recorded

#Contact

#area/country

#assessor

#stockid

#assessment category

#assess method

require(RODBC)

chan <- odbcConnect('srdbusercalo')

qu <- paste("select t.scientificname, t.commonname1, a.recorder, a.daterecorded, a.contacts, ar.areaid, ar.areaname, a.assessorid, aa.assessorfull, aa.country, a.stockid, am.category, am.methodshort from srdb.assessment a, srdb.taxonomy t, srdb.assessmethod am, srdb.assessor aa, srdb.stock s, srdb.area ar where a.assessorid = aa.assessorid and a.assessmethod=am.methodshort and a.stockid = s.stockid and s.areaid=ar.areaid and s.tsn=t.tsn and assess=1 order by aa.country", sep="")
my.dd <- sqlQuery(chan,qu)

odbcClose(chan)

write.csv(my.dd, "PARMA-2012-01-17.csv", row.names=FALSE)
