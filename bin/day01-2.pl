#!/usr/bin/env perl
use strict;
use warnings;

use List::Util qw(sum);

use v5.16;

my $inc = 0;
my @lines;
while (<>) {
    chomp;
    push @lines, $_;
}

my $last = -1;
for (my $i = 1; $i < $#lines - 1; $i++) {
    my $sum = sum @lines[$i .. $i + 2];
    $inc++ if ($sum > $last);
    $last = $sum;
}

say $inc;
