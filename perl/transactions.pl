# this is from O'Reilly's book "Programming the Perl DBI
#
#### Connect to the database with transactions and error handing enabled
my $dbh = DBI->connect( "dbi:Oracle:archaeo", "username", "password" , {
    AutoCommit => 0,
    RaiseError => 1,
} );

### Keep a count of failures. Used for program exit status
my @failed;

foreach my $country_code ( qw(US CA GB IE FR) ) {

    print "Processing $country_code\n";

    ### Do all the work for one country inside an eval
    eval {

        ### Read, parse and sanity check the data file (e.g., using DBD::CSV)
        my $data = load_sales_data_file( "$country_file.csv" );

        ### Add data from the Web (e.g., using the LWP modules)
        add_exchange_rates( $data, $country_code,
                            "http://exchange-rate-service.com" );

        ### Perform database loading steps (e.g., using DBD::Oracle)
        insert_sales_data( $dbh, $data );
        update_country_summary_data( $dbh, $data );
        insert_processed_files( $dbh, $country_code );

        ### Everything done okay for this file, so commit the database changes
        $dbh->commit();

    };

    ### If something went wrong...
    if ($@) {

        ### Tell the user that something went wrong, and what went wrong
        warn "Unable to process $country_code: $@\n";
        ### Undo any database changes made before the error occured
        $dbh->rollback();

        ### Keep track of failures
        push @failed, $country_code;

    }
}
$dbh->disconnect();

### Exit with useful status value for caller
exit @failed ? 1 : 0;




##########################
#########################
# this is from http://www.saturn5.com/~jwb/dbi-examples.html

use strict;
use DBI qw(:sql_types);

my $dbh = DBI->connect( 'dbi:Oracle:orcl',
                        'jeffrey',
                        'jeffspassword',
                        {
                          RaiseError => 1,
                          AutoCommit => 0
                        }
                      ) || die "Database connection not made: $DBI::errstr";

my @records = (
                [ 0, "Larry Wall",      "Perl Author",  "555-0101" ],
                [ 1, "Tim Bunce",       "DBI Author",   "555-0202" ],
                [ 2, "Randal Schwartz", "Guy at Large", "555-0303" ],
                [ 3, "Doug MacEachern", "Apache Man",   "555-0404" ] 
              );

my $sql = qq{ INSERT INTO employees VALUES ( ?, ?, ?, ? ) };
my $sth = $dbh->prepare( $sql );


for( @records ) {
  eval {
    $sth->bind_param( 1, @$_->[0], SQL_INTEGER );
    $sth->bind_param( 2, @$_->[1], SQL_VARCHAR );
    $sth->bind_param( 3, @$_->[2], SQL_VARCHAR );
    $sth->bind_param( 4, @$_->[3], SQL_VARCHAR );
    $sth->execute();
    $dbh->commit();
  };

  if( $@ ) {
    warn "Database error: $DBI::errstr\n";
    $dbh->rollback(); #just die if rollback is failing
  }
}

$sth->finish();
$dbh->disconnect();
