#!/usr/bin/perl
use strict;
#use warnings;

my @numbers = ('1','2','10','1.2','1e2','1.02e2','1.02e-2','e-2','er','et','0er');

foreach my $number (@numbers) {
    my $test = $number;
    if (eval { $test +=0 }) {
        print "$number is a number \n"
      }}

