#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

my $depth = 0;
my $pos = 0;
while (<>) {
    chomp;
    $pos += $1 if (/^forward (\d+)$/);
    $depth -= $1 if (/^up (\d+)$/);
    $depth += $1 if (/^down (\d+)$/);
}

say $pos * $depth;
