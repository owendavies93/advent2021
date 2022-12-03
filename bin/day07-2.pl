#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

use List::Util qw(sum min max);

my @nums = split /,/, scalar(<>);

my $min = ~0;
my $start = min @nums;
my $end = max @nums;
for my $n ($start .. $end) {
    my $sum = sum map {
        my $diff = abs($_ - $n);
        ($diff * ($diff + 1)) / 2;
    } @nums;
    $min = $sum if $sum < $min;
}

say $min;
