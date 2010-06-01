#!/usr/bin/perl -w
# generate the Excel file containing the data shared by different analysts
# Daniel Ricard 2008-02-08

use strict;
use Spreadsheet::ParseExcel;
use Spreadsheet::WriteExcel;
use Data::Dumper;

use DBI;
my $dbh = DBI->connect('dbi:Pg:dbname=gfsDB;host=localhost;port=5433','ricardd','ricardd')|| die "Database connection not made: $DBI::errstr";


my $destname = "../srDB/data/srDB-shared-data.xls";

my $dest_book  = Spreadsheet::WriteExcel->new("$destname")
 or die "Could not create a new Excel file in $destname: $!";
print "\n\nSaving contents of database tables in $destname...\n\n";

my $row = 2;

my $sheet ="srDB.assessors";
my $dest_sheet = $dest_book->addworksheet($sheet);
my $sql = qq{ SELECT * FROM srDB.assessor };
my $sth = $dbh->prepare( $sql );
$sth->execute();
my( $assessorid, $rfmo, $country, $assessorfull );
$sth->bind_columns( undef, \$assessorid, \$rfmo, \$country, \$assessorfull );
$dest_sheet->write($row-2, 0, "assessorid");
$dest_sheet->write($row-2, 1, "rfmo");
$dest_sheet->write($row-2, 2, "country");
$dest_sheet->write($row-2, 3, "assessorfull");
while( $sth->fetch() ) {
    $dest_sheet->write($row, 0, $assessorid);
    $dest_sheet->write($row, 1, $rfmo);
    $dest_sheet->write($row, 2, $country);
    $dest_sheet->write($row, 3, $assessorfull);
$row = $row + 1;
}
print "assessors worksheet written\n";


$sheet ="srDB.stocks";
$dest_sheet = $dest_book->addworksheet($sheet);
$sql = qq{ SELECT * FROM srDB.stock };
$sth = $dbh->prepare( $sql );
$sth->execute();
my( $stockid, $tsn, $scientificname, $commonname, $areaid, $stocklong, $inmyersdb );
$sth->bind_columns( undef,   \$stockid, \$tsn, \$scientificname, \$commonname, \$areaid, \$stocklong, \$inmyersdb );
$row = 2;
$dest_sheet->write($row-2, 0, "stockid");
$dest_sheet->write($row-2, 1, "tsn");
$dest_sheet->write($row-2, 2, "scientificname");
$dest_sheet->write($row-2, 3, "commonname");
$dest_sheet->write($row-2, 4, "areaid");
$dest_sheet->write($row-2, 5, "stocklong");
$dest_sheet->write($row-2, 6, "inmyersdb");
while( $sth->fetch() ) {
    $dest_sheet->write($row, 0, $stockid);
    $dest_sheet->write($row, 1, $tsn);
    $dest_sheet->write($row, 2, $scientificname);
    $dest_sheet->write($row, 3, $commonname);
    $dest_sheet->write($row, 4, $areaid);
    $dest_sheet->write($row, 5, $stocklong);
    $dest_sheet->write($row, 6, $inmyersdb);
$row = $row + 1;
}
print "stocks worksheet written\n";


$sheet ="srDB.biometrics";
$dest_sheet = $dest_book->addworksheet($sheet);
$sql = qq{ SELECT * FROM srDB.biometrics };
$sth = $dbh->prepare( $sql );
$sth->execute();
my( $bioshort, $biolong, $biounitsshort, $biounitslong );
$sth->bind_columns( undef,  \$bioshort, \$biolong, \$biounitsshort, \$biounitslong );
$row = 2;
$dest_sheet->write($row-2, 0, "bioshort");
$dest_sheet->write($row-2, 1, "biolong");
$dest_sheet->write($row-2, 2, "biounitsshort");
$dest_sheet->write($row-2, 3, "biounitslong");
while( $sth->fetch() ) {
    $dest_sheet->write($row, 0, $bioshort);
    $dest_sheet->write($row, 1, $biolong);
    $dest_sheet->write($row, 2, $biounitsshort);
    $dest_sheet->write($row, 3, $biounitslong);
$row = $row + 1;
}
print "point metrics worksheet written\n";


