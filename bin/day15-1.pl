#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

use lib '../cheatsheet/lib';

use Advent::Grid::Dense::Square;

use List::PriorityQueue;
use List::Util qw(sum);

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
my $end = $height * $width - 1;

my $g = Advent::Grid::Dense::Square->new({
    grid  => \@grid,
    width => $width,
});

my $edge_list = $g->edge_list();

my $dist = {};
my $prev = {};
my $q = List::PriorityQueue->new();
my @path;

$dist->{0} = 0;
$q->insert(0, 0);

while (1) {
    my $c = $q->pop();
    if ($c == $end) {
        while ($c != 0) {
            my $p = $prev->{$c};
            push @path, $edge_list->{$p}->{$c};
            $c = $p;
        }
        say sum @path;
        exit;
    }

    for my $n (keys %{$edge_list->{$c}}) {
        my $new_dist = $dist->{$c} + $edge_list->{$c}->{$n};
        if (!defined $dist->{$n} || $new_dist < $dist->{$c}) {
            $dist->{$n} = $new_dist;
            $q->insert($n, $new_dist);
            $prev->{$n} = $c;
        }
    }
}

