#!/bin/bash
# bash script to dump the stock-recruitment database using pg_dump
# Daniel Ricard
# Started: 2008-08-21
# Last modified: Time-stamp: <2008-08-21 11:31:50 (ricardd)>

# script file version, for use with "psql"
pg_dump -C srDB > srDB-dump.sql

