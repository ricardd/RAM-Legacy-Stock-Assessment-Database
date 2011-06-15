#!/bin/bash
# bash script to re-create the stock-recruitment database from scratch
# Daniel Ricard
# Started: 2009-03-16

./destroy-srDB.bash
./create-srDB.bash
./load-srDB.bash
./load-assessments-RAMLegacy-v1.bash

psql srdb -f ../perl/RAM-orig.sql 2> ../perl/RAM-orig-SQL.log

./post-load-srDB.bash
./summaries.bash > summary.txt
