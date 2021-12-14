#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

my $start = scalar(<>);
chomp($start);
my $rules = {};

while (<>) {
    chomp;

    next if !$_;

    my ($from, $to) = split / -> /;
    $rules->{$from} = $to;
}

my $counts = {};
for (my $i = 0; $i < (length $start) - 1; $i++) {
    my $key = substr $start, $i, 2;
    $counts->{$key}++;
}

my $steps = 40;
while ($steps--) {
    my $next = {};

    for my $k (keys %$counts) {
        my ($f, $s) = split '', $k;
        my $v = $counts->{$k};
        my $first = $f . $rules->{$k};
        my $second = $rules->{$k} . $s;
        $next->{$first} += $v;
        $next->{$second} += $v;
    }
    
    $counts = $next;
}

my $unfold = {};
for my $k (keys %$counts) {
    my $v = $counts->{$k};
    my ($first) = substr $k, 0, 1;
    $unfold->{$first} += $v;
}
my $last = substr $start, -1;
$unfold->{$last}++;

my @keys = sort { $a <=> $b } values %$unfold;
say $keys[-1] - $keys[0];
