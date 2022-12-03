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
my $end = $height * $width - 1;

my @cpy = @grid;
for my $times (1..4) {
    my @new = map { adjust_risk($_, $times) } @cpy;
    push @grid, @new;
}

my $g = Advent::Grid::Dense::Square->new({
    grid => \@grid,
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

sub adjust_risk {
    my ($risk, $t) = @_;
    my $n = ($risk + $t);
    return $n > 9 ? $n - 9 : $n;
}

