#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

my @start = split '', scalar (<>);
@start = @start[0..$#start - 1];

my $rules = {};

while (<>) {
    chomp;

    next if !$_;

    my ($from, $to) = split / -> /;
    $rules->{$from} = $to;
}

my $steps = 10;

while ($steps--) {
    my @copy = @start;
    for (my $i = 0; $i < scalar @copy - 1; $i++) {
        my @key = @copy[$i .. ($i+1)];
        my $res = $rules->{join '', @key};

        splice @start, (2 * $i) + 1, 0, $res;
    }
}

my $group = {};
$group->{$_}++ for (@start);

my @keys = sort { $a <=> $b } values %$group;
say $keys[-1] - $keys[0];
