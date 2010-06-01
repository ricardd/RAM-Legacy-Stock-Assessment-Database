#!/usr/bin/perl -w
# script to input a single spreadsheet file in the srDB

use strict;
use Spreadsheet::ParseExcel;
use POSIX qw(strftime);
use DBI;
my $dbh = DBI->connect('dbi:Pg:dbname=gfsDB;host=localhost;port=5433','ricardd','ricardd')|| die "Database connection not made: $DBI::errstr";


my $oExcel = new Spreadsheet::ParseExcel;

die "You must provide a filename to $0 to be parsed as an Excel file" unless @ARGV;

my $oBook = $oExcel->Parse($ARGV[0]);

#print "COUNT :", $oBook->{SheetCount} , "\n";

#die "The spreadsheet does not have 4 worksheets" unless $oBook->{SheetCount} == 4;

# variables for table srdb.assessement
my ($assessid, $assessorid, $stockid, $recorder, $daterecorded, $dateloaded, $assessyear, $assesssource, $contacts, $notes, $pdffile, $assess, $refpoints, $assessmethod, $assesscomments );


my($iR, $iC, $oWkS, $oWkC);

#####################################################
# first sheet
my $iSheet=0;
 $oWkS = $oBook->{Worksheet}[$iSheet];
 die "First worksheet must be called meta" unless $oWkS->{Name} eq "meta"; 

$assessorid = $oWkS->{Cells}[11][3]->Value;
$stockid = $oWkS->{Cells}[13][3]->Value;
$recorder = $oWkS->{Cells}[19][3]->Value;
$daterecorded = $oWkS->{Cells}[20][3]->Value;

# second sheet
$iSheet=1;
 $oWkS = $oBook->{Worksheet}[$iSheet];
 die "Second worksheet must be called reference" unless $oWkS->{Name} eq "reference"; 

$assessyear = $oWkS->{Cells}[2][2]->Value;
$assessyear = $oWkS->{Cells}[2][2]->Value;

$assesssource = $oWkS->{Cells}[4][2]->Value;
$contacts = $oWkS->{Cells}[5][2]->Value;
$notes = $oWkS->{Cells}[6][2]->Value;
$pdffile = $oWkS->{Cells}[7][2]->Value;
$assess = $oWkS->{Cells}[9][2]->Value;
$refpoints = $oWkS->{Cells}[10][2]->Value;
$assessmethod = $oWkS->{Cells}[11][2]->Value;
$assesscomments = $oWkS->{Cells}[12][2]->Value;


$assessid = $assessorid . "-" . $stockid . "-" . $assessyear . "-" . $recorder;
# end sheets 1 and 2

$dateloaded = strftime "%Y-%m-%d %H:%M:%S", localtime;


my $sql = qq{ INSERT INTO srdb.assessment VALUES(\'$assessid\', \'$assessorid\', \'$stockid\', \'$recorder\', \'$daterecorded\', \'$dateloaded\', $assessyear, \'$assesssource\', \'$contacts\', \'$notes\', \'$pdffile\', $assess, $refpoints, \'$assessmethod\', \'$assesscomments\') };
# print "$sql\n";
my $sth = $dbh->prepare( $sql );
$sth->execute();



# sheet 3
# variables for table srdb.bioparams
my ($bioid, $biounits, $biovalue);

$iSheet=2;
 $oWkS = $oBook->{Worksheet}[$iSheet];
 die "Third worksheet must be called points" unless $oWkS->{Name} eq "points"; 
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
# print("$iC $bioid $biounits $biovalue\n");
$sql = qq{ INSERT INTO srdb.bioparams VALUES(\'$assessid\',\'$bioid\',$biovalue) };
#print "$sql\n";
my $sth = $dbh->prepare( $sql );
$sth->execute();
  }

# sheet 4

# variables for time-series
my ($tsmetric, $tsunit, $tsyr, $tsvalue);

$iSheet=3;
 $oWkS = $oBook->{Worksheet}[$iSheet];

for($iC = $oWkS->{MinCol}+3;
      defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ;
      $iC++)
  {

    for($iR = $oWkS->{MinRow}+4;
      defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ;
      $iR++)

      {
	$tsmetric = $oWkS->{Cells}[2][$iC]->Value;
	$tsyr = $oWkS->{Cells}[$iR][2]->Value;
	$tsvalue  = $oWkS->{Cells}[$iR][$iC]->Value;
	#print("$tsmetric $tsyr $tsvalue\n");
	$sql = qq{ INSERT INTO srdb.timeseries VALUES(\'$assessid\',\'$tsmetric\',$tsyr, $tsvalue) };
	#print "$sql\n";
	my $sth = $dbh->prepare( $sql );
	$sth->execute();
      } # end loop across rows
  }


  # end loop across columns

$dbh->disconnect();
#####################################################


# print "\n\nAll done!\n";




