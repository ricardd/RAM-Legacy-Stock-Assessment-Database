#!/bin/bash
## use the database supplied as an argument to create a test version of it, which means copying it and removing the tables not necessary for the production version
# Last modified Time-stamp: <2011-08-12 11:09:55 (srdbadmin)>

STR="$1test"

SQLCALL1="DROP DATABASE "$STR
echo $SQLCALL1 | psql template1

SQLCALL2="CREATE DATABASE $STR WITH TEMPLATE $1;"
echo $SQLCALL2 | psql template1

# now remove the tables in the test database
psql $STR -f ./scripts/cull-tables-for-production.sql

