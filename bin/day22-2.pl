#!/usr/bin/env perl
use Mojo::Base -strict;

use List::Util qw(sum);

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day22';
$file = "inputs/day22-$file" if $file =~ /test/;
open(my $fh, '<', $file) or die $!;

my @steps = ();
my @cuboids = ();

while (<$fh>) {
    chomp;
    my ($state) = (split ' ');
    push @steps, $state;
    push @cuboids, [m/(-?\d+)/g];
}

my @non_overlapping_cuboids = ();

for (my $i = 0; $i < scalar @steps; $i++) {
    my $state  = $steps[$i];
    my $cuboid = $cuboids[$i];
    $cuboid->[1]++;
    $cuboid->[3]++;
    $cuboid->[5]++;

    @non_overlapping_cuboids = map {
        cuboid_difference($_, $cuboid)
    } @non_overlapping_cuboids;

    push @non_overlapping_cuboids, $cuboid if $state eq 'on';
}

say sum map {
    ($_->[1] - $_->[0]) * ($_->[3] - $_->[2]) * ($_->[5] - $_->[4])
} @non_overlapping_cuboids;

sub cuboid_difference {
    my ($x, $y) = @_;

    return () if wholly_contains($y, $x);

    return ($x) if !intersects($x, $y);

    my @xrange = ($x->[0], $x->[1]);
    my @yrange = ($x->[2], $x->[3]);
    my @zrange = ($x->[4], $x->[5]);

    push @xrange, $y->[0] if between($y->[0], $x->[0], $x->[1]);
    push @xrange, $y->[1] if between($y->[1], $x->[0], $x->[1]);
    push @yrange, $y->[2] if between($y->[2], $x->[2], $x->[3]);
    push @yrange, $y->[3] if between($y->[3], $x->[2], $x->[3]);
    push @zrange, $y->[4] if between($y->[4], $x->[4], $x->[5]);
    push @zrange, $y->[5] if between($y->[5], $x->[4], $x->[5]);

    my @wholly_contained_subsections = ();

    @xrange = sort { $a <=> $b } @xrange;
    @yrange = sort { $a <=> $b } @yrange;
    @zrange = sort { $a <=> $b } @zrange;

    for (my $i = 0; $i < $#xrange; $i++) {
        for (my $j = 0; $j < $#yrange; $j++) {
            for (my $k = 0; $k < $#zrange; $k++) {
                my $sub_cuboid = [
                    $xrange[$i], $xrange[$i + 1],
                    $yrange[$j], $yrange[$j + 1],
                    $zrange[$k], $zrange[$k + 1]
                ];

                if (!wholly_contains($y, $sub_cuboid)) {
                    push @wholly_contained_subsections, $sub_cuboid;
                }
            }
        }
    }

    return @wholly_contained_subsections;
}

sub wholly_contains {
    my ($x, $y) = @_;
    return $x->[0] <= $y->[0] && $x->[1] >= $y->[1] &&
           $x->[2] <= $y->[2] && $x->[3] >= $y->[3] &&
           $x->[4] <= $y->[4] && $x->[5] >= $y->[5];
}

sub intersects {
    my ($x, $y) = @_;
    return $x->[0] <= $y->[1] && $x->[1] >= $y->[0] &&
           $x->[2] <= $y->[3] && $x->[3] >= $y->[2] &&
           $x->[4] <= $y->[5] && $x->[5] >= $y->[4];
}

sub between {
    my ($x, $l, $u) = @_;
    return ($l < $x && $x < $u);
}

