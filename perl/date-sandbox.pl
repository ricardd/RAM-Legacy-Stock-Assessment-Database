#!/usr/bin/perl -w
# Perl code to test how to properly read dates from an Excel spreadsheet
# Last modified: Time-stamp: <2008-12-01 22:03:10 (ricardd)>
#

use strict;
use Spreadsheet::ParseExcel;

# this is the package that does the job, had to be installed using CPAN
use DateTime::Format::Excel;

use POSIX qw(strftime);

my($oExcel,$oBook,$iSheet,$oWkS,$date,$excel,$formateddate);
$excel = DateTime::Format::Excel->new();
$oExcel = new Spreadsheet::ParseExcel;

die "You must provide a filename to $0 to be parsed as an Excel file" unless @ARGV;

$oBook = $oExcel->Parse($ARGV[0]);
print("BEGIN\nProcessing the following Excel file: $ARGV[0] \n\n");

$iSheet=0;
 $oWkS = $oBook->{Worksheet}[$iSheet];
$date = $oWkS->{Cells}[1][1]->Value;
$formateddate = $excel->parse_datetime( $date )->ymd;
print("$date \n");
print("$formateddate \n");

$date = $oWkS->{Cells}[2][1]->Value;
$formateddate = $excel->parse_datetime( $date )->ymd;
print("$date \n");
print("$formateddate \n");

$date = $oWkS->{Cells}[3][1]->Value;
$formateddate = $excel->parse_datetime( $date )->ymd;
print("$date \n");
print("$formateddate \n");

$date = $oWkS->{Cells}[4][1]->Value;
$formateddate = $excel->parse_datetime( $date )->ymd;
print("$date \n");
print("$formateddate \n");


# OK, this works fine

