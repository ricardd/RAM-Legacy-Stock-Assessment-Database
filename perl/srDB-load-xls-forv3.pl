#!/usr/bin/perl -w
# script to input a single spreadsheet file in the srDB
# Daniel Ricard
# 2008-02-12: modifications to accomodate Excel template v2
# 2008-02-19: modifications to accomodate Excel template v3

use strict;
use Spreadsheet::ParseExcel;
use POSIX qw(strftime);
use DBI;
#my $dbh = DBI->connect('dbi:Pg:dbname=gfsDB;host=localhost;port=5433','ricardd','ricardd')|| die "Database connection not made: $DBI::errstr";
#my $dbh = DBI->connect('dbi:Pg:dbname=srDB;host=localhost;port=5432','ricardd','ricardd')|| die "Database connection not made: $DBI::errstr";
my $dbh = DBI->connect('dbi:Pg:dbname=srdb;host=localhost;port=5432','ricardd','ricardd')|| die "Database connection not made: $DBI::errstr";

my $oExcel = new Spreadsheet::ParseExcel;

die "You must provide a filename to $0 to be parsed as an Excel file" unless @ARGV;

my $oBook = $oExcel->Parse($ARGV[0]);

#print "COUNT :", $oBook->{SheetCount} , "\n";

die "The spreadsheet does not have 3 worksheets" unless $oBook->{SheetCount} == 3;

print("BEGIN\nProcessing the following Excel file: $ARGV[0] \n\n");

# variables for table srdb.assessement
my ($assessid, $assessorid, $stockid, $recorder, $daterecorded, $dateloaded, $assessyear, $assesssource, $contacts, $notes, $pdffile, $assess, $refpoints, $assessmethod, $assesscomments );


my($iR, $iC, $oWkS, $oWkC);

# first, obtain minimum and maximum YEAR in the time-series, to assing "assessyear"
my $iSheet=2;
$oWkS = $oBook->{Worksheet}[$iSheet];
#print ("$oWkS->{MinRow} \t $oWkS->{MaxRow}\n");
$assessyear = ($oWkS->{Cells}[$oWkS->{MinRow}+4][2]->Value) . "-" . ($oWkS->{Cells}[$oWkS->{MaxRow}][2]->Value) ;
# print ("$assessyear\n");
#$oWkS->{MaxRow} \n"



#####################################################
# first sheet
$iSheet=0;
 $oWkS = $oBook->{Worksheet}[$iSheet];
die "First worksheet must be called meta" unless $oWkS->{Name} eq "meta"; 

$assessorid = $oWkS->{Cells}[10][3]->Value;
$stockid = $oWkS->{Cells}[12][3]->Value;
$recorder = $oWkS->{Cells}[18][3]->Value;
$daterecorded = $oWkS->{Cells}[19][3]->Value;

#$assessyear = $oWkS->{Cells}[2][2]->Value;

# TEMPORARY FAKE VALUE
# $assessyear = 2134;

$assesssource = $oWkS->{Cells}[22][3]->Value;
$contacts = $oWkS->{Cells}[23][3]->Value;
$notes = $oWkS->{Cells}[24][3]->Value;
$pdffile = $oWkS->{Cells}[25][3]->Value;
$assess = $oWkS->{Cells}[27][3]->Value;
$refpoints = $oWkS->{Cells}[28][3]->Value;
$assessmethod = $oWkS->{Cells}[29][3]->Value;
$assesscomments = $oWkS->{Cells}[30][3]->Value;

#print "$notes\n";


$assessid = $assessorid . "-" . $stockid . "-" . $assessyear . "-" . $recorder;

$dateloaded = strftime "%Y-%m-%d %H:%M:%S", localtime;

my $sqlassessment = qq{ INSERT INTO srdb.assessment VALUES(\'$assessid\', \'$assessorid\', \'$stockid\', \'$recorder\', \'$daterecorded\', \'$dateloaded\', \'$assessyear\', \'$assesssource\', \'$contacts\', \'$notes\', \'$pdffile\', $assess, $refpoints, \'$assessmethod\', \'$assesscomments\') };
# print "$sqlassessment\n";

# load data into the assessment table
my $sth = $dbh->prepare( $sqlassessment );
die "Could not load the assessment metadata.\nExiting without any changes to the database.\n\n" unless $sth->execute();

print "Assessment metadata loaded successfully.\n";

# second sheet
$iSheet=1;
 $oWkS = $oBook->{Worksheet}[$iSheet];
 die "Second worksheet must be called biometrics" unless $oWkS->{Name} eq "biometrics"; 
# variables for table srdb.bioparams
my ($sqlbiometrics, $biounique, $bioid, $bioyr, $biounits, $biovalue); #, $biounique

#print(" $oWkS->{MinRow} \n");
#print(" $oWkS->{MaxRow} \n");
#print(" $oWkS->{MinCol} \n");
#print(" $oWkS->{MaxCol} \n");

  for($iC = $oWkS->{MinCol}+2;
      defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ;
      $iC++)
  {
$bioid = $oWkS->{Cells}[2][$iC]->Value;
$biounits = $oWkS->{Cells}[3][$iC]->Value;
$biovalue = $oWkS->{Cells}[4][$iC]->Value;
$bioyr = $oWkS->{Cells}[5][$iC]->Value;
$biounique = $bioid . "-" . $biounits;

#$biounique = $bioid . "-" . $biounits;
# print("$iC $bioid $biounits $biovalue\n");
$sqlbiometrics = qq{ INSERT INTO srdb.bioparams VALUES(\'$assessid\',\'$biounique\',\'$biovalue\', \'$bioyr\') };
#print "$sqlbiometrics\n";
my $sth = $dbh->prepare( $sqlbiometrics );
$sth->execute();
  }
print "Biometrics loaded successfully.\n";

# sheet 3

# variables for time-series
my ($sqltimeseries, $tsmetric, $tsunit, $tsyr, $tsvalue, $tsunique);

$iSheet=2;
 $oWkS = $oBook->{Worksheet}[$iSheet];
 die "Third worksheet must be called timeseries" unless $oWkS->{Name} eq "timeseries"; 

#print(" $oWkS->{MinRow} \n");
#print(" $oWkS->{MaxRow} \n");
#print(" $oWkS->{MinCol} \n");
#print(" $oWkS->{MaxCol} \n");

for($iC = $oWkS->{MinCol}+2;
      defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ;
      $iC++)
  {

    for($iR = $oWkS->{MinRow}+4;
      defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ;
      $iR++)

      {
	$tsmetric = $oWkS->{Cells}[2][$iC]->Value;
	$tsunit = $oWkS->{Cells}[3][$iC]->Value;
	$tsyr = $oWkS->{Cells}[$iR][2]->Value;
	$tsvalue  = $oWkS->{Cells}[$iR][$iC]->Value;
	$tsunique = $tsmetric . "-" . $tsunit;
	#print("$tsmetric $tsyr $tsvalue\n");
	$sqltimeseries = qq{ INSERT INTO srdb.timeseries VALUES(\'$assessid\',\'$tsunique\',$tsyr, $tsvalue) };
#	print "$sqltimeseries\n";
	my $sth = $dbh->prepare( $sqltimeseries );
	$sth->execute();
      } # end loop across rows
  }

print "Time-series loaded successfully.\n";

#$assessyear 

  # end loop across columns



# load data into the biometrics table

# load data into the timeseries table



$dbh->disconnect();
#####################################################



print "\nDatetime stamp for database input: $dateloaded \n $ARGV[0] \nEND\n\n\n\n";



