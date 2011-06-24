#!/bin/bash
# bash script to create the stock-recruitment database
# Daniel Ricard
# Started: 2007-12-20
#

#psql -U srdbadmin -d srDB -f './scripts/create-srDB.sql'
#psql -d srDB -f './scripts/create-srDB.sql'
psql -d srdb -f './scripts/create-srDB.sql'
psql -d srdb -c 'CREATE LANGUAGE plpgsql'