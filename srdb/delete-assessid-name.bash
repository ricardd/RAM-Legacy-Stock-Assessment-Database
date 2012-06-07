#!/bin/bash
# bash script to delete a single assessment from a database
# first argument is the database name, the second argument is the assessid
# Time-stamp: <2012-06-07 12:14:12 (srdbadmin)>

psql -d $1 -c "DELETE FROM srdb.referencedoc where assessid = '$2'"
psql -d $1 -c "DELETE FROM srdb.qaqc where assessid = '$2'"
psql -d $1 -c "DELETE FROM srdb.bioparams where assessid = '$2'"
psql -d $1 -c "DELETE FROM srdb.timeseries where assessid = '$2'"
psql -d $1 -c "DELETE FROM srdb.brptots where assessid = '$2'"
psql -d $1 -c "DELETE FROM srdb.assessment where assessid = '$2'"
