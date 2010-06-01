#!/usr/bin/perl -w
# script to input RAM's original sr data into the srdb database
# Daniel Ricard, started 2008-08-22
#
# Last modified Time-stamp: <2009-03-19 18:45:08 (ricardd)>
# Modification history:
# 2008-10-14: the "chomp" function needs not be used in an assignment, invocation is sufficient to remove trailing newline
# 2009-03-12: some long overdue work on this to also include biometrics values, up until now, only time-series were translated to SQL
# 2009-03-19: adding comments and notes to the srdb.assessment table, this required some regexpr statements to remove the LaTex {\em }
# data was obtained from sftp://ram.biology.dal.ca/autofs/auto/data-blade/users/data/sr/data/ and copied to /home/ricardd/linux_sync_folder/SQL/SQLpg/srDB/RAMdata/

use strict;
use DBI;
use POSIX qw(strftime);

# connect to srDB
my $dbh = DBI->connect('dbi:Pg:dbname=srdb;host=localhost;port=5432','ricardd','ricardd')|| die "Database connection not made: $DBI::errstr";

my $sqlfile = "RAM-orig.sql";
my $sqllogfile = "RAM-orig.log";
open SQLFILE, ">$sqlfile" or die $!;
open UNITSFILE, ">RAMunits.txt" or die $!;


# obtain a list of all the stocks that have a .doc file
my(@docfiles,$docfile,@datfiles,$datfile,$docinfile,$datinfile);
opendir(DIR, "../RAMdata");
#opendir(DIR, "../RAMdatatest");
@docfiles = grep(/\.doc$/,readdir(DIR));

@datfiles = grep(/\.dat$/,readdir(DIR));
closedir(DIR);

my ($assessid, $assessorid, $stockid, $recorder, $daterecorded, $dateloaded, $assessyear, $assesssource, $contacts, $notes, $pdffile, $assess, $refpoints, $assessmethod, $assesscomments , @raw_doc_data, @raw_dat_data, $sciname, $family, $order, $stock, $source, $comments, $fage, $agerecdat, $temp, $temp1, $unitssb, $unitrec, $unitland, $units, $natmort, $f01, $fmax, $fmed);

$recorder = "MYERS";
$assessorid = "RAM";
$daterecorded = "2007-03-27";
# $daterecorded = "33333";
$dateloaded = strftime "%Y-%m-%d %H:%M:%S", localtime;
$assesssource = "RAMoriginal";
$contacts = "RAMoriginal";
$notes = "this assessment was translated from RAM original data";
$pdffile = "NULL";
$assess = 1; # "PHONYassess";
$refpoints = 1; # "PHONYrefpoint";

$assesscomments = "none";


