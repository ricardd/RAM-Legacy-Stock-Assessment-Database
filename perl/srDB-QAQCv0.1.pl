#!/usr/bin/perl -w
# script to output a quality assured, quality controlled pdf for a loaded assessment
# Cóilín Minto
# date: Fri Nov 21 13:17:09 AST 2008
# Time-stamp: <2009-03-05 16:53:15 (mintoc)>
use strict;
use warnings;
use DBI;
use LaTeX::Table;
use File::chdir;
use File::Basename;

die "Need to supply an assessment ID\n" if @ARGV <1;
my $assessid=$ARGV[0];
print "Processing assessment: $assessid \n";
# open a connection to the database
my $dbh = DBI->connect("dbi:Pg:dbname=srdb;host=localhost;port=5432;" ,
                      "srdbuser", "srd6us3r!")
		      || die "Database connection not made: $DBI::errstr";

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ title ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
my $titlesql = qq{select ar.areaname, st.commonname, assess.recorder, assess.dateloaded, st.scientificname from srdb.assessment as assess, srdb.area as ar, srdb.stock as st where assessid=\'$assessid\' and st.stockid=assess.stockid and ar.areaID=st.areaID};
my $titlehandle = $dbh -> prepare($titlesql);
$titlehandle -> execute();
my @titleresult = $titlehandle->fetchrow_array();
$titlehandle->finish();
my $area=$titleresult[0];
my $sp=lc $titleresult[1];
my $recorder=$titleresult[2];
my $datein=$titleresult[3];
my $sciname=$titleresult[4];
# create an assessment-specific tex file
#my $temptex="/home/srdbadmin/SQLpg/srDB/tex/srDB-QAQC-template.tex";
#my $outtex="/home/srdbadmin/SQLpg/srDB/tex/" . $assessid . ".tex";

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ assessment authors ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
my $authorsql = qq{select risentry from srdb.referencedoc where assessid=\'$assessid\' and risfield='A1'};
my $authorhandle = $dbh -> prepare($authorsql);
$authorhandle -> execute();
my @authorresult = $authorhandle->fetchrow_array();
$authorhandle->finish();
my $authors=join(",",@authorresult);

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ first table: assess. details  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

my $tab1sql = qq{select mgmt, assessorfull, assessyear, pdffile, methodlong from srdb.assessment as a, srdb.assessmethod, srdb.assessor as b where  assessmethod=methodshort and a.assessorid=b.assessorid and assessid=\'$assessid\'};
my $tab1handle = $dbh -> prepare($tab1sql);
$tab1handle -> execute();
my @tab1result = $tab1handle->fetchrow_array();
$tab1handle->finish();
# replace the charatcers that latex finds difficult
# set up a hash of change strings
my %change = ( '_' => '\\_', '&' => '\\&', '%' => '\\%' );
my $list_item;
for $list_item(@tab1result)
{
  # loop through the changes hash
  for(keys %change)
  { $list_item =~ s/$_/$change{$_}/gs }
}

my $mgmt=$tab1result[0];
my $assessorfull=$tab1result[1];
my $assessyear=$tab1result[2];
my $pdffile=$tab1result[3];
my $pdffilename = basename($pdffile);
my $methodlong=$tab1result[4];

## N.B. all replacements to the template are done at the end of this file
## make the latex tables
## latex first table 
  my $header = [[ 'Detail', 'Value']];
  
  my $data = [
      [ 'Management body',  "$mgmt" ],
      [ 'Assessment group', "$assessorfull" ],
      [ 'Assessment authors',           "$authors" ],
      [ 'Assessment method',           "$methodlong" ],
      [ 'Years',            "$assessyear" ],
      [ 'Document',         "$pdffilename" ],
      [ 'Recorder',         "$recorder"],
      [ 'Date entered',     "$datein"],
     ];
  my $assesstabfile= "/home/srdbadmin/SQLpg/srDB/tex/" . $assessid . "assestab.tex";
# print "$assesstabfile \n";
$CWD = "/home/srdbadmin/SQLpg/srDB/tex";
  my $table1 = LaTeX::Table->new(
        {   
        filename    => "$assesstabfile",
        maincaption => '',
	caption_top => 1,
        caption     => '',
        label       => 'tab:assessdet',
	center        => 1,
	position    => 'htb',
        header      => $header,
        data        => $data,
	set_width   =>'\textwidth',
        }
  );
  $table1->set_coldef_strategy({
    LONG_COL => 'p{7cm}', # set the column width 
  });
  # write LaTeX code in $assesstabfile
  $table1->generate();

##~~~~~~~~~~~~~~ second table: timeries and biometric details  ~~~~~~~~~~~~~~

## timeseries
my $tab2sql = qq{select distinct tsshort from srdb.tsmetrics, srdb.timeseries where tsid=tsunique and assessid=\'$assessid\'};
my $tab2handle = $dbh -> prepare($tab2sql);
$tab2handle -> execute();
my @row;
my @tab2result;
my $entrystring;
while (@row = $tab2handle->fetchrow_array) {  # retrieve one row
      $entrystring= "@row";
      #print $entrystring;
      push(@tab2result, $entrystring);
    }
$tab2handle->finish();
print "@tab2result \n";
my $timeseries=join(", ",@tab2result);

## biometrics
my $tab3sql = qq{select distinct bioshort from srdb.biometrics, srdb.bioparams where bioid=biounique and assessid=\'$assessid\'  and subcategory != 'REFERENCE POINTS ETC.'};
my $tab3handle = $dbh -> prepare($tab3sql);
$tab3handle -> execute();
my @row1;
my @tab3result;
my $entrystring;
while (@row1 = $tab3handle->fetchrow_array) {  # retrieve one row
      $entrystring= "@row1";
      #print $entrystring;
      push(@tab3result, $entrystring);
    }
$tab3handle->finish();
print "@tab3result \n";
my $biometrics=join(", ",@tab3result);
# change the percentage and underscore signs for latex
$biometrics =~ s/%/\\%/g;

## reference points
my $tab4sql = qq{select distinct bioshort from srdb.biometrics, srdb.bioparams where bioid=biounique and assessid=\'$assessid\'  and subcategory = 'REFERENCE POINTS ETC.'};
my $tab4handle = $dbh -> prepare($tab4sql);
$tab4handle -> execute();
my @row2;
my @tab4result;
my $entrystring;
while (@row2 = $tab4handle->fetchrow_array) {  # retrieve one row
      $entrystring= "@row2";
      #print $entrystring;
      push(@tab4result, $entrystring);
    }
$tab4handle->finish();
print "@tab4result \n";
my $refpoints=join(", ",@tab4result);
# change the percentage signs for latex
$refpoints =~ s/%/\\%/g;


## latex second table 
  my $header = [[ 'Detail', 'Value']];
  
  my $data = [
      [ 'Timeseries',  "$timeseries" ],
      [ 'Biometrics',  "$biometrics" ],
      [ 'Reference points',  "$refpoints" ],
     ];
  my $timebiotabfile= "/home/srdbadmin/SQLpg/srDB/tex/" . $assessid . "timebiotab.tex";
  my $table2 = LaTeX::Table->new(
	{
        filename    => "$timebiotabfile",
        maincaption => '',
	caption_top => 1,
        caption     => '',
        label       => 'tab:timebiodet',
	center        => 1,
	position    => 'htb',
        header      => $header,
        data        => $data,
	set_width   =>'\textwidth',
        coldef      => 'lp{7cm}',
        }
  );

  $table2->set_coldef_strategy({
    LONG_COL => 'p{7cm}', # set the column width 
  });
  # write LaTeX code in $assesstabfile
  $table2->generate();

##~~~~~~~~~~~~~~~~ R file~~~~~~~~~~~~~~~~~~~~~~~~
# replaces the 
# create an assessment-specific R file
my $tempR="/home/srdbadmin/SQLpg/srDB/R/functions/srDB-QAQC-template.R";
my $outR="/home/srdbadmin/SQLpg/srDB/R/functions/" . $assessid . ".R";
print "$outR \n";
##~~~~~~~~~~~~~~~~ replacements ~~~~~~~~~~~~~~~~~~~~~~

## Open the file
open (IN, "$tempR") || die $!;
## print the modified contents to out file
open (OUT, ">$outR") || die $!;
while ($_ = <IN> ) {
## If text exists, replace text
# area

if ($_ =~ /ASSESSID/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/ASSESSID/$assessid/g;
     }
     print OUT "$_";
}
close(IN);
close(OUT);

#print "R --slave < $outR > /home/srdbadmin/SQLpg/srDB/R/functions/r.log";
system("R --slave < $outR > /home/srdbadmin/SQLpg/srDB/R/functions/r.log");
my $summaryplot="/home/srdbadmin/SQLpg/srDB/tex/figures/plot-". $assessid . ".pdf";
print "$summaryplot /n";

##~~~~~~~~~~~~~~~~ LaTeX file~~~~~~~~~~~~~~~~~~~~~~~~

# create an assessment-specific tex file
my $temptex="/home/srdbadmin/SQLpg/srDB/tex/srDB-QAQC-template.tex";
my $outtex="/home/srdbadmin/SQLpg/srDB/tex/" . $assessid . ".tex";

##~~~~~~~~~~~~~~~~ replacements ~~~~~~~~~~~~~~~~~~~~~~

## Open the file
open (IN, "$temptex") || die $!;
## print the modified contents to out file
#open (OUT, ">$outtex") || die $!;
open (OUT, ">$outtex") || die $!;
while ($_ = <IN> ) {
## If text exists, replace text
# area
if ($_ =~ /AREA/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/AREA/$area/g;
     }
# species
if ($_ =~ /SPECIES/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/SPECIES/$sp/g;
     }
# latiname
if ($_ =~ /LATINNAME/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/LATINNAME/$sciname/g;
     }
# recorder
#if ($_ =~ /RECORDER/) {
#       # Replace text, all instances on a line (/g)
#       $_ =~ s/RECORDER/$recorder/g;
#     }
#if ($_ =~ /DATEIN/) {
#       # Replace text, all instances on a line (/g)
#       $_ =~ s/DATEIN/$datein/g;
#     }
if ($_ =~ /ASSESSTABLE/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/ASSESSTABLE/$assesstabfile/g;
     }
if ($_ =~ /TIMEBIOTABLE/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/TIMEBIOTABLE/$timebiotabfile/g;
     }
if ($_ =~ /SUMMARYPLOT/) {
       # this is for the plot which is generated from the R code
       $_ =~ s/SUMMARYPLOT/$summaryplot/g;
     }
     print OUT "$_";
  }
close(IN);
close(OUT);

## compile the document
system("pdflatex -output-directory /home/srdbadmin/SQLpg/srDB/tex  $outtex ");
my $outpdffile = "/home/srdbadmin/SQLpg/srDB/tex/" . $assessid . ".pdf";
## clean up, removes extra files generated by latex
my $outtexlog= "/home/srdbadmin/SQLpg/srDB/tex/" . $assessid . ".log";
my $outtexaux= "/home/srdbadmin/SQLpg/srDB/tex/" . $assessid . ".aux";
unlink $outtex, $outR, $summaryplot, $timebiotabfile, $assesstabfile, $outtexlog, $outtexaux || die "Cannot open file";
system("kpdf $outpdffile &") || die "Cannot open file";

$dbh->disconnect();
