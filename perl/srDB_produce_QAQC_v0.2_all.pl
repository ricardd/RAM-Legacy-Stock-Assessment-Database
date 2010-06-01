#!/usr/bin/perl -w
# script to generate ALL QAQC documents
# Daniel Ricard, started: 2009-04-23
# Last modified Time-stamp: <2009-11-09 17:34:41 (srdbadmin)>
# Modification history: edits to accomodate the new directory structure intriduced by subversion
#

use strict;
use warnings;
use DBI;

# open a connection to the database
my $dbh = DBI->connect("dbi:Pg:dbname=srdb;host=localhost;port=5432;" ,
                      "srdbuser", "srd6us3r!")
		      || die "Database connection not made: $DBI::errstr";

my $recorderssql = qq{
SELECT DISTINCT recorder from srdb.assessment WHERE recorder != \'MYERS\'
};

my $handle = $dbh -> prepare($recorderssql);
$handle -> execute();
#my @results = $handle->fetchrow_array();

my @row;
while (@row = $handle->fetchrow_array) {
  my @systemcall=("/usr/bin/perl", "/home/srdbadmin/SQLpg/srdb/trunk/perl/srDB_produce_QAQC_docv0.2.pl", "@row");
  system(@systemcall);
#print("@row \n");
#print("$_ \n");
    }


$dbh->disconnect();
