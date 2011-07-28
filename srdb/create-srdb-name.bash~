#!/bin/bash
# bash script to create the stock-recruitment database
# Daniel Ricard
# Started: 2011-06-24, adding an argument that determines what database to use (to better handle development, staging and production versions of the database)
# Last modified: Time-stamp: <2011-06-24 09:40:00 (srdbadmin)>

psql -d $1 -f './scripts/create-srDB.sql'
