#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

my $opens       = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' };
my $closes      = { ')' => '(', ']' => '[', '}' => '{', '>' => '<' };
my $comp_scores = { ')' => 1, ']' => 2, '}' => 3, '>' => 4 };

my @scores = ();
while (<>) {
    chomp;

    my @stack = ();
    my $keep = 1;
    for my $ch (split //, $_) {
        if ($opens->{$ch}) {
            push @stack, $ch;
        } else {
            my $expected = pop @stack;
            if ($expected ne $closes->{$ch}) {
                $keep = 0;
                last;
            }
        }
    }

    if ($keep) {
        my $score = 0;
        for my $left (reverse @stack) {
            $score *= 5;
            $score += $comp_scores->{$opens->{$left}};
        }

        push @scores, $score;
    }
}

my $length = scalar @scores;
@scores = sort { $a <=> $b } @scores;
say $scores[$length / 2];

