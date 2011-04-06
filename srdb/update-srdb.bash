#!/bin/bash
# bash script to update the database after adding new assessment(s)
# Time-stamp: <2011-04-05 21:42:13 (srdbadmin)>

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

## remove stock assessments that are not the "latest" from the views (updates to existing assessments are kept, previous ones are removed)
psql srdb -f ./scripts/views-keep-most-recent.sql


psql srdb -t -f ./scripts/grants.sql | psql srdb

#touch /home/srdbadmin/srdb/projects/fishandfisheries/tex/lastDBupdate-timestamp.txt
touch /home/srdbadmin/srdb/projects/fishandfisheries/tex/first-review/lastDBupdate-timestamp.txt
