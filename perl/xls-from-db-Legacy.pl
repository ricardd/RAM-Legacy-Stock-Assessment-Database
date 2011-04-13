#!/usr/bin/perl -w
## generate an Excel file that is filled in using the database contents
## - this serves the purpose of generating a file to be used for updating a stock
## Last modified Time-stamp: <2011-04-12 15:32:48 (srdbadmin)>
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

my $titlesql = qq{
select ar.areaname, st.scientificname, assess.recorder, assess.dateloaded, assess.daterecorded,  st.scientificname,ar.areaID, (CASE WHEN q.issueurl IS NULL THEN 'no issueID' ELSE q.issueurl END), (CASE WHEN q.qaqc THEN 'YES' ELSE 'NO' END) as qaqc, (CASE WHEN q.dateapproved IS NOT NULL THEN q.dateapproved ELSE NULL END) as dateapproved, st.stocklong, st.stockid, am.category, am.methodshort, assess.assessorid  from srdb.assessment as assess, srdb.area as ar, srdb.stock as st, srdb.qaqc q, srdb.assessmethod am where q.assessid=assess.assessid and assess.assessid=\'$assessid\' and st.stockid=assess.stockid and ar.areaID=st.areaID and assess.assessmethod = am.methodshort};
#print("$titlesql \n");
my $titlehandle = $dbh -> prepare($titlesql);
$titlehandle -> execute();
my @titleresult = $titlehandle->fetchrow_array();

$titlehandle->finish();
my $area=$titleresult[0];
my $sp=$titleresult[1];
my $rec=$titleresult[2];
my $dateloaded=$titleresult[3];
my $datein=$titleresult[4];
my $sciname=$titleresult[5];
my $areaid=$titleresult[6];
my $issueurl=$titleresult[7];
my $qaqc=$titleresult[8];
my $dateapproved=$titleresult[9];
my $stocklong=$titleresult[10];
my $stockid=$titleresult[11];
my $assesscat=$titleresult[12];
my $assessmet=$titleresult[13];
my $assessorid=$titleresult[14];

print "Processing assessment: $assessid \n";
print "Scientific name: $sp \n";

#$sheet1->write(3, 1, ("assessid"), $format);
#$sheet1->write(3, 2, $assessid);

$sheet1->write(3, 1, ("Stock ID"), $format);
$sheet1->write(3, 2, $stockid);

$sheet1->write(4, 1, ("Stock long"), $format);
$sheet1->write(4, 2, $stocklong);

$sheet1->write(5, 1, ("Scientific Name"), $format);
$sheet1->write(5, 2, $sp);

$sheet1->write(6, 1, ("Assessor"), $format);
$sheet1->write(6, 2, $assessorid);


$sheet1->write(7, 1, ("Assessment method category"), $format);
$sheet1->write(7, 2, $assesscat);

$sheet1->write(8, 1, ("Assessment method"), $format);
$sheet1->write(8, 2, $assessmet);


$sheet1->write(9, 1, ("Recorder"), $format);
$sheet1->write(9, 2, $rec);

$sheet1->write(10, 1, ("Date recorded"), $format);
$sheet1->write(10, 2, $datein);


$sheet1->write(12, 1, ("LME primary"), $format);

$sheet1->write(13, 1, ("Reference document"), $format);

## second worksheet
$sheet2->write(1, 1, ("Time-series details"), $format);
$sheet2->write(2, 1, (""), $format);

$sheet2->write(4, 1, ("Reference points"), $format);
$sheet2->write(5, 1, (""), $format);

$sheet2->write(7, 1, ("Life-history"), $format);
$sheet2->write(8, 1, (""), $format);

$sheet3->write(1, 1, ("Timeseries"), $format);
$sheet3->write(2, 1, ("tsyear"));

# bring back the timeseries, one at a time and write each column separately

my $c = 2;
## loop over timeseries
my $tssql = qq{select distinct(tsid) from srdb.timeseries where assessid like \'$assessid\'};
my $tshandle = $dbh -> prepare($tssql);
$tshandle -> execute();
while (my $tsid = $tshandle->fetchrow_array) {
print("\t $tsid \t");
$sheet3->write(2,$c,$tsid);
$c=$c+1;
} ## end loop over timeseries

$tshandle->finish();

my $r = 3;
## loop over available years
my $yrsql = qq{select distinct(tsyear) from srdb.timeseries where assessid like \'$assessid\' order by tsyear};
my $yrhandle = $dbh -> prepare($yrsql);
$yrhandle -> execute();
while (my $yr = $yrhandle->fetchrow_array) {
# print("$yr \t");
$sheet3->write($r,1,$yr);
## loop over timeseries
my $tssql = qq{select distinct(tsid) from srdb.timeseries where assessid like \'$assessid\'};
my $tshandle = $dbh -> prepare($tssql);
$tshandle -> execute();
my $c = 2;
while (my $tsid = $tshandle->fetchrow_array) {
my $valsql = qq{select tsvalue from srdb.timeseries where assessid like \'$assessid\' and tsid = \'$tsid\' and tsyear = $yr};
## (CASE WHEN tsvalue IS NULL THEN \'NULL\' ELSE to_char(tsvalue, \'9999.99\') END) as
my $valhandle = $dbh -> prepare($valsql);
$valhandle -> execute();
print("$r\t$c\n");
$sheet3->write($r,$c,$valhandle->fetchrow_array);
$c=$c+1;
$valhandle -> finish();
}
## end loop over timeseries

# print("\n");
$r=$r+1;
 } ## end loop over years
 $yrhandle->finish();




#----------------
$dbh->disconnect();
