#!/usr/bin/perl -w
use strict;
#use warnings;
use DBI;
use LaTeX::Table;
use File::chdir;
use File::Basename;
use POSIX qw(strftime);


# open a connection to the database
my $dbh = DBI->connect("dbi:Pg:dbname=srdb;host=localhost;port=5432;" ,
                      "srdbuser", "srd6us3r!")
		      || die "Database connection not made: $DBI::errstr";

# open output file
my $outfile = "Science-2009-pdf-checks.txt";

open (OUT, ">$outfile") || die $!;
print OUT "assessid\t pdfcheck\t pdffilename \n";

my $tab1sql = qq{select ss.assessid, (CASE WHEN a.pdffile IS NULL THEN \'NONE\' ELSE a.pdffile END) as pdffile, q.issueurl from srdb.assessment a, srdb.qaqc q, srdb.science2009stocks ss where a.assessid = ss.assessid and q.assessid = ss.assessid};
my $tab1handle = $dbh -> prepare($tab1sql);
$tab1handle -> execute();

my($assessid, $pdffile, $issueurl, $pdftemp, $pdffilename, $pdfcheck);

while (($assessid, $pdffile, $issueurl) = $tab1handle->fetchrow_array) {  # retrieve one row
# check if pdf is present
if($pdffile eq "NONE"){$pdffilename ="NONE"}else{$pdffilename = basename($pdffile)};
#print OUT "$assessid\t $pdffile\t $pdffilename \n";

if (-e "/home/srdbadmin/SQLpg/srDB/pdf/$pdffilename") {
print "pdf file exists!";
#print OUT "pdf file exists!\n\n";
$pdfcheck ="(pdf file present)";
}else {
#print "pdf file does not exist.";
print "pdf file MISSING!";
#print OUT "pdf file MISSING!\n\n";
$pdfcheck ="(pdf file MISSING!)";
}
print "\t$pdfcheck\n\n";
print OUT "$assessid \t $pdfcheck \t $pdffile \t $issueurl\n";
print("$assessid \t $pdffile \t $pdffilename \n");
    }

$tab1handle->finish();
$dbh->disconnect();
