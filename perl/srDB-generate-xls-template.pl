#!/usr/bin/perl -w
# script to 
# Daniel Ricard
# Started: 2009-05-04
# Time-stamp: <2009-05-13 12:30:55 (ricardd)>
# Modification history:
# 2009-05-13: it turns out, I was using an outdated version of the Spreadsheet::WriteExcel module and upgrading it to the latest version fixed the earlier messages when uing "set_properties"

use strict;
use warnings;
use DBI;
use Spreadsheet::ParseExcel;
use Spreadsheet::WriteExcel;
use POSIX qw(strftime);

my $datetime = strftime "%Y-%m-%d %H:%M:%S %Z", localtime;

# open a connection to the database
my $dbh = DBI->connect("dbi:Pg:dbname=srdb;host=localhost;port=5432;" ,
                      "srdbuser", "srd6us3r!")
		      || die "Database connection not made: $DBI::errstr";

# open the static spreadsheet template to get the blah blah
my $oExcel = new Spreadsheet::ParseExcel;
my $oBook = $oExcel->Parse("../spreadsheets/srDB-spreadsheet-template-v4.3.xls");
my ($oWkS, $dd);
$oWkS = $oBook->{Worksheet}[0];

$dd = ($oWkS->{Cells}[0][0]->Value);

# create dynamic spreadsheet
my $workbook = Spreadsheet::WriteExcel->new("srdb-template-dynamic.xls");
# Add 4 worksheets
$workbook->compatibility_mode();

my $sheet1 = $workbook->add_worksheet("instructions");


$workbook->set_properties(
title    => 'This is the spreadsheet template used for capturing stock assessment data for inclusion in the stock-recruitment database',
author   => 'Daniel Ricard',
comments => 'Created with Perl and Spreadsheet::WriteExcel, with contents from the database',
);


my $format = $workbook->add_format(bold=>1, size=>12, bg_color=>'yellow');
$sheet1->write(0, 0, $dd, $format);
$sheet1->write(0, 1, "", $format);

$format = $workbook->add_format(bold=>1,bg_color=>27,size=>11);

$dd = ($oWkS->{Cells}[1][0]->Value);
$sheet1->write(1, 0, $dd, $format);
$sheet1->write(1, 1, "", $format);


$format = $workbook->add_format(bold=>1,bg_color=>27,color=>'blue', underline=>1);
$dd = ($oWkS->{Cells}[2][0]->Value);
$sheet1->write(2, 0, $dd, $format);
$sheet1->write(2, 1, "", $format);

$format = $workbook->add_format(color=>'black', bg_color=>27, underline=>0, bold=>1);

$dd = ($oWkS->{Cells}[3][0]->Value);
$sheet1->write(3, 0, $dd, $format);
$sheet1->write(3, 1, "", $format);

$format = $workbook->add_format();
$format->set_bg_color('yellow');

$format = $workbook->add_format();
$format->set_bg_color('none');

#$format->set_text_wrap();
$sheet1->set_column(1,1,130);

$format = $workbook->add_format(color=>'black', underline=>1, bold=>1, text_wrap=>1);
$dd = ($oWkS->{Cells}[4][1]->Value);
$sheet1->write(4, 1, $dd, $format);

$format = $workbook->add_format(color=>'black', underline=>0, bold=>0, text_wrap=>1);
$dd = ($oWkS->{Cells}[5][1]->Value);
$sheet1->write(5, 1, $dd, $format);

$dd = ($oWkS->{Cells}[6][1]->Value);
$sheet1->write(6, 1, $dd, $format);

$dd = ($oWkS->{Cells}[7][1]->Value);
$sheet1->write(7, 1, $dd, $format);

$dd = ($oWkS->{Cells}[8][1]->Value);
$sheet1->write(8, 1, $dd, $format);

$format = $workbook->add_format(color=>'black', underline=>1, bold=>1, text_wrap=>1);
$dd = ($oWkS->{Cells}[10][1]->Value);
$sheet1->write(10, 1, $dd, $format);

$format = $workbook->add_format(color=>'black', underline=>0, bold=>0, text_wrap=>1);
$dd = ($oWkS->{Cells}[11][1]->Value);
$sheet1->write(11, 1, $dd, $format);

$dd = ($oWkS->{Cells}[12][1]->Value);
$sheet1->write(12, 1, $dd, $format);

$dd = ($oWkS->{Cells}[13][1]->Value);
$sheet1->write(13, 1, $dd, $format);

$dd = ($oWkS->{Cells}[14][1]->Value);
$sheet1->write(14, 1, $dd, $format);

$dd = ($oWkS->{Cells}[15][1]->Value);
$sheet1->write(15, 1, $dd, $format);

$dd = ($oWkS->{Cells}[16][1]->Value);
$sheet1->write(16, 1, $dd, $format);

$dd = ($oWkS->{Cells}[17][1]->Value);
$sheet1->write(17, 1, $dd, $format);

$format = $workbook->add_format(bg_color=>27, color=>'black', underline=>0, bold=>1, text_wrap=>1);

