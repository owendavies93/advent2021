#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

use lib '../cheatsheet/lib';

use Advent::Grid::Dense::Square;

use List::Util qw(product);
use List::MoreUtils qw(all);

my $width;
my @grid = ();
while (<>) {
    chomp;
    my @l = split //;
    $width = scalar @l if !defined $width;
    push @grid, @l;
}

my $g = Advent::Grid::Dense::Square->new({
    grid => \@grid,
    width => $width,
});

my @lows = ();
for (my $i = 0; $i < scalar @grid; $i++) {
    my $val = $g->get_at_index($i);
    if (all { $val < $_ } $g->neighbour_vals_from_index($i)) {
        push @lows, $i;
    }
}

my @basins = ();

for my $l (@lows) {
    my @q = ($l);
    my $seen = {};

    while (scalar @q) {
        my $i = shift @q;
        my @nis = $g->neighbours_from_index($i);
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

