#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

use List::Util qw(product);
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

my @lows = ();
for (my $i = 0; $i < scalar @grid; $i++) {
    my $val = $grid[$i];
    my @nis = neighbour_from_index($i);
    my @nvs = map { $grid[$_] } @nis;
    if (all { $val < $_ } @nvs) {
        push @lows, $i;
    }
}

my @basins = ();

for my $l (@lows) {
    my @q = ($l);
    my $seen = {};

    while (scalar @q) {
        my $i = shift @q;
        my @nis = neighbour_from_index($i);
        foreach my $ni (@nis) {
            if (!defined $seen->{$ni} && $grid[$ni] != 9) {
                $seen->{$ni} = 1;
                push @q, $ni;
            }
        }
    }

    push @basins, scalar keys %$seen;
}

my @top3 = (sort { $b <=> $a } @basins)[0..2];
say product @top3;

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
