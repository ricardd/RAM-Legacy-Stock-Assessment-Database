#!/usr/bin/perl -w

use DBI;

#my $dbh = DBI->connect('dbi:Pg:dbname=gfsDB;host=localhost;port=5433','ricardd','ricardd')|| die "Database connection not made: $DBI::errstr";
my $dbh = DBI->connect('dbi:Pg:dbname=srDB;host=localhost;port=5432','ricardd','ricardd')|| die "Database connection not made: $DBI::errstr";

my $sql = qq{ SELECT COUNT(*) FROM srDB.tsmetrics };
my $sth = $dbh->prepare( $sql );
$sth->execute();

my( $tot );
$sth->bind_columns( undef, \$tot );

while( $sth->fetch() ) {
  print "$tot\n";
}


$dbh->disconnect();

