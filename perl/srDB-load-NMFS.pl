#!/usr/bin/perl -w
# script to input timeseries from NMFS assessments in the srDB
# using the Excel files that Mike Fogarty provided
# Daniel Ricard
# Started: 2008-05-08 from earlier work
# Last modified Time-stamp: <2008-11-12 16:05:27 (ricardd)>
#
# Modification history:
# 2008-07-21: adding an associative array to extract each stock's units

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
print "Number of worksheets :", $oBook->{SheetCount} , "\n";
die "The spreadsheet does not have 3 worksheets" unless $oBook->{SheetCount} == 3;

print("BEGIN\nProcessing the following Excel file: $ARGV[0] \n\n");

# variables for table srdb.assessement
my ($assessid, $assessorid, $stockid, $recorder, $daterecorded, $dateloaded, $assessyear, $assesssource, $contacts, $notes, $pdffile, $assess, $refpoints, $assessmethod, $assesscomments );

$assessorid = "NMFS";
$recorder = "FOGARTY";
#$daterecorded = "2008-04-11";
$daterecorded = "-999";
$dateloaded = strftime "%Y-%m-%d %H:%M:%S", localtime;
$assesssource = "Mike Fogarty Excel file";
$contacts = "Mike Fogarty (mfogarty at mercury.wh.whoi.edu)";
$notes = "NULL";
$pdffile = "NULL";
$assess=1;
$refpoints=1;
$assessmethod="UNKNOWN";
$assesscomments = "Assessment results obtained from Mike Fogarty.";

my $iSheet=0;
my($iR, $iC, $oWkS, $oWkC);

$oWkS = $oBook->{Worksheet}[$iSheet];

# create an array to link each stock with its stockid, tsunique and tsunits
#my (@NMFSarraytemp,@NMFSarray);
my (@NMFSarray);
my (%NMFSarray2);

#@NMFSarraytemp=(1,2,3,4,5,6,7,8);
#push(@NMFSarray, \@NMFSarraytemp);

#print(" $oWkS->{MinRow} \n");
#print(" $oWkS->{MaxRow} \n");
#print(" $oWkS->{MinCol} \n");
#print(" $oWkS->{MaxCol} \n");
my ($NMFSname, $sql, $minbioage, $minrecage, $biounits, $spawnunits, $catchunits, $recunits, $funits);

#print("index 0 of NMFSarray: $NMFSarray[0]\n");
#print("first element of index 0 of NMFSarray: @NMFSarray[0]->[0]\n");


