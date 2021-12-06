#!/usr/bin/env perl

use strict;
use warnings;

use v5.16;

use List::Util qw(sum);

my $counts = {};
$counts->{$_} = 0 for (0..8);
while (<>) {
    chomp;
    for my $n (split /,/) {
        $counts->{$n} += 1;
    }
}

my $gens = 256;
for (1..$gens) {
    my $zeros = $counts->{0};

    for (0..7) {
        $counts->{$_} = $counts->{$_ + 1};
    }

    $counts->{6} += $zeros;
    $counts->{8} = $zeros;
}

say sum(values %$counts);
