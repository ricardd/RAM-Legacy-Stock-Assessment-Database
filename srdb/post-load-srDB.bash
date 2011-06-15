#!/bin/bash
# bash script to perform post-load tasks in the stock-recruitment database
# 
# Last modified Time-stamp: <2011-06-13 22:15:15 (srdbadmin)>

# a quick and dirty way to generate a summary log files of error to identify assessments that did not load
# grep ERROR ../spreadsheets/*.log | grep key > load-errors-summary.log
# grep ERROR ../spreadsheets/*.log | grep invalid > load-errors-summary.log

grep ERROR ../spreadsheets/*.log | grep foreign > load-errors-summary.log

# invoke the SQL script that fixes units as requested by Julia Baum 
# i.e. reduces the number of time-series units
psql -d srdb -f './scripts/massage-timeseries.sql'
psql -d srdb -f './scripts/massage-biometrics.sql'

# a script to assign the value of RIS field ID in the referencedoc table to the value of pdffile in the assessment table
psql -d srdb -f './scripts/massage-pdfs.sql'

# QAQC data
psql -d srdb -f './scripts/load-qaqc.sql'

# LMEs
psql -d srdb -f './scripts/load-lmes.sql'

# reference points to timeseries
psql srdb -f './scripts/load-ref-points-to-ts.sql'

# FishBase and SAUPcodes
psql srdb -f './scripts/load-fishbase-saup-codes.sql'

psql srdb -f './scripts/srDB-views.sql'

psql srdb -f './scripts/most-recent.sql'

# stocks for Science 2009 manuscript
#psql -d srdb -f './scripts/Science-2009-stocks.sql'


# views for time-series truncation project
# psql -d srdb -f './scripts/tstruncation-views.sql'

# BRP to timeseries
# psql -d srdb -f './scripts/load-ref-points-to-ts.sql'


# GRANT USAGE to schema
psql -d srdb -c 'GRANT USAGE ON SCHEMA srdb TO srdbuser;'

# GRANT SELECT on tables to users "srdbuser" and others
psql -d srdb -t -f './scripts/grants.sql' | psql -d srdb

# run a VACUUM and ANALYSE
psql -d srdb -f './scripts/post-load.sql'
