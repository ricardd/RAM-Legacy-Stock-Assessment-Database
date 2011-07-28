#!/usr/bin/perl -w
# script to input a single spreadsheet file in the srDB
# Last modified: Time-stamp: <2011-07-25 11:54:13 (srdbadmin)>
# Daniel Ricard
# 2008-02-12: modifications to accomodate Excel template v2
# 2008-02-19: modifications to accomodate Excel template v3
# 2008-04-07: modifications to accomodate Excel template v4 (biometrics sheet now has all possible values)
# 2008-06-02: modifications to accomodate Excel template v4.2 (removed redundancies in species name and TSN)
# 2008-07-17: the cells read for "assessmethod" and "assesscomments" were wrong, fixed that
# 2008-08-25: editing script so that each assessment is processed as a batch using "BEGIN" and "COMMIT"
# 200-11-27: adding code to INSERT reference document data into appropriate tables
# 2008-12-02: adding code to correctly handle the date format coming from Excel, needs the "use DateTime::Format::Excel" package. had to be installed from CPAN
# 2009-03-13: some spreadsheet's biometrics start at row 6, some at row 7, modifying code to handle both, values were not being translated to SQL INSERT statements
# 2009-09-29: again, had to reinstall the "DateTime::Format::Excel" package from cpan (sudo cpan DateTime::Format::Excel)
# 2011-05-03: edits to capture the addition of a "mostrecent" column in srdb.assessment
# 2011-06-24: commenting out the call to psql and adding code so that the script returns the assessid that is created, so that we can assemble a bash script at the other end with appropriate psql calls 
use strict;
use Spreadsheet::ParseExcel;
#use DateTime::Format::Excel;
use POSIX qw(strftime);
use DBI;
#my $dbh = DBI->connect('dbi:Pg:dbname=gfsDB;host=localhost;port=5433','ricardd','ricardd')|| die "Database connection not made: $DBI::errstr";
#my $dbh = DBI->connect('dbi:Pg:dbname=srDB;host=localhost;port=5432','ricardd','ricardd')|| die "Database connection not made: $DBI::errstr";
#my $dbh = DBI->connect('dbi:Pg:dbname=srdb;host=localhost;port=5432','ricardd','ricardd')|| die "Database connection not made: $DBI::errstr";
#my $dbh = DBI->connect('dbi:Pg:dbname=srdb;host=localhost;port=5435','srdbadmin','srd6adm1n!')|| die "Database connection not made: $DBI::errstr";
my $dbh = DBI->connect('dbi:Pg:dbname=srdb;host=localhost;port=5432','srdbadmin','srd6adm1n!')|| die "Database connection not made: $DBI::errstr";

my $oExcel = new Spreadsheet::ParseExcel;

die "You must provide a filename to $0 to be parsed as an Excel file" unless @ARGV;

my $oBook = $oExcel->Parse($ARGV[0]);

#print "COUNT :", $oBook->{SheetCount} , "\n";

#die "The spreadsheet does not have 3 worksheets" unless $oBook->{SheetCount} == 3;
#die "The spreadsheet does not have 4 worksheets" unless $oBook->{SheetCount} == 4;

#print("BEGIN\nProcessing the following Excel file: $ARGV[0] \n\n");

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

#print(" $oWkS->{MinRow} \n");
#print(" $oWkS->{MaxRow} \n");
#print(" $oWkS->{MinCol} \n");
#print(" $oWkS->{MaxCol} \n");

$assessyear = ($oWkS->{Cells}[$oWkS->{MinRow}+8][2]->Value) . "-" . ($oWkS->{Cells}[$oWkS->{MaxRow}][2]->Value) ;
# print ("$assessyear\n");
#$oWkS->{MaxRow} \n"



#####################################################
# meta sheet
$iSheet=1;
 $oWkS = $oBook->{Worksheet}[$iSheet];
die "Second worksheet must be called meta" unless $oWkS->{Name} eq "meta"; 

$assessorid = $oWkS->{Cells}[10][3]->Value;
$stockid = $oWkS->{Cells}[12][3]->Value;
$recorder = $oWkS->{Cells}[17][3]->Value;
$daterecorded = $oWkS->{Cells}[18][3]->Value;

#print("$daterecorded \n");
#$excel = DateTime::Format::Excel->new();
#print($daterecorded);
#$formatteddaterecorded = $excel->parse_datetime( $daterecorded )->ymd;
$formatteddaterecorded = $daterecorded;

#$assessyear = $oWkS->{Cells}[2][2]->Value;

