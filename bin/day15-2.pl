#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

use Graph::Dijkstra;

my $width;
my $height = 0;

my @grid = ();
while (<>) {
    chomp;
    my @l = split //;
    $width = 5 * scalar @l if !defined $width;
    push @grid, @l;

    for my $times (1..4) {
        my @new = map { 
            adjust_risk($_, $times)
        } @l;
        push @grid, @new;
    }

    $height++;
}

$height *= 5;
my @cpy = @grid;

for my $times (1..4) {
    my @new = map { adjust_risk($_, $times) } @cpy;
    push @grid, @new;
}

my $graph = Graph::Dijkstra->new( { edgedefault => 'directed' } );

my $end = $height * $width - 1;
$graph->node( { id => $_ } ) for (0..$end); 

for (my $i = 0; $i < scalar @grid; $i++) {
    for my $n (neighbour_from_index($i)) {
        $graph->edge( { sourceID => $i, targetID => $n, weight => $grid[$n] } );
    }
}

my $route = { originID => 0, destinationID => $end };
my $risk  = $graph->shortestPath($route);
say $risk;

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

sub adjust_risk {
    my ($risk, $t) = @_;
    my $n = ($risk + $t);
    return $n > 9 ? $n - 9 : $n;
}

