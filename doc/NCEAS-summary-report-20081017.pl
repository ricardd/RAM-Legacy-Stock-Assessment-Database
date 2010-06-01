#!/usr/bin/perl -w
# script to generate LaTex cod for NCEAS report
# Daniel Ricard, started 2008-10-16
# Last modified: Time-stamp: <2009-04-24 10:12:39 (ricardd)>
# Modification history:
# 2008-10-17: Coilin added a new table called "NCEASplots" that stored the assessid of assessments for which there are pdf summaries available, using that to generate LaTex content, instead of using all assessid from srDB

use strict;
use DBI;
use POSIX qw(strftime);

# connect to srDB
my $dbh = DBI->connect('dbi:Pg:dbname=srDB;host=localhost;port=5432','ricardd','ricardd')|| die "Database connection not made: $DBI::errstr";

# the basic LaTex structure to create consists of a SECTION for each order, a SUBSECTION for each family and a SUBSUBSECTION for each species
open LATEXFILE, ">NCEASallgraphs.tex" or die $!;

# query for assessments
#my $sqlassessment = qq{select * from NCEASplots};
#my $sth = $dbh->prepare( $sqlassessment );
#$sth->execute();
#my $assessments = $sth->fetchrow_array();



# query for orders
my $sqlorders = qq{select
distinct tt.ordername
FROM
srdb.assessment aa,
srdb.stock bb,
srdb.taxonomy tt
WHERE
aa.stockid=bb.stockid AND
bb.tsn=tt.tsn
ORDER BY
tt.ordername
};

my $sth = $dbh->prepare( $sqlorders );
$sth->execute();

my ($ordername, $famname, $assessname, $comname, $sciname, $pdfname);

while ( $ordername = $sth->fetchrow_array() ) 
{
#print "$ordername \n";
#print LATEXFILE "\\section{$ordername}\\index{$ordername (order)}\n\n";
print LATEXFILE "\\section{$ordername}\\index{$ordername}\n\n";

my $sqlfam = qq{SELECT distinct tt.family from srdb.assessment aa,srdb.stock bb, srdb.taxonomy tt
WHERE
aa.stockid=bb.stockid AND
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
print LATEXFILE "\\subsection{$famname}\\index{$famname (family)}\\index{$ordername!$famname}\n\n";

my $sqlassess = qq{SELECT distinct aa.assessid, tt.commonname1, tt.scientificname from srdb.assessment aa,srdb.stock bb, srdb.taxonomy tt, srdb.timeseries ts
WHERE
aa.stockid=bb.stockid AND ts.assessid = aa.assessid AND
bb.tsn=tt.tsn AND
tt.family = \'$famname\'
ORDER BY
aa.assessid
};
my $sth3 = $dbh->prepare( $sqlassess );
$sth3->execute();
while ( ($assessname, $comname, $sciname) = $sth3->fetchrow_array() ) 
{
#print "\t \t $assessname - $comname\n";
$pdfname = $assessname . ".pdf";
#print LATEXFILE "\\subsubsection{$sciname - $comname}\\index{$comname}\\index{$sciname}\n";
print LATEXFILE "\\subsubsection{$sciname - $comname}\\index{$comname (common name)}\\index{$sciname (scientific name) \\index{$famname!$sciname}}\n";
#print LATEXFILE "Blah blah\n";
#print LATEXFILE "\\begin{figure}[htb]\n";
print LATEXFILE "\\begin{center}\n";

#print LATEXFILE "\\includegraphics{$pdfname}\n";
#print LATEXFILE "\\includegraphics[width=1.2\\textwidth]{../R/onestock.pdf}\n";
print LATEXFILE "\\includegraphics[width=1.2\\textwidth]{../R/figures/$pdfname}\n";
#print LATEXFILE "\\vspace{-0.2cm}\\includegraphics[scale=0.65]{../R/onestock.pdf}\n";
print LATEXFILE "\\end{center}\n\n";
#print LATEXFILE "\\end{figure}\n\n";

}# end while over assessments

}# end while over family

}# end while over order


# disconnect from srDB
$dbh->disconnect();
close  LATEXFILE;
