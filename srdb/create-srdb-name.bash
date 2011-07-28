#!/bin/bash
# bash script to create the stock assessment database
# Daniel Ricard
# Started: 2011-06-24, adding an argument that determines what database to use (to better handle development, staging and production versions of the database)
# Last modified: Time-stamp: <2011-07-20 20:34:31 (srdbadmin)>

psql -d $1 -f './scripts/create-srDB.sql'
