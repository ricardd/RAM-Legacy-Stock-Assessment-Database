#!/bin/bash
# bash script to obtain summaries from the stock-recruitment database
# Daniel Ricard
# Started: 2008-04-11
#

#psql -d srDB -f './scripts/summaries-srDB.sql'
psql -d srdb -f './scripts/summaries-srDB.sql'
