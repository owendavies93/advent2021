#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

use lib '../cheatsheet/lib';

use Advent::Grid::Dense::Diagonal;

use List::MoreUtils qw(any);

my $width;
my @grid = ();
while (<>) {
    chomp;
    my @l = split //;
    $width = scalar @l if !defined $width;
    push @grid, @l;
}

my $g = Advent::Grid::Dense::Diagonal->new({
    grid => \@grid,
    width => $width,
});

my $total = 0;
my $steps = 100;
while ($steps--) {
    for (my $i = 0; $i < scalar @grid; $i++) {
        $g->inc_at_index($i);
    }

    while (any { $_ > 9 } @grid) {
        for (my $i = 0; $i < scalar @grid; $i++) {
            if ($g->get_at_index($i) > 9) {
                my @ns = $g->neighbours_from_index($i);
                for my $j (@ns) {
                    $g->inc_at_index($j) if $g->get_at_index($j) != 0;
                }
                $g->set_at_index($i, 0);
                $total++;
            }
        }
    }
}

say $total;

