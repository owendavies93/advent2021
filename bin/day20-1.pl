#!/usr/bin/env perl
use Mojo::Base -strict;

use lib '../cheatsheet/lib';

use Advent::Grid::Sparse;

my $file = defined $ARGV[0] ? $ARGV[0] : 'inputs/day20';
$file = 'inputs/day20-test' if $file eq 'test';
open(my $fh, '<', $file) or die $!;

my $width;
my $height = 0;

my $g = Advent::Grid::Sparse->new;
my $algo = scalar(<$fh>);
chomp($algo);
my @algo = map { $_ eq '#' ? 1 : 0 } split //, $algo;

while (<$fh>) {
    chomp;
    next if !$_;
    $width = 0;
    for (split //) {
        $g->set($width, $height, $_ eq '#' ? 1 : 0);
        $width++;
    }
    $height++;
}

my $minx = 0;
my $miny = 0;
my $maxx = $width - 1;
my $maxy = $height - 1;

step($_ % 2 == 0) for (1..2);

say $g->count_set();

sub step {
    my $default = shift;
    my $next_g = Advent::Grid::Sparse->new;
    $minx -= 1;
    $maxx += 1;
    $miny -= 1;
    $maxy += 1;

    for my $y ($miny..$maxy) {
        for my $x ($minx..$maxx) {
            my $bi = get_binary_index($x, $y, $default);
            $next_g->inc($x, $y) if $algo[$bi] == $default;
        }
    }
    $g = $next_g;
}

sub get_binary_index {
    my ($x, $y, $default) = @_;

    my $nv = join '', map { $_ // 0 } $g->neighbour_values($x, $y);
    $nv =~ tr/10/01/ if $default;
    return oct('0b' . $nv);
}

