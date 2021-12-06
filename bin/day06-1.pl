#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

my @timers;
while (<>) {
    chomp;
    @timers = split /,/, $_;
}

my $gens = 80;
my $i = 0;
while ($i < $gens) {
    my $gen_length = scalar @timers;
    for (my $j = 0; $j < $gen_length; $j++) {
        my $t = $timers[$j];
        if ($t == 0) {
            $timers[$j] = 6;
            push @timers, 8;
        } else {
            $timers[$j]--;
        }
    }

    $i++;
}

say scalar @timers;
