#!/usr/bin/perl -w
## generate an Excel file that is filled in using the database contents
## - this serves the purpose of generating a file to be used for updating a stock
## Last modified Time-stamp: <2011-02-28 16:07:13 (srdbadmin)>
use strict;
use warnings;
use DBI;
use Spreadsheet::ParseExcel;
use Spreadsheet::WriteExcel;
use POSIX qw(strftime);

die "Need to supply an assessid\n" if @ARGV <1;

my $assessid = $ARGV[0];
my $xlsfilename = $assessid . ".xls";

my $timestamp = strftime "%Y-%m-%d %H:%M:%S %Z", localtime;
my $stamp = "Created on " . $timestamp; 

# open a connection to the database
my $dbh = DBI->connect("dbi:Pg:dbname=srdb;host=localhost;port=5432;" ,
                      "srdbuser", "srd6us3r!")
		      || die "Database connection not made: $DBI::errstr";

# create dynamic spreadsheet that uses the assessid as its file name
my $workbook = Spreadsheet::WriteExcel->new($xlsfilename);
# Add 4 worksheets
$workbook->compatibility_mode();


$workbook->set_properties(
title    => 'Spreadsheet of database contents for stock assessment already loaded in RAM Legacy.',
author   => 'Daniel Ricard',
comments => 'Created with Perl and Spreadsheet::WriteExcel, with contents from the database',
);

my $sheet1 = $workbook->add_worksheet("meta");
my $sheet2 = $workbook->add_worksheet("biometrics");
my $sheet3 = $workbook->add_worksheet("timeseries");

my $format = $workbook->add_format(bold=>1, size=>12);

$sheet1->write(1, 0, ("This spreadsheet template was dynamically generated using the database contents on " . $timestamp), $format);

my $titlesql = qq{select ar.areaname, st.scientificname, assess.recorder, assess.dateloaded, assess.daterecorded,  st.scientificname,ar.areaID, (CASE WHEN q.issueurl IS NULL THEN 'no issueID' ELSE q.issueurl END), (CASE WHEN q.qaqc THEN 'YES' ELSE 'NO' END) as qaqc, (CASE WHEN q.dateapproved IS NOT NULL THEN q.dateapproved ELSE NULL END) as dateapproved, st.stocklong  from srdb.assessment as assess, srdb.area as ar, srdb.stock as st, srdb.qaqc q where q.assessid=assess.assessid and  assess.assessid=\'$assessid\' and st.stockid=assess.stockid and ar.areaID=st.areaID};

my $titlehandle = $dbh -> prepare($titlesql);
$titlehandle -> execute();
my @titleresult = $titlehandle->fetchrow_array();
$titlehandle->finish();
my $area=$titleresult[0];
my $sp=lc $titleresult[1];
my $rec=$titleresult[2];
my $dateloaded=$titleresult[3];
my $datein=$titleresult[4];
my $sciname=$titleresult[5];
my $areaid=$titleresult[6];
my $issueurl=$titleresult[7];
my $qaqc=$titleresult[8];
my $dateapproved=$titleresult[9];
my $stocklong=$titleresult[10];

print "Processing assessment: $assessid \n";
print "Scientific name: $sp \n";

$sheet1->write(3, 1, ("assessid"), $format);
$sheet1->write(3, 2, $assessid);

$sheet1->write(4, 1, ("stocklong"), $format);
$sheet1->write(4, 2, $stocklong);

$sheet1->write(5, 1, ("scientificname"), $format);
$sheet1->write(5, 2, $sp);

$sheet1->write(6, 1, ("assessor"), $format);

$sheet1->write(6, 1, ("recorder"), $format);
$sheet1->write(6, 2, $rec);

$sheet1->write(8, 1, ("LME primary"), $format);


$sheet2->write(1, 1, ("Reference points"), $format);
$sheet2->write(2, 1, (""), $format);


$sheet3->write(1, 1, ("Timeseries"), $format);
# bring back the timeseries
my $tssql = qq{select * from srdb.timeseries where assessid like \'$assessid\'};
my $tshandle = $dbh -> prepare($tssql);
$tshandle -> execute();

#my i=3;
#while (my @tsrow = $tshandle->fetchrow_array) {  # retrieve one row
#$sheet3->write(3,2,@tsrow);
#i=i+1;
#    }

$tshandle->finish();


#----------------
$dbh->disconnect();
