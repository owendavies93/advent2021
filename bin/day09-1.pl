#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

use lib '../cheatsheet/lib';

use Advent::Grid::Dense::Square;

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

my $total = 0;

my @lows = ();
for (my $i = 0; $i < scalar @grid; $i++) {
    my $val = $g->get_at_index($i);
    if (all { $val < $_ } $g->neighbour_vals_from_index($i)) {
        $total += (1 + $val);
    }
}

say $total;

