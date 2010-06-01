#!/usr/bin/perl -w
# script to generate LaTex code for srdb summary report
# Daniel Ricard, started 2009-04-24 from earlier code in NCEAS-summary-report.pl
# Last modified: Time-stamp: <2009-06-01 11:12:48 (ricardd)>
# Modification history:

use strict;
use DBI;
use LaTeX::Table;
use POSIX qw(strftime);

# connect to srDB
my $dbh = DBI->connect('dbi:Pg:dbname=srdb;host=localhost;port=5432','srdbuser','srd6us3r!')|| die "Database connection not made: $DBI::errstr";

my $tablequery = qq{"select
tt.commonname1 as \\"Common name\\", tt.scientificname as \\"Scientific name\\", count(*) as \\"N. assessments\\"
FROM
srdb.assessment aa,
srdb.stock bb,
srdb.taxonomy tt
WHERE
aa.stockid=bb.stockid AND
bb.tsn=tt.tsn AND
aa.assessid in (SELECT assessid from srdb.qaqc where qaqc is true)
GROUP BY
tt.commonname1, tt.family, tt.ordername, tt.scientificname
ORDER BY
tt.ordername, tt.family, tt.scientificname
"};

$tablequery = qq{"select aa.recorder, aa.stockid, aa.assessid from srdb.assessment aa where aa.assessid in (aa.assessid in (SELECT assessid from srdb.qaqc where qaqc is true)) order by aa.recorder, aa.stockid"};

# summary table of contributors


# summary table of number of assessments per stock

# summary table of number of assessments per species

# summary table of reference documents

# a SECTION for each order, a SUBSECTION for each family and a SUBSUBSECTION for each species
open LATEXFILE, ">srdb-allgraphs.tex" or die $!;

# query for orders with QAQC assessments
my $sqlorders = qq{select
distinct tt.ordername
FROM srdb.assessment aa, srdb.stock bb,
srdb.taxonomy tt
WHERE
aa.assessid in (SELECT assessid from srdb.qaqc where qaqc is true) and
aa.stockid=bb.stockid AND 
bb.tsn=tt.tsn
ORDER BY
tt.ordername
};

my $sth = $dbh->prepare( $sqlorders );
$sth->execute();

my ($ordername, $famname, $stocklong, $assessid, $comname, $sciname, $pdfname, $recorder, $assess, $model, $method);

while ( $ordername = $sth->fetchrow_array() ) 
{
#print "$ordername \n";
print LATEXFILE "\\section{$ordername}\\index{$ordername}\n\n";
#print LATEXFILE "\\section{$ordername}\\index{$ordername (order)}\n\n";

my $sqlfam = qq{SELECT distinct tt.family from srdb.assessment aa, srdb.stock bb, srdb.taxonomy tt, srdb.timeseries ts
WHERE
aa.assessid in (SELECT assessid from srdb.qaqc where qaqc is true) and
aa.stockid=bb.stockid AND aa.assessid=ts.assessid AND
bb.tsn=tt.tsn AND
tt.ordername = \'$ordername\'
ORDER BY
tt.family
};
my $sth2 = $dbh->prepare( $sqlfam );
$sth2->execute();
while ( $famname = $sth2->fetchrow_array() ) 
{
#print "\t $famname \n";
print LATEXFILE "\\subsection{$famname}\\index{$famname}\\index{$ordername!$famname}\n\n";
#print LATEXFILE "\\subsection{$famname}\\index{$famname (family)}\\index{$ordername (order)!$famname}\n\n";

#my $sqlassess = qq{select distinct aa.assessid, tt.commonname1, tt.scientificname, aa.recorder from srdb.taxonomy tt, srdb.assessment aa, srdb.stock ss where (aa.assessid in (SELECT assessid from srdb.qaqc where qaqc is true)) and aa.stockid=ss.stockid and ss.tsn=tt.tsn and tt.family = \'$famname\' order by tt.scientificname, aa.recorder};

my $sqlassess = qq{select distinct ss.stocklong, aa.assessid, tt.commonname1, tt.scientificname, aa.recorder, aa.assess, (CASE WHEN aa.assess = 1 THEN \'stock assessment conducted\' ELSE \'no assessmenth conducted\' END) as model, am.methodlong from srdb.taxonomy tt, srdb.assessment aa, srdb.stock ss, srdb.assessmethod am where aa.assessmethod=am.methodshort and (aa.assessid in (SELECT assessid from srdb.qaqc where qaqc is true)) and aa.stockid=ss.stockid and ss.tsn=tt.tsn and tt.family = \'$famname\' order by tt.scientificname, aa.recorder};

my $sth3 = $dbh->prepare( $sqlassess );
$sth3->execute();
#while ( ($assessid, $comname, $sciname, $recorder) = $sth3->fetchrow_array() ) 
while ( ($stocklong, $assessid, $comname, $sciname, $recorder, $assess, $model, $method) = $sth3->fetchrow_array() ) 
{
$pdfname = "plot-" . $assessid . ".pdf";
print LATEXFILE "\\subsubsection{$sciname - $comname}\\index{$comname}\\index{$sciname}\\index{$famname!$sciname}\n";

print LATEXFILE "ID: $assessid\n\n";
print LATEXFILE "$stocklong \n\n";
print LATEXFILE "$model: $method \n";


print LATEXFILE "\\begin{center}\n";
print LATEXFILE "\\vspace{-0.2cm}\\includegraphics[scale=0.65]{../tex/figures/$pdfname}\n";

print LATEXFILE "\\end{center}\n\n";
print LATEXFILE "\\newpage\n";


}# end while over assessments

}# end while over family

}# end while over order


# disconnect from srDB
$dbh->disconnect();
close  LATEXFILE;
