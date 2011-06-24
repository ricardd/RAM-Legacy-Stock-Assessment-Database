#!/bin/bash
# bash script to load background data in the stock-recruitment database
# that is, data required to start loading the spreadsheet assessments
# Daniel Ricard
# Started: 2011-06-24, adding an argument that determines what database to use (to handle development, staging and production versions of the database)
# Last modified: Time-stamp: <2011-06-24 09:20:09 (srdbadmin)>

psql -d $0 -f './scripts/load-stocks.sql'

psql -d $0 -f './scripts/RAM-tables.sql'

psql -d $0 -f './scripts/load-assessors.sql'
psql -d $0 -f './scripts/load-assessmethods.sql'

# indices 
psql -d $0 -f './scripts/indices.sql'
