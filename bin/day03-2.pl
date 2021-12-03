#!/usr/bin/env perl
use strict;
use warnings;

use v5.16;

my $counts = {};
my $len;
my @nums;
while (<>) {
    chomp;
    $len = length if !defined $len;
    push @nums, $_;
}

my @ox = @nums;
my @co = @nums;
for my $i (0..($len - 1)) {
    @ox = filter_modal(\@ox, $i, sub {
        my $counts = shift;
        $counts->{$i}->{'1'} >= $counts->{$i}->{'0'};
    });
    last if scalar @ox == 1;
}

for my $i (0..($len - 1)) {
    @co = filter_modal(\@co, $i, sub {
        my $counts = shift;
        $counts->{$i}->{'1'} < $counts->{$i}->{'0'};
    });
    last if scalar @co == 1;
}

my $o = oct("0b" . (join '', @ox));
my $c = oct("0b" . (join '', @co));

say $o * $c;

sub get_counts {
    my $nums = shift;
    my $counts = {};
    for my $line (@$nums) {
        for my $i (0..($len - 1)) {
            my $ch = substr($line, $i, 1);
            if (!defined $counts->{$i}->{$ch}) {
                $counts->{$i}->{$ch} = 1;
            } else {
                $counts->{$i}->{$ch}++;
            }
        }
    }
    return $counts;
}

sub filter_modal {
    my ($cans, $i, $crit) = @_;
    my $counts = get_counts($cans);
    my $val = $crit->($counts) ? 1 : 0;
    return grep { substr($_, $i, 1) eq $val } @$cans;
}
