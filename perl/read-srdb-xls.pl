#!/usr/bin/perl -w
# script to input a single spreadsheet file in the srDB

use strict;
use Spreadsheet::ParseExcel;
use DBI;

my $oExcel = new Spreadsheet::ParseExcel;

die "You must provide a filename to $0 to be parsed as an Excel file" unless @ARGV;

my $oBook = $oExcel->Parse($ARGV[0]);

die "The spreadsheet does not have 4 worksheets" unless $oBook->{SheetCount} == 4;

my($iR, $iC, $oWkS, $oWkC);

#####################################################
# first sheet
my $iSheet=0;

 $oWkS = $oBook->{Worksheet}[$iSheet];
 print "--------- SHEET:", $oWkS->{Name}, "\n\n";
 die "First worksheet must be called meta" unless $oWkS->{Name} eq "meta"; 

 for($iR = $oWkS->{MinRow} ;
     defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ;
     $iR++)
 {
  for($iC = $oWkS->{MinCol} ;
      defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ;
      $iC++)
  {
   $oWkC = $oWkS->{Cells}[$iR][$iC];
   print "( $iR , $iC ) =>", $oWkC->Value, "\n" if($oWkC);
  }
 }

my $stock = $oWkS->{Cells}[13][3]->Value;

# end work on first sheet
#####################################################

#####################################################
# second sheet
my $iSheet=1;

 $oWkS = $oBook->{Worksheet}[$iSheet];
 print "--------- SHEET:", $oWkS->{Name}, "\n\n";
die "Second worksheet must be called reference" unless $oWkS->{Name} eq "reference"; 

 for($iR = $oWkS->{MinRow} ;
     defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ;
     $iR++)
 {
  for($iC = $oWkS->{MinCol} ;
      defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ;
      $iC++)
  {
   $oWkC = $oWkS->{Cells}[$iR][$iC];
   print "( $iR , $iC ) =>", $oWkC->Value, "\n" if($oWkC);
  }
 }
# end work on second sheet
#####################################################

#####################################################
# third sheet
my $iSheet=2;

 $oWkS = $oBook->{Worksheet}[$iSheet];
 print "--------- SHEET:", $oWkS->{Name}, "\n\n";
 die "Third worksheet must be called points, not ",$oWkS->{Name} ,"\n" unless $oWkS->{Name} eq "points"; 

 for($iR = $oWkS->{MinRow} ;
     defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ;
     $iR++)
 {
  for($iC = $oWkS->{MinCol} ;
      defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ;
      $iC++)
  {
   $oWkC = $oWkS->{Cells}[$iR][$iC];
   print "( $iR , $iC ) =>", $oWkC->Value, "\n" if($oWkC);
  }
 }
# end work on third sheet
#####################################################

#####################################################
# fourth sheet
my $iSheet=3;

 $oWkS = $oBook->{Worksheet}[$iSheet];
 print "--------- SHEET:", $oWkS->{Name}, "\n\n";
 die "Fourth worksheet must be called series" unless $oWkS->{Name} eq "series"; 

 for($iR = $oWkS->{MinRow} ;
     defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ;
     $iR++)
 {
  for($iC = $oWkS->{MinCol} ;
      defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ;
      $iC++)
  {
   $oWkC = $oWkS->{Cells}[$iR][$iC];
   print "( $iR , $iC ) =>", $oWkC->Value, "\n" if($oWkC);
  }
 }
# end work on fourth sheet
#####################################################



#####################################################
# load data from spreadsheet into the database
my $dbh = DBI->connect('dbi:Pg:dbname=gfsDB;host=localhost;port=5433','ricardd','ricardd')|| die "Database connection not made: $DBI::errstr";



$dbh->disconnect();
#####################################################


print "\n\nAll done!\n";

