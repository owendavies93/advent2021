#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

use List::Util qw(sum);

my @nums = split /,/, scalar(<>);

my $min = ~0;
for my $n (@nums) {
    my $sum = sum map { abs($_ - $n) } @nums;
    $min = $sum if $sum < $min;
}

say $min;
