#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

use List::Util qw(min max);

my $points = {};
my $overlaps = 0;

while (<>) {
    chomp;
    my ($startx, $starty, $endx, $endy) = /^(\d+),(\d+) -> (\d+),(\d+)$/;
    $points->{$startx} = {} if !defined $points->{$startx};

    if ($startx == $endx) {
        for my $y (min(($starty, $endy)) .. max(($starty, $endy))) {
            mark($startx, $y);
        }
    } elsif ($starty == $endy) {
        for my $x (min(($startx, $endx)) .. max(($startx, $endx))) {
            mark($x, $starty);
        }
    } else {
        if ($endx > $startx) {
            if ($endy > $starty) {
                while ($startx <= $endx && $starty <= $endy) {
                    mark($startx, $starty);
                    $startx++;
                    $starty++;
                }
            } else {
                while ($startx <= $endx && $starty >= $endy) {
                    mark($startx, $starty);
                    $startx++;
                    $starty--;
                }
            }
        } else {
            if ($endy > $starty) {
                while ($startx >= $endx && $starty <= $endy) {
                    mark($startx, $starty);
                    $startx--;
                    $starty++;
                }
            } else {
                while ($startx >= $endx && $starty >= $endy) {
                    mark($startx, $starty);
                    $startx--;
                    $starty--;
                }
            }
        }
    }
}

sub mark {
    my ($x, $y) = @_;

    $points->{$x}->{$y}++;
    $overlaps++ if ($points->{$x}->{$y} == 2);
}

say $overlaps;
