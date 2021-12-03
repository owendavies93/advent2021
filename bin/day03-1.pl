#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

my $counts = {};
while (my $line = <>) {
    chomp $line;
    my $len = length $line;

    for my $i (0..($len - 1)) {
        my $ch = substr($line, $i, 1);
        if (!defined $counts->{$i}->{$ch}) {
            $counts->{$i}->{$ch} = 1;
        } else {
            $counts->{$i}->{$ch}++;
        }
    }
}

my $gamma = [];
my $epsilon = [];

foreach my $i (keys %$counts) {
    if ($counts->{$i}->{'1'} > $counts->{$i}->{'0'}) {
        $gamma->[$i] = '1';
        $epsilon->[$i] = '0';
    } else {
        $gamma->[$i] = '0';
        $epsilon->[$i] = '1';
    }
}

my $g = oct("0b" . (join '', @$gamma));
my $e = oct("0b" . (join '', @$epsilon));

say $g * $e;
