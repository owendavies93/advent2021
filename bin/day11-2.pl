#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

use List::MoreUtils qw(any);

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

my $i = 1;
while (1) {
    my $total = 0;

    for (my $i = 0; $i < scalar @grid; $i++) {
        $grid[$i]++;
    }

    while (any { $_ > 9 } @grid) {
        for (my $i = 0; $i < scalar @grid; $i++) {
            if ($grid[$i] > 9) {
                my @ns = neighbour_from_index($i);
                for my $j (@ns) {
                    $grid[$j]++ if $grid[$j] != 0;
                }
                $grid[$i] = 0;
                $total++;
            }
        }
    }

    if ($total == $height * $width) {
        say $i;
        exit;
    }

    $i++;
}

sub check_bounds {
    my $index = shift;
    return ($index >= 0 && $index < scalar @grid);
}

sub neighbour_from_index {
    my $i = shift;

    my @cans = ($i + $width, $i - $width);
    if ($i % $width == 0) {
        push @cans, ($i + 1, $i - $width + 1, $i + $width + 1);
    } elsif ($i % $width == ($width - 1)) {
        push @cans, ($i - 1, $i - $width - 1, $i + $width - 1);
    } else {
        push @cans, (
            $i + 1, $i - 1, $i - $width + 1, $i + $width + 1,
            $i - $width - 1, $i + $width - 1
        );
    }
    return grep { check_bounds($_) } @cans;
}

