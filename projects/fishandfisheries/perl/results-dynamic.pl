#!/usr/bin/perl -w
# a Perl script to generate a LaTeX file with the results
# DR CM
# Time-stamp: <2009-12-07 11:45:36 (srdbadmin)>
use strict;
use warnings;
use DBI;
# open a connection to the database
my $dbh = DBI->connect("dbi:Pg:dbname=srdb;host=localhost;port=5432;" ,
                      "srdbuser", "srd6us3r!")
		      || die "Database connection not made: $DBI::errstr";


open OUT, ">/home/srdbadmin/SQLpg/srdb/trunk/projects/fishandfisheries/tex/results-dynamic.tex" or die $!;



open IN, "/home/srdbadmin/SQLpg/srdb/trunk/projects/fishandfisheries/tex/fishandfisheries-results-dynamic.tex" or die $!;

# loop over lines in the IN file
while ($_ = <IN> ) {

# loop over flags
my $sqlresults = qq{select * from fishfisheries.results};
my $sth1 = $dbh->prepare( $sqlresults );
$sth1->execute();
my($flag,$value);
while ( ($flag, $value) = $sth1->fetchrow_array() ) 
{
#print ($flag . " " .$value . "\n");
  if($_ =~ /$flag/ ) {
$_ =~ s/$flag/$value/gs;
}

}
print OUT "$_";


}

close(IN);




close(OUT);




# close database connection
$dbh->disconnect();
