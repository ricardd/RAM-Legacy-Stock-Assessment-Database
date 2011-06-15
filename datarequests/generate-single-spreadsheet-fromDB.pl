#!/usr/bin/perl -w
# script to generate a single Excel file with each table from srdb as a separate worksheet
# Daniel Ricard
# Started: 2011-06-13 from initial script for Rainer Froese's F&F request
# Time-stamp: <2011-06-13 20:11:58 (srdbadmin)>
# Modification history:

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
my $workbook = Spreadsheet::WriteExcel->new("HILBORN-RAMLegacy-June2011.xls");

# Add 4 worksheets
$workbook->compatibility_mode();
$workbook->set_properties(
title    => 'This is a single spreadsheet containing the table contents from the RAM Legacy database.',
author   => 'Daniel Ricard',
comments => 'Created with Perl and Spreadsheet::WriteExcel, with contents from the RAM Legacy database',
);

my $sheet0 = $workbook->add_worksheet("README");

$sheet0->write(0, 0, "Single spreadsheet of the RAM Legacy database.");
$sheet0->write(1, 0, "Created on:" . $datetime);
#$sheet0->write(1, 1, $datetime);


## AREA
my $sheet1 = $workbook->add_worksheet("area");

my $sql = qq{SELECT * from srdb.area };
my $handle = $dbh -> prepare($sql);
$handle -> execute();

my $nn = $handle->{NUM_OF_FIELDS};
my $format = $workbook->add_format(bold=>1, size=>12);

## for autofit
$sheet1->add_write_handler(qr[\w], \&store_string_widths);

## increase column width
## $sheet1->set_column(1, $nn,  50);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet1->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

my $rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet1->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet1);


## ASSESSMENT
my $sheet2 = $workbook->add_worksheet("assessment");

$sql = qq{SELECT * from srdb.assessment where recorder !='MYERS' and assess=1 };
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet2->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet2->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet2->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet2);

## ASSESSMETHOD 
my $sheet3 = $workbook->add_worksheet("assessmethod");

$sql = qq{SELECT * from srdb.assessmethod };
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet3->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet3->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet3->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet3);

## ASSESSOR
my $sheet4 = $workbook->add_worksheet("assessor");

$sql = qq{SELECT * from srdb.assessor };
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet4->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet4->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet4->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet4);


## BIOMETRICS
my $sheet5 = $workbook->add_worksheet("biometrics");

$sql = qq{SELECT * from srdb.biometrics };
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet5->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet5->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet5->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet5);

## BIOPARAMS
my $sheet6 = $workbook->add_worksheet("bioparams");

$sql = qq{SELECT * from srdb.bioparams };
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet6->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet6->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet6->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet6);

## MANAGEMENT
my $sheet7 = $workbook->add_worksheet("management");

$sql = qq{SELECT * from srdb.management };
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet7->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet7->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet7->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet7);

## RECORDER
my $sheet8 = $workbook->add_worksheet("recorder");

$sql = qq{SELECT * from srdb.recorder };
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet8->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet8->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet8->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet8);

## STOCK
my $sheet9 = $workbook->add_worksheet("stock");

$sql = qq{SELECT * from srdb.stock };
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet9->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet9->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet9->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet9);

## TAXONOMY
my $sheet10 = $workbook->add_worksheet("taxonomy");

$sql = qq{SELECT * from srdb.taxonomy };
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet10->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet10->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet10->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet10);

## TIMESERIES
my $sheet11 = $workbook->add_worksheet("timeseries");
$sql = qq{SELECT * from srdb.timeseries where assessid in (SELECT assessid from srdb.assessment where recorder !='MYERS' and assess=1) };
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet11->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet11->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet11->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet11);


my $sheet12 = $workbook->add_worksheet("tsmetrics");
$sql = qq{SELECT * from srdb.tsmetrics };
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet12->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet12->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet12->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet12);

## FISHBASESAUPCODES
my $sheet13 = $workbook->add_worksheet("fishbasesaupcodes");
$sql = qq{SELECT * from srdb.fishbasesaupcodes };
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet13->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet13->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet13->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet13);

## SPFITS
my $sheet14 = $workbook->add_worksheet("spfits");
$sql = qq{SELECT * from srdb.spfits };
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet14->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet14->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet14->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet14);


my $sheet15 = $workbook->add_worksheet("timeseries_values_view");
$sql = qq{SELECT * from srdb.timeseries_values_view where assessid in (SELECT assessid from srdb.assessment where recorder !='MYERS' and assess=1)};
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet15->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet15->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet15->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet15);

my $sheet16 = $workbook->add_worksheet("timeseries_units_view");
$sql = qq{SELECT * from srdb.timeseries_units_view where assessid in (SELECT assessid from srdb.assessment where recorder !='MYERS' and assess=1) };
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet16->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet16->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet16->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet16);

my $sheet17 = $workbook->add_worksheet("reference_point_values_view");
$sql = qq{SELECT * from srdb.reference_point_values_view where assessid in (SELECT assessid from srdb.assessment where recorder !='MYERS' and assess=1)};
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet17->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet17->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet17->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet17);

my $sheet18 = $workbook->add_worksheet("reference_point_units_view");
$sql = qq{SELECT * from srdb.reference_point_units_view where assessid in (SELECT assessid from srdb.assessment where recorder !='MYERS' and assess=1)};
$handle = $dbh -> prepare($sql);
$handle -> execute();
$nn = $handle->{NUM_OF_FIELDS};

## for autofit
$sheet18->add_write_handler(qr[\w], \&store_string_widths);

## write header
  for(my $c = 1; $c<=$nn; $c++) {
$sheet18->write(1, $c, $handle->{NAME_uc}->[$c-1], $format);
  }

$rowcounter = 2;
while (my @row = $handle->fetchrow_array) {  # retrieve one row
  for(my $c = 1; $c<=$nn; $c++) {
$sheet18->write($rowcounter, $c, $row[$c-1]);
  }
$rowcounter = $rowcounter + 1;
    }

# Run the autofit after you have finished writing strings to the workbook.
autofit_columns($sheet18);


#----------------
$dbh->disconnect();


## then, run 
## postgresql_autodoc -d srdb -s srdb --table=area,assessment,assessmethod,assessor,biometrics,bioparams,management,recorder,stock,taxonomy,timeseries,tsmetrics,fishbasesaupcodes,spfits,timeseries_values_view,timeseries_units_view,reference_point_values_view,reference_point_units_view
