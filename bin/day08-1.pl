#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

my $count = 0;
while (<>) {
    chomp;
    my ($output) = /\|\s*(.*)$/;
    my @combs = split / /, $output;
    for my $c (@combs) {
        $count++ if (length $c <= 4 || length $c == 7)
    }
}

say $count;
