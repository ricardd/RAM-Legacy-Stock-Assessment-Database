#!/bin/bash
# bash script to load background data in the stock-recruitment database
# that is, data required to start loading the spreadsheet assessments
# Daniel Ricard
# Started: 2007-12-20
# Last modified: Time-stamp: <2009-03-10 11:38:21 (ricardd)>
#

psql -d srdb -f './scripts/load-stocks.sql'
# psql -d srdb -f './scripts/NMFS-tables.sql'
psql -d srdb -f './scripts/RAM-tables.sql'

psql -d srdb -f './scripts/load-assessors.sql'
psql -d srdb -f './scripts/load-assessmethods.sql'

# indices 
psql -d srdb -f './scripts/indices.sql'