$dd = ($oWkS->{Cells}[18][1]->Value);
$sheet1->write(18, 1, $dd, $format);

$format = $workbook->add_format(bg_color=>'none', color=>'black', underline=>0, bold=>1, size=>24);

$dd = ($oWkS->{Cells}[19][1]->Value);
$sheet1->write(19, 1, $dd, $format);



my $sheet2 = $workbook->add_worksheet("meta");
$oWkS = $oBook->{Worksheet}[1];

$format = $workbook->add_format(bold=>1, size=>12, bg_color=>'yellow');

$dd = ($oWkS->{Cells}[0][0]->Value);
$sheet1->write(0, 0, $dd, $format);

$format = $workbook->add_format();
$format->set_bg_color('none');

$sheet2->write(0, 0, $dd, $format);
$sheet2->write(1, 0, ("This spreadsheet template was dynamically generated using the database contents on " . $datetime), $format);


$format = $workbook->add_format();
$format->set_bg_color('yellow');

$dd = ($oWkS->{Cells}[3][0]->Value);
$sheet2->write(3, 0, $dd, $format);

$format = $workbook->add_format();
$format->set_bg_color('orange');

$dd = ($oWkS->{Cells}[4][0]->Value);
$sheet2->write(4, 0, $dd, $format);

$format = $workbook->add_format();
$format->set_bg_color('none');
$format->set_color('red');

$dd = ($oWkS->{Cells}[5][0]->Value);
$sheet2->write(5, 0, $dd, $format);

$format = $workbook->add_format(color=>'black');

$dd = ($oWkS->{Cells}[6][0]->Value);
$sheet2->write(6, 0, $dd, $format);

$sheet2->write(8, 2, "Field name", $format);
$sheet2->write(8, 3, "Example value", $format);
$sheet2->write(8, 4, "Instructions", $format);

$sheet2->write(10, 2, "assessorid", $format);
$sheet2->write(12, 2, "stockid", $format);
$sheet2->write(13, 2, "Sciname", $format);
$sheet2->write(14, 2, "Comname", $format);
$sheet2->write(15, 2, "areaID", $format);

$sheet2->write(17, 2, "recorder", $format);
$sheet2->write(18, 2, "daterecorded", $format);

$sheet2->write(20, 1, "Information about the assessment", $format);

$sheet2->write(21, 2, "assesssource", $format);
$sheet2->write(22, 2, "contacts", $format);
$sheet2->write(23, 2, "notes", $format);

$sheet2->write(25, 2, "assess", $format);
$sheet2->write(26, 2, "refpoints", $format);
$sheet2->write(27, 2, "assesscat", $format);
$sheet2->write(28, 2, "assessmethod", $format);
$sheet2->write(29, 2, "assesscomments", $format);

$sheet2->data_validation('C28',
        {
         validate        => 'list',
	 value =>['','',''],
            error_message   => 'Sorry, invalid value.',
        });

my $sheet3 = $workbook->add_worksheet("biometrics");
$oWkS = $oBook->{Worksheet}[2];
$dd = ($oWkS->{Cells}[0][0]->Value);
$sheet3->write(0, 0, $dd, $format);
$dd = ($oWkS->{Cells}[1][0]->Value);
$sheet3->write(1, 0, $dd, $format);
$dd = ($oWkS->{Cells}[2][0]->Value);
$sheet3->write(2, 0, $dd, $format);
$dd = ($oWkS->{Cells}[3][0]->Value);
$sheet3->write(3, 0, $dd, $format);

$sheet3->write(5, 1, "bioshort", $format);
$sheet3->write(5, 2, "biolong", $format);
$sheet3->write(5, 3, "biounitsshort", $format);
$sheet3->write(5, 4, "biounitslong", $format);
$sheet3->write(5, 5, "value", $format);
$sheet3->write(5, 6, "notes", $format);
$sheet3->write(5, 7, "YEAR", $format);

$sheet3->write(5, 0, "TIME SERIES DATA DESCRIPTORS", $format);

my $rowcounter = 6;
# SPAWNERS
$sheet3->write($rowcounter, 0, "SPAWNERS", $format);

