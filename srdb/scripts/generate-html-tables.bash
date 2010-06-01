#!/bin/bash

psql -d srdb -q -c "select scientificname, commonname1, tsn, kingdom, phylum, classname, ordername, family, genus, species from srdb.taxonomy order by scientificname" -o ../data/taxonomy.html -H 

psql -d srdb -q -c "select * from srdb.management order by mgmt" -o ../data/management.html -H

psql -d srdb -q -c "select * from srdb.area order by country, areatype, areacode" -o ../data/area.html -H

psql -d srdb -q -c "select * from srdb.assessor order by country, mgmt, assessorid, assessorfull " -o ../data/assessor.html -H

psql -d srdb -q -c "select scientificname, stockid, scientificname, commonname, areaID, stocklong, inMYERSDB, MYERSstockid from srdb.stock order by scientificname" -o ../data/stock.html -H

psql -d srdb -q -c "select * from srdb.tsmetrics" -o ../data/tsmetrics.html -H

psql -d srdb -q -c "select bioshort, category, subcategory, biolong, biounitsshort, biounitslong from srdb.biometrics order by category DESC, subcategory ASC, bioshort ASC" -o ../data/biometrics.html -H

psql -d srdb -q -c "select * from srdb.assessmethod order by category, methodshort" -o ../data/assess-methods.html -H

psql -d srdb -q -c "select recorder, assessid, assessorid, stockid, daterecorded, dateloaded, assessyear, assess, refpoints, assessmethod, xlsfilename from srdb.assessment order by recorder, stockid" -o ../data/assessment.html -H

psql -d srdb -q -c "select recorder, assessid, assessorid, stockid, daterecorded, dateloaded, assessyear, assess, refpoints, assessmethod, xlsfilename from srdb.assessment where recorder != 'MYERS' order by recorder, stockid" -o ../data/assessment-lite.html -H