for($iR = $oWkS->{MinRow}+2; defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow}; $iR++)
  {
$NMFSname = $oWkS->{Cells}[$iR][1]->Value;
chomp $NMFSname;
$NMFSname =~ s/\s+$//; 
$assessyear = $oWkS->{Cells}[$iR][2]->Value;
$minbioage = $oWkS->{Cells}[$iR][3]->Value;
$minrecage = $oWkS->{Cells}[$iR][4]->Value;
$biounits = $oWkS->{Cells}[$iR][5]->Value;
$spawnunits = $oWkS->{Cells}[$iR][6]->Value;
$catchunits = $oWkS->{Cells}[$iR][7]->Value;
$recunits = $oWkS->{Cells}[$iR][8]->Value;
$funits = $oWkS->{Cells}[$iR][9]->Value;

#print("$iR \t $NMFSname \n");

my $sql = qq{ SELECT stockid FROM srdb.nmfsstock WHERE NMFSname = \'$NMFSname\' };
#print "$sql\n";

my $sth = $dbh->prepare($sql)
                or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth->execute
      or die "Can't execute SQL statement: $DBI::errstr\n";

  #my @row;
  $stockid = $sth->fetchrow_array(  ) ;
  #print "$iR \t $stockid \t $NMFSname\n";

$assessid = $assessorid . "-" . $stockid . "-" . $assessyear . "-" . $recorder;

#@NMFSarraytemp = ($assessid, $minbioage, $minrecage, $biounits, $spawnunits, $catchunits, $recunits, $funits);
my @NMFSarraytemp = ($assessid, $minbioage, $minrecage, $biounits, $spawnunits, $catchunits, $recunits, $funits);
#print("$assessid \t  $minbioage \t  $minrecage \t  $biounits \t  $spawnunits \t  $catchunits \t  $recunits \t  $funits \n");

push(@NMFSarray, \@NMFSarraytemp);
$NMFSarray2{$assessid} = [$assessid, $minbioage, $minrecage, $biounits, $spawnunits, $catchunits, $recunits, $funits];
#print("$NMFSarray2{$assessid}\n");
#print("position 0: $NMFSarray2{$assessid}->[0]\n");
#print("position 1: $NMFSarray2{$assessid}->[1]\n");
#print("position 2: $NMFSarray2{$assessid}->[2]\n");
#print("position 3: $NMFSarray2{$assessid}->[3]\n");
#print("position 4: $NMFSarray2{$assessid}->[4]\n");
#print("position 5: $NMFSarray2{$assessid}->[5]\n");
#print("position 6: $NMFSarray2{$assessid}->[6]\n");
#print("position 7: $NMFSarray2{$assessid}->[7]\n");

#print("inside loop, first element of index $iR-1 of NMFSarray: @NMFSarray\n");
#print("inside loop, first element of index $iR-1 of NMFSarray: @NMFSarray[$iR-2]->[0]\n");

#print("$iR \t @NMFSarraytemp\n");
#print("$iR \t $NMFSarraytemp[1]\t $NMFSarraytemp[2]\n");


$sql = qq{ INSERT INTO srdb.assessment VALUES(\'$assessid\', \'$assessorid\', \'$stockid\', \'$recorder\', \'$daterecorded\', \'$dateloaded\', \'$assessyear\', \'$assesssource\', \'$contacts\', \'$notes\', \'$pdffile\', $assess, $refpoints, \'$assessmethod\', \'$assesscomments\') };

#print "$iR \t $sql\n";

$sth = $dbh->prepare( $sql );
$sth->execute();
#die "Could not load the assessment metadata.\nExiting without any changes to the database.\n\n" unless $sth->execute();

  } # end loop over rows 

# at this stage, all stock-year combinations have a corresponding entry in the srdb.assessment table

# second worksheet has time-series data

$iSheet=1;
$oWkS = $oBook->{Worksheet}[$iSheet];

#print(" $oWkS->{MinRow} \n");
#print(" $oWkS->{MaxRow} \n");
#print(" $oWkS->{MinCol} \n");
#print(" $oWkS->{MaxCol} \n");

my ($tsyear, $biomass, $spawners, $recruits, $catch, $Fmort); #, $tsunique);

for($iR = $oWkS->{MinRow}+1; defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow}; $iR++)
  {
$NMFSname = $oWkS->{Cells}[$iR][0]->Value;
chomp $NMFSname;
$NMFSname =~ s/\s+$//; 

$assessyear = $oWkS->{Cells}[$iR][1]->Value;
$tsyear = $oWkS->{Cells}[$iR][2]->Value;
$biomass = $oWkS->{Cells}[$iR][3]->Value;
$spawners = $oWkS->{Cells}[$iR][4]->Value;
$recruits = $oWkS->{Cells}[$iR][7]->Value;
$catch = $oWkS->{Cells}[$iR][8]->Value;
$Fmort = $oWkS->{Cells}[$iR][9]->Value;


$sql = qq{ SELECT stockid FROM srdb.nmfsstock WHERE NMFSname = \'$NMFSname\' };
my $sth = $dbh->prepare($sql)
                or die "Couldn't prepare statement: " . $dbh->errstr;
  $sth->execute
      or die "Can't execute SQL statement: $DBI::errstr\n";
  $stockid = $sth->fetchrow_array(  ) ;

my $assessid2 = $assessorid . "-" . $stockid . "-" . $assessyear . "-" . $recorder;

#print("$assessid2 \t $NMFSarray2{$assessid2}->[0] \t $NMFSarray2{$assessid2}->[1] \t $NMFSarray2{$assessid2}->[2] \t $NMFSarray2{$assessid2}->[3] \t $NMFSarray2{$assessid2}->[4] \n");

# find the total biomass time-series metric associated with the current stock
my $temp = $NMFSarray2{$assessid2}->[3];
$sql = qq{ SELECT tsunique FROM srdb.nmfstsmetrics WHERE NMFScategory = \'Bio_Units\' AND NMFSunit = \'$temp\' };


$sth = $dbh->prepare($sql)
                or die "Couldn't prepare statement: " . $dbh->errstr;
  $sth->execute
      or die "Can't execute SQL statement: $DBI::errstr\n";
  my $tsunique1 = $sth->fetchrow_array(  ) ;
my $sql1 = qq{ INSERT INTO srdb.timeseries VALUES(\'$assessid2\',\'$tsunique1\',$tsyear, $biomass) };
print("$sql1 \n");
$sth = $dbh->prepare( $sql1 );
$sth->execute();


# find the spawners time-series metric associated with the current stock
my $temp2 = $NMFSarray2{$assessid2}->[4];

$sql = qq{ SELECT tsunique FROM srdb.nmfstsmetrics WHERE NMFScategory = \'Spawn_Units\' AND NMFSunit = \'$temp2\' };
#print("$sql \n");
$sth = $dbh->prepare($sql)
                or die "Couldn't prepare statement: " . $dbh->errstr;
  $sth->execute
      or die "Can't execute SQL statement: $DBI::errstr\n";
  my $tsunique2 = $sth->fetchrow_array(  ) ;
$sql1 = qq{ INSERT INTO srdb.timeseries VALUES(\'$assessid2\',\'$tsunique2\',$tsyear, $spawners) };
print("$sql1 \n");
$sth = $dbh->prepare( $sql1 );
$sth->execute();

# find the catch time-series metric associated with the current stock
my $temp3 = $NMFSarray2{$assessid2}->[5];
$sql = qq{ SELECT tsunique FROM srdb.nmfstsmetrics WHERE NMFScategory = \'Catch_Units\' AND NMFSunit = \'$temp3\' };
#print("$sql \n");
$sth = $dbh->prepare($sql)
                or die "Couldn't prepare statement: " . $dbh->errstr;
  $sth->execute
      or die "Can't execute SQL statement: $DBI::errstr\n";
  my $tsunique3 = $sth->fetchrow_array(  ) ;
$sql1 = qq{ INSERT INTO srdb.timeseries VALUES(\'$assessid2\',\'$tsunique3\',$tsyear, $catch) };
print("$sql1 \n");
$sth = $dbh->prepare( $sql1 );
$sth->execute();


# find the recruit time-series metric associated with the current stock
my $temp4 = $NMFSarray2{$assessid2}->[6];
$sql = qq{ SELECT tsunique FROM srdb.nmfstsmetrics WHERE NMFScategory = \'Recruit_Units\' AND NMFSunit = \'$temp4\' };
# print("$sql \n");
$sth = $dbh->prepare($sql)
                or die "Couldn't prepare statement: " . $dbh->errstr;
  $sth->execute
      or die "Can't execute SQL statement: $DBI::errstr\n";
  my $tsunique4 = $sth->fetchrow_array(  ) ;
$sql1 = qq{ INSERT INTO srdb.timeseries VALUES(\'$assessid2\',\'$tsunique4\',$tsyear, $recruits) };
print("$sql1 \n");
$sth = $dbh->prepare( $sql1 );
$sth->execute();


# find the F time-series metric associated with the current stock
my $temp5 = $NMFSarray2{$assessid2}->[7];
$sql = qq{ SELECT tsunique FROM srdb.nmfstsmetrics WHERE NMFScategory = \'Fmort_Units\' AND NMFSunit = \'$temp5\' };
#print("$sql \n");
$sth = $dbh->prepare($sql)
                or die "Couldn't prepare statement: " . $dbh->errstr;
  $sth->execute
      or die "Can't execute SQL statement: $DBI::errstr\n";
  my $tsunique5 = $sth->fetchrow_array(  ) ;
$sql1 = qq{ INSERT INTO srdb.timeseries VALUES(\'$assessid2\',\'$tsunique5\',$tsyear, $Fmort) };
print("$sql1 \n");
$sth = $dbh->prepare( $sql1 );
$sth->execute();


# print("temps: $temp \t $temp2 \t $temp3 \t $temp4 \t $temp5 \n");

#print("$NMFSname \t $assessyear \t $tsyear \t $biomass \t $spawners \t $recruits \n");


  } # end loop over rows





$dbh->disconnect();