my $sql = qq{SELECT category, subcategory, bioshort, biolong, biounitsshort, biounitslong from srdb.biometrics where subcategory = \'SPAWNERS\' order by category, subcategory, bioshort };
my $handle = $dbh -> prepare($sql);
$handle -> execute();

while (my @row = $handle->fetchrow_array) {  # retrieve one row
$sheet3->write($rowcounter, 1, $row[2], $format);
$sheet3->write($rowcounter, 2, $row[3], $format);
$sheet3->write($rowcounter, 3, $row[4], $format);
$sheet3->write($rowcounter, 4, $row[5], $format);
$rowcounter = $rowcounter + 1;

#print("@row[1] \n");
    }
# END SPAWNERS

$rowcounter = $rowcounter + 1;
# RECRUITS
$sheet3->write($rowcounter, 0, "RECRUITS", $format);

$sql = qq{SELECT category, subcategory, bioshort, biolong, biounitsshort, biounitslong from srdb.biometrics where subcategory = \'RECRUITS\' order by category, subcategory, bioshort };
$handle = $dbh -> prepare($sql);
$handle -> execute();
while (my @row = $handle->fetchrow_array) {  # retrieve one row
$sheet3->write($rowcounter, 1, $row[2], $format);
$sheet3->write($rowcounter, 2, $row[3], $format);
$sheet3->write($rowcounter, 3, $row[4], $format);
$sheet3->write($rowcounter, 4, $row[5], $format);
$rowcounter = $rowcounter + 1;
#print("@row \n");
    }
# END RECRUITS


$rowcounter = $rowcounter + 1;
# FISHING MORTALITY
$sheet3->write($rowcounter, 0, "FISHING MORTALITY", $format);
$sql = qq{SELECT category, subcategory, bioshort, biolong, biounitsshort, biounitslong from srdb.biometrics where subcategory = \'FISHING MORTALITY\' order by category, subcategory, bioshort };
$handle = $dbh -> prepare($sql);
$handle -> execute();
while (my @row = $handle->fetchrow_array) {  # retrieve one row
$sheet3->write($rowcounter, 1, $row[2], $format);
$sheet3->write($rowcounter, 2, $row[3], $format);
$sheet3->write($rowcounter, 3, $row[4], $format);
$sheet3->write($rowcounter, 4, $row[5], $format);
$rowcounter = $rowcounter + 1;
#print("@row \n");
    }
# END FISHING MORTALITY

$rowcounter = $rowcounter + 1;
# TOTAL BIOMASS
$sheet3->write($rowcounter, 0, "TOTAL BIOMASS", $format);
$sql = qq{SELECT category, subcategory, bioshort, biolong, biounitsshort, biounitslong from srdb.biometrics where subcategory = \'TOTAL BIOMASS\' order by category, subcategory, bioshort };
$handle = $dbh -> prepare($sql);
$handle -> execute();
while (my @row = $handle->fetchrow_array) {  # retrieve one row
$sheet3->write($rowcounter, 1, $row[2], $format);
$sheet3->write($rowcounter, 2, $row[3], $format);
$sheet3->write($rowcounter, 3, $row[4], $format);
$sheet3->write($rowcounter, 4, $row[5], $format);
$rowcounter = $rowcounter + 1;
#print("@row \n");
    }
# END TOTAL BIOMASS

$rowcounter = $rowcounter + 1;
$sheet3->write($rowcounter, 0, "OTHER BIOMETRICS", $format);
$rowcounter = $rowcounter + 1;
# LIFE HISTORY
$sheet3->write($rowcounter, 0, "LIFE HISTORY", $format);
$sql = qq{SELECT category, subcategory, bioshort, biolong, biounitsshort, biounitslong from srdb.biometrics where subcategory = \'LIFE HISTORY\' order by category, subcategory, bioshort };
$handle = $dbh -> prepare($sql);
$handle -> execute();
while (my @row = $handle->fetchrow_array) {  # retrieve one row
$sheet3->write($rowcounter, 1, $row[2], $format);
$sheet3->write($rowcounter, 2, $row[3], $format);
$sheet3->write($rowcounter, 3, $row[4], $format);
$sheet3->write($rowcounter, 4, $row[5], $format);
$rowcounter = $rowcounter + 1;
#print("@row \n");
    }
# END LIFE HISTORY


# REFERENCE POINTS ETC.
$sheet3->write($rowcounter, 0, "REFERENCE POINTS ETC.", $format);
$sql = qq{SELECT DISTINCT category, subcategory, bioshort, biolong, biounitsshort, biounitslong from srdb.biometrics where subcategory = \'REFERENCE POINTS ETC.\' order by category, subcategory, bioshort };
$handle = $dbh -> prepare($sql);
$handle -> execute();
while (my @row = $handle->fetchrow_array) {  # retrieve one row
$sheet3->write($rowcounter, 1, $row[2], $format);
$sheet3->write($rowcounter, 2, $row[3], $format);
$sheet3->write($rowcounter, 3, $row[4], $format);
$sheet3->write($rowcounter, 4, $row[5], $format);
$rowcounter = $rowcounter + 1;
#print("@row \n");
    }
# END REFERENCE POINTS ETC.


my $sheet4 = $workbook->add_worksheet("timeseries");
$oWkS = $oBook->{Worksheet}[3];


$dd = ($oWkS->{Cells}[0][0]->Value);
$sheet4->write(0, 0, $dd, $format);
$dd = ($oWkS->{Cells}[1][0]->Value);
$sheet4->write(1, 0, $dd, $format);
$dd = ($oWkS->{Cells}[2][0]->Value);
$sheet4->write(2, 0, $dd, $format);
$dd = ($oWkS->{Cells}[3][0]->Value);
$sheet4->write(3, 0, $dd, $format);
$dd = ($oWkS->{Cells}[4][0]->Value);
$sheet4->write(4, 0, $dd, $format);







#----------------
$dbh->disconnect();
