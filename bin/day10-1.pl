#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

use List::Util qw(sum);

my $map = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137,
};

my $opens = {
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>',
};

my $closes = {
    ')' => '(',
    ']' => '[',
    '}' => '{',
    '>' => '<',
};

my $counts = {};

while (<>) {
    chomp;
    my @stack = ();
    for my $ch (split //, $_) {
        if ($opens->{$ch}) {
            push @stack, $ch;
        } else {
            my $expected = pop @stack;
            if ($expected ne $closes->{$ch}) {
                $counts->{$ch}++;
            }
        }
    }
}

say sum map { $counts->{$_} * $map->{$_} } keys %$counts;