$sheet ="srDB.tsmetrics";
$dest_sheet = $dest_book->addworksheet($sheet);
$sql = qq{ SELECT * FROM srDB.tsmetrics };
$sth = $dbh->prepare( $sql );
$sth->execute();
my( $tsshort, $tslong, $tsunitsshort, $tsunitslong );
$sth->bind_columns( undef,  \$tsshort, \$tslong, \$tsunitsshort, \$tsunitslong );
$row = 2;
$dest_sheet->write($row-2, 0, "tsshort");
$dest_sheet->write($row-2, 1, "tslong");
$dest_sheet->write($row-2, 2, "tsunitsshort");
$dest_sheet->write($row-2, 3, "tsunitslong");
while( $sth->fetch() ) {
    $dest_sheet->write($row, 0, $tsshort);
    $dest_sheet->write($row, 1, $tslong);
    $dest_sheet->write($row, 2, $tsunitsshort);
    $dest_sheet->write($row, 3, $tsunitslong);
$row = $row + 1;
}
print "time-series metrics worksheet written\n";


$sheet ="srDB.assessmethods";
$dest_sheet = $dest_book->addworksheet($sheet);
$sql = qq{ SELECT * FROM srDB.assessmethod };
$sth = $dbh->prepare( $sql );
$sth->execute();
my( $methodshort, $methodlong );
$sth->bind_columns( undef, \$methodshort, \$methodlong);
$row = 2;
$dest_sheet->write($row-2, 0, "methodshort");
$dest_sheet->write($row-2, 1, "methodlong");
while( $sth->fetch() ) {
    $dest_sheet->write($row, 0, $methodshort);
    $dest_sheet->write($row, 1, $methodlong);
$row = $row + 1;
}
print "assessment methods worksheet written\n";


$sheet ="srDB.taxonomy";
$dest_sheet = $dest_book->addworksheet($sheet);
$sql = qq{ SELECT * FROM srDB.taxonomy };
$sth = $dbh->prepare( $sql );
$sth->execute();
my( $kingdom, $phylum, $classname, $ordername, $family, $genus, $species, $myersname, $commonname1, $commonname2 );
$sth->bind_columns( undef,  \$tsn, \$scientificname, \$kingdom, \$phylum, \$classname, \$ordername, \$family, \$genus, \$species, \$myersname, \$commonname1, \$commonname2);
$row = 2;
$dest_sheet->write($row-2, 0, "tsn");
$dest_sheet->write($row-2, 1, "scientificname");
$dest_sheet->write($row-2, 2, "kingdom");
$dest_sheet->write($row-2, 3, "phylum");
$dest_sheet->write($row-2, 4, "class");
$dest_sheet->write($row-2, 5, "order");
$dest_sheet->write($row-2, 6, "family");
$dest_sheet->write($row-2, 7, "genus");
$dest_sheet->write($row-2, 8, "species");
$dest_sheet->write($row-2, 9, "myersname");
$dest_sheet->write($row-2, 10, "commonname1");
$dest_sheet->write($row-2, 11, "commonname2");

while( $sth->fetch() ) {
    $dest_sheet->write($row, 0, $tsn);
    $dest_sheet->write($row, 1, $scientificname);
    $dest_sheet->write($row, 2, $kingdom);
    $dest_sheet->write($row, 3, $phylum);
    $dest_sheet->write($row, 4, $classname);
    $dest_sheet->write($row, 5, $ordername);
    $dest_sheet->write($row, 6, $family);
    $dest_sheet->write($row, 7, $genus);
    $dest_sheet->write($row, 8, $species);
    $dest_sheet->write($row, 9, $myersname);
    $dest_sheet->write($row, 10, $commonname1);
    $dest_sheet->write($row, 11, $commonname2);
$row = $row + 1;
}
print "taxonomy worksheet written\n";


$sheet ="srDB.area";
$dest_sheet = $dest_book->addworksheet($sheet);
$sql = qq{ SELECT * FROM srDB.area };
$sth = $dbh->prepare( $sql );
$sth->execute();
my( $areacode, $areaname, $alternateareaname );
$sth->bind_columns( undef, \$country, \$rfmo, \$areacode, \$areaname, \$alternateareaname, \$areaid );
$row = 2;
$dest_sheet->write($row-2, 0, "areaid");
$dest_sheet->write($row-2, 1, "country");
$dest_sheet->write($row-2, 2, "rfmo");
$dest_sheet->write($row-2, 3, "areacode");
$dest_sheet->write($row-2, 4, "areaname");
$dest_sheet->write($row-2, 5, "alternateareaname");

while( $sth->fetch() ) {
    $dest_sheet->write($row, 0, $areaid);
    $dest_sheet->write($row, 1, $country);
    $dest_sheet->write($row, 2, $rfmo);
    $dest_sheet->write($row, 3, $areacode);
    $dest_sheet->write($row, 4, $areaname);
    $dest_sheet->write($row, 5, $alternateareaname);
$row = $row + 1;
}
print "areas worksheet written\n";


$dest_book->close();

print "\n\ndone!\n";

$dbh->disconnect();
