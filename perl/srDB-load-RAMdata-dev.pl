#!/usr/bin/perl -w
# script to input RAM's original sr data into the srdb database
# Daniel Ricard, started 2009-03-23, from earlier work
# Last modified: Time-stamp: <2009-03-23 12:38:48 (ricardd)>
# I'm modifying this script so that it can handle the stocks that have more than one-time-series data (e,g, CODNEAR, CODNERA2, CODNEAR3, CODNEAR4)

use strict;
use DBI;
use POSIX qw(strftime);

# connect to srDB
my $dbh = DBI->connect('dbi:Pg:dbname=srdb;host=localhost;port=5432','ricardd','ricardd')|| die "Database connection not made: $DBI::errstr";

my $sqlfile = "RAM-orig-dev.sql";

open SQLFILE, ">$sqlfile" or die $!;
open UNITSFILE, ">RAMunits.txt" or die $!;


# obtain a list of all the stocks that have a .doc file
my(@docfiles,$docfile,@datfiles,$datfile,$docinfile,$datinfile);
opendir(DIR, "../RAMdata");

@docfiles = grep(/\.doc$/,readdir(DIR));
@datfiles = grep(/\.dat$/,readdir(DIR));
closedir(DIR);

my ($assessid, $assessorid, $stockid, $recorder, $daterecorded, $dateloaded, $assessyear, $assesssource, $contacts, $notes, $pdffile, $assess, $refpoints, $assessmethod, $assesscomments , @raw_doc_data, @raw_dat_data, $sciname, $family, $order, $stock, $source, $comments, $fage, $agerecdat, $temp, $temp1, $unitssb, $unitrec, $unitland, $units, $natmort, $f01, $fmax, $fmed);

$recorder = "MYERS";
$assessorid = "RAM";
$daterecorded = "2007-03-27";
$dateloaded = strftime "%Y-%m-%d %H:%M:%S", localtime;
$assesssource = "RAMoriginal";
$contacts = "RAMoriginal";
$notes = "this assessment was translated from RAM original data";
$pdffile = "NULL";
$assess = 1;
$refpoints = 1;
$assesscomments = "none";


foreach $docfile (@docfiles) {
  $docinfile = "../RAMdata/$docfile";

# is there more than one file for this stock?


# if only one file, call the appropriate function
onefilestock($docinfile);

# if more than one stock, call the appropriate function
morethanonefilestock();


} # end loop over .doc files

# disconnect from srDB
$dbh->disconnect();
