#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

my $pos = 0;
my $aim = 0;
my $depth = 0;

while (<>) {
    chomp;
    $aim += $1 if (/^down (\d+)$/);
    $aim -= $1 if (/^up (\d+)$/);

    if (/^forward (\d+)$/) {
        $pos += $1;
        $depth += ($aim * $1);
    }
}

say $pos * $depth;
