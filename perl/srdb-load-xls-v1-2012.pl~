#!/usr/bin/perl -w
# script to input a single spreadsheet file in the RAM Legacy Stock Assessment Database
# Last modified: Time-stamp: <2012-05-10 11:57:13 (srdbadmin)>
# Daniel Ricard
# 2012-05-08: this Perl script is to accomodate the newest spreadsheet template developed by Trevor Branch and his team at UW
# 2012-05-10: I think that this is working fine now, the spreadsheet template is only missing entries for "assess", "refpoints", and also "year" for the biometrics

use strict;
use Spreadsheet::ParseExcel;
#use DateTime::Format::Excel;
use POSIX qw(strftime);
use DBI;
my $dbh = DBI->connect('dbi:Pg:dbname=srdb;host=localhost;port=5432','srdbadmin','srd6adm1n!')|| die "Database connection not made: $DBI::errstr";

my $oExcel = new Spreadsheet::ParseExcel;

die "You must provide a filename to $0 to be parsed as an Excel file" unless @ARGV;

my $oBook = $oExcel->Parse($ARGV[0]);

# open a new SQL file that will contain all INSERT statements
my $sqlfile = substr ($ARGV[0], 0, rindex($ARGV[0], ".xls")) . ".sql";
my $sqllogfile = substr ($ARGV[0], 0, rindex($ARGV[0], ".xls")) . ".log";

#open SQLFILE, ">$sqlfile" or die $!;
open SQLFILE, ">:utf8", $sqlfile or die $!;
print SQLFILE "BEGIN;\n";

# variables for table srdb.assessement
my ($assessid, $assessorid, $stockid, $recorder, $daterecorded, $dateloaded, $assessyear, $assesssource, $contacts, $notes, $pdffile, $assess, $refpoints, $assessmethod, $assesscomments, $formatteddaterecorded, $xlsfilename, $mostrecent );
$xlsfilename = $ARGV[0];
$mostrecent="999";

my($iR, $iC, $oWkS, $oWkC, $excel);

# first, obtain minimum and maximum YEAR in the time-series, to assing "assessyear"
my $iSheet=3;
$oWkS = $oBook->{Worksheet}[$iSheet];

$assessyear = ($oWkS->{Cells}[$oWkS->{MinRow}+5][1]->Value) . "-" . ($oWkS->{Cells}[$oWkS->{MaxRow}][1]->Value) ;

# print(" $oWkS->{MinRow} \n");
# print(" $oWkS->{MaxRow} \n");
# print(" $oWkS->{MinCol} \n");
# print(" $oWkS->{MaxCol} \n");
# print ("$assessyear\n");

#####################################################
# Data sources sheet
$iSheet=1;
 $oWkS = $oBook->{Worksheet}[$iSheet];
die "First worksheet must be called Data sources" unless $oWkS->{Name} eq "Data sources"; 

$assessorid = $oWkS->{Cells}[10][1]->Value;
$stockid = $oWkS->{Cells}[11][1]->Value;
$recorder = $oWkS->{Cells}[3][1]->Value;
$daterecorded = $oWkS->{Cells}[4][1]->Value;
$formatteddaterecorded = $daterecorded;

$assesssource = $oWkS->{Cells}[5][1]->Value;
$contacts = $oWkS->{Cells}[8][1]->Value;
$notes = $oWkS->{Cells}[14][1]->Value;
if($oWkS->{Cells}[6][1]) {$pdffile = $oWkS->{Cells}[6][1]->Value;}
else {$pdffile = "NULL";}

$assess = $oWkS->{Cells}[17][1]->Value;
$refpoints = $oWkS->{Cells}[18][1]->Value;

$assessmethod = $oWkS->{Cells}[13][1]->Value;
$assesscomments = $oWkS->{Cells}[15][1]->Value;

$assessid = $assessorid . "-" . $stockid . "-" . $assessyear . "-" . $recorder;

$dateloaded = strftime "%Y-%m-%d %H:%M:%S", localtime;


# print ("$assessorid\n");
# print ("$stockid\n");
# print ("$recorder\n");
# print ("$daterecorded\n");
# print ("$assesssource\n");
# print ("$contacts\n");
# print ("$notes\n");
# print ("$pdffile\n");
# print ("$assessmethod\n");
# print ("$assesscomments\n");
# print ("$dateloaded\n");
# print ("$assessid\n");
# print ("$assess\n");
# print ("$refpoints\n");

my $sqlassessment = qq{ INSERT INTO srdb.assessment VALUES(\'$assessid\', \'$assessorid\', \'$stockid\', \'$recorder\', \'$formatteddaterecorded\', \'$dateloaded\', \'$assessyear\', \'$assesssource\', \'$contacts\', \'$notes\', \'$pdffile\', $assess, $refpoints, \'$assessmethod\', \'$assesscomments\', \'$xlsfilename\', \'$mostrecent\') };
# print "$sqlassessment\n";

print SQLFILE "$sqlassessment; \n";


#####################################################
# Biometrics sheet
$iSheet=2;
 $oWkS = $oBook->{Worksheet}[$iSheet];
die "Second worksheet must be called Biometrics" unless $oWkS->{Name} eq "Biometrics"; 

# variables for table srdb.bioparams
my ($sqlbiometrics, $biounique, $bioid, $bioyr, $biounits, $biovalue, $bionotes); #, $biounique

# set the start and end rows
my $startrow = $oWkS->{MinRow}+2;
my $endrow = $oWkS->{MaxRow};

# loop over rows
for($iR = $startrow; $iR <= $endrow; $iR++)
  {
$bioid = $oWkS->{Cells}[$iR][1]->Value;
$biounits = $oWkS->{Cells}[$iR][4]->Value;
$biovalue = $oWkS->{Cells}[$iR][2]->Value;
if($oWkS->{Cells}[$iR][7]) {$bionotes = $oWkS->{Cells}[$iR][7]->Value;}; # else {$bionotes = "NULL"};
$bioyr = $oWkS->{Cells}[$iR][8]->Value;
$biounique = $bioid . "-" . $biounits;

$sqlbiometrics = qq{ INSERT INTO srdb.bioparams VALUES(\'$assessid\',\'$biounique\',\'$biovalue\', \'$bioyr\', \'$bionotes\') };
print SQLFILE "$sqlbiometrics; \n";
  } # end loop over rows 


#####################################################
# Time series sheet
$iSheet=3;
 $oWkS = $oBook->{Worksheet}[$iSheet];
die "Second worksheet must be called Time series" unless $oWkS->{Name} eq "Time series"; 

# variables for time-series
my ($sqltimeseries, $tsmetric, $tsunit, $tsyr, $tsvalue, $tsunique);

#print("$oWkS->{MinCol} \n");
#print("$oWkS->{MaxCol} \n");

for($iC = $oWkS->{MinCol}+2;
      defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ;
      $iC++)
  {

    for($iR = $oWkS->{MinRow}+5;
      defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ;
      $iR++)

      {
	
	$tsmetric = $oWkS->{Cells}[3][$iC]->Value;
	$tsunit = $oWkS->{Cells}[4][$iC]->Value;
	$tsyr = $oWkS->{Cells}[$iR][1]->Value;
	$tsvalue  = $oWkS->{Cells}[$iR][$iC]->Value;
	$tsunique = $tsmetric . "-" . $tsunit;
	$sqltimeseries = qq{ INSERT INTO srdb.timeseries VALUES(\'$assessid\',\'$tsunique\',$tsyr, $tsvalue) };
	print SQLFILE "$sqltimeseries; \n";
      } # end loop across rows
  } # end loop across columns

print SQLFILE "COMMIT;";
