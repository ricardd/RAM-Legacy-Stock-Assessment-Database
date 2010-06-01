#!/usr/bin/perl -w
# testing code for multi-dimensional arrays
# Daniel Ricard
# Started: 2008-07-21
# Last modified Time-stamp: <2008-07-21 14:01:34 (ricardd)>
#

use strict;

my @first = ('cat', 'dog', 'rabbit');
my @second = ('cod','trout','squid');
my @third = ('Bud','Guinness','Pabst');

print("@first\n");
print("@second\n");
print("@third\n");

my @all = (\@first,\@second,\@third);
#@all = push(@all, \@first);
print("@all\n");
print("$all[1]\n");
#print("@all[1]->[0]\n");
print("$all[1]->[0]\n");
print("$all[1]->[1]\n");
print("$all[1]->[2]\n\n");
print("$all[2]->[0]\n");
push(@all, \@first);

print("$all[3]->[0]\n");

my @all2;

# now try with a loop
for(my $iR = 0; $iR<10; $iR++)
  {
my @temp = ($iR,1,2,3,4,5,6,7);
push(@all2,\@temp);
print("inside: @temp\n");
  } # end loop over $iR

print("outside: @all2\n");
print("outside index 0: @all2[0]->[0]\n");
print("outside index 1: @all2[1]->[0]\n");
