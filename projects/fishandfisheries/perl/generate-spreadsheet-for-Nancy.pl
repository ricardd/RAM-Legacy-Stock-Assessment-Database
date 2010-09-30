#!/usr/bin/perl -w
# a Perl script to generate a spreadsheet for Nancy Roney who is helping me out with citations
# Daniel Ricard, started 2010-09-29
# Time-stamp: <2010-09-29 11:41:54 (srdbadmin)>

use strict;
use warnings;
use DBI;
use Spreadsheet::WriteExcel;
use POSIX qw(strftime);


sub autofit_columns {

    my $worksheet = shift;
    my $col       = 0;

    for my $width (@{$worksheet->{__col_widths}}) {

        $worksheet->set_column($col, $col, $width) if $width;
        $col++;
    }
}

sub store_string_widths {

    my $worksheet = shift;
    my $col       = $_[1];
    my $token     = $_[2];

    # Ignore some tokens that we aren't interested in.
    return if not defined $token;       # Ignore undefs.
    return if $token eq '';             # Ignore blank cells.
    return if ref $token eq 'ARRAY';    # Ignore array refs.
    return if $token =~ /^=/;           # Ignore formula

    # Ignore numbers
    return if $token =~ /^([+-]?)(?=\d|\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?$/;

    # Ignore various internal and external hyperlinks. In a real scenario
    # you may wish to track the length of the optional strings used with
    # urls.
    return if $token =~ m{^[fh]tt?ps?://};
    return if $token =~ m{^mailto:};
    return if $token =~ m{^(?:in|ex)ternal:};


    # We store the string width as data in the Worksheet object. We use
    # a double underscore key name to avoid conflicts with future names.
    #
    my $old_width    = $worksheet->{__col_widths}->[$col];
    my $string_width = string_width($token);

    if (not defined $old_width or $string_width > $old_width) {
        # You may wish to set a minimum column width as follows.
        #return undef if $string_width < 10;

        $worksheet->{__col_widths}->[$col] = $string_width;
    }


    # Return control to write();
    return undef;
}

sub string_width {

    return 0.9 * length $_[0];
}

my $datetime = strftime "%Y-%m-%d %H:%M:%S %Z", localtime;

# open a connection to the database
my $dbh = DBI->connect("dbi:Pg:dbname=srdb;host=localhost;port=5432;" ,
                      "srdbuser", "srd6us3r!")
		      || die "Database connection not made: $DBI::errstr";


# create spreadsheet file
my $workbook = Spreadsheet::WriteExcel->new("spreadhseet-for-Nancy.xls");

# Add 4 worksheets
$workbook->compatibility_mode();
$workbook->set_properties(
title    => 'This is a spreadsheet containing the necessary data for Nancy Roney to work on the srdb citations',
author   => 'Daniel Ricard',
comments => 'Created with Perl and Spreadsheet::WriteExcel, with contents from the RAM Legacy database',
);

my $sheet0 = $workbook->add_worksheet("stock list");

$sheet0->write(0, 0, "Spreadsheet for Nancy Roney");
$sheet0->write(1, 0, "Created on:" . $datetime);
#$sheet0->write(1, 1, $datetime);

my $sql = qq{ select ass.mgmt, a.assessid, s.stocklong, t.scientificname, a.pdffile from srdb.assessment a, srdb.stock s, srdb.taxonomy t, srdb.assessor ass where a.assessorid=ass.assessorid and a.stockid = s.stockid and s.tsn=t.tsn and a.assess=1 and a.recorder !='MYERS' order by ass.mgmt, t.scientificname };
my $handle = $dbh -> prepare($sql);
$handle -> execute();

my $nn = $handle->{NUM_OF_FIELDS};
my $format = $workbook->add_format(bold=>1, size=>12);

## for autofit
$sheet0->add_write_handler(qr[\w], \&store_string_widths);

## increase column width
## $sheet1->set_column(1, $nn,  50);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet0->write(2, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

my $rowcounter = 3;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet0->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet0);

#----------------
$dbh->disconnect();

