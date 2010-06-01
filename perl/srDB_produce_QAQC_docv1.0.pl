#!/usr/bin/perl -w
# script to output a quality assured, quality controlled pdf for all loaded assessments from either a given recorder (-r RECRODERNAME) or a management unit (-m MGMTUNITNAME)
# Cóilín Minto and Daniel Ricard
# Date started: 2009-06-03. from earlier work using only the recorder name as an argument 
# Time-stamp: <2010-05-27 12:03:12 (srdbadmin)>
# Modification history:
# 2009-06-05: to also allow for the generation of a QAQC document for each assessor (e.g. NEFSC for Mike Fogarty), I'm addins an additional argument option "-a"
# 2009-06-10: adding an ORDER BY statement to the SQL so that the resulting document is more readable
# 2009-10-22: had to reinstall the "Latex::Table" package from cpan (sudo cpan LaTeX::Table) and "File::chdir", also changed paths to reflect new path using subversion
# 2010-05-27: system upgrade, LaTeX::Table reinstalled again
use strict;
use warnings;
use DBI;
use LaTeX::Table;
use File::chdir;
use File::Basename;
use Switch;

die "Need to supply an assessor ID\n" if @ARGV <1;

my $argument = $ARGV[1];
my $alistsql;

switch($ARGV[0]) {
case "-a" {$alistsql = qq{select assessid from srdb.assessment aa, srdb.stock s, srdb.area a where aa.recorder != \'MYERS\' and s.areaid=a.areaid and s.stockid=aa.stockid and assessid like \'$argument%\' order by assessid};}
case "-r" {$alistsql = qq{select distinct assessid from srdb.assessment where recorder = \'$argument\' order by assessid};}
case "-m" {$alistsql = qq{select assessid from srdb.assessment aa, srdb.stock s, srdb.area a where aa.recorder != \'MYERS\' and s.areaid=a.areaid and s.stockid=aa.stockid and a.areatype = \'$argument\' order by assessid};}
}

# open a connection to the database
my $dbh = DBI->connect("dbi:Pg:dbname=srdb;host=localhost;port=5432;" ,
                      "srdbuser", "srd6us3r!")
		      || die "Database connection not made: $DBI::errstr";

my $alisthandle = $dbh -> prepare($alistsql);
$alisthandle -> execute();

my @alistarray;

while (my @alrow = $alisthandle->fetchrow_array) {  # retrieve one row
      push(@alistarray, @alrow);
    }
my @pdflistarray;
foreach (@alistarray) {
#  my @systemcall=("/usr/bin/perl", "/home/srdbadmin/SQLpg/srDB/perl/srDB-QAQCv0.2.pl", "$_");
  my @systemcall=("/usr/bin/perl", "/home/srdbadmin/SQLpg/srdb/trunk/perl/srDB-QAQCv1.0.pl", "$_");

#  my @systemcall=("/usr/bin/perl", "/home/srdbadmin/SQLpg/srdb/trunk/perl/srDB-QAQCv0.2.pl", "$_");
  system(@systemcall);
#  push(@pdflistarray, "/home/srdbadmin/SQLpg/srDB/tex/" . $_ . ".pdf");
  push(@pdflistarray, "/home/srdbadmin/SQLpg/srdb/trunk/tex/" . $_ . ".pdf");
}

#-------------------------------
# create the first page
#-------------------------------
# the name of the recorder
#my $recordersql = qq{select firstname from srdb.recorder where nameinxls=\'$assessorid\'};
#my $recorderhandle = $dbh -> prepare($recordersql);
#$recorderhandle -> execute();
#my @recorderresult = $recorderhandle->fetchrow_array();
#$recorderhandle->finish();
#my $recorderid=$recorderresult[0];
my $recorderid;

switch($ARGV[0]) {
case "-r" {
$recorderid = $argument;
my $recordersql = qq{select firstname from srdb.recorder where nameinxls=\'$recorderid\'};
my $recorderhandle = $dbh -> prepare($recordersql);
$recorderhandle -> execute();
my @recorderresult = $recorderhandle->fetchrow_array();
$recorderhandle->finish();
$recorderid=$recorderresult[0];
}
case "-m" {$recorderid = "Colleague";}
case "-a" {$recorderid = "Colleague";}
}

#print "$assessorid . $recorderid";

# number of assesments they entered
# my $assessnumsql = qq{select count(assessid) from srdb.assessment where assessid like \'%$assessorid%\'};
#my $assessnumhandle = $dbh -> prepare($assessnumsql);
#$assessnumhandle -> execute();
#my @assessnumresult = $assessnumhandle->fetchrow_array();
#$assessnumhandle->finish();
#my $assessnum=$assessnumresult[0];

my $assessnum = scalar (@alistarray);

my $plural;
if($assessnum > 1){$plural='s'}else{$plural=''}

#------------------------------------------
# LaTeX file replacements
#------------------------------------------
# create an assessment-specific tex file
#my $temptex="/home/srdbadmin/SQLpg/srDB/tex/templates/QAQC_instructions_to_recorders_template.tex";
my $temptex="/home/srdbadmin/SQLpg/srdb/trunk/tex/templates/QAQC_instructions_to_recorders_template.tex";
#my $outtex="/home/srdbadmin/SQLpg/srDB/tex/" . $assessorid . "_QAQC.tex";
#my $outtex="/home/srdbadmin/SQLpg/srDB/tex/" . $argument . "_QAQC.tex";
my $outtex="/home/srdbadmin/SQLpg/srdb/trunk/tex/" . $argument . "_QAQC.tex";

## Open the file
open (IN, "$temptex") || die $!;
## print the modified contents to out file
#open (OUT, ">$outtex") || die $!;
open (OUT, ">$outtex") || die $!;
while ($_ = <IN> ) {
## If text exists, replace text
# area
if ($_ =~ /RECORDERID/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/RECORDERID/$recorderid/g;
#       $_ =~ s/RECORDERID/$argument/g;
     }
if ($_ =~ /ASSESSNUM/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/ASSESSNUM/$assessnum/g;
     }
if ($_ =~ /PLURAL/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/PLURAL/$plural/g;
     }
     print OUT "$_";
  }

foreach (@pdflistarray) {
my $pdffilename=basename($_);
my @pdffilename= split(/.pdf/, $pdffilename);
my $stockname=$pdffilename[0];
print OUT '\includepdf[pagecommand={\thispagestyle{plain}}, addtotoc={1,subsubsection,1,' . "$stockname" . ',' . "$stockname" . '}, pages={1,2}]{' . "$_" ."}\n";
#print OUT '\includepdf[pagecommand={\thispagestyle{plain}}, addtotoc={1,subsubsection,1,' . "$stockname" . '}, pages={1,2}]{' . "$_" ."}\n";
} 
#print OUT '\includepdf[angle=90, addtotoc={1,subsubsection,1,LME map,lmemap}]{/home/srdbadmin/SQLpg/srDB/tex/lme_map.pdf}';
print OUT '\includepdf[angle=90, addtotoc={1,subsubsection,1,LME map,lmemap}]{/home/srdbadmin/SQLpg/srdb/trunk/tex/lme_map.pdf}';
print OUT '\end{document}'. "\n";
close(IN);
close(OUT);

# compile the first page

#system("pdflatex -output-directory /home/srdbadmin/SQLpg/srDB/tex  $outtex");
#system("pdflatex -output-directory /home/srdbadmin/SQLpg/srDB/tex  $outtex");
system("pdflatex -output-directory /home/srdbadmin/SQLpg/srdb/trunk/tex  $outtex");
system("pdflatex -output-directory /home/srdbadmin/SQLpg/srdb/trunk/tex  $outtex");
#my $outpdffile = "/home/srdbadmin/SQLpg/srDB/tex/" . $assessorid . "_QAQC.pdf";
## clean up, removes extra files generated by latex
#my $outtexlog= "/home/srdbadmin/SQLpg/srDB/tex/" . $assessorid . "_QAQC.log";
#my $outtexaux= "/home/srdbadmin/SQLpg/srDB/tex/" . $assessorid . "_QAQC.aux";
#my $outtexout= "/home/srdbadmin/SQLpg/srDB/tex/" . $assessorid . "_QAQC.out";
#my $outtexlog= "/home/srdbadmin/SQLpg/srDB/tex/" . $argument . "_QAQC.log";
#my $outtexaux= "/home/srdbadmin/SQLpg/srDB/tex/" . $argument . "_QAQC.aux";
#my $outtexout= "/home/srdbadmin/SQLpg/srDB/tex/" . $argument . "_QAQC.out";
my $outtexlog= "/home/srdbadmin/SQLpg/srdb/trunk/tex/" . $argument . "_QAQC.log";
my $outtexaux= "/home/srdbadmin/SQLpg/srdb/trunk/tex/" . $argument . "_QAQC.aux";
my $outtexout= "/home/srdbadmin/SQLpg/srdb/trunk/tex/" . $argument . "_QAQC.out";

unlink $outtexlog, $outtexaux, $outtexout || die "Cannot open file";

#----------------
$dbh->disconnect();
