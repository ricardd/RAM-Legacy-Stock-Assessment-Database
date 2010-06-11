#!/usr/bin/perl -w
# a Perl script to generate a single pdf file containing summaries and plots for all assessments in the database
# Daniel Ricard, started 2009-12-05 from earlier Perl script 
# Time-stamp: <2010-06-10 10:40:10 (srdbadmin)>

use strict;
use warnings;
use DBI;
use LaTeX::Table;
use File::chdir;
use File::Basename;


# open a connection to the database
my $dbh = DBI->connect("dbi:Pg:dbname=srdb;host=localhost;port=5432;" ,
                      "srdbuser", "srd6us3r!")
		      || die "Database connection not made: $DBI::errstr";
open LATEXFILE, ">summary-appendix-allgraphs.tex" or die $!;

# query for taxonomic orders 
my $sqlorders = qq{select
distinct tt.ordername
FROM srdb.assessment aa, srdb.stock bb,
srdb.taxonomy tt
WHERE
aa.stockid=bb.stockid AND 
bb.tsn=tt.tsn AND
aa.recorder != \'MYERS\'
ORDER BY
tt.ordername
};

my $sth = $dbh->prepare( $sqlorders );
$sth->execute();

my ($ordername, $famname, $stocklong, $assessid, $comname, $sciname, $pdfname, $recorder, $assess, $model, $method);
while ( $ordername = $sth->fetchrow_array() ) 
{
#print "$ordername \n";
#print LATEXFILE "\\section{$ordername}\\index{$ordername}\n\n";
#print LATEXFILE "\\section{$ordername}\\index{$ordername (order)}\n\n";
print LATEXFILE "\\addcontentsline{toc}{section}{Order $ordername}" ; # .  . . . . . . . . . . . . . . . . . . . . . . . . . .

my $sqlfam = qq{SELECT distinct tt.family from srdb.assessment aa, srdb.stock bb, srdb.taxonomy tt, srdb.timeseries ts
WHERE
aa.stockid=bb.stockid AND aa.assessid=ts.assessid AND
aa.recorder != \'MYERS\' AND
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
print LATEXFILE "\\index{$famname}\\index{$ordername!$famname}\n\n";
#\\subsection{$famname}
#print LATEXFILE "\\subsection{$famname}\\index{$famname (family)}\\index{$ordername (order)!$famname}\n\n";
print LATEXFILE "\\addcontentsline{toc}{subsection}{\\hspace{0.2cm}Family $famname}" ; # . .  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 

#my $sqlassess = qq{select distinct aa.assessid, tt.commonname1, tt.scientificname, aa.recorder from srdb.taxonomy tt, srdb.assessment aa, srdb.stock ss where (aa.assessid in (SELECT assessid from srdb.qaqc where qaqc is true)) and aa.stockid=ss.stockid and ss.tsn=tt.tsn and tt.family = \'$famname\' order by tt.scientificname, aa.recorder};

my $sqlassess = qq{select distinct ss.stocklong, aa.assessid, tt.commonname1, tt.scientificname, aa.recorder, aa.assess, (CASE WHEN aa.assess = 1 THEN \'stock assessment conducted\' ELSE \'no assessment conducted\' END) as model, am.methodlong from srdb.taxonomy tt, srdb.assessment aa, srdb.stock ss, srdb.assessmethod am where aa.recorder != \'MYERS\' AND aa.assessmethod=am.methodshort and aa.stockid=ss.stockid and ss.tsn=tt.tsn and tt.family = \'$famname\' order by tt.scientificname, aa.recorder};

my $sth3 = $dbh->prepare( $sqlassess );
$sth3->execute();
#while ( ($assessid, $comname, $sciname, $recorder) = $sth3->fetchrow_array() ) 
while ( ($stocklong, $assessid, $comname, $sciname, $recorder, $assess, $model, $method) = $sth3->fetchrow_array() ) 
{
$pdfname = $assessid . ".pdf";
print LATEXFILE "\\index{$comname}\\index{$sciname}\\index{$famname!$sciname}\n";
#print LATEXFILE "\\addcontentsline{toc}{subsubsection}{\\hspace{0.2cm}\\it{$sciname} . .  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . }" ;
#\\subsubsection{$sciname - $comname}
#print LATEXFILE "ID: $assessid\n\n";
#print LATEXFILE "$stocklong \n\n";
#print LATEXFILE "$model: $method \n";


print LATEXFILE '\includepdf[pagecommand={\thispagestyle{plain}}, pages={1,2}]{' . "../../../tex/$pdfname" ."}\n";

#print LATEXFILE "\\begin{center}\n";
#print LATEXFILE "\\vspace{-0.2cm}\\includegraphics[scale=0.65]{../../../tex/$pdfname}\n";

#print LATEXFILE "\\end{center}\n\n";
#print LATEXFILE "\\newpage\n";


}# end while over assessments

}# end while over family

}# end while over order


close LATEXFILE;

# close database connection
$dbh->disconnect();