foreach $docfile (@docfiles) {
  $docinfile = "../RAMdata/$docfile";
#  $docinfile = "../RAMdatatest/$docfile";
#print("$docinfile \n");

  my $t = substr ($docfile, 0, rindex($docfile, ".doc")) . ".dat"; # create name of the .dat file using the name of the .doc file
  $datfile = "$t";
  $datinfile = "../RAMdata/$datfile";
#  $datinfile = "../RAMdatatest/$datfile";

open(DOC, $docinfile) || die("Could not open file $docinfile!");
@raw_doc_data=<DOC>;
open(DAT, $datinfile) || die("Could not open file $datinfile!");
@raw_dat_data=<DAT>;



$temp = $raw_dat_data[$#raw_dat_data]; # last line of the file
$temp =~ s/^\s+//; # remove leading whitespaces
$temp = substr ($temp,0,4); # keep only the year

$temp1 = $raw_dat_data[0];# first line of the file
$temp1 =~ s/^\s+//; # remove leading whitespaces
$temp1 = substr ($temp1,0,4); # keep only the year

$assessyear = $temp1 . "-" . $temp;
#print("$assessyear \t $datinfile \n");

  my $stockid = substr ($docfile, 0, rindex($docfile, "."));
  my $sqlstock = qq{ select stockid, commonname from srdb.stock where stockid=\'$stockid\' };
  $assessid = $assessorid . "-" . $stockid . "-" . $assessyear . "-" . $recorder;
  #print "$assessid\n";

$sciname = substr ($raw_doc_data[2], rindex($raw_doc_data[2], "@")+2,100);
chomp $sciname;
$family = substr ($raw_doc_data[3], rindex($raw_doc_data[3], "@")+2,100);

$order = substr ($raw_doc_data[5], rindex($raw_doc_data[5], "@")+2,100);
$stock = substr ($raw_doc_data[6], rindex($raw_doc_data[6], "@")+2,100);
chomp $stock;
$source = substr ($raw_doc_data[7], rindex($raw_doc_data[7], "@")+2,1000);
#print("$source \n");
chomp $source;
$source =~ s/'/''/; # replace single quotes with 2 single quotes, otherwise the SQL will choke
#print("$source \n");
$source =~ s/{\\em /(/; # replace all occurence of LaTex "{\em...}" with a space, otherwise the SQL will choke 
$source =~ s/{\\it /(/; # replace all occurence of LaTex "{\it...}" with a space, otherwise the SQL will choke 
$source =~ s/}/)/;
#print("$source \n");

$comments = substr ($raw_doc_data[8], rindex($raw_doc_data[8], "@")+2,1000);
chomp $comments;
$comments =~ s/'/''/; # replace single quotes with 2 single quotes, otherwise the SQL will choke
if($comments eq '.') {$comments = 'NULL';};
#print("$comments \n");

$fage = substr ($raw_doc_data[9], rindex($raw_doc_data[9], "@")+2,1000);
chomp $fage;

$unitssb = substr ($raw_doc_data[11], rindex($raw_doc_data[11], "@")+2,100);
chomp $unitssb;
$unitrec = substr ($raw_doc_data[12], rindex($raw_doc_data[12], "@")+2,100);
chomp $unitrec;
$agerecdat = substr ($raw_doc_data[13], rindex($raw_doc_data[13], "@")+2,100);
chomp $agerecdat;
$unitland = substr ($raw_doc_data[14], rindex($raw_doc_data[14], "@")+2,100);
chomp $unitland;
$natmort = substr ($raw_doc_data[23], rindex($raw_doc_data[23], "@")+2,100);
chomp $natmort;

$f01  = substr ($raw_doc_data[24], rindex($raw_doc_data[24], "@")+2,100);
chomp $f01;
$fmax  = substr ($raw_doc_data[25], rindex($raw_doc_data[25], "@")+2,100);
chomp $fmax;
$fmed  = substr ($raw_doc_data[26], rindex($raw_doc_data[26], "@")+2,100);
chomp $fmed;

print UNITSFILE "$sciname \t $stock \t $unitssb \t $unitrec \t $unitland \n";

#print "$unitssb \t $unitrec \t $unitland \n";

$assessmethod = substr ($raw_doc_data[10], rindex($raw_doc_data[10], "@")+2,100);
chomp $assessmethod;
$assessmethod =~ s/\s+$//;

#my $sqlassessment = qq{ INSERT INTO srdb.assessment VALUES(\'$assessid\', \'$assessorid\', \'$stockid\', \'$recorder\', \'$daterecorded\', \'$dateloaded\', \'$assessyear\', \'$assesssource\', \'$contacts\', \'$notes\', \'$pdffile\', $assess, $refpoints, \'$assessmethod\', \'$assesscomments\') };
my $sqlassessment = qq{ INSERT INTO srdb.assessment VALUES(\'$assessid\', \'$assessorid\', \'$stockid\', \'$recorder\', \'$daterecorded\', \'$dateloaded\', \'$assessyear\', \'$assesssource\', \'$contacts\', \'$notes\', \'$pdffile\', $assess, $refpoints, \'$assessmethod\', \'$assesscomments\') };

#print "$sqlassessment\n";
print SQLFILE "BEGIN;\n";
print SQLFILE "$sqlassessment; \n";

# SQL for biometrics
#if($natmort ne '.') {
if($natmort != '.') {
  my $biometric = qq{ INSERT INTO srdb.bioparams VALUES(\'$assessid\',\'NATMORT-1/yr\', $natmort, $temp) };
   print SQLFILE "$biometric; \n";
 }


#if($f01 ne '.') {
if($f01 != '.') {
#  print("F01 $f01 \n");
  my $biometric = qq{ INSERT INTO srdb.bioparams VALUES(\'$assessid\',\'F0.1-1/yr\', $f01, $temp) };
   print SQLFILE "$biometric; \n";
 }

#if($fmax ne '.') {
if($fmax != '.') {
  my $biometric = qq{ INSERT INTO srdb.bioparams VALUES(\'$assessid\',\'Fmax-1/yr\', $fmax, $temp) };
   print SQLFILE "$biometric; \n";
 }

#if($fage ne '.') {
if($fage != '.') {
  my $biometric = qq{ INSERT INTO srdb.bioparams VALUES(\'$assessid\',\'F-AGE-yr-yr\', \'$fage\', $temp) };
   print SQLFILE "$biometric; \n";
 }



# now load time-series data
my ($iR, $datR, @datsR, $sqtimeseries );
for($iR = 0; $iR<= ($temp-$temp1); $iR++)
  {
$datR = $raw_dat_data[$iR];
chomp $datR;

$datR =~ s/^\s+//; # remove leading whitespaces
# $datR =~ s/\s\.\s /1, /g; # replace dots with 'NULL'
$datR =~ s/\s+/, /g; # replace whitespaces by a comma

@datsR = split(",", $datR); # split into an array on commas

#print "$datR \n";

#print "$datsR[0] \t $datsR[1] \t $datsR[2] \t $datsR[3] \t $datsR[4] \t \n";

# find srDB units
# NOTE: IF THE UNITS ARE NOT RECOGNISED, DON'T WRITE AN SQL INSERT STATEMENT

my $sqlunits = qq{ SELECT tsunitsshort FROM srdb.ramunits WHERE ramcat= \'UNITSSB\' AND ramunits=\'$unitssb\'};
my $sth = $dbh->prepare( $sqlunits ); 
$sth->execute();
$units = $sth->fetchrow_array(  ) ;
#print "$sqlunits \n";
if ($datsR[1] == '.' ) {$datsR[1] = "NULL"};
if ($units) {
    $sqtimeseries = qq{ INSERT INTO srdb.timeseries VALUES(\'$assessid\',\'$units\',$datsR[0],$datsR[1]) };
    print SQLFILE "$sqtimeseries; \n";
  };

$sqlunits = qq{ SELECT tsunitsshort FROM srdb.ramunits WHERE ramcat= \'UNITREC\' AND ramunits=\'$unitrec\'};
$sth = $dbh->prepare( $sqlunits ); 
$sth->execute();
$units = $sth->fetchrow_array(  ) ;
if ($datsR[2] == '.' ) {$datsR[2] = "NULL"};

if ($units) {
  $sqtimeseries = qq{ INSERT INTO srdb.timeseries VALUES(\'$assessid\',\'$units\',$datsR[0],$datsR[2]) };
  print SQLFILE "$sqtimeseries; \n";
};

$sqlunits = qq{ SELECT tsunitsshort FROM srdb.ramunits WHERE ramcat= \'UNITLAND\' AND ramunits=\'$unitland\'};
$sth = $dbh->prepare( $sqlunits ); 
$sth->execute();
$units = $sth->fetchrow_array(  ) ;
if ($datsR[3] == '.' ) {$datsR[3] = "NULL"};
if ($units) {
  $sqtimeseries = qq{ INSERT INTO srdb.timeseries VALUES(\'$assessid\',\'$units\',$datsR[0],$datsR[3]) };
  print SQLFILE "$sqtimeseries; \n";
};

if ($datsR[4] == '.' ) {$datsR[4] = "NULL"};
$sqtimeseries = qq{ INSERT INTO srdb.timeseries VALUES(\'$assessid\',\'F-1/T\',$datsR[0],$datsR[4]) };
print SQLFILE "$sqtimeseries; \n";
# SSB   REC   LAND   FRPL

  } # end for loop over years

print SQLFILE "COMMIT; \n";
close(DOC);

}

close SQLFILE;
close UNITSFILE;

# send the batch file to postgresql 
#my @sqlcall =`psql srdb -f $sqlfile 2> $sqllogfile`;

# disconnect from srDB
$dbh->disconnect();
