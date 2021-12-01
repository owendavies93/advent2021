#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

my $i = 0;
my $last = -1;
while (<>) {
    chomp;
    $i++ if ($_ > $last);
    $last = $_;

}

say $i - 1;