# TEMPORARY FAKE VALUE
# $assessyear = 2134;

$assesssource = $oWkS->{Cells}[21][3]->Value;
$contacts = $oWkS->{Cells}[22][3]->Value;
$notes = $oWkS->{Cells}[23][3]->Value;
if($oWkS->{Cells}[24][3]) {$pdffile = $oWkS->{Cells}[24][3]->Value;}
else {$pdffile = "NULL";}

$assess = $oWkS->{Cells}[25][3]->Value;
$refpoints = $oWkS->{Cells}[26][3]->Value;
$assessmethod = $oWkS->{Cells}[28][3]->Value;
$assesscomments = $oWkS->{Cells}[29][3]->Value;

$assessid = $assessorid . "-" . $stockid . "-" . $assessyear . "-" . $recorder;

$dateloaded = strftime "%Y-%m-%d %H:%M:%S", localtime;

#my $sqlassessment = qq{ INSERT INTO srdb.assessment VALUES(\'$assessid\', \'$assessorid\', \'$stockid\', \'$recorder\', \'$daterecorded\', \'$dateloaded\', \'$assessyear\', \'$assesssource\', \'$contacts\', \'$notes\', \'$pdffile\', $assess, $refpoints, \'$assessmethod\', \'$assesscomments\') };
my $sqlassessment = qq{ INSERT INTO srdb.assessment VALUES(\'$assessid\', \'$assessorid\', \'$stockid\', \'$recorder\', \'$formatteddaterecorded\', \'$dateloaded\', \'$assessyear\', \'$assesssource\', \'$contacts\', \'$notes\', \'$pdffile\', $assess, $refpoints, \'$assessmethod\', \'$assesscomments\', \'$xlsfilename\', \'$mostrecent\') };
# print "$sqlassessment\n";

print SQLFILE "$sqlassessment; \n";

# now loop over RIS fields and create INSERT statements for the reference document
my ($sqlrisdata,$risfield,$risvalue);

#print(" $oWkS->{MinRow} \n");
#print(" $oWkS->{MaxRow} \n");
#print(" $oWkS->{MinCol} \n");
#print(" $oWkS->{MaxCol} \n");

for($iR = 32; defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow}; $iR++)
  {
$risfield = $oWkS->{Cells}[$iR][2]->Value;
$risvalue = $oWkS->{Cells}[$iR][3]->Value;
$sqlrisdata = qq{ INSERT INTO srdb.referencedoc VALUES(\'$assessid\', \'$risfield\', \'$risvalue\') };
#print("$iR \t $risfield \t $risvalue \n");
print SQLFILE "$sqlrisdata; \n";
} # end loop over RIS fields

# add the assessid as the field value for a field called "zzid"
$sqlrisdata = qq{ INSERT INTO srdb.referencedoc VALUES(\'$assessid\', \'ZZID\', \'$assessid\') };
print SQLFILE "$sqlrisdata; \n";


# load data into the assessment table
#my $sth = $dbh->prepare( $sqlassessment );
#die "Could not load the assessment metadata.\nExiting without any changes to the database.\n\n" unless $sth->execute();

# print "Assessment metadata loaded successfully.\n";

# biometrics sheet
$iSheet=2;
 $oWkS = $oBook->{Worksheet}[$iSheet];
 die "Third worksheet must be called biometrics" unless $oWkS->{Name} eq "biometrics"; 
# variables for table srdb.bioparams
my ($sqlbiometrics, $biounique, $bioid, $bioyr, $biounits, $biovalue, $bionotes); #, $biounique


# determine whether the biometric values start at row 5 or row 7 and establish to correct bounds for the loop over rows that follows
my ($startrow, $endrow);

if(defined $oWkS->{Cells}[5][0]) {
#print("cell 5 0 defined");
$startrow = $oWkS->{MinRow}+6;
$endrow = $oWkS->{MaxRow};
}
else {
$startrow = $oWkS->{MinRow}+5;
$endrow = $oWkS->{MaxRow};
}

#print("$startrow \t $endrow  \n");

#print(" $oWkS->{MinRow} \n");
#print(" $oWkS->{MaxRow} \n");
#print(" $oWkS->{MinCol} \n");
#print(" $oWkS->{MaxCol} \n");

#for($iR = $oWkS->{MinRow}+6; defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow}; $iR++)
for($iR = $startrow; $iR <= $endrow; $iR++)
  {
$bioid = $oWkS->{Cells}[$iR][1]->Value;
$biounits = $oWkS->{Cells}[$iR][3]->Value;
$biovalue = $oWkS->{Cells}[$iR][5]->Value;
if($oWkS->{Cells}[$iR][6]) {$bionotes = $oWkS->{Cells}[$iR][6]->Value;}; # else {$bionotes = "NULL"};
$bioyr = $oWkS->{Cells}[$iR][7]->Value;
$biounique = $bioid . "-" . $biounits;

#print("$iR $bioid $biounits $biovalue $bioyr \n");
#$sqlbiometrics = qq{ INSERT INTO srdb.bioparams VALUES(\'$assessid\',\'$biounique\',\'$biovalue\', \'$bionotes\', \'$bioyr\') };
$sqlbiometrics = qq{ INSERT INTO srdb.bioparams VALUES(\'$assessid\',\'$biounique\',\'$biovalue\', \'$bioyr\', \'$bionotes\') };
print SQLFILE "$sqlbiometrics; \n";
#print "$sqlbiometrics\n";
#my $sth = $dbh->prepare( $sqlbiometrics ); 
#$sth->execute();

#print("$iR $bioid $biounits $biovalue \n");
#print("$iR $bioid $biovalue \n");
  } # end loop over rows 

#print("Loop over rows finished \n");

# old code for version 3 spreadsheet
#  for($iC = $oWkS->{MinCol}+2;
#      defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ;
#      $iC++)
#  {
#$bioid = $oWkS->{Cells}[2][$iC]->Value;
#$biounits = $oWkS->{Cells}[3][$iC]->Value;
#$biovalue = $oWkS->{Cells}[4][$iC]->Value;
#$bioyr = $oWkS->{Cells}[5][$iC]->Value;
#$biounique = $bioid . "-" . $biounits;

#$biounique = $bioid . "-" . $biounits;
## print("$iC $bioid $biounits $biovalue\n");
#$sqlbiometrics = qq{ INSERT INTO srdb.bioparams VALUES(\'$assessid\',\'$biounique\',\'$biovalue\', \'$bioyr\') };
#print "$sqlbiometrics\n";
#my $sth = $dbh->prepare( $sqlbiometrics );
#$sth->execute();
#  }
# print "Biometrics loaded successfully.\n";

# timeseries sheet
# variables for time-series
my ($sqltimeseries, $tsmetric, $tsunit, $tsyr, $tsvalue, $tsunique);

$iSheet=3;
 $oWkS = $oBook->{Worksheet}[$iSheet];
 die "Fourth worksheet must be called timeseries" unless $oWkS->{Name} eq "timeseries"; 

#print(" $oWkS->{MinRow} \n");
#print(" $oWkS->{MaxRow} \n");
#print(" $oWkS->{MinCol} \n");
#print(" $oWkS->{MaxCol} \n");

for($iC = $oWkS->{MinCol}+3;
      defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ;
      $iC++)
  {

    for($iR = $oWkS->{MinRow}+8;
      defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ;
      $iR++)

      {
	
	$tsmetric = $oWkS->{Cells}[6][$iC]->Value;

	$tsunit = $oWkS->{Cells}[7][$iC]->Value;
	$tsyr = $oWkS->{Cells}[$iR][2]->Value;
	$tsvalue  = $oWkS->{Cells}[$iR][$iC]->Value;
	$tsunique = $tsmetric . "-" . $tsunit;
	#print("$tsmetric $tsyr $tsvalue\n");
	$sqltimeseries = qq{ INSERT INTO srdb.timeseries VALUES(\'$assessid\',\'$tsunique\',$tsyr, $tsvalue) };
	print SQLFILE "$sqltimeseries; \n";
	#print("$iC $iR \n");

	#print "$sqltimeseries\n";
	#my $sth = $dbh->prepare( $sqltimeseries );
	#$sth->execute();
      } # end loop across rows
  }

# print "Time-series loaded successfully.\n";

#$assessyear 

  # end loop across columns



# load data into the biometrics table

# load data into the timeseries table



$dbh->disconnect();
#####################################################



#print "\nDatetime stamp for database input: $dateloaded \n $ARGV[0] \nEND\n\n\n\n";
print "$sqlfile 2> $sqllogfile \n";

print SQLFILE "COMMIT;";
close SQLFILE;

# send the batch file to postgresql 
#my @sqlcall =`psql srDB -f $sqlfile 2> $sqllogfile`;
#my @sqlcall =`psql srdb -f $sqlfile 2> $sqllogfile`;
#my @sqlcall =`/usr/lib/postgresql/8.4/bin/psql srdb -p 5435 -f $sqlfile 2> $sqllogfile`;
