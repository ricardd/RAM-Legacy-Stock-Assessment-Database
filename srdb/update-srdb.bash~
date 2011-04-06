#!/bin/bash
# bash script to update the database after adding new assessment(s)
# Time-stamp: <2010-06-14 11:20:16 (srdbadmin)>

psql srdb -f ./scripts/massage-timeseries.sql
psql srdb -f ./scripts/massage-biometrics.sql
psql srdb -f ./scripts/massage-pdfs.sql

psql srdb -f ./scripts/delete-references.sql
psql srdb -t -f ./scripts/insertZZID-references.sql | psql srdb 

psql srdb -f ./scripts/load-qaqc.sql
psql srdb -f ./scripts/load-lmes.sql

psql srdb -f ./scripts/load-ref-points-to-ts.sql

psql srdb -f ./scripts/srDB-views.sql

psql srdb -f ./scripts/most-recent.sql


psql srdb -t -f ./scripts/grants.sql | psql srdb

touch /home/srdbadmin/srdb/projects/fishandfisheries/tex/lastDBupdate-timestamp.txt
