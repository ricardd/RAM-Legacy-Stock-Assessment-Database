#!/usr/bin/perl -w
# script to input biometrics from NMFS assessments in the srDB
# using the Excel files that Mike Fogarty provided
# Daniel Ricard
# Started: 2008-07-22 from work on timeseries script
# Last modified Time-stamp: <2008-10-24 14:41:27 (ricardd)>
#
# Modification history:
# TODO : add Fmsy and Bmsy

use strict;
use Spreadsheet::ParseExcel;
use POSIX qw(strftime);
use DBI;

my $assessorid = "NMFS";
my $recorder = "FOGARTY";

my $dbh = DBI->connect('dbi:Pg:dbname=srDB;host=localhost;port=5432','ricardd','ricardd')|| die "Database connection not made: $DBI::errstr";

my $oExcel = new Spreadsheet::ParseExcel;
die "You must provide a filename to $0 to be parsed as an Excel file" unless @ARGV;

my $oBook = $oExcel->Parse($ARGV[0]);
print "Number of worksheets :", $oBook->{SheetCount} , "\n";
#die "The spreadsheet has more than one worksheet" unless $oBook->{SheetCount} == 1;

print("BEGIN\nProcessing the following Excel file: $ARGV[0] \n\n");


# open worksheet
my $iSheet=0;
my($iR, $iC, $oWkS, $oWkC);

$oWkS = $oBook->{Worksheet}[$iSheet];

#print(" $oWkS->{MinRow} \n");
#print(" $oWkS->{MaxRow} \n");
#print(" $oWkS->{MinCol} \n");
#print(" $oWkS->{MaxCol} \n");

my ($NMFSname, $stockid, $assessyear, $bestFest, $assessid, $lastdata);
# loop over rows
for($iR = $oWkS->{MinRow}+2; defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow}; $iR++)
  {
$NMFSname = $oWkS->{Cells}[$iR][2]->Value;
my $sql = qq{ SELECT stockid FROM srdb.nmfsstock WHERE NMFSname = \'$NMFSname\' };
my $sth = $dbh->prepare($sql)
                or die "Couldn't prepare statement: " . $dbh->errstr;
  $sth->execute
      or die "Can't execute SQL statement: $DBI::errstr\n";
  $stockid = $sth->fetchrow_array(  ) ;

$assessyear = $oWkS->{Cells}[$iR][3]->Value;
$lastdata = $oWkS->{Cells}[$iR][5]->Value;

$assessid = $assessorid . "-" . $stockid . "-" . $assessyear . "-" . $recorder;

$bestFest = $oWkS->{Cells}[$iR][16]->Value;

$sql = qq{ INSERT INTO srdb.bioparams VALUES(\'$assessid\',\'Fcurrent-1/T\',$bestFest,$lastdata) };
print("$iR \t $sql\n");
$sth = $dbh->prepare( $sql );
$sth->execute();

#print "$iR \t $stockid \t $NMFSname \t $assessid \t $bestFest\n";

  } # end loop over rows 


$dbh->disconnect();
