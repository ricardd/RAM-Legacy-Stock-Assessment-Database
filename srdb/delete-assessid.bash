#!/bin/bash
# bash script to delete a single assessment
# Time-stamp: <2010-05-27 20:06:11 (srdbadmin)>

psql srdb -c "DELETE FROM srdb.referencedoc where assessid = '$1'"
psql srdb -c "DELETE FROM srdb.qaqc where assessid = '$1'"
psql srdb -c "DELETE FROM srdb.bioparams where assessid = '$1'"
psql srdb -c "DELETE FROM srdb.timeseries where assessid = '$1'"
psql srdb -c "DELETE FROM srdb.brptots where assessid = '$1'"
psql srdb -c "DELETE FROM srdb.science2009stocks where assessid = '$1'"
psql srdb -c "DELETE FROM srdb.science2009updated where assessid = '$1'"
psql srdb -c "DELETE FROM srdb.assessment where assessid = '$1'"
