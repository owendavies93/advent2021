#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

use List::MoreUtils qw(all);

my $width;
my $height = 0;

my @grid = ();
while (<>) {
    chomp;
    my @l = split //;
    $width = scalar @l if !defined $width;
    push @grid, @l;
    $height++;
}

my $total = 0;

my @lows = ();
for (my $i = 0; $i < scalar @grid; $i++) {
    my $val = $grid[$i];
    my @nis = neighbour_from_index($i);
    my @nvs = map { $grid[$_] } @nis;
    if (all { $val < $_ } @nvs) {
        $total += (1 + $val);
    }
}

say $total;

sub check_bounds {
    my $index = shift;
    return ($index >= 0 && $index < scalar @grid);
}

sub neighbour_from_index {
    my $i = shift;

    my @cans;
    if ($i % $width == 0) {
        @cans = ($i + 1, $i + $width, $i - $width);
    } elsif ($i % $width == ($width - 1)) {
        @cans = ($i - 1, $i + $width, $i - $width);
    } else {
        @cans = ($i + 1, $i - 1, $i + $width, $i - $width);
    }
    return grep { check_bounds($_) } @cans;
}

