#!/bin/bash
# bash script to update the database after adding new assessment(s)
# Time-stamp: <2011-08-05 12:12:55 (srdbadmin)>

psql $1 -f ./scripts/massage-timeseries.sql
psql $1 -f ./scripts/massage-biometrics.sql
psql $1 -f ./scripts/massage-pdfs.sql

psql $1 -f ./scripts/delete-references.sql
psql $1 -t -f ./scripts/insertZZID-references.sql | psql $1 

psql $1 -f ./scripts/load-qaqc.sql
psql $1 -f ./scripts/load-lmes.sql

psql $1 -f ./scripts/load-ref-points-to-ts.sql

psql $1 -f ./scripts/srDB-views.sql

psql $1 -f ./scripts/most-recent.sql

## remove stock assessments that are not the "latest" from the views (updates to existing assessments are kept, previous ones are removed)
psql $1 -f ./scripts/views-keep-most-recent.sql


psql $1 -t -f ./scripts/grants.sql | psql $1

#touch /home/srdbadmin/srdb/projects/fishandfisheries/tex/lastDBupdate-timestamp.txt
touch /home/srdbadmin/srdb/projects/fishandfisheries/tex/PROOFS-final/lastDB-update.txt
