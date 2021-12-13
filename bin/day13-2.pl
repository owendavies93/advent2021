#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

my @grid = ();
my $maxx = -1;
my $maxy = -1;
while (<>) {
    chomp;

    last if !$_;

    my ($x, $y) = split /,/;
    $grid[$x][$y] = 1;

    $maxx = $x if $x > $maxx;
    $maxy = $y if $y > $maxy;
}

for my $y (0..$maxy) {
    for my $x (0..$maxx) {
        $grid[$x][$y] = 0 unless defined $grid[$x][$y];
    }
}

my @folds = ();
while (<>) {
    chomp;

    my ($dir) = /fold along (\w)/;
    push @folds, $dir;
}


@grid = fold(\@grid, $_) for @folds;

print_grid(@grid);

sub fold {
    my ($old_grid, $dir) = @_;

    my $new_width = scalar @$old_grid - 1;
    my $new_height = scalar @{$old_grid->[0]} - 1;
    my $oldmaxx = $new_width;
    my $oldmaxy = $new_height;

    my $yfold = $dir eq 'y' ? 1 : 0;

    my @new_grid = ();

    if ($yfold) {
        $new_height = int($new_height / 2);
    } else {
        $new_width = int($new_width / 2);
    }

    for my $y (0..$oldmaxy) {
        for my $x (0..$oldmaxx) {
            if ($old_grid->[$x][$y] == 1) {
                if (($yfold && $y < $new_height) ||
                    (!$yfold && $x < $new_width)) {
                    $new_grid[$x][$y] = $old_grid->[$x][$y];
                } elsif ($yfold) {
                    $new_grid[$x][$oldmaxy - $y] = $old_grid->[$x][$y];
                } elsif (!$yfold) {
                    $new_grid[$oldmaxx - $x][$y] = $old_grid->[$x][$y];
                }
            } else {
                if (($yfold && $y < $new_height) ||
                    (!$yfold && $x < $new_width)) {
                    $new_grid[$x][$y] = 0;
                }
            }
        }
    }

    return @new_grid;
}

sub print_grid {
    my @g = @_;
    my $width = scalar @g - 1;
    my $height = scalar @{$g[0]} - 1;

    for my $y (0..$height) {
        for my $x (0..$width) {
            print $g[$x][$y] == 1 ? '#' : '.';
        }
        print "\n";
    }
    print "\n\n";
}
